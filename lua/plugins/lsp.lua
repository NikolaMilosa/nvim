return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "folke/lazydev.nvim",
                ft = "lua", -- only load on lua files
                opts = {
                    library = {
                        -- See the configuration section for more details
                        -- Load luvit types when the `vim.uv` word is found
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                },
            },
        },
        config = function()
            local lspconfig = require("lspconfig")
            local configs = require("lspconfig.configs")
            -- lua setup --
            lspconfig.lua_ls.setup {}

            -- rust setup --
            if not configs.rust_multiplex then
                configs.rust_multiplex = {
                    default_config = {
                        cmd = { "/usr/local/bin/ra-multiplex", "client", "--server-path", "rust-analyzer" },
                        filetype = { "rust" },
                        root_dir = lspconfig.util.root_pattern("Cargo.toml", ".git"),
                        settings = {},
                    }
                }
            end
            lspconfig.rust_multiplex.setup {}

            vim.diagnostic.config({
                virtual_text = {
                    prefix = "●", -- could be "■", "▎", "x"
                    spacing = 3,
                    severity = { min = vim.diagnostic.severity.WARN },
                },
                signs = {
                    severity = { min = vim.diagnostic.severity.WARN },
                },
                underline = {
                    severity = { min = vim.diagnostic.severity.WARN },
                },
                update_in_insert = false,
                severity_sort = true,
                float = {
                    focusable = false,
                    severity = { min = vim.diagnostic.severity.WARN },
                    style = "minimal",
                    border = "rounded",
                    source = true,
                    header = "",
                    prefix = "",
                },
            })
        end,
    }
}
