export ZSH=$HOME/.zsh/oh-my-zsh
export ZSH_THEME="imajes"

source $ZSH/oh-my-zsh.sh

# editor, stuff here should move into ohmyzshcode
export EDITOR=vim
export PATH=$HOME/.rbenv/bin:$HOME/bin:$PATH

# support rbenv
eval "$(rbenv init -)"
