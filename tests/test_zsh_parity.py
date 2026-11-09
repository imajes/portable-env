"""Portable source contracts; never loads the operator's shell or credentials."""
import base64
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import tomllib
import unittest

ROOT = Path(__file__).resolve().parents[1]
ZSH = os.environ.get("ZSH_TEST_SHELL", shutil.which("zsh") or "/bin/zsh")
BASH = os.environ.get("BASH_TEST_SHELL", "/bin/bash")


class ZshParityTests(unittest.TestCase):
    def test_selected_zsh_contains_reviewed_baseline(self):
        result = subprocess.run(["git", "-C", str(ROOT / ".config/zsh"),
                                 "merge-base", "--is-ancestor", "cd4d12fc3b20acd044afd56c4d231766f5a4b08c", "HEAD"],
                                capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertTrue((ROOT / ".config/zsh/libexec/mark-run.py").is_file())
        for rel in ("functions/mise-expire", "functions/util:compile_functions_if_stale",
                    "shell_customizations.d/30-mise_bootstrap.zsh", "functions/_codex_helm"):
            self.assertFalse((ROOT / ".config/zsh" / rel).exists(), rel)

    def test_account_policy_is_consumed_before_prompt(self):
        with tempfile.TemporaryDirectory(prefix="portable-account-") as td:
            shutil.copy2(ROOT / ".zsh_portable-env", Path(td) / ".zsh_portable-env")
            env = {"HOME": td, "PATH": "/usr/bin:/bin", "ZDOTDIR": str(ROOT / ".config/zsh")}
            code = ('source "$ZDOTDIR/shell_customizations.d/03-terminal.zsh"; '
                    'source "$ZDOTDIR/.p10k.zsh"; '
                    'print -r -- "$ZSH_PORTABLE_MODE:${POWERLEVEL9K_DISABLE_GITSTATUS:-unset}"')
            for extra, expected in [({}, "1:true"), ({"ZSH_PORTABLE_MODE": "0"}, "0:unset")]:
                result = subprocess.run([ZSH, "-dfc", code], env=env | extra,
                                        cwd=td, capture_output=True, text=True, timeout=10)
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual(result.stderr, "")
                self.assertEqual(result.stdout.strip(), expected)
