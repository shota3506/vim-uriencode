scriptencoding utf-8

if exists('g:loaded_uriencode')
  finish
endif
let g:loaded_uriencode = 1

command! -nargs=1 URIEncode echo uri#encode(<q-args>)
command! -nargs=1 URIDecode echo uri#decode(<q-args>)
