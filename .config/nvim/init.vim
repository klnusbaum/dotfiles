" plugins {{{
call plug#begin('~/.local/share/nvim/plugged')
Plug 'kien/ctrlp.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'rust-lang/rust.vim'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'Olical/conjure'
call plug#end()
" }}}

" netrw {{{
lua << EOF
vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 1
EOF
" }}}

" Misc Options {{{
lua << EOF
vim.opt.nu=true
vim.opt.mouse=a
vim.opt.tabstop=2
vim.opt.shiftwidth=2
vim.opt.expandtab=true
vim.opt.smartindent=true
vim.opt.clipboard=unnamed
vim.opt.splitbelow=true
vim.opt.splitright=true
EOF
" }}}

" terminal customizations {{{
autocmd TermOpen * setlocal nonumber norelativenumber
autocmd BufWinEnter,WinEnter term://* startinsert

tnoremap <c-\><c-w> <c-\><c-n><c-w><c-w>
tnoremap <c-\><c-h> <c-\><c-n><c-w>h
tnoremap <c-\><c-j> <c-\><c-n><c-w>j
tnoremap <c-\><c-k> <c-\><c-n><c-w>k
tnoremap <c-\><c-l> <c-\><c-n><c-w>l

command! Ot :vsplit term://zsh
nnoremap <leader>ot :Ot<enter>
inoremap <leader>ot <esc>:Ot<enter>
" }}}

" vimscript editing convenience {{{
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
inoremap <leader>ev <esc>:vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
" }}}

" netrw launching {{{
function! _Dir()
    execute 'vsplit' expand('%:p:h')
endfunction

command! Dir call _Dir()

" Quickly call Dir function.
nnoremap <leader>u :Dir<enter>
" }}}

" bazel auto format {{{
autocmd BufWritePost *.star,*.bzl,*.bazel execute "! /Users/kurtis/go-code/bin/buildifier " . shellescape(expand('%p')) . " || read"  | redraw!
autocmd BufWritePost *.star,*.bzl,*.bazel edit | redraw
" }}}


" spelling short cuts {{{
lua << EOF
vim.keymap.set("n", "<leader>ss", ":set spell<cr>", {})
vim.keymap.set("i", "<leader>ss", "<esc>:set spell<cr>", {})
vim.keymap.set("n", "<leader>ns", ":set nospell<cr>", {})
vim.keymap.set("i", "<leader>ns", "<esc>:set nospell<cr>", {})
EOF
" }}}

" vim-go {{{
let g:go_fmt_options = {
    \ 'gopls': '-local selector,inventory,gopkg.in,google.golang.org,code.uber.internal,thriftrw,thrift,gogoproto,go.uber.org,golang.org,github.com,mock',
    \ }
autocmd FileType go nnoremap <leader>ts :GoTest<cr>
autocmd FileType go nnoremap <leader>at :GoAlternate<cr>
" }}}

" rust vim {{{
lua << EOF
vim.g.rustfmt_autosave = 1 
EOF
autocmd FileType rust nnoremap <leader>ts :RustTest<cr>
" }}}

" airline settings {{{
lua << EOF
vim.g.airline_theme = 'deus'
EOF
" }}}

" ctrlp {{{
lua << EOF
vim.g.ctrlp_user_command = 'rg %s --files --color=never --glob ""'
vim.g.ctrlp_use_caching = 1
vim.g.ctrlp_working_path_mode = 0
EOF
" }}}

" markdown editing {{{
" Use gq to format Markdown to 100 chars.
au BufRead,BufNewFile *.md setlocal textwidth=100
" }}}

" git stuff {{{
command! QuickUpdate :Git add --update <bar> Git commit --amend --no-edit

nnoremap <leader>qu :QuickUpdate<cr>
nnoremap <leader>gga :Git add --update<cr>

lua << EOF
vim.keymap.set('n', '<leader>ggc', function()
  vim.ui.input({ prompt = 'Commit message: '}, function(input)
    vim.api.nvim_command('Git commit -m "' .. input .. '"')
  end)
end)
EOF
" }}}

" arc stuff {{{
command! Ad :vsplit term://ad
nnoremap <leader>ad :Ad<cr>
inoremap <leader>ad <esc>:Ad<cr>

lua << EOF
vim.keymap.set('n', '<leader>ud', function()
  vim.ui.input({ prompt = 'Diff message: '}, function(input)
    vim.api.nvim_command('vs | term arc diff HEAD^ -m "' .. input .. '"')
  end)
end)
EOF
" }}}

" Wildignore stuff {{{
set wildignore+=*/buck-out/*
set wildignore+=*/target/*
" }}}
