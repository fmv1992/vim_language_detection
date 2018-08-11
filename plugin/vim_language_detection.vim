" Check if plugin is enabled. {{{
if exists('g:vim_language_detection') && g:vim_language_detection
else
    finish
endif
" }}}

" Module constants declaration. {{{
let g:vim_language_detection_program_name = 'vim_language_detection'
let g:vim_language_detection_root_path = expand('<sfile>:p:h:h')
" }}}

" Check plugin dependencies. {{{
let s:lack_deps = []
if ! has('python3')
    call add(s:lack_deps, 'python3')
endif
if len(s:lack_deps) != 0
    echoerr g:vim_language_detection_program_name .
        \ ': vim lacks the following dependencies: '
        \ . join(s:lack_deps, ', ')
    finish
endif
unlet s:lack_deps
" }}}

" Set plugin variables. {{{
call vim_language_detection#default(
    \ 'g:vim_language_detection_n_words_to_trigger_check', 20)
call vim_language_detection#default(
    \ 'g:vim_language_detection_max_lines', 1000)
" }}}

" Functions. {{{
function! s:VimLanguageDetectionAddPluginToPythonPath(path) " {{{

    python3 import sys, vim
    python3 sys.path.insert(0, vim.eval("g:vim_language_detection_root_path"))

endfunction
" }}}

function! s:VimLanguageDetectionMain() " {{{
    " Return a string with the name of the detected language.

    " Insert vim_language_detection to pythonpath .
    call s:VimLanguageDetectionAddPluginToPythonPath(
        \ g:vim_language_detection_root_path)


    " If spell is set. ???
    if v:true

    endif

    " Do not invoke program if there are too many lines.
    if line('$') > g:vim_language_detection_max_lines
        return v:true
    endif

    " Python code. {{{
    python3 << EOF
import vim
import vim_language_detection
vim.current.buffer.vars[
    'vim_language_detection_found_language'] = vim_language_detection.main(
        vim)
EOF
    " }}}

    if b:vim_language_detection_found_language == ''
        echo g:vim_language_detection_program_name
            \ . " " . strftime("%FT%T%z") ": Unmatched language (too few words)."
        return v:false
    else
        echo g:vim_language_detection_program_name
            \ . ": Matched language: '"
            \ . b:vim_language_detection_found_language
            \ . "'."
        execute "normal! :setlocal spelllang="
            \ . b:vim_language_detection_found_language
            \ . "\<CR>"
        return v:true
    endif

    return v:true

endfunction
" }}}
" }}}

augroup vim_language_detection
    autocmd InsertLeave * call s:VimLanguageDetectionMain()
augroup END

" vim: set filetype=vim fileformat=unix foldmethod=marker nowrap:
