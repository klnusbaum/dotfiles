local M = {}

local Augroup = {}
Augroup.__index = Augroup

function Augroup:new(name)
  local group = {
      id = vim.api.nvim_create_augroup(name, { clear = true })
  }
  return setmetatable(group, self)
end

function Augroup:add_cmd(events, opts)
    opts.group = self.id
    vim.api.nvim_create_autocmd(events, opts)
end

function Augroup:delete()
    vim.api.nvim_del_augroup_by_id(self.id)
end

M.Augroup = Augroup

return M
