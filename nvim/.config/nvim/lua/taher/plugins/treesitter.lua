return {
	{
		-- main branch (rewrite for nvim 0.12; master is frozen at 0.11). It does not lazy-load
		-- and has no configs module: it only installs parsers and queries, the features are
		-- switched on per buffer below.
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			-- parsers come only from this list (no silent fetch + compile on first open);
			-- async, and a no-op for parsers already installed
			require("nvim-treesitter").install({
				"json",
				"php",
				"javascript",
				"typescript",
				"tsx",
				"go",
				"yaml",
				"html",
				"css",
				"python",
				"http",
				"prisma",
				"markdown",
				"markdown_inline",
				"graphql",
				"bash",
				"lua",
				"vim",
				"dockerfile",
				"gitignore",
				"query",
				"vimdoc",
				"rust",
				"diff",
				"gitcommit",
				"ssh_config",
				"toml",
				-- not on main: jsonc (its filetype now uses the json parser) and tmux (dropped
				-- upstream; tmux.conf keeps vim's regex syntax)
			})

			-- highlighting for every filetype that has a parser; treesitter indent where the
			-- language ships indent queries, except ruby, which keeps vim's regex syntax and indent
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("taher-treesitter", { clear = true }),
				callback = function(ev)
					if not pcall(vim.treesitter.start, ev.buf) then
						return
					end
					local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
					if lang == "ruby" then
						vim.bo[ev.buf].syntax = "ON"
					elseif lang and #vim.api.nvim_get_runtime_file("queries/" .. lang .. "/indents.scm", false) > 0 then
						vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})

			-- <C-space>: select the node under the cursor, then grow to its parent on each press
			-- (master's incremental_selection; nvim 0.12 has it built in, see :h v_an)
			vim.keymap.set({ "n", "x" }, "<C-space>", function()
				if vim.treesitter.get_parser(nil, nil, { error = false }) then
					vim.treesitter.select("parent", vim.v.count1)
				end
			end, { desc = "Select treesitter node / grow to parent" })
		end,
	},
	-- NOTE: js,ts,jsx,tsx Auto Close Tags
	{
		"windwp/nvim-ts-autotag",
		enabled = true,
		ft = { "html", "xml", "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte" },
		config = function()
			-- Independent nvim-ts-autotag setup
			require("nvim-ts-autotag").setup({
				opts = {
					enable_close = false, -- Auto-close tags
					enable_rename = true, -- Auto-rename pairs
					enable_close_on_slash = false, -- Disable auto-close on trailing `</`
				},
				per_filetype = {
					["html"] = {
						enable_close = false, -- Disable auto-closing for HTML
					},
					["typescriptreact"] = {
						enable_close = false, -- Explicitly enable auto-closing (optional, defaults to `true`)
					},
				},
			})
		end,
	},
}
