return {
    'ojroques/nvim-osc52',
    config = function(_, opts)
        local osc52 = require 'osc52'

        osc52.setup(opts)
        vim.keymap.set('n', '<leader>y', osc52.copy_operator, { expr = true })
        vim.keymap.set('n', '<leader>yy', '<leader>y_', { remap = true })
        vim.keymap.set('v', '<leader>y', osc52.copy_visual)
    end
}
