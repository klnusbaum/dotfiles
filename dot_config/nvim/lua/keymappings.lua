local M = {}

function M.kt_map(shortcut, action)
    vim.keymap.set('t', shortcut, action)
end

function M.kn_map(shortcut, action, opts)
    vim.keymap.set('n', shortcut, action, opts)
end

function M.kn_l_map(shortcut, action, opts)
    vim.keymap.set('n', '<leader>' .. shortcut, action, opts)
end

function M.kv_l_map(shortcut, action, opts)
    vim.keymap.set('v', '<leader>' .. shortcut, action, opts)
end

return M
