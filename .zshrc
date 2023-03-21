zmodload zsh/zprof

# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh
export ZSH_HOME=$HOME/.oh-my-zsh

# Set to the name theme to load.
# Look in ~/.oh-my-zsh/themes/
export ZSH_THEME="sorin"

source $ZSH/oh-my-zsh.sh

# use zsh sqlite history
export HISTDB_TABULATE_CMD=(sed -e $'s/\x1f/\t/g')
source $ZSH_CUSTOM/plugins/zsh-histdb/sqlite-history.zsh
autoload -Uz add-zsh-hook

# use evalcache
source $ZSH_CUSTOM/plugins/evalcache/evalcache.plugin.zsh

plugins=(
  1password
  ansible
  aws
  colorize
  direnv
  docker
  docker-compose
  dotenv
  evalcache
  fzf
  github
  golang
  heroku
  python
  rails
  ruby
  volta
)

source $HOME/.zshrc-extras

export NVIM_RUBY_LOG_FILE=$HOME/local/nvim_ruby.log
export NVIM_RUBY_LOG_LEVEL=debug

alias python=python3

export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

_evalcache direnv hook zsh

alias cat=bat
alias less=bat
alias nxt=.bundle/gems/next_rails-1.1.0/exe/next.sh
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
