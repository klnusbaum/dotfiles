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
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'Olical/conjure'
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
set nu
set clipboard=unnamed
" }}}

" terminal customizations {{{
autocmd TermOpen * setlocal nonumber norelativenumber

tnoremap <c-\><c-w> <c-\><c-n><c-w><c-w>

command! Ot :vsplit term://zsh
nnoremap <leader>ot :Ot<enter>a
inoremap <leader>ot <esc>:Ot<enter>a
" }}}

" vimscript editing convenience {{{
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
inoremap <leader>ev <esc>:vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
" }}}

" split preferences {{{
set splitbelow
set splitright
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
nnoremap <leader>ss :set spell<cr>
inoremap <leader>ss <esc>:set spell<cr>
nnoremap <leader>ns :set nospell<cr>
inoremap <leader>ns <esc>:set nospell<cr>
" }}}

" vim-go {{{
let g:go_fmt_options = {
    \ 'gopls': '-local selector,inventory,gopkg.in,google.golang.org,code.uber.internal,thriftrw,thrift,gogoproto,go.uber.org,golang.org,github.com,mock',
    \ }
autocmd FileType go nnoremap <leader>ts :GoTest<cr>
autocmd FileType go nnoremap <leader>at :GoAlternate<cr>
" }}}

" rust vim {{{
let g:rustfmt_autosave = 1 
autocmd FileType rust nnoremap <leader>ts :RustTest<cr>
" }}}

" airline settings {{{
let g:airline_theme='deus'
" }}}

" ctrlp {{{
let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
let g:ctrlp_use_caching = 1
let g:ctrlp_working_path_mode = 0
" }}}

" nerdtree {{{
nmap <F6> :NERDTreeToggle<CR>
" }}}

" markdown editing {{{
" Use gq to format Markdown to 100 chars.
au BufRead,BufNewFile *.md setlocal textwidth=100
" }}}

" Wildignore stuff {{{
set wildignore+=*/buck-out/*
set wildignore+=*/target/*
" }}}
