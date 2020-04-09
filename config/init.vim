" Filename:   init.vim
" Github:     https://github.com/leelavg/dotfiles/

" Plugins (minpac) {{{

set packpath^=~/.nvim/packages/
if isdirectory($HOME.'/.nvim/packages/pack')
    packadd minpac
endif

if !exists('*minpac#init')
    " Install minpac
    call mkdir ($HOME.'/.nvim/packages/pack/minpac/opt/minpac', 'p')
    :!cd $HOME/.nvim/packages/pack/minpac/opt/ && git clone https://github.com/k-takata/minpac.git 2>/dev/null
    packadd minpac
endif

call minpac#init()
call minpac#add('tpope/vim-surround')
call minpac#add('tpope/vim-unimpaired')
call minpac#add('tpope/vim-repeat')
call minpac#add('tpope/vim-commentary')
call minpac#add('christoomey/vim-tmux-navigator')
call minpac#add('machakann/vim-highlightedyank')
call minpac#add('k-takata/minpac', {'type':'opt'})

" }}}

" Set Commands {{{

set showmatch                               " show matching brackets.
set ignorecase                              " case insensitive matching
set hlsearch                                " highlight search results
set tabstop=4                               " number of columns occupied by a tab character
set softtabstop=4                           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab                               " converts tabs to white space
set shiftwidth=4                            " width for autoindents
set autoindent                              " indent a new line the same amount as the line just typed
set number                                  " add line numbers
set relativenumber                          " for easy movements
set wildmenu                                " Vim tab completions
set wildmode=longest:full,full              " Vim tab completions
set modelines=0                             " Turn off modelines
set nomodeline                              " Turn off modelines
set wrap                                    " Automatically wrap text that extends beyond the screen length.
set scrolloff=100                           " Display 100 lines above/below the cursor when scrolling with a mouse.
set backspace=indent,eol,start              " Fixes common backspace problems
set laststatus=2                            " Status bar
set showcmd                                 " Display options
set matchpairs+=<:>                         " Highlight matching pairs of brackets. Use the '%' character to jump between them.
set list                                    " Display different types of white spaces.
set encoding=utf-8                          " Encoding
set incsearch                               " Enable incremental search
set smartcase                               " Include only uppercase words with uppercase search term
set viminfo='100,<9999,s100                 " Store more info
set formatoptions+=tcqrn1                   " Control formats on newlines
set noshiftround                            " Neglect rounding to shiftwidth in block operations
set textwidth=80                            " Break text after reaching textwidth
set showmode                                " which mode are we in currently
set lcs=tab:›\ ,trail:•,extends:#,nbsp:.    " lists character
set inccommand=split                        " Searches in a split window
set smartindent                             " Context awareness
set foldmethod=marker
set smarttab
set ruler

" }}}

" Misc {{{

filetype plugin indent on                   " allows auto-indenting depending on file type
syntax on                                   " syntax highlighting

" }}}

" All Mappings {{{

map <space> <leader>
map <leader>so :source $MYVIMRC <bar> :doautocmd BufRead<cr>
map <leader>v :vnew <C-r>=escape(expand("%:p:h"), ' ') . '/'<cr>
map <leader>l :set cursorline!<CR>
map <leader>p :set paste!<CR>
nmap <leader>= :wincmd _<cr>:wincmd \|<cr>
nmap <leader>- :wincmd =<cr>

nmap 0 ^
nmap <silent> <BS>  :nohlsearch<CR>
imap jk <esc>:w<cr>
imap kj <esc>:w<cr>
nmap j gj
nmap k gk

" }}}

" Command Aliases {{{

command! Q q " Bind :Q to :q
command! Qall qall
command! QA qall
command! E e
command! PackUpdate call minpac#update()
command! PackClean  call minpac#clean()
command! PackStatus call minpac#status()

" }}}

" Status Line {{{

highlight statusline ctermbg=white ctermfg=magenta
highlight search     ctermbg=white ctermfg=red

" }}}

" Autocommands {{{

" Rebalance windows on vim resize
autocmd VimResized * :wincmd =

autocmd BufNewFile,BufRead *.thpl set filetype=perl
autocmd BufWinLeave ?.* mkview
autocmd BufWinEnter ?.* silent loadview
autocmd Filetype help nnoremap <buffer> q :q<CR>

augroup BgHighlight
    autocmd!
    autocmd WinEnter * set cursorline
    autocmd WinLeave * set nocursorline
augroup END

" }}}
