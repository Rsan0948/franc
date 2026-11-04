CC ?= gcc
CFLAGS ?= -std=gnu11 -O2 -Wall -Wextra
.PHONY: all test clean os os-proof os-uefi
all: frac
stage2/compiler_source.h: stage2/compiler.frac stage3/shell.frac stage3/drivers.frac stage3/ata.frac stage3/storage.frac stage3/display.frac stage3/console.frac stage2/gen_compiler_header.py
	python3 stage2/gen_compiler_header.py
frac: frac.c gfx.c gfx.h font8x8.h stage2/compiler_source.h
	$(CC) $(CFLAGS) -o $@ frac.c gfx.c
test: frac
	python3 tests/test_frac.py
	python3 tests/test_libraries.py
	python3 tests/test_libs.py
	python3 tests/test_stage2.py
	python3 tests/test_stage3_shell.py
	python3 tests/test_stage3_drivers.py
	python3 tests/test_stage3_storage_display.py
	python3 tests/test_graphics.py
	python3 tests/test_apps.py
	python3 tests/test_dd.py
	python3 tests/test_persistence.py
	python3 tests/test_qemu_visual.py
	bash tests/arith/run_hosted.sh ./frac
clean:
	rm -f frac frac-original

# Standard-layout FrancOS (native Franc + assembly, independent of historical stages)
os:
	$(MAKE) -f build/Makefile.native bios
os-proof:
	$(MAKE) -f build/Makefile.native os-proof
os-uefi:
	$(MAKE) -f build/Makefile.native uefi
