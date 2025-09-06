return {
    "tpope/vim-fugitive",
    config = function()
        vim.keymap.set("n", "<leader>b", ":Git blame<CR>", { noremap = true, silent = true })
    end
}
