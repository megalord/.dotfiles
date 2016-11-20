set t_Co=256

set nocompatible              " be iMproved, required

" Look for rplugins
let &rtp = &rtp.','.expand('~').'/.nvim'

call plug#begin('~/.nvim/bundle')
" Utils
Plug 'scrooloose/nerdtree'
Plug 'kien/ctrlp.vim'
Plug 'bling/vim-airline'
Plug 'Lokaltog/vim-easymotion'
Plug 'docunext/closetag.vim'
Plug 'godlygeek/tabular'

" JS
Plug 'kchmck/vim-coffee-script'
Plug 'pangloss/vim-javascript'
Plug 'raichoo/purescript-vim'
Plug 'FrigoEU/psc-ide-vim'

" Web
Plug 'elzr/vim-json'
Plug 'groenewege/vim-less'

" Haskell
Plug 'neovimhaskell/haskell-vim'
Plug 'Twinside/vim-hoogle'
Plug 'eagletmt/ghcmod-vim'

" Lisps
Plug 'wlangstroth/vim-racket'
Plug 'paredit.vim'

" Other langs
Plug 'tpope/vim-rails'
Plug 'derekwyatt/vim-scala'
Plug 'hdima/python-syntax'
"Plug 'klen/python-mode'

" rplugins
Plug 'neovim/node-host'

" Style
Plug 'tomasr/molokai'
Plug 'luochen1990/rainbow'

call plug#end()



au Bufread,BufNewFile *.asd   setfiletype lisp
au Bufread,BufNewFile *.raml   setfiletype yaml
au Filetype javascript setl et tabstop=4 shiftwidth=4

set mouse=

set cursorline
set modeline
set ls=2

colorscheme molokai
hi String ctermfg=228
hi Comment ctermfg=245
set nohlsearch

set smartindent
set expandtab
set tabstop=2
set shiftwidth=2
set backspace=2


set ruler

set splitbelow
set splitright

set nobackup
set nowritebackup

set scrolloff=5

let mapleader=","

let g:ctrlp_map = '<leader>f'
let g:ctrlp_working_path_mode = 0
let g:ctrlp_custom_ignore = '\v[\/](node_modules|bower_components|\.git|vendor|coverage|report|compiled|dist|tmp|output)$'

let g:paredit_electric_return = 0

let g:rainbow_active = 1

nmap <Leader>n :NERDTreeToggle<CR>
nmap <Leader>o :set paste!<CR>
nnoremap <Leader>b :buffer<Space>term
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

function! s:Colors()
  let num = 255
  execute 'vnew'
  while num >= 0
      exec 'hi col_'.num.' ctermbg='.num.' ctermfg=white'
      exec 'syn match col_'.num.' "ctermbg='.num.':...." containedIn=ALL'
      call append(0, 'ctermbg='.num.':....')
      let num = num - 1
  endwhile
endfunction
command! -nargs=0 Colors call s:Colors()

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

function! s:CafeLogs()
  execute '?Detailed logs'
  normal f/
  normal vj$hy
  execute 'new'
  normal pJx
  normal 0y$
  execute 'e! ' . @"
  "normal Go
endfunction

command! -nargs=0 CafeLogs call s:CafeLogs()
