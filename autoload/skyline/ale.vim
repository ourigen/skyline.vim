" Helper to check that ALE is active first
function! skyline#ale#linted() abort
    return get(g:, 'ale_enabled', 0) == 1
                \ && getbufvar(bufnr(''), 'ale_enabled', 1)
                \ && getbufvar(bufnr(''), 'ale_linted', 0) > 0
                \ && ale#engine#IsCheckingBuffer(bufnr('')) == 0
endfunction

function! skyline#ale#warnings() abort
    if !skyline#ale#linted()
        return ''
    endif
    let l:counts = ale#skyline#Count(bufnr(''))
    let l:all_warnings = l:counts.warning + l:counts.style_warning
    return l:all_warnings == 0 ? '' : printf(' %d', all_warnings)
endfunction

function! skyline#ale#errors() abort
    if !skyline#ale#linted()
        return ''
    endif
    let l:counts = ale#skyline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    return l:all_errors == 0 ? '' : printf(' %d', all_errors)
endfunction

function! skyline#ale#ok() abort
    if !skyline#ale#linted()
        return ''
    endif
    let l:counts = ale#skyline#Count(bufnr(''))
    return l:counts.total == 0 ? '' : ''
endfunction

" function! skyline#ale#allsigns() abort
"     let l:counts = ale#skyline#Count(bufnr(''))

"     let l:errors = l:counts.error + l:counts.style_error
"     let l:warnings = l:counts.warning + l:counts.style_warning

"     let l:total = l:errors + l:warnings

"     return l:total == 0 ? '' : printf( '%d errors %d warnings |', errors, warnings)
" endfunction
