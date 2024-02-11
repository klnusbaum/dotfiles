return {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
        -- Starter
        local starter = require("mini.starter")
        starter.setup()

        -- Sessions
        local sessions = require("mini.sessions")
        sessions.setup()
        vim.keymap.set('n', '<leader>Sc', function()
            vim.ui.input({
                prompt = 'Create new session named: ',
                default = vim.fs.basename(vim.fn.getcwd()),
            }, function(session_name)
                if session_name ~= nil then
                    sessions.write(session_name, {})
                end
            end)
        end, { desc = 'Create new session' })
        vim.keymap.set('n', '<leader>Sr', function() sessions.select('read', {}) end, { desc = 'Read session' })
        vim.keymap.set('n', '<leader>Sw', function() sessions.select('write', {}) end, { desc = 'Write session' })
        vim.keymap.set('n', '<leader>Sd', function() sessions.select('delete', {}) end, { desc = 'Delete session' })

        -- Surround
        require("mini.surround").setup()
    end
}
