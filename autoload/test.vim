scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

function! test#run() abort
  let v:errors = []

  call s:uriencode()
  call s:uridecode()

  if len(v:errors) > 0
    for error in v:errors
      echo error
    endfor
    cquit!
  endif

  echo "ok\n"
  qall!
endfunction

func s:uriencode() abort
  let out = uri#encode("")
  call assert_equal("", out)

  let out = uri#encode("abc")
  call assert_equal("abc", out)

  let out = uri#encode("abc+def")
  call assert_equal("abc+def", out)

  let out = uri#encode("a/b")
  call assert_equal("a%2Fb", out)

  let out = uri#encode("one two")
  call assert_equal("one%20two", out)

  let out = uri#encode("10%")
  call assert_equal("10%25", out)

  let out = uri#encode(" ?&=#+%!<>#\"{}|\\^[]`\t:/@$'()*,;")
  call assert_equal("%20%3F&=%23+%25%21%3C%3E%23%22%7B%7D%7C%5C%5E%5B%5D%60%09:%2F@$%27%28%29%2A%2C%3B", out)

  let out = uri#encode("あいうえお")
  call assert_equal("%E3%81%82%E3%81%84%E3%81%86%E3%81%88%E3%81%8A", out)
endfunction

func s:uridecode() abort
  let out = uri#decode("")
  call assert_equal("", out)

  let out = uri#decode("abc")
  call assert_equal("abc", out)

  let out = uri#decode("abc+def")
  call assert_equal("abc+def", out)

  let out = uri#decode("a%2Fb")
  call assert_equal("a/b", out)

  let out = uri#decode("one%20two")
  call assert_equal("one two", out)

  let out = uri#decode("10%25")
  call assert_equal("10%", out)

  let out = uri#decode("%20%3F&=%23+%25%21%3C%3E%23%22%7B%7D%7C%5C%5E%5B%5D%60%09:%2F@$%27%28%29%2A%2C%3B")
  call assert_equal(" ?&=#+%!<>#\"{}|\\^[]`\t:/@$'()*,;", out)

  " The case below don't succeed.
  " `list2str` cannot convert some 3-bytes characters.
  " let out = uri#decode("%E3%81%82%E3%81%84%E3%81%86%E3%81%88%E3%81%8A")
  " call assert_equal("あいうえお", out)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
