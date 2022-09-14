local Augroup = require('kautocmd').Augroup
local M = {}

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

local current_win = vim.api.nvim_get_current_win
local current_buf = vim.api.nvim_get_current_buf
local buf_delete = vim.api.nvim_buf_delete
local current_buf_contents = require("kbufhelpers").current_buf_contents
local set_current_buf_contents = require("kbufhelpers").set_current_buf_contents
local TMPDIR = vim.env.TMPDIR or "/tmp/"

local function msg_file_path()
  local parent_commit = vim.fn.system 'git rev-parse HEAD^'
  return TMPDIR .. MSG_FILENAME_PREFIX .. '_' .. parent_commit:gsub("%s+$", "")
end

local function default_msg_file_content()
  local commit_msg = vim.fn.system 'git log -n 1 --pretty=format:"%s"'
  return commit_msg .. '\n\n' .. DIFF_TEMPLATE
end

local function submit_diff(diff_msg_file)
  vim.cmd("vsplit | term echo diffing... && arc diff HEAD^ -F " .. diff_msg_file .. " && rm " .. diff_msg_file)
end

function M.create_diff()
  local diff_msg_file =  msg_file_path()
  vim.cmd("vsplit " .. diff_msg_file)
  if current_buf_contents() == "" then
    set_current_buf_contents(default_msg_file_content())
  end

  local diff_group = Augroup:new("diffgroup")
  local diff_buf = current_buf()
  diff_group:add_cmd("WinClosed", {
    pattern = "" .. current_win(),
    nested = true,
    callback = function()
      submit_diff(diff_msg_file)
      buf_delete(diff_buf, {})
      return true -- delete this autocmd once it's run since we don't need it anymore
    end,
  })
end

return M
