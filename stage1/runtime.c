/* FracOS Stage 1: tiny freestanding console, keyboard, heap and libc shim.
   No POSIX system calls or Linux services are used at runtime. */
#include <stdint.h>
#include <stddef.h>
#include <stdarg.h>
#include <limits.h>
#include "../gfx.h"
#include "include/stdio.h"
#include "include/stdlib.h"
#include "include/string.h"
#include "include/ctype.h"
#include "include/errno.h"
#include "include/sys/mman.h"

int errno;
static FILE in_file={0},out_file={1},err_file={2};
FILE *stdin=&in_file,*stdout=&out_file,*stderr=&err_file;
static inline void outb(uint16_t p,uint8_t v){ __asm__ volatile("outb %0,%1"::"a"(v),"Nd"(p)); }
static inline uint8_t inb(uint16_t p){uint8_t v;__asm__ volatile("inb %1,%0":"=a"(v):"Nd"(p));return v;}
/* Mode 13h: 320x200x8; glyphs render into the pixel framebuffer. */
static unsigned row,col;
static int serial_ok;
static void serial_init(void){
    outb(0x3f9,0);outb(0x3fb,0x80);outb(0x3f8,1);outb(0x3f9,0);
    outb(0x3fb,3);outb(0x3fa,0xc7);outb(0x3fc,0x0b);
    serial_ok=1;
}
static void screen_scroll(void){
    if(row<25)return;
    gfx_scroll_up(8,0);
    row=24;
}
static void console_raw(int ch){
    if(serial_ok){
        if(ch=='\n'){while(!(inb(0x3fd)&0x20)){} outb(0x3f8,'\r');}
        while(!(inb(0x3fd)&0x20)){} outb(0x3f8,(uint8_t)ch);
    }
    if(ch=='\n'){col=0;row++;screen_scroll();return;}
    if(ch=='\r'){col=0;return;}
    if(ch=='\b'){
        if(col){col--;gfx_glyph(' ',(int)col*8,(int)row*8,15,0);}
        return;
    }
    if(ch=='\t'){do{console_raw(' ');}while(col%4);return;}
    if(ch<32||ch>126)ch='?';
    gfx_glyph((uint8_t)ch,(int)col*8,(int)row*8,15,0);
    if(++col==40){col=0;row++;screen_scroll();}
}
int putchar(int ch){console_raw(ch);return ch;}
int fputs(const char *s,FILE* f){(void)f;while(*s)putchar((unsigned char)*s++);return 0;}
int fflush(FILE* f){(void)f;return 0;}
void perror(const char *s){fputs(s,stderr);fputs(": error\n",stderr);}

static const char scancode_us[] = {
  0,27,'1','2','3','4','5','6','7','8','9','0','-','=',8,'\t',
  'q','w','e','r','t','y','u','i','o','p','[',']','\n',0,'a','s',
  'd','f','g','h','j','k','l',';', '\'', '`',0,'\\','z','x','c','v',
  'b','n','m',',','.','/',0,'*',0,' ',0
};
static const char scancode_shift[] = {
  0,27,'!','@','#','$','%','^','&','*','(',')','_','+',8,'\t',
  'Q','W','E','R','T','Y','U','I','O','P','{','}','\n',0,'A','S',
  'D','F','G','H','J','K','L',':','"','~',0,'|','Z','X','C','V',
  'B','N','M','<','>','?',0,'*',0,' ',0
};
static int shift_down;
static int keyboard_char(void){
    if(!(inb(0x64)&1))return -1;
    uint8_t code=inb(0x60);
    if(code==0x2a||code==0x36){shift_down=1;return -1;}
    if(code==0xaa||code==0xb6){shift_down=0;return -1;}
    if(code&0x80 || code>=sizeof(scancode_us))return -1;
    return shift_down?(unsigned char)scancode_shift[code]:(unsigned char)scancode_us[code];
}
int getchar(void){
    for(;;){
        if(serial_ok&&(inb(0x3fd)&1))return (int)inb(0x3f8);
        int c=keyboard_char();if(c>0)return c;
        __asm__ volatile("pause");
    }
}
char* fgets(char *s,int max,FILE* f){
    (void)f;
    if(max<=1)return 0;
    int n=0;
    while(n<max-1){
        int ch=getchar();
        if(ch=='\r')ch='\n';
        if(ch=='\b'||ch==127){if(n){n--;putchar('\b');}continue;}
        if(ch==27)continue;
        if(ch<' '&&ch!='\n'&&ch!='\t')continue;
        s[n++]=(char)ch;putchar(ch);
        if(ch=='\n')break;
    }
    s[n]=0;
    return s;
}

struct sink{ char *dst;size_t cap,used; };
static void out_char(struct sink *s,char c){
    if(s->dst){if(s->cap&&s->used<s->cap-1)s->dst[s->used]=c;}
    else putchar((unsigned char)c);
    s->used++;
}
static void out_string(struct sink*s,const char *p,int max){
    if(!p)p="(null)";
    while(*p&&max--!=0)out_char(s,*p++);
}
static void out_uint(struct sink*s,uint64_t v){
    char b[32];int i=0;
    do{b[i++]=(char)('0'+v%10);v/=10;}while(v);
    while(i)out_char(s,b[--i]);
}
static int vfmt(struct sink*s,const char*fmt,va_list ap){
    while(*fmt){
        if(*fmt!='%'){out_char(s,*fmt++);continue;}
        ++fmt;
        if(*fmt=='%'){out_char(s,'%');fmt++;continue;}
        int precision=-1;
        if(*fmt=='.'){
            precision=0;fmt++;
            while(*fmt>='0'&&*fmt<='9'){precision=precision*10+(*fmt++-'0');}
        }
        int len=0;
        while(*fmt=='l'){len++;fmt++;}
        switch(*fmt){
            case 's': out_string(s,va_arg(ap,const char*),precision);break;
            case 'd':case 'i':{
                int64_t v=len?va_arg(ap,long long):va_arg(ap,int);
                if(v<0){out_char(s,'-');out_uint(s,(uint64_t)(-(v+1))+1);}else out_uint(s,(uint64_t)v);
                break;
            }
            case 'u':{
                uint64_t v=len?va_arg(ap,unsigned long long):va_arg(ap,unsigned);
                out_uint(s,v);break;
            }
            case 'c':out_char(s,(char)va_arg(ap,int));break;
            default:out_char(s,'?');break;
        }
        if(*fmt)fmt++;
    }
    if(s->dst&&s->cap)s->dst[s->used<s->cap?s->used:s->cap-1]=0;
    return (int)s->used;
}
int printf(const char* fmt,...){va_list ap;va_start(ap,fmt);struct sink s={0};int r=vfmt(&s,fmt,ap);va_end(ap);return r;}
int fprintf(FILE* f,const char*fmt,...){(void)f;va_list ap;va_start(ap,fmt);struct sink s={0};int r=vfmt(&s,fmt,ap);va_end(ap);return r;}
int snprintf(char*dst,size_t n,const char*fmt,...){va_list ap;va_start(ap,fmt);struct sink s={dst,n,0};int r=vfmt(&s,fmt,ap);va_end(ap);return r;}

size_t strlen(const char*s){size_t n=0;while(s[n])n++;return n;}
int strcmp(const char*a,const char*b){while(*a&&*a==*b){a++;b++;}return (unsigned char)*a-(unsigned char)*b;}
char* strncpy(char*d,const char*s,size_t n){size_t i=0;while(i<n&&s[i]){d[i]=s[i];i++;}while(i<n)d[i++]=0;return d;}
void* memcpy(void*d,const void*s,size_t n){uint8_t*dd=d;const uint8_t*ss=s;for(size_t i=0;i<n;i++)dd[i]=ss[i];return d;}
void* memset(void*d,int c,size_t n){uint8_t*p=d;for(size_t i=0;i<n;i++)p[i]=(uint8_t)c;return d;}
int isspace(int c){return c==' '||c=='\n'||c=='\r'||c=='\t'||c=='\v'||c=='\f';}
long long strtoll(const char*p,char**end,int base){
    const char*start=p;while(isspace(*p))p++;
    int neg=0;if(*p=='-'||*p=='+'){neg=*p=='-';p++;}
    if(!base)base=10;
    uint64_t v=0,limit=neg?(uint64_t)INT64_MAX+1:(uint64_t)INT64_MAX;
    int digits=0,overflow=0;
    for(;;p++){
        int c=(unsigned char)*p,d;
        if(c>='0'&&c<='9')d=c-'0';
        else if(c>='a'&&c<='z')d=c-'a'+10;
        else if(c>='A'&&c<='Z')d=c-'A'+10;
        else break;
        if(d>=base)break;
        if(v>(limit-(uint64_t)d)/(unsigned)base)overflow=1;
        if(!overflow)v=v*(unsigned)base+(unsigned)d;
        digits++;
    }
    if(end)*end=(char*)(digits?p:start);
    if(overflow){errno=ERANGE;return neg?INT64_MIN:INT64_MAX;}
    if(neg)return v==(uint64_t)INT64_MAX+1?INT64_MIN:-(long long)v;
    return (long long)v;
}
static uintptr_t heap_next=0x4800000;
void* malloc(size_t n){
    heap_next=(heap_next+15)&~(uintptr_t)15;
    if(n>8*1024*1024 || heap_next+n>0x5000000)return 0;
    void*p=(void*)heap_next;heap_next+=n;return p;
}
void free(void*p){(void)p;/* bump allocator: reclaimed on reboot */}
void* mmap(void*hint,size_t len,int prot,int flags,int fd,long off){
    (void)hint;(void)prot;(void)flags;(void)fd;(void)off;
    return len<=64*1024*1024?(void*)0x200000:MAP_FAILED;
}
_Noreturn void exit(int status){
    (void)status;fputs("\nFracOS halted.\n",stdout);
    for(;;)__asm__ volatile("cli; hlt");
}
extern int frac_main(void);
void kernel_main(void){
    serial_init();
    gfx_init();
    row=col=0;
    printf("FracOS Stage 1 | 64-bit bare metal | Frac JIT\n");
    printf("Mode 13h 320x200 | COM1 serial\n\n");
    (void)frac_main();
    exit(0);
}
