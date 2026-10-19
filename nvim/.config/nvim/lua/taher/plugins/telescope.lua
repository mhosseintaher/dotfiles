return {
	"nvim-telescope/telescope.nvim",
	branch = "master", -- using master to fix issues with deprecated to definition warnings
	-- '0.1.x' for stable ver.
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		"andrew-george/telescope-themes",
		-- 'nvim-telescope/telescope-ui-select.nvim',
	},
	cmd = "Telescope",
	-- Keymaps (telescope loads on the first one used)
	keys = {
		{ "<leader>sh", function() require("telescope.builtin").help_tags() end, desc = "[S]earch [H]elp" },
		{ "<leader>sk", function() require("telescope.builtin").keymaps() end, desc = "[S]earch [K]eymaps" },
		{ "<leader>sf", function() require("telescope.builtin").find_files() end, desc = "[S]earch [F]iles" },
		{ "<leader>ss", function() require("telescope.builtin").builtin() end, desc = "[S]earch [S]elect Telescope" },
		{ "<leader>sw", function() require("telescope.builtin").grep_string() end, desc = "[S]earch current [W]ord" },
		{ "<leader>sg", function() require("telescope.builtin").live_grep() end, desc = "[S]earch by [G]rep" },
		{ "<leader>sd", function() require("telescope.builtin").diagnostics() end, desc = "[S]earch [D]iagnostics" },
		{ "<leader>sr", function() require("telescope.builtin").resume() end, desc = "[S]earch [R]esume" },
		{ "<leader>s.", function() require("telescope.builtin").oldfiles() end, desc = '[S]earch Recent Files ("." for repeat)' },
		{ "<leader><leader>", function() require("telescope.builtin").buffers() end, desc = "[ ] Find existing buffers" },
		{ "<C-p>", function() require("telescope.builtin").git_files() end, desc = "My Always Control P" },
		{
			"<leader>s/",
			function()
				require("telescope.builtin").live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end,
			desc = "[S]earch [/] in Open Files",
		},
		-- Shortcut for searching your Neovim configuration files
		{
			"<leader>sn",
			function()
				require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
			end,
			desc = "[S]earch [N]eovim files",
		},
		{
			"<leader>sWc",
			function()
				local word = vim.fn.expand("<cWORD>")
				require("telescope.builtin").grep_string({ search = word })
			end,
			desc = "[S]earch Connected [W]ords under [c]ursor",
		},
		{
			"<leader>ths",
			function()
				-- the other colorschemes are lazy; load them so the picker lists them
				require("lazy").load({
					plugins = { "gruvbox.nvim", "kanagawa.nvim", "solarized-osaka.nvim", "folkeTokyonight" },
				})
				vim.cmd("Telescope themes")
			end,
			silent = true,
			desc = "Theme Switcher",
		},
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
					},
				},
			},
			extensions = {
				themes = {
					enable_previewer = true,
					enable_live_preview = true,
					persist = {
						enabled = true,
						-- init.lua loads this file; it lives in the dotfiles repo on purpose
						path = vim.fn.stdpath("config") .. "/lua/current-theme.lua",
					},
				},
			},
		})

		-- extensions read their config at load time, so load them after setup()
		telescope.load_extension("fzf")
		telescope.load_extension("themes")
	end,
}
