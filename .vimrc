"if $COLORTERM == 'gnome-terminal'
    set t_Co=256
"endif
syntax on

" use custom javascript syntax
au BufReadPost *.js set syntax=myjs

" show filename
set modeline
set ls=2

" colorscheme
colorscheme molokai

" tabs/spaces
set smartindent
set expandtab
set tabstop=4
set shiftwidth=4

" line numbers
set number
