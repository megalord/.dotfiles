set t_Co=256

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Utils
Plugin 'scrooloose/nerdtree'
Plugin 'kien/ctrlp.vim'
Plugin 'bling/vim-airline'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'docunext/closetag.vim'

" Language specific
Plugin 'kchmck/vim-coffee-script'
Plugin 'pangloss/vim-javascript'
Plugin 'tpope/vim-rails'
Plugin 'elzr/vim-json'
Plugin 'groenewege/vim-less'
Plugin 'derekwyatt/vim-scala'

" Lisps
Plugin 'wlangstroth/vim-racket'
Plugin 'amdt/vim-niji'
"Plugin 'jgdavey/tslime.vim'
Plugin 'paredit.vim'

" Style
Plugin 'tomasr/molokai'


" All of your Plugins must be added before the following line
call vundle#end()            " required
syntax enable
filetype plugin indent on    " required

au Bufread,BufNewFile *.asd   setfiletype lisp
let g:ctrlp_custom_ignore = '\v[\/](node_modules|\.git|vendor|coverage|report|compiled|dist)$'

set modeline
set ls=2

colorscheme molokai
highlight Normal ctermfg=grey ctermbg=none

set smartindent
set expandtab
set tabstop=2
set shiftwidth=2
set backspace=2

au Filetype javascript setl et tabstop=4 shiftwidth=4

set ruler

set splitbelow
set splitright

set nobackup
set nowritebackup

set scrolloff=5

let mapleader=","

let g:ctrlp_map = '<leader>f'

let g:paredit_electric_return = 0

let g:niji_matching_filetypes = ['lisp', 'asd', 'racket']

nmap <Leader>n :NERDTreeToggle<CR>
nmap <Leader>o :set paste!<CR>

"vmap <Leader>e <Plug>SendSelectionToTmux
"nmap <Leader>e <Plug>NormalModeSendToTmux
"nmap <Leader>t <Plug>SetTmuxVars
"nmap <Leader>l :call SendToTmux('(enter! ' . '"' . @% . '")')<CR>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap ; :
inoremap jj <ESC>

" neovim
if has('nvim')
  tnoremap jj <C-\><C-n>
  tnoremap <C-h> <C-\><C-n><C-w>h
  tnoremap <C-j> <C-\><C-n><C-w>j
  tnoremap <C-k> <C-\><C-n><C-w>k
  tnoremap <C-l> <C-\><C-n><C-w>l

  vmap <Leader>e y<C-l>p
  nmap <Leader>e vipy<C-l>p
  nmap <Leader>t ;vs term://zsh<CR>
  nmap <Leader>l :let @r = '(enter! ' . '"' . expand("%") . '")'<CR><C-l>"rpa<CR>
endif
