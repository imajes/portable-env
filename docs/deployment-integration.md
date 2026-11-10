# Deployment integration for the reviewed source sync

The repaired Ansible dotfiles role supports this repository layout directly. Its
explicit `bin/lab dotfiles --limit HOST` operation updates each selected account's
checkout in place, backs up replaced managed config, preserves runtime/auth/history
state, and composes the terminal appearance role and per-account theme caches.
The seven preferences below are included in its reviewed selection. A matching
controller checkout and immutable portable source revision are required.

The native chezmoi experiment remains optional and independently owned. If that
candidate is adopted later, these are its corresponding source mappings:

| Current source | Native chezmoi source | Installed destination |
| --- | --- | --- |
| `.gitattributes` | `home/dot_gitattributes` | `~/.gitattributes` |
| `.markdownlint.jsonc` | `home/dot_markdownlint.jsonc` | `~/.markdownlint.jsonc` |
| `.shellcheckrc` | `home/dot_shellcheckrc` | `~/.shellcheckrc` |
| `.tidyrc` | `home/dot_tidyrc` | `~/.tidyrc` |
| `.config/aprc` | `home/dot_config/aprc` | `~/.config/aprc` |
| `.config/htop/htoprc` | `home/dot_config/htop/htoprc` | `~/.config/htop/htoprc` |
| `.config/mdcat/config.toml` | `home/dot_config/mdcat/config.toml` | `~/.config/mdcat/config.toml` |

Also update `home/dot_gitignore_global`, the selected Git settings, shared WezTerm
and Neovide preferences, and the reviewed zsh/Neovim source revisions. The shell
startup fix must be included in the zsh revision. Keep the native candidate's
source layout and profile policy; do not overlay this repository root wholesale.

For the optional migration, the native appearance asset mapping is `home/dot_config/bat` and
`home/dot_config/rod`; Git includes `~/.config/bat/nightfox.gitconfig`. Rebuild bat
caches as each account using a version with paired light/dark theme support.
These files are configuration, not application installation instructions.

Publish source commits before any parent commit that references them. Before a
public push, resolve the existing tracked GnuPG material review separately.
A live pilot requires an explicit host limit and selected user/root accounts.
