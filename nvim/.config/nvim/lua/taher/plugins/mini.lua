  return { 
--       {
--     'echasnovski/mini.nvim',
--     config = function()
--       -- Better Around/Inside textobjects
--       --
--       -- Examples:
--       --  - va)  - [V]isually select [A]round [)]paren
--       --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
--       --  - ci'  - [C]hange [I]nside [']quote
--       require('mini.ai').setup { n_lines = 500 }
--
--       -- Add/delete/replace surroundings (brackets, quotes, etc.)
--       --
--       -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
--       -- - sd'   - [S]urround [D]elete [']quotes
--       -- - sr)'  - [S]urround [R]eplace [)] [']
--       require('mini.surround').setup()
--
--       -- Simple and easy statusline.
--       --  You could remove this setup call if you don't like it,
--       --  and try some other statusline plugin
--       local statusline = require 'mini.statusline'
--       -- set use_icons to true if you have a Nerd Font
--       statusline.setup { use_icons = vim.g.have_nerd_font }
--
--       -- You can configure sections in the statusline by overriding their
--       -- default behavior. For example, here we set the section for
--       -- cursor location to LINE:COLUMN
--       ---@diagnostic disable-next-line: duplicate-set-field
--       statusline.section_location = function()
--         return '%2l:%-2v'
--       end
--     end,
-- },
 -- Comments
    {
        'echasnovski/mini.comment',
        version = false,
        event = "VeryLazy",
        dependencies = {
            "JoosepAlviste/nvim-ts-context-commentstring",
        },
        config = function()
            -- disable the autocommand from ts-context-commentstring
            require('ts_context_commentstring').setup {
                enable_autocmd = false,
            }

            require("mini.comment").setup {
                -- tsx, jsx, html , svelte comment support
                options = {
                    custom_commentstring = function()
                        return require('ts_context_commentstring.internal').calculate_commentstring({ key =
                            'commentstring' })
                            or vim.bo.commentstring
                    end,
                },
            }
        end
    },
    -- Get rid of whitespace
    {
        "echasnovski/mini.trailspace",
        keys = {
            { "<leader>wr", function() require("mini.trailspace").trim() end, desc = "Trailing [w]hiterpace [r]emove from current file" },
        },
        init = function()
            -- trim only, never highlight (replaces the old CursorMoved unhighlight autocmd)
            vim.g.minitrailspace_disable = true
        end,
        config = function()
            require("mini.trailspace").setup({
                only_in_normal_buffers = true,
            })
        end,
    },
    -- Split & join
    {
        "echasnovski/mini.splitjoin",
        keys = {
            { "<leader>fj", function() require("mini.splitjoin").join() end, mode = { "n", "x" }, desc = "[F]ormat [J]oin arguments" },
            { "<leader>fk", function() require("mini.splitjoin").split() end, mode = { "n", "x" }, desc = "[F]ormat [S]plit arguments" },
        },
        config = function()
            require("mini.splitjoin").setup({
                mappings = { toggle = "" }, -- Disable default mapping
            })
        end,
    },
  }
