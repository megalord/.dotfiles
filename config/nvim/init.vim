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
Plug 'jelera/vim-javascript-syntax'
Plug 'leafgarland/typescript-vim'

" Web
Plug 'elzr/vim-json'
Plug 'groenewege/vim-less'

" Lisps
Plug 'wlangstroth/vim-racket'
"Plug 'paredit.vim'

" Other langs
Plug 'hdima/python-syntax'
Plug 'fatih/vim-go'

" rplugins
Plug 'tweekmonster/nvim-api-viewer'
Plug 'neovim/node-host'

" Style
Plug 'liuchengxu/space-vim-dark'
Plug 'luochen1990/rainbow'

call plug#end()


au Bufread,BufNewFile *.asd        setfiletype lisp
au Bufread,BufNewFile *.raml       setfiletype yaml
au Bufread,BufNewFile Jenkinsfile*  setfiletype groovy
au Bufread,BufNewFile Dockerfile.* setfiletype dockerfile
au Bufread,BufNewFile *.sith       setfiletype c
"au Filetype javascript setl et tabstop=4 shiftwidth=4

set mouse=

set nonumber
set cursorline
set modeline
set ls=2

hi Normal ctermbg=233
colorscheme space-vim-dark " Modify the plugin source to use ctermbg 233 on line 83
hi Comment cterm=italic
hi Normal guibg=None ctermbg=None ctermfg=253
set nohlsearch

set smartindent
set expandtab
set tabstop=2
set shiftwidth=2
set backspace=2
set tabline=%!MyTabLine()


set ruler

set splitbelow
set splitright

set nobackup
set nowritebackup

set scrolloff=5

let mapleader=","

set wildignore+=*.o
let g:ctrlp_map = '<leader>f'
let g:ctrlp_working_path_mode = 0
let g:ctrlp_custom_ignore = '\v[\/](node_modules|bower_components|\.git|vendor|coverage|report|compiled|dist|tmp|output|\.o)$'

let g:paredit_electric_return = 0

let g:rainbow_active = 1

nmap <Leader>d :!date<CR>
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


" neovim
if has('nvim')
  tnoremap jk <C-\><C-n>
  tnoremap <C-h> <C-\><C-n><C-w>h
  tnoremap <C-j> <C-\><C-n><C-w>j
  tnoremap <C-k> <C-\><C-n><C-w>k
  tnoremap <C-l> <C-\><C-n><C-w>l

  vmap <Leader>e y<C-l>p
  nmap <Leader>e vipy<C-l>p
  nnoremap <Leader>t :e term://bash<CR>
  nnoremap <Leader>vt :vs term://bash<CR>

  set inccommand=nosplit
  " let $VISUAL = 'nvr -cc split --remote-wait'
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


function! MyTabLine()
  let s = ' '
  for i in range(tabpagenr('$'))
    " select the highlighting
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T'

    " the label is made by MyTabLabel()
    let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
  endfor

  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'

  " right-align the label to close the current tab page
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999Xclose'
  endif

  return s
endfunction

function! MyTabLabel(n)
  let winnr = tabpagewinnr(a:n)
  return split(getcwd(winnr, a:n), '/')[-1]
endfunction
