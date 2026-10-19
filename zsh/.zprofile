# Drop duplicate PATH/fpath entries (nested login shells re-run this file)
typeset -U path fpath

export LANG=en_US.UTF-8

# Setting Default User makes the prompt shorter
export DEFAULT_USER="$USER"

# History settings live in .zshrc (non-login shells need them too)

#Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi
export VISUAL="$EDITOR"

#---------------All Paths-------------
#export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Man Path
export MANPATH="/usr/local/man:$MANPATH"

# GNU coreutils
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"

# Add local ~/scripts to the PATH
export PATH="$HOME/scripts:$PATH"

# Mason (appended so its binaries never shadow system/brew ones; Neovim adds it itself)
export PATH="$PATH:$HOME/.local/share/nvim/mason/bin"

# Tmux
export TMUX_CONF=~/.config/tmux/tmux.conf

# Starship PATH
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

# Path to your oh-my-zsh installation.
# NOTE: using oh-my-zsh only for zsh plugins management
export ZSH="$HOME/.oh-my-zsh"

# Disabled ZSH Theme - Using Starship
# export ZSH_THEME="agnoster"

# -----------------FZF-----------------
# Set up fzf key bindings and fuzzy completion
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git "
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

export FZF_DEFAULT_OPTS="--height 50% --layout=default --border --color=hl:#2dd4bf"

# Setup fzf previews
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons=always --tree --color=always {} | head -200'"

# fzf preview for tmux
export FZF_TMUX_OPTS=" -p90%,70% "  
# --------------------------------------

export PATH="/opt/homebrew/opt/trash/bin:$PATH"

# Homebrew: static `brew shellenv` (no subprocess, and no exported FPATH;
# .zshrc sets fpath the same way for every shell)
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export MANPATH=":${MANPATH#:}"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"

export PATH="$HOME/.local/bin:$PATH"

export PATH="$PATH:${GOPATH:-$HOME/go}/bin"
