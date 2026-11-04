# Separate C-enabled UEFI firmware adapter for C-free native FrancOS.
# Run at repo root: make -f stage4/uefi/Makefile esp
CLANG ?= clang
LLD_LINK ?= lld-link
EFI_DIR = stage4/uefi
EFI = $(EFI_DIR)/BOOTX64.EFI
ESP = $(EFI_DIR)/franc-esp.img
.PHONY: all esp clean
all: esp
$(EFI_DIR)/loader.obj: $(EFI_DIR)/loader.c $(EFI_DIR)/uefi.h
	$(CLANG) --target=x86_64-pc-windows-msvc -O2 -ffreestanding -fshort-wchar \
	  -mno-red-zone -fno-stack-protector -fno-builtin \
	  -fno-asynchronous-unwind-tables -Wall -Wextra -Werror -c $< -o $@
$(EFI): $(EFI_DIR)/loader.obj
	$(LLD_LINK) /machine:x64 /subsystem:efi_application /entry:efi_main \
	  /nodefaultlib /out:$@ $<
$(ESP): $(EFI) stage4/native_seed.bin
	truncate -s 64M $@
	mformat -i $@ -F ::
	mmd -i $@ ::/EFI
	mmd -i $@ ::/EFI/BOOT
	mcopy -i $@ $(EFI) ::/EFI/BOOT/BOOTX64.EFI
	mcopy -i $@ stage4/native_seed.bin ::/FRANC.KRN
esp: $(ESP)
clean:
	rm -f $(EFI_DIR)/loader.obj $(EFI) $(ESP)
