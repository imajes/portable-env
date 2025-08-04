# shellcheck shell=sh

# Only run in "Ruby-looking" directories
if [[ ! -f "$1/Gemfile" && ! -d "$1/.bundle" && ! -f "$1/.ruby-version" ]]; then
  echo "" # to ensure the script meets the interface.
  exit 0
fi

# Compute last matching bundler bin dir (Ruby 3.x) and export it as a PATH segment
if compgen -G "$1/.bundle/ruby/3*/bin" >/dev/null; then
  BUNDLE_BIN_PATH="$(command ls -d $1/.bundle/ruby/3*/bin 2>/dev/null | tail -n1)"
fi

# Local project paths (prepend, preserve existing PATH)
echo "$1/node_modules/.bin:$BUNDLE_BIN_PATH:$1/bin"
