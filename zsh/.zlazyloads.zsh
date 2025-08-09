#!/usr/bin/env zsh
# =============================================================================
# ZSH Lazy Loading Configuration
# =============================================================================
# This file implements lazy loading for development tools to improve shell
# startup performance. Tools are loaded only when first accessed.
#
# Author: Taher
# Last Updated: $(date +"%Y-%m-%d")
# =============================================================================

# =============================================================================
# HELPER FUNCTIONS
# =============================================================================

# Generic lazy loader factory
# Usage: _create_lazy_loader <tool_name> <load_function> <commands...>
_create_lazy_loader() {
  local tool_name="$1"
  local load_function="$2"
  shift 2
  local commands=("$@")
  
  for cmd in "${commands[@]}"; do
    eval "
    $cmd() {
      unset -f $cmd 2>/dev/null || true
      $load_function || return \$?
      command $cmd \"\$@\"
    }"
  done
}

# Check if a command exists and is executable
_command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# =============================================================================
# NODE.JS ECOSYSTEM (NVM)
# =============================================================================

# Node Version Manager lazy loader
__load_nvm_once() {
  # Prevent multiple loads
  [[ -n "${__NVM_LOADED:-}" ]] && return 0
  
  # Set NVM directory (user preference first, then Homebrew)
  export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
  
  # Try to load NVM from standard locations
  local nvm_script
  for nvm_script in "$NVM_DIR/nvm.sh" "/opt/homebrew/opt/nvm/nvm.sh"; do
    if [[ -s "$nvm_script" ]]; then
      # Update NVM_DIR if using Homebrew location
      [[ "$nvm_script" == "/opt/homebrew/opt/nvm/nvm.sh" ]] && export NVM_DIR="/opt/homebrew/opt/nvm"
      
      # Source the NVM script
      source "$nvm_script"
      __NVM_LOADED=1
      return 0
    fi
  done
  
  # NVM not found
  echo "⚠️  NVM not found in expected locations:" >&2
  echo "   • $HOME/.nvm/nvm.sh" >&2
  echo "   • /opt/homebrew/opt/nvm/nvm.sh" >&2
  return 127
}

# Special handling for nvm command (must use shell function, not `command nvm`)
nvm() {
  unset -f nvm 2>/dev/null
  __load_nvm_once || return $?
  nvm "$@"
}

# Create lazy loaders for Node.js ecosystem tools
_create_lazy_loader "nvm" "__load_nvm_once" node npm npx corepack pnpm yarn

# =============================================================================
# PYTHON ECOSYSTEM (PYENV)
# =============================================================================

# Python Version Manager lazy loader
__load_pyenv_once() {
  # Prevent multiple loads
  [[ -n "${__PYENV_LOADED:-}" ]] && return 0
  
  # Set PYENV root directory
  export PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"
  
  # Try to load pyenv from user installation first
  if [[ -x "$PYENV_ROOT/bin/pyenv" ]]; then
    eval "$("$PYENV_ROOT/bin/pyenv" init -)"
    __PYENV_LOADED=1
    return 0
  fi
  
  # Try Homebrew installation as fallback
  if _command_exists "/opt/homebrew/bin/pyenv"; then
    eval "$("/opt/homebrew/bin/pyenv" init -)"
    __PYENV_LOADED=1
    return 0
  fi
  
  # pyenv not found - this is not an error, just unavailable
  return 1
}

# Create lazy loaders for Python ecosystem tools
_create_lazy_loader "pyenv" "__load_pyenv_once" pyenv python python3 pip pip3

# =============================================================================
# RUBY ECOSYSTEM (RBENV)
# =============================================================================

# Ruby Version Manager lazy loader
__load_rbenv_once() {
  # Prevent multiple loads
  [[ -n "${__RBENV_LOADED:-}" ]] && return 0
  
  # Set RBENV root directory
  export RBENV_ROOT="${RBENV_ROOT:-$HOME/.rbenv}"
  
  # Try to load rbenv from user installation first
  if [[ -x "$RBENV_ROOT/bin/rbenv" ]]; then
    eval "$("$RBENV_ROOT/bin/rbenv" init - zsh)"
    __RBENV_LOADED=1
    return 0
  fi
  
  # Try Homebrew installation as fallback
  if _command_exists "/opt/homebrew/bin/rbenv"; then
    eval "$("/opt/homebrew/bin/rbenv" init - zsh)"
    __RBENV_LOADED=1
    return 0
  fi
  
  # rbenv not found - this is not an error, just unavailable
  return 1
}

# Create lazy loaders for Ruby ecosystem tools
_create_lazy_loader "rbenv" "__load_rbenv_once" rbenv ruby gem bundle

# =============================================================================
# CLEANUP
# =============================================================================

# Clean up helper functions to avoid polluting the global namespace
unset -f _create_lazy_loader _command_exists

# =============================================================================
# DEBUG INFO (uncomment for troubleshooting)
# =============================================================================
# echo "🚀 Lazy loading configuration loaded successfully"
# echo "📦 Available lazy loaders: nvm, pyenv, rbenv"
# echo "🎨 Deferred plugins: zsh-autosuggestions, zsh-syntax-highlighting"