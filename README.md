# vim-uriencode

uriencode is a plugin for encoding/decoding uri.

This plugin follows the specification of the Percent-Encoding mechanism
described in [RFC3986](https://datatracker.ietf.org/doc/html/rfc3986).

## Usage

### Using Commands

You can also use the `:URIEncode` and `:URIDecode` commands in two ways:

1. **With a visual selection** - Select text in Visual mode and execute `:URIEncode` or `:URIDecode` to replace the selection:
   ```vim
   :'<,'>URIEncode
   ```

2. **With an argument** - Pass text as an argument to display the encoded/decoded result:
   ```vim
   :URIEncode Hello, world!
   " Output: Hello%2C%20world%21
   ```

## Install

### Install with [vim-plug](https://github.com/junegunn/vim-plug)
Add the following line to your `.vimrc`.

    Plug 'shota3506/vim-uriencode'
