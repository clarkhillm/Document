set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

set diffexpr=MyDiff()
function MyDiff()
    let opt = '-a --binary '
    if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
    if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
    let arg1 = v:fname_in
    if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
    let arg2 = v:fname_new
    if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
    let arg3 = v:fname_out
    if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
    let eq = ''
    if $VIMRUNTIME =~ ' '
        if &sh =~ '\<cmd'
            let cmd = '""' . $VIMRUNTIME . '\diff"'
            let eq = '"'
        else
            let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
        endif
    else
        let cmd = $VIMRUNTIME . '\diff'
    endif
    silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

set magic

winpos 0 0
colo monokain
syntax on

set autoindent
set smartindent
1
set lines=100 columns=100
setlocal spell spelllang=en_us
set encoding=utf-8
set fileencoding=utf-8
"解决consle输出乱码
language messages zh_CN.utf-8

set guifont=Source_code_pro_Medium:h10:cDEFAULT
set gfw=NSimSun:h10

set ignorecase

set foldenable      " 允许折叠  
set foldmethod=indent
set foldlevel=30
set foldcolumn=0
set expandtab     " 使用空格代替tab.
set smarttab
set tabstop=4     " 空格数量是4。 
set shiftwidth=4  " 自动缩进的宽度。

set list
set tags=tags
set autochdir
set linespace=4
set cuc cul
set number
set listchars=tab:>.,trail:~,extends:>,precedes:<,nbsp:_

nnoremap <A-a> <C-a>
nnoremap <A-x> <C-x>

set fdo-=search

set guioptions-=T " 隐藏工具栏
set guioptions-=m " 隐藏菜单栏

