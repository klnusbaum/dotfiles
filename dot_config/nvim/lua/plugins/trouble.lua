return {
    'folke/trouble.nvim',
    config = function(_, opts)
        local trouble = require 'trouble'
        trouble.setup(opts)

        vim.keymap.set('n', '<leader>xx', trouble.toggle, { desc = 'Trouble' })
        vim.keymap.set('n', '<leader>xw', function()
            trouble.toggle('workspace_diagnostics')
        end, { desc = 'Workspace Diagnostics' })
        vim.keymap.set('n', '[x',
            function()
                trouble.previous({ skip_groups = true, jump = true })
            end, { desc = 'Previous trouble' })
        vim.keymap.set('n', ']x',
            function()
                trouble.next({ skip_groups = true, jump = true })
            end,
            { desc = 'Next trouble' })
    end,
}
