-- Check if there is a `./poetry.lock` and source env if it exists
local sourceVenvIfExists = function()
    local match = vim.fn.glob(vim.fn.getcwd() .. "/poetry.lock")
    -- Return if there are no matches
    if match == "" then
        return
    end

    vim.notify("Found poetry.lock in root", vim.log.levels.INFO)
    local venv_path = vim.fn.trim(vim.fn.system("poetry env info --path"))
    if vim.v.shell_error ~= 0 or venv_path == "" then
        vim.notify("Could not get poetry venv path", vim.log.levels.ERROR)
        return
    end

    vim.notify("Using Poetry venv: " .. venv_path, vim.log.levels.INFO)

    -- Set Python for LSP / plugins
    vim.g.python3_host_prog = venv_path .. "/bin/python"
    vim.env.VIRTUAL_ENV = venv_path
    vim.env.PATH = venv_path .. "/bin:" .. vim.env.PATH
end

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

            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/nvim-cmp",
            "L3MON4D3/LuaSnip",
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
                        root_dir = lspconfig.util.root_pattern("Cargo.toml"),
                        settings = {},
                    }
                }
            end
            lspconfig.rust_multiplex.setup {}

            lspconfig.gopls.setup {}

            lspconfig.csharp_ls.setup {}

            lspconfig.pyright.setup {}

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

            local cmp = require('cmp')
            local cmp_lsp = require("cmp_nvim_lsp")
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                cmp_lsp.default_capabilities())

            local cmp_select = { behavior = cmp.SelectBehavior.Select }

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                }, {
                    { name = 'buffer' },
                })
            })

            -- Try source on init
            sourceVenvIfExists()
            vim.api.nvim_create_autocmd({ "DirChanged" }, {
                callback = sourceVenvIfExists
            })
        end,
    }
}
