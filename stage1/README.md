# Stage 1 — FracOS (experimental bare-metal image)

**Current status:** Builds a BIOS disk image, and both **QEMU boot/JIT smoke testing and persistence through an emulated cold reboot pass in GitHub Actions**. QEMU is not installed in this local container; graphical display inspection and real hardware remain unverified.

This stage retains the Stage 0 C compiler/JIT but runs it as a freestanding x86-64 kernel. The disk image includes:

- A 512-byte BIOS boot sector, which loads a fixed 127-sector payload via INT 13h extensions, enables A20, enters protected mode, sets identity-mapped 2 MiB pages, enters 64-bit long mode, and transfers control to the linked kernel at physical address `0x10000`.
- A freestanding C runtime providing Mode 13h 320x200 VGA pixel graphics with an 8x8 raster font (40x25 graphical text cells), COM1 serial input/output (useful under QEMU), a minimal polled PS/2 keyboard, allocation from a fixed heap, a tiny printf subset, string functions, and a fixed executable-memory arena at physical `0x200000`.
- The **same Stage 0 Frac JIT** (`../frac.c`) built with `-Dmain=frac_main` against small freestanding replacement headers. The five Frac math libraries plus three graphical demos are compiled from `../lib/*.frac` into an embedded C string at build time and initialized at boot before entering the REPL. No Linux syscalls are used at runtime. The embedded `lib/*.frac` modules are bundled as text by `embed_libraries.py` and compiled into the live JIT during boot.

## Requirements

Build on an x86-64 Linux host with GCC, GNU as/ld/objcopy, make, and Python 3. For actual boot testing, QEMU `qemu-system-x86_64` must be installed.

```sh
make -C stage1                # raw BIOS image at stage1/fracos.img
python3 stage1/verify_image.py  # static layout checks, not a boot test
make -C stage1 run            # headless QEMU, serial on stdio
make -C stage1 run-gui        # QEMU VGA window plus serial console
python3 stage1/qemu_smoke.py   # requires QEMU, tests the interactive REPL
```

For a graphical VGA console, replace `-display none -serial stdio` with `-display gtk -serial mon:stdio` (depending on installed QEMU display backends). Both PS/2 and COM1 are polled. To exit QEMU when using `-serial stdio`, use another terminal to terminate QEMU; Frac `bye` halts the guest CPU.

## Memory map and limitations

| Physical memory | Use |
| --- | --- |
| `0x7c00` | BIOS boot sector |
| `0x9000–0xbfff` | Long-mode paging tables |
| `0x10000+` | Kernel image, data, and BSS |
| `0x80000` (downward) | Kernel/C/JIT call stack |
| `0x200000–0x41fffff` | 64 MiB JIT executable memory (including scratch area) |
| `0x4800000–0x4ffffff` | 8 MiB bump allocator |

This is deliberately minimal: BIOS boot only (no UEFI path), fixed sector count, fixed memory map requiring 128 MiB RAM, identity-mapped executable pages, minimal PS/2 set-1 scancodes, no interrupts or timer, and no general-purpose filesystem (only a fixed 12-file ATA source store). A real OS would need more; this experiment intentionally doesn't aim to be one yet.

The build generates `stage1/library_bundle.h` from the included libraries. The generated header is not a source of truth; edit the `.frac` files and rebuild instead.

## Mode 13h graphic commands

The 16-bit BIOS loader sets mode `0x13` before switching to protected/long mode.
Framebuffer: `0xA0000`, 320x200 pixels, 8-bit palette indices (0..255).
This is a legacy BIOS/VGA-only experiment, **not UEFI GOP or VESA**.

Commands available in the Frac REPL:

```text
0 clearfb
0 100 319 100 15 line
160 0 160 199 15 line
10 10 80 40 14 fillrect
160 100 pixel@ .
20 fordland
0 clearfb 5 2 14 spiro
```

`pixel` takes `x y color`, `line` takes `x0 y0 x1 y1 color`, `fillrect`
takes `x y width height color`, `palette` takes `index R G B` with 6-bit
DAC channels. `pixel@` returns an 8-bit palette index at that position.

The graphical console shares the framebuffer with plotted output: drawing may
cover old terminal text. COM1 serial remains independent for debugging.
The Linux-hosted REPL emulates the same framebuffer and provides the additional
`screenshot` word to write `franc-frame.ppm`. Frac libraries are loaded at
boot and stored as text in the kernel; no filesystem is required.

**Test boundary:** build-time disk layout and Linux framebuffer tests do not
prove the BIOS image boots. Use `python3 stage1/qemu_smoke.py` when QEMU is
available, and independently inspect the VGA display in graphical QEMU.

## Tiny disk source store (FRANCFS1, experimental)

The BIOS image is now **256 sectors / 128 KiB**. The first 128 sectors are the
512-byte boot block and padded kernel. The remaining 128 sectors are reserved
for a purpose-built, **not FAT/ext**, source store. LBA 128 contains the
`FRANCFS1` magic, LBA 129 contains up to twelve 32-byte directory entries
(name + byte length), and source payloads occupy four sectors apiece starting
at LBA 136 (2047 source bytes plus NUL maximum per file). Source is stored
as raw UTF-8 text and compiled after `load`.

Bare-metal disk I/O uses polling ATA PIO on the primary master, with bounded
status polling. It is intended for QEMU's `if=ide` virtual drive only.
**Do not boot it on real hardware expecting safe persistent writes.** Its ATA
device is not guaranteed to be the BIOS boot device on physical systems.

The QEMU image is preformatted. `save` writes to RAM and disk when the header
is present, `load` falls back to disk if the file is not in RAM, and `files`
shows both. The `disk-format` word explicitly reformats the small source
store, never the OS region. The host build only touches an explicit disk image
provided via `FRANC_DISK_IMAGE`; it does not open real drives.

**Do not rebuild `fracos.img` over a modified image if you want to keep saved
programs.** Rebuilding replaces the preformatted disk with an empty one.
Preserve a copy of the image between builds. QEMU must run against a writable
copy of this image for persistence tests.

The Linux file-backed storage simulation passes across separate processes.
**QEMU ATA-IDE persistence is also validated:** `stage1/qemu_persistence.py`
boots FracOS, saves source, powers off, boots again and executes the saved
word. This does not verify physical USB, SATA, or real-machine drivers.
