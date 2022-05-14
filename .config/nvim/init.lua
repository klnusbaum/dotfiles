-- Switch to utilizing special nvim path if it exists
vim.env.PATH = vim.env.NVIM_PATH or vim.env.PATH

require('kplugins')
local tkmap = require("keymappings").tkmap
local nkmap = require("keymappings").nkmap
local new_autocmd = require("myautocmd").new_autocmd
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

tkmap("<c-\\><c-w>","<c-\\><c-n><c-w><c-w>")
tkmap("<c-\\><c-h>","<c-\\><c-n><c-w>h")
tkmap("<c-\\><c-j>","<c-\\><c-n><c-w>j")
tkmap("<c-\\><c-k>","<c-\\><c-n><c-w>k")
tkmap("<c-\\><c-l>","<c-\\><c-n><c-w>l")

nkmap("ot", function()
  vim.api.nvim_command("vsplit | term")
end)

-- vim config editing convenience
nkmap("ev", function ()
  vim.api.nvim_command("vsplit $MYVIMRC")
end)
nkmap("sv", function ()
  vim.api.nvim_command("source $MYVIMRC")
  vim.notify('Reloaded $MYVIMRC')
end)

-- Netrw settings
vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 1
nkmap("u", function()
  vim.api.nvim_command('Vexplore')
end)

-- spelling shortcuts
nkmap("ss", function()
  vim.opt.spell = true
end)
nkmap("ns", function()
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

  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
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

-- ctrlp settings
vim.g.ctrlp_user_command = 'rg %s --files --color=never --glob ""'
vim.g.ctrlp_use_caching = 1
vim.g.ctrlp_working_path_mode = 0

-- Fugitive (git) customizations
nkmap('ggu', function() 
  vim.api.nvim_command("Git add --update") 
  vim.notify('git added all updated files')
end)
nkmap('gga', function() vim.api.nvim_command("Git commit --amend --no-edit") end)
nkmap('ggc', function()
  vim.ui.input({ prompt = 'Commit message: '}, function(input)
    vim.api.nvim_command('Git commit -m "' .. input .. '"')
  end)
end)

-- Arc customizations
nkmap("ad", function() vim.api.nvim_command("vsplit term://ad") end)
nkmap('ud', function()
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
nkmap('ff', function() tele.find_files() end)
nkmap('fh', function() tele.help_tags() end)
nkmap('fg', function() tele.live_grep() end)
