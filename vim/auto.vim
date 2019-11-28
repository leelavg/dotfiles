" Contains autocommands

autocmd BufNewFile,BufRead *.thpl set filetype=perl
autocmd BufWinLeave ?.* mkview
autocmd BufWinEnter ?.* silent loadview
" autocmd CursorHold,CursorHoldI * update
autocmd Filetype help nnoremap <buffer> q :q<CR>
