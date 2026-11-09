"""Home runtime declarations must stay in sync."""
from pathlib import Path
import tomllib
import unittest

ROOT = Path(__file__).resolve().parents[1]


class VersionTests(unittest.TestCase):
    def test_home_versions_agree_with_mise(self):
        config = tomllib.loads((ROOT / ".config/mise/config.toml").read_text())
        legacy = {}
        for line in (ROOT / ".tool-versions").read_text().splitlines():
            if line and not line.startswith("#"):
                name, version = line.split()
                legacy[{"golang": "go"}.get(name, name)] = version
        versions = {name: value["version"] if isinstance(value, dict) else value
                    for name, value in config["tools"].items()}
        self.assertEqual(legacy, versions)
        self.assertEqual(config["tools"]["rust"]["components"], "rust-analyzer,llvm-tools")
        self.assertNotIn("java", config["tools"])
