local M = {}

local GROUP_NAME = 'Personal'
local ext_opts = require('options').ext_opts

function M.create_personal_group()
  local personal_group_id = vim.api.nvim_create_augroup(GROUP_NAME, { clear = true })
  return {
    new_autocmd = function(events, opts)
      all_opts = ext_opts({ group = personal_group_id }, opts)
      vim.api.nvim_create_autocmd(events, all_opts)
    end,
    name = GROUP_NAME,
    id = personal_group_id,
  }
end

return M
