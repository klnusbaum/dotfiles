local M = {}

function M.ext_opts(defaults, opts)
  local all_opts = defaults
  if opts then
    all_opts = vim.tbl_extend("force", all_opts, opts)
  end
  return all_opts
end

return M
