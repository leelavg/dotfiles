" Status Line
highlight statusline ctermbg=white ctermfg=magenta
highlight search     ctermbg=white ctermfg=red

" Rebalance windows on vim resize
autocmd VimResized * :wincmd =

" Zoom a vim pane, <C-w>= to re-balance
nnoremap <leader>= :wincmd _<cr>:wincmd \|<cr>
nnoremap <leader>- :wincmd =<cr>
