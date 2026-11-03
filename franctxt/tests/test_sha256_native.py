"""Verify freestanding assembly SHA-256 against Python's independent hashlib.

No C source or compiler is involved. The same assembly is included by
the FrancOS native micro-runtime, using only x86-64 integer operations.
"""
import ctypes
import hashlib
from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[2]
ASM = ROOT / "franctxt" / "sha256_native.S"
DOMAIN = b"franctxt/1\0"


class NativeSHA256(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        path = Path(cls.tmp.name)
        subprocess.run(["as", "--64", "-o", str(path / "hash.o"), str(ASM)],
                       check=True)
        subprocess.run(["ld", "-shared", "-o", str(path / "hash.so"),
                        str(path / "hash.o")], check=True)
        cls.module = ctypes.CDLL(str(path / "hash.so"))
        cls.hash = cls.module.ft_sha256_canonical
        cls.hash.argtypes = (ctypes.c_void_p, ctypes.c_size_t)
        cls.hash.restype = ctypes.c_char_p
        cls.raw_hash = cls.module.ft_sha256_raw
        cls.raw_hash.argtypes = (ctypes.c_void_p, ctypes.c_size_t)
        cls.raw_hash.restype = ctypes.c_char_p

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def sha_native(self, payload):
        buffer = ctypes.create_string_buffer(payload)
        result = self.hash(buffer, len(payload))
        return result.decode("ascii") if result is not None else None

    def test_block_edges(self):
        for length in (0, 1, 10, 43, 44, 45, 53, 54, 55, 56, 57,
                       63, 64, 65, 127, 128, 191, 511, 1023, 2047):
            data = bytes((index * 23 + 19) % 256 for index in range(length))
            with self.subTest(size=length):
                expected = hashlib.sha256(DOMAIN + data).hexdigest()
                self.assertEqual(self.sha_native(data), expected)

    def test_raw_offline_package_source_sha256(self):
        for length in (0, 1, 12, 43, 44, 55, 56, 64, 128, 256, 2047):
            data = bytes((index * 11 + 7) & 255 for index in range(length))
            with self.subTest(length=length):
                buf = ctypes.create_string_buffer(data)
                value = self.raw_hash(buf, length)
                self.assertIsNotNone(value)
                self.assertEqual(value.decode("ascii"),
                                 hashlib.sha256(data).hexdigest())
        self.assertIsNone(self.raw_hash(None, 6))
        buf = ctypes.create_string_buffer(b"x" * 2048)
        self.assertIsNone(self.raw_hash(buf, 2048))

    def test_real_canonical_example(self):
        payload = (ROOT / "franctxt" / "examples" / "kernel.franctxt").read_bytes()
        self.assertEqual(self.sha_native(payload),
                         hashlib.sha256(DOMAIN + payload).hexdigest())

    def test_invalid_length(self):
        buffer = ctypes.create_string_buffer(b"x" * 2048)
        self.assertIsNone(self.hash(buffer, 2048))
        self.assertIsNone(self.hash(None, 4))


if __name__ == "__main__":
    unittest.main()
