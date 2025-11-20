scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

if exists('g:loaded_uriencode')
  finish
endif
let g:loaded_uriencode = 1

command! -nargs=* -range URIEncode call s:command_encode(<q-args>, <line1>, <line2>, <range>)
command! -nargs=* -range URIDecode call s:command_decode(<q-args>, <line1>, <line2>, <range>)

function! s:command_encode(arg, line1, line2, range) abort
  if a:arg !=# ''
    echo uri#encode(a:arg)
  elseif a:range
    " Use the existing visual mode function which properly handles block selection
    call s:encode()
  else
    echo 'Usage: :[range]URIEncode or :URIEncode <text>'
  endif
endfunction

function! s:command_decode(arg, line1, line2, range) abort
  if a:arg !=# ''
    echo uri#decode(a:arg)
  elseif a:range
    " Use the existing visual mode function which properly handles block selection
    call s:decode()
  else
    echo 'Usage: :[range]URIDecode or :URIDecode <text>'
  endif
endfunction

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

vnoremap <silent> <Plug>(uriencode-encode)
      \ :<C-u>call <SID>encode()<CR>

vnoremap <silent> <Plug>(uriencode-decode)
      \ :<C-u>call <SID>decode()<CR>

let &cpo = s:save_cpo
unlet s:save_cpo
