AS = as
LD = ld
OBJCOPY = objcopy
.PHONY: all clean verify native-all legacy-all
# Production default is built entirely from Franc-generated assembly seed.
all: native-all
native-all:
	$(MAKE) -C .. -f stage4/Makefile.native native-proof
# Historical Python seed is an explicitly selected compatibility target.
legacy-all: franos-aot.img verify
kernel.generated.S: compiler.py kernel.frac ../stage2/compiler.frac ../stage3/ata.frac ../stage3/storage.frac display.frac keyboard.frac repl.frac upgrade.frac aot.frac bundle.frac
	python3 compiler.py ../stage3/ata.frac ../stage3/storage.frac display.frac keyboard.frac ../stage2/compiler.frac repl.frac upgrade.frac aot.frac bundle.frac apps/registry.frac kernel.frac -o $@
program.o: kernel.generated.S
	$(AS) --64 -o $@ $<
runtime.o: runtime.S gop_console.S ../franctxt/sha256_native.S interrupts.S scheduler.S e820.S ring3.S page_owners.S process_spaces.S user_scheduler.S user_compiled.S
	$(AS) --64 -I .. -o $@ $<
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
# Kernel=1..127, 200..263, 264..390, 391..454; FRANCFS1=128..199.
franos-aot.img: boot.bin kernel.bin
	@test "$(shell wc -c < boot.bin)" -eq 512
	@test "$(shell wc -c < kernel.bin)" -le 195584
	@dd if=/dev/zero of=$@ bs=512 count=512 status=none
	@dd if=boot.bin of=$@ conv=notrunc status=none
	@dd if=kernel.bin of=$@ bs=512 count=127 seek=1 conv=notrunc status=none
	@dd if=kernel.bin of=$@ bs=512 skip=127 count=64 seek=200 conv=notrunc status=none
	@dd if=kernel.bin of=$@ bs=512 skip=191 count=127 seek=264 conv=notrunc status=none
	@dd if=kernel.bin of=$@ bs=512 skip=318 count=64 seek=391 conv=notrunc status=none
	@printf FRANCFS1 | dd of=$@ bs=512 seek=128 conv=notrunc status=none
verify: franos-aot.img kernel.elf
	python3 verify.py
clean:
	rm -f *.o *.bin *.elf *.img kernel.generated.S
