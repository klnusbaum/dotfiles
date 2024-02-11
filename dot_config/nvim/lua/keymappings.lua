local M = {}

function M.kv_l_map(shortcut, action, opts)
    vim.keymap.set('v', '<leader>' .. shortcut, action, opts)
end

return M
