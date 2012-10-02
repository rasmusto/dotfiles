runtime bundle/vim-pathogen/autoload/pathogen.vim

"pathogen setup
call pathogen#infect()

"let $TMP="c:/tmp"
"set directory^=$HOME/tmp
"set directory+=,~/tmp,$TMP
" Suppress warnings about not having ruby (on win)
let g:LustyExplorerSuppressRubyWarning = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=300

" Enable filetype plugin
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","
let maplocalleader = ","
let g:maplocalleader = ","

" Fast saving
nmap <leader>w :w!<cr>

" Fast editing of the .vimrc
"map <leader>e :e! ~/.vimrc<cr>

" When vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc
autocmd! bufwritepost *.snippets call ReloadAllSnippets()


"set autochdir


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the curors - when moving vertical..
set so=7
set wildmenu "Turn on WiLd menu
set ruler "Always show current position
set cmdheight=1 "The commandbar height
set hid "Change buffer - without saving

" Mouse control in terminal
set mouse=a
set ttymouse=xterm2

" Set backspace config
set backspace=eol,start,indent
"set whichwrap+=<,>,h,l
set whichwrap+=<,>

set smartcase ignorecase "Ignore case when searching
set hlsearch "Highlight search things
set incsearch "Make search act like search in modern browsers
set magic "Set magic on, for regular expressions

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

"map 0 ^

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable

" Set font according to system
if has('mac')
    set gfn=Bitstream\ Vera\ Sans\ Mono:h12
    set shell=/bin/bash
elseif has('win32')
    set shellcmdflag=/c
    set guifont=DejaVu_Sans_Mono:h12:cANSI
elseif has('unix')
    set guifont=GohuFont
    set shell=/bin/bash
endif


if has('gui_running')
    "Fullscreen
    set go-=m go-=T go-=l go-=L go-=r go-=R go-=b go-=F go=
    set t_Co=256
    set background=dark
    colorscheme solarized
else
    set t_Co=256
    "let g:solarized_termcolors=256
    set background=dark
    colorscheme solarized
endif

set encoding=utf8
try
    lang en_US
catch
endtry

"set ffs=unix,dos,mac "Default file types


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files and backups
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git anyway...
set nobackup
set nowritebackup
set nowb
set noswapfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab
set shiftwidth=4
set tabstop=4
set smarttab

set lbr
set tw=500

set autoindent
"set smartindent
set nowrap "Don't wrap lines

""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Really useful!
"  In visual mode when you press * or # to search for the current selection
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSearch('gv')<CR>
map <leader>vg :vimgrep  ./*<left><left><left><left>


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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Command mode related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

map <silent> <leader><cr> :noh<cr>

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
"map <S-l> :bn<cr>
"map <S-h> :bp<cr>
map <esc>l :bn<cr>
map <esc>h :bp<cr>

" When pressing <leader>cd switch to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>

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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Cope
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Do :help cope if you are unsure what cope is. It's super useful!
map <leader>co :botright copen<cr>
map <leader>lo :botright lopen<cr>

map <M-n> :cn<cr>
map <esc>n :cn<cr>

map <M-p> :cp<cr>
map <esc>p :cp<cr>

set timeout
set timeoutlen=300


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Omni complete functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType c set omnifunc=ccomplete#Complete


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

"Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=


""""""""""""""""""""""""""""""
" => Python section
""""""""""""""""""""""""""""""
"au FileType python set nocindent
let python_highlight_all = 1

au FileType python set smartindent
au FileType python set tabstop=4
au FileType python set shiftwidth=4
au FileType python set expandtab

"Delete trailing white space
func! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()

"whitespace
highlight ExtraWhitespace ctermbg=0 guibg=#073642
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => MISC
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <leader>mmm mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

"Quickly open a buffer for scripbble
map <leader>q :e ~/buffer<cr>

set number
map <F4> :TagbarToggle<cr>
map <F8> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

au FileType python set omnifunc=pythoncomplete#Complete

let g:SuperTabDefaultCompletionType = "context"


""""""""""""""""""""""""""""""
" => Statusline
""""""""""""""""""""""""""""""
" Always hide the statusline
set laststatus=2

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin-specific mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nmap <silent> <leader>j :LustyJuggler<CR>
nmap <silent> <leader>f :LustyFilesystemExplorer<CR>
nmap <silent> <leader>r :LustyFilesystemExplorerFromHere<CR>
nmap <silent> <leader>b :LustyBufferExplorer<CR>
nmap <silent> <leader>g :LustyBufferGrep<CR>

let g:tagbar_left = 1

"showmarks
let g:showmarks_enable=0
let showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

"for vimshell/vimrun.exe
set shellquote=
set shellslash
set shellxquote=
set shellpipe=2>&1\|tee
set shellredir=>%s\ 2>&1

"formatoptions
"set fo=qwant2
set fo=qwnt2
"set fo=qant2

set textwidth=79
set cc=80

"autocmd QuickFixCmdPost * :copen

" From sample vimrc (thanks bram)
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

    set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
                \ | wincmd p | diffthis
endif

map <C-t> :TagbarToggle<CR>

" Command/search edit window
"map : q:i
"map / q/i
au CmdwinEnter * nnoremap <buffer> <ESC> :q<cr>
au CmdwinEnter * nnoremap <buffer> <C-[> :q<cr>

" Change case
set tildeop

set wildignorecase

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

set modeline

" show length of visual mode selection
set sc

" git
au FileType gitcommit set tw=72
au FileType gitcommit set cc=72
au FileType gitrebase set tw=72
au FileType gitrebase set cc=72

"R lang
let vimrplugin_screenplugin = 0

autocmd BufWrite *.r :call DeleteTrailingWS()

let vimrplugin_underscore = 0

au BufRead,BufNewFile *.cshrc set filetype=csh

let g:yankring_history_file = '.yankring_history'

let g:Powerline_symbols = 'fancy'
set fillchars+=stl:\ ,stlnc:\ 
"let g:Powerline_theme = 'default'
let g:Powerline_theme = 'default'
let g:Powerline_colorscheme = 'skwp'
"let g:Powerline_stl_path_style = 'full'
set noshowmode
set noshowcmd
"PowerlineReloadColorscheme

let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_open_multiple_files = '1hjr'
let g:ctrlp_max_height = 40
let g:ctrlp_custom_ignore = '\.pyc$'

let g:tagbar_compact = 1

" persistent undo
set undodir=~/.vim/undodir
set undofile
set undolevels=1000
set undoreload=10000

nnoremap <F5> :GundoToggle<CR>

let vimclojure#WantNailgun = 1
" let vimclojure#SplitSize = 10
let vimclojure#SplitPos = "left"
let g:vimclojure#ParenRainbow = 1

let g:insertlessly_cleanup_trailing_ws = 0
let g:insertlessly_cleanup_all_ws = 0
