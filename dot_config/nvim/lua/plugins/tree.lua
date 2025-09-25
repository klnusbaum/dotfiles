return {
    'nvim-tree/nvim-tree.lua',
    config = function()
        require('nvim-tree').setup()
        local api = require('nvim-tree.api')

        -- nvim-tree session restore workaround
        vim.api.nvim_create_autocmd({ 'BufEnter' }, {
            pattern = 'NvimTree*',
            callback = function()
                if not api.tree.is_visible() then
                    api.tree.open()
                end
            end,
        })

        vim.keymap.set('n', '<leader>fd', function()
            api.tree.open({ find_file = true })
        end)
        vim.keymap.set('n', '<leader>fc', function()
            api.tree.close()
        end)
        vim.keymap.set('n', '<leader>ff', function()
            api.tree.focus()
        end)
    end
}
