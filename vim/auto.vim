" Contains autocommands

autocmd BufNewFile,BufRead *.thpl set filetype=perl
autocmd BufWinLeave ?.* mkview
autocmd BufWinEnter ?.* silent loadview
autocmd Filetype help nnoremap <buffer> q :q<CR>

augroup BgHighlight
    autocmd!
    autocmd WinEnter * set cursorline
    autocmd WinLeave * set nocursorline
augroup END
