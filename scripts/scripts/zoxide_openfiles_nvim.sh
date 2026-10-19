#!/bin/bash

# Script to find every single file and opens in neovim
# alias set as nzo in .zshrc
search_with_zoxdie() {
    if [ -z "$1" ]; then
        # use fd with fzf to select & open a file when no arg are provided
        # gitignore-aware (no -I), so node_modules and build output are skipped
        file="$(fd --type f -H -E .git -E .git-crypt -E .cache -E .backup | fzf --height=70% --preview='bat -n --color=always --line-range :500 {}')"
        if [ -n "$file" ]; then
            nvim -- "$file"
        fi
    else
        # Handle when an arg is provided: one bounded, gitignore-aware fd over the top 40 zoxide dirs.
        # Nested dirs repeat files, so awk drops duplicates. fzf opens the only match directly.
        file=$(zoxide query -l | head -n 40 | tr '\n' '\0' |
            xargs -0 fd --type f -H -E .git -E .git-crypt -E .cache -E .backup -E .vscode --max-depth 4 -- "$1" |
            awk '!seen[$0]++' |
            fzf --query="$1" --select-1 --exit-0 --height=70% --preview='bat -n --color=always --line-range :500 {}')
        rc=$?

        if [ -n "$file" ]; then
            nvim -- "$file"
        elif [ "$rc" -eq 1 ]; then
            echo "No matches found." >&2
        fi
    fi
}

search_with_zoxdie "$@"
