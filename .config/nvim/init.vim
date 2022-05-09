" plugins {{{
call plug#begin('~/.local/share/nvim/plugged')
Plug 'kien/ctrlp.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'Olical/conjure'
call plug#end()
" }}}

lua << EOF
local tkmap = require("keymappings").tkmap
local nkmap = require("keymappings").nkmap
local new_autocmd = require("myautocmd").new_autocmd

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

-- vim-go settings
vim.g.go_fmt_options = {
   gopls= '-local selector,inventory,gopkg.in,google.golang.org,code.uber.internal,thriftrw,thrift,gogoproto,go.uber.org,golang.org,github.com,mock',
}

go_keymaps = function ()
  nkmap("ts", function() vim.api.nvim_command("GoTest") end)
  nkmap("at", function() vim.api.nvim_command("GoAlternate") end)
end

new_autocmd("Filetype", {
  pattern = "go",
  callback = go_keymaps,
})

-- Airline settings
vim.g.airline_theme = 'deus'

-- ctrlp settings
vim.g.ctrlp_user_command = 'rg %s --files --color=never --glob ""'
vim.g.ctrlp_use_caching = 1
vim.g.ctrlp_working_path_mode = 0

-- Fugitive (git) customizations
nkmap('ggu', function() vim.api.nvim_command("Git add --update") end)
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

EOF

" bazel auto format {{{
autocmd BufWritePost *.star,*.bzl,*.bazel execute "! /Users/kurtis/go-code/bin/buildifier " . shellescape(expand('%p')) . " || read"  | redraw!
autocmd BufWritePost *.star,*.bzl,*.bazel edit | redraw
" }}}


" Wildignore stuff {{{
set wildignore+=*/buck-out/*
set wildignore+=*/target/*
" }}}
