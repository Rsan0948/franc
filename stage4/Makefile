AS = as
LD = ld
OBJCOPY = objcopy
.PHONY: all clean verify
all: franos-aot.img verify
kernel.generated.S: compiler.py kernel.frac ../stage2/compiler.frac ../stage3/ata.frac ../stage3/storage.frac display.frac keyboard.frac repl.frac
	python3 compiler.py ../stage3/ata.frac ../stage3/storage.frac display.frac keyboard.frac ../stage2/compiler.frac repl.frac kernel.frac -o $@
program.o: kernel.generated.S
	$(AS) --64 -o $@ $<
runtime.o: runtime.S
	$(AS) --64 -o $@ $<
boot.bin: ../stage1/boot.S
	$(AS) --64 -o boot.o $<
	$(LD) -m elf_x86_64 --oformat binary -Ttext 0x7c00 -o $@ boot.o
font.o: font.S
	$(AS) --64 -o $@ $<
kernel.elf: runtime.o font.o program.o kernel.ld
	$(LD) -m elf_x86_64 -nostdlib -T kernel.ld -o $@ runtime.o font.o program.o
kernel.bin: kernel.elf
	$(OBJCOPY) -O binary -j .text -j .rodata -j .data $< $@
franos-aot.img: boot.bin kernel.bin
	python3 make_image.py $^ $@
verify: franos-aot.img kernel.elf
	python3 verify.py
clean:
	rm -f *.o *.bin *.elf *.img kernel.generated.S
