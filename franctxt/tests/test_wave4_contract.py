"""Static invariants for the paired FrancOS Wave 4 service/UI integration.

This intentionally does not claim that a source-level assertion is a
substitute for the single-disk QEMU user journey. It catches silent native
JIT definition drop caused by out-of-order app modules and unsupported
Franc conditional nesting before a costly cold boot is attempted.
"""
from pathlib import Path
import re
import unittest

ROOT = Path(__file__).resolve().parents[2]
BUNDLE = ROOT / "stage4/app_sources.list"
CORE = ("lib/ui.frac", "lib/user_aot.frac", "lib/ide.frac",
        "lib/franctxt.frac", "stage4/pci.frac", "stage4/net.frac",
        "stage4/ip.frac", "stage4/udp.frac", "lib/services.frac",
        "lib/pkg.frac")


def words(source: str):
    for lineno, line in enumerate(source.splitlines(), 1):
        if not line.startswith("def "):
            continue
        masked = re.sub(r'"[^"]*"', '""', line)
        yield lineno, masked.split()


class Wave4Integration(unittest.TestCase):
    def test_app_dependency_graph_is_in_compiler_order(self):
        entries = [x.strip() for x in BUNDLE.read_text().splitlines()
                   if x.strip() and not x.lstrip().startswith("#")]
        self.assertEqual(len(entries), len(set(entries)))
        self.assertEqual(entries[0], "stage4/apps/native-compat.frac")
        for entry in CORE:
            self.assertIn(entry, entries)
        before = (
            ("stage4/apps/native-compat.frac", "lib/user_aot.frac"),
            ("lib/ui.frac", "lib/ide.frac"),
            ("lib/user_aot.frac", "lib/ide.frac"),
            ("lib/ide.frac", "lib/pkg.frac"),
            ("lib/franctxt.frac", "lib/pkg.frac"),
            ("stage4/pci.frac", "stage4/net.frac"),
            ("stage4/net.frac", "stage4/ip.frac"),
            ("stage4/ip.frac", "stage4/udp.frac"),
            ("stage4/udp.frac", "lib/services.frac"),
            ("lib/ui.frac", "lib/services.frac"),
            ("lib/services.frac", "lib/pkg.frac"),
        )
        for dep, consumer in before:
            with self.subTest(dep=dep, consumer=consumer):
                self.assertLess(entries.index(dep), entries.index(consumer))
        # Predeclaration must match the exact 4KiB pinned IDE reservation,
        # so the user-code emitter can compile before the editor module.
        compat = (ROOT / entries[0]).read_text()
        ide = (ROOT / "lib/ide.frac").read_text()
        self.assertIn("def ide-buffer $6b00000 ;", compat)
        self.assertIn("def ide-buffer $6b00000 ;", ide)

    def test_new_franc_core_definitions_have_closed_branches(self):
        names = set()
        for path in ("lib/ui.frac", "lib/services.frac", "lib/ide.frac",
                     "lib/pkg.frac"):
            content = (ROOT / path).read_text()
            for lineno, definition in words(content):
                name = definition[1]
                names.add(name)
                depth = 0
                for token in definition[2:]:
                    if token in ("if", "if0", "ifnz"):
                        depth += 1
                    elif token == "then":
                        self.assertGreater(depth, 0, (path, lineno, name))
                        depth -= 1
                    elif token == "else":
                        self.assertGreater(depth, 0, (path, lineno, name))
                self.assertEqual(depth, 0, (path, lineno, name))
        for required in ("ui-frame", "ui-error", "ui-status", "ide-run-user",
                         "ide-main", "pkg-ui", "pkg-run-pair", "svc-dns-poll",
                         "svc-dns-request", "svc-net-info"):
            self.assertIn(required, names)

    def test_ring3_launch_isolated_from_trusted_main(self):
        ide = (ROOT / "lib/ide.frac").read_text()
        pkg = (ROOT / "lib/pkg.frac").read_text()
        self.assertIn("def ide-run-user ide-buffer user-compile", ide)
        self.assertIn("user-code-stage", ide)
        self.assertIn("user-compiled-probe", ide)
        self.assertIn("user-compiled-relaunch", ide)
        self.assertIn("ide-key 121 - if0 ide-run-user", ide)
        self.assertIn("def pkg-run-pair pkg-dependency-valid", pkg)
        self.assertIn("def pkg-install-verified :pc-bus :pc-fn :pc-dev", pkg)
        self.assertIn("user-compiled-probe", pkg)
        # Installation never calls the privileged JIT compiler on uploaded
        # source: execution is exclusively the audited user-mode grammar.
        installation = pkg.split("def pkg-install-verified ", 1)[1].split(
            "\ndef ", 1)[0]
        self.assertNotIn("s2-source", installation)
        self.assertNotIn("s2-run", installation)

    def test_integrated_journey_covers_all_seven_exit_steps(self):
        source = (ROOT / "stage4/qemu_v1_journey.py").read_text()
        self.assertIn("stage_offline(disk, base", source)
        self.assertIn("stage_offline(disk, app", source)
        self.assertIn("stage_offline(disk, update", source)
        self.assertIn('g.key(b"y"', source)
        self.assertIn('g.key(b"x"', source)
        self.assertIn("2049 svc-dns-poll", source)
        self.assertIn("boot4.pcap", source)
        for index in range(1, 18):
            self.assertIn(f"v1-{index:02d}-", source)
        self.assertIn("all seven FrancOS v1 journey stages", source)


if __name__ == "__main__":
    unittest.main()
