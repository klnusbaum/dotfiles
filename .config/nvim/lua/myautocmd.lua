local M = {}

local ext_opts = require("options").ext_opts

local personal_group = vim.api.nvim_create_augroup("Personal", { clear = true })

function M.new_autocmd(events, opts)
  local all_opts = ext_opts({ group = personal_group}, opts)
  vim.api.nvim_create_autocmd(events, all_opts)
end

return M
