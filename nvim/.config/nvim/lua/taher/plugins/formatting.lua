return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters = {
                -- ["markdown-toc"] = {
                --     condition = function(_, ctx)
                --         for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
                --             if line:find("<!%-%- toc %-%->") then
                --                 return true
                --             end
                --         end
                --     end,
                -- },
            },
                formatters_by_ft = {
				javascript = { "biome-check" },
				typescript = { "biome-check" },
				javascriptreact = { "biome-check" },
				typescriptreact = { "biome-check" },
				css = { "biome-check" },
				html = { "biome-check" },
                svelte = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                graphql = { "prettier" },
                liquid = { "prettier" },
                lua = { "stylua" },
                go = { "gofmt", "goimports" },
                -- python = { "black" },
                markdown = { "prettier" }, -- markdown-toc was never installed
                -- ["markdown.mdx"] = { "prettier", "markdownlint", "markdown-toc" },
            },
            format_on_save = {
            	lsp_format = "fallback",
            	async = false,
            	timeout_ms = 1000,
            },
        })

        -- Configure individual formatters
        conform.formatters.prettier = {
            args = {
                "--stdin-filepath",
                "$FILENAME",
                "--tab-width",
                "4",
                "--use-tabs",
                "false",
            },
        }

        vim.keymap.set({ "n", "x" }, "<leader>f", function()
            conform.format({
                lsp_format = "fallback",
                async = false,
                timeout_ms = 1000,
            })
        end, { desc = "Format whole file or range (in visual mode) with" })
    end,
}
