# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.zsh/oh-my-zsh

# Set to the name theme to load.
# Look in ~/.oh-my-zsh/themes/
export ZSH_THEME="imajes"

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# editor, stuff here should move into ohmyzshcode
export EDITOR=vim
export PATH=$HOME/.rbenv/bin:$HOME/bin:$PATH
export RUBYOPT="rubygems"

#ruby perf
export RUBY_HEAP_MIN_SLOTS=2500000
export RUBY_HEAP_SLOTS_INCREMENT=250000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=60000000

# support rbenv
eval "$(rbenv init -)"
