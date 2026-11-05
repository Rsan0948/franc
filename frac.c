// frac.c — Stage 0 Frac JIT (userspace, x86-64 Linux)
// Build: gcc -O2 -o frac frac.c
// Run:   ./frac
//
// Stage 1 port notes are at the bottom.

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <ctype.h>
#include <sys/mman.h>
#include <errno.h>
#include <limits.h>
#ifndef FRANC_BARE_METAL
#include <sys/select.h>
#include <termios.h>
#include <unistd.h>
#endif
#include "gfx.h"
#include "font8x8.h"
#include "stage2/compiler_source.h"

typedef struct { int64_t num, den; } Rat;   // den==0: num==0→⊥, else ∞

// ─── wheel arithmetic ────────────────────────────────────────────────
// Bounded wheel: intermediate arithmetic uses 128 bits. Results too large
// to represent in Rat resolve to bottom instead of invoking signed-overflow UB.
static __uint128_t ugcd(__uint128_t a, __uint128_t b) {
    while (b) { __uint128_t r=a%b; a=b; b=r; }
    return a;
}
static __uint128_t magnitude(__int128 x) { return x<0 ? (__uint128_t)(-(x+1))+1 : (__uint128_t)x; }
static Rat canon128(__int128 n, __int128 d) {
    if (d==0) return n==0 ? (Rat){0,0} : (Rat){1,0};
    if (n==0) return (Rat){0,1};
    __uint128_t g=ugcd(magnitude(n),magnitude(d));
    n/=(__int128)g; d/=(__int128)g;
    if (d<0) { d=-d; n=-n; }
    if (n<INT64_MIN || n>INT64_MAX || d>INT64_MAX) return (Rat){0,0};
    return (Rat){(int64_t)n,(int64_t)d};
}
static Rat canon(int64_t n, int64_t d) { return canon128(n,d); }

// ─── printing ────────────────────────────────────────────────────────
static void print_rat(Rat r) {
#ifdef FRANC_EMBED_LIBS
    if (r.den == 0) printf(r.num == 0 ? "NaN" : "inf");
#else
    if (r.den == 0) printf(r.num == 0 ? "\xe2\x8a\xa5" : "\xe2\x88\x9e");
#endif
    else if (r.den == 1) printf("%lld", (long long)r.num);
    else printf("%lld/%lld", (long long)r.num, (long long)r.den);
}
static void print_expansion(Rat r) {                 // ~ for a finite rational
    if (r.den == 0) { print_rat(r); return; }
    if (r.num == 0) { printf("0"); return; }
    int neg = r.num < 0;
    uint64_t num=neg ? (uint64_t)(-(r.num+1))+1 : (uint64_t)r.num;
    uint64_t den=(uint64_t)r.den;
    uint64_t whole=num/den, rem=num%den;
    if (neg) putchar('-');
    printf("%llu", (unsigned long long)whole);
    if (rem == 0) return;
    putchar('.');
    uint64_t rems[1024]; int digs[1024], cnt = 0;
    while (rem != 0 && cnt < 1024) {
        int rep = -1;
        for (int i = 0; i < cnt; i++) if (rems[i] == rem) { rep = i; break; }
        if (rep >= 0) {
            for (int i = 0; i < rep; i++) putchar('0' + digs[i]);
            putchar('(');
            for (int i = rep; i < cnt; i++) putchar('0' + digs[i]);
            putchar(')');
            return;
        }
        rems[cnt] = rem;
        __uint128_t scaled = (__uint128_t)rem*10;
        digs[cnt] = (int)(scaled / den);
        rem = (uint64_t)(scaled % den);
        cnt++;
    }
    for (int i = 0; i < cnt; i++) putchar('0' + digs[i]);
}
static void print_base(Rat r, int64_t base) {        // ~ with a second arg
    if (r.den != 1) { printf("(non-integer)"); return; }
    if (base < 2 || base > 36) { printf("(bad base)"); return; }
    int neg=r.num<0; uint64_t n=neg ? (uint64_t)(-(r.num+1))+1 : (uint64_t)r.num;
    char buf[80]; int i = 0;
    if (n == 0) buf[i++] = '0';
    while (n > 0) {
        int d = (int)(n % base);
        buf[i++] = d < 10 ? '0' + d : 'A' + d - 10;
        n /= base;
    }
    if (neg) putchar('-');
    while (i > 0) putchar(buf[--i]);
}

// ─── data stack ──────────────────────────────────────────────────────
static Rat g_stack[1024];
static Rat* g_sp = g_stack;
static uint8_t* g_exec; static size_t g_exec_size, g_exec_used, g_line_start, g_pos;
static const size_t g_scratch_start = 32 * 1024 * 1024;
static int g_compile_error = 0;
static void error(const char* msg) { fprintf(stderr, "%s\n",msg); g_compile_error=1; }
/* Stage 3 driver and source-store modules allocate named global registers. */
#define FRANC_REGISTER_CAP 1024
static Rat g_regs[FRANC_REGISTER_CAP];
static int g_next_reg=26;

static int need(int n) {
    if (g_sp - g_stack < n) { fprintf(stderr, "stack underflow\n"); return 0; }
    return 1;
}

// ─── runtime helpers (called from emitted code) ──────────────────────
#define HELPER __attribute__((noinline, used))

HELPER void h_push(int64_t n, int64_t d) { if (g_sp == g_stack + 1024) { fprintf(stderr,"stack overflow\n"); return; } *g_sp++ = canon(n, d); }
HELPER void h_push_string(int64_t ptr) { h_push(ptr, 1); }
HELPER void h_type(void) { if(!need(1)) return; Rat p = *--g_sp; if (p.den!=1 || !p.num) { fprintf(stderr,"type: invalid string\n"); return; } fputs((const char*)(uintptr_t)p.num,stdout); fflush(stdout); }
// Application memory is byte-addressable; raw @/! remain JIT opcode access.
static uint8_t g_app_memory[256+16*128];
static int g_pending_key=-1;
#ifdef FRANC_BARE_METAL
extern int franc_key_event_poll(void);
extern void franc_console_home(void);
static int platform_key_poll(void) { return franc_key_event_poll(); }
static void app_key_mode(int active) { (void)active; }
#else
static struct termios g_saved_tty;
static int g_raw_keys=0;
static void app_key_mode(int active) {
    if (active && !g_raw_keys && isatty(0) && tcgetattr(0,&g_saved_tty)==0) {
        struct termios raw=g_saved_tty;
        raw.c_lflag &= (tcflag_t)~(ICANON|ECHO);
        raw.c_cc[VMIN]=1; raw.c_cc[VTIME]=0;
        if(tcsetattr(0,TCSANOW,&raw)==0)g_raw_keys=1;
    } else if(!active && g_raw_keys){tcsetattr(0,TCSANOW,&g_saved_tty);g_raw_keys=0;}
}
static int platform_key_poll(void) {
    fd_set set;struct timeval tv={0,0};FD_ZERO(&set);FD_SET(0,&set);
    if(select(1,&set,NULL,NULL,&tv)>0) return getchar();
    return -1;
}
#endif
// Key events: ASCII for printable/Enter/Backspace/Esc; 1001-1004 for arrows.
#ifndef FRANC_BARE_METAL
static int decode_key(int c) {
    if(c!='\033')return c;
#ifdef FRANC_BARE_METAL
    return c;
#else
    // ANSI arrows are ESC [ A/B/C/D; retain a bare Esc as an exit key.
    if(!isatty(0) && feof(stdin))return 27;
    fd_set set;struct timeval tv={0,30000};FD_ZERO(&set);FD_SET(0,&set);
    if(select(1,&set,NULL,NULL,&tv)<=0)return 27;
    int next=getchar();
    if(next!='['){if(next!=EOF)ungetc(next,stdin);return 27;}
    tv.tv_sec=0;tv.tv_usec=30000;FD_ZERO(&set);FD_SET(0,&set);
    if(select(1,&set,NULL,NULL,&tv)<=0)return 27;
    int arrow=getchar();
    return arrow=='A'?1001:arrow=='B'?1002:arrow=='D'?1003:arrow=='C'?1004:27;
#endif
}
#endif
HELPER void h_key(void) {
    int c=g_pending_key;
    if(c>=0)g_pending_key=-1;
#ifdef FRANC_BARE_METAL
    else { do { c=platform_key_poll(); } while(c<0); }
    h_push(c,1);
#else
    else c=decode_key(getchar());
    h_push(c==EOF?-1:c,1);
#endif
}
HELPER void h_keyq(void) {
    if(g_pending_key<0)g_pending_key=platform_key_poll();
    h_push(g_pending_key>=0,1);
}
HELPER void h_breakq(void) {
    if(g_pending_key<0)g_pending_key=platform_key_poll();
    int yes=g_pending_key==27;
    if(yes)g_pending_key=-1;
    h_push(yes,1);
}
HELPER void h_keymode(void) { if(!need(1))return;Rat on=*--g_sp;app_key_mode(on.num!=0); }
/* Stage 3 hardware boundary: these four tiny primitives do not own a driver.
 * The PS/2 and serial protocol/state machines live in stage3/drivers.frac.
 * No user-space in/out instructions: the hosted build deliberately exposes
 * inert ports and routes physical keyboard events through host-key instead. */
HELPER void h_hw_bare(void) { h_push(
#ifdef FRANC_BARE_METAL
    1
#else
    0
#endif
    ,1); }
HELPER void h_bitand(void) {
    if(!need(2))return;
    Rat b=*--g_sp,*a=&g_sp[-1];
    *a=(a->den==1&&b.den==1)?(Rat){a->num&b.num,1}:(Rat){0,0};
}
HELPER void h_io8_read(void) {
    if(!need(1))return;
    Rat port=*--g_sp;
    if(port.den!=1||port.num<0||port.num>65535){h_push(0,1);return;}
#ifdef FRANC_BARE_METAL
    uint8_t v; uint16_t p=(uint16_t)port.num;
    __asm__ volatile("inb %1,%0":"=a"(v):"Nd"(p));
    h_push(v,1);
#else
    h_push(0,1);
#endif
}
HELPER void h_io8_write(void) {
    if(!need(2))return;
    Rat v=*--g_sp,p=*--g_sp;
    if(p.den!=1||p.num<0||p.num>65535||v.den!=1)return;
#ifdef FRANC_BARE_METAL
    uint16_t port=(uint16_t)p.num;
    __asm__ volatile("outb %0,%1"::"a"((uint8_t)v.num),"Nd"(port));
#endif
}
HELPER void h_io16_read(void) {
    if(!need(1))return;
    Rat port=*--g_sp;
    if(port.den!=1||port.num<0||port.num>65535){h_push(0,1);return;}
#ifdef FRANC_BARE_METAL
    uint16_t v,p=(uint16_t)port.num;
    __asm__ volatile("inw %1,%0":"=a"(v):"Nd"(p));
    h_push(v,1);
#else
    h_push(0,1);
#endif
}
/* Franc owns ATA protocol. This is a single raw 16-bit port output. */
HELPER void h_io16_write(void) {
    if(!need(2))return;
    Rat val=*--g_sp,port=*--g_sp;
    if(port.den!=1||port.num<0||port.num>65535||val.den!=1)return;
#ifdef FRANC_BARE_METAL
    uint16_t p=(uint16_t)port.num;
    __asm__ volatile("outw %0,%1"::"a"((uint16_t)val.num),"Nd"(p));
#endif
}
/* Reserved safe DMA-free scratch: stores exactly one ATA sector. */
static uint8_t g_franc_sector_buffer[512];
HELPER void h_sector_buffer(void){h_push((int64_t)(uintptr_t)g_franc_sector_buffer,1);}
HELPER void h_sector_byte_read(void){
    if(!need(1))return;Rat index=*--g_sp;
    if(index.den!=1||index.num<0||index.num>=512){h_push(0,1);return;}
    h_push(g_franc_sector_buffer[index.num],1);
}
HELPER void h_sector_byte_write(void){
    if(!need(2))return;Rat value=*--g_sp,index=*--g_sp;
    if(index.den!=1||index.num<0||index.num>=512||value.den!=1)return;
    g_franc_sector_buffer[index.num]=(uint8_t)value.num;
}



/* Raw byte containers; no allocation, graphics policy or filesystem logic in C.
 * Bounds apply on both Linux and bare metal. The compiler owns the calling code. */
static uint8_t g_franc_source_buffer[2048];
HELPER void h_source_buffer(void){h_push((int64_t)(uintptr_t)g_franc_source_buffer,1);}
HELPER void h_source_byte_store(void){
    if(!need(2))return;Rat value=*--g_sp,index=*--g_sp;
    if(index.den!=1||index.num<0||index.num>=2048||value.den!=1)return;
    g_franc_source_buffer[index.num]=(uint8_t)value.num;
}
HELPER void h_frame_read(void){
    if(!need(1))return;
    Rat offset=*--g_sp;
    if(offset.den!=1||offset.num<0||offset.num>=64000){h_push(0,1);return;}
    h_push(gfx_get((int)(offset.num%320),(int)(offset.num/320)),1);
}
HELPER void h_frame_write(void){
    if(!need(2))return;
    Rat value=*--g_sp,offset=*--g_sp;
    if(offset.den!=1||offset.num<0||offset.num>=64000||value.den!=1)return;
    gfx_pixel((int)(offset.num%320),(int)(offset.num/320),(uint8_t)value.num);
}
HELPER void h_font_row(void){
    if(!need(2))return;
    Rat row=*--g_sp,ch=*--g_sp;
    if(ch.den!=1||row.den!=1||row.num<0||row.num>=8||ch.num<0||ch.num>=128){h_push(0,1);return;}
    h_push(franc_font8x8[(int)ch.num][(int)row.num],1);
}
HELPER void h_depth(void) { h_push((int64_t)(g_sp-g_stack),1); }
HELPER void h_calc_buffer(void) { h_push((int64_t)(uintptr_t)g_app_memory,1); }
HELPER void h_history_buffer(void) { h_push((int64_t)(uintptr_t)(g_app_memory+256),1); }
static int app_memory_range(Rat addr) {
    uintptr_t p=(uintptr_t)addr.num,lo=(uintptr_t)g_app_memory;
    return addr.den==1 && p>=lo && p-lo<sizeof(g_app_memory);
}
HELPER void h_bfetch(void) {
    if(!need(1))return;
    Rat a=*--g_sp;
    if(!app_memory_range(a)){fprintf(stderr,"b@: invalid application address\n");h_push(0,1);return;}
    h_push(*(uint8_t*)(uintptr_t)a.num,1);
}
HELPER void h_bstore(void) {
    if(!need(2))return;
    Rat val=*--g_sp,addr=*--g_sp;
    if(!app_memory_range(addr)||val.den!=1){fprintf(stderr,"b!: invalid application write\n");return;}
    *(uint8_t*)(uintptr_t)addr.num=(uint8_t)val.num;
}
HELPER void h_home(void) {
#ifdef FRANC_BARE_METAL
    franc_console_home();
#else
    fputs("\033[H",stdout);
#endif
}


HELPER void h_add(void) { if (!need(2)) return; Rat b = *--g_sp; Rat* a = &g_sp[-1]; *a = canon128((__int128)a->num*b.den + (__int128)b.num*a->den, (__int128)a->den*b.den); }
HELPER void h_sub(void) { if (!need(2)) return; Rat b = *--g_sp; Rat* a = &g_sp[-1]; *a = canon128((__int128)a->num*b.den - (__int128)b.num*a->den, (__int128)a->den*b.den); }
HELPER void h_mul(void) { if (!need(2)) return; Rat b = *--g_sp; Rat* a = &g_sp[-1]; *a = canon128((__int128)a->num*b.num, (__int128)a->den*b.den); }
HELPER void h_div(void) { if (!need(2)) return; Rat b = *--g_sp; Rat* a = &g_sp[-1]; *a = canon128((__int128)a->num*b.den, (__int128)a->den*b.num); }

HELPER void h_drop(void) { if (!need(1)) return; g_sp--; }
HELPER void h_dup(void)  { if (!need(1)) return; g_sp[0] = g_sp[-1]; g_sp++; }
HELPER void h_swap(void) { if (!need(2)) return; Rat t = g_sp[-1]; g_sp[-1] = g_sp[-2]; g_sp[-2] = t; }
HELPER void h_over(void) { if (!need(2)) return; g_sp[0] = g_sp[-2]; g_sp++; }
HELPER void h_rot(void)  { if (!need(3)) return; Rat t = g_sp[-3]; g_sp[-3]=g_sp[-2]; g_sp[-2]=g_sp[-1]; g_sp[-1]=t; }
HELPER void h_nip(void)  { if (!need(2)) return; g_sp[-2] = g_sp[-1]; g_sp--; }
HELPER void h_tuck(void) { if (!need(2)) return; Rat t = g_sp[-1]; g_sp[-1]=g_sp[-2]; g_sp[-2]=t; g_sp[0]=t; g_sp++; }
HELPER void h_pick(void) { if (!need(1)) return; Rat r = g_sp[-1]; if (r.den!=1 || r.num<0 || r.num>=g_sp-g_stack-1) { fprintf(stderr,"pick: invalid index\n"); return; } --g_sp; g_sp[0] = g_sp[-r.num-1]; g_sp++; }
HELPER void h_2dup(void) { if (!need(2)) return; g_sp[0]=g_sp[-2]; g_sp[1]=g_sp[-1]; g_sp+=2; }
HELPER void h_2drop(void){ if (!need(2)) return; g_sp -= 2; }

HELPER void h_dot(void)  { if (!need(1)) return; print_rat(*--g_sp); putchar('\n'); fflush(stdout); }
HELPER void h_dots(void) { for (Rat* p = g_stack; p < g_sp; p++) { print_rat(*p); putchar(' '); } putchar('\n'); fflush(stdout); }
HELPER void h_emit(void) { if (!need(1)) return; putchar((char)(--g_sp)->num); fflush(stdout); }

// ~ dispatches on arity: 1 arg → decimal expansion; 2 args → base conversion
HELPER void h_tilde(void) {
    if (g_sp - g_stack >= 2) { Rat b = *--g_sp; Rat r = *--g_sp; print_base(r, b.num); }
    else { if (!need(1)) return; print_expansion(*--g_sp); }
    putchar('\n'); fflush(stdout);
}

// % dispatches on arity: 1 arg → percent; 2 args → mod (integers only)
HELPER void h_mod(void) {
    if (g_sp - g_stack >= 2) {
        Rat b = *--g_sp; Rat* a = &g_sp[-1];
        if (a->den == 1 && b.den == 1 && b.num != 0) {
            __int128 m=(__int128)a->num % b.num;
            if (m != 0 && ((m < 0) != (b.num < 0))) m += b.num;
            *a = canon128(m,1);
        } else *a = (Rat){0, 0};
    } else { if (!need(1)) return; Rat* a = &g_sp[-1]; *a = canon128(a->num, (__int128)a->den * 100); }
}

// Rounding toward negative infinity; wheel values pass through unchanged.
HELPER void h_floor(void) {
    if (!need(1)) return;
    Rat* a=&g_sp[-1];
    if (a->den <= 1) return;
    int64_t q=a->num/a->den;
    if (a->num % a->den < 0) --q;
    *a=(Rat){q,1};
}

HELPER void h_abs(void) { if (!need(1)) return; Rat* a = &g_sp[-1]; if (a->num < 0) *a=canon128(-(__int128)a->num,a->den); }
HELPER void h_neg(void) { if (!need(1)) return; Rat* a = &g_sp[-1]; *a=canon128(-(__int128)a->num,a->den); }
HELPER void h_inv(void) { if (!need(1)) return; Rat* a = &g_sp[-1]; *a = canon(a->den, a->num); }

HELPER void h_pow(void) {
    if (!need(2)) return;
    Rat b = *--g_sp; Rat* a = &g_sp[-1];
    if (b.den != 1) { *a = (Rat){0,0}; return; }
    if (b.num==INT64_MIN) { *a=(Rat){0,0}; return; }
    int64_t e = b.num; int neg_exp = e < 0; if (neg_exp) e = -e;
    Rat base=*a, result={1,1};
    while (e) {
        if (e & 1) result=canon128((__int128)result.num*base.num,
                                      (__int128)result.den*base.den);
        e >>= 1;
        if (e) base=canon128((__int128)base.num*base.num,
                             (__int128)base.den*base.den);
    }
    if (neg_exp) result = canon(result.den, result.num);
    *a = result;
}

// pop the top and return its sign: -1, 0, or +1 (∞ counts as +1; ⊥ as 0)
HELPER int64_t h_pop_sign(void) {
    if (!need(1)) return 0;
    Rat r = *--g_sp;
    if (r.den == 0) return r.num == 0 ? 0 : 1;
    if (r.num == 0) return 0;
    return r.num > 0 ? 1 : -1;
}

// Stage-0 byte-addressed code memory. @ reads one opcode byte, ! writes one.
// ! uses (address value --) to match the supplied 'sq $90 ! example.
static int code_address(Rat a) {
    uintptr_t p = (uintptr_t)a.num, lo = (uintptr_t)g_exec;
    return a.den==1 && p>=lo && p-lo<g_exec_size;
}
HELPER void h_fetch(void) {
    if (!need(1)) return;
    Rat* a=&g_sp[-1];
    if (!code_address(*a)) { fprintf(stderr,"@: address outside JIT region\n"); return; }
    *a=(Rat){*(uint8_t*)(uintptr_t)a->num,1};
}
HELPER void h_store(void) {
    if (!need(2)) return;
    Rat v=*--g_sp, a=*--g_sp;
    if (!code_address(a) || v.den!=1) { fprintf(stderr,"!: invalid byte write\n"); return; }
    *(uint8_t*)(uintptr_t)a.num=(uint8_t)v.num;
}
HELPER void h_push_reg(int64_t i) { *g_sp++ = g_regs[i]; }
HELPER void h_store_reg(int64_t i) { if (!need(1)) return; g_regs[i] = *--g_sp; }
/* Display is a shared implementation: VGA Mode 13h on bare metal, RAM on Linux. */
static int graphical_int(Rat r, int *v) {
    if (!r.den) return 0;
    int64_t q = r.num/r.den;
    if (q < INT32_MIN || q > INT32_MAX) return 0;
    *v=(int)q;return 1;
}
HELPER void h_pixel(void) {
    if(!need(3))return;
    Rat c=*--g_sp, y=*--g_sp, x=*--g_sp;
    int ix,iy,ic;
    if(graphical_int(x,&ix)&&graphical_int(y,&iy)&&graphical_int(c,&ic))
        gfx_pixel(ix,iy,(uint8_t)ic);
}
HELPER void h_pixel_fetch(void) {
    if(!need(2))return;
    Rat y=*--g_sp,x=*--g_sp;
    int ix,iy;
    h_push(graphical_int(x,&ix)&&graphical_int(y,&iy)?gfx_get(ix,iy):0,1);
}
HELPER void h_line(void) {
    if(!need(5))return;
    Rat c=*--g_sp,y1=*--g_sp,x1=*--g_sp,y0=*--g_sp,x0=*--g_sp;
    int a,b,d,e,f;
    if(graphical_int(x0,&a)&&graphical_int(y0,&b)&&graphical_int(x1,&d)&&
       graphical_int(y1,&e)&&graphical_int(c,&f))gfx_line(a,b,d,e,(uint8_t)f);
}
HELPER void h_fillrect(void) {
    if(!need(5))return;
    Rat c=*--g_sp,h=*--g_sp,w=*--g_sp,y=*--g_sp,x=*--g_sp;
    int a,b,d,e,f;
    if(graphical_int(x,&a)&&graphical_int(y,&b)&&graphical_int(w,&d)&&
       graphical_int(h,&e)&&graphical_int(c,&f))gfx_fillrect(a,b,d,e,(uint8_t)f);
}
HELPER void h_clearfb(void) {
    if(!need(1))return;
    Rat c=*--g_sp;int v;if(graphical_int(c,&v))gfx_clear((uint8_t)v);
}
HELPER void h_palette(void) {
    if(!need(4))return;
    Rat b=*--g_sp,g=*--g_sp,r=*--g_sp,i=*--g_sp;
    int c,red,green,blue;
    if(graphical_int(i,&c)&&graphical_int(r,&red)&&graphical_int(g,&green)&&
       graphical_int(b,&blue))gfx_palette((uint8_t)c,(uint8_t)red,(uint8_t)green,(uint8_t)blue);
}
#ifndef FRANC_BARE_METAL
HELPER void h_screenshot(void) {
    if(!gfx_save_ppm("franc-frame.ppm"))fprintf(stderr,"screenshot: could not write PPM\n");
}
#endif

HELPER void h_bye(void) { exit(0); }

// ─── dictionary ──────────────────────────────────────────────────────
typedef struct Word { char name[64]; void* addr; int immediate; struct Word* next; } Word;
static Word* g_dict = NULL;
static Word* add_word(const char* name, void* addr) {
    Word* w = malloc(sizeof(Word));
    strncpy(w->name, name, 63); w->name[63] = 0;
    w->addr = addr; w->immediate = 0; w->next = g_dict; g_dict = w; return w;
}
static void add_immediate(const char* name) { add_word(name,NULL)->immediate=1; }
static Word* lookup(const char* name) {
    for (Word* w = g_dict; w; w = w->next) if (!strcmp(w->name, name)) return w;
    return NULL;
}

// ─── emitter ─────────────────────────────────────────────────────────
static void emit_u8(uint8_t b) {
    if (g_line_start + g_pos >= (g_line_start>=g_scratch_start?g_scratch_start+4*1024*1024:g_scratch_start)) { fprintf(stderr, "code overflow\n"); exit(1); }
    g_exec[g_line_start + g_pos++] = b;
}
static void emit_u32(uint32_t v) { for (int i=0;i<4;i++) emit_u8((v>>(8*i))&0xff); }
static void emit_u64(uint64_t v) { for (int i=0;i<8;i++) emit_u8((v>>(8*i))&0xff); }

static void emit_movabs_rdi(int64_t v) { emit_u8(0x48); emit_u8(0xBF); emit_u64(v); }
static void emit_movabs_rsi(int64_t v) { emit_u8(0x48); emit_u8(0xBE); emit_u64(v); }

// movabs rax, fn ; call rax  — distance-independent, safe with any mmap placement
static void emit_call(void* fn) {
    emit_u8(0x48); emit_u8(0xB8); emit_u64((uint64_t)fn);
    emit_u8(0xFF); emit_u8(0xD0);
}

// SysV ABI: at entry rsp%16==8, so align before every helper/word call.
static void emit_prologue(void) { emit_u8(0x48); emit_u8(0x83); emit_u8(0xEC); emit_u8(0x08); }
static void emit_ret(void) { emit_u8(0x48); emit_u8(0x83); emit_u8(0xC4); emit_u8(0x08); emit_u8(0xC3); }
static void emit_test_rax_rax(void) { emit_u8(0x48); emit_u8(0x85); emit_u8(0xC0); }

static size_t emit_jns_ph(void) { emit_u8(0x0F); emit_u8(0x89); size_t p=g_pos; emit_u32(0); return p; }
static size_t emit_jnz_ph(void) { emit_u8(0x0F); emit_u8(0x85); size_t p=g_pos; emit_u32(0); return p; }
static size_t emit_jz_ph(void)  { emit_u8(0x0F); emit_u8(0x84); size_t p=g_pos; emit_u32(0); return p; }
static size_t emit_jmp_ph(void) { emit_u8(0xE9);               size_t p=g_pos; emit_u32(0); return p; }

static void patch_rel32(size_t pos, size_t target) {
    int32_t rel = (int32_t)(target - (pos + 4));
    size_t b = g_line_start + pos;
    g_exec[b+0] = (rel >>  0) & 0xff;
    g_exec[b+1] = (rel >>  8) & 0xff;
    g_exec[b+2] = (rel >> 16) & 0xff;
    g_exec[b+3] = (rel >> 24) & 0xff;
}
static void emit_jmp_target(size_t target) {
    emit_u8(0xE9);
    emit_u32((uint32_t)(int32_t)(target - (g_pos + 4)));
}

// ─── compile state ───────────────────────────────────────────────────
typedef struct { size_t pos_cond, pos_else; int has_else; } IfState;
static IfState g_if_stack[64]; static int g_if_sp = 0;
static size_t  g_begin_stack[64]; static int g_begin_sp = 0;
static size_t g_while_stack[64]; static int g_while_sp=0;

typedef struct { size_t line_start, pos; } CState;
static CState cstate_push(void) { return (CState){g_line_start, g_pos}; }
static void   cstate_pop(CState s) { g_line_start = s.line_start; g_pos = s.pos; }

// Named registers extend the original a..z register convention. They are
// still global (not locals) and compile into the same native getter/setter words.
static int ensure_register(const char* name) {
    if (!*name || strlen(name)>=60) { error("bad register name"); return 0; }
    char store_name[64];
    store_name[0]=':'; strncpy(store_name+1,name,62); store_name[63]=0;
    if (lookup(store_name)) return 1;
    if (g_next_reg>=FRANC_REGISTER_CAP) {
        fprintf(stderr, "too many registers: cap=%d, name=%s\n", FRANC_REGISTER_CAP, name);
        g_compile_error=1; return 0;
    }
    int index=g_next_reg++;
    CState saved=cstate_push();
    size_t start=g_exec_used;
    g_line_start=start;g_pos=0;
    emit_prologue();emit_movabs_rdi(index);emit_call((void*)h_push_reg);emit_ret();
    g_exec_used=start+g_pos;
    add_word(name,g_exec+start);
    start=g_exec_used;g_line_start=start;g_pos=0;
    emit_prologue();emit_movabs_rdi(index);emit_call((void*)h_store_reg);emit_ret();
    g_exec_used=start+g_pos;
    add_word(store_name,g_exec+start);
    cstate_pop(saved);
    return 1;
}

// ─── tokenizer / literal parser ──────────────────────────────────────
static int tokenize(const char* line, char tokens[][256], int max_tok) {
    int n=0; const char* p=line;
    while (*p && n<max_tok) {
        while (isspace((unsigned char)*p)) p++;
        if (!*p) break;
        int len=0;
        if (*p=='"') {
            tokens[n][len++]=*p++;
            while (*p && *p!='"' && len<254) tokens[n][len++]=*p++;
            if (*p=='"') tokens[n][len++]=*p++;
            else { error("unterminated string"); return n; }
        } else {
            while (*p && !isspace((unsigned char)*p) && len<255) tokens[n][len++]=*p++;
        }
        tokens[n][len]=0; n++;
    }
    return n;
}

static int parse_rat(const char* tok, Rat* out) {
    int sign = 1;
    if (*tok == '-') { sign = -1; tok++; }
    else if (*tok == '+') tok++;
    int base = 10;
    if (*tok == '$') { base = 16; tok++; }
    else if (*tok == '#') { base = 2; tok++; }
    else if (tok[0]=='0' && (tok[1]=='x'||tok[1]=='X')) { base=16; tok+=2; }
    char* end; errno=0;
    int64_t num = strtoll(tok, &end, base);
    if (end == tok || errno==ERANGE) return 0;
    tok = end;
    int64_t den = 1;
    if (*tok == '/') {
        tok++; base = 10;
        if (*tok == '$') { base = 16; tok++; }
        else if (*tok == '#') { base = 2; tok++; }
        else if (tok[0]=='0' && (tok[1]=='x'||tok[1]=='X')) { base=16; tok+=2; }
        errno=0; den = strtoll(tok, &end, base);
        if (end == tok || errno==ERANGE) return 0;
        tok = end;
    } else if (*tok == '.') {
        tok++;
        int64_t frac = 0, scale = 1;
        while (*tok >= '0' && *tok <= '9') {
            if (scale>INT64_MAX/10 || frac>INT64_MAX/10) return 0;
            frac=frac*10+(*tok-'0'); scale*=10; tok++;
        }
        if ((__int128)num*scale+frac > INT64_MAX) return 0;
        num = num*scale + frac; den = scale;
    }
    if (*tok != 0) return 0;
    *out = canon(sign * num, den);
    return 1;
}

// ─── compiler ────────────────────────────────────────────────────────
static void compile_token(char* tok) {
    if (tok[0]==':' && tok[1] && !lookup(tok)) {
        if (!ensure_register(tok+1)) return;
    }
    Word* w=lookup(tok); // Dictionary first: even numeric literals and keywords can be shadowed.
    if (w && w->immediate) {
        if (!strcmp(tok,"if")||!strcmp(tok,"if0")||!strcmp(tok,"ifnz")) {
            if (g_if_sp>=64) { error("conditional nesting limit"); return; }
            emit_call((void*)h_pop_sign);
            emit_test_rax_rax();
            size_t p;
            if (!strcmp(tok,"if")) p=emit_jns_ph();
            else if (!strcmp(tok,"if0")) p=emit_jnz_ph();
            else p=emit_jz_ph();
            g_if_stack[g_if_sp++]=(IfState){p,0,0};
        } else if (!strcmp(tok,"else")) {
            if (!g_if_sp || g_if_stack[g_if_sp-1].has_else) { error("else without matching if"); return; }
            IfState* c=&g_if_stack[g_if_sp-1];
            size_t p=emit_jmp_ph(); patch_rel32(c->pos_cond,g_pos);
            c->pos_else=p; c->has_else=1;
        } else if (!strcmp(tok,"then")) {
            if (!g_if_sp) { error("then without matching if"); return; }
            IfState c=g_if_stack[--g_if_sp];
            patch_rel32(c.has_else ? c.pos_else : c.pos_cond,g_pos);
        } else if (!strcmp(tok,"begin")) {
            if (g_begin_sp>=64) { error("begin nesting limit"); return; }
            g_begin_stack[g_begin_sp++]=g_pos;
        } else if (!strcmp(tok,"again")) {
            if (!g_begin_sp) { error("again without begin"); return; }
            emit_jmp_target(g_begin_stack[--g_begin_sp]);
        } else if (!strcmp(tok,"while")) {
            if (!g_begin_sp || g_while_sp>=64) { error("while without begin"); return; }
            emit_call((void*)h_pop_sign);
            emit_test_rax_rax();
            g_while_stack[g_while_sp++]=emit_jns_ph();
        } else if (!strcmp(tok,"repeat")) {
            if (!g_begin_sp || !g_while_sp) { error("repeat without while/begin"); return; }
            size_t loop=g_begin_stack[--g_begin_sp];
            emit_jmp_target(loop);
            patch_rel32(g_while_stack[--g_while_sp],g_pos);
        } else if (!strcmp(tok,"exit")) emit_ret();
        else error("unexpected immediate word");
        return;
    }
    if (w) { emit_call(w->addr); return; }
    if (tok[0]=='\'' && tok[1]) {
        Word* target=lookup(tok+1);
        if (!target || !target->addr) { error("quote: unknown/noncallable word"); return; }
        emit_movabs_rdi((int64_t)(uintptr_t)target->addr);
        emit_movabs_rsi(1); emit_call((void*)h_push); return;
    }
    if (tok[0]=='"') {
        size_t n=strlen(tok);
        if(n<2 || tok[n-1]!='"') { error("malformed string"); return; }
        char* owned=malloc(n-1);
        if(!owned) { error("allocation failure"); return; }
        memcpy(owned,tok+1,n-2); owned[n-2]=0;
        emit_movabs_rdi((int64_t)(uintptr_t)owned);
        emit_call((void*)h_push_string); return;
    }
    Rat r;
    if (parse_rat(tok,&r)) {
        emit_movabs_rdi(r.num); emit_movabs_rsi(r.den);
        emit_call((void*)h_push); return;
    }
    fprintf(stderr,"unknown word: %s\n",tok); g_compile_error=1;
}

static void compile_tokens(char tokens[][256], int ntok) {
    // Reserve native getter/setter slots before emitting any definition body.
    // Otherwise allocating them while a def is being compiled overwrites its code.
    for (int j=0;j<ntok;j++)
        if (tokens[j][0]==':' && tokens[j][1] && !lookup(tokens[j]))
            if (!ensure_register(tokens[j]+1)) return;
    for (int i=0;i<ntok;i++) {
        char* tok=tokens[i];
        Word* w=lookup(tok);
        if (w && w->immediate && !strcmp(tok,"def")) {
            if (++i>=ntok) { error("def: missing name"); return; }
            char* name=tokens[i];
            if (g_exec_used >= g_scratch_start) { error("dictionary code space exhausted"); return; }
            CState outer=cstate_push();
            int old_if=g_if_sp,old_begin=g_begin_sp,old_while=g_while_sp;
            g_line_start=g_exec_used; g_pos=0; g_if_sp=g_begin_sp=g_while_sp=0;
            size_t body=g_exec_used;
            emit_prologue();
            // Pre-register for recursion, and give user definitions dictionary priority.
            Word* defined=add_word(name,g_exec+body);
            int err_at_entry=g_compile_error;
            i++;
            while (i<ntok && strcmp(tokens[i],";")!=0) compile_token(tokens[i++]);
            if (i>=ntok) error("def: missing ;");
            if (g_if_sp || g_begin_sp || g_while_sp) error("def: unclosed control structure");
            emit_ret();
            if (g_compile_error!=err_at_entry) {
                // Roll back a malformed word so future calls cannot enter corrupt code.
                if (g_dict==defined) g_dict=defined->next;
                free(defined);
                g_exec_used=body;
            } else g_exec_used=body+g_pos;
            g_if_sp=old_if;g_begin_sp=old_begin;g_while_sp=old_while; cstate_pop(outer);
            continue;
        }
        if (tok[0]=='\'' && tok[1]==0) {
            if (++i>=ntok) { error("quote: missing name"); return; }
            char buf[256]; snprintf(buf,sizeof(buf),"'%.253s",tokens[i]);
            compile_token(buf); continue;
        }
        if (tok[0]=='\\') break; // source comments until end of line
        if (!strcmp(tok,";")) { error("stray ;"); continue; }
        compile_token(tok);
    }
}

// Stage 2 bootstrap bridge. These primitives expose addresses and memory
// to the Franc-language compiler; tokenization, dictionary search, number
// parsing, and native byte emission live in stage2/compiler.frac.
// The 64 MiB JIT arena dedicates 4 MiB for source token storage and 8 MiB+
// for disjoint Stage 2 output blocks. Stage 1 can compile these same words.
static size_t g_s2_code_offset=32*1024*1024+8*1024*1024;
static int s2_pop_int(int64_t* out) {
    if (!need(1)) return 0;
    Rat r=*--g_sp;
    if (r.den!=1) { fprintf(stderr,"stage2: integer argument required\n"); return 0; }
    *out=r.num; return 1;
}
HELPER void h_s2_byte_fetch(void) {
    int64_t addr;
    if (!s2_pop_int(&addr)) return;
    // This compiler is deliberately low-level; like `type`, a corrupt pointer
    // from a trusted Franc program is not isolated from the host process.
    h_push(*(unsigned char*)(uintptr_t)addr,1);
}
HELPER void h_s2_dict_head(void) { h_push((int64_t)(uintptr_t)g_dict,1); }
HELPER void h_s2_dict_next(void) {
    int64_t p; if (!s2_pop_int(&p)) return;
    h_push(p?(int64_t)(uintptr_t)((Word*)(uintptr_t)p)->next:0,1);
}
HELPER void h_s2_dict_name(void) {
    int64_t p; if (!s2_pop_int(&p)) return;
    h_push(p?(int64_t)(uintptr_t)((Word*)(uintptr_t)p)->name:0,1);
}
HELPER void h_s2_dict_code(void) {
    int64_t p; if (!s2_pop_int(&p)) return;
    h_push(p?(int64_t)(uintptr_t)((Word*)(uintptr_t)p)->addr:0,1);
}
HELPER void h_s2_token_buffer(void) { h_push((int64_t)(uintptr_t)(g_exec+g_scratch_start+4*1024*1024),1); }
HELPER void h_s2_lit_addr(void) { h_push((int64_t)(uintptr_t)h_push,1); }
/* Stage 2 architecture bridge: the *compiler logic* is Franc, while the
 * environment supplies code memory, stable string storage and primitive
 * function addresses. No tokenizer/compiler is implemented by these helpers. */
HELPER void h_s2_sign_addr(void) { h_push((int64_t)(uintptr_t)h_pop_sign,1); }
HELPER void h_s2_string_addr(void) { h_push((int64_t)(uintptr_t)h_push_string,1); }
HELPER void h_s2_self_source(void) { h_push((int64_t)(uintptr_t)franc_stage2_self_source,1); }
HELPER void h_s2_shell_source(void) { h_push((int64_t)(uintptr_t)franc_stage3_shell_source,1); }
HELPER void h_s2_line_buffer(void) { h_push((int64_t)(uintptr_t)(g_exec+g_scratch_start+4*1024*1024+16384),1); }
HELPER void h_s2_control_buffer(void) { h_push((int64_t)(uintptr_t)(g_exec+g_scratch_start+4*1024*1024+8192),1); }
HELPER void h_s2_intern(void) {
    int64_t p;if(!s2_pop_int(&p))return;
    const char *str=(const char*)(uintptr_t)p;
    size_t n=strlen(str);
    if(n>254){h_push(0,1);return;}
    char *dst=malloc(n+1);
    if(!dst){h_push(0,1);return;}
    memcpy(dst,str,n+1);
    h_push((int64_t)(uintptr_t)dst,1);
}

HELPER void h_s2_code_end(void) { h_pop_sign(); }
HELPER void h_s2_no_address(void) { h_push(0,1); }
HELPER void h_s2_code(void) {
    if (g_s2_code_offset+65536>g_exec_size) { fprintf(stderr,"stage2 code arena exhausted\n"); h_push(0,1); return; }
    size_t start=g_s2_code_offset;
    g_s2_code_offset+=65536;
    h_push((int64_t)(uintptr_t)(g_exec+start),1);
}
HELPER void h_s2_define(void) {
    int64_t addr,name;
    if (!s2_pop_int(&addr) || !s2_pop_int(&name)) return;
    if ((uintptr_t)addr<(uintptr_t)(g_exec+g_scratch_start+8*1024*1024) ||
        (uintptr_t)addr>=(uintptr_t)(g_exec+g_s2_code_offset) || !name) {
        fprintf(stderr,"stage2: invalid word registration\n"); return;
    }
    const char *s=(const char*)(uintptr_t)name;
    size_t n=strlen(s);
    if (!n || n>=64) { fprintf(stderr,"stage2: invalid word name\n"); return; }
    add_word(s,(void*)(uintptr_t)addr);
}
HELPER void h_s2_run(void) {
    int64_t addr; if (!s2_pop_int(&addr)) return;
    uintptr_t first=(uintptr_t)(g_exec+g_scratch_start+8*1024*1024);
    uintptr_t last=(uintptr_t)(g_exec+g_s2_code_offset);
    if ((uintptr_t)addr<first || (uintptr_t)addr>=last) {
        fprintf(stderr,"stage2: invalid code address\n"); return;
    }
    ((void(*)(void))(uintptr_t)addr)();
}

// ─── bootstrap ───────────────────────────────────────────────────────
static void bootstrap(void) {
    add_word("+",h_add); add_word("-",h_sub); add_word("*",h_mul); add_word("/",h_div);
    add_word("%",h_mod); add_word("^",h_pow); add_word("pow",h_pow);
    add_word("abs",h_abs); add_word("neg",h_neg); add_word("inv",h_inv);
    add_word("floor",h_floor);
    add_word("drop",h_drop); add_word("dup",h_dup); add_word("swap",h_swap);
    add_word("over",h_over); add_word("rot",h_rot); add_word("nip",h_nip);
    add_word("tuck",h_tuck); add_word("pick",h_pick);
    add_word("2dup",h_2dup); add_word("2drop",h_2drop);
    add_word(".",h_dot); add_word(".s",h_dots);
    add_word("emit",h_emit); add_word("~",h_tilde);
    add_word("@",h_fetch); add_word("!",h_store);
    add_word("pixel",h_pixel);
    add_word("pixel@",h_pixel_fetch);
    add_word("line",h_line);
    add_word("fillrect",h_fillrect);
    add_word("clearfb",h_clearfb);
    add_word("palette",h_palette);
#ifndef FRANC_BARE_METAL
    add_word("screenshot",h_screenshot);
#endif
    add_word("depth",h_depth);
    add_word("b@",h_bfetch); add_word("b!",h_bstore);
    add_word("calc-buffer",h_calc_buffer);add_word("history-buffer",h_history_buffer);
    add_word("key?",h_keyq);add_word("break?",h_breakq);add_word("key-mode",h_keymode);
    add_word("host-key",h_key);add_word("hardware?",h_hw_bare);
    add_word("band",h_bitand);add_word("io8@",h_io8_read);add_word("io8!",h_io8_write);
    add_word("io16@",h_io16_read);add_word("io16!",h_io16_write);add_word("sector-buffer",h_sector_buffer);add_word("sector-byte@",h_sector_byte_read);add_word("sector-byte!",h_sector_byte_write);
    add_word("home",h_home);
    add_word("bye",h_bye);
    add_word("type",h_type); add_word("print",h_type); add_word("key",h_key);
    add_word("byte@",h_s2_byte_fetch);
    add_word("dict-head",h_s2_dict_head);
    add_word("dict-next",h_s2_dict_next);
    add_word("dict-name",h_s2_dict_name);
    add_word("dict-code",h_s2_dict_code);
    add_word("s2-token-buffer",h_s2_token_buffer);
    add_word("s2-lit-addr",h_s2_lit_addr);
    add_word("s2-sign-addr",h_s2_sign_addr);
    add_word("s2-string-addr",h_s2_string_addr);
    add_word("s2-control-buffer",h_s2_control_buffer);
    add_word("s2-line-buffer",h_s2_line_buffer);
    add_word("s2-self-source",h_s2_self_source);
    add_word("s2-shell-source",h_s2_shell_source);
    add_word("s2-intern",h_s2_intern);
    add_word("s2-code",h_s2_code);
    add_word("s2-code-end",h_s2_code_end);
    add_word("s2-var-slot",h_s2_no_address);
    add_word("s2-reg-get-addr",h_s2_no_address);
    add_word("s2-reg-set-addr",h_s2_no_address);
    add_word("s2-run",h_s2_run);
    add_word("s2-define",h_s2_define);

    const char* imm[]={"def","if","if0","ifnz","else","then","begin","again","while","repeat","exit"};
    for (size_t i=0;i<sizeof(imm)/sizeof(*imm);i++) add_immediate(imm[i]);

    for (int i = 0; i < 26; i++) {
        CState o = cstate_push();
        size_t s = g_exec_used; g_line_start = s; g_pos = 0;
        emit_prologue(); emit_movabs_rdi(i); emit_call((void*)h_push_reg); emit_ret();
        g_exec_used = s + g_pos;
        char n1[2] = { (char)('a'+i), 0 }; add_word(n1, g_exec + s);
        cstate_pop(o);

        o = cstate_push();
        s = g_exec_used; g_line_start = s; g_pos = 0;
        emit_prologue(); emit_movabs_rdi(i); emit_call((void*)h_store_reg); emit_ret();
        g_exec_used = s + g_pos;
        char n2[3] = { ':', (char)('a'+i), 0 }; add_word(n2, g_exec + s);
        cstate_pop(o);
    }
}

// Execute a single line. This entry point is shared by the host REPL and
// freestanding embedded-library bootstrap; no filesystem is needed in Stage 1.
static void execute_line(const char* line) {
    static char tokens[512][256];
    int ntok=tokenize(line,tokens,512);
    if (!ntok) return;
    g_line_start=g_scratch_start;g_pos=0;
    g_if_sp=0;g_begin_sp=0;g_while_sp=0;g_compile_error=0;
    emit_prologue();
    compile_tokens(tokens,ntok);
    if (g_if_sp || g_begin_sp || g_while_sp) error("unclosed control structure");
    emit_ret();
    if (!g_compile_error) ((void(*)(void))(g_exec+g_scratch_start))();
}

// Eval compiles into separate scratch pages so an eval invoked from an
// executing REPL line cannot overwrite its caller's machine code.
static int g_eval_nesting;
static void evaluate_source(const char* src) {
    if(!src || g_eval_nesting>=3) {fprintf(stderr,"eval: nesting limit\n");return;}
    CState prev=cstate_push();
    int old_if=g_if_sp,old_begin=g_begin_sp,old_while=g_while_sp;
    int old_err=g_compile_error;
    ++g_eval_nesting;
    char line[4096];
    while(*src) {
        size_t n=0;
        while(*src && *src!='\n' && n+1<sizeof(line))line[n++]=*src++;
        line[n]=0;if(*src=='\n')++src;
        /* Franc compiler definitions exceed 128 tokens. Keep this buffer in
           BSS rather than consuming the tiny bare-metal kernel stack. */
        static char tk[512][256];
        int count=tokenize(line,tk,512);
        if(!count)continue;
        g_line_start=g_scratch_start+(size_t)g_eval_nesting*1024*1024;
        g_pos=0;g_if_sp=g_begin_sp=g_while_sp=0;g_compile_error=0;
        emit_prologue();
        compile_tokens(tk,count);
        if(g_if_sp||g_begin_sp||g_while_sp)error("eval: unbalanced control flow");
        emit_ret();
        if(!g_compile_error)((void(*)(void))(g_exec+g_line_start))();
    }
    --g_eval_nesting;
    cstate_pop(prev);
    g_if_sp=old_if;g_begin_sp=old_begin;g_while_sp=old_while;
    g_compile_error=old_err;
}
HELPER void h_eval(void) {
    if(!need(1))return;
    Rat a=*--g_sp;
    // Accept only app memory or compiler-created quoted strings for eval.
    if(a.den!=1 || a.num==0)return;
    const char* src=(const char*)(uintptr_t)a.num;
    if(app_memory_range(a)) {
        size_t remaining=sizeof(g_app_memory)-((uintptr_t)a.num-(uintptr_t)g_app_memory);
        size_t n=0;while(n<remaining && src[n] && n<4095)n++;
        if(n>=remaining||n>=4095){fprintf(stderr,"eval: unterminated application string\n");return;}
    }
    evaluate_source(src);
}
#include "stage1/disk_store.h"
// RAM store shadows the optional flat disk store (no filesystem).
#define MAX_RAM_FILES 12
#define MAX_RAM_SOURCE 2048
typedef struct { char name[48]; char source[MAX_RAM_SOURCE]; } RamFile;
static RamFile g_ram_files[MAX_RAM_FILES];
static int g_ram_count;
static char g_disk_source[2048];
static const char* locate_source(const char* name) {
    for(int i=0;i<g_ram_count;i++)
        if(strcmp(g_ram_files[i].name,name)==0)return g_ram_files[i].source;
    return franc_disk_load_source(name,g_disk_source)?g_disk_source:NULL;
}
static void h_disk_format(void) {
    if(!franc_disk_format())fprintf(stderr,"disk-format: unavailable/failed\n");
}
static void h_disk_ready(void) {h_push(franc_disk_formatted(),1);}

static RamFile* find_ram_file(const char* name) {
    for(int i=0;i<g_ram_count;i++)if(strcmp(g_ram_files[i].name,name)==0)return &g_ram_files[i];
    return NULL;
}
HELPER void h_save(void) {
    if(!need(2))return;
    Rat src=*--g_sp,name=*--g_sp;
    if(src.den!=1||name.den!=1||!src.num||!name.num)return;
    const char *n=(const char*)(uintptr_t)name.num,*s=(const char*)(uintptr_t)src.num;
    size_t nn=strlen(n),sn=strlen(s);
    if(!nn||nn>=48||sn>=MAX_RAM_SOURCE){fprintf(stderr,"save: file too large\n");return;}
    RamFile* f=find_ram_file(n);
    if(!f){if(g_ram_count==MAX_RAM_FILES){fprintf(stderr,"save: RAM store full\n");return;}f=&g_ram_files[g_ram_count++];}
    memcpy(f->name,n,nn+1);memcpy(f->source,s,sn+1);
    /* Only persist on a deliberately formatted/attached disk. */
    if(franc_disk_formatted() && !franc_disk_save_source(n,s))
        fprintf(stderr,"save: disk write failed (RAM copy retained)\n");
}
HELPER void h_load(void) {
    if(!need(1))return;
    Rat name=*--g_sp;
    if(name.den!=1||!name.num)return;
    const char *src=locate_source((const char*)(uintptr_t)name.num);
    if(!src){fprintf(stderr,"load: source not found\n");return;}
    evaluate_source(src);
}
HELPER void h_source(void) {
    if(!need(1))return;
    Rat name=*--g_sp;
    if(name.den!=1||!name.num){h_push(0,1);return;}
    const char *src=locate_source((const char*)(uintptr_t)name.num);
    h_push(src?(int64_t)(uintptr_t)src:0,1);
}
HELPER void h_copy(void) {
    if(!need(2))return;
    Rat dst=*--g_sp,src=*--g_sp;
    if(dst.den!=1||src.den!=1||!dst.num||!src.num)return;
    const char* d=(const char*)(uintptr_t)dst.num;
    const char* original=locate_source((const char*)(uintptr_t)src.num);
    if(!original){fprintf(stderr,"copy: source not found\n");return;}
    size_t n=strlen(d);
    if(!n||n>=48)return;
    RamFile* target=find_ram_file(d);
    if(!target){if(g_ram_count==MAX_RAM_FILES)return;target=&g_ram_files[g_ram_count++];}
    strncpy(target->name,d,47);target->name[47]=0;
    memcpy(target->source,original,strlen(original)+1);
    if(franc_disk_formatted() && !franc_disk_save_source(d,target->source))
        fprintf(stderr,"copy: disk write failed (RAM copy retained)\n");
}
HELPER void h_files(void) {
    for(int i=0;i<g_ram_count;i++)printf("%s\n",g_ram_files[i].name);
    unsigned char dir[512];
    if(franc_disk_dir(dir))for(int i=0;i<FRANC_FS_SLOTS;i++) {
        const char* name=(const char*)(dir+i*32);
        if(name[0] && !find_ram_file(name))printf("%s\n",name);
    }
}
HELPER void h_run_main(void) {
    Word* w=lookup("main");
    if(!w||!w->addr){fprintf(stderr,"run-main: no main defined\n");return;}
    ((void(*)(void))w->addr)();
}
HELPER void h_launch(void) {
    if(!need(1))return;
    Rat a=*--g_sp;
    if(a.den!=1||!a.num)return;
    const char* src=locate_source((const char*)(uintptr_t)a.num);
    if(!src){fprintf(stderr,"launch: source not found\n");return;}
    /* Do not re-run an unrelated stale 'main' if this file lacks one. */
    Word* old=lookup("main");
    evaluate_source(src);
    Word* current=lookup("main");
    if(current!=old && current && current->addr) ((void(*)(void))current->addr)();
    else fprintf(stderr,"launch: loaded source has no new main\n");
}
#ifdef FRANC_EMBED_LIBS
#include "stage1/library_bundle.h"
static void load_embedded_libraries(void) {
    char line[4096];
    const char *src=franc_library_source;
    while (*src) {
        size_t n=0;
        while (*src && *src!='\n' && n+1<sizeof(line)) line[n++]=*src++;
        line[n]=0;
        if (*src=='\n') ++src;
        execute_line(line);
    }
}
#endif

// ─── REPL ────────────────────────────────────────────────────────────
int main(void) {
    g_exec_size = 64 * 1024 * 1024;
    g_exec = mmap(NULL, g_exec_size, PROT_READ|PROT_WRITE|PROT_EXEC,
                  MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
    if (g_exec == MAP_FAILED) { perror("mmap"); return 1; }
    g_exec_used = 0;
#ifndef FRANC_BARE_METAL
    setvbuf(stdin,NULL,_IONBF,0);
    gfx_init();
#endif
    bootstrap();
    // These words live here because evaluate_source depends on the compiler.
    add_word("source-buffer",h_source_buffer);add_word("source-byte!",h_source_byte_store);
    add_word("frame@",h_frame_read);add_word("frame!",h_frame_write);
    add_word("font-row",h_font_row);add_word("host-emit",h_emit);
    add_word("host-type",h_type);add_word("host-save",h_save);
    add_word("host-source",h_source);add_word("host-files",h_files);
    add_word("eval",h_eval);add_word("save",h_save);
    add_word("load",h_load);add_word("files",h_files);
    add_word("source",h_source);add_word("copy",h_copy);
    add_word("disk-format",h_disk_format);add_word("disk-ready?",h_disk_ready);
    add_word("run-main",h_run_main);add_word("launch",h_launch);

#ifdef FRANC_EMBED_LIBS
#ifdef FRANC_BARE_METAL
    /* First compiler generation, installed before shell words refer to it.
       The Franc os-boot word installs subsequent generations in Franc. */
    evaluate_source(franc_stage2_self_source);
#endif
    load_embedded_libraries();
    printf("FrancOS: math, graphics, and application libraries loaded\n");
#ifdef FRANC_BARE_METAL
    /* Device initialization stays in C; the shell and boot policy are Franc. */
    evaluate_source("os-boot");
#endif
#endif
    char line[4096];
    while (1) {
        printf("Frac> "); fflush(stdout);
        if (!fgets(line, sizeof(line), stdin)) break;
        execute_line(line);
        if (g_sp > g_stack) { print_rat(g_sp[-1]); putchar('\n'); fflush(stdout); }
    }
    return 0;
}
