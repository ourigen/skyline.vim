function! skyline#fugitive#branch() abort
    if exists('g:loaded_fugitive')
        let l:branch = FugitiveHead()
        return l:branch !=# '' ? ' ' . branch : ''
    endif
    return ''
endfunction
