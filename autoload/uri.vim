scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

let s:upperhex = '0123456789ABCDEF'

function! uri#encode(str) abort
  let out = ""

  for i in range(strlen(a:str))
    let c = a:str[i]
    let out = out . uri#escape(c)
  endfor

  return out
endfunction

function! uri#decode(str) abort
  let bytes = []

  let n = strlen(a:str)
  let i = 0
  while i < n
    let c = a:str[i]
    if c !=# '%'
      call add(bytes, char2nr(c, 1))
      let i = i + 1
      continue
    endif

    if i + 2 >= n
      throw 'invalid string for uri decoding'
    endif

    call add(bytes, uri#unhex(a:str[i+1]) * 16 + uri#unhex(a:str[i+2]))
    let i = i + 3
  endwhile

  return bytes->map({ i, n -> printf('\x%02x', n) })->join('')->printf('"%s"')->eval()
endfunction

function! uri#escape(c) abort
  if strlen(a:c) != 1
    return a:c
  endif

  let c = a:c[0]
  let b = char2nr(c, 1)
  if (char2nr('a', 1) <= b && b <= char2nr('z', 1))
    \ || (char2nr('A', 1) <= b && b <= char2nr('Z', 1))
    \ || (char2nr('0', 1) <= b && b <= char2nr('9', 1))
    return c
  endif

  if c ==# '-' || c ==# '_' || c ==# '.' || c ==# '~' || c ==# '$'
    \ || c ==# '&' || c ==# '+' || c ==# ':' || c ==# '=' || c ==# '@'
    return c
  endif

  return '%' . s:upperhex[float2nr(floor(b / 16))] . s:upperhex[and(b, 15)]
endfunction

function! uri#unhex(c) abort
  let b = char2nr(a:c, 1)
  if char2nr('0', 1) <= b && b <= char2nr('9', 1)
    return b - char2nr('0', 1)
  endif
  if char2nr('a', 1) <= b && b <= char2nr('f', 1)
    return b - char2nr('a', 1) + 10
  endif
  if char2nr('A', 1) <= b && b <= char2nr('F', 1)
    return b - char2nr('A', 1) + 10
  endif

  return 0
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
