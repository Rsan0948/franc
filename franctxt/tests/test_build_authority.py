"""Regression tests for deterministic Franc-native seed and bundle preflight."""
from pathlib import Path
import tempfile
import unittest

from franctxt import canonical
from franctxt.build import (
    APP_SOURCE_LIST, BuildAuthorityError, LOCK_PATH,
    SEED_PATH, SEED_SOURCE_LIST, check_app_registers, check_seed,
    listed_sources, packed_apps, pin_seed, seed_inputs_sha,
)


class BuildAuthority(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix="franctxt-lock-")
        self.root = Path(self.tmp.name)
        for directory in ("stage4/apps", "stage2", "franctxt"):
            (self.root / directory).mkdir(parents=True, exist_ok=True)
        self.put(SEED_PATH, ".text\n.global franc_entry\n")
        self.put("stage4/aot.frac", "def compile 1 ;\n")
        self.put("stage2/compiler.frac", "def compiler 1 ;\n")
        self.put("stage4/apps/registry.frac", "def app-register-seed 0 :known ;\n")
        self.put(SEED_SOURCE_LIST,
                 "stage2/compiler.frac\nstage4/aot.frac\nstage4/apps/registry.frac\n")
        self.put("stage4/apps/example.frac", "def f known 3 :known ;\n")
        self.put(APP_SOURCE_LIST, "stage4/apps/example.frac\n")
        self.put("franctxt/build.franctxt", canonical({
            "schema": "francos.build-authority.v1",
            "system.name": "FrancOS",
            "build.abi": "franc-rat16-v1",
            "build.arch": "x86_64",
            "build.app-list": APP_SOURCE_LIST,
            "build.seed-list": SEED_SOURCE_LIST,
            "build.native-seed-required": True,
            "memory.ram-mib": 128,
        }))

    def tearDown(self):
        self.tmp.cleanup()

    def put(self, name, data):
        path = self.root / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(data.encode("ascii") if isinstance(data, str) else data)

    def test_seed_pin_and_strict_preflight(self):
        first = pin_seed(self.root)
        self.assertEqual(check_seed(self.root), first)
        self.assertEqual(len(check_app_registers(self.root)), 1)
        self.put("stage4/apps/registry.frac", "def app-register-seed 0 :known 0 :new ;\n")
        with self.assertRaisesRegex(BuildAuthorityError, "STALE BOOTSTRAP SEED"):
            check_seed(self.root)
        pin_seed(self.root)
        self.assertNotEqual(check_seed(self.root), first)
        self.put(SEED_PATH, ".text\n# rebuilt\n")
        with self.assertRaisesRegex(BuildAuthorityError, "STALE BOOTSTRAP SEED"):
            check_seed(self.root)

    def test_missing_register_detected_before_guest(self):
        pin_seed(self.root)
        self.put("stage4/apps/example.frac", "def f known :new_register ;\n")
        with self.assertRaisesRegex(BuildAuthorityError, "REGISTRY MISMATCH"):
            check_app_registers(self.root)
        self.put("stage4/apps/registry.frac",
                 "def app-register-seed 0 :known 0 :new_register ;\n")
        self.assertEqual(check_app_registers(self.root),
                         {"new_register"})

    def test_list_is_single_source_of_truth(self):
        self.assertEqual(packed_apps(self.root),
                         b"def f known 3 :known ;\n\n\0")
        before = seed_inputs_sha(self.root)
        self.put("stage2/compiler.frac", "def compiler 2 ;\n")
        self.assertNotEqual(seed_inputs_sha(self.root), before)
        self.put(APP_SOURCE_LIST, "../outside.frac\n")
        with self.assertRaises(BuildAuthorityError):
            listed_sources(self.root, APP_SOURCE_LIST)

    def test_missing_lock_is_blocker(self):
        with self.assertRaisesRegex(BuildAuthorityError, "missing Franctxt"):
            check_seed(self.root)


if __name__ == "__main__":
    unittest.main()
