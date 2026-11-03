# Franctxt v1: portable, verifiable state

Extension: .franctxt. Status: experimental v1 interoperability core.
Implementations: Python (franctxt/__init__.py), zero-dependency Node.js
(franctxt/index.js), and native Franc (lib/franctxt.frac).

Franctxt is declarative data, not Franc code. Parsing must never
execute arbitrary programs. Its primary purpose is language-independent
deterministic configuration and state with cryptographic identity.

## Grammar and types

A v1 document starts with "franctxt 1", followed by zero or more
"key = value" records. Blank lines and whole-line # comments are
accepted on input. No inline comments, interpolation or expressions.

Keys: [a-z][a-z0-9]*(?:[._-][a-z0-9]+)*, maximum 63 ASCII bytes.
Duplicate keys are invalid.

V1 values:
- true, false: booleans, not integer aliases.
- null: absent optional value.
- 123, -42: signed integers, magnitude <= 9223372036854775807.
  No plus, leading zeroes, floating point, or exponent syntax.
- 1/3, -6/8: exact rationals with positive nonzero denominator,
  64-bit bounded components, normalized using positive GCD.
- "FrancOS": ASCII strings, maximum 255 content bytes. Embedded
  backslashes, quotes, escapes and control characters are not supported
  in v1. Future extensions require a new version number.

Input and canonical output are ASCII and max 2047 bytes to fit native
FRANCFS1 storage. LF and CRLF are accepted, bare CR is forbidden.
No executable constraints exist in the file. Known schemas are
enforced by versioned, independently implemented profile validators.

## Canonicalization and semantic identity

Portable parsers accept reordered lines, full-line comments, CRLF
and extra whitespace. Canonicalization sorts keys in ascending ASCII,
reduces rationals, minimizes integer spellings, and writes:

    franctxt 1
    history.parent = null
    simulation.ratio = 1/3
    system.name = "FrancOS"

Every canonical line uses exactly "key = value" and ends in LF,
including the last. No comments or blank lines remain. A rational
4/1 remains a rational rather than changing into integer 4.

Document identity:
  sha256:<lowercase hex of SHA-256(
      ASCII bytes "franctxt/1", followed by NUL,
      followed by canonical document bytes)>

This is a domain-separated semantic *content digest*, not proof of
authorship. Whitespace reformatting and rational reduction preserve
identity; changes to the semantic content do not.

A parent state can be recorded by the normal field
"history.parent = " plus a quoted sha256:... string. It is included
in the child's digest. Applications must verify the full ancestry
rather than assuming a reference proves trust.

## Kernel integration

The native shell/assembly image packer installs two files into the
existing persistent FRANCFS1 directory:

- kernel.franctxt: version, Git source revision, SHA-256 of the
  exact native kernel binary, and SHA-256 identity of initial config.
- system.franctxt: typed default configuration, currently BIOS boot,
  bounded RAM and cooperative scheduler settings.

The kernel binary digest covers the raw kernel image; the Franctxt
semantic digest covers the canonical config. They are deliberately
different, and neither hash is embedded into its own hashed bytes.

Once native app sources are loaded, Franc exposes:
    ft-show-config
    ft-show-identity
    ft-config "memory.page-size" ft-get ft-int .

This native Franc code reads the persistent files and can access typed
integer and rational lexical values. It does not compile input data,
and the parser never executes config values. Configuration changes
are stored but are NOT automatically applied as kernel policies.

CRITICAL: The native Franc reader does not yet calculate SHA-256 or
verify Ed25519 signatures in the guest. Host CI validates the actual
kernel and config digests. Printing a build hash is NOT secure boot.

## Optional authenticated signatures

Python's CLI can sign a canonical document with an external Ed25519
private key and write a separate JSON .fsig file. The message signed
is ASCII "franctxt-signature/v1", then one zero byte, then the 32
binary bytes of the document digest. Verification requires an
independently trusted external Ed25519 public key. No secret or
private key may be checked into this repository or embedded in images.

A matching unsigned hash cannot prove authorization. A signature
verified against an untrusted public key is also insufficient.

## Portable commands

    python3 -m franctxt canonical franctxt/examples/kernel_alternate.franctxt
    python3 -m franctxt id franctxt/examples/kernel.franctxt
    python3 -m franctxt check-kernel franctxt/examples/kernel.franctxt

    # requires pip install cryptography and externally managed keys
    python3 -m franctxt sign state.franctxt --key release.pem --output state.fsig.json
    python3 -m franctxt verify state.franctxt --signature state.fsig.json --trusted-key release.pub.pem
    python3 -m franctxt verify-kernel kernel.franctxt --binary stage4/native_seed.bin

## Regression and cross-language tests

    python3 -m unittest discover -s franctxt/tests -p test_conformance.py -v
    node franctxt/tests/test_cross_language.cjs

CI compares Python and JavaScript semantic IDs and the normalized
fixture bytes. It tests malformed input, exact rationals, parent
references, external-trust Ed25519 verification, disk identity,
and guest boot/persistence using actual QEMU.

## Scope

Franctxt v1 is a bounded interoperability baseline, not an arbitrary
schema/expression VM, virtual memory manager, distributed consensus
protocol, secure boot chain, encrypted secrets format, or transactional
state journal. Standardized richer types, kernel-side cryptographic
verification, atomic config updates, and signed release policy are
future, separately testable increments.
