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

" Minimal Plugins
function! MinimalPlugins() abort
        call minpac#add('tpope/vim-surround')
        call minpac#add('tpope/vim-repeat')
        call minpac#add('machakann/vim-highlightedyank')
        call minpac#add('jiangmiao/auto-pairs')
        call minpac#add('unblevable/quick-scope')
endfunction

" Extra Plugins
function! ExtraPlugins() abort
        call minpac#add('tpope/vim-commentary')
        call minpac#add('christoomey/vim-tmux-navigator')
        call minpac#add('itchyny/lightline.vim')
        call minpac#add('junegunn/fzf', { 'do': { -> system('./install') }})
        call minpac#add('junegunn/fzf.vim')
        call minpac#add('miyakogi/conoline.vim')
endfunction

" Load Plugin Manager (minpac) on demand
function! PackInit(type) abort

    call InstallMinpac()
    packadd minpac
    call minpac#init()
    call minpac#add('k-takata/minpac', {'type':'opt', 'branch':'devel'})

    if a:type == 'minimal'
        call MinimalPlugins()
    elseif a:type == 'full'
        call MinimalPlugins()
        call ExtraPlugins()
    endif

endfunction

" }}}

" Set Commands {{{

set showmatch                               " show matching brackets.
set ignorecase                              " case insensitive matching
set hlsearch                                " highlight search results
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
set lcs=tab:›\ ,trail:•,extends:#,nbsp:.    " lists character
set inccommand=split                        " Searches in a split window
set smartindent                             " Context awareness
set foldmethod=marker
set smarttab
set ruler
set hidden

" Basic Settings for Python
set tabstop=4                               " number of columns occupied by a tab character
set softtabstop=4                           " see multiple spaces as tabstops so <BS> does the right thing
set shiftwidth=4                            " width for autoindents
set textwidth=79                            " Break text after reaching textwidth
set expandtab                               " converts tabs to white space
set autoindent                              " indent a new line the same amount as the line just typed
set fileformat=unix

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

nnoremap <F5> :call LanguageClient_contextMenu()<cr>

nmap 0 ^
nmap <silent> <BS> :nohl<cr>
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
command! PackMinimal call PackInit('minimal') | call minpac#update()
command! PackFull call PackInit('full') | call minpac#update()
command! PackClean  call PackInit('full') | call minpac#clean()
command! PackStatus  packadd minpac | call minpac#status()

" }}}

" Aesthetics{{{

highlight VertSplit cterm=NONE

if ! &rtp =~ 'lightline'
    set showmode
    highlight statusline ctermbg=white ctermfg=magenta
    highlight search     ctermbg=white ctermfg=red
endif

" }}}

" Autocommands {{{

" Rebalance windows on vim resize
autocmd VimResized * :wincmd =
autocmd Filetype help nnoremap <buffer> q :q<CR>

" Escape inside a FZF terminal window should exit the terminal window
autocmd FileType fzf tnoremap <buffer> <Esc> <Esc>

" QuickScope character highlights
highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline

" Highlight Window
augroup BgHighlight
    autocmd!
    autocmd WinEnter * set colorcolumn=80
    autocmd WinLeave * set colorcolumn=0
augroup END

" }}}

" Variable Modifications {{{

" FZF
let g:fzf_commits_log_options = '--graph --color=always
\ --format="%C(yellow)%h%C(red)%d%C(reset)
\ - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)"'

" Conoline
let g:conoline_auto_enable = 1

" Quickscope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" }}}
