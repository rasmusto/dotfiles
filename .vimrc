" pathogen setup {{{1
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()

" General {{{1
set history=300

" Enable filetype plugin
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

let mapleader = ","
let g:mapleader = ","
let maplocalleader = ","
let g:maplocalleader = ","

" change timeout for sending esc/meta through terminal
set timeout
set timeoutlen=300

" When vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc
autocmd! bufwritepost *.snippets call ReloadAllSnippets()

" VIM user interface {{{1
set scrolloff=7
set wildmenu
set hidden

" Mouse control in terminal
set mouse=a
set ttymouse=xterm2

set backspace=start,indent

set smartcase ignorecase
set hlsearch
set incsearch
set magic

set showmatch
set matchtime=2

" No sound on errors
set noerrorbells
set novisualbell
set t_vb=

" Lock scrolling horizontally when using scrollbind
set scrollopt+=hor
set scrollopt+=ver
set scrollopt+=jump

set number

" set listchars=tab:

" Colors and Fonts {{{1
syntax enable

" Set font according to system
if has('mac')
    set gfn=Bitstream\ Vera\ Sans\ Mono:h12
    " set shell=/bin/bash
elseif has('win32')
    set shellcmdflag=/c
    set guifont=DejaVu_Sans_Mono:h12:cANSI
elseif has('unix')
    set guifont=GohuFont
    " set shell=/bin/bash
endif

let g:solarized_italic=0

if has('gui_running')
    "Fullscreen
    set go-=m go-=T go-=l go-=L go-=r go-=R go-=b go-=F go=
    set t_Co=256
    set background=dark
    colorscheme solarized
else
    set t_Co=256
    set background=dark
    colorscheme solarized
endif

set encoding=utf8
try
    lang en_US
catch
endtry

set fileformats=unix,dos,mac

" Files and backups {{{1
set nobackup
set nowritebackup
set noswapfile

" Text, tab and indent related {{{1
set expandtab
set shiftwidth=4
set tabstop=4
set smarttab

set linebreak
set textwidth=500

set autoindent
set nowrap

" Visual mode related{{{1

" show length of visual mode selection
set showcmd

function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

" From an idea by Michael Naumann
function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Mappings {{{1
" In visual mode when you press * or # to search for the current selection
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>
vnoremap <silent> gv :call VisualSearch('gv')<CR>

" Command mode related
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

" Moving around, tabs and buffers
" Window movement
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Close the current buffer
map <leader>dd :Bclose<cr>

" When pressing <leader>cd switch to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>

" Buffer changing
map <esc>l :bn<cr>
map <esc>h :bp<cr>

nmap <leader>l :set list!<CR>
map <silent> <leader><cr> :noh<cr>

command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

" Specify the behavior when switching between buffers
try
    set switchbuf=usetab
    set showtabline=1
catch
endtry


" Quickfix/location list {{{1
map <leader>co :botright copen<cr>
map <leader>lo :botright lopen<cr>

map <M-n> :cn<cr>
map <esc>n :cn<cr>

map <M-p> :cp<cr>
map <esc>p :cp<cr>


" Spell checking {{{1
map <leader>ss :setlocal spell!<cr>

" Language-specific settings {{{1
" Python {{{2
let python_highlight_all = 1

au FileType python set smartindent
au FileType python set tabstop=4
au FileType python set shiftwidth=4
au FileType python set expandtab

" whitespace {{{2
func! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc

autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.r :call DeleteTrailingWS()
autocmd BufWrite *.clj :call DeleteTrailingWS()

highlight ExtraWhitespace ctermbg=0 guibg=#073642
match ExtraWhitespace /\s\+$/

" autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
" autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
" autocmd InsertLeave * match ExtraWhitespace /\s\+$/
" autocmd BufWinLeave * call clearmatches()

" Omni complete functions {{{2
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType c set omnifunc=ccomplete#Complete
autocmd FileType python set omnifunc=pythoncomplete#Complete

" MISC {{{1
" Remove the Windows ^M - when the encodings gets messed up
noremap <leader>mmm mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Statusline {{{1
set laststatus=2

" Plugin-specific mappings {{{1

" Tagbar {{{2
let g:tagbar_left = 1
let g:tagbar_compact = 1

map <F4> :TagbarToggle<cr>
map <F8> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

" R lang {{{2
let vimrplugin_screenplugin = 0
let vimrplugin_underscore = 0

" Yankring {{{2
let g:yankring_history_file = '.yankring_history'
let g:Powerline_symbols = 'fancy'
set fillchars+=stl:\ ,stlnc:\ 
let g:Powerline_theme = 'default'
let g:Powerline_colorscheme = 'skwp'

" Ctrlp {{{2
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_open_multiple_files = '1hjr'
let g:ctrlp_max_height = 40
let g:ctrlp_custom_ignore = {
            \ 'dir':
            \ '\v[\/](vnc_logs|target|.git|.hg|.svn)$',
            \ }
let g:ctrlp_working_path_mode = 'r'

" Syntastic {{{2
" disable perl syntax checking, it's recursive and takes too long
let g:syntastic_disabled_filetypes = ['perl', 'python']

" python syntax checking weirdness
let g:syntastic_enable_highlighting = 0
let g:syntastic_echo_current_error = 0
let g:syntastic_python_checker='flake8'
let g:syntastic_python_checker_args='--ignore=E501'
let g:syntastic_enable_signs=0
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],
                           \ 'passive_filetypes': ['python', 'perl'] }

" paredit {{{2
command! Ptoggle call PareditToggle()

" formatoptions {{{1
set formatoptions=qwnt2

set textwidth=79
set cc=80

" From sample vimrc (thanks bram) {{{1
if has("autocmd")

    " Enable file type detection.
    " Use the default filetype settings, so that mail gets 'tw' set to 72,
    " 'cindent' is on in C files, etc.
    " Also load indent files, to automatically do language-dependent indenting.
    filetype plugin indent on

    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
        au!

        " For all text files set 'textwidth' to 78 characters.
        autocmd FileType text setlocal textwidth=78

        " When editing a file, always jump to the last known cursor position.
        " Don't do it when the position is invalid or when inside an event handler
        " (happens when dropping a file on gvim).
        " Also don't do it when the mark is in the first line, that is the default
        " position when opening a file.
        autocmd BufReadPost *
                    \ if line("'\"") > 1 && line("'\"") <= line("$") |
                    \   exe "normal! g`\"" |
                    \ endif

    augroup END

else
    set autoindent
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
                \ | wincmd p | diffthis
endif

" Command/search edit window {{{1
au CmdwinEnter * nnoremap <buffer> <ESC> :q<cr>
au CmdwinEnter * nnoremap <buffer> <C-[> :q<cr>

" Change case {{{1
set tildeop

if has('unix')
    set wildignorecase
elseif has('mac')
    set wildignorecase
endif


au BufRead,BufNewFile *.cshrc set filetype=csh

" persistent undo
set undodir=~/.vim/undodir
set undofile
set undolevels=1000
set undoreload=10000

nnoremap <F5> :GundoToggle<CR>
