local kn_l_map = require("keymappings").kn_l_map
kn_l_map("cr", function()
    vim.cmd("split | term cargo run")
end)
