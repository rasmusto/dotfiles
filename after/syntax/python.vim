" change these to something else if it looks bad in your colorscheme
" these choices where chosen for the solarized theme
hi def link sagePrompt DiffChange
hi def link pythonDocString Underlined
hi def link sageDocStringKeywords Todo

" Load the ReST syntax file; but first we clear the current syntax
" definition, as rst.vim does nothing if b:current_syntax is defined.
let s:current_syntax=b:current_syntax
unlet b:current_syntax
" Load the ReST syntax file
syntax include @ReST $VIMRUNTIME/syntax/rst.vim
let b:current_syntax=s:current_syntax
unlet s:current_syntax

" clear the rstLiteralBlock
" TODO: improve this; this should apply to all
" pythonDocString regions but the sageDoctest regions
syntax clear rstLiteralBlock

" By using the nextgroup argument below, we are giving priority to
" pythonDocString over all other groups.
syntax match beginPythonBlock
    \ "\%(\%(\%(cp\=\)\=def\|class\)\s.*:\s*\)\@<=$"
    \ nextgroup=pythonDocString
    \ skipempty
    \ skipwhite
syntax match beginPythonBlock
    \ "\%^\%(#!.*$\)\="
    \ nextgroup=pythonDocString
    \ skipempty
    \ skipwhite
hi link beginPythonBlock None

syntax region pythonDocString
    \ start=+[uUr]\='+
    \ end=+'+ 
    \ contains=sageDoctest,pythonEscape,@Spell,@ReST,SageDocStringKeywords
    \ containedin=beginPythonBlock
    \ contained
syntax region pythonDocString
    \ start=+[uUr]\="+
    \ end=+"+ 
    \ contains=sageDoctest,pythonEscape,@Spell,@ReST,SageDocStringKeywords
    \ containedin=beginPythonBlock
    \ contained
syntax region pythonDocString
    \ start=+^\s*[uUr]\='''+
    \ end=+^\s*'''*$+
    \ contains=sageDoctest,pythonEscape,@Spell,@ReST,SageDocStringKeywords
    \ skipempty
    \ skipwhite
    \ containedin=beginPythonBlock
    \ contained
    \ keepend
    \ fold
syntax region pythonDocString
    \ start=+^\s*[uUr]\="""+
    \ end=+^\s*"""$+
    \ contains=sageDoctest,pythonEscape,@Spell,@ReST,SageDocStringKeywords
    \ skipempty
    \ skipwhite
    \ containedin=beginPythonBlock
    \ contained
    \ keepend
    \ fold
syntax match pythonDocString
    \ +^\s*[uUr]\='''.*'''$+
    \ contains=sageDoctest,pythonEscape,@Spell,@ReST,SageDocStringKeywords
    \ skipempty
    \ skipwhite
    \ containedin=beginPythonBlock
    \ contained
    \ keepend
syntax match pythonDocString
    \ +^\s*[uUr]\=""".*"""$+
    \ contains=sageDoctest,pythonEscape,@Spell,@ReST,SageDocStringKeywords
    \ skipempty
    \ skipwhite
    \ containedin=beginPythonBlock
    \ contained
    \ keepend

" clear the pythonDoctest and pythonDoctestValue syntax groups
syntax clear pythonDoctest
syntax clear pythonDoctestValue

syntax region sageDoctest
    \ start=+^\s*\zs\n\s*\%(sage:\|>>>\)\s+
    \ end=+\ze\_^\s*\%('''\|"""\)\=$+
    \ contains=ALLBUT,@ReST,@Spell
    \ containedin=pythonDocString
    \ contained 
    \ keepend
    \ fold
hi link sageDoctest	Special

syntax region sageDoctestValue
    \ start=+^\s*\%(sage:\s\|>>>\s\|\.\.\.\s\)\@!\S\++
    \ end=+\ze\_^\s*\%(\%(sage:\|>>>\)\s\|\%('''\|"""\)\=$\)+
    \ contains=NONE
    \ containedin=sageDoctest
    \ contained 
hi link sageDoctestValue Define

syntax match sagePrompt "^\s*\zs\%(sage:\|>>>\|\.\.\.\)" containedin=sageDoctest contained
"syntax match sageBlockWhitespace "^\s*" containedin=sageDoctest contained

syntax case match
syntax match sageDocStringKeywords
    \ "^\s*\zs\u*\ze:" containedin=sageDocString contained

" Look back at least 200 lines to compute the syntax highlighting
syntax sync minlines=200

syntax keyword pythonBuiltin self
