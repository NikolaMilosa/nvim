local set = vim.keymap.set

set("n", "<leader>pv", vim.cmd.Ex)

set("v", "J", ":m '>+1<CR>gv=gv")
set("v", "K", ":m '<-2<CR>gv=gv")

set("n", "<C-d>", "<C-d>zz")
set("n", "<C-u>", "<C-u>zz")

set("n", "n", "nzzzv")
set("n", "N", "Nzzzv")

set({ "n", "v" }, "<leader>y", [["+y]])
set("n", "<leader>Y", [["+Y]])

set({ "n", "v" }, "<leader>d", "\"_d")

set("n", "Q", "<nop>")

set("n", "U", "<C-R>")
