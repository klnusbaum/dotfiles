local M = {}

local personal_group = vim.api.nvim_create_augroup("Personal", { clear = true })

function M.new_autocmd(events, opts)
  local all_opts = { group = personal_group }
  if opts then
    all_opts = vim.tbl_extend("force", all_opts, opts)
  end
  vim.api.nvim_create_autocmd(events, all_opts)
end

return M
