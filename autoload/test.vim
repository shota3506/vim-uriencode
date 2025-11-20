scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

function! test#run() abort
  let v:errors = []

  echo "Running comprehensive URI encoding/decoding tests..."
  echo ""

  call s:test_unreserved_characters()
  call s:test_reserved_characters()
  call s:test_special_characters()
  call s:test_unicode_characters()
  call s:test_edge_cases()
  call s:test_round_trip()

  if len(v:errors) > 0
    echo "\n❌ FAILED: " . len(v:errors) . " test(s) failed"
    for error in v:errors
      echo error
    endfor
    cquit!
  endif

  echo "\n✓ All comprehensive tests passed!\n"
  qall!
endfunction

" Test unreserved characters (should NOT be encoded)
" RFC3986: unreserved = ALPHA / DIGIT / "-" / "." / "_" / "~"
func s:test_unreserved_characters() abort
  echo "Testing unreserved characters (should NOT be encoded)..."

  " Lowercase letters
  let out = uri#encode("abcdefghijklmnopqrstuvwxyz")
  call assert_equal("abcdefghijklmnopqrstuvwxyz", out)

  " Uppercase letters
  let out = uri#encode("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
  call assert_equal("ABCDEFGHIJKLMNOPQRSTUVWXYZ", out)

  " Digits
  let out = uri#encode("0123456789")
  call assert_equal("0123456789", out)

  " Unreserved special characters
  let out = uri#encode("-._~")
  call assert_equal("-._~", out)

  echo "  ✓ Unreserved characters test passed"
endfunction

" Test reserved characters (SHOULD be encoded in most contexts)
" RFC3986: gen-delims = ":" / "/" / "?" / "#" / "[" / "]" / "@"
"          sub-delims = "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="
func s:test_reserved_characters() abort
  echo "Testing reserved characters (should be encoded)..."

  " gen-delims
  let out = uri#encode(":/?#[]@")
  call assert_equal("%3A%2F%3F%23%5B%5D%40", out)

  " sub-delims
  let out = uri#encode("!$&'()*+,;=")
  call assert_equal("%21%24%26%27%28%29%2A%2B%2C%3B%3D", out)

  echo "  ✓ Reserved characters test passed"
endfunction

" Test special characters
func s:test_special_characters() abort
  echo "Testing special characters..."

  " Space
  let out = uri#encode(" ")
  call assert_equal("%20", out)

  " Percent sign (must always be encoded)
  let out = uri#encode("%")
  call assert_equal("%25", out)

  " Double quotes, less-than, greater-than
  let out = uri#encode('"<>')
  call assert_equal("%22%3C%3E", out)

  " Backslash, pipe, caret
  let out = uri#encode("\\|^")
  call assert_equal("%5C%7C%5E", out)

  " Curly braces
  let out = uri#encode("{}")
  call assert_equal("%7B%7D", out)

  " Backtick
  let out = uri#encode("`")
  call assert_equal("%60", out)

  echo "  ✓ Special characters test passed"
endfunction

" Test Unicode characters (multi-byte UTF-8)
func s:test_unicode_characters() abort
  echo "Testing Unicode characters..."

  " Japanese hiragana
  let out = uri#encode("あいうえお")
  call assert_equal("%E3%81%82%E3%81%84%E3%81%86%E3%81%88%E3%81%8A", out)

  " Copyright symbol (2-byte UTF-8)
  let out = uri#encode("©")
  call assert_equal("%C2%A9", out)

  " Emoji (4-byte UTF-8)
  let out = uri#encode("😀")
  call assert_equal("%F0%9F%98%80", out)

  " Chinese characters
  let out = uri#encode("你好")
  call assert_equal("%E4%BD%A0%E5%A5%BD", out)

  " Cyrillic
  let out = uri#encode("Привет")
  call assert_equal("%D0%9F%D1%80%D0%B8%D0%B2%D0%B5%D1%82", out)

  echo "  ✓ Unicode characters test passed"
endfunction

" Test edge cases
func s:test_edge_cases() abort
  echo "Testing edge cases..."

  " Empty string
  let out = uri#encode("")
  call assert_equal("", out)

  " Only special characters
  let out = uri#encode("!@#$%^&*()")
  call assert_equal("%21%40%23%24%25%5E%26%2A%28%29", out)

  " Mixed ASCII and Unicode
  let out = uri#encode("Hello 世界")
  call assert_equal("Hello%20%E4%B8%96%E7%95%8C", out)

  " Newline and tab
  let out = uri#encode("\n\t")
  call assert_equal("%0A%09", out)

  echo "  ✓ Edge cases test passed"
endfunction

" Test round-trip (encode then decode should return original)
func s:test_round_trip() abort
  echo "Testing round-trip encoding/decoding..."

  let test_strings = [
        \ "Hello, World!",
        \ "user@example.com",
        \ "path/to/file?query=1&foo=bar",
        \ "100% pure",
        \ "こんにちは世界",
        \ "Mix of ASCII & Unicode: 你好",
        \ "Special: !@#$%^&*()",
        \ "-._~0aZ",
        \ ]

  for str in test_strings
    let encoded = uri#encode(str)
    let decoded = uri#decode(encoded)
    call assert_equal(str, decoded, "Round-trip failed for: " . str)
  endfor

  echo "  ✓ Round-trip test passed"
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
