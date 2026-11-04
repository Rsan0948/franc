# FrancOS experimental UEFI loader

**C is allowed only in this UEFI firmware adapter.** The FrancOS kernel,
Franc compiler, native JIT and AOT self-hosting remain C-free. Nothing
here replaces the existing BIOS stage4/boot.S or changes its disk image.

The separate PE32+ UEFI application is built freestanding using Clang
and lld-link. It reads FRANC.KRN (the existing Franc-generated native
kernel binary) from a FAT ESP, reserves physical memory at the
kernel's original link address 0x10000, builds a 4GiB identity-mapped
page table, obtains a fresh UEFI memory-map key, exits Boot Services,
and jumps directly to the native kernel entry point. It does not use
libc, UEFI runtime calls from the kernel, or a C-based kernel runtime.

## Build

From repository root, with clang, lld-link, mtools and GNU binutils:

    make -f stage4/Makefile.native native-seed
    make -f stage4/uefi/Makefile esp

This produces stage4/uefi/BOOTX64.EFI and
stage4/uefi/franc-esp.img (FAT32, containing
EFI/BOOT/BOOTX64.EFI and FRANC.KRN).

The OVMF integration workflow also requires QEMU and OVMF. Its
test_boot.py attaches the native disk as the first IDE master and
the separate FAT ESP as a virtio block device; it confirms the
UEFI-to-kernel transition, existing ATA storage, and application load.

## Experimental limitations

- Requires x86-64 UEFI and RAM available at physical 0x10000;
  the loader intentionally refuses to overwrite unallocated low RAM.
- Loads only the known pinned, raw kernel image up to 158720 bytes;
  there is no PE or ELF kernel relocation. The native fixed address
  and the 0x80000 kernel stack remain unchanged.
- Serial output is functional. The original FrancOS framebuffer writes
  VGA Mode 13h at 0xA0000 and is **not compatible with UEFI GOP**.
  No UEFI graphical framebuffer, real-world hardware or USB boot claim.
- Still depends on an IDE primary-master image for FRANCFS1 and source
  bundles. The UEFI FAT ESP is strictly the loader medium.
- The UEFI memory map is used only for ExitBootServices; the kernel
  does not yet parse the firmware map or preserve runtime services.
- A 4GiB identity map is temporary boot scaffolding, **not** user/kernel
  memory isolation or hardened page permission management.
- The loader is a prototype for OVMF/QEMU, **not** tested on physical
  UEFI computers. The separate BIOS bootstrap is unchanged.
