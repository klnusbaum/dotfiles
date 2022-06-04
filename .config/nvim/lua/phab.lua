local M = {}

local uv = vim.loop
local current_win = vim.api.nvim_get_current_win
local create_autocmd = vim.api.nvim_create_autocmd
local init_term_win = require('kterm').init_term_win

local MSG_FILENAME_PREFIX = "diffmsg"
local DIFF_TEMPLATE = [[
Summary: 

Test Plan: 

Reviewers: 

Subscribers: 

Tags: 

Revert Plan: 

JIRA Issues: 

API Changes: 

Monitoring and Alerts: 
]]

local function msg_file_path()
  local parent_commit = vim.fn.system 'git rev-parse HEAD^'
  return vim.env.TMPDIR .. MSG_FILENAME_PREFIX .. '_' .. parent_commit:gsub("%s+$", "")
end

local function default_msg_file_content()
  local commit_msg = vim.fn.system 'git log -n 1 --pretty=format:"%s"'
  return commit_msg .. '\n\n' .. DIFF_TEMPLATE
end

local function ensure_diff_msg_file(fname)
  if uv.fs_stat(fname) == nil then
    local fd = uv.fs_open(fname,"w", 438)
    uv.fs_write(fd, default_msg_file_content())
    uv.fs_close(fd)
  end
end

local function submit_diff(diff_msg_file)
  vim.cmd("vsplit | term arc diff HEAD^ -F " .. diff_msg_file .. " && rm " .. diff_msg_file)
  init_term_win()
end

function M.create_diff()
  local diff_msg_file =  msg_file_path()
  ensure_diff_msg_file(diff_msg_file)
  vim.cmd("vsplit " .. diff_msg_file)
  create_autocmd("WinClosed", {
    pattern = "" .. current_win(),
    callback = function()
      submit_diff(diff_msg_file)
    end,
  })
end

return M
