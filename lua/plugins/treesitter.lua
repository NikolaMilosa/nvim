return {
    "nvim-treesitter/nvim-treesitter",
    branch = 'master',
    lazy = false,
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup{
            ensure_installed = { "rust", "lua", "markdown" },
            sync_install = false,
            auto_install = true,
            highlight = { enable = true },
            ignore_install = {},
            modules =  {},
            textobjects = {
                select = {
                    enable = true,

                    -- Automatically jump forward to textobj, similar to targets.vim
                    lookahead = true,

                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                    },
                }
            }
        }
     end
 }
