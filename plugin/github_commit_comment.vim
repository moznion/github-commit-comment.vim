if exists('g:loaded_github_commit_comment') && g:loaded_github_commit_comment == 1
  finish
endif

try
  execute 'source $HOME/.github_commit_comment.vim'
  source $HOME/.github_commit_comment.vim
catch
  " Nothing to do
endtry

if !exists('g:github_commit_comment_vim')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=* GitHubLineComment   call github_commit_comment#comment_line(<f-args>)
command! -nargs=* GitHubFileComment   call github_commit_comment#comment_file(<f-args>)
command! -nargs=* GitHubCommitComment call github_commit_comment#comment_commit(<f-args>)

let g:loaded_github_commit_comment = 1

let &cpo = s:save_cpo
unlet s:save_cpo

