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


class RubyConfigurationTests(unittest.TestCase):
    def test_ruby_hook_remains_opt_in(self):
        config = tomllib.loads((ROOT / ".config/mise/config.toml").read_text())
        self.assertFalse(config.get("env"))
        self.assertNotIn("env-ruby.zsh", (ROOT / ".config/mise/config.toml").read_text())



class RubyHelperTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="portable-ruby-")
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name)
        self.install = self.home / "selected Ruby"
        binary = self.install / "bin/ruby"
        binary.parent.mkdir(parents=True)
        binary.write_text('#!/bin/sh\n[ -z "${RUBYOPT-}${RUBYLIB-}" ] || exit 91\nprintf 4.0.0\n')
        binary.chmod(0o700)

    def project(self, name="project", marker=True, dirs=("node_modules/.bin", "bin")):
        root = self.home / name
        root.mkdir(parents=True)
        if marker:
            (root / "Gemfile").write_text('raise "must never execute"\n')
        for rel in dirs:
            (root / rel).mkdir(parents=True)
        return root

    def run_helper(self, project, install=None, extra=None):
        encode = lambda value: base64.b64encode(os.fsencode(value)).decode()
        env = {"HOME": str(self.home), "PATH": "/usr/bin:/bin",
               "_MISE_RUBY_CWD_B64": encode(project),
               "_MISE_RUBY_INSTALL_B64": encode(install or self.install)} | (extra or {})
        result = subprocess.run([BASH, "--noprofile", "--norc", "-c",
                                 'source "$1"; status=$?; '
                                 '[[ ! ${_MISE_RUBY_CWD_B64+x} && ! ${_MISE_RUBY_INSTALL_B64+x} ]] || exit 92; '
                                 'printf "%s" "$PATH"; exit "$status"',
                                 "test", str(ROOT / ".config/mise/scripts/env-ruby.bash")],
                                env=env, cwd=self.home, capture_output=True, text=True, timeout=15)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stderr, "")
        return result.stdout.split(":")

    def test_ordinary_and_missing_directories_add_nothing(self):
        self.assertEqual(self.run_helper(self.project(marker=False)), ["/usr/bin", "/bin"])
        self.assertEqual(self.run_helper(self.project("empty", dirs=())), ["/usr/bin", "/bin"])

    def test_only_existing_directories_and_exact_abi(self):
        p = self.project(dirs=("bin", "node_modules/.bin", ".bundle/ruby/3.4.0/bin", ".bundle/ruby/4.0.0/bin"))
        self.assertEqual(self.run_helper(p), [str(p / rel) for rel in
                         ("node_modules/.bin", ".bundle/ruby/4.0.0/bin", "bin")] + ["/usr/bin", "/bin"])

    def test_incompatible_bundle_is_not_added(self):
        p = self.project(dirs=("bin", ".bundle/ruby/3.4.0/bin"))
        self.assertEqual(self.run_helper(p), [str(p / "bin"), "/usr/bin", "/bin"])

    def test_project_code_and_ruby_environment_are_not_executed(self):
        p = self.project(dirs=("bin", ".bundle/ruby/4.0.0/bin"))
        fake = p / "bin/ruby"
        fake.write_text('#!/bin/sh\ntouch "$HOME/BAD"\nexit 93\n')
        fake.chmod(0o700)
        self.run_helper(p, extra={"PATH": str(p / "bin") + ":/usr/bin:/bin",
                                  "RUBYOPT": "-rproject", "RUBYLIB": str(p)})
        self.assertFalse((self.home / "BAD").exists())

    def test_colon_directory_is_skipped(self):
        self.assertEqual(self.run_helper(self.project("colon:name")), ["/usr/bin", "/bin"])

    def test_literal_directory_names(self):
        for name in ("two words", "literal $HOME", "$(touch BAD)", "`touch BAD`", "a; touch BAD",
                     "glob[a]*?", "quotes'\"", "line\nbreak", "trailing\n\n", "café 日本語"):
            with self.subTest(name=name):
                p = self.project(name)
                self.assertEqual(self.run_helper(p), [str(p / "node_modules/.bin"), str(p / "bin"), "/usr/bin", "/bin"])
                self.assertFalse((self.home / "BAD").exists())

    def test_invalid_transport_data_leaves_path_intact(self):
        self.assertEqual(self.run_helper(self.home, extra={"_MISE_RUBY_CWD_B64": ""}), ["/usr/bin", "/bin"])
