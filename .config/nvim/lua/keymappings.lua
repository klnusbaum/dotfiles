local M = {}

local function makemap(mode, shortcut, action)
  vim.keymap.set(mode, shortcut, action, { noremap = true })
end

function M.tkmap(shortcut, action)
    makemap('t', shortcut, action, { noremap = true })
end

function M.nkmap(shortcut, action)
    makemap('n', '<leader>' .. shortcut, action, { noremap = true })
end

return M
