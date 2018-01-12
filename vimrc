execute pathogen#infect()
syntax enable
set hlsearch
set background=dark
let g:solarized_termcolors=256
let g:solarized_termtrans=1
colorscheme solarized
" colorscheme vividchalk
filetype plugin indent on
filetype on
filetype indent on
filetype plugin on
set nocompatible
set mouse=a
set expandtab
set tabstop=2 shiftwidth=2 softtabstop=2
set autoindent
let g:airline#extensions#tabline#enabled = 1
set laststatus=2
" for fugitive
set statusline+=%{fugitive#statusline()}
" For syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" end syntastic
