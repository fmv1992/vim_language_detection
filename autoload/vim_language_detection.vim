" Check if plugin is enabled. {{{
if exists('g:vim_language_detection') && g:vim_language_detection
else
    finish
endif
" }}}

" Functions. {{{
function! vim_language_detection#default(name, default) "{{{
    if ! exists(a:name)
        let {a:name} = a:default
        return 0
    endif
    return 1
endfunction
" }}}
" }}}

" vim: set filetype=vim fileformat=unix foldmethod=marker nowrap :
