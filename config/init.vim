" Filename:   init.vim
" Github:     https://github.com/leelavg/dotfiles/

" Path {{{

set packpath^=$HOME/.nvim/

" }}}

" Custom Functions {{{

" Install minpac
function! InstallMinpac() abort

    call mkdir($HOME.'/.nvim', 'p')
    if !isdirectory($HOME.'/.nvim/pack')
        if !exists('*minpac#init')
            if !executable('git')
                " Install git
                :echo '..... Installing git command line utility .....'
                :silent !yum -y install git &>/dev/null
                :echo '..... Installed git command line utility .....'
            endif

            " Install minpac
            call mkdir($HOME.'/.nvim/pack/minpac/opt/minpac', 'p')
            :silent !cd $HOME/.nvim/pack/minpac/opt/ && git clone https://github.com/k-takata/minpac.git 2>/dev/null
        endif
    endif

endfunction

" Load Plugin Manager (minpac) on demand
function! PackInit() abort

    call InstallMinpac()

    packadd minpac
    call minpac#init()
    call minpac#add('k-takata/minpac', {'type':'opt', 'branch':'devel'})

    call minpac#add('tpope/vim-surround')
    call minpac#add('tpope/vim-repeat')
    call minpac#add('christoomey/vim-tmux-navigator')
    call minpac#add('machakann/vim-highlightedyank')
    call minpac#add('itchyny/lightline.vim')
    call minpac#add('jiangmiao/auto-pairs')
    call minpac#add('preservim/nerdcommenter')
    call minpac#add('junegunn/fzf', { 'do': { -> system('./install') }})
    call minpac#add('junegunn/fzf.vim')

endfunction

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
set shiftround                              " Rounding to shiftwidth in block operations
set textwidth=79                            " Break text after reaching textwidth
set noshowmode                              " lightline takes over status line
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
map <leader>n :source $cwd/.init.vim<cr>
map <leader>e :set cursorline!<CR>
map <leader>p :set paste!<CR>
nmap <leader>= :wincmd _<cr>:wincmd \|<cr>
nmap <leader>- :wincmd =<cr>

nnoremap <silent> <leader>f :Files<cr>
nnoremap <silent> <leader>g :GFiles?<cr>
nnoremap <silent> <leader>l :Lines<cr>
nnoremap <silent> <leader>c :BCommits<cr>
nnoremap <silent> <leader>b :Buffers<cr>
nnoremap <silent> <leader>m :Marks<cr>

nnoremap <leader>rg :Rg<space>
nnoremap <leader>rg! :Rg!<space>

nmap 0 ^
nmap <silent> <BS> :let @/=""<cr>
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
command! PackUpdate source $cwd/.init.vim | call PackInit() | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  source $cwd/.init.vim | call PackInit() | call minpac#clean()
command! PackStatus packadd minpac | call minpac#status()

" }}}

" Status Line {{{

" tookover by 'lightline'
" highlight statusline ctermbg=white ctermfg=magenta
" highlight search     ctermbg=white ctermfg=red

" }}}

" Autocommands {{{

" Rebalance windows on vim resize
autocmd VimResized * :wincmd =
autocmd Filetype help nnoremap <buffer> q :q<CR>

" Escape inside a FZF terminal window should exit the terminal window
autocmd FileType fzf tnoremap <buffer> <Esc> <Esc>

" }}}

" Variable Modifications {{{

" Netrw
let g:netrw_liststyle = 3
let g:netrw_banner = 0

" FZF
let g:fzf_commits_log_options = '--graph --color=always
  \ --format="%C(yellow)%h%C(red)%d%C(reset)
  \ - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)"'
let g:fzf_layout = { 'window': {
            \ 'width': 0.9,
            \ 'height': 0.7,
            \ 'highlight': 'Comment',
            \ 'rounded': v:false } }

" }}}
