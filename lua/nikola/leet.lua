--- Only create these if you are in a leet code
--- directory at home.

local M = {}

--- @todo: Map this to as shortcut
--- @todo: Add a yank specifically for the code and usings

local open_buffer_and_set_as_active = function(name)
    vim.cmd("edit " .. name)
    vim.cmd("write!")
end

local add_module_to_lib = function(name)
    local lib = vim.fn.getcwd() .. "/src/lib.rs"

    local f = io.open(lib, "r")
    local content = ""
    if f then
        content = f:read("*all")
        f:close()
    end

    -- Write the new line + old content
    f = io.open(lib, "w")
    if f then
        f:write("mod " .. name .. ";\n" .. content)
        f:close()
    else
        error("Could not open file for writing: " .. lib)
    end

    -- format lib
    vim.system({ "rustfmt", lib })
end

local save_file = function(name, lines)
    local new_file = vim.fn.getcwd() .. "/src/" .. name .. ".rs"

    if vim.fn.filereadable(new_file) == 1 then
        vim.notify("File `" .. new_file .. "` already exists so pick a different name", vim.log.levels.ERROR)
        return
    end

    local fd = io.open(new_file, "w")
    if fd then
        fd:write(table.concat(lines, "\n"))
        fd:close()
    else
        vim.notify("Failed to write to `" .. new_file .. "`", vim.log.levels.ERROR)
        return
    end

    -- format the new file
    vim.system({ "rustfmt", new_file })
    add_module_to_lib(name)
    open_buffer_and_set_as_active(new_file)
end

local parse_lines = function(lines)
    local contents = {}
    local problem_name = nil

    for _, line in ipairs(lines) do
        local comment = line:match("^%s*//%s*(.*)")
        if comment then
            local name = comment:match("Problem name:%s*`([^`]+)`")
            if name then
                problem_name = name
            end
        else
            table.insert(contents, line)
        end
    end

    -- This is just randomly picked because it will usually be something like the following
    -- impl Solution {
    --      pub fn find_even_numbers(digits: Vec<i32>) -> Vec<i32> {
    --
    --      }
    -- }
    if #contents <= 2 then
        vim.notify("No contents detected. Did you paste the snippet from the leet code?", vim.log.levels.ERROR)
        return
    end

    table.insert(contents, 1, "use crate::Solution;")

    -- Generate two test cases
    for _, test_case in ipairs({ 1, 2 }) do
        table.insert(contents, "")
        table.insert(contents, "#[test]")
        table.insert(contents, "fn " .. problem_name .. "_" .. test_case .. "()" .. "{}")
    end

    save_file(problem_name, contents)
end

function M.setup()
    local working_dir = vim.fn.getcwd()
    local pattern = "work/Personal/some-more-leet"
    -- local pattern = ".config/nvim"

    -- Check if we are in the correct directory
    if working_dir:sub(- #pattern) ~= pattern then
        return
    end
    vim.notify("Detected leet dir, loading some utilities...", vim.log.levels.INFO)

    -- Add a command to open a buffer, paste the text and close the buffer
    vim.api.nvim_create_user_command("LeetPaste", function()
        --   Create a scratch buffer
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_set_current_buf(buf)
        vim.bo[buf].filetype = "rust"

        -- Paste the provided text (from args) or a default snippet
        local text = { "// Paste the initialization code from leetcode below this comment.",
            "// The comments will be ignored and whatever is commented will be skipped in the actual snippet. ",
            "// ",
            "// Enter the problem name between ``.",
            "// **NOTE**: the problem name should be a single word without `*.rs` at the end.",
            "// Problem name: `some_problem`", "//", "" }
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, text)

        -- Find the line and column to place the cursor
        local target_line = 6
        local col = text[target_line]:find("some_problem") - 1
        -- Set cursor position in the current window
        vim.api.nvim_win_set_cursor(0, { target_line, col })

        -- Map <CR> in normal mode for this buffer only
        vim.keymap.set("n", "<CR>", function()
            local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
            parse_lines(lines)
            if vim.api.nvim_buf_is_valid(buf) then
                vim.api.nvim_buf_delete(buf, { force = true })
            end
        end, { buffer = buf, nowait = true })
    end, {
        nargs = "*",
        desc = "Open a scratch buffer, paste text, and close it",
    })
end

return M
