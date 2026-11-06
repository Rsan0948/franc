"""Release publication is idempotent and fails closed on lookup errors."""
from pathlib import Path
import subprocess
import tempfile
import unittest

SCRIPT = Path(__file__).resolve().parents[1] / "tools/release_tag_state.sh"


class ReleaseTagState(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="franc-release-state-")
        self.addCleanup(self.temp.cleanup)
        self.repo = Path(self.temp.name) / "repo"
        self.repo.mkdir()
        self.git("init", "-q")
        self.git("-c", "user.name=Release Test", "-c",
                 "user.email=release-test@example.invalid", "commit", "-qm",
                 "fixture", "--allow-empty")
        self.git("remote", "add", "origin", str(self.repo))

    def git(self, *args):
        return subprocess.check_output(["git", *args], cwd=self.repo,
                                       stderr=subprocess.STDOUT)

    def state(self, tag="francos-test"):
        return subprocess.run(["sh", str(SCRIPT), tag], cwd=self.repo,
                              text=True, capture_output=True)

    def test_missing_tag_needs_publication(self):
        self.git("branch", "francos-test")
        self.git("tag", "francos-test-other")
        result = self.state()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stdout, "publish=true\n")

    def test_existing_tag_skips_publication_without_moving_it(self):
        self.git("tag", "francos-test")
        before = self.git("rev-parse", "refs/tags/francos-test")
        result = self.state()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stdout, "publish=false\n")
        self.assertEqual(self.git("rev-parse", "refs/tags/francos-test"), before)

    def test_unavailable_remote_fails_without_authorizing_publication(self):
        self.git("remote", "set-url", "origin", str(self.repo / "missing.git"))
        result = self.state()
        self.assertNotEqual(result.returncode, 0)
        self.assertNotIn("publish=", result.stdout)

    def test_invalid_tag_fails_without_authorizing_publication(self):
        result = self.state("invalid*tag")
        self.assertNotEqual(result.returncode, 0)
        self.assertNotIn("publish=", result.stdout)


if __name__ == "__main__":
    unittest.main()
