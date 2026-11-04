#ifndef FRAC_STRING_H
#define FRAC_STRING_H
#include <stddef.h>
size_t strlen(const char *s);
int strcmp(const char *a,const char *b);
char* strncpy(char *dest,const char *src,size_t n);
void* memcpy(void *dst,const void *src,size_t n);
void* memset(void *dst,int ch,size_t n);
#endif
