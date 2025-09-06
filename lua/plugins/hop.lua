return {
    'smoka7/hop.nvim',
    version = "v2.7",
    config = function() 
        local hop = require("hop")
        local directions = require('hop.hint').HintDirection

        hop.setup {}

        vim.keymap.set('', '<leader>g', hop.hint_char1)
    end 
}
