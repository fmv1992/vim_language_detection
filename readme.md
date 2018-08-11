![](???)

# vim_language_detection

Autodetect the language of your files from a set of languages and change the `'spelllang'` accordingly.

## Description

Autodetect the language of your files from a set of languages and change the `'spelllang'` accordingly.

That's it, this is a [KISS](https://en.wikipedia.org/wiki/KISS_principle) plugin.

Read the documentation: <???> for more details.

# Requirements

* Vim compiled with `+python3` support.

* `python3` itself.

* A dictionary file with most common words for the languages that you want the plugin to check against.

# Installing

As of vim8 there is an officially supported way of adding plugins. See `:tab help packages` in vim for details.

    cd ~/.vim/pack/foo/start
    git clone https://github.com/fmv1992/vim_language_detection

Then enable the plugin, select your languages and provide a dictionary with common words for them:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
let g:vim_language_detection = v:true
let g:vim_language_detection_languages = ['en_us', 'pt_br', ..., 'yy_zz']

let g:vim_language_detection_en_us_dictionary_file = '/path/to/my/en_us/list/of/common/words.txt'
let g:vim_language_detection_pt_br_dictionary_file = '/path/to/my/pt_br/list/of/common/words.txt'
...
let g:vim_language_detection_yy_zz_dictionary_file = '/path/to/my/yy_zz/list/of/common/words.txt'
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Alternatively issue `make all` to download the dictionaries for English and Portuguese.

# License

[GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html).

[comment]: # ( vim: set filetype=markdown fileformat=unix wrap spell spelllang=en_us: )
