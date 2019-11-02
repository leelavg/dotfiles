" Leader commands
let mapleader="\<Space>"

" General
map <leader>so :source $MYVIMRC<cr>
map <leader>v :vnew <C-r>=escape(expand("%:p:h"), ' ') . '/'<cr>   " Pre-populate a split command with the current directory
map <leader>cv <C-v>
map <leader>co ggVG*y   " Copy the entire buffer into the system register
map <leader>l :set cursorline!<CR>

" Project specific
map <leader>p :!plt %<CR>
map <leader>n :!ntl %<CR>
map <leader>w :w! ~/temp/lines<CR>
map <leader>r :r ~/temp/lines<CR>