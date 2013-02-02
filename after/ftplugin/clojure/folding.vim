function! ClojureFolds()
    let thisline = getline(v:lnum)
    if match(thisline, '^(defn') >= 0
        return ">1"
    else
        return "="
    endif
endfunction
setlocal foldmethod=expr
setlocal foldexpr=ClojureFolds()

function! ClojureFoldText()
    return getline(v:foldstart) . v:folddashes
endfunction
setlocal foldtext=ClojureFoldText()
