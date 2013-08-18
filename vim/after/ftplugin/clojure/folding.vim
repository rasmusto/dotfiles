function! ClojureFolds()
    let thisline = getline(v:lnum)
    if thisline =~ '^(defn'
        return ">1"
    elseif thisline =~ '^(comment'
        return ">1"
    elseif thisline =~ '^(def'
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
