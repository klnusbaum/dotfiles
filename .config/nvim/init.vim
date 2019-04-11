" plugins {{{
call plug#begin('~/.local/share/nvim/plugged')
Plug 'tpope/vim-sensible'
Plug 'fatih/vim-go'
Plug 'kien/ctrlp.vim'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'rust-lang/rust.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'autozimu/LanguageClient-neovim', {
  \ 'branch': 'next',
  \ 'do': 'bash install.sh',
  \ } 
call plug#end()
" }}}

" netrw {{{
let g:netrw_liststyle = 3
let g:netrw_banner = 1
" }}}

" Misc Options {{{
set mouse=a
set tabstop=4
set ruler
syntax on
set smartindent
" line numbers
set nu
" hide buffers when going to a new buffer, don't close them
set hidden
" }}}

" vimscript editing convenience {{{
nnoremap <leader>ev :split $MYVIMRC<cr>
inoremap <leader>ev <esc>:split $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
" }}}

" {{{
let g:LanguageClient_serverCommands = {
  \ 'rust': ['rustup', 'run', 'stable', 'rls'],
  \ 'go': ['gopls'] }
autocmd BufWritePre *.go :call LanguageClient#textDocument_formatting_sync()
" The call to GoImports shouldn't be necessary, but the above call to
" textDocument_formatting_sync doesn't seem to be adding the imports like it
" should
autocmd BufWritePre *.go :GoImports
" }}}

" Vim Go {{{
let g:go_def_mode='gopls'
" }}}

" Rust Options {{{
let g:rustfmt_autosave = 1
" }}}

" airline settings {{{
let g:airline_theme='deus'
let g:airline_powerline_fonts = 1
" }}}

" Wildignore stuff {{{
set wildignore+=*/buck-out/*
set wildignore+=*/target/*
" }}}
