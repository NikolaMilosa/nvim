return {
    'akinsho/bufferline.nvim',
    version = "v4.9",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
        require("bufferline").setup {
            options = {
                buffer_close_icon = '',
                close_icon = '',
                diagnostics = "nvim_lsp",
            }
        }

        vim.keymap.set("n", "e", ":BufferLineCycleNext<cr>")
        vim.keymap.set("n", "q", ":BufferLineCyclePrev<cr>")
        vim.keymap.set("n", "<leader>w", ":bdelete<cr>")
        vim.keymap.set("n", "<leader>q", ":BufferLineCloseOthers<cr>")
    end
}
