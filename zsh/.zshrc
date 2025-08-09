eval "$(/opt/homebrew/bin/brew shellenv)"

# ---------- Completion Optimization ----------
# Skip security checking for faster startup
skip_global_compinit=1

# ---------- gdircolors (guarded) ----------
command -v gdircolors >/dev/null 2>&1 && eval "$(gdircolors)"

# ---------- Oh My Zsh ----------
export ZSH="$HOME/.oh-my-zsh"     # real path: ~/.oh-my-zsh

# set plugins BEFORE sourcing OMZ (you had it after)
plugins=(
  docker
  git
  sudo
  tnet
)

DISABLE_UNTRACKED_FILES_DIRTY="true"
ZSHZ_CASE=ignore
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 30
zstyle ':completion:*' menu select

# If you ever see compfix nags:
# export ZSH_DISABLE_COMPFIX=true
source "$ZSH/oh-my-zsh.sh"

# unbind Ctrl G
bindkey -r "^G"

# ---------- Keymaps ----------
bindkey -v
set -o vi
bindkey -M viins '^E' autosuggest-accept
bindkey -M viins '^P' up-line-or-history
bindkey -M viins '^N' down-line-or-history
bindkey -M viins 'jj' vi-cmd-mode


#----- tmux-sessionizer ------
bindkey -s ^f "$HOME/scripts/tmux-sessionizer\n"
bindkey -s ^o "$HOME/scripts/tmux-sessionizer --edit\n"

# ---------- Editor ----------
export EDITOR=nvim
export VISUAL=nvim

# ---------- Zoxide (guarded) ----------
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

# ---------- FZF (guarded) ----------
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi

# ---------- Starship (guarded) ----------
if command -v starship >/dev/null 2>&1; then
  # Keep the zle-keymap-select cleanup you had
  if [[ "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select" || \
        "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select-wrapped" ]]; then
      zle -N zle-keymap-select "";
  fi
  eval "$(starship init zsh)"
fi

# ---------- Atuin (guarded) ----------
export ATUIN_NOBIND="true"
command -v atuin >/dev/null 2>&1 && eval "$(atuin init zsh)"
bindkey '^r' atuin-up-search-viins

# ---------- Aliases / your scripts ----------
source $HOME/.zalias

source $HOME/.zlazyloads.zsh

# ---------- Lastly Loaded -------------------
# Loading zsh plugins directly as preferred
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

