local M = {}

local ext_opts = require("options").ext_opts

function M.tkmap(shortcut, action)
    vim.keymap.set('t', shortcut, action)
end

function M.nkmap(shortcut, action, opts)
    local all_opts = ext_opts({ noremap = true }, opts)
    vim.keymap.set('n', '<leader>' .. shortcut, action, opts)
end

return M
