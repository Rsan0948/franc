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

typedef struct { int64_t num, den; } Rat;   // den==0: num==0→⊥, else ∞

// ─── wheel arithmetic ────────────────────────────────────────────────
static int64_t igcd(int64_t a, int64_t b) {
    if (a < 0) a = -a;
    if (b < 0) b = -b;
    while (b) { int64_t t = a % b; a = b; b = t; }
    return a;
}
static Rat canon(int64_t n, int64_t d) {
    if (d == 0) return n == 0 ? (Rat){0,0} : (Rat){1,0};
    if (n == 0) return (Rat){0,1};
    int64_t g = igcd(n, d);
    n /= g; d /= g;
    if (d < 0) { n = -n; d = -d; }
    return (Rat){n, d};
}

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
    int64_t num = neg ? -r.num : r.num, den = r.den;
    int64_t whole = num / den, rem = num % den;
    if (neg) putchar('-');
    printf("%lld", (long long)whole);
    if (rem == 0) return;
    putchar('.');
    int64_t rems[1024]; int digs[1024], cnt = 0;
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
        rem *= 10;
        digs[cnt] = (int)(rem / den);
        rem %= den;
        cnt++;
    }
    for (int i = 0; i < cnt; i++) putchar('0' + digs[i]);
}
static void print_base(Rat r, int64_t base) {        // ~ with a second arg
    if (r.den != 1) { printf("(non-integer)"); return; }
    if (base < 2 || base > 36) { printf("(bad base)"); return; }
    int64_t n = r.num; int neg = n < 0; if (neg) n = -n;
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
static Rat g_regs[26];

static int need(int n) {
    if (g_sp - g_stack < n) { fprintf(stderr, "stack underflow\n"); return 0; }
    return 1;
}

// ─── runtime helpers (called from emitted code) ──────────────────────
#define HELPER __attribute__((noinline, used))

HELPER void h_push(int64_t n, int64_t d) { *g_sp++ = canon(n, d); }

HELPER void h_add(void) { if (!need(2)) return; Rat b = *--g_sp; Rat* a = &g_sp[-1]; *a = canon(a->num*b.den + b.num*a->den, a->den*b.den); }
HELPER void h_sub(void) { if (!need(2)) return; Rat b = *--g_sp; Rat* a = &g_sp[-1]; *a = canon(a->num*b.den - b.num*a->den, a->den*b.den); }
HELPER void h_mul(void) { if (!need(2)) return; Rat b = *--g_sp; Rat* a = &g_sp[-1]; *a = canon(a->num*b.num, a->den*b.den); }
HELPER void h_div(void) { if (!need(2)) return; Rat b = *--g_sp; Rat* a = &g_sp[-1]; *a = canon(a->num*b.den, a->den*b.num); }

HELPER void h_drop(void) { if (!need(1)) return; g_sp--; }
HELPER void h_dup(void)  { if (!need(1)) return; g_sp[0] = g_sp[-1]; g_sp++; }
HELPER void h_swap(void) { if (!need(2)) return; Rat t = g_sp[-1]; g_sp[-1] = g_sp[-2]; g_sp[-2] = t; }
HELPER void h_over(void) { if (!need(2)) return; g_sp[0] = g_sp[-2]; g_sp++; }
HELPER void h_rot(void)  { if (!need(3)) return; Rat t = g_sp[-3]; g_sp[-3]=g_sp[-2]; g_sp[-2]=g_sp[-1]; g_sp[-1]=t; }
HELPER void h_nip(void)  { if (!need(2)) return; g_sp[-2] = g_sp[-1]; g_sp--; }
HELPER void h_tuck(void) { if (!need(2)) return; Rat t = g_sp[-1]; g_sp[-1]=g_sp[-2]; g_sp[-2]=t; g_sp[0]=t; g_sp++; }
HELPER void h_pick(void) { if (!need(1)) return; int64_t n = (--g_sp)->num; g_sp[0] = g_sp[-n-1]; g_sp++; }
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
            int64_t m = a->num % b.num;
            if (m != 0 && ((m < 0) != (b.num < 0))) m += b.num;
            *a = (Rat){m, 1};
        } else *a = (Rat){0, 0};
    } else { if (!need(1)) return; Rat* a = &g_sp[-1]; *a = canon(a->num, a->den * 100); }
}

HELPER void h_abs(void) { if (!need(1)) return; Rat* a = &g_sp[-1]; if (a->num < 0) a->num = -a->num; }
HELPER void h_neg(void) { if (!need(1)) return; Rat* a = &g_sp[-1]; a->num = -a->num; }
HELPER void h_inv(void) { if (!need(1)) return; Rat* a = &g_sp[-1]; *a = canon(a->den, a->num); }

HELPER void h_pow(void) {
    if (!need(2)) return;
    Rat b = *--g_sp; Rat* a = &g_sp[-1];
    if (b.den != 1) { *a = (Rat){0,0}; return; }
    int64_t e = b.num; int neg_exp = e < 0; if (neg_exp) e = -e;
    Rat base = *a; Rat result = {1, 1};
    for (int64_t i = 0; i < e; i++) result = canon(result.num * base.num, result.den * base.den);
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

HELPER void h_fetch(void) { if (!need(1)) return; Rat* a = &g_sp[-1]; int64_t v = *(int64_t*)a->num; a->num = v; a->den = 1; }
HELPER void h_store(void) { if (!need(2)) return; Rat a = *--g_sp; Rat v = *--g_sp; *(int64_t*)a.num = v.num; }
HELPER void h_push_reg(int64_t i) { *g_sp++ = g_regs[i]; }
HELPER void h_store_reg(int64_t i) { if (!need(1)) return; g_regs[i] = *--g_sp; }
HELPER void h_bye(void) { exit(0); }

// ─── dictionary ──────────────────────────────────────────────────────
typedef struct Word { char name[32]; void* addr; struct Word* next; } Word;
static Word* g_dict = NULL;
static Word* add_word(const char* name, void* addr) {
    Word* w = malloc(sizeof(Word));
    strncpy(w->name, name, 31); w->name[31] = 0;
    w->addr = addr; w->next = g_dict; g_dict = w; return w;
}
static Word* lookup(const char* name) {
    for (Word* w = g_dict; w; w = w->next) if (!strcmp(w->name, name)) return w;
    return NULL;
}

// ─── emitter ─────────────────────────────────────────────────────────
static uint8_t* g_exec; static size_t g_exec_size, g_exec_used, g_line_start, g_pos;

static void emit_u8(uint8_t b) {
    if (g_line_start + g_pos >= g_exec_size) { fprintf(stderr, "code overflow\n"); exit(1); }
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

static void emit_ret(void) { emit_u8(0xC3); }
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

typedef struct { size_t line_start, pos; } CState;
static CState cstate_push(void) { return (CState){g_line_start, g_pos}; }
static void   cstate_pop(CState s) { g_line_start = s.line_start; g_pos = s.pos; }

// ─── tokenizer / literal parser ──────────────────────────────────────
static int tokenize(const char* line, char tokens[][64], int max_tok) {
    int n = 0; const char* p = line;
    while (*p && n < max_tok) {
        while (*p && isspace((unsigned char)*p)) p++;
        if (!*p) break;
        int len = 0;
        while (*p && !isspace((unsigned char)*p) && len < 63) tokens[n][len++] = *p++;
        tokens[n][len] = 0; n++;
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
    char* end;
    int64_t num = strtoll(tok, &end, base);
    if (end == tok) return 0;
    tok = end;
    int64_t den = 1;
    if (*tok == '/') {
        tok++; base = 10;
        if (*tok == '$') { base = 16; tok++; }
        else if (*tok == '#') { base = 2; tok++; }
        den = strtoll(tok, &end, base);
        if (end == tok) return 0;
        tok = end;
    } else if (*tok == '.') {
        tok++;
        int64_t frac = 0, scale = 1;
        while (*tok >= '0' && *tok <= '9') { frac = frac*10 + (*tok-'0'); scale *= 10; tok++; }
        num = num*scale + frac; den = scale;
    }
    if (*tok != 0) return 0;
    *out = canon(sign * num, den);
    return 1;
}

// ─── compiler ────────────────────────────────────────────────────────
static void compile_token(char* tok) {
    // immediate words
    if (!strcmp(tok,"if")||!strcmp(tok,"if0")||!strcmp(tok,"ifnz")) {
        emit_call((void*)h_pop_sign);
        emit_test_rax_rax();
        size_t p;
        if      (!strcmp(tok,"if"))   p = emit_jns_ph();   // skip body if not negative
        else if (!strcmp(tok,"if0"))  p = emit_jnz_ph();   // skip body if nonzero
        else                          p = emit_jz_ph();    // skip body if zero
        g_if_stack[g_if_sp++] = (IfState){p, 0, 0};
        return;
    }
    if (!strcmp(tok,"else")) {
        IfState* s = &g_if_stack[g_if_sp-1];
        size_t p = emit_jmp_ph();          // unconditional jump past the else body
        patch_rel32(s->pos_cond, g_pos);   // cond-jump lands at start of else body
        s->pos_else = p; s->has_else = 1;
        return;
    }
    if (!strcmp(tok,"then")) {
        IfState s = g_if_stack[--g_if_sp];
        if (s.has_else) patch_rel32(s.pos_else, g_pos);
        else            patch_rel32(s.pos_cond, g_pos);
        return;
    }
    if (!strcmp(tok,"begin")) { g_begin_stack[g_begin_sp++] = g_pos; return; }
    if (!strcmp(tok,"again")) { emit_jmp_target(g_begin_stack[--g_begin_sp]); return; }
    if (!strcmp(tok,"exit"))  { emit_ret(); return; }

    // literal
    Rat r;
    if (parse_rat(tok, &r)) {
        emit_movabs_rdi(r.num); emit_movabs_rsi(r.den);
        emit_call((void*)h_push);
        return;
    }

    // dictionary word
    Word* w = lookup(tok);
    if (w) { emit_call(w->addr); return; }

    fprintf(stderr, "unknown word: %s\n", tok);
}

static void compile_tokens(char tokens[][64], int ntok) {
    for (int i = 0; i < ntok; i++) {
        char* tok = tokens[i];
        if (!strcmp(tok,"def")) {
            if (++i >= ntok) { fprintf(stderr, "def: missing name\n"); return; }
            char* name = tokens[i];
            CState outer = cstate_push();
            size_t body = g_exec_used;
            g_line_start = body; g_pos = 0;
            add_word(name, g_exec + body);       // register BEFORE body for recursion
            i++;
            while (i < ntok && strcmp(tokens[i], ";") != 0) compile_token(tokens[i++]);
            if (i >= ntok) fprintf(stderr, "def: missing ;\n");
            emit_ret();
            g_exec_used = body + g_pos;
            cstate_pop(outer);
            continue;
        }
        if (!strcmp(tok,";")) { fprintf(stderr, "stray ;\n"); continue; }
        compile_token(tok);
    }
}

// ─── bootstrap ───────────────────────────────────────────────────────
static void bootstrap(void) {
    add_word("+",h_add); add_word("-",h_sub); add_word("*",h_mul); add_word("/",h_div);
    add_word("%",h_mod); add_word("^",h_pow);
    add_word("abs",h_abs); add_word("neg",h_neg); add_word("inv",h_inv);
    add_word("drop",h_drop); add_word("dup",h_dup); add_word("swap",h_swap);
    add_word("over",h_over); add_word("rot",h_rot); add_word("nip",h_nip);
    add_word("tuck",h_tuck); add_word("pick",h_pick);
    add_word("2dup",h_2dup); add_word("2drop",h_2drop);
    add_word(".",h_dot); add_word(".s",h_dots);
    add_word("emit",h_emit); add_word("~",h_tilde);
    add_word("@",h_fetch); add_word("!",h_store);
    add_word("bye",h_bye);

    for (int i = 0; i < 26; i++) {
        CState o = cstate_push();
        size_t s = g_exec_used; g_line_start = s; g_pos = 0;
        emit_movabs_rdi(i); emit_call((void*)h_push_reg); emit_ret();
        g_exec_used = s + g_pos;
        char n1[2] = { (char)('a'+i), 0 }; add_word(n1, g_exec + s);
        cstate_pop(o);

        o = cstate_push();
        s = g_exec_used; g_line_start = s; g_pos = 0;
        emit_movabs_rdi(i); emit_call((void*)h_store_reg); emit_ret();
        g_exec_used = s + g_pos;
        char n2[3] = { ':', (char)('a'+i), 0 }; add_word(n2, g_exec + s);
        cstate_pop(o);
    }
}

// ─── REPL ────────────────────────────────────────────────────────────
int main(void) {
    g_exec_size = 64 * 1024 * 1024;
    g_exec = mmap(NULL, g_exec_size, PROT_READ|PROT_WRITE|PROT_EXEC,
                  MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
    if (g_exec == MAP_FAILED) { perror("mmap"); return 1; }
    g_exec_used = 0;
    bootstrap();

    char line[4096];
    static char tokens[512][64];
    while (1) {
        printf("Frac> "); fflush(stdout);
        if (!fgets(line, sizeof(line), stdin)) break;
        int ntok = tokenize(line, tokens, 512);
        if (ntok == 0) continue;

        g_line_start = g_exec_used; g_pos = 0;
        g_if_sp = 0; g_begin_sp = 0;
        compile_tokens(tokens, ntok);
        emit_ret();

        size_t code_start = g_line_start;
        g_exec_used = g_line_start + g_pos;
        ((void(*)(void))(g_exec + code_start))();

        if (g_sp > g_stack) { print_rat(g_sp[-1]); putchar('\n'); fflush(stdout); }
    }
    return 0;
}
