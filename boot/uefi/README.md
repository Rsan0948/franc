# FrancOS UEFI boot and graphics

The UEFI adapter boots the Franc/assembly kernel and hands it a validated GOP
framebuffer descriptor. FrancOS then renders text and graphics directly to
the guest framebuffer. QEMU/OVMF acceptance exercises the 1024×768 display,
keyboard navigation, applications, and persistent ATA storage.

The adapter is a separate freestanding C PE32+ application, built with Clang
and LLD. It reads `FRANC.KRN` from a FAT EFI system partition, reserves the
kernel's fixed physical memory, builds identity-mapped startup page tables,
obtains the UEFI memory map, exits Boot Services, and enters the native kernel.
The kernel, compiler, and native runtime use Franc and assembly.

## Build and launch

From the repository root, with GNU binutils, Make, Clang, LLD, and mtools:

```sh
make os-uefi
tools/run_francos.sh uefi
```

The build produces `boot/uefi/BOOTX64.EFI` and
`build/out/francos-uefi-esp.img`, containing `EFI/BOOT/BOOTX64.EFI` and
`FRANC.KRN`. The launcher attaches both the persistent ATA disk and the EFI
system partition. Install QEMU and OVMF to run the guest; the launcher
recognizes standard Linux and Homebrew firmware paths and accepts
`FRANC_OVMF_CODE` and `FRANC_OVMF_VARS` overrides.

## Boot contract

- The raw kernel loads at physical `0x10000`. The loader checks memory
  availability and image size before entering it; constants are in
  [`loader.c`](loader.c).
- The EFI system partition supplies the loader and kernel. The primary
  IDE disk supplies `FRANCFS1` storage and source bundles.
- The GOP descriptor supplies framebuffer address, dimensions, pitch, and
  pixel format to the assembly runtime; the BIOS path uses VGA.
- The firmware memory map supports the Boot Services handoff. FrancOS
  manages its own execution after that transition.

The supported validation target is QEMU/OVMF. See the
[security policy](../../SECURITY.md) for trust boundaries and the
[build guide](../../docs/BUILD_AND_TEST.md) for guest acceptance commands.
