export LANG=en_US.UTF-8

# Setting Default User makes the prompt shorter 
export DEFAULT_USER="$USER"

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=200000
export SAVEHIST=200000
setopt APPEND_HISTORY INC_APPEND_HISTORY SHARE_HISTORY

#Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

#---------------All Paths-------------
#export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Man Path
export MANPATH="/usr/local/man:$MANPATH"

# GNU coreutils
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"

# ZSH
export ZSH="$HOME/.oh-my-zsh"

# Add local ~/scripts to the PATH
export PATH="$HOME/scripts:$PATH"

# Mason
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"

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

fpath=(/Users/taher/.docker/completions $fpath)
