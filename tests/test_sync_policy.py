"""The public sync entrypoint must preview exact files without mutating the tree."""
import hashlib
import os
from pathlib import Path, PurePosixPath
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


class SyncPolicy(unittest.TestCase):
    def test_manifest_contains_only_individual_public_files(self):
        paths = (ROOT / "sync-files.txt").read_text().splitlines()
        self.assertEqual(len(paths), len(set(paths)))
        for name in paths:
            path = PurePosixPath(name)
            self.assertFalse(path.is_absolute())
            self.assertNotIn("..", path.parts)
            self.assertTrue((ROOT / name).is_file(), name)
            self.assertFalse((ROOT / name).is_symlink(), name)
            self.assertFalse(name.startswith((".gnupg/", ".agents/", ".codex/", ".claude/", "bin/")), name)
            self.assertNotIn(name, (".npmrc", ".gitconfig", ".config/gh/hosts.yml"))

    @unittest.skipUnless(shutil.which("just") and shutil.which("rsync"), "just and rsync required")
    def test_sync_is_a_preview_and_excludes_private_neighbors(self):
        with tempfile.TemporaryDirectory(prefix="portable-sync-") as tmp:
            root = Path(tmp)
            home, target = root / "home", root / "target"
            home.mkdir()
            target.mkdir()
            for name in ("Justfile", "sync-files.txt"):
                shutil.copy2(ROOT / name, target / name)
            paths = (ROOT / "sync-files.txt").read_text().splitlines()
            for name in paths:
                src = home / name
                src.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(ROOT / name, src)
            existing = target / paths[0]
            existing.parent.mkdir(parents=True, exist_ok=True)
            existing.write_text("existing destination\n")
            for name in (".npmrc", ".cargo/credentials.toml", ".config/gh/hosts.yml"):
                src = home / name
                src.parent.mkdir(parents=True, exist_ok=True)
                src.write_text("PRIVATE_FIXTURE_DO_NOT_COPY\n")
            def snapshot():
                return {str(p.relative_to(target)): hashlib.sha256(p.read_bytes()).hexdigest()
                        for p in target.rglob("*") if p.is_file()}
            before = snapshot()
            run = subprocess.run(["just", "sync"], cwd=target, env=dict(os.environ, HOME=str(home)),
                                 text=True, capture_output=True, timeout=15)
            self.assertEqual(run.returncode, 0, run.stderr)
            self.assertEqual(snapshot(), before)
            self.assertIn(paths[0], run.stdout)
            for name in (".npmrc", "credentials.toml", "hosts.yml", "PRIVATE_FIXTURE"):
                self.assertNotIn(name, run.stdout + run.stderr)


if __name__ == "__main__":
    unittest.main()
