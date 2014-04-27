let s:save_cpo = &cpo
set cpo&vim

function! github_commit_comment#comment_commit()
  call s:comment(0)
endfunction

function! github_commit_comment#comment_file()
  call s:comment(1)
endfunction

function! github_commit_comment#comment_line()
  call s:comment(2)
endfunction

function! s:comment(comment_type) " `comment_type` is very s**ks
  if !s:is_command_executable('git') || !s:is_command_executable('curl')
    return
  endif

  let t:position = ''
  if a:comment_type == 2 " for line comment
    let t:position = line('.')
  endif

  let t:relative_path = ''
  if a:comment_type == 1 || a:comment_type == 2 " for line or file comment
    let t:relative_path = s:retrieve_relative_path()
  endif

  let t:sha    = substitute(system('git rev-parse HEAD'), '\r\=\n$', '', '')
  let t:origin = s:fetch_origin_info()

  let l:tmpfile = '__github_commit_comment_vim_' . localtime()
  10new `=l:tmpfile`
  setlocal filetype=markdown
  cabbrev wq <C-r>='w'<CR>
  autocmd BufWriteCmd <buffer> let t:github_commit_comment_contents = getline(0,'$')
  autocmd BufWriteCmd <buffer> :q!
  autocmd BufWriteCmd <buffer> call s:post(
    \    t:sha,
    \    t:origin,
    \    t:github_commit_comment_contents,
    \    t:relative_path,
    \    t:position,
    \ )
  autocmd BufWriteCmd <buffer> :cabbrev wq <C-r>='wq'<CR>
endfunction

function! s:post(sha, origin, body, path, position)
  let l:serialized_body = join(a:body, "\n")
  let l:payload = webapi#json#encode({
    \  'body':     l:serialized_body,
    \  'path':     a:path,
    \  'position': a:position
  \ })

  let l:ret = system('curl -s -k -i -u ' . g:github_commit_comment_vim.token . ':x-oauth-basic https://api.github.com/repos/' . a:origin.user . '/' . a:origin.repos . '/commits/' . a:sha . "/comments -X POST -d '" . l:payload . "'")

  redraw

  if s:is_success(l:ret)
    echo "Posted"
  else
    echo "Failed to post"
  endif
endfunction

function! s:is_command_executable(cmd)
  if !executable(a:cmd)
    echo a:cmd . ' has not installed yet on this environment'
    return 0
  endif
  return 1
endfunction

function! s:fetch_origin_info()
  let l:origin = split(substitute(system('git config --get remote.origin.url'), '\r\=\n$', '', ''), '/')

  return {
    \ 'repos': substitute(l:origin[-1], '\.git$', '', ''),
    \ 'user': split(l:origin[-2], ':')[-1]
  \ }
endfunction

function! s:retrieve_relative_path()
  let l:git_root_fullpath = substitute(system('git rev-parse --show-toplevel'), '\r\=\n$', '', '')
  let l:current_file_fullpath = expand('%:p')
  return substitute(l:current_file_fullpath, '^' . l:git_root_fullpath . '/', '', '')
endfunction

function! s:is_success(ret)
  if s:get_status_code(a:ret) == 201 " Created
    return 1
  else
    return 0
  endif
endfunction

function! s:get_status_code(ret)
  for l:line in split(a:ret, '\n')
    let l:status_code = matchstr(l:line, '^Status:\s\+\zs\d\+\ze\s\+')
    if l:status_code
      return l:status_code
    endif
  endfor
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

