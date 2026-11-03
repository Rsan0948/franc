AS = as
LD = ld
OBJCOPY = objcopy
.PHONY: all clean verify seed
# Default production build is now a Franc-to-Franc kernel rebuild.
# The pinned assembler seed is checked in; Python is never called by make.
all: franos-selfhost.img verify
seed: franos-aot.img
kernel.generated.S: seed.generated.S
	cp $< $@
program.o: kernel.generated.S
	$(AS) --64 -o $@ $<
runtime.o: runtime.S
	$(AS) --64 -o $@ $<
boot.bin: boot.S
	$(AS) --64 -o boot.o $<
	$(LD) -m elf_x86_64 --oformat binary -Ttext 0x7c00 -o $@ boot.o
font.o: font.S
	$(AS) --64 -o $@ $<
kernel.elf: runtime.o font.o program.o kernel.ld
	$(LD) -m elf_x86_64 -nostdlib -T kernel.ld -o $@ runtime.o font.o program.o
kernel.bin: kernel.elf
	$(OBJCOPY) -O binary -j .text -j .rodata -j .data $< $@
# GNU binary tools package the 512-sector image; no Python packager.
# Kernel=1..127, 200..255, 256..382; FRANCFS1=128..199.
franos-aot.img: boot.bin kernel.bin
	@test "$(shell wc -c < boot.bin)" -eq 512
	@test "$(shell wc -c < kernel.bin)" -le 158720
	@dd if=/dev/zero of=$@ bs=512 count=512 status=none
	@dd if=boot.bin of=$@ conv=notrunc status=none
	@dd if=kernel.bin of=$@ bs=512 count=127 seek=1 conv=notrunc status=none
	@dd if=kernel.bin of=$@ bs=512 skip=127 count=56 seek=200 conv=notrunc status=none
	@dd if=kernel.bin of=$@ bs=512 skip=183 count=127 seek=256 conv=notrunc status=none
	@printf FRANCFS1 | dd of=$@ bs=512 seek=128 conv=notrunc status=none
# This target invokes only Franc, assembly and standard shell tools.
franos-selfhost.img: franos-aot.img build_selfhost.sh source_pack.sh aot_entry.S aot.frac aot_dict.frac bundle.frac kernel.frac display.frac keyboard.frac repl.frac upgrade.frac ../stage2/compiler.frac ../stage3/ata.frac ../stage3/storage.frac
	sh build_selfhost.sh franos-aot.img $@
verify: franos-selfhost.img
	@test "$(wc -c < franos-selfhost.img)" -eq 262144
	@test "$(wc -c < franos-aot.img)" -eq 262144
	@echo 'PASS: Python-free Franc bootstrap built a full kernel image'

clean:
	rm -f *.o *.bin *.elf *.img kernel.generated.S
