-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true
-- vim.g.loaded_netrw = 0
-- vim.g.loaded_netrwPlugin = 0
vim.cmd("let g:netrw_liststyle = 3")
vim.cmd("let g:netrw_banner = 0 ")

vim.opt.guicursor = ""
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.wrap = true
vim.o.breakindent = true

vim.opt.swapfile = false
vim.opt.backup = false
-- persistent undo lives in nvim's own state dir, readable only by me (0700)
local undodir = vim.fn.stdpath("state") .. "/undo"
vim.fn.mkdir(undodir, "p", tonumber("700", 8))
vim.uv.fs_chmod(undodir, tonumber("700", 8))
vim.opt.undodir = undodir
vim.opt.undofile = true

-- no undo history on disk for secret-ish files (old secrets would outlive edits);
-- BufWritePre/BufFilePost also catch ":w .env" and ":saveas" from an unnamed or other buffer
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile", "BufWritePre", "BufFilePost" }, {
	group = vim.api.nvim_create_augroup("secret-noundo", { clear = true }),
	pattern = {
		"*.env",
		".env*",
		"*.auth",
		"auth.json",
		"*/.ssh/*",
		"*/.gnupg/*",
		"/tmp/*",
		"/private/tmp/*",
		"/var/folders/*",
		"/private/var/folders/*",
	},
	callback = function()
		vim.opt_local.undofile = false
	end,
})

vim.opt.hlsearch = true
vim.opt.incsearch = false

vim.opt.inccommand = "split"

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.termguicolors = true
vim.opt.background = "dark"

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

-- Enable folding ( setup in nvim-ufo )
vim.o.foldenable = true -- Enable folding by default
vim.o.foldmethod = "manual" -- Default fold method (change as needed)
vim.o.foldlevel = 99 -- Open most folds by default
vim.o.foldcolumn = "0"

-- backspace
vim.opt.backspace = { "start", "eol", "indent" }

--split windows
vim.opt.splitright = true --split vertical window to the right
vim.opt.splitbelow = true --split horizontal window to the bottom

vim.opt.isfname:append("@-@")
vim.opt.updatetime = 200
-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300
vim.opt.colorcolumn = "120"

-- Sync clipboard between OS and Neovim.
-- Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- for easy mouse resizing, just incase
vim.opt.mouse = "a"

-- gets rid of line with white spaces
vim.g.editorconfig = true

vim.o.showmode = false

vim.o.list = false
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Show which line your cursor is on
vim.o.cursorline = true

vim.o.confirm = true

-- tell tmux this pane runs nvim (pane option @pane-is-vim), so tmux's C-h/j/k/l hand the key
-- to nvim even when a wrapper (nzo, git commit) started it and tmux's process check misses it
if vim.env.TMUX and vim.env.TMUX_PANE then
	local function pane_is_vim(on)
		local argv = { "tmux", "set-option", "-p", "-t", vim.env.TMUX_PANE }
		vim.list_extend(argv, on and { "@pane-is-vim", "1" } or { "-u", "@pane-is-vim" })
		local ok, proc = pcall(vim.system, argv)
		return ok and proc or nil
	end
	local group = vim.api.nvim_create_augroup("tmux-pane-is-vim", { clear = true })
	vim.api.nvim_create_autocmd({ "VimEnter", "VimResume" }, {
		group = group,
		callback = function()
			pane_is_vim(true)
		end,
	})
	vim.api.nvim_create_autocmd("VimSuspend", {
		group = group,
		callback = function()
			pane_is_vim(false)
		end,
	})
	vim.api.nvim_create_autocmd("VimLeavePre", {
		group = group,
		callback = function()
			local proc = pane_is_vim(false)
			if proc then
				proc:wait(200) -- let it land before nvim exits
			end
		end,
	})
end
