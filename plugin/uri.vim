scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

if exists('g:loaded_uriencode')
  finish
endif
let g:loaded_uriencode = 1

command! -nargs=1 URIEncode echo uri#encode(<q-args>)
command! -nargs=1 URIDecode echo uri#decode(<q-args>)

function! s:encode()
  let tmp = @z

  normal! gv"zy
  let text = @z
  let encoded = uri#encode(text)

  normal! gv"zd
  let @z = encoded
  normal! "zP

  let @z = tmp
endfunction

function! s:decode()
  let tmp = @z

  normal! gv"zy
  let text = @z
  let decoded = uri#decode(text)

  normal! gv"zd
  let @z = decoded
  normal! "zP

  let @z = tmp
endfunction

vnoremap <silent> <Plug>(uriencode)
      \ :<C-u>call <SID>encode()<CR>

vnoremap <silent> <Plug>(uridecode)
      \ :<C-u>call <SID>decode()<CR>

if !exists('g:uriencode_no_default_key_mappings') ||
      \ !g:uriencode_no_default_key_mappings
  silent! xmap <unique> ge <Plug>(uriencode)
  silent! xmap <unique> gd <Plug>(uridecode)
endif

let &cpo = s:save_cpo
unlet s:save_cpo
