" ============================================================
" File: skyline.vim
" Maintainer: ourigen <https://github.com/ourigen>
" Description: A minimal yet configurable statusline plugin
" Last Updated: 17 February 2021
" ============================================================

if exists('g:loaded_skyline')
    finish
endif
let g:loaded_skyline = 1

let s:save_cpoptions = &cpoptions
set cpoptions&vim

set laststatus=2

" === User configuration variables ===
let g:skyline_gitbranch = get(g:, 'skyline_gitbranch', '0')
let g:skyline_path = get(g:, 'skyline_path', '1')
let g:skyline_preview = get(g:, 'skyline_preview', '0')
let g:skyline_fileformat = get(g:, 'skyline_fileformat', '1')
let g:skyline_encoding = get(g:, 'skyline_encoding', '1')
let g:skyline_wordcount = get(g:, 'skyline_wordcount', '0')
let g:skyline_linecount = get(g:, 'skyline_linecount', '0')
let g:skyline_percent = get(g:, 'skyline_percent', '1')
let g:skyline_lineinfo = get(g:, 'skyline_lineinfo', '1')
" ======

function! ActiveStatus()
    let l:statusline=''

    "=== Dynamic mode color ===
    let l:statusline.='%#String#%{(mode()=="n")?"   NORMAL  ":""}'
    let l:statusline.='%#String#%{(mode()=="c")?"   COMMAND  ":""}'
    let l:statusline.='%#Function#%{(mode()=="i")?"   INSERT  ":""}'
    let l:statusline.='%#Function#%{(mode()=="t")?"   TERMINAL  ":""}'
    let l:statusline.='%#Statement#%{(mode()=="v")?"   VISUAL  ":""}'
    let l:statusline.='%#Statement#%{(mode()=="\<C-v>")?"   VISUAL  ":""}'
    let l:statusline.='%#Identifier#%{(mode()=="R")?"   REPLACE  ":""}'
    let l:statusline.='%#Identifier#%{(mode()=="s")?"   SELECT  ":""}'

    " === Resets color ===
    let l:statusline.='%#Normal#'

    " === Git branch ===
    if g:skyline_gitbranch
        let l:statusline.='%#Type#'
        if exists('g:loaded_fugitive')
            let l:statusline.='%(%{skyline#Fugitive()}%)'
        else
            let l:statusline.='%(%{skyline#GitBranch()}%)'
        endif
        let l:statusline.='%#Normal#'
    endif

    " === File path ===
    " g:skyline_pah :: 1 = tail, 2 = full path
    let path_options = [ ' %t', ' %#Comment#%{skyline#FileDir()}%#Normal#%t' ]
    let statusline.=path_options[g:skyline_path]

    " === Filetype, modified, readonly flag [vim,+,RO] ===
    let l:statusline.='%#Comment#%( [%{&filetype}%M%R]%)'
    let l:statusline.='%#Normal#'

    " === Preview flag [Preview] ===
    if g:skyline_preview
        let l:statusline.='%( %w%)'
    endif

    " === Divider ===
    let l:statusline.='%='

    " === File format ===
    if g:skyline_fileformat
        let l:statusline.='%( %{skyline#FileFormat()} |%)'
    endif

    " === File encoding ===
    if g:skyline_encoding
        let l:statusline.='%( %{skyline#FileEncoding()} |%)'
    endif

    " === Word count ===
    if g:skyline_wordcount
        let l:statusline.='%( %{skyline#WordCount()} words |%)'
    endif

    " === Line count ===
    if g:skyline_linecount
        let l:statusline.=' %L lines |'
    endif

    " === Relative line number ===
    if g:skyline_percent
        let l:statusline.=' %3p%% |'
    endif

    " === Line:column number ===
    if g:skyline_lineinfo
        let l:statusline.=' %3l:%-3c |'
    endif

    " === Buffer number ===
    let l:statusline.='%( %#LineNr#[%n] %)'

    return l:statusline
endfunction

function! InactiveStatus()
    let l:statusline='%#StatusLineNC#'

    " === File path ===
    let path_options = [ ' %t', ' %F' ]
    let statusline.=path_options[g:skyline_path]

    " === Modified flag [+] ===
    let l:statusline.='%( %M%)'

    " === Divider ===
    let l:statusline.='%='

    " === Buffer number ===
    let l:statusline.='%( [%n] %)'

    return l:statusline
endfunction

augroup skyline
    autocmd!
    autocmd WinEnter,BufEnter * setlocal statusline=%!ActiveStatus()
    autocmd WinLeave,BufLeave * setlocal statusline=%!InactiveStatus()
augroup END

set statusline=%!ActiveStatus()

let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions
