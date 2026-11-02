CC ?= gcc
CFLAGS ?= -std=gnu11 -O2 -Wall -Wextra
.PHONY: all test clean
all: frac
frac: frac.c gfx.c gfx.h font8x8.h
	$(CC) $(CFLAGS) -o $@ frac.c gfx.c
test: frac
	python3 tests/test_frac.py
	python3 tests/test_libraries.py
	python3 tests/test_libs.py
	python3 tests/test_stage2.py
	python3 tests/test_graphics.py
	python3 tests/test_apps.py
clean:
	rm -f frac frac-original
