" Contains basic key mappings

" Set commands
set nocompatible                    " disable compatibility to old-time vi
set showmatch                       " show matching brackets.
set ignorecase                      " case insensitive matching
set hlsearch                        " highlight search results
set tabstop=4                       " number of columns occupied by a tab character
set softtabstop=4                   " see multiple spaces as tabstops so <BS> does the right thing
set expandtab                       " converts tabs to white space
set shiftwidth=4                    " width for autoindents
set autoindent                      " indent a new line the same amount as the line just typed
set number                          " add line numbers
set relativenumber                  " for easy movements
set wildmenu                        " Vim tab completions
set wildmode=longest:full,full      " Vim tab completions
set modelines=0                     " Turn off modelines
set nomodeline                      " Turn off modelines
set wrap                            " Automatically wrap text that extends beyond the screen length.
set scrolloff=100                   " Display 100 lines above/below the cursor when scrolling with a mouse.
set backspace=indent,eol,start      " Fixes common backspace problems
set ttyfast                         " Speed up scrolling in Vim
set laststatus=2                    " Status bar
set showcmd                         " Display options
set matchpairs+=<:>                 " Highlight matching pairs of brackets. Use the '%' character to jump between them.
set list                            " Display different types of white spaces.
set encoding=utf-8                  " Encoding
set incsearch                       " Enable incremental search
set smartcase                       " Include only uppercase words with uppercase search term
set viminfo='100,<9999,s100         " Store more info
set formatoptions+=tcqrn1           " Control formats on newlines
set noshiftround                    " Neglect rounding to shiftwidth in block operations
set textwidth=80                    " Break text after reaching textwidth
set showmode                        " which mode are we in currently
set lcs=tab:›\ ,trail:•,extends:#,nbsp:.    " lists character
set smartindent
set smarttab
set ruler

" Misc
filetype plugin indent on           " allows auto-indenting depending on file type
syntax on                           " syntax highlighting

" Map commands
nmap 0 ^
nmap <silent> <BS>  :nohlsearch<CR>
imap jk <esc>:w<cr>
imap kj <esc>:w<cr>
nmap j gj
nmap k gk

" Command aliases for typo'ed commands (accidentally holding shift too long)
command! Q q " Bind :Q to :q
command! Qall qall
command! QA qall
command! E e

" NeoVim commands
if has('nvim')
   set inccommand=split         " Searches in a split window
endif

