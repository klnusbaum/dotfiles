local M = {}

function M.init_term_win()
     vim.wo.number = false
     vim.wo.relativenumber = false
     vim.cmd "startinsert"
 end

 return M
