local M = {}

local function makemap(mode, lhs, rhs)
  vim.keymap.set(mode, lhs, rhs, { noremap = true })
end

function M.tkmap(lhs, rhs)
    makemap('t', lhs, rhs, { noremap = true })
end

function M.nkmap(lhs, rhs)
    makemap('n', lhs, rhs, { noremap = true })
end

return M
