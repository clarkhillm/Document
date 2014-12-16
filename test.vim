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

au FileType * call CheckFiletype()

function CheckFiletype()
    if &filetype == "javascript" || &filetype == "python"
        set guifont=Source_Code_Pro:h9:cDEFAULT
        setlocal spell spelllang=en_us
    endif
endfunction
