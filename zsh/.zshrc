# ohmyzsh configuration
ZVM_INIT_MODE=sourcing # this is important to avoid plugin keybinding conflicts
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"
DEFAULT_USER="$(whoami)"
zstyle ':omz:update' mode reminder  # just remind me to update when it's time
zstyle ':omz:update' frequency 15
HIST_STAMPS="dd/mm/yyyy"

# some plugins should be installed manually:
# ------------------------------------------
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# git clone https://github.com/jeffreytse/zsh-vi-mode $ZSH_CUSTOM/plugins/zsh-vi-mode
# git clone https://github.com/jscutlery/nx-completion $ZSH_CUSTOM/plugins/nx-completion
# git clone https://github.com/z-shell/zi $ZSH_CUSTOM/plugins/zi
#
# vi-mode: edit with 'vv' when in NORMAL mode
plugins=(gitfast z zsh-vi-mode pass zsh-autosuggestions zsh-syntax-highlighting nx-completion)

source $ZSH/oh-my-zsh.sh
export EDITOR='nvim'
# export FZF_BASE=~/.fzf

# aliases
alias ls='exa --icons'
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
alias azcheckout='az repos pr checkout --id $(az repos pr list --output table | tail -n -2 | fzf | cut -d " " -f1)'
alias diffmain="git diff main.. | nvim - +Diffurcate '+Telescope find_files'"

# Kitty themes
alias kitty_light="kitty @ set-colors -c ~/.config/kitty/tomorrow-light.conf"
alias kitty_dark="kitty @ set-colors -c ~/.config/kitty/tomorrow-dark.conf"

# Autosuggest colour
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#666666'

# Tmux
alias t="tmux -u"
alias ta="tmux -u a"
alias tls="tmux ls"
alias tks="tmux kill-session -t"

# Neovim
alias nvim_update_plugins="nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'"

# mpd
alias mpd_cover="~/bin/mpd_cover/mpd_cover.rb"

# mpv
alias tv='mpv http://192.168.1.128:9981/playlist/channels.m3u --no-terminal'

# ctags
alias ctags_ruby='ctags --tag-relative -R --sort=yes --languages=ruby,scss,javascript --exclude=.git --exclude=log --exclude=tmp . $(bundle list --paths)'

# other sources
source ~/.env_variables

# FZF
source ~/.fzf.zsh

# az completions
source ~/.config/zsh/az.completion

# gpg
export GPG_TTY=$(tty)

# Homebrew java
export PATH="$HOME/homebrew/opt/openjdk/bin:$PATH"

# rbenv for Ruby
eval "$(rbenv init -)"
