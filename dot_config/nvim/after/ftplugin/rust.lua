vim.keymap.set('n', '<leader>cb', function()
    vim.cmd.vsplit()
    vim.cmd.term('cargo build')
end)
vim.keymap.set('n', '<leader>cr', function()
    vim.cmd.vsplit()
    vim.cmd.term('cargo run')
end)