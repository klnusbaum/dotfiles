local M = {}

function M.tkmap(shortcut, action)
    vim.keymap.set('t', shortcut, action)
end

function M.nkmap(shortcut, action)
    vim.keymap.set('n', '<leader>' .. shortcut, action)
end

return M
