# vim-uriencode

uriencode is a plugin for encoding/decoding uri.

This plugin follows the specification of the Percent-Encoding mechanism
described in [RFC3986](https://datatracker.ietf.org/doc/html/rfc3986).

## Usage

### Encode

Select plain text in Visual mode and type `ge` with defauld configuration.

For example,

    Hello, world!

will be encoded into

    Hello%2C%20world%21

### Decode

Select URI encoded text in Visual mode and type `gd`.

## Install

### Install with [vim-plug](https://github.com/junegunn/vim-plug)
Add the following line to your `.vimrc`.

    Plug 'shota3506/vim-uriencode'
