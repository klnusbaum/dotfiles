return {
    'ojroques/nvim-osc52',
    config = function(_, opts)
        local osc52 = require 'osc52'
        local kv_l_map = require("keymappings").kv_l_map

        osc52.setup(opts)
        vim.keymap.set('n', '<leader>y', osc52.copy_operator, { expr = true })
        vim.keymap.set('n', '<leader>yy', '<leader>y_', { remap = true })
        kv_l_map('y', osc52.copy_visual)
    end
}
