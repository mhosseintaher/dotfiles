return {
    -- never had a setup() call, so it never guessed on its own; :GuessIndent runs it on demand
    { 'NMAC427/guess-indent.nvim', cmd = "GuessIndent", opts = { auto_cmd = false } },
    { "nvim-lua/plenary.nvim", lazy = true }, --lua functions that many plugins use
    { "szw/vim-maximizer", keys = { { "<leader>sm", "<cmd>MaximizerToggle<CR>", desc = "[S]plit [M]aximize/minimize" } } },
    {
        'folke/todo-comments.nvim',
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = { signs = false },
        keys = {
            { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
            { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
        },
    },
	"christoomey/vim-tmux-navigator", -- tmux & split window nav
}
