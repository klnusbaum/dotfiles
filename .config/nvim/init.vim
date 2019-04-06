" plugins {{{
call plug#begin('~/.local/share/nvim/plugged')
Plug 'tpope/vim-sensible'
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'vim-syntastic/syntastic'
Plug 'kien/ctrlp.vim'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'artur-shaik/vim-javacomplete2'
Plug 'solarnz/thrift.vim'
Plug 'rust-lang/rust.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'majutsushi/tagbar'
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

" Syntastic settings {{{
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" }}}

" Rust Options {{{
let g:rustfmt_autosave = 1

au FileType rust nmap <leader>gd <Plug>(rust-def)
au FileType rust nmap <leader>gs <Plug>(rust-def-split)
au FileType rust nmap <leader>gx <Plug>(rust-def-vertical)
au FileType rust nmap <leader>go <Plug>(rust-doc)
" }}}

" airline settings {{{
let g:airline_theme='deus'
" }}}

" Wildignore stuff {{{
set wildignore+=*/buck-out/*
set wildignore+=*/target/*
" }}}
