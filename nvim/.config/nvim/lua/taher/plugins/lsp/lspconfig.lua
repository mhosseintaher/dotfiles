return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		-- mason.setup puts mason/bin on PATH before any server starts
		"williamboman/mason.nvim",
		-- "saghen/blink.cmp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "j-hui/fidget.nvim", opts = {} },
	},
	config = function()
		-- NOTE: LSP Keybinds

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings
				-- Check `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				-- keymaps
				opts.desc = "Show LSP references"
				vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "Go to declaration"
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "Show LSP definitions"
				vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

				opts.desc = "Show LSP implementations"
				vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

				opts.desc = "Show LSP type definitions"
				vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

				opts.desc = "See available code actions"
				vim.keymap.set({ "n", "x" }, "<leader>vca", function()
					vim.lsp.buf.code_action()
				end, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Smart rename"
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "Show buffer diagnostics"
				vim.keymap.set("n", "<leader>lD", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

				opts.desc = "Show line diagnostics"
				vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Show documentation for what is under cursor"
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Restart LSP"
				vim.keymap.set("n", "<leader>lrs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

				vim.keymap.set("i", "<C-h>", function()
					vim.lsp.buf.signature_help()
				end, opts)
			end,
		})

		-- NOTE : Moved all this to Mason including local variables
		-- used to enable autocompletion (assign to every lsp server config)
		-- local capabilities = cmp_nvim_lsp.default_capabilities()
		-- Change the Diagnostic symbols in the sign column (gutter)

		-- Define sign icons for each severity
		local signs = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = "󰠠 ",
			[vim.diagnostic.severity.INFO] = " ",
		}

		-- Set the diagnostic config with all icons
		vim.diagnostic.config({
			signs = {
				text = signs, -- Enable signs in the gutter
			},
			virtual_text = true, -- Specify Enable virtual text for diagnostics
			underline = true, -- Specify Underline diagnostics
			update_in_insert = false, -- Keep diagnostics active in insert mode
		})

		-- NOTE: nvim 0.11 native LSP. nvim-lspconfig ships the base configs (lsp/*.lua);
		-- vim.lsp.config only adds my overrides. Servers run from mason/bin, and the
		-- node ones use whatever node is first on PATH.
		vim.lsp.config("*", {
			capabilities = require("cmp_nvim_lsp").default_capabilities(),
		})

		-- lua_ls
		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					completion = {
						callSnippet = "Replace",
					},
					workspace = {
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		})

		-- emmet_language_server
		vim.lsp.config("emmet_language_server", {
			filetypes = {
				"css",
				"eruby",
				"html",
				"javascript",
				"javascriptreact",
				"less",
				"sass",
				"scss",
				"pug",
				"typescriptreact",
			},
			init_options = {
				includeLanguages = {},
				excludeLanguages = {},
				extensionsPath = {},
				preferences = {},
				showAbbreviationSuggestions = true,
				showExpandedAbbreviation = "always",
				showSuggestionsAsSnippets = false,
				syntaxProfiles = {},
				variables = {},
			},
		})

		-- ts_ls (replaces tsserver)
		vim.lsp.config("ts_ls", {
			-- never in deno projects; otherwise root at the nearest tsconfig/package/jsconfig/.git
			-- (no root means no client, like the old single_file_support = false)
			root_dir = function(bufnr, on_dir)
				if vim.fs.root(bufnr, { "deno.json", "deno.jsonc" }) then
					return
				end
				local markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" }
				-- nested list = equal priority, the nearest directory wins
				local root = vim.fs.root(bufnr, vim.fn.has("nvim-0.11.3") == 1 and { markers } or markers)
				if root then
					on_dir(root)
				end
			end,
			init_options = {
				preferences = {
					includeCompletionsWithSnippetText = true,
					includeCompletionsForImportStatements = true,
				},
			},
		})

		vim.lsp.config("gopls", {
			settings = {
				gopls = {
					-- enable staticcheck (which bundles lots of extra analyzers)
					staticcheck = true,
				},
			},
		})

		-- tailwindcss: lspconfig's root_dir falls back to .git (for tailwind v4), which starts
		-- it in every git repo. Start it only below a tailwind/postcss config, or a
		-- package.json (or mix.lock/Gemfile.lock) that names tailwind.
		vim.lsp.config("tailwindcss", {
			root_dir = function(bufnr, on_dir)
				local util = require("lspconfig.util")
				local fname = vim.api.nvim_buf_get_name(bufnr)
				local markers = {
					"tailwind.config.js",
					"tailwind.config.cjs",
					"tailwind.config.mjs",
					"tailwind.config.ts",
					"postcss.config.js",
					"postcss.config.cjs",
					"postcss.config.mjs",
					"postcss.config.ts",
				}
				markers = util.insert_package_json(markers, "tailwindcss", fname)
				markers = util.root_markers_with_field(markers, { "mix.lock", "Gemfile.lock" }, "tailwind", fname)
				local found = vim.fs.find(markers, { path = fname, upward = true })[1]
				if found then
					on_dir(vim.fs.dirname(found))
				end
			end,
		})

		-- every server mason-lspconfig installs; eslint starts only where an eslint config is
		-- found, tailwindcss only where the root_dir above finds one
		vim.lsp.enable({
			"lua_ls",
			"ts_ls",
			"html",
			"cssls",
			"tailwindcss",
			"gopls",
			"emmet_language_server",
			"eslint",
			"marksman",
		})

		-- HACK: If using Blink.cmp Configure all LSPs here

		-- ( comment the ones in mason )
		-- local lspconfig = require("lspconfig")
		-- local capabilities = require("blink.cmp").get_lsp_capabilities() -- Import capabilities from blink.cmp

		-- Configure lua_ls
		-- lspconfig.lua_ls.setup({
		--     capabilities = capabilities,
		--     settings = {
		--         Lua = {
		--             diagnostics = {
		--                 globals = { "vim" },
		--             },
		--             completion = {
		--                 callSnippet = "Replace",
		--             },
		--             workspace = {
		--                 library = {
		--                     [vim.fn.expand("$VIMRUNTIME/lua")] = true,
		--                     [vim.fn.stdpath("config") .. "/lua"] = true,
		--                 },
		--             },
		--         },
		--     },
		-- })
		--
		-- -- Configure tsserver (TypeScript and JavaScript)
		-- lspconfig.ts_ls.setup({
		--     capabilities = capabilities,
		--     root_dir = function(fname)
		--         local util = lspconfig.util
		--         return not util.root_pattern('deno.json', 'deno.jsonc')(fname)
		--             and util.root_pattern('tsconfig.json', 'package.json', 'jsconfig.json', '.git')(fname)
		--     end,
		--     single_file_support = false,
		--     on_attach = function(client, bufnr)
		--         -- Disable formatting if you're using a separate formatter like Prettier
		--         client.server_capabilities.documentFormattingProvider = false
		--     end,
		--     init_options = {
		--         preferences = {
		--             includeCompletionsWithSnippetText = true,
		--             includeCompletionsForImportStatements = true,
		--         },
		--     },
		-- })

		-- Add other LSP servers as needed, e.g., gopls, eslint, html, etc.
		-- lspconfig.gopls.setup({ capabilities = capabilities })
		-- lspconfig.html.setup({ capabilities = capabilities })
		-- lspconfig.cssls.setup({ capabilities = capabilities })
	end,
}
