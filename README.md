# github-commit-comment.vim

Post and show GitHub commit comment on vim

## Description

This plugin supports the following features;

- Post commit comment by vim
    - Line comment
    - Commit comment
    - File comment
- Show commit line comment on vim

These command work on current git revision (means `HEAD`) and `origin` of remote.

## Commands

### GitHubLineComment [comment]

Posts commit line comment to current revision and current cursored line.

#### Without command argument
![commit line comment](https://dl.dropboxusercontent.com/u/14832699/github-commit-comment-vim/line_comment.gif)

#### With command argument
![commit line comment with argument](https://dl.dropboxusercontent.com/u/14832699/github-commit-comment-vim/line_comment2.gif)

### GitHubCommitComment [comment]

Posts commit comment to current revision.
![commit comment](https://dl.dropboxusercontent.com/u/14832699/github-commit-comment-vim/commit_comment.gif)

### GitHubFileComment [comment]

Posts commit file comment to current revision and current file.
![commit file comment](https://dl.dropboxusercontent.com/u/14832699/github-commit-comment-vim/file_comment.gif)

### GitHubFetchCommitComment

Fetch commit comments and show line comments on Vim (insert into quickfix)
![fetch commit comments](https://dl.dropboxusercontent.com/u/14832699/github-commit-comment-vim/fetch.gif)

## Configurations

1. Generate access token of GitHub at "Personal access tokens" ([https://github.com/settings/applications](https://github.com/settings/applications)). This plugin only requires `repo` permission.

2.  Please put `.github_commit_comment.vim` file on your home directory. And fill github access token into this file. For example;

```vim
let g:github_commit_comment_vim = {'token': '4be7622cf9d7b2154255e2afeb2384e0898f3046'}
```

## Dependencies

### Requires

- [webapi-vim](https://github.com/mattn/webapi-vim])

### Recommends

- [vim-hier](https://github.com/jceb/vim-hier)
- [quickfixstatus](https://github.com/dannyob/quickfixstatus)

## License

MIT
