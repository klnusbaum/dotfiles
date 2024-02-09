local kn_l_map = require("keymappings").kn_l_map

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
        kn_l_map('Sc', function()
            vim.ui.input({
                prompt = 'Create new session named: ',
                default = vim.fs.basename(vim.fn.getcwd()),
            }, function(session_name)
                if session_name ~= nil then
                    sessions.write(session_name, {})
                end
            end)
        end, { desc = 'Create new session' })
        kn_l_map('Sr', function() sessions.select('read', {}) end, { desc = 'Read session' })
        kn_l_map('Sw', function() sessions.select('write', {}) end, { desc = 'Write session' })
        kn_l_map('Sd', function() sessions.select('delete', {}) end, { desc = 'Delete session' })
    end
}
