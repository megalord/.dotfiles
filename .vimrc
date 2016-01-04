set t_Co=256

set nocompatible              " be iMproved, required

call plug#begin('~/.vim/bundle')
" Utils
Plug 'scrooloose/nerdtree'
Plug 'kien/ctrlp.vim'
Plug 'bling/vim-airline'
Plug 'Lokaltog/vim-easymotion'
Plug 'docunext/closetag.vim'
Plug 'godlygeek/tabular'
Plug 'Shougo/vimproc.vim'

" Language specific
Plug 'kchmck/vim-coffee-script'
Plug 'pangloss/vim-javascript'
Plug 'tpope/vim-rails'
Plug 'elzr/vim-json'
Plug 'groenewege/vim-less'
Plug 'derekwyatt/vim-scala'
Plug 'hdima/python-syntax'
Plug 'neovimhaskell/haskell-vim'
Plug 'Twinside/vim-hoogle'
Plug 'eagletmt/ghcmod-vim'

" Lisps
Plug 'wlangstroth/vim-racket'
Plug 'spinningarrow/vim-niji'
"Plug 'jgdavey/tslime.vim'
Plug 'paredit.vim'

" Style
Plug 'tomasr/molokai'

" lulz
Plug 'mattn/flappyvird-vim'

call plug#end()


au Bufread,BufNewFile *.asd   setfiletype lisp
let g:ctrlp_custom_ignore = '\v[\/](node_modules|\.git|vendor|coverage|report|compiled|dist|tmp)$'

set mouse=

set modeline
set ls=2

colorscheme molokai
highlight Normal ctermfg=grey ctermbg=none
set nohlsearch

set smartindent
set expandtab
set tabstop=2
set shiftwidth=2
set backspace=2

"au Filetype javascript setl et tabstop=4 shiftwidth=4

set ruler

set splitbelow
set splitright

set nobackup
set nowritebackup

set scrolloff=5

let mapleader=","

let g:ctrlp_map = '<leader>f'
let g:ctrlp_working_path_mode = 0

let g:paredit_electric_return = 0

let g:niji_matching_filetypes = ['lisp', 'asd', 'racket']

"let python_highlight_all = 1

nmap <Leader>n :NERDTreeToggle<CR>
nmap <Leader>o :set paste!<CR>
nnoremap <Leader>b :buffer<Space>term<Tab>
nnoremap <Leader>g :CtrlPTag<CR>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap ; :
inoremap jk <ESC>


" Haskell helpers

" Show types in completion suggestions
let g:necoghc_enable_detailed_browse = 1
" Resolve ghcmod base directory
au FileType haskell let g:ghcmod_use_basedir = getcwd()

nnoremap <Leader>hh :Hoogle<CR>
nnoremap <Leader>hH :Hoogle
nnoremap <Leader>hi :HoogleInfo<CR>
nnoremap <Leader>hI :HoogleInfo
nnoremap <Leader>hz :HoogleClose<CR>
nnoremap <Leader>ht :GhcModType<CR>
nnoremap <Leader>hc :GhcModTypeClear<CR>


" neovim
if has('nvim')
  tnoremap jk <C-\><C-n>
  tnoremap <C-h> <C-\><C-n><C-w>h
  tnoremap <C-j> <C-\><C-n><C-w>j
  tnoremap <C-k> <C-\><C-n><C-w>k
  tnoremap <C-l> <C-\><C-n><C-w>l

  vmap <Leader>e y<C-l>p
  nmap <Leader>e vipy<C-l>p
  nnoremap <Leader>t :e term://zsh<CR>
  nnoremap <Leader>vt :vs term://zsh<CR>
  nmap <Leader>l :let @r = '(enter! ' . '"' . expand("%") . '")'<CR><C-l>"rpa<CR>
endif


augroup jump_to_tags
  autocmd!

  " Basically, <c-]> jumps to tags (like normal) and <c-\> opens the tag in a new
  " split instead.
  "
  " Both of them will align the destination line to the upper middle part of the
  " screen.  Both will pulse the cursor line so you can see where the hell you
  " are.  <c-\> will also fold everything in the buffer and then unfold just
  " enough for you to see the destination line.
  nnoremap <c-]> <c-]>mzzvzz15<c-e>`z:Pulse<cr>
  nnoremap <c-\> <c-w>v<c-]>mzzMzvzz15<c-e>`z:Pulse<cr>

  " Pulse Line (thanks Steve Losh)
  function! s:Pulse() " {{{
    redir => old_hi
    silent execute 'hi CursorLine'
    redir END
    let old_hi = split(old_hi, '\n')[0]
    let old_hi = substitute(old_hi, 'xxx', '', '')

    let steps = 8
    let width = 1
    let start = width
    let end = steps * width
    let color = 233

    for i in range(start, end, width)
      execute "hi CursorLine ctermbg=" . (color + i)
      redraw
      sleep 6m
    endfor
    for i in range(end, start, -1 * width)
      execute "hi CursorLine ctermbg=" . (color + i)
      redraw
      sleep 6m
    endfor

    execute 'hi ' . old_hi
  endfunction " }}}

  command! -nargs=0 Pulse call s:Pulse()
augroup END
