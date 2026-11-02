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
    if (r.den == 0) printf(r.num == 0 ? "\xe2\x8a\xa5" : "\xe2\x88\x9e");
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
static Rat g_regs[256];
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
HELPER void h_key(void) { int c = getchar(); h_push(c == EOF ? -1 : c,1); }

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
    if (g_line_start + g_pos >= (g_line_start==g_scratch_start?g_exec_size:g_scratch_start)) { fprintf(stderr, "code overflow\n"); exit(1); }
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
    if (g_next_reg>=256) { error("too many registers"); return 0; }
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
    add_word("bye",h_bye);
    add_word("type",h_type); add_word("print",h_type); add_word("key",h_key);
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
    bootstrap();

#ifdef FRANC_EMBED_LIBS
    load_embedded_libraries();
    printf("FrancOS: five math libraries loaded\n");
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
