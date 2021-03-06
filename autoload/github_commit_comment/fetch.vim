let s:save_cpo = &cpo
set cpo&vim

function! github_commit_comment#fetch#fetch()
  let l:origin = github_commit_comment#git#fetch_origin_info()
  let l:sha    = github_commit_comment#git#get_last_modified_sha()
  let l:relative_path = github_commit_comment#git#retrieve_relative_path_from_git_root()
  let l:absolute_path = expand('%:p')

  let l:url = github_commit_comment#api#build_comments_api_url(l:origin, l:sha)
  let l:ret = webapi#http#get(l:url, {
    \ 'Authorization': 'token ' . g:github_commit_comment_vim.token
  \ })
  let l:comments = webapi#json#decode(l:ret.content)

  let l:info = []
  for l:comment in l:comments
    let l:position = l:comment.position
    if l:position && l:comment.path ==# l:relative_path
      call add(l:info, {
        \ 'filename': l:absolute_path,
        \ 'lnum':     l:position,
        \ 'text':     'GitHub Comment (' . l:sha[0:6]. '): ' . l:comment.body,
        \ 'type':     'I'
      \ })
    endif
  endfor

  call setqflist(l:info, 'r')

  if exists('b:syntastic_loclist')
    unlet b:syntastic_loclist
  endif

  highlight github_commit_comment
        \ ctermfg=black ctermbg=yellow
        \ guifg=black   guifg=yellow
  exec 'hi! link QFInfo github_commit_comment'

  HierUpdate
  QuickfixStatusEnable
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

