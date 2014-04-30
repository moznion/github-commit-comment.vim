let s:save_cpo = &cpo
set cpo&vim

function! github_commit_comment#comment#comment(comment_type, message) " `comment_type` is very s**ks
  if !s:is_command_executable('git')
    return
  endif

  let t:position = ''
  if a:comment_type == 2 " for line comment
    let t:position = line('.')
  endif

  let t:relative_path = ''
  if a:comment_type == 1 || a:comment_type == 2 " for line or file comment
    let t:relative_path = github_commit_comment#git#retrieve_relative_path_from_git_root()
  endif

  let t:sha    = github_commit_comment#git#get_last_modified_sha()
  let t:origin = github_commit_comment#git#fetch_origin_info()

  if a:message != [] " give message by f-args
    call s:post(
      \  t:sha,
      \  t:origin,
      \  [join(a:message, " ")],
      \  t:relative_path,
      \  t:position,
    \ )
    call github_commit_comment#fetch#fetch()
  else
    let l:tmpfile = '__github_commit_comment_vim_' . localtime()
    10new `=l:tmpfile`
    setlocal filetype=markdown
    cabbrev wq <C-r>='w'<CR>
    autocmd BufWriteCmd <buffer> let t:github_commit_comment_message = getline(0,'$')
    autocmd BufWriteCmd <buffer> :q!
    autocmd BufWriteCmd <buffer> call s:post(
      \  t:sha,
      \  t:origin,
      \  t:github_commit_comment_message,
      \  t:relative_path,
      \  t:position,
    \ )
    autocmd BufWriteCmd <buffer> :cabbrev wq <C-r>='wq'<CR>
    autocmd BufWriteCmd <buffer> call github_commit_comment#fetch#fetch()
  endif
endfunction

function! s:post(sha, origin, body, path, position)
  let l:serialized_body = join(a:body, "\n")
  let l:payload = webapi#json#encode({
    \  'body':     l:serialized_body,
    \  'path':     a:path,
    \  'position': a:position
  \ })

  let l:url = printf('https://api.github.com/repos/%s/%s/commits/%s/comments', a:origin.user, a:origin.repos, a:sha)
  let l:ret = webapi#http#post(l:url, l:payload, {'Authorization': 'token ' . g:github_commit_comment_vim.token})

  redraw

  if l:ret.status == 201
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

let &cpo = s:save_cpo
unlet s:save_cpo

