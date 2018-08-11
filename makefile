TEXT_FILES := tests/corpus/english_sample_text.txt
TEXT_FILES += tests/corpus/portuguese_sample_text.txt
TEXT_FILES += download/languages_dictionary_files/pt_br.txt
TEXT_FILES += download/languages_dictionary_files/en_us.txt

all: install test

install: doc/tags

download: $(TEXT_FILES)

%.txt:
	wget --quiet -O - \
		'https://docs.google.com/uc?export=download&id=18YWDd69SEndu2BDjXXg8GvtwvqnemaQ_' | \
		tar -xJf -
	touch $(TEXT_FILES)

generate_help: doc/tags

doc/tags:
	vim -i NONE -u NONE --cmd "helptags ./doc/" --cmd "q!"
	touch $@

clean:
	find . -iname "*.pyc" -print0 | xargs -0 rm -rf
	find . -iname "__pycache__" -print0 | xargs -0 rm -rf
	rm $(TEXT_FILES)

test: $(TEXT_FILES)
	bash -x ./tests/test.sh

.PHONY: all install download generate_help clean test
