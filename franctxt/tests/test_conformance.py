"""Cross-language Franctxt v1 conformance and signature regression tests."""
import io
from fractions import Fraction
from pathlib import Path
import unittest

from franctxt import (
    FranctxtError, canonical, digest, format_value, identity, parse,
    parse_value, validate_kernel, verify_parent,
)
from franctxt.__main__ import sign_file, verify_signature, verify_kernel_image

EXAMPLES = Path(__file__).resolve().parents[1] / "examples"
CANON = (EXAMPLES / "kernel.franctxt").read_bytes()
ALTERNATE = (EXAMPLES / "kernel_alternate.franctxt").read_bytes()


class Conformance(unittest.TestCase):
    def test_canonical(self):
        self.assertEqual(canonical(parse(CANON)), CANON)
        self.assertEqual(canonical(parse(ALTERNATE)), CANON)
        self.assertEqual(digest(CANON), digest(ALTERNATE))
        self.assertEqual(identity(ALTERNATE).bytes, len(CANON))

    def test_types(self):
        config = parse(CANON)
        self.assertEqual(config["math.ratio"], Fraction(1, 3))
        self.assertEqual(config["memory.page-size"], 4096)
        self.assertIs(config["network.enabled"], False)
        self.assertIsNone(config["history.parent"])
        self.assertEqual(format_value(Fraction(6, 8)), "3/4")
        self.assertEqual(format_value(Fraction(4, 1)), "4/1")
        self.assertEqual(format_value(parse_value("-0")), "0")

    def test_kernel_rules(self):
        validate_kernel(parse(CANON))
        bad = parse(CANON)
        bad["scheduler.max-tasks"] = 3
        with self.assertRaises(FranctxtError):
            validate_kernel(bad)
        bad = parse(CANON)
        bad["network.enabled"] = True
        bad["network.driver"] = "none"
        with self.assertRaises(FranctxtError):
            validate_kernel(bad)

    def test_history(self):
        old = CANON
        new = parse(old)
        new["history.parent"] = digest(old)
        newer = canonical(new)
        self.assertTrue(verify_parent(newer, old))
        self.assertFalse(verify_parent(newer, canonical({"x": 1})))

    def test_reject_bad_inputs(self):
        invalid = [
            "franctxt 2\nx = 1\n",
            "franctxt 1\nx = 1\nx = 2\n",
            "franctxt 1\nÉ = 1\n",
            "franctxt 1\nx = 1.5\n",
            "franctxt 1\nx = 1/0\n",
            "franctxt 1\nx = 9223372036854775808\n",
            "franctxt 1\nx = \"a\\nb\"\n",
            "franctxt 1\nx = \"a\\\\nb\"\n",
            "franctxt 1\nx = true\np..q = false\n",
            "franctxt 1\nx = 1\rbroken\n",
            "franctxt 1\nx = 01\n",
        ]
        for document in invalid:
            with self.subTest(document=repr(document)):
                with self.assertRaises(FranctxtError):
                    parse(document)

    def test_over_limit(self):
        with self.assertRaises(FranctxtError):
            parse("franctxt 1\n" + "x = 1\n" * 500)
        with self.assertRaises(FranctxtError):
            format_value("x" * 256)

    def test_kernel_binary_identity(self):
        binary = b"exact Franc kernel image"
        import hashlib
        metadata = {"build.kernel-sha256": "sha256:" + hashlib.sha256(binary).hexdigest()}
        manifest = canonical(metadata)
        self.assertTrue(verify_kernel_image(manifest, binary))
        self.assertFalse(verify_kernel_image(manifest, binary + b"\x00"))

    def test_ed25519_external_trust(self):
        from cryptography.hazmat.primitives.asymmetric.ed25519 import Ed25519PrivateKey
        from cryptography.hazmat.primitives.serialization import (
            Encoding, PrivateFormat, PublicFormat, NoEncryption,
        )
        import json
        private = Ed25519PrivateKey.generate()
        private_pem = private.private_bytes(Encoding.PEM, PrivateFormat.PKCS8, NoEncryption())
        public_pem = private.public_key().public_bytes(Encoding.PEM, PublicFormat.SubjectPublicKeyInfo)
        envelope = json.dumps(sign_file(CANON, private_pem)).encode()
        self.assertTrue(verify_signature(ALTERNATE, envelope, public_pem))
        self.assertFalse(verify_signature(CANON.replace(b"FrancOS", b"FrancMX"), envelope, public_pem))
        unrelated = Ed25519PrivateKey.generate().public_key().public_bytes(
            Encoding.PEM, PublicFormat.SubjectPublicKeyInfo
        )
        self.assertFalse(verify_signature(CANON, envelope, unrelated))


if __name__ == "__main__":
    unittest.main()
