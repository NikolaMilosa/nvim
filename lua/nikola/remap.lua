local set = vim.keymap.set

set("n", "<leader>pv", vim.cmd.Ex)

set("v", "J", ":m '>+1<CR>gv=gv")
set("v", "K", ":m '<-2<CR>gv=gv")

set("n", "<C-j>", "<C-d>zz")
set("n", "<C-k>", "<C-u>zz")

set("n", "n", "nzzzv")
set("n", "N", "Nzzzv")

set({ "n", "v" }, "<leader>y", [["+y]])
set("n", "<leader>Y", [["+Y]])

set({ "n", "v" }, "<leader>d", "\"_d")

set("n", "Q", "<nop>")

set("n", "U", "<C-R>")

set({ "n", "v" }, "gg", "gg0")
set({ "n", "v" }, "ge", "G$0")
set({ "n", "v" }, "gl", "$")
set({ "n", "v" }, "gh", "0")

set("n", "<M-j>", "<cmd>cnext<CR>")
set("n", "<M-k>", "<cmd>cprev<CR>")

set("n", "ž", "<cmd>vsplit<CR>")
set("n", "-", "<cmd>split<CR>")

set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true })

set("n", "<C-d>n", function() vim.diagnostic.jump({ count = 1, float = true }) end)
set("n", "<C-d>p", function() vim.diagnostic.jump({ count = -1, float = true }) end)
