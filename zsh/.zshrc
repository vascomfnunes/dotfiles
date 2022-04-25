# ohmyzsh configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="simple"
zstyle ':omz:update' mode reminder  # just remind me to update when it's time
zstyle ':omz:update' frequency 15
HIST_STAMPS="dd/mm/yyyy"
plugins=(gitfast z vi-mode)
source $ZSH/oh-my-zsh.sh
bindkey "^R" history-incremental-search-backward

# aliases
alias e='nvim'
alias c='clear'
alias :q='exit'
alias df='df -h'
alias cat='bat'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias diff='diff --color=auto'
alias grep="grep --color=auto --exclude-dir={.git,artwork,node_modules,vendor}"
alias ssh='TERM=xterm-256color ssh'
# alias ctags="/usr/local/bin/ctags -R --options=$HOME/.ctags --languages=Ruby,RSpec,JavaScript,CSS,SCSS . $(bundle list --paths)"
alias rspec='rspec -f d'
alias music='ncmpcpp'

# Git
alias gP="git push"
alias gc="git commit"
alias gf="git fetch"
alias gp="git pull"
alias gr="git restore"
alias gco="git checkout"
alias gb="git branch"
alias gs="git status"
alias gl='git log'
alias ga="git add"
alias gd="git diff"

# Tmux
alias t="tmux -u"
alias ta="tmux -u a"
alias tls="tmux ls"
alias tks="tmux kill-session -t"

# other sources
source ~/.config/zsh/env_variables

# gpg
export GPG_TTY=$(tty)

# rbenv for Ruby
eval "$(rbenv init -)"
