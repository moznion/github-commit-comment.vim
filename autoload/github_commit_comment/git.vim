let s:save_cpo = &cpo
set cpo&vim

function! github_commit_comment#git#fetch_origin_info()
  let l:origin = split(substitute(system('git config --get remote.origin.url'), '\r\=\n$', '', ''), '/')

  return {
    \  'repos': substitute(l:origin[-1], '\.git$', '', ''),
    \  'user': split(l:origin[-2], ':')[-1]
  \ }
endfunction

function! github_commit_comment#git#get_last_modified_sha()
  return system('git log --pretty=format:"%H" -1 ' . expand('%:p'))
endfunction

function! github_commit_comment#git#get_last_modified_line_sha()
  let output = system('git blame HEAD -L ' . line('.') .',' . line('.') .' -l -M -C --incremental ' . expand('%:p'))

  return matchstr(output, '\w\+')
endfunction

function! github_commit_comment#git#retrieve_relative_path_from_git_root()
  let l:git_root_fullpath = substitute(system('git rev-parse --show-toplevel'), '\r\=\n$', '', '')
  let l:current_file_fullpath = expand('%:p')
  return substitute(l:current_file_fullpath, '^' . l:git_root_fullpath . '/', '', '')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

