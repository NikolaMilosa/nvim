--- Spawns a toggleable terminal window t hat can be used to issue commands
--- and then remove if needed and takes up the whole screen

local M = {}

--- @todo: Abstract this so I can have multiple terminals
--- bound to specific key bindings. Would be useful to have
--- one for dev containers and others for something else like
--- git.
local buf = 0
local win = 0
local shown = false

local ui = vim.api.nvim_list_uis()[1]
local width = math.floor(ui.width * 0.8)
local height = math.floor(ui.height * 0.8)
local col = math.floor((ui.width - width) / 2)
local row = math.floor((ui.height - height) / 2)

local create_window = function()
    buf = vim.api.nvim_create_buf(false, true)
end

local toggle_term_window = function()
    local created_window = false
    if buf == 0 then
        create_window()
        created_window = true
    end

    if not shown then
        win = vim.api.nvim_open_win(buf, true, {
            relative = "editor",
            width = width,
            height = height,
            col = col,
            row = row,
            style = "minimal",
            border = "rounded",
        })
        vim.api.nvim_set_current_buf(buf)
        if created_window then
            vim.cmd("terminal")
        end
    else
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
    end

    -- Invert shown
    shown = not shown
end

function M.setup()
    vim.api.nvim_create_user_command("NikolaToggleTerm", toggle_term_window, {
        nargs = "*",
        desc = "Toggle the popup terminal window with console",
    })
    vim.keymap.set({ "n", "t" }, "<M-t>", toggle_term_window)
end

return M
