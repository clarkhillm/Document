"* Gavin Tools for VIM *
"
let mapleader = "m"

function JumpInBraces(direction)
    if a:direction == "f"
        let s:linenumber=search("{")
    else
        let s:linenumber=search("{","b")
    endif
    let s:cursorLocal=line(".")
    normal %
    let s:cursorLocal1=line(".")
    normal %
    if s:cursorLocal == s:cursorLocal1
        call JumpInBraces(a:direction)
    endif
    if  foldclosed(s:linenumber) != -1
        call JumpInBraces(a:direction)
    endif
endfunction

function Jump_floder()
    call JumpInBraces("f")
    let s:cursorLocal=line(".")
    normal %
    let s:cursorLocal1=line(".")
    normal %
    if s:cursorLocal != s:cursorLocal1
        normal zzjzc
    endif
endfunction

nnoremap  <leader>b :call JumpInBraces("f")<CR>
nnoremap  <leader>f :call JumpInBraces("b")<CR>
nnoremap  <leader>q :call Jump_floder()<CR>

