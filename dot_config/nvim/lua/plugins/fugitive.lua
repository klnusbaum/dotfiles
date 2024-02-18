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
    end
}
