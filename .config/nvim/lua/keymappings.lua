local M = {}

function M.kt_map(shortcut, action)
    vim.keymap.set('t', shortcut, action)
end

function M.kn_map(shortcut, action, opts)
    vim.keymap.set('n', '<leader>' .. shortcut, action)
end

return M
