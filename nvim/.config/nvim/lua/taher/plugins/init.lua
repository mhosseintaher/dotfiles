return {
    'NMAC427/guess-indent.nvim',
    "nvim-lua/plenary.nvim", --lua functions that many plugins use
    "szw/vim-maximizer", keys = { { "<leader>sm", "<cmd>MaximizerToggle<CR>", desc = "[S]plit [M]aximize/minimize" },},
    { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
	"christoomey/vim-tmux-navigator", -- tmux & split window nav
}
