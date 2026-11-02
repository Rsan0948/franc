#ifndef FRAC_STDIO_H
#define FRAC_STDIO_H
#include <stddef.h>
#define EOF (-1)
typedef struct { int kind; } FILE;
extern FILE *stdin,*stdout,*stderr;
int putchar(int ch);
int getchar(void);
int printf(const char *fmt, ...);
int fprintf(FILE *file,const char *fmt,...);
int snprintf(char *dst,size_t n,const char *fmt,...);
int fputs(const char *s,FILE *file);
char *fgets(char *str,int size,FILE *file);
int fflush(FILE *file);
void perror(const char *s);
#endif
