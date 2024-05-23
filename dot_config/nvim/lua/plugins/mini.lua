return {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
        -- Starter
        require("mini.starter").setup()

        -- Sessions
        local mini_sessions = require('mini.sessions')
        mini_sessions.setup()
        vim.keymap.set('n', '<leader>sc', function()
            vim.ui.input({
                prompt = 'Create new session named: ',
                default = vim.fs.basename(vim.fn.getcwd()),
            }, function(session_name)
                if session_name ~= nil and session_name ~= "" then
                    mini_sessions.write(session_name, {})
                end
            end)
        end, { desc = 'Create new session' })

        -- Surround
        require("mini.surround").setup()
    end
}
