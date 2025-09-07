return {
    "stevearc/conform.nvim",
    opts = {},
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
                go = { "gofmt" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                rust = { "rustfmt" },
                python = { "ruff" },
            },
            format_on_save = function(bufnr)
                return { timeout_ms = 3000, lsp_fallback = true }
            end
        })

        vim.keymap.set("n", "<leader>f", function()
            require("conform").format({ bufnr = 0 })
        end)
    end,
}
