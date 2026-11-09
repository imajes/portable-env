# Portable Zsh parity

The portable source uses the shared Zsh repository through `.config/zsh`.
The recorded revision contains the reviewed `cd4d12f` cleanup and the portable
compatibility changes on `codex/ansible-6r5.3-portable` (`6ee87ed`). The portable
candidate is `codex/ansible-6r5.4-parity`; neither branch changes the live shell.

## Included behavior

- Fresh mise activation per shell; completion discovery before plugins; no
  persistent cache of session PATH; no credential CLI invocation for completions.
- Reviewed history ownership, native navigation, filename-safe helpers, bounded
  job cleanup, metadata-only command supervision, and portable Zim health guidance.
- The existing `.zsh_portable-env` is now consumed before prompt/plugin setup.
  Its default is lightweight mode for portable accounts, including local consoles.
- One static PATH pass discovers existing user tools on Linux and macOS, before
  plugins and mise activation. XDG_CONFIG_HOME and explicit GOPATH are respected.
  Homebrew paths and OrbStack setup are macOS-specific; ls uses platform options.

`ZSH_PORTABLE_MODE` choices are `0` (full UI), `1` (lightweight UI), or `auto`
(SSH/container/CI detection). Portable accounts default to `1`; an explicit value
wins. Unrecognized values safely use automatic detection. Lightweight mode disables
gitstatus, syntax highlighting and autosuggestions and enables the reviewed remote
directory reporting hooks where the terminal supports them.

## Runtime configuration

The portable mise tool selection stays portable: Node 24, latest Ruby/Go/Lua/Python/
Rust/uv, with the existing Rust components. No personal Java or credential settings
are imported. The linked home `.tool-versions` remains present for the existing
Ansible layout and agrees with these versions, instead of requesting Ruby 3 and
Node LTS independently. Projects can still select their own runtime versions.

Ruby project-bin activation remains disabled. The obsolete `env-ruby.zsh` has been
replaced by the same `env-ruby.bash` used in the reviewed personal fix. The commented
example in `.config/mise/config.toml` shows both ordered env blocks required to enable
it. Directory names cross the template boundary as base64 data; only existing bins
are added, and Bundler bins must match the selected Ruby ABI. Ruby detection does
not execute a Gemfile or discover Ruby through a project-controlled PATH.

Enabling that example is a separate behavior choice. At that point, verify actual
mise entry/exit transitions and the installed Ruby versions as well as these tests.

## Quick test guide

Requires Python 3.11+ and Zsh. From this worktree, run:

```sh
python3 -m unittest discover -s tests -v
python3 -m unittest discover -s .config/zsh/tests -v
shellcheck .config/mise/scripts/env-ruby.bash
```

To exercise both installed Mac interpreters:

```sh
ZSH_TEST_SHELL=/bin/zsh BASH_TEST_SHELL=/bin/bash python3 -m unittest discover -s tests -v
ZSH_TEST_SHELL=/bin/zsh python3 -m unittest discover -s .config/zsh/tests -v
ZSH_TEST_SHELL=/opt/homebrew/bin/zsh BASH_TEST_SHELL=/opt/homebrew/bin/bash python3 -m unittest discover -s tests -v
ZSH_TEST_SHELL=/opt/homebrew/bin/zsh python3 -m unittest discover -s .config/zsh/tests -v
```

These are targeted regression tests with temporary filesystem fixtures. They do
not install tools, source a private `.env_local`, invoke credential services, or
contact Ansible hosts. The Ruby ABI tests use a controlled interpreter fixture.
The shared Zsh tests exercise Linux policy branches on the current host; a native
Linux session with the full plugin graph is separate acceptance work.

The recorded checks for this candidate passed 11 portable tests and 13 shared Zsh
tests on each interpreter pair, ShellCheck, and parsing of 39 retained Zsh sources
under both Zsh versions. An additional 27 existing zsh-lab helper/navigation/job/
command-supervision regressions passed per Zsh against the selected shared source.
This is narrower than the previous full 99-test personal lab run.

After an eventual candidate installation, open a fresh shell and run:

```zsh
print -r -- "HOME=$HOME" "ZDOTDIR=$ZDOTDIR" "portable=$ZSH_PORTABLE_MODE"
print -rl -- $path
whence -a git mise ruby node python3 cargo atuin
```

Check the expected account/tools, Tab completion, Ctrl-R and Up/Down history.
Enter and leave a versioned project and open a nested shell. Compare
`ZSH_PORTABLE_MODE=0 zsh` and `ZSH_PORTABLE_MODE=1 zsh`.

## Review and promotion

Review the shared branch against `cd4d12f` and this branch against `6503a4f` using
`git diff --submodule=log`. Publish the shared Zsh commits before publishing a
portable commit that references them; until then, the new gitlink is local-only.
No push, merge, live-shell promotion or host deployment is part of this change.

The legacy Ansible role's destructive-update fixes and a disposable Linux deployment
rehearsal remain deferred under `ansible-6r5.2` and `ansible-6r5.5`. The independent
chezmoi worktree is unchanged. Avoid bulk `just sync` for this promotion: it copies
personal configuration beyond the selected portable changes.
