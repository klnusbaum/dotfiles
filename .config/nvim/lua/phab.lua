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
local create_autocmd = vim.api.nvim_create_autocmd
local current_buf_contents = require("kbufhelpers").current_buf_contents
local set_current_buf_contents = require("kbufhelpers").set_current_buf_contents

local function msg_file_path()
  local parent_commit = vim.fn.system 'git rev-parse HEAD^'
  return vim.env.TMPDIR .. MSG_FILENAME_PREFIX .. '_' .. parent_commit:gsub("%s+$", "")
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
  diff_group:add_cmd("WinClosed", {
    pattern = "" .. current_win(),
    nested = true,
    callback = function()
      submit_diff(diff_msg_file)
      diff_group:delete()
    end,
  })
end

return M
