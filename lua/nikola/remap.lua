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

local function open_file_in_split(direction)
    -- grab the word (filename) under cursor
    local file = vim.fn.expand("%")

    -- check if file exists
    if vim.fn.filereadable(file) == 0 then
        vim.notify("File does not exist: " .. file, vim.log.levels.WARN)
        return
    end

    -- decide split command
    local cmd = ""
    if direction == "left" then
        cmd = "topleft vsplit"
    elseif direction == "right" then
        cmd = "botright vsplit"
    elseif direction == "up" then
        cmd = "topleft split"
    elseif direction == "down" then
        cmd = "botright split"
    else
        vim.notify("Invalid direction: " .. direction, vim.log.levels.ERROR)
        return
    end

    -- open the file in the split
    vim.cmd(cmd .. " " .. vim.fn.fnameescape(file))
end

-- Keymaps
set("n", "<leader>sh", function() open_file_in_split("left") end,
    { desc = "Open file under cursor in left split" })
set("n", "<leader>sl", function() open_file_in_split("right") end,
    { desc = "Open file under cursor in right split" })
set("n", "<leader>sk", function() open_file_in_split("up") end,
    { desc = "Open file under cursor in up split" })
set("n", "<leader>sj", function() open_file_in_split("down") end,
    { desc = "Open file under cursor in down split" })

set("n", "<M-j>", "<cmd>cnext<CR>")
set("n", "<M-k>", "<cmd>cprev<CR>")
