# Security policy

FrancOS is an experimental x86-64 QEMU-focused operating system. It is not
suitable for untrusted workloads or protection of sensitive data. The native
trusted Franc REPL runs with kernel privilege. Only a restricted, audited Franc
user-program subset is executed as protected Ring 3 code. Storage is not
journaled; packages verify local content hashes but not publisher signatures;
the networking implementation does not support HTTPS/TLS.

Please **do not publish exploit details or secrets in public issues**. Once
the repository is public, use GitHub's private vulnerability reporting or
contact the maintainers through a private channel they designate. There is
currently no promised security support or patch response SLA.

No release should claim secure boot, hardened process isolation, broad device
support or signed online software distribution without separately verified
implementation and independent review.
