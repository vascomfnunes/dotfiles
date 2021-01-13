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

export TERM='xterm-256color'

## Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
	print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
	command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
	command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
		print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
		print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
# End of Zinit's installer chunk

zinit light zdharma/fast-syntax-highlighting
zinit light zsh-users/zsh-history-substring-search
zinit light zsh-users/zsh-autosuggestions
zinit wait lucid atload"zicompinit; zicdreplay" blockf for \
	zsh-users/zsh-completions
	zinit wait lucid atload'_zsh_autosuggest_start' light-mode for \
		zsh-users/zsh-autosuggestions

# This needs to come first to use homebrew packages over system ones
export PATH="/usr/local/bin:$PATH"

# Add clangd to the path so c compilers can find it
export PATH="/usr/local/opt/llvm/bin:$PATH"

# openssl libraries
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"
export LIBRARY_PATH="$LIBRARY_PATH:/usr/local/opt/openssl/lib/"
export PATH="/usr/local/opt/node@12/bin:$PATH"

# Jira env variables
source ~/.jira_conf

function set_win_title(){
	print -Pn "\e]0;%~\a"
}

precmd_functions+=(set_win_title)

################################################################################
#                             Options
################################################################################

setopt prompt_subst
setopt autocd		# automatically cd into typed directory.
stty stop undef		# disable ctrl-s to freeze terminal.
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
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.

## Use beam shape cursor on startup.
echo -ne '\e[5 q'

## Use beam shape cursor for each new prompt.
preexec() { echo -ne '\e[5 q' ;}

# Preferred editor for local and remote sessions
# export EDITOR="$HOME/bin/nvim/bin/nvim"
export EDITOR="/usr/local/bin/vim"

# Use nvim as manpager `:h Man`
# export MANPAGER="$HOME/bin/nvim/bin/nvim +Man!"
export MANPAGER="/usr/local/bin/vim +Man!"

# Function to kill all running processes using a specific port
function killport() {
	lsof -i TCP:$1 | grep LISTEN | awk '{print $2}' | xargs kill -9
}

# Autojump
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# Fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#===============================================================================
#                             Sources
#===============================================================================

source ~/.aliases
source /usr/local/share/zsh/site-functions

#===============================================================================
#                             Completion
#===============================================================================

zstyle ":completion:*:git-checkout:*" sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu select
zmodload zsh/complist
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*' # case insensitive

# Vi mode
bindkey -v

# Use vim keys in tab complete menu:
bindkey -v '^?' backward-delete-char
# use the vi navigation keys in menu completion
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# history substring function
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
bindkey '^[[Z' reverse-menu-complete # fix reverse menu
bindkey '^[[P' delete-char

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Change cursor shape for different vi modes.
function zle-keymap-select {
	if [[ ${KEYMAP} == vicmd ]] ||
		[[ $1 = 'block' ]]; then
			echo -ne '\e[1 q'
		elif [[ ${KEYMAP} == main ]] ||
			[[ ${KEYMAP} == viins ]] ||
			[[ ${KEYMAP} = '' ]] ||
			[[ $1 = 'beam' ]]; then
					echo -ne '\e[5 q'
	fi
}
zle -N zle-keymap-select
zle-line-init() {
echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # use beam shape cursor for each new prompt.

# Set autosuggestions color
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'

# Rbenv
export PATH="$HOME/.rbenv/bin:$HOME/bin:$PATH"
eval "$(rbenv init -)"

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
