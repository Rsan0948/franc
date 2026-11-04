# The Franc Mathematics Bible
## An implementation-grounded reference to rational arithmetic, exceptional values, and numerical libraries

**Scope:** Franc / Frac and FrancOS, including the historical hosted runtime and the experimental C-free native kernel. This is an engineering and mathematical reference, **not** a claim of a new theorem, a formal proof of wheel axioms, or unlimited precision.

## 1. The thesis: ratios before approximations

A Franc numeric value is represented primarily as a **rational pair (numerator, denominator)** rather than as a binary floating-point number. A finite, valid rational is interpreted as n/d, with a positive denominator and normalization by the greatest common divisor (GCD).

    1/3 1/6 +       \ 1/2
    8/12             \ canonicalized as 2/3
    0.1 0.2 +        \ 3/10 in the hosted runtime

Why it matters: many programming languages encourage programmers to treat approximations as if they were exact numeric values. Fractions are exact **within the representable range**. In Franc, a number does not quietly turn into a binary approximation just because it is expressed as a ratio.

In the hosted implementation, the core representation is a 16-byte pair of signed 64-bit integers. The native operating system uses the same pair shape but has a separate assembly runtime, and it does **not** necessarily implement every hosted syntax feature. Exactness **is not** unlimited size.

## 2. Canonicalization, identity and equality

For ordinary finite values:

- The denominator is positive; the sign is carried in the numerator.
- The GCD is divided out: 6/8 becomes 3/4, and -2/-4 becomes 1/2.
- Finite zero becomes 0/1; a whole number k is represented as k/1.
- Results are computed and then normalized, subject to the underlying bounds.

This gives a useful canonical encoding for representable rationals: two different fraction spellings become the same normalized value.

Mathematically, finite values behave like the field of rational numbers Q **only where operations stay within the representable range**. A machine-bounded implementation is not itself the full mathematical field Q; some sums and products leave the representable domain.

### Hosted versus kernel arithmetic

| Implementation | Representation | Key arithmetic properties |
| --- | --- | --- |
| Hosted Frac (historical frac.c) | Two signed 64-bit integers, 16 bytes | Uses signed 128-bit intermediates for basic operations; canonicalizes results; out-of-range normalized results become bottom |
| Native FrancOS (native assembly runtime) | Same signed-64-bit pair ABI | Implements arithmetic and normalization in x86-64 assembly: a 64-bit fast path, plus an exact 128-bit path for overflow and exceptional operands. Checked inside the OS against the conformance table |
| Optional big-number module | A separate bounded-arena, unsigned base-256 limb object | Does **not** replace the core rational ABI or automatically make every rational arbitrary precision |

## 3. Infinity, bottom, and the wheel-inspired model

Ordinary rational arithmetic excludes division by zero. Franc **represents** two exceptional equivalence classes:

| Expression | Canonical pair | Hosted display | Meaning |
| --- | --- | --- | --- |
| 1/2 | (1,2) | 1/2 | Finite rational |
| 0 | (0,1) | 0 | Finite zero |
| 1/0 | (1,0) | ∞ | A single infinity-like state |
| -1/0 | (1,0) | ∞ | Same infinity-like state: **sign is lost** |
| 0/0 | (0,0) | ⊥ | Bottom / undefined / unrepresentable |

The hosted pretty printer emits the infinity and bottom glyphs. Some freestanding/native serial output prints **NaN** for bottom. The internal pair, not its display spelling, defines the state.

Franc is *inspired by wheel arithmetic* or **totalized division**, an area of algebra studying division that can be defined even at zero. A formal wheel has specific axioms. Franc's bounded implementation **has not been established as a formally verified mathematical wheel**; do not confuse inspiration with an algebraic proof.

The present implementation uses the familiar rational pair formulas, then canonicalizes:

    (a/b) + (c/d) = (a*d + b*c) / (b*d)
    (a/b) - (c/d) = (a*d - b*c) / (b*d)
    (a/b) * (c/d) = (a*c) / (b*d)
    (a/b) / (c/d) = (a*d) / (b*c)

At zero denominators, these formulas produce behavior worth remembering:

    1/0 1 +        \ ∞
    1/0 1/0 +      \ ⊥ (NOT ∞)
    1/0 0 *        \ ⊥
    1/0 1/0 *      \ ∞
    1 0 /          \ ∞
    0 0 /          \ ⊥

Those specific behaviors appear in the executable hosted tests. **Do not assume the standard identities of the real numbers remain valid in exceptional cases.** A cancellation such as x/x = 1 requires a suitable nonzero finite x. In this model, infinity is one unsigned state: there is no distinct positive and negative infinity.

Bottom also has no reason code: 0/0, overflow, invalid conversions and other errors may all resolve to the same encoded pair. Applications that must diagnose failure causes need a separate error channel.

### Why treat the exceptional states as values?

This can make a REPL or an exploratory numeric program *continue* through otherwise problematic arithmetic, while leaving an explicit result that can be inspected. But propagation of a bottom value is **not** the same as an exception with an error message or stack trace. Applications must still validate inputs and choose a policy.

## 4. Exactness, boundedness, and when rounding enters

**Exact rational arithmetic** means the finite result equals the mathematical fraction whenever the result fits the representation. It does **not** imply:

- Arbitrary-precision integers or fractions;
- exact representation of π, e or √2 as a single core fraction;
- an absence of overflow;
- no numerical error in approximate or transcendental functions;
- proof that a numerical method converges for all inputs.

The hosted interpreter uses 128-bit intermediates for core operations and reduces results into 64-bit cells. If the reduced values do not fit, it returns bottom instead of relying on undefined signed-overflow behavior. The native runtime reaches the same results with its own assembly implementation. Both must match [`tests/arith/vectors.txt`](../tests/arith/vectors.txt), which is the rule for edge behavior rather than either implementation.

The `%` operator takes two integers and returns a result with the sign of the divisor, so `-7 3 %` is 2. A zero divisor or a non-integer operand gives bottom. The hosted interpreter also treats `%` with a single value on the stack as percent; that behavior depends on stack depth, is not part of the language rule, and does not exist natively.

For approximation, the math library includes fixed-precision rational helpers. Default precision is six decimal digits, but that is a library policy, not the native numeric type:

    1/3              \ exactly 1/3
    1/3 fix          \ 333333/1000000 at default precision
    1/3 fix 1/3 -    \ -1/3000000, the exact residual

This distinction is powerful for debugging approximation error: a rounded value is **still a rational**, and the difference from the exact rational can be measured exactly when within bounds.

## 5. Franc compared with common programming languages

| Language/platform | Common ordinary numbers | What differs from Franc |
| --- | --- | --- |
| C/C++ | Fixed-width integers and hardware floating point | Faster low-level primitives; fraction types are custom; overflow/rounding rules vary by type |
| JavaScript | Binary64 Number and separate BigInt | Decimal-looking Number expressions can round; default Number is not a reduced fraction |
| Python | Arbitrary-precision int, binary float; optional fractions.Fraction | Exact rational arithmetic is available, but normally opt-in; Python integers are often unbounded |
| Rust | Fixed-width integer/float, library rational/BigInt types | Rich type and overflow checking; default scalar numeric types are not rational pairs |
| Haskell, Julia and other mathematical languages | Multiple numeric representations, often including a first-class rational facility | Franc is **not unique in supporting rationals**; its distinguishing choice is how the rational model integrates with the minimal language and OS |
| Mathematica, SageMath, SymPy | Rich symbolic and arbitrary-precision mathematics | Franc does **not** currently provide a comparable general-purpose symbolic algebra system |

The meaningful difference is not “other languages cannot do fractions.” They can. Franc's design is **rational-first execution with exceptional values and direct integration into a compact self-hosted language/runtime**.

### A comparison with IEEE 754

IEEE binary floating point approximates many fractions, represents infinities with signs, distinguishes NaN encodings and specifies arithmetic/rounding behavior. Franc's bounded rational pair can represent 1/3 exactly, but its **single** infinity-like state and bottom state do **not** behave like IEEE 754 +∞, -∞, NaN or exception flags.

The optional **float.frac** library can inspect an eight-byte IEEE binary64 encoding, classify zero/normal/subnormal/infinity/NaN and extract a significand with a power-of-two exponent. It is **not** an implementation of a general-purpose hardware floating-point arithmetic engine. Conversion of a binary64 value into a single core rational can fail because of the 64-bit numerator/denominator bounds.

## 6. Practical use cases

### Exact allocation, prices and rates

Splitting a quantity among recipients or preserving a contractual ratio is a natural fit for exact fractions. For example:

    5 3 /          \ exact allocation of 5 units among 3: 5/3
    1/6 +          \ exact combination: 11/6

For production money, though, a currency unit, a specified rounding mode, legal/accounting policy and auditability matter. **Do not treat Franc's educational fix helper as a production financial rounding or regulatory compliance implementation.**

### Geometry, display scaling and aspect ratios

Proportions such as 16/9 and 3/4 can remain exact until a chosen rasterization step. Franc's graphical demos, Stern–Brocot explorer and Ford circles show the relationship between rational structure and visual geometry. Rendering pixels still involves rounding and device bounds; exact fractions do not make a framebuffer itself exact.

### Number theory and continued fractions

A finite rational has a Euclidean continued-fraction expansion. Franc ships **cf.frac**, **walk.frac**, and **ford.frac** to explore this structure:

    22/7 cf .s       \ coefficients 3 7
    355/113 cf .s    \ coefficients 3 7 16

The Stern–Brocot tree and Ford circles make rational ordering and approximation visible. They are particularly good demonstrations of Franc's numeric foundation. They do **not** yield an exact core rational representation of an irrational constant.

### Verifiable numerical algorithms

When both expected and actual results are representable fractions, tests can assert equality without floating tolerances. Approximate algorithms still need numeric error bounds. Franc's **approx.frac** offers rational approximations for square roots, pi and e, with finite precision; **trans.frac** implements selected transcendental approximations.

### Repeating decimals and base inspection

The hosted REPL can display the repeating cycle of a finite rational, without losing the exact source fraction:

    1/7 ~            \ 0.(142857)
    -1/6 ~           \ -0.1(6)
    255 16 ~         \ FF in hexadecimal

These examples are **hosted behavior**; do not infer that all formatting operators are implemented identically in the freestanding OS.

## 7. A guided map of the math libraries

| Module | What it provides | Appropriate use | Important limitation |
| --- | --- | --- | --- |
| **fixpt.frac** | Precision selection, eps and rational rounding | Controlled display/iteration precision | Approximate policy, not a certified finance engine |
| **cf.frac** | Continued-fraction coefficients | Euclidean algorithm and approximation experiments | Bounded rational inputs |
| **approx.frac** | sqrt/isqrt, pi, e approximations | Educational numerical methods | No exact irrational values |
| **trans.frac** | Selected sin, cos, atan, log, exp approximations | Exploring finite approximations | Domain/range and convergence limits |
| **iv.frac** | Interval addition/subtraction/multiplication/division | Demonstrations of range arithmetic | **Zero-containing divisor intervals are not rigorous enclosures** |
| **dd.frac** | Two-component, unevaluated rational sum hi + lo | Extra representable sums without core ABI change | **Not IEEE double-double**; components can overflow |
| **bignum.frac** | Separate unsigned base-256 multi-limb numbers in an arena | Larger natural-number experiments | Not core big-rational arithmetic |
| **float.frac** | IEEE 754 binary64 bit-pattern classification and decoding | Binary format introspection | Not an FPU; core rational conversion may fail |
| **litetofrac.frac** | Tiny infix integer + - * / ( ) translator | Familiar entry of simple expressions | Not a complete syntax/parser/compiler |
| **walk.frac / ford.frac** | Stern–Brocot and Ford-circle exploration | Visual rational number theory | Educational bounded demos |

**Intervals:** The present interval division implementation computes endpoint combinations; when an interval crosses zero it cannot be trusted as a rigorous enclosure. Do not use it for certified numerical analysis.

**Two-part rational expansions:** A pair (hi,lo) represents an exact unevaluated sum *of two representable rationals*. It can avoid collapsing a large sum too early, but arithmetic can still overflow in either component. This is not an IEEE float “double-double” implementation.

**Bignums:** The library's arena is separately bounded. The mere existence of bignums does not change all operations on core rational values into unlimited-precision operations.

## 8. The computer-science dimension: redefinable operations

Franc is also a programmable, postfix, JIT-compiled environment: definitions can shadow earlier words, including operators in the hosted implementation. That gives research freedom to build domain-specific arithmetic and representations, but it can surprise users who expect immutable operator semantics.

    def sq dup * ;
    5 sq             \ 25

A mathematical model for *large* applications should eventually establish scoped operator definitions and stable numeric interfaces, because uncontrolled global shadowing can make a symbol such as + mean something different after a definition is loaded.

## 9. Boundaries and future research

1. **Formal algebra:** specify the value set, equality, canonicalization, every exceptional operation table, conditional semantics and which identities hold on which subsets.
2. **Overflow semantics:** decide whether overflow, mathematical undefined and invalid input should be distinct tagged values, or preserve the single bottom state with a separate error channel.
3. **Numerical tower:** design versioned big-integer, big-rational, decimal, interval and IEEE bridge types without quietly changing the 16-byte kernel ABI.
4. **Differential tests:** extend [`tests/arith/vectors.txt`](../tests/arith/vectors.txt) beyond the core operators, and explain deliberate differences.
5. **Verification:** property tests over finite safe ranges, exceptional operation tables, and fuzzed normalization/canonicalization.
6. **Domain-specific error policies:** define rigorous rounding and convergence contracts for scientific, monetary and geometry libraries before claiming production suitability.

## 10. Where the assertions come from

- Hosted rational normalization: **frac.c**, specifically the Rat pair, canon128, core arithmetic and printing.
- Hosted exceptional-value and overflow tests: **tests/test_frac.py**.
- Native kernel numeric ABI and arithmetic: **stage4/runtime.S at v1.1**, then its canonical **runtime/abi.S** path in the reorganized source tree.
- Library behavior tests: **tests/test_libraries.py** and the corresponding source modules in **lib/**.
- Current OS system scope and limitations: **docs/FRANCOS_V1_RELEASE_CANDIDATE.md** and **docs/REPO_ARCHITECTURE.md**.

The original experimental release is immutable and remains available at the v1.1 tag. Source file paths in this document refer to the reorganized development tree where explicitly noted.

---

**The core idea:** Franc treats the fraction as the starting numeric abstraction, allows a consciously nonstandard division-by-zero model, and uses the same model throughout a small compiler and experimental OS. Its strengths are exact representable ratios and mathematical transparency; its constraints are bounded representation, limited native parity and the absence of a comprehensive formal numeric specification.
