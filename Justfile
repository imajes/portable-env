# Defaults; override per-run with:
#   just --set FOLDERS ".config/nvim .ssh" sync
DEFAULT_FOLDERS := ".config/bat .config/neovide .config/wezterm .config/atuin .config/gh .config/mise .config/husky .config/yarn .config/wandb .pryrc .npmrc .default-gems .gemrc .gitconfig .gitignore_global .irbrc .cargo bin"

sync:
    @set -euo pipefail
    @folders="${FOLDERS:-{{DEFAULT_FOLDERS}}}"; \
    for p in $folders; do \
      echo "Syncing $p"; \
      src="$HOME/$p"; \
      dest="./$p"; \
      if [ ! -e "$src" ]; then echo "Skip $p (no such path)"; continue; fi; \
      if [ -d "$src" ]; then \
        mkdir -p "$dest"; \
        rsync -aH --delete "$src"/ "$dest"/; \
      else \
        mkdir -p "$(dirname "$dest")"; \
        rsync -aH --delete "$src" "$dest"; \
      fi; \
    done
