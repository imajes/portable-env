# shellcheck shell=bash
# Sourced by mise's env._.source (Bash, including macOS Bash 3.2).
# Only PATH is changed; mise owns activation and removal of these prepends.

_mise_ruby_project_path() {
  local encoded=${_MISE_RUBY_CWD_B64-} project bundle='' candidate
  local install_encoded=${_MISE_RUBY_INSTALL_B64-} install='' abi=''
  local -a entries=()
  local LC_ALL=C IFS=:
  unset _MISE_RUBY_CWD_B64 _MISE_RUBY_INSTALL_B64
  [[ -n $encoded ]] || return 0

  # The sentinel preserves trailing newlines in directory names.
  project=$(printf '%s' "$encoded" | /usr/bin/base64 --decode && printf '/') || return
  project=${project%/}
  # PATH cannot represent a directory containing its ':' separator.
  [[ $project == /* && $project != *:* ]] || return 0

  if [[ ! -f $project/Gemfile && ! -d $project/.bundle && ! -f $project/.ruby-version ]]; then
    return 0
  fi

  # mise supplies the selected installation after resolving project tools.
  # Do not discover ruby through PATH (which can contain project executables),
  # evaluate a Gemfile, or load RUBYOPT/RUBYLIB while inspecting the ABI.
  if [[ -d $project/.bundle/ruby && -n $install_encoded ]]; then
    install=$(printf '%s' "$install_encoded" | /usr/bin/base64 --decode && printf '/') || install='/'
    install=${install%/}
    if [[ $install == /* && -x $install/bin/ruby ]]; then
      abi=$(/usr/bin/env -u RUBYOPT -u RUBYLIB "$install/bin/ruby" --disable-gems \
        -rrbconfig -e 'print RbConfig::CONFIG.fetch("ruby_version")' 2>/dev/null) || abi=''
      if [[ $abi =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        bundle="$project/.bundle/ruby/$abi/bin"
      fi
    fi
  fi

  for candidate in "$project/node_modules/.bin" "$bundle" "$project/bin"; do
    [[ -d $candidate ]] && entries+=("$candidate")
  done
  (( ${#entries[@]} )) || return 0
  export PATH="${entries[*]}${PATH:+:$PATH}"
}

_mise_ruby_project_path
unset -f _mise_ruby_project_path
