local M = {}

local ALL_LINES = -1
local get_lines = vim.api.nvim_buf_get_lines
local set_lines = vim.api.nvim_buf_set_lines
local get_current_buf = vim.api.nvim_get_current_buf

local function split_to_table(contents)
  local result = {};
  for line in string.gmatch(contents, "(.-)\n") do
      table.insert(result, line);
  end
  return result;
end

function M.current_buf_contents()
  local lines = get_lines(get_current_buf(), 0, ALL_LINES, false)
  return table.concat(lines, "\n")
end

function M.set_current_buf_contents(contents)
  local lines = split_to_table(contents)
  set_lines(get_current_buf(), 0, ALL_LINES, false, lines)
end

return M
