"* Gavin Tools for VIM *
"
let mapleader = "m"
function JumpInBraces()
    let s:linenumber=search("{")
    if  foldclosed(s:linenumber) != -1
        call JumpInBraces()
    endif
endfunction

nnoremap  <leader>b :call JumpInBraces()<CR>
