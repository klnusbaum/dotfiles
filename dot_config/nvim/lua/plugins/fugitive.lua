return {
    'tpope/vim-fugitive',
    config = function()
        vim.keymap.set('n', '<leader>ggu', function()
            vim.cmd("Git add --update")
            vim.notify('git added all updated files')
        end)
        vim.keymap.set('n', '<leader>gga', function() vim.cmd("Git commit --amend --no-edit") end)
        vim.keymap.set('n', '<leader>ggc', function()
            vim.ui.input({ prompt = 'Commit message: ' }, function(input)
                if input ~= nil and input ~= "" then
                    vim.cmd('Git commit -m "' .. input .. '"')
                else
                    vim.notify("Commit aborted")
                end
            end)
        end)
        vim.keymap.set('n', '<leader>ggrc', function() vim.cmd("Git rebase --continue") end)
        vim.keymap.set('n', '<leader>ggpu', function() vim.cmd("Git push") end)
        vim.keymap.set('n', '<leader>ggs', vim.cmd.Git)
    end
}
