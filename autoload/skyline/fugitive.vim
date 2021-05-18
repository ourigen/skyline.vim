function! skyline#fugitive#branch() abort
    if exists('g:loaded_fugitive')
        let l:branch = fugitive#head()
        return l:branch !=# '' ? ' ' . branch : ''
    endif
    return ''
endfunction
