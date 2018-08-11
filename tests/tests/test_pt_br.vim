" Load text.
execute "normal! :read " . g:vim_language_detection_root_path . "/tests/corpus/portuguese_sample_text.txt\<CR>"
normal! ggdd

" Make assertions.
call assert_true(&spell)
call assert_equal(&spelllang, '')
" Trigger plugin execution.
doautocmd InsertLeave
call assert_equal(&spelllang, 'pt_br')

if len(v:errors) > 0
    cquit!
else
    quit!
endif
