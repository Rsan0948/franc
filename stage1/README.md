# Stage 1 — FracOS (experimental bare-metal image)

**Current status:** Builds successfully into a BIOS disk image; **not boot-tested yet** in this environment because QEMU isn't installed here. Do not claim the OS has booted until a QEMU smoke test succeeds.

This stage retains the Stage 0 C compiler/JIT but runs it as a freestanding x86-64 kernel. The disk image includes:

- A 512-byte BIOS boot sector, which loads a fixed 127-sector payload via INT 13h extensions, enables A20, enters protected mode, sets identity-mapped 2 MiB pages, enters 64-bit long mode, and transfers control to the linked kernel at physical address `0x10000`.
- A freestanding C runtime providing VGA text, COM1 serial input/output (useful under QEMU), a minimal polled PS/2 keyboard, allocation from a fixed heap, a tiny printf subset, string functions, and a fixed executable-memory arena at physical `0x200000`.
- The **same Stage 0 Frac JIT** (`../frac.c`) built with `-Dmain=frac_main` against small freestanding replacement headers. The five Frac math libraries are compiled from `../lib/*.frac` into an embedded C string at build time and initialized at boot before entering the REPL. No Linux syscalls are used at runtime. The five `lib/*.frac` modules are bundled as text by `embed_libraries.py` and compiled into the live JIT during boot.

## Requirements

Build on an x86-64 Linux host with GCC, GNU as/ld/objcopy, make, and Python 3. For actual boot testing, QEMU `qemu-system-x86_64` must be installed.

```sh
make -C stage1                # raw BIOS image at stage1/fracos.img
python3 stage1/verify_image.py  # static layout checks, not a boot test
make -C stage1 run            # starts BIOS QEMU, VGA hidden, serial on stdio
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

This is deliberately minimal: BIOS boot only (no UEFI path), fixed sector count, fixed memory map requiring 128 MiB RAM, identity-mapped executable pages, minimal PS/2 set-1 scancodes, no interrupts or timer, no filesystem, and no persistence. A real OS would need more; this experiment intentionally doesn't aim to be one yet.

The build generates `stage1/library_bundle.h` from the five libraries. The generated header is not a source of truth; edit the `.frac` files and rebuild instead.
