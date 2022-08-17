# ohmyzsh configuration
ZVM_INIT_MODE=sourcing # this is important to avoid plugin keybinding conflicts
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="simple"
zstyle ':omz:update' mode reminder  # just remind me to update when it's time
zstyle ':omz:update' frequency 15
HIST_STAMPS="dd/mm/yyyy"

# some plugins requires:
# ----------------------
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# git clone https://github.com/jeffreytse/zsh-vi-mode $ZSH_CUSTOM/plugins/zsh-vi-mode
# git clone https://github.com/jscutlery/nx-completion $ZSH_CUSTOM/plugins/nx-completion
#
# vi-mode: edit with 'vv' when in NORMAL mode
plugins=(gitfast z zsh-vi-mode pass fzf zsh-autosuggestions zsh-syntax-highlighting nx-completion)

source $ZSH/oh-my-zsh.sh
export EDITOR='nvim'
export FZF_BASE=~/.fzf

# aliases
alias la='ls -la'
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
alias ssh='kitty +kitten ssh'
alias icat='kitty +kitten icat --align=left'
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

# Kitty themes
alias kitty_light="kitty @ set-colors -c ~/.config/kitty/gruvbox-material-soft-light.conf"
alias kitty_dark="kitty @ set-colors -c ~/.config/kitty/gruvbox-material-soft-dark.conf"

# Tmux
alias t="tmux -u"
alias ta="tmux -u a"
alias tls="tmux ls"
alias tks="tmux kill-session -t"

# other sources
source ~/.env_variables

# gpg
export GPG_TTY=$(tty)

# rbenv for Ruby
eval "$(rbenv init -)"
