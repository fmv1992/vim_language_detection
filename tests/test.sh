#! /bin/bash

# Check before starting.
set -e
which python3 1>/dev/null 2>/dev/null
which vim 1>/dev/null 2>/dev/null

# Go to test root directory.
cd $(dirname $0)

# Create temporary vimrc.
temp_vimrc=$(mktemp /tmp/tmp.vim_language_detection.XXXXXX)
cat ./support_files/vim_language_detection_tests_vimrc.vim >> $temp_vimrc
echo "set runtimepath+=$(dirname $PWD)" >> $temp_vimrc
echo "let g:vim_language_detection_en_us_dictionary_file = '$(dirname $PWD)/download/languages_dictionary_files/en_us.txt'" >> $temp_vimrc
echo "let g:vim_language_detection_pt_br_dictionary_file = '$(dirname $PWD)/download/languages_dictionary_files/pt_br.txt'" >> $temp_vimrc

# vim: set fileformat=unix filetype=sh wrap tw=0 :

# Source common variables.
for vim_file in $(find ./tests -iname "*.vim")
do
    vim -u $temp_vimrc -S $vim_file
done

rm $temp_vimrc

# vim: set fileformat=unix filetype=sh wrap tw=0 :
