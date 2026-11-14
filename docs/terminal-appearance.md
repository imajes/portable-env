# Automatic light/dark appearance

The default pair is **dayfox / duskfox**. All seven official Nightfox exports are
included for manual previews. See [asset provenance and checksums](../.config/bat/NIGHTFOX.md).

Install `.config/bat/`, `.config/rod/config.toml` and the Git include from
`.gitconfig`. Use a bat release that supports `--theme-light` and `--theme-dark`
(validated with 0.26.1), then run `bat cache --build` as each target account.
Delta 0.20.1 uses that cache and the seven named Git features. The cache is local
generated state; it must not be committed or copied between accounts/platforms.

The coordinated shell change initializes the first interactive prompt through
[rod](https://github.com/leiserfg/rod), then follows terminal change notifications
while the line editor is active. It chooses
`DELTA_FEATURES=+dayfox` or `+duskfox`, preserving other features already set.
Bat detects the background itself. Neovim uses its native background detection
and the same pair. Incoming `LIGHT_MODE` is no longer the source of truth.

WezTerm loads `.config/wezterm/terminal-appearance.lua`, which sends the standard
light/dark report to subscribed panes on palette changes, including inactive tabs.
Zsh consumes the report as an editor event and repaints an existing suggestion
without changing typed text. Bash 4.4+ uses Readline and PS0 for the same lifecycle.
Each shell stops notifications before launching a command and requests current
state when its prompt returns. There is no periodic terminal reader or shared
host-wide appearance flag. The existing index90/index228 suggestion colors remain.

For tmux 3.6+, `.config/tmux/tmux.conf` loads the source's client hooks. An existing
`~/.tmux.conf` takes precedence over that XDG file: include
`source-file -q ~/.config/zsh/libexec/terminal-appearance.tmux` in the active config
when retaining an existing tmux setup. The scoped host pilot must inspect this
precedence and the installed tmux version. A standalone appearance deployment
that does not install the full Zsh source also needs the tmux snippet installed
and included explicitly. Terminals with native mode2031 support need no Lua adapter.

Ansible's explicit dotfiles operation deploys the full reviewed configuration using
the repaired Git/symlink role, then composes the appearance installation and caches.
It does not require chezmoi. Its narrow `lab_terminal_appearance` role can also
independently install the detector, shared
shell hooks and this small file allowlist for selected Linux accounts, including
root. SSH and `sudo su` reuse the terminal; each new interactive shell detects it
again. No private SSH forwarding policy or sudoers changes are needed.

Rod 0.1.13 has an official Linux x86_64 release. Other architectures can build its
pinned, locked source with Rust 1.85 or newer. Rod's fallback is configured as
light. Its macOS config location is `~/Library/Application Support/rod/config.toml`;
copy the same public `.config/rod/config.toml` there when installing on macOS.

## Integration boundaries

The source checkout currently uses `.config/` and a root `.gitconfig`. If the
parallel native chezmoi migration lands first, move these appearance changes to
`home/dot_config/{bat,rod}` and the include to `home/dot_gitconfig`. The installed
paths remain unchanged. Ansible accepts an explicit asset source directory, so
it can consume either `.config` or `home/dot_config`.

The gitlinks select reviewed source commits, including the coordinated portable
zsh policy and first-editable-prompt initialization fix. Publish any new source
commits before publishing this parent revision so other machines can fetch them.
Future source updates follow the same source-first review order.
No agent configuration, credentials, history, or private machine settings are
part of this appearance slice.

## Validation

```sh
python3 -m unittest discover -s tests -v
```

Tests verify all seven original theme hashes and parse their XML, build a temporary
bat cache and render with bat and delta. They use a temporary HOME and Git config.
The official XML exports contain stale display names, so rendered palette colors
and light/dark diff backgrounds are more useful checks than delta's display name.

Exact Fox palette recognition remains follow-up work. The
first rollout still needs an explicit remote pilot covering SSH, nested SSH,
root login/non-login shells and tmux. Local fixture success is not that pilot.
