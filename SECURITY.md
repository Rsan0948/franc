# Security policy

FrancOS is developed and tested as an experimental operating system in QEMU.
Use a disposable guest for exploration and trusted source for the native REPL
and apps, which execute with kernel privileges. The supported user-program
subset runs as protected Ring 3 code with tested preemption and fault isolation.

## Trust boundaries

`FRANCFS1` uses a small, non-journaled persistent directory. Offline packages
verify content hashes against their manifest; publisher signatures are outside
the current package format. Networking supports Ethernet/IP/ICMP/UDP/DNS;
HTTPS/TLS is outside the current network stack. These boundaries make QEMU
with non-sensitive data the appropriate environment for trying FrancOS.

## Report a vulnerability

Keep exploit details, credentials, and private data out of public issues.
Use GitHub's private vulnerability reporting when available, or contact the
maintainer through a designated private channel. Security reports are handled
on a best-effort basis.

Describe the affected commit, reproduction steps, and observed impact.
Security and hardware support statements should identify the implementation
and tests that establish them.
