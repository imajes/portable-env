"""Portable tab behavior using the real Lua module and a minimal WezTerm API stub."""
from pathlib import Path
import shutil
import subprocess
import unittest

ROOT = Path(__file__).resolve().parents[1]


@unittest.skipUnless(shutil.which("lua"), "Lua required")
class Wezterm(unittest.TestCase):
    def test_remote_context_and_application_titles(self):
        code = r'''
package.path = "./.config/wezterm/?.lua;" .. package.path
package.preload.wezterm = function()
  return {
    home_dir = "/home/fixture",
    hostname = function() return "local-host" end,
    url = { parse = function(s)
      local host, path = s:match("^file://([^/]*)(/.*)$")
      if not host then error("invalid URL") end
      return { host = host, file_path = path }
    end },
  }
end
local module = require("smart_tab_title")
local function title(proc, cwd, fallback)
  return module.format_tab_title({active_pane={foreground_process_name=proc,
    current_working_dir=cwd, title=fallback or "terminal"}}, {}, {}, {}, false, 80)
end
assert(title("/bin/ssh", "file://remote.example/work/project") == " remote: work/project ")
assert(title("/bin/zsh", "file://remote.example/work/project", "local shell") == " local shell ")
assert(title("/bin/codex", "file://local-host/home/fixture/project", "Working on tests") == " Working on tests ")
assert(title("/bin/zsh", {host="local-host",file_path="/home/fixture/work/project"}) == " work/project ")
assert(title("/bin/ssh", "invalid URL") == " terminal ")
'''
        run = subprocess.run(["lua", "-"], input=code, cwd=ROOT, text=True, capture_output=True, timeout=10)
        self.assertEqual(run.returncode, 0, run.stderr)


if __name__ == "__main__":
    unittest.main()
