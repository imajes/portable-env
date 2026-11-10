# Deployment integration for the reviewed source sync

The legacy dotfiles role is retired from the active Ansible entrypoints. Do not
reactivate it to deploy the new preferences. The separate native chezmoi workstream
owns full environment deployment; the scoped terminal appearance playbook installs
only the terminal detector, shell hooks and Fox assets for explicitly selected accounts.

The following newly selected preferences need these native source mappings when
that candidate consumes this source revision:

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

The native appearance asset mapping is `home/dot_config/bat` and
`home/dot_config/rod`; Git includes `~/.config/bat/nightfox.gitconfig`. Rebuild bat
caches as each account using a version with paired light/dark theme support.
These files are configuration, not application installation instructions.

Publish source commits before any parent commit that references them. Before a
public push, resolve the existing tracked GnuPG material review separately.
A live pilot requires an explicit host limit and selected user/root accounts.
