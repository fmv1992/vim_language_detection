"""Define dictionary related functions for the vim_dictionary application."""

import logging
import os
import tempfile
import string

LOGGING_FORMAT = logging.Formatter(
    fmt=('|Thread: %{threadName:s}|{levelname:8s}|{asctime:s}|{name:8s}'
         '| {message:s}'),
    datefmt='%Y-%m-%d %H:%M:%S',
    style='{')

PROGRAM_NAME = 'vim_language_detection'

MINIMUM_WORDS_TO_PREDICT_FILE_LANGUAGE = 20


# Logging is not implemented as of v0.0.1.
def _instantiate_logger(name):
    """Instantiate a logger."""
    mylogger = logging.getLogger(name)
    mylogger.setLevel(logging.DEBUG)

    if not mylogger.handlers:
        # Add a console logger as well.
        myconsole = logging.StreamHandler()
        myconsole.setFormatter(LOGGING_FORMAT)
        myconsole.setLevel(logging.DEBUG)
        mylogger.addHandler(myconsole)

    return mylogger


# Logging is not implemented as of v0.0.1.
def setup_logging():
    """Set up logging.

    Returns:
        logging.Logger: A logger instantiated with '__name__'.

    """
    logfile = os.path.join(tempfile.gettempdir(), PROGRAM_NAME + '.log')
    logging.basicConfig(
        level=logging.INFO,
        filename=logfile,
        filemode='a')

    rootlogger = _instantiate_logger(__name__)
    rootlogger.debug('Started logging.')
    rootlogger.debug('Logging file is: {0}'.format(logfile))

    return rootlogger


def _filter_ascii_letters_and_space(string_data):
    return ''.join(filter(lambda x: x in set(string.ascii_lowercase + ' '),
                          string_data))


def _preprocess_text(string_data):
    """Convert a text to lowercase and spaces only."""
    return string_data.replace('\n', ' ').lower()


def get_words_from_string(string_data):
    """Return a set of lower case words from a vim buffer."""
    data_preprocessed = _preprocess_text(string_data)
    data_lower_ascii = _filter_ascii_letters_and_space(data_preprocessed)
    words = set(map(lambda x: x.lower(),
                    data_lower_ascii.split(' ')))
    return words


def get_words_from_dictionary_file(path):
    """Return a set of lower case words from a text file."""
    with open(path, 'rt') as f:
        data = f.read()
    return get_words_from_string(data)


def count_words_in_buffer(vim_instance):
    """Count the number of words in current buffer."""
    vim_current_buffer = vim_instance.current.buffer
    lines = vim_current_buffer[:].copy()
    return len(' '.join(lines).split(' '))


def main(vim_instance):
    """Execute the vim_language_detection plugin."""
    # Define constants
    variable_prefix = 'vim_language_detection_'
    variable_suffix = '_dictionary_file'

    # If the current buffer is too small then return an empty string.
    if count_words_in_buffer(
            vim_instance) < MINIMUM_WORDS_TO_PREDICT_FILE_LANGUAGE:
        return ''

    # Get words in current buffer.
    vim_current_buffer = vim_instance.current.buffer
    lines = vim_current_buffer[:].copy()
    words_in_buffer = get_words_from_string('\n'.join(lines))

    # Get words in dictionaries.
    # print('\n'.join(sorted(map(str, vim_instance.vars.keys()))))
    dictionary_entries = filter(
        lambda x: (x.startswith(variable_prefix)
                   and x.endswith(variable_suffix)),
        map(lambda y: y.decode(), vim_instance.vars.keys()))
    dictionary_languages = list(dictionary_entries)
    dictionary_languages_dict = dict(map(
        lambda x: (x, get_words_from_dictionary_file(vim_instance.vars[x])),
        dictionary_languages))

    # Sort languages with most matches between words.
    sorted_word_match = sorted(
        dictionary_languages_dict.keys(),
        key=lambda x: len(dictionary_languages_dict[x] & words_in_buffer))

    # Get the language name from the defined variables.
    language_variable_with_most_match = sorted_word_match[-1]
    language_with_most_match = language_variable_with_most_match[
        len(variable_prefix):-len(variable_suffix)]

    return language_with_most_match

# vim: set filetype=python fileformat=unix nowrap nospell:
