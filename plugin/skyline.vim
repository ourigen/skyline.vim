" ============================================================
" File: skyline.vim
" Maintainer: ourigen <https://github.com/ourigen>
" Description: An easily-configurable statusline plugin
" ============================================================

if exists('g:loaded_skyline')
    finish
endif
let g:loaded_skyline = 1

let s:save_cpoptions = &cpoptions
set cpoptions&vim

set laststatus=2

" === User configuration variables ===
" TODO: Changed skyline_gitbranch -> skyline_fugitive.
" Update docs and add check if skyline_gitbranch exists
let g:skyline_gitbranch = get(g:, 'skyline_gitbranch', '0')
let g:skyline_fugitive = get(g:, 'skyline_fugitive', '0')
let g:skyline_ale = get(g:, 'skyline_ale', '0')
let g:skyline_path = get(g:, 'skyline_path', '1')
" let g:skyline_preview = get(g:, 'skyline_preview', '0')
let g:skyline_fileformat = get(g:, 'skyline_fileformat', '1')
let g:skyline_encoding = get(g:, 'skyline_encoding', '1')
let g:skyline_wordcount = get(g:, 'skyline_wordcount', '0')
let g:skyline_linecount = get(g:, 'skyline_linecount', '0')
let g:skyline_percent = get(g:, 'skyline_percent', '1')
let g:skyline_lineinfo = get(g:, 'skyline_lineinfo', '1')
let g:skyline_filetype = get(g:, 'skyline_filetype', '1')
let g:skyline_bufnum = get(g:, 'skyline_bufnum', '1')
" ======

function! ActiveStatus()
    let l:statusline=''

    "=== Dynamic mode color ===
    let l:statusline.='%#String#'
    let l:statusline.='%{(mode()=="n")?"▎  NORMAL  ":""}'
    let l:statusline.='%{(mode()=="c")?"▎  COMMAND  ":""}'
    let l:statusline.='%#Function#'
    let l:statusline.='%{(mode()=="i")?"▎  INSERT  ":""}'
    let l:statusline.='%{(mode()=="t")?"▎  TERMINAL  ":""}'
    let l:statusline.='%#Statement#'
    let l:statusline.='%{(mode()=="v")?"▎  VISUAL  ":""}'
    let l:statusline.='%{(mode()=="\<C-v>")?"▎  VISUAL  ":""}'
    let l:statusline.='%#Identifier#'
    let l:statusline.='%{(mode()=="R")?"▎  REPLACE  ":""}'
    let l:statusline.='%{(mode()=="s")?"▎  SELECT  ":""}'

    " === Resets color ===
    let l:statusline.='%#Normal#'

    " === Git branch ===
    if g:skyline_gitbranch
        echo 'g:skyline_gitbranch was changed to g:skyline_fugitive. Please update the setting'
    endif
    if g:skyline_fugitive
        let l:statusline.='%#Type#'
        " if exists('g:loaded_fugitive')
        let l:statusline.='%(%{skyline#fugitive#branch()}%)'
        " else
        "     let l:statusline.='%(%{skyline#base#GitBranch()}%)'
        " endif
        let l:statusline.='%#Normal#'
    endif

    " === File path ===
    " g:skyline_pah :: 1 = tail, 2 = full path
    let path_options = [ ' %t', ' %#Comment#%{skyline#base#directory()}%#Normal#%t' ]
    let l:statusline.=path_options[g:skyline_path]

    " === Filetype, modified, readonly flag [vim,+,RO] ===
    if g:skyline_filetype
        let l:statusline.='%#Comment#%( [%{&filetype}%M%R]%)'
    else
        let l:statusline.='%#Comment#%( %m%)'
    endif
    let l:statusline.='%#Normal#'

    " === Preview flag [Preview] ===
    " if g:skyline_preview
    "     let l:statusline.='%( %w%)'
    " endif

    " === Divider ===
    let l:statusline.='%='

    " === ALE lint status ===
    if g:skyline_ale
        let l:statusline.='%#String#%(%{skyline#ale#ok()} %)'
        let l:statusline.='%#Error#%(%{skyline#ale#errors()} %)'
        let l:statusline.='%#WarningMsg#%(%{skyline#ale#warnings()} %)'
        let l:statusline.='%#Normal#'
    endif

    " === File format ===
    if g:skyline_fileformat
        let l:statusline.='%( %{skyline#base#fileformat()}  %)'
    endif

    " === File encoding ===
    if g:skyline_encoding
        let l:statusline.='%( %{skyline#base#fileencoding()}  %)'
    endif

    " === Word count ===
    if g:skyline_wordcount
        let l:statusline.='%( %{skyline#base#wordcount()} words  %)'
    endif

    " === Line count ===
    if g:skyline_linecount
        let l:statusline.=' %L lines  '
    endif

    " === Relative line number ===
    if g:skyline_percent
        let l:statusline.=' %3p%%  '
    endif

    " === Line:column number ===
    if g:skyline_lineinfo
        let l:statusline.=' %3l:%-3c  '
    endif

    " === Buffer number ===
    if g:skyline_bufnum
        let l:statusline.='%( %#LineNr#[%n] %)'
    endif

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
    if g:skyline_bufnum
        let l:statusline.='%( [%n] %)'
    endif

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
