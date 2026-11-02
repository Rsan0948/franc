#ifndef FRAC_MMAN_H
#define FRAC_MMAN_H
#include <stddef.h>
#define PROT_READ 1
#define PROT_WRITE 2
#define PROT_EXEC 4
#define MAP_PRIVATE 2
#define MAP_ANONYMOUS 32
#define MAP_FAILED ((void*)-1)
void* mmap(void*,size_t,int,int,int,long);
#endif
