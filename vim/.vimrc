inoremap jj <ESC>

augroup vimrc
  autocmd!
  autocmd FocusLost * silent! wa
augroup END

" never run modelines from opened files (a Homebrew vim does not read Apple's vimrc)
set nomodeline nomodelineexpr
set secure
