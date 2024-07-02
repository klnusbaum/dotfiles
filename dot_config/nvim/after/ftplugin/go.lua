vim.keymap.set('n', '<leader>cb', function()
    vim.cmd.vsplit()
    vim.cmd.term('go build')
end)
vim.keymap.set('n', '<leader>cr', function()
    vim.cmd.vsplit()
    vim.cmd.term('go run main.go')
end)
vim.keymap.set('n', '<leader>ct', function()
    vim.cmd.vsplit()
    vim.cmd.lcd('%:p:h')
    vim.cmd.term('go test')
end)
