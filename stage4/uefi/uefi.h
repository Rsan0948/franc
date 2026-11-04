/* Minimal freestanding UEFI x86_64 declarations used by FrancOS.
 * C is confined to the UEFI loader. Firmware entry uses Microsoft x64 ABI.
 * Structure offsets are asserted against the UEFI specification.
 */
#ifndef FRANC_UEFI_H
#define FRANC_UEFI_H
typedef unsigned long long U64;
typedef unsigned int U32;
typedef unsigned short U16;
typedef unsigned char U8;
typedef U64 EFI_STATUS;
typedef void *EFI_HANDLE;
typedef U64 EFI_PHYSICAL_ADDRESS;
typedef U64 UINTN;
typedef U16 CHAR16;
#define EFI_SUCCESS 0ULL
#define EFI_ERROR(s) ((s) >> 63)
#define EFI_INVALID_PARAMETER 0x8000000000000002ULL
#define EFI_BUFFER_TOO_SMALL 0x8000000000000005ULL
#define EFI_ABORTED 0x8000000000000015ULL
#define EFI_FILE_MODE_READ 1ULL
#define AllocateAddress 2U
#define AllocateMaxAddress 1U
#define EfiLoaderData 2U
typedef struct { U32 a; U16 b,c; U8 d[8]; } EFI_GUID;
typedef struct { U64 Signature; U32 Revision, HeaderSize, CRC32, Reserved; } EFI_TABLE_HEADER;
typedef struct EFI_FILE_PROTOCOL EFI_FILE_PROTOCOL;
typedef struct EFI_SIMPLE_FILE_SYSTEM_PROTOCOL EFI_SIMPLE_FILE_SYSTEM_PROTOCOL;
struct EFI_FILE_PROTOCOL {
    U64 Revision;
    EFI_STATUS (*Open)(EFI_FILE_PROTOCOL *, EFI_FILE_PROTOCOL **, CHAR16 *, U64, U64);
    EFI_STATUS (*Close)(EFI_FILE_PROTOCOL *);
    void *Delete;
    EFI_STATUS (*Read)(EFI_FILE_PROTOCOL *, UINTN *, void *);
    void *Write, *GetPosition, *SetPosition, *GetInfo, *SetInfo, *Flush;
};
struct EFI_SIMPLE_FILE_SYSTEM_PROTOCOL {
    U64 Revision;
    EFI_STATUS (*OpenVolume)(EFI_SIMPLE_FILE_SYSTEM_PROTOCOL *, EFI_FILE_PROTOCOL **);
};
typedef struct {
    U32 Revision, Pad0;
    EFI_HANDLE ParentHandle;
    void *SystemTable;
    EFI_HANDLE DeviceHandle;
    void *FilePath, *Reserved;
    U32 LoadOptionsSize, Pad1;
    void *LoadOptions, *ImageBase;
    U64 ImageSize;
    U32 ImageCodeType, ImageDataType;
    void *Unload;
} EFI_LOADED_IMAGE_PROTOCOL;
typedef struct {
    void *Reset;
    EFI_STATUS (*OutputString)(void *, CHAR16 *);
} EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL;
typedef struct { EFI_TABLE_HEADER Hdr; void *functions[48]; } EFI_BOOT_SERVICES;
typedef struct {
    EFI_TABLE_HEADER Hdr;
    CHAR16 *FirmwareVendor;
    U32 FirmwareRevision, Pad0;
    EFI_HANDLE ConsoleInHandle;
    void *ConIn;
    EFI_HANDLE ConsoleOutHandle;
    EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL *ConOut;
    EFI_HANDLE StandardErrorHandle;
    void *StdErr;
    void *RuntimeServices;
    EFI_BOOT_SERVICES *BootServices;
} EFI_SYSTEM_TABLE;
typedef EFI_STATUS (*EFI_ALLOCATE_PAGES)(U32, U32, UINTN, EFI_PHYSICAL_ADDRESS *);
typedef EFI_STATUS (*EFI_GET_MEMORY_MAP)(UINTN *, void *, UINTN *, UINTN *, U32 *);
typedef EFI_STATUS (*EFI_ALLOCATE_POOL)(U32, UINTN, void **);
typedef EFI_STATUS (*EFI_HANDLE_PROTOCOL)(EFI_HANDLE, EFI_GUID *, void **);
typedef EFI_STATUS (*EFI_EXIT_BOOT_SERVICES)(EFI_HANDLE, UINTN);
typedef EFI_STATUS (*EFI_LOCATE_PROTOCOL)(EFI_GUID *, void *, void **);
typedef EFI_STATUS (*EFI_FREE_POOL)(void *);
typedef struct { U32 RedMask, GreenMask, BlueMask, ReservedMask; } EFI_PIXEL_MASKS;
typedef struct {
    U32 Version, HorizontalResolution, VerticalResolution, PixelFormat;
    EFI_PIXEL_MASKS PixelInformation;
    U32 PixelsPerScanLine;
} EFI_GRAPHICS_OUTPUT_MODE_INFORMATION;
typedef struct {
    U32 MaxMode, Mode;
    EFI_GRAPHICS_OUTPUT_MODE_INFORMATION *Info;
    UINTN SizeOfInfo;
    EFI_PHYSICAL_ADDRESS FrameBufferBase;
    UINTN FrameBufferSize;
} EFI_GRAPHICS_OUTPUT_PROTOCOL_MODE;
typedef struct EFI_GRAPHICS_OUTPUT_PROTOCOL EFI_GRAPHICS_OUTPUT_PROTOCOL;
struct EFI_GRAPHICS_OUTPUT_PROTOCOL {
    EFI_STATUS (*QueryMode)(EFI_GRAPHICS_OUTPUT_PROTOCOL *, U32, UINTN *,
                             EFI_GRAPHICS_OUTPUT_MODE_INFORMATION **);
    EFI_STATUS (*SetMode)(EFI_GRAPHICS_OUTPUT_PROTOCOL *, U32);
    void *Blt;
    EFI_GRAPHICS_OUTPUT_PROTOCOL_MODE *Mode;
};

_Static_assert(sizeof(EFI_TABLE_HEADER)==24, "UEFI header size");
_Static_assert(__builtin_offsetof(EFI_SYSTEM_TABLE, BootServices)==96, "UEFI BootServices offset");
_Static_assert(__builtin_offsetof(EFI_LOADED_IMAGE_PROTOCOL, DeviceHandle)==24, "UEFI loaded-image device");
_Static_assert(__builtin_offsetof(EFI_FILE_PROTOCOL, Read)==32, "UEFI file read");
#endif
