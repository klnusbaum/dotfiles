return {
    'ojroques/nvim-osc52',
    config = function(_, opts)
        local osc52 = require 'osc52'
        local kn_l_map = require("keymappings").kn_l_map
        local kv_l_map = require("keymappings").kv_l_map

        osc52.setup(opts)
        kn_l_map('y', osc52.copy_operator, {expr = true})
        kn_l_map('yy', '<leader>y_', {remap = true})
        kv_l_map('y', osc52.copy_visual)
    end
}
