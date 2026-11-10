"""Verify upstream assets and actual bat/delta rendering in a private fixture."""
import hashlib
import os
from pathlib import Path
import plistlib
import re
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / ".config/bat"
FOXES = ("dayfox", "dawnfox", "duskfox", "nightfox", "nordfox", "terafox", "carbonfox")


class Nightfox(unittest.TestCase):
    def test_unmodified_official_assets(self):
        provenance = (ASSETS / "NIGHTFOX.md").read_text()
        for fox in FOXES:
            data = (ASSETS / "themes" / f"{fox}.tmTheme").read_bytes()
            expected = re.search(rf"\| `{fox}` .*?`([a-f0-9]{{64}})`", provenance).group(1)
            self.assertEqual(hashlib.sha256(data).hexdigest(), expected, fox)
            self.assertIn("settings", plistlib.loads(data))
        self.assertIn("MIT", (ASSETS / "NIGHTFOX-LICENSE").read_text())

    @unittest.skipUnless(shutil.which("bat") and shutil.which("delta"), "bat and delta required")
    def test_actual_renderers_and_native_features(self):
        with tempfile.TemporaryDirectory(prefix="nightfox-test-") as tmp:
            home = Path(tmp)
            config = home / ".config/bat"
            shutil.copytree(ASSETS, config)
            shutil.copy2(config / "nightfox.gitconfig", home / ".gitconfig")
            env = {k: v for k, v in os.environ.items() if not k.startswith(("BAT_", "DELTA_", "GIT_CONFIG"))}
            env.update(HOME=tmp, XDG_CONFIG_HOME=str(home / ".config"),
                       XDG_CACHE_HOME=str(home / ".cache"), BAT_CACHE_PATH=str(home / ".cache/bat"),
                       BAT_CONFIG_PATH=str(config / "config"), GIT_CONFIG_NOSYSTEM="1",
                       GIT_CONFIG_GLOBAL=str(config / "nightfox.gitconfig"))
            def run(args, data=None, **extra):
                result = subprocess.run(args, input=data, env=dict(env, **extra), text=True,
                                        capture_output=True, timeout=20, cwd=home)
                self.assertEqual(result.returncode, 0, result.stderr)
                return result.stdout
            run(["bat", "cache", "--build"])
            themes = run(["bat", "--list-themes", "--color=never"])
            for fox in FOXES:
                self.assertIn(fox, themes)
                rendered = run(["bat", f"--theme={fox}", "--language=python", "--color=always",
                                "--paging=never", "--style=plain"], 'print("Fox")\n')
                self.assertIn("\x1b[", rendered)
                effective = run(["delta", "--show-config", "--true-color=always"], DELTA_FEATURES="+" + fox)
                # Upstream exports share stale display metadata; check actual mode colors.
                self.assertIn("Catppuccin Macchiato", effective)
                mode = "light" if fox in ("dayfox", "dawnfox") else "dark"
                self.assertIn("#FFFFFF" if mode == "light" else "#000000", effective)
                diff = 'diff --git a/demo.py b/demo.py\n--- a/demo.py\n+++ b/demo.py\n@@ -1 +1 @@\n-print(1)\n+print(2)\n'
                output = run(["delta", "--paging=never", "--true-color=always"], diff, DELTA_FEATURES="+" + fox)
                self.assertIn("print", output)
            for mode in ("light", "dark"):
                run(["bat", f"--theme={mode}", "--language=python", "--paging=never"], "print(1)\n")


if __name__ == "__main__":
    unittest.main()
