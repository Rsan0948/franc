/* FrancOS experimental UEFI-to-native-kernel bridge.
 * Only the firmware adapter is C. The kernel and Franc compiler remain
 * assembly/Franc and keep their deterministic C/Python-free bootstrap.
 *
 * Limitations: x86_64 OVMF/QEMU, identity-mapped physical load at 0x10000,
 * serial-only console (native VGA Mode 13h does NOT work through UEFI GOP).
 * The guest needs a separate legacy ATA disk containing FRANCFS1 and bundles.
 */
#include "uefi.h"
static EFI_GUID loaded_image_guid =
    {0x5b1b31a1U,0x9562,0x11d2,{0x8e,0x3f,0x00,0xa0,0xc9,0x69,0x72,0x3b}};
static EFI_GUID simple_fs_guid =
    {0x964e5b22U,0x6459,0x11d2,{0x8e,0x39,0x00,0xa0,0xc9,0x69,0x72,0x3b}};
#define KERNEL_START 0x10000ULL
#define KERNEL_REGION_PAGES 128ULL
#define KERNEL_BINARY_MAX 162816ULL
#define TABLE_PAGES 6ULL
#define MAP_BUFFER_BYTES 32768ULL

static void port_out(U16 port, U8 value) {
    __asm__ __volatile__("outb %0, %1" : : "a"(value), "Nd"(port));
}
static U8 port_in(U16 port) {
    U8 result;
    __asm__ __volatile__("inb %1, %0" : "=a"(result) : "Nd"(port));
    return result;
}
static void serial_init(void) {
    port_out(0x3fb,0x80); port_out(0x3f8,1);
    port_out(0x3f9,0); port_out(0x3fb,3); port_out(0x3fa,0xc7);
}
static void serial_write(const char *s) {
    while (*s) {
        for (U32 i=0; i<100000U; ++i) if (port_in(0x3fd)&0x20U) break;
        port_out(0x3f8,(U8)*s++);
    }
}
static EFI_STATUS fail(EFI_SYSTEM_TABLE *st, const char *serial, CHAR16 *screen) {
    serial_write(serial);
    if (st && st->ConOut) st->ConOut->OutputString(st->ConOut,screen);
    return EFI_ABORTED;
}
static void zero_bytes(void *ptr, UINTN size) {
    volatile U8 *out=(volatile U8 *)ptr;
    while (size--) *out++=0;
}
__attribute__((noreturn))
static void jump_to_kernel(U64 root_pt) {
    /* 4 GiB low identity-map covers the loader while swapping CR3.
     * _kstart resets the stack to 0x80000 and initializes its own serial.
     * BIOS-only graphics remain disabled in UEFI mode.
     */
    __asm__ __volatile__(
        "cli\n\t"
        "movq %0, %%cr3\n\t"
        "movq $0x80000, %%rsp\n\t"
        "xorq %%rbp, %%rbp\n\t"
        "movabsq $0x10000, %%rax\n\t"
        "jmp *%%rax\n\t"
        : : "r"(root_pt) : "rax","memory");
    __builtin_unreachable();
}
EFI_STATUS efi_main(EFI_HANDLE image, EFI_SYSTEM_TABLE *st) {
    if (!st || !st->BootServices) return EFI_ABORTED;
    serial_init();
    serial_write("UEFI FRANC LOADER\r\n");
    EFI_BOOT_SERVICES *bs=st->BootServices;
    EFI_ALLOCATE_PAGES pages=(EFI_ALLOCATE_PAGES)bs->functions[2];
    EFI_GET_MEMORY_MAP get_map=(EFI_GET_MEMORY_MAP)bs->functions[4];
    EFI_ALLOCATE_POOL pool=(EFI_ALLOCATE_POOL)bs->functions[5];
    EFI_HANDLE_PROTOCOL protocol=(EFI_HANDLE_PROTOCOL)bs->functions[16];
    EFI_EXIT_BOOT_SERVICES leave=(EFI_EXIT_BOOT_SERVICES)bs->functions[26];

    EFI_LOADED_IMAGE_PROTOCOL *loaded=0;
    if (EFI_ERROR(protocol(image,&loaded_image_guid,(void **)&loaded)) || !loaded)
        return fail(st,"UEFI LOADED IMAGE ERROR\r\n",L"Franc: LoadedImage unavailable\r\n");
    EFI_SIMPLE_FILE_SYSTEM_PROTOCOL *fs=0;
    if (EFI_ERROR(protocol(loaded->DeviceHandle,&simple_fs_guid,(void **)&fs)) || !fs)
        return fail(st,"UEFI FAT VOLUME ERROR\r\n",L"Franc: FAT volume unavailable\r\n");
    EFI_FILE_PROTOCOL *root=0,*kernel=0;
    if (EFI_ERROR(fs->OpenVolume(fs,&root)) || !root)
        return fail(st,"UEFI OPEN VOLUME ERROR\r\n",L"Franc: cannot open volume\r\n");
    if (EFI_ERROR(root->Open(root,&kernel,L"\\FRANC.KRN",EFI_FILE_MODE_READ,0)) || !kernel)
        return fail(st,"UEFI KERNEL FILE MISSING\r\n",L"Franc: FRANC.KRN missing\r\n");

    /* The BIOS kernel is linked at fixed physical 0x10000. Request this
     * precise region from firmware; never write into unallocated pages.
     */
    EFI_PHYSICAL_ADDRESS load=KERNEL_START;
    if (EFI_ERROR(pages(AllocateAddress,EfiLoaderData,KERNEL_REGION_PAGES,&load))
        || load!=KERNEL_START)
        return fail(st,"UEFI LOW REGION UNAVAILABLE\r\n",L"Franc: low memory unavailable\r\n");
    zero_bytes((void *)(UINTN)load,KERNEL_REGION_PAGES*4096ULL);
    UINTN bytes=KERNEL_BINARY_MAX;
    if (EFI_ERROR(kernel->Read(kernel,&bytes,(void *)(UINTN)load)) || bytes==0)
        return fail(st,"UEFI READ KERNEL FAILED\r\n",L"Franc: kernel read failed\r\n");
    U8 sentinel=0;
    UINTN additional=1;
    if (EFI_ERROR(kernel->Read(kernel,&additional,&sentinel)) || additional!=0)
        return fail(st,"UEFI KERNEL TOO LARGE\r\n",L"Franc: kernel too large\r\n");
    kernel->Close(kernel);
    root->Close(root);
    serial_write("UEFI KERNEL LOADED\r\n");

    /* Build private 0..4GiB identity-mapped page tables with 2MiB pages.
     * Allocated firmware pages are held across ExitBootServices.
     * Upper limit avoids the fixed 96..107MiB Franc app scratch regions.
     */
    EFI_PHYSICAL_ADDRESS tables=0x05000000ULL;
    if (EFI_ERROR(pages(AllocateMaxAddress,EfiLoaderData,TABLE_PAGES,&tables)))
        return fail(st,"UEFI PAGE TABLE ALLOCATION FAILED\r\n",
                    L"Franc: paging allocation failed\r\n");
    zero_bytes((void *)(UINTN)tables,TABLE_PAGES*4096ULL);
    U64 *pml4=(U64 *)(UINTN)tables;
    U64 *pdpt=(U64 *)(UINTN)(tables+0x1000ULL);
    pml4[0]=(tables+0x1000ULL)|3ULL;
    for (U64 n=0;n<4;++n) {
        U64 base=tables+(2ULL+n)*4096ULL;
        pdpt[n]=base|3ULL;
        U64 *pd=(U64 *)(UINTN)base;
        for (U64 page=0;page<512;++page)
            pd[page]=((n*512ULL+page)*0x200000ULL)|0x83ULL;
    }

    /* Firmware memory-map key must be obtained immediately before
     * ExitBootServices. After the first attempt, only GetMemoryMap and
     * ExitBootServices can be used. No pool allocation is allowed here.
     */
    void *map=0;
    if (EFI_ERROR(pool(EfiLoaderData,MAP_BUFFER_BYTES,&map)) || !map)
        return fail(st,"UEFI MAP BUFFER ERROR\r\n",L"Franc: map allocation failed\r\n");
    serial_write("UEFI TRANSFER\r\n");
    EFI_STATUS status=EFI_ABORTED;
    for (U32 attempt=0;attempt<4;++attempt) {
        UINTN length=MAP_BUFFER_BYTES, key=0, desc_size=0;
        U32 version=0;
        status=get_map(&length,map,&key,&desc_size,&version);
        if (status!=EFI_SUCCESS) break;
        status=leave(image,key);
        if (status==EFI_SUCCESS) break;
        if (status!=EFI_INVALID_PARAMETER) break;
    }
    if (status!=EFI_SUCCESS) {
        serial_write("UEFI EXIT BOOT SERVICES FAILED\r\n");
        return status;
    }
    serial_write("UEFI EXIT OK\r\n");
    jump_to_kernel(tables);
}
