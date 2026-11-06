# Separate C-enabled UEFI firmware adapter for C-free native FrancOS.
# Run at repo root: make -f boot/uefi/Makefile esp
CLANG ?= clang
LLD_LINK ?= lld-link
EFI_DIR = boot/uefi
EFI = $(EFI_DIR)/BOOTX64.EFI
ESP = build/out/francos-uefi-esp.img
.PHONY: all esp clean
all: esp
$(EFI_DIR)/loader.obj: $(EFI_DIR)/loader.c $(EFI_DIR)/uefi.h
	$(CLANG) --target=x86_64-pc-windows-msvc -O2 -ffreestanding -fshort-wchar \
	  -mno-red-zone -fno-stack-protector -fno-builtin \
	  -fno-asynchronous-unwind-tables -Wall -Wextra -Werror -c $< -o $@
$(EFI): $(EFI_DIR)/loader.obj
	$(LLD_LINK) /machine:x64 /subsystem:efi_application /entry:efi_main \
	  /nodefaultlib /out:$@ $<
build/out/kernel.bin:
	$(MAKE) -f build/Makefile.native bios
$(ESP): $(EFI) build/out/kernel.bin
	truncate -s 64M $@
	mformat -i $@ -F ::
	mmd -i $@ ::/EFI
	mmd -i $@ ::/EFI/BOOT
	mcopy -i $@ $(EFI) ::/EFI/BOOT/BOOTX64.EFI
	mcopy -i $@ build/out/kernel.bin ::/FRANC.KRN
esp: $(ESP)
clean:
	rm -f $(EFI_DIR)/loader.obj $(EFI) $(ESP)
