return {
	"williamboman/mason.nvim",
	-- loaded by nvim-lspconfig (BufReadPre/BufNewFile) or by one of these commands
	cmd = {
		"Mason",
		"MasonInstall",
		"MasonUninstall",
		"MasonUninstallAll",
		"MasonUpdate",
		"MasonLog",
		"MasonToolsInstall",
		"MasonToolsInstallSync",
		"MasonToolsUpdate",
		"MasonToolsUpdateSync",
		"MasonToolsClean",
		"LspInstall",
		"LspUninstall",
	},
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		-- "saghen/blink.cmp",
	},
	config = function()
		-- import mason and mason_lspconfig
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		-- NOTE: Moved these local imports below back to lspconfig.lua due to mason depracated handlers

		-- local lspconfig = require("lspconfig")
		-- local cmp_nvim_lsp = require("cmp_nvim_lsp")             -- import cmp-nvim-lsp plugin
		-- local capabilities = cmp_nvim_lsp.default_capabilities() -- used to enable autocompletion (assign to every lsp server config)

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			automatic_enable = false, -- lspconfig.lua enables its own list (emmet-ls stays off)
			-- servers for mason to install
			ensure_installed = {
				"lua_ls",
				"ts_ls", -- currently using a ts plugin
				"html",
				"cssls",
				"tailwindcss",
				"gopls",
				"emmet_language_server",
				"eslint",
				"marksman",
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"biome", -- biome formatter and linter
				"prettier", -- prettier formatter (backup)
				"stylua", -- lua formatter
				"isort", -- python formatter
				"pylint",
				"clangd",
				{ "eslint_d", version = "13.1.2" },
				"golangci-lint",
			},
			-- check for missing tools at most once a day, 3 s after startup
			debounce_hours = 24,
			start_delay = 3000,

			-- NOTE: mason BREAKING Change! Removed setup_handlers
			-- moved lsp configuration settings back into lspconfig.lua file
		})
		-- its start check hangs on a VimEnter autocmd (augroup mti_start); when mason
		-- lazy-loads after VimEnter that never fires, so fire it now (it deletes itself)
		if vim.v.vim_did_enter == 1 then
			pcall(vim.api.nvim_exec_autocmds, "VimEnter", { group = "mti_start" })
		end
	end,
}
