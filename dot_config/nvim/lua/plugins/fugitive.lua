return {
    'tpope/vim-fugitive',
    config = function()
        vim.keymap.set('n', '<leader>gu', function()
            vim.cmd("Git add --update")
            vim.notify('git added all updated files')
        end)
        vim.keymap.set('n', '<leader>ga', function() vim.cmd("Git commit --amend --no-edit") end)
        vim.keymap.set('n', '<leader>grc', function() vim.cmd("Git rebase --continue") end)
        vim.keymap.set('n', '<leader>gp', function() vim.cmd("Git pull --rebase") end)
        vim.keymap.set('n', '<leader>gP', function() vim.cmd("Git push") end)
        vim.keymap.set('n', '<leader>gs', vim.cmd.Git)
        vim.keymap.set('n', '<leader>gF', function() vim.cmd("Git fetch") end)
        vim.keymap.set('n', '<leader>gS', function() vim.cmd("Git stash") end)
        vim.keymap.set('n', '<leader>gd', function() vim.cmd("Git diff") end)
        vim.keymap.set('n', '<leader>gc', function() vim.cmd("Git commit") end)
    end
}
