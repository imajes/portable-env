#!/usr/bin/env zsh
set -euo pipefail

# Usage:
#   gen-rust-log.zsh [PATH=. ] [CRATE_LEVEL=trace] [BASE_LEVEL=warn]
BASE_PATH=${1:-.}
CRATE_LEVEL=${2:-trace}
BASE_LEVEL=${3:-warn}

typeset -a targets

# Find Cargo.toml files under subdirectories (not the root), skipping tests/target
while IFS= read -r -d '' toml; do
  # Extract [package] name without fancy regex (portable to BSD awk)
  name=$(/usr/bin/awk '
    BEGIN { inpkg=0 }
    /^[[:space:]]*\[package][[:space:]]*$/ { inpkg=1; next }
    /^[[:space:]]*\[/ { if (inpkg) exit; next }
    inpkg && $0 ~ /^[[:space:]]*name[[:space:]]*=/ {
      # strip trailing comments
      sub(/[[:space:]]*#.*/, "", $0)
      # split on first "="
      n = split($0, a, "=")
      v = a[n]
      # trim surrounding whitespace
      sub(/^[[:space:]]+/, "", v)
      sub(/[[:space:]]+$/, "", v)
      # strip single or double quotes
      if (v ~ /^"/)  { sub(/^"/, "", v); sub(/"$/, "", v) }
      else if (v ~ /^'\''/) { sub(/^'\''/, "", v); sub(/'\''$/, "", v) }
      print v
      exit
    }
  ' "$toml")

  [[ -n "${name:-}" ]] || continue
  targets+="${name//-/_}"   # hyphen → underscore for RUST_LOG targets
done < <(find "$BASE_PATH" -mindepth 1 -type f -name Cargo.toml \
          -not -path "*/target/*" \
          -not -path "*/tests/*" \
          -not -path "*/test/*" -print0)

# De-duplicate, preserve order
typeset -A seen; typeset -a uniq
for t in $targets; do
  [[ -n ${seen[$t]:-} ]] && continue
  seen[$t]=1
  uniq+=$t
done

# Build the export line
logspec=$BASE_LEVEL
for t in $uniq; do
  logspec+=",${t}=${CRATE_LEVEL}"
done

print "${logspec}"
