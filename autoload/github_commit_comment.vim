let s:save_cpo = &cpo
set cpo&vim

function! github_commit_comment#comment_commit(...)
  call github_commit_comment#comment#comment(0, a:000)
endfunction

function! github_commit_comment#comment_file(...)
  call github_commit_comment#comment#comment(1, a:000)
endfunction

function! github_commit_comment#comment_line(...)
  call github_commit_comment#comment#comment(2, a:000)
endfunction

function! github_commit_comment#fetch_comment()
  call github_commit_comment#fetch#fetch()
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

