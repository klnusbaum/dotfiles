local kn_l_map = require("keymappings").kn_l_map
kn_l_map("cr", function()
    vim.api.nvim_command("split | term cargo run")
end)
