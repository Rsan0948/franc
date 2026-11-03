"""python3 -m franctxt: canonicalize, identify, validate and sign documents.

Ed25519 private keys are never persisted by this tool. Signatures are
separate attestations: a hash is not an authorization, and verification
always requires an explicitly trusted public key supplied by the caller.
"""
import argparse
import hashlib
import json
from pathlib import Path
import sys

from . import FranctxtError, canonical, digest, parse, validate_kernel

SIGNED_DOMAIN = b"franctxt-signature/v1\0"


def sign_file(document: bytes, private_key_pem: bytes) -> dict:
    try:
        from cryptography.hazmat.primitives.serialization import load_pem_private_key
        from cryptography.hazmat.primitives.asymmetric.ed25519 import Ed25519PrivateKey
    except ImportError as exc:
        raise FranctxtError("signing requires pip install cryptography") from exc
    key = load_pem_private_key(private_key_pem, password=None)
    if not isinstance(key, Ed25519PrivateKey):
        raise FranctxtError("expected an Ed25519 private signing key")
    identifier = digest(document)
    import base64
    return {
        "format": "franctxt-signature/v1",
        "document": identifier,
        "signature": base64.b64encode(
            key.sign(SIGNED_DOMAIN + bytes.fromhex(identifier.split(":", 1)[1]))
        ).decode("ascii"),
        "signature_algorithm": "ed25519",
    }


def verify_signature(document: bytes, signature_file: bytes, trusted_public_pem: bytes) -> bool:
    try:
        from cryptography.hazmat.primitives.serialization import load_pem_public_key
        from cryptography.hazmat.primitives.asymmetric.ed25519 import Ed25519PublicKey
        from cryptography.exceptions import InvalidSignature
    except ImportError as exc:
        raise FranctxtError("signature verification requires pip install cryptography") from exc
    import base64
    envelope = json.loads(signature_file)
    if not isinstance(envelope, dict) or set(envelope) != {
        "format", "document", "signature", "signature_algorithm"
    }:
        raise FranctxtError("malformed signature envelope")
    if envelope["format"] != "franctxt-signature/v1" or envelope["signature_algorithm"] != "ed25519":
        raise FranctxtError("unsupported signature envelope")
    identifier = digest(document)
    if envelope["document"] != identifier:
        return False
    key = load_pem_public_key(trusted_public_pem)
    if not isinstance(key, Ed25519PublicKey):
        raise FranctxtError("expected a trusted Ed25519 public key")
    try:
        raw = base64.b64decode(envelope["signature"], validate=True)
        if len(raw) != 64:
            raise FranctxtError("Ed25519 signature must be 64 bytes")
        key.verify(raw, SIGNED_DOMAIN + bytes.fromhex(identifier[7:]))
    except (InvalidSignature, ValueError):
        return False
    return True


def verify_kernel_image(document: bytes, kernel: bytes) -> bool:
    state = parse(document)
    expected = state.get("build.kernel-sha256")
    if not isinstance(expected, str) or len(expected) != 71:
        raise FranctxtError("manifest has no canonical build.kernel-sha256")
    return expected == "sha256:" + hashlib.sha256(kernel).hexdigest()


def main(argv=None) -> int:
    parser = argparse.ArgumentParser(prog="franctxt")
    sub = parser.add_subparsers(dest="command", required=True)
    for name in ("canonical", "id", "check-kernel"):
        action = sub.add_parser(name)
        action.add_argument("document", type=Path)
    sign = sub.add_parser("sign")
    sign.add_argument("document", type=Path)
    sign.add_argument("--key", required=True, type=Path,
                      help="external Ed25519 private PEM, never written to the repo")
    sign.add_argument("--output", required=True, type=Path)
    check = sub.add_parser("verify")
    check.add_argument("document", type=Path)
    check.add_argument("--signature", required=True, type=Path)
    check.add_argument("--trusted-key", required=True, type=Path)
    binary = sub.add_parser("verify-kernel")
    binary.add_argument("document", type=Path)
    binary.add_argument("--binary", required=True, type=Path)
    args = parser.parse_args(argv)
    doc = args.document.read_bytes()
    try:
        if args.command == "canonical":
            sys.stdout.buffer.write(canonical(parse(doc)))
        elif args.command == "id":
            print(digest(doc))
        elif args.command == "check-kernel":
            validate_kernel(parse(doc))
            print("PASS: Franctxt kernel configuration validated")
        elif args.command == "sign":
            envelope = sign_file(doc, args.key.read_bytes())
            args.output.write_text(json.dumps(envelope, sort_keys=True, indent=2) + "\n")
            print("Signed " + envelope["document"])
        elif args.command == "verify":
            if not verify_signature(doc, args.signature.read_bytes(),
                                    args.trusted_key.read_bytes()):
                print("FAIL: signature invalid or document changed", file=sys.stderr)
                return 1
            print("PASS: trusted Ed25519 signature, " + digest(doc))
        elif args.command == "verify-kernel":
            if not verify_kernel_image(doc, args.binary.read_bytes()):
                print("FAIL: manifest does not match kernel bytes", file=sys.stderr)
                return 1
            print("PASS: manifest matches kernel binary")
    except (FranctxtError, UnicodeError, ValueError) as exc:
        print("Franctxt error: " + str(exc), file=sys.stderr)
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
