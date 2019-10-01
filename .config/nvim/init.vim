" plugins {{{
call plug#begin('~/.local/share/nvim/plugged')
Plug 'tpope/vim-sensible'
Plug 'kien/ctrlp.vim'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'vim-airline/vim-airline'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'rust-lang/rust.vim'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
call plug#end()
" }}}

" netrw {{{
let g:netrw_liststyle = 3
let g:netrw_banner = 1
" }}}

" Misc Options {{{
set mouse=a
set tabstop=2
set shiftwidth=2
set expandtab
set ruler
syntax on
set smartindent
" line numbers
set nu
" }}}

" vimscript editing convenience {{{
nnoremap <leader>ev :split $MYVIMRC<cr>
inoremap <leader>ev <esc>:split $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
" }}}


" fun short cuts {{{
nnoremap <leader>ss :set spell<cr>
inoremap <leader>ss <esc>:set spell<cr>
nnoremap <leader>ns :set nospell<cr>
inoremap <leader>ns <esc>:set nospell<cr>
" }}}

" vim-go {{{
let g:go_fmt_command = "goimports"
autocmd FileType go nnoremap <leader>ts :GoTest<cr>
" }}}

" rust vim {{{
let g:rustfmt_autosave = 1 
autocmd FileType rust nnoremap <leader>ts :RustTest<cr>
" }}}

" deoplete {{{
let g:deoplete#enable_at_startup = 1
" }}}

" airline settings {{{
let g:airline_theme='deus'
let g:airline_powerline_fonts = 1
" }}}

" ctrlp {{{
let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
" ripgrep is fase enough that you can turn off caching.
let g:ctrlp_use_caching = 1
" }}}

" nerdtree {{{
nmap <F6> :NERDTreeToggle<CR>
" }}}

" Wildignore stuff {{{
set wildignore+=*/buck-out/*
set wildignore+=*/target/*
" }}}
