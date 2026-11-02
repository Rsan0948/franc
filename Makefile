CC ?= gcc
CFLAGS ?= -std=gnu11 -O2 -Wall -Wextra
.PHONY: all test clean
all: frac
frac: frac.c
	$(CC) $(CFLAGS) -o $@ $<
test: frac
	python3 tests/test_frac.py
clean:
	rm -f frac frac-original
