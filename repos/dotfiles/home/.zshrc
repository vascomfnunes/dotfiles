#!/usr/bin/env zsh

#          _
#  _______| |__  _ __ ___
# |_  / __| '_ \| '__/ __|
#  / /\__ \ | | | | | (__
# /___|___/_| |_|_|  \___|

# /*********************************************
# * Description - zsh configuration file
# * Author - Vasco Nunes <contact@vasco.dev>
# * Creation Date - Nov 24 2020
# * *******************************************/

# This needs to come first to use homebrew packages over system ones
export PATH="/usr/local/bin:$PATH"

# Add clangd to the path so c compilers can find it
export PATH="/usr/local/opt/llvm/bin:$PATH"

# bat colour theme
export BAT_THEME="base16"

# openssl libraries
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"
export LIBRARY_PATH="$LIBRARY_PATH:/usr/local/opt/openssl/lib/"
export PATH="/usr/local/opt/node@12/bin:$PATH"

# Jira env variables
source ~/.jira_conf

autoload -Uz compinit
compinit

setopt promptsubst

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

################################################################################
#                             Options
################################################################################

setopt prompt_subst
setopt always_to_end
setopt append_history
setopt auto_menu
setopt complete_in_word
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt interactivecomments
setopt share_history
setopt complete_aliases
setopt autocd
unsetopt beep

################################################################################
#                             Misc
################################################################################

# History settings
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
CASE_SENSITIVE='false'

## Use beam shape cursor on startup.
echo -ne '\e[5 q'

## Use beam shape cursor for each new prompt.
preexec() { echo -ne '\e[5 q' ;}

# Preferred editor for local and remote sessions
export EDITOR='$HOME/bin/nvim/bin/nvim'

# Use nvim as manpager `:h Man`
export MANPAGER='$HOME/bin/nvim/bin/nvim +Man!'

# Function to kill all running processes using a specific port
function killport() {
  lsof -i TCP:$1 | grep LISTEN | awk '{print $2}' | xargs kill -9
}

# Autojump
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# Fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# enable vim mode on commmand line
bindkey -v

# edit command with editor
# usage: type something then hit Esc+v
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

#===============================================================================
#                             Sources
#===============================================================================

source ~/.aliases
source /usr/local/share/zsh/site-functions

#===============================================================================
#                             Completion
#===============================================================================

# fzf-tab (https://github.com/Aloxaf/fzf-tab)
source ~/.fzf-tab/fzf-tab.plugin.zsh
zstyle ":completion:*:git-checkout:*" sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'

# Auto suggestions

source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Set autosuggestions color
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'

# Rbenv
export PATH="$HOME/.rbenv/bin:$HOME/bin:$PATH"
eval "$(rbenv init -)"

# Rubocop daemon wrapper
# export PATH="/usr/local/bin/rubocop-daemon-wrapper:$PATH"

# For GPG
export GPG_TTY=$(tty)

#===============================================================================
#                             Prompt
#===============================================================================

autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' on  %b'

PROMPT='
%F{red} $(rbenv version-name) %F{green} %1d%F{yellow}${vcs_info_msg_0_}%f%{$reset_color%}
$ '
