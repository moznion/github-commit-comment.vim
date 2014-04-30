let s:save_cpo = &cpo
set cpo&vim

let s:default_github_api_endpoint = 'https://api.github.com'

function! github_commit_comment#api#build_comments_api_url(origin, sha)
  if exists('g:github_commit_comment_vim.api_endpoint')
    let l:github_api_endpoint = g:github_commit_comment_vim.api_endpoint
  endif

  if !exists('l:github_api_endpoint') || l:github_api_endpoint ==# ''
    let l:github_api_endpoint = s:default_github_api_endpoint
  endif

  return printf(
    \ l:github_api_endpoint . '/repos/%s/%s/commits/%s/comments',
    \ a:origin.user,
    \ a:origin.repos,
    \ a:sha
  \ )
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
