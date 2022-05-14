local M = {}

local ext_opts = require('options').ext_opts

function M.create_personal_group()
  local personal_group_id = vim.api.nvim_create_augroup('Personal', { clear = true })
  local personal_group = {
    new_autocmd = function(events, opts)
      all_opts = ext_opts({ group = personal_group_id }, opts)
      vim.api.nvim_create_autocmd(events, all_opts)
    end
  }
  return personal_group
end

return M
