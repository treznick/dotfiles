export ZSH=$HOME/.oh-my-zsh
export ZSH_CUSTOM=$HOME/.oh-my-zsh-custom
export ZSH_THEME="dracula"
plugins=(git ruby vi-mode macos gem bundler)
bindkey -M vicmd 'v' edit-command-line
##
export LC_ALL=en_US.UTF-8
##
###disable ctrl-s/suspension
stty stop undef
setopt NO_FLOW_CONTROL
setopt magicequalsubst
setopt interactivecomments
unsetopt BEEP
bindkey '^R' history-incremental-search-backward
autoload -U zrecompile
##
alias vi='vim'

alias openwork='vim -p $(git ls-files -m) $(git ls-files --others --exclude-standard)'
##
PATH=$PATH:$HOME/bin # Make personal scripts available
PATH=$PATH:$HOME/.bin # Make dotfiles scripts available
#
## Allow for local environment configuration in ~/.zsh/*.zsh

source "$HOME/.vi-everywhere/bash.d/init.sh"
#bindkey -v
#if [ -d ~/.zsh ]; then
#  for config_file (~/.zsh/*.zsh); do
#    source $config_file
#  done
#fi
##
export ZSH_THEME="dracula"
##
### Prevent warnings if the user has not set up a tmux user.conf file
if [ ! -f "$HOME/.tmux/user.conf" ]; then
  touch $HOME/.tmux/user.conf
fi
source $ZSH/oh-my-zsh.sh
source ~/.zsh/local.zsh
