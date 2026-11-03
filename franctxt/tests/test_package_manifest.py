"""Wave 3 offline package identity and fail-closed dependency-plan tests.

All of these are host-side pure validation. Real native install, update,
rollback, replay and CPL3 package execution remain independent acceptance.
"""
import unittest

from franctxt import canonical, parse
from franctxt.packages import (
    PackageError, manifest_for, plan_install, read_manifest, verify_payloads,
)


def make(id_, version="1.0.0", deps=(), files=None):
    if files is None:
        files = {f"{id_}.frac": b"def main 7 8 + ;"}
    pkg = manifest_for(id_, version, files, tuple(deps),
                       entry=next(iter(files)))
    return pkg, files


class OfflinePackageManifestTests(unittest.TestCase):
    def test_manifest_identity_roundtrip(self):
        pkg, payloads = make("math")
        self.assertEqual(read_manifest(pkg.manifest), pkg)
        self.assertEqual(canonical(parse(pkg.manifest)), pkg.manifest)
        self.assertTrue(verify_payloads(pkg, payloads))
        self.assertEqual(pkg.files[0][2][:7], "sha256:")

    def test_tampering_and_unknown_fields_fail_closed(self):
        pkg, payloads = make("math")
        with self.assertRaises(PackageError):
            verify_payloads(pkg, {"math.frac": b"def main 0 ;"})
        invalid = dict(parse(pkg.manifest))
        invalid["package.other"] = True
        with self.assertRaises(PackageError):
            read_manifest(canonical(invalid))
        with self.assertRaises(PackageError):
            read_manifest(pkg.manifest + b"\n")

    def test_rejects_unsafe_paths_names_and_unbounded_source(self):
        for filename in ("../evil.frac", "kernel.franctxt",
                         "absolute/path.frac", "x" * 24):
            with self.assertRaises(PackageError):
                manifest_for("safe", "1.0.0", {filename: b"a"})
        with self.assertRaises(PackageError):
            manifest_for("safe", "1.0.0", {"safe.frac": b"x" * 2048})

    def test_dependencies_install_in_order_without_mutating_current_state(self):
        base, base_files = make("base")
        app, app_files = make("app", deps=(("base", "1.0.0"),))
        repo = {base.key: (base, base_files), app.key: (app, app_files)}
        installed = {}
        plan = plan_install(repo, installed, app.key)
        self.assertEqual(plan.ordered, (base.key, app.key))
        self.assertEqual(plan.installed, (("app", "1.0.0"), ("base", "1.0.0")))
        self.assertEqual(len(plan.files), 2)
        self.assertEqual(installed, {})
        already = plan_install(repo, dict(plan.installed), app.key)
        self.assertEqual(already.ordered, ())

    def test_missing_dependency_cycle_and_rollback_on_error(self):
        a, af = make("a", deps=(("b", "1.0.0"),))
        b, bf = make("b", deps=(("a", "1.0.0"),))
        repo = {a.key: (a, af), b.key: (b, bf)}
        installed = {"existing": "1.0.0"}
        with self.assertRaises(PackageError):
            plan_install(repo, {}, a.key)
        self.assertEqual(installed, {"existing": "1.0.0"})
        with self.assertRaises(PackageError):
            plan_install({a.key: (a, af)}, {}, a.key)

    def test_duplicate_filename_and_space_overrun_fail_closed(self):
        a, af = make("a", files={"shared.frac": b"def x 1 ;"})
        b, bf = make("b", deps=(("a", "1.0.0"),),
                     files={"shared.frac": b"def y 2 ;"})
        with self.assertRaises(PackageError):
            plan_install({a.key: (a, af), b.key: (b, bf)}, {}, b.key)
        repo = {}
        dependencies = ()
        for i in range(3):
            identifier = f"pack{i}"
            files = {f"{identifier}-{j}.frac": b"def x 1 ;"
                     for j in range(4)}
            pkg, sources = make(identifier, deps=dependencies, files=files)
            repo[pkg.key] = (pkg, sources)
            dependencies = (pkg.key,)
        with self.assertRaises(PackageError):
            plan_install(repo, {}, ("pack2", "1.0.0"))

    def test_implicit_upgrade_refused(self):
        old, old_src = make("math", "1.0.0")
        new, new_src = make("math", "2.0.0")
        repo = {old.key: (old, old_src), new.key: (new, new_src)}
        with self.assertRaises(PackageError):
            plan_install(repo, {"math": "1.0.0"}, new.key)


if __name__ == "__main__":
    unittest.main()
