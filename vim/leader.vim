" Leader commands
map <space> <leader>

" For Bash Aliases
let $BASH_ENV="~/.bash_aliases"

" General
map <leader>so :source ~/.config/nvim/init.vim<cr>
map <leader>v :vnew <C-r>=escape(expand("%:p:h"), ' ') . '/'<cr>
map <leader>co ggVG*y   " Copy the entire buffer into the system register
map <leader>l :set cursorline!<CR>
map <leader>p :set paste!<CR>

" Project specific
map <leader>w :w! /tmp/lines<CR>
map <leader>r :r /tmp/lines<CR>
