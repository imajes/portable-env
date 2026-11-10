# Startup light/dark appearance

The default pair is **dayfox / duskfox**. All seven official Nightfox exports are
included for manual previews. See [asset provenance and checksums](../.config/bat/NIGHTFOX.md).

Install `.config/bat/`, `.config/rod/config.toml` and the Git include from
`.gitconfig`. Use a bat release that supports `--theme-light` and `--theme-dark`
(validated with 0.26.1), then run `bat cache --build` as each target account.
Delta 0.20.1 uses that cache and the seven named Git features. The cache is local
generated state; it must not be committed or copied between accounts/platforms.

The coordinated zsh change queries the attached terminal once at the first
interactive prompt through [rod](https://github.com/leiserfg/rod). It chooses
`DELTA_FEATURES=+dayfox` or `+duskfox`, preserving other features already set.
Bat detects the background itself. Neovim uses its native background detection
and the same pair. Incoming `LIGHT_MODE` is no longer the source of truth.

Ansible's narrow `lab_terminal_appearance` role can install the detector, shared
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

Continuous switching and exact Fox palette recognition are follow-up work. The
first rollout still needs an explicit remote pilot covering SSH, nested SSH,
root login/non-login shells and tmux. Local fixture success is not that pilot.
