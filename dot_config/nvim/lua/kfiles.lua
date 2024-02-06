local M = {}

-- nvim defines 0 as the number of what ever the current buffer is
-- TODO switch to nvim_get_current_buffer
local CURRENT_BUFFER_NUMBER = 0

function M.cur_file()
  return vim.api.nvim_buf_get_name(CURRENT_BUFFER_NUMBER)
end

return M
