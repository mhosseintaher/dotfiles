return {
	"thePrimeagen/harpoon",
	enabled = true,
	branch = "harpoon2",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	-- loads on first use of one of these keys
	keys = {
		--Harpoon Nav Interface
		{ "<leader>a", function() require("harpoon"):list():add() end, desc = "Harpoon add file" },
		{ "<C-e>", function() local harpoon = require("harpoon"); harpoon.ui:toggle_quick_menu(harpoon:list()) end },

		--Harpoon marked files
		{ "<C-y>", function() require("harpoon"):list():select(1) end },
		{ "<C-t>", function() require("harpoon"):list():select(2) end },
		{ "<C-n>", function() require("harpoon"):list():select(3) end },
		{ "<C-s>", function() require("harpoon"):list():select(4) end },

		-- Toggle previous & next buffers stored within Harpoon list
		{ "<C-S-P>", function() require("harpoon"):list():prev() end },
		{ "<C-S-N>", function() require("harpoon"):list():next() end },
	},
	config = function()
		-- harpoon 2 reads `settings` (the old global_settings/save_on_change were ignored)
		require("harpoon"):setup({
			settings = {
				save_on_toggle = true,
			},
		})
	end,
}
