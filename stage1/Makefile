CC = gcc
AS = as
LD = ld
OBJCOPY = objcopy
CFLAGS = -std=gnu11 -O2 -Wall -Wextra -ffreestanding -fno-stack-protector -fno-pic -fno-pie -fno-builtin -mno-red-zone -mcmodel=large -DFRANC_BARE_METAL -Iinclude
LDFLAGS = -nostdlib -no-pie -Wl,--build-id=none -Wl,-T,kernel.ld
.PHONY: all clean run run-gui
all: fracos.img
boot.bin: boot.S
	$(AS) --64 -o boot.o boot.S
	$(LD) -m elf_x86_64 --oformat binary -Ttext 0x7c00 -o $@ boot.o
entry.o: entry.S
	$(AS) --64 -o $@ $<
library_bundle.h: ../lib/fixpt.frac ../lib/cf.frac ../lib/approx.frac ../lib/iv.frac ../lib/trans.frac ../lib/graphics.frac ../lib/ford.frac ../lib/spiro.frac ../lib/calc.frac ../lib/edit.frac ../lib/walk.frac ../lib/dd.frac embed_libraries.py
	python3 embed_libraries.py
frac.o: ../frac.c ../gfx.h library_bundle.h
	$(CC) $(CFLAGS) -Dmain=frac_main -DFRANC_EMBED_LIBS -c -o $@ $<
gfx.o: ../gfx.c ../gfx.h ../font8x8.h
	$(CC) $(CFLAGS) -c -o $@ $<
runtime.o: runtime.c ../gfx.h
	$(CC) $(CFLAGS) -c -o $@ $<
kernel.elf: entry.o frac.o runtime.o gfx.o kernel.ld
	$(CC) $(LDFLAGS) -o $@ entry.o frac.o runtime.o gfx.o -lgcc
kernel.bin: kernel.elf
	$(OBJCOPY) -O binary $< $@
	@test $$(stat -c%s $@) -le 65024 || (echo 'kernel exceeds 127-sector BIOS loader capacity' >&2; exit 1)
fracos.img: boot.bin kernel.bin
	@python3 -c 'from pathlib import Path; b=Path("boot.bin").read_bytes(); k=Path("kernel.bin").read_bytes(); assert len(b)==512; image=bytearray(b+k+bytes(127*512-len(k))+bytes(128*512)); image[128*512:128*512+8]=b"FRANCFS1"; Path("fracos.img").write_bytes(image)'
run: fracos.img
	qemu-system-x86_64 -m 128M -drive file=fracos.img,format=raw,if=ide -serial stdio -display none -no-reboot
run-gui: fracos.img
	qemu-system-x86_64 -m 128M -drive file=fracos.img,format=raw,if=ide -serial mon:stdio -no-reboot
clean:
	rm -f *.o *.bin *.elf *.img
