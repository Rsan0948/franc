#ifndef FRAC_STDLIB_H
#define FRAC_STDLIB_H
#include <stddef.h>
#include <stdint.h>
void* malloc(size_t size);
void free(void *p);
_Noreturn void exit(int code);
long long strtoll(const char *s,char **end,int base);
#endif
