local M = {}

local ext_opts = require('options').ext_opts

local Augroup = {}
Augroup.__index = Augroup

function Augroup:new(name)
  local group = {
      id = vim.api.nvim_create_augroup(name, { clear = true })
  }
  return setmetatable(group, self)
end

function Augroup:add_cmd(events, opts)
    local all_opts = ext_opts({ group = self.id }, opts)
    vim.api.nvim_create_autocmd(events, all_opts)
end

function Augroup:delete()
    vim.api.delete_augroup_by_id(self.id)
end

M.Augroup = Augroup

return M

