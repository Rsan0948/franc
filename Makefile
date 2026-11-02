CC ?= gcc
CFLAGS ?= -std=gnu11 -O2 -Wall -Wextra
.PHONY: all test clean
all: frac
stage2/compiler_source.h: stage2/compiler.frac stage3/shell.frac stage2/gen_compiler_header.py
	python3 stage2/gen_compiler_header.py
frac: frac.c gfx.c gfx.h font8x8.h stage2/compiler_source.h
	$(CC) $(CFLAGS) -o $@ frac.c gfx.c
test: frac
	python3 tests/test_frac.py
	python3 tests/test_libraries.py
	python3 tests/test_libs.py
	python3 tests/test_stage2.py
	python3 tests/test_stage3_shell.py
	python3 tests/test_graphics.py
	python3 tests/test_apps.py
	python3 tests/test_dd.py
	python3 tests/test_persistence.py
clean:
	rm -f frac frac-original
