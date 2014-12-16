"* Gavin Tools for VIM *
"
let mapleader = "m"
"在大括号之间跳跃
function JumpInBraces()
    let s:linenumber=search("{")
    let s:cursorLocal=line(".")
    normal %
    let s:cursorLocal1=line(".")
    normal %
    if s:cursorLocal == s:cursorLocal1
        call JumpInBraces()
    endif
    if  foldclosed(s:linenumber) != -1
        call JumpInBraces()
    endif
endfunction
"折叠下一个大括号
function Jump_floder()
    call JumpInBraces()
    let s:cursorLocal=line(".")
    normal %
    let s:cursorLocal1=line(".")
    normal %
    if s:cursorLocal != s:cursorLocal1
        normal zzjzc
    endif
endfunction

nnoremap  <leader>b :call JumpInBraces()<CR>
nnoremap  <leader>q :call Jump_floder()<CR>

au FileType * call CheckFiletype()

function CheckFiletype()
    if &filetype == "javascript" || &filetype == "python"
        set guifont=Source_Code_Pro:h9:cDEFAULT
        setlocal spell spelllang=en_us
        colo monokain
    endif
endfunction
