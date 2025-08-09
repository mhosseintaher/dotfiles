# Neovim Keybinds Reference

This document contains all keybinds configured in your Neovim setup, organized by mode and sorted alphabetically.

## Leader Key
- **Leader**: `<Space>` (Space key)
- **Local Leader**: `<Space>` (Space key)

## 🚨 **DUPLICATE/CONFLICTING KEYBINDS** 🚨

| Keybind | Plugin/File | Action | Conflict |
|---------|-------------|--------|----------|
| `<leader>gs` | vim-fugitive | Git status | ⚠️ **CONFLICT** |
| `<leader>gs` | gitsigns | Stage hunk | ⚠️ **CONFLICT** |
| `<C-h>` | core/keymaps | Focus left window | ⚠️ **CONFLICT** |
| `<C-h>` | harpoon | Select harpoon file 1 | ⚠️ **CONFLICT** |
| `<C-h>` | lspconfig (insert) | LSP signature help | ⚠️ **CONFLICT** |
| `<C-k>` | core/keymaps | Focus upper window | ⚠️ **CONFLICT** |
| `<C-k>` | nvim-cmp (insert) | Previous completion item | ⚠️ **CONFLICT** |
| `<C-k>` | telescope (insert) | Move selection previous | ⚠️ **CONFLICT** |
| `<C-j>` | core/keymaps | Focus lower window | ⚠️ **CONFLICT** |
| `<C-j>` | nvim-cmp (insert) | Next completion item | ⚠️ **CONFLICT** |
| `<C-j>` | telescope (insert) | Move selection next | ⚠️ **CONFLICT** |
| `<C-f>` | core/keymaps | TMux sessionizer | ⚠️ **CONFLICT** |
| `<C-f>` | nvim-cmp (insert) | Scroll docs down | ⚠️ **CONFLICT** |
| `<C-d>` | core/keymaps | Move down with cursor centered | ⚠️ **CONFLICT** |
| `<C-d>` | nvim-cmp (insert) | Close completion docs | ⚠️ **CONFLICT** |
| `<C-e>` | harpoon | Toggle harpoon menu | ⚠️ **CONFLICT** |
| `<C-e>` | nvim-cmp (insert) | Abort completion | ⚠️ **CONFLICT** |
| `<leader>d` | core/keymaps | Delete without yanking | ⚠️ **CONFLICT** |
| `<leader>d` | lspconfig | Show line diagnostics | ⚠️ **CONFLICT** |
| `<leader>p` | core/keymaps (visual) | Paste without yanking | ⚠️ **CONFLICT** |
| `<leader>p` | vim-fugitive (fugitive buffer) | Git pull --rebase | ⚠️ **CONFLICT** |

---

## Normal Mode Keybinds

| Keybind | Plugin/File | Action | Description |
|---------|-------------|--------|-------------|
| `[h` | gitsigns | `gs.prev_hunk` | Previous git hunk |
| `[t` | todo-comments | `todo_comments.jump_prev()` | Previous todo comment |
| `]h` | gitsigns | `gs.next_hunk` | Next git hunk |
| `]t` | todo-comments | `todo_comments.jump_next()` | Next todo comment |
| `<C-d>` | core/keymaps | `<C-d>zz` | Move down with cursor centered |
| `<C-f>` | core/keymaps | `<cmd>!tmux neww tmux-sessionizer<CR>` | Start new tmux session |
| `<C-h>` | core/keymaps | `<C-w><C-h>` | Focus left window |
| `<C-h>` | harpoon | `harpoon:list():select(1)` | Select harpoon file 1 |
| `<C-j>` | core/keymaps | `<C-w><C-j>` | Focus lower window |
| `<C-k>` | core/keymaps | `<C-w><C-k>` | Focus upper window |
| `<C-l>` | core/keymaps | `<C-w><C-l>` | Focus right window |
| `<C-n>` | harpoon | `harpoon:list():select(3)` | Select harpoon file 3 |
| `<C-p>` | telescope | `builtin.git_files` | Git files |
| `<C-s>` | harpoon | `harpoon:list():select(4)` | Select harpoon file 4 |
| `<C-S-N>` | harpoon | `harpoon:list():next()` | Next harpoon file |
| `<C-S-P>` | harpoon | `harpoon:list():prev()` | Previous harpoon file |
| `<C-space>` | treesitter | init_selection | Init treesitter selection |
| `<C-t>` | harpoon | `harpoon:list():select(2)` | Select harpoon file 2 |
| `<C-u>` | core/keymaps | `<C-u>zz` | Move up with cursor centered |
| `<down>` | core/keymaps | `<cmd>echo "Use j to move!!"<CR>` | Disabled - use j |
| `<left>` | core/keymaps | `<cmd>echo "Use h to move!!"<CR>` | Disabled - use h |
| `<right>` | core/keymaps | `<cmd>echo "Use l to move!!"<CR>` | Disabled - use l |
| `<up>` | core/keymaps | `<cmd>echo "Use k to move!!"<CR>` | Disabled - use k |
| `gD` | lspconfig | `vim.lsp.buf.declaration` | Go to declaration |
| `gd` | lspconfig | `<cmd>Telescope lsp_definitions<CR>` | Show LSP definitions |
| `gi` | lspconfig | `<cmd>Telescope lsp_implementations<CR>` | Show LSP implementations |
| `gR` | lspconfig | `<cmd>Telescope lsp_references<CR>` | Show LSP references |
| `gt` | lspconfig | `<cmd>Telescope lsp_type_definitions<CR>` | Show LSP type definitions |
| `J` | core/keymaps | `mzJ\`z` | Join lines with cursor position |
| `K` | lspconfig | `vim.lsp.buf.hover` | Show hover documentation |
| `n` | core/keymaps | `nzzzv` | Next search with cursor centered |
| `N` | core/keymaps | `Nzzzv` | Previous search with cursor centered |
| `p` | core/keymaps (visual) | `"_dp` | Paste without copying deleted text |
| `Q` | core/keymaps | `<nop>` | Disabled |
| `x` | core/keymaps | `"_x` | Delete character without yanking |
| `zM` | nvim-ufo | `require('ufo').closeAllFolds` | Close all folds |
| `zR` | nvim-ufo | `require('ufo').openAllFolds` | Open all folds |

## Leader Key Combinations (Normal Mode)

| Keybind | Plugin/File | Action | Description |
|---------|-------------|--------|-------------|
| `<leader><leader>` | telescope | `builtin.buffers` | Find existing buffers |
| `<leader>a` | harpoon | `harpoon:list():add()` | Add file to harpoon |
| `<leader>d` | core/keymaps | `[["_d]]` | Delete without yanking |
| `<leader>d` | lspconfig | `vim.diagnostic.open_float` | Show line diagnostics |
| `<leader>D` | lspconfig | `<cmd>Telescope diagnostics bufnr=0<CR>` | Show buffer diagnostics |
| `<leader>f` | formatting | `conform.format()` | Format file |
| `<leader>fj` | mini.splitjoin | `miniSplitJoin.join()` | Join arguments |
| `<leader>fk` | mini.splitjoin | `miniSplitJoin.split()` | Split arguments |
| `<leader>fp` | core/keymaps | Copy file path | Copy file path to clipboard |
| `<leader>gB` | gitsigns | `gs.toggle_current_line_blame` | Toggle line blame |
| `<leader>gbl` | gitsigns | `gs.blame_line({ full = true })` | Show blame line |
| `<leader>gd` | gitsigns | `gs.diffthis` | Diff this |
| `<leader>gD` | gitsigns | `gs.diffthis("~")` | Diff this ~ |
| `<leader>gp` | gitsigns | `gs.preview_hunk` | Preview hunk |
| `<leader>gr` | gitsigns | `gs.reset_hunk` | Reset hunk |
| `<leader>gR` | gitsigns | `gs.reset_buffer` | Reset buffer |
| `<leader>gs` | vim-fugitive | `vim.cmd.Git` | Git status |
| `<leader>gs` | gitsigns | `gs.stage_hunk` | Stage hunk |
| `<leader>gS` | gitsigns | `gs.stage_buffer` | Stage buffer |
| `<leader>gu` | gitsigns | `gs.undo_stage_hunk` | Undo stage hunk |
| `<leader>l` | linting | `lint.try_lint()` | Trigger linting |
| `<leader>lg` | lazygit (disabled) | `<cmd>LazyGit<cr>` | Open lazy git |
| `<leader>lx` | core/keymaps | Toggle LSP diagnostics | Toggle LSP diagnostics visibility |
| `<leader>P` | vim-fugitive (fugitive buffer) | `vim.cmd.Git('push')` | Git push |
| `<leader>p` | vim-fugitive (fugitive buffer) | `vim.cmd.Git({'pull', '--rebase'})` | Git pull --rebase |
| `<leader>pv` | core/keymaps | `vim.cmd.Ex` | Open file explorer |
| `<leader>q` | core/keymaps | `vim.diagnostic.setloclist` | Open diagnostic quickfix list |
| `<leader>rn` | lspconfig | `vim.lsp.buf.rename` | Smart rename |
| `<leader>rs` | lspconfig | `:LspRestart<CR>` | Restart LSP |
| `<leader>s` | core/keymaps | Global replace | Replace word under cursor globally |
| `<leader>s.` | telescope | `builtin.oldfiles` | Search recent files |
| `<leader>s/` | telescope | Live grep in open files | Search in open files |
| `<leader>sd` | telescope | `builtin.diagnostics` | Search diagnostics |
| `<leader>se` | core/keymaps | `<C-w>=` | Make splits equal size |
| `<leader>sf` | telescope | `builtin.find_files` | Search files |
| `<leader>sg` | telescope | `builtin.live_grep` | Search by grep |
| `<leader>sh` | core/keymaps | `<C-w>s` | Split window horizontally |
| `<leader>sh` | telescope | `builtin.help_tags` | Search help |
| `<leader>sk` | telescope | `builtin.keymaps` | Search keymaps |
| `<leader>sm` | vim-maximizer | `<cmd>MaximizerToggle<CR>` | Maximize/minimize split |
| `<leader>sn` | telescope | Search Neovim files | Search in Neovim config |
| `<leader>sr` | telescope | `builtin.resume` | Search resume |
| `<leader>ss` | telescope | `builtin.builtin` | Search Telescope builtin |
| `<leader>sv` | core/keymaps | `<C-w>v` | Split window vertically |
| `<leader>sw` | telescope | `builtin.grep_string` | Search current word |
| `<leader>sWc` | telescope | Search connected words | Search connected words under cursor |
| `<leader>sx` | core/keymaps | `<cmd>close<CR>` | Close current split |
| `<leader>t` | vim-fugitive (fugitive buffer) | `:Git push -u origin ` | Git push set upstream |
| `<leader>tf` | core/keymaps | `<cmd>tabnew %<CR>` | Open current file in new tab |
| `<leader>ths` | telescope | `<cmd>Telescope themes<CR>` | Theme switcher |
| `<leader>tn` | core/keymaps | `<cmd>tabn<CR>` | Go to next tab |
| `<leader>to` | core/keymaps | `<cmd>tabnew<CR>` | Open new tab |
| `<leader>tp` | core/keymaps | `<cmd>tabp<CR>` | Go to previous tab |
| `<leader>tx` | core/keymaps | `<cmd>tabclose<CR>` | Close current tab |
| `<leader>u` | undotree | `vim.cmd.UndotreeToggle` | Toggle undotree |
| `<leader>vca` | lspconfig | `vim.lsp.buf.code_action()` | See available code actions |
| `<leader>wr` | mini.trailspace | `miniTrailspace.trim()` | Remove trailing whitespace |
| `<leader>x` | core/keymaps | `<cmd>!chmod +x %<CR>` | Make file executable |
| `<leader>xe` | emmet | `require('nvim-emmet').wrap_with_abbreviation` | Emmet wrap with abbreviation |
| `<leader>xl` | trouble | `<cmd>Trouble loclist toggle<CR>` | Open trouble location list |
| `<leader>xq` | trouble | `<cmd>Trouble quickfix toggle<CR>` | Open trouble quickfix list |
| `<leader>xt` | trouble | `<cmd>Trouble todo toggle<CR>` | Open todos in trouble |
| `<leader>xw` | trouble | `<cmd>Trouble diagnostics toggle<CR>` | Open trouble workspace diagnostics |
| `<leader>xd` | trouble | `<cmd>Trouble diagnostics toggle filter.buf=0<CR>` | Open trouble document diagnostics |
| `<leader>Y` | core/keymaps | `[["+Y]]` | Yank to system clipboard |

## Visual Mode Keybinds

| Keybind | Plugin/File | Action | Description |
|---------|-------------|--------|-------------|
| `<` | core/keymaps | `<gv` | Dedent and keep selection |
| `>` | core/keymaps | `>gv` | Indent and keep selection |
| `ih` | gitsigns | `:<C-U>Gitsigns select_hunk<CR>` | Select git hunk |
| `J` | core/keymaps | `:m '>+1<CR>gv=gv` | Move lines down in visual selection |
| `K` | core/keymaps | `:m '<-2<CR>gv=gv` | Move lines up in visual selection |
| `<leader>d` | core/keymaps | `[["_d]]` | Delete without yanking |
| `<leader>f` | formatting | `conform.format()` | Format selection |
| `<leader>fj` | mini.splitjoin | `miniSplitJoin.join()` | Join arguments |
| `<leader>fk` | mini.splitjoin | `miniSplitJoin.split()` | Split arguments |
| `<leader>gr` | gitsigns | Reset selected hunk | Reset selected git hunk |
| `<leader>gs` | gitsigns | Stage selected hunk | Stage selected git hunk |
| `<leader>p` | core/keymaps | `[["_dP]]` | Paste without yanking |
| `<leader>vca` | lspconfig | `vim.lsp.buf.code_action()` | Code actions for selection |
| `<leader>xe` | emmet | `require('nvim-emmet').wrap_with_abbreviation` | Emmet wrap selection |

## Insert Mode Keybinds

| Keybind | Plugin/File | Action | Description |
|---------|-------------|--------|-------------|
| `<C-b>` | nvim-cmp | `cmp.mapping.scroll_docs(-4)` | Scroll completion docs up |
| `<C-c>` | core/keymaps | `<Esc>` | Escape |
| `<C-d>` | nvim-cmp | `cmp.close_docs()` | Close completion docs |
| `<C-e>` | nvim-cmp | `cmp.mapping.abort()` | Abort completion |
| `<C-f>` | nvim-cmp | `cmp.mapping.scroll_docs(4)` | Scroll completion docs down |
| `<C-h>` | lspconfig | `vim.lsp.buf.signature_help()` | LSP signature help |
| `<C-j>` | nvim-cmp | `select_next_item` | Next completion item |
| `<C-k>` | nvim-cmp | `select_prev_item` | Previous completion item |
| `<C-n>` | nvim-cmp | `select_next_item` | Next completion item |
| `<C-p>` | nvim-cmp | `select_prev_item` | Previous completion item |
| `<C-space>` | treesitter | node_incremental | Incremental selection |
| `<C-y>` | nvim-cmp | `confirm(entry)` | Confirm completion |
| `<CR>` | nvim-cmp | `confirm(entry)` | Confirm completion |
| `<Down>` | nvim-cmp | `select_next_item` | Next completion item |
| `<S-Tab>` | nvim-cmp | Previous item/jump back | Previous item or snippet jump |
| `<Tab>` | nvim-cmp | Next item/expand/jump | Next item, expand snippet, or jump |
| `<Up>` | nvim-cmp | `select_prev_item` | Previous completion item |

## Telescope Insert Mode Keybinds

| Keybind | Plugin/File | Action | Description |
|---------|-------------|--------|-------------|
| `<C-j>` | telescope | `actions.move_selection_next` | Move selection next |
| `<C-k>` | telescope | `actions.move_selection_previous` | Move selection previous |

## Terminal Mode Keybinds

| Keybind | Plugin/File | Action | Description |
|---------|-------------|--------|-------------|
| `<Esc><Esc>` | core/keymaps | `<C-\\><C-n>` | Exit terminal mode |

## Operator-Pending Mode Keybinds

| Keybind | Plugin/File | Action | Description |
|---------|-------------|--------|-------------|
| `ih` | gitsigns | `:<C-U>Gitsigns select_hunk<CR>` | Select git hunk |

---

## Summary

- **Total Normal Mode Keybinds**: 45+
- **Total Leader Combinations**: 50+
- **Total Visual Mode Keybinds**: 15+
- **Total Insert Mode Keybinds**: 15+
- **Major Conflicts Found**: 8 sets of conflicts
- **Most Problematic Conflicts**: 
  - `<C-h>`, `<C-j>`, `<C-k>` (window navigation vs completion vs harpoon)
  - `<leader>gs` (git status vs stage hunk)
  - `<leader>d` (delete vs diagnostics)

## Recommendations

1. **Resolve `<C-h>` conflict**: Consider remapping harpoon file 1 to something else
2. **Resolve `<leader>gs` conflict**: Consider using `<leader>gg` for git status or `<leader>gsh` for stage hunk
3. **Resolve completion navigation**: Consider using `<C-n>`/`<C-p>` exclusively for completion
4. **Consider namespace organization**: Group related functions under common prefixes
   - `<leader>g*` for git operations
   - `<leader>s*` for search operations  
   - `<leader>t*` for tab/todo operations
   - `<leader>x*` for trouble/diagnostics
