-- Switch to utilizing special nvim path if it exists
vim.env.PATH = vim.env.NVIM_PATH or vim.env.PATH

-- load plugins
require('kplugins')

-- helper functions
local kt_map = require("keymappings").kt_map
local kn_map = require("keymappings").kn_map
local kn_l_map = require("keymappings").kn_l_map
local new_autocmd = require("myautocmd").create_personal_group().new_autocmd
local cur_file = require("kfiles").cur_file

-- Misc options settings
vim.opt.nu=true
vim.opt.mouse=a
vim.opt.tabstop=2
vim.opt.shiftwidth=2
vim.opt.expandtab=true
vim.opt.smartindent=true
vim.opt.clipboard="unnamed"
vim.opt.splitbelow=true
vim.opt.splitright=true

-- terminal customizations 
new_autocmd("TermOpen", {
  pattern = "*",
  command = "setlocal nonumber",
})
new_autocmd({"BufWinEnter","WinEnter"}, {
  pattern = "term://*",
  command = "startinsert",
})

kt_map("<c-\\><c-w>","<c-\\><c-n><c-w><c-w>")
kt_map("<c-\\><c-h>","<c-\\><c-n><c-w>h")
kt_map("<c-\\><c-j>","<c-\\><c-n><c-w>j")
kt_map("<c-\\><c-k>","<c-\\><c-n><c-w>k")
kt_map("<c-\\><c-l>","<c-\\><c-n><c-w>l")

kn_l_map("ot", function()
  vim.api.nvim_command("vsplit | term")
end)

-- vim config editing convenience
kn_l_map("ev", function ()
  vim.api.nvim_command("vsplit $MYVIMRC")
end)
kn_l_map("sv", function ()
  vim.api.nvim_command("source $MYVIMRC")
  vim.notify('Reloaded $MYVIMRC')
end)

-- Netrw settings
vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 1
kn_l_map("u", function()
  vim.api.nvim_command('Vexplore')
end)

-- spelling shortcuts
kn_l_map("ss", function()
  vim.opt.spell = true
end)
kn_l_map("ns", function()
  vim.opt.spell = false
end)

-- lsp settings
local function autofmt()
    vim.lsp.buf.formatting_sync(nil, 3000)
end
new_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = autofmt,
})

local lsp_on_attach = function(client, bufnr)
  local opts = { noremap=true, silent=true, buffer=bufnr}

  vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'

  kn_map('gd', vim.lsp.buf.definition, opts)
  kn_map('K', vim.lsp.buf.hover, opts)
end

local lsp_flags = {
  -- Don't spam LSP with changes. Wait a second between each.
  debounce_text_changes = 1000,
}

require('lspconfig').gopls.setup {
  cmd = {'gopls', '-remote=auto'},
  on_attach = lsp_on_attach,
  flags = lsp_flags,
}

-- Airline settings
vim.g.airline_theme = 'deus'

-- Fugitive (git) customizations
kn_l_map('ggu', function() 
  vim.api.nvim_command("Git add --update") 
  vim.notify('git added all updated files')
end)
kn_l_map('gga', function() vim.api.nvim_command("Git commit --amend --no-edit") end)
kn_l_map('ggc', function()
  vim.ui.input({ prompt = 'Commit message: '}, function(input)
    if input then
      vim.api.nvim_command('Git commit -m "' .. input .. '"')
    else 
      vim.notify("Commit aborted")
    end
  end)
end)

-- Arc customizations
kn_l_map("ad", function() vim.api.nvim_command("vsplit term://ad") end)
kn_l_map('ud', function()
  vim.ui.input({ prompt = 'Diff message: '}, function(input)
    vim.api.nvim_command('vs | term arc diff HEAD^ -m "' .. input .. '"')
  end)
end)

-- Bazel/Starlark
new_autocmd("BufWritePost", {
  pattern = { "*.star", "*.bzl", "*.bazel" },
  callback = function()
      vim.fn.system("buildifier " .. cur_file())
      vim.cmd("edit")
  end,
})

-- Telescope
local tele = require('telescope.builtin')
kn_l_map('tf', function() tele.find_files() end)
kn_l_map('th', function() tele.help_tags() end)
kn_l_map('tg', function() tele.live_grep() end)
