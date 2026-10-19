# Drop duplicate PATH/fpath entries (nested shells re-add them)
typeset -U path fpath

# ---------- History ----------
# Not exported, so child bash shells keep their own history file
HISTFILE="$HOME/.zsh_history"
HISTSIZE=200000
SAVEHIST=200000
setopt SHARE_HISTORY HIST_IGNORE_SPACE

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

zstyle ':omz:update' mode reminder   # update by hand with `omz update`
zstyle ':omz:update' frequency 30
zstyle ':completion:*' menu select

# Same fpath in login and non-login shells, so OMZ keeps one completion dump
fpath=(/opt/homebrew/share/zsh/site-functions $HOME/.docker/completions $fpath)

# If you ever see compfix nags:
# export ZSH_DISABLE_COMPFIX=true
source "$ZSH/oh-my-zsh.sh"

# ---------- Keymaps ----------
bindkey -v
# unbind Ctrl G (in the vi keymaps, so after bindkey -v)
bindkey -M viins -r '^G'
bindkey -M vicmd -r '^G'
bindkey -M viins '^E' autosuggest-accept
bindkey -M viins '^P' up-line-or-history
bindkey -M viins '^N' down-line-or-history
bindkey -M viins 'jj' vi-cmd-mode
KEYTIMEOUT=20   # 0.2s wait after `j` for `jj` (default 0.4s)


#----- tmux-sessionizer ------
bindkey -s ^f "$HOME/scripts/tmux-sessionizer\n"
bindkey -s ^o "$HOME/scripts/tmux-sessionizer --edit\n"

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
if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh)"
  bindkey -M viins '^r' atuin-search-viins
  bindkey -M vicmd '^r' atuin-search-vicmd
fi

# ---------- Aliases / your scripts ----------
source $HOME/.zalias

source $HOME/.zlazyloads.zsh

# ---------- Lastly Loaded -------------------
# Loading zsh plugins directly as preferred
source "${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"


# pnpm
export PNPM_HOME="/Users/taher/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Kiro shell integration; the path is cached (the kiro CLI takes 160-460ms)
if [[ "$TERM_PROGRAM" == "kiro" ]]; then
  _kiro_si="$HOME/.cache/kiro-zsh-si"
  [[ -r "$_kiro_si" && -r "$(<$_kiro_si)" ]] || kiro --locate-shell-integration-path zsh >| "$_kiro_si"
  . "$(<$_kiro_si)"
  unset _kiro_si
fi
