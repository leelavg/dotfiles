" Filename:   init.vim
" Github:     https://github.com/leelavg/dotfiles/

" Path {{{

" set packpath^=$HOME/.nvim/

" }}}

" Custom Functions {{{

" Install minpac
function! InstallMinpac() abort

    if !isdirectory($HOME.'/.config/nvim/pack')
        if !exists('*minpac#init')
            " if !executable('git')
            "     " Install git
            "     :echo '..... Installing git command line utility .....'
            "     :silent !yum -y install git &>/dev/null
            "     :echo '..... Installed git command line utility .....'
            " endif

            " Install minpac
            call mkdir($HOME.'/.config/nvim/pack/minpac/opt/', 'p')
            :silent !cd $HOME/.config/nvim/pack/minpac/opt/ && git clone https://github.com/k-takata/minpac.git 2>/dev/null
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
        call minpac#add('junegunn/fzf.vim')
        call minpac#add('numirias/semshi')
        call minpac#add('ludovicchabant/vim-gutentags')
        call minpac#add('skywind3000/gutentags_plus')
        call minpac#add('majutsushi/tagbar')
        call minpac#add('mgedmin/python-imports.vim')
        call minpac#add('fatih/vim-go')
        call minpac#add('tpope/vim-fugitive')
        call minpac#add('tpope/vim-obsession')
        call minpac#add('crusoexia/vim-monokai')
        call minpac#add('pprovost/vim-ps1')
        call minpac#add('prettier/vim-prettier')
        call minpac#add('alaviss/nim.nvim')
        call minpac#add('martinda/Jenkinsfile-vim-syntax')
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

" Show colors
function! <SID>SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun

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
set hidden
set fileformat=unix
set tabstop=4                              " number of columns occupied by a tab character
set softtabstop=4                          " see multiple spaces as tabstops so <BS> does the right thing
set shiftwidth=4                           " width for autoindents
set expandtab                              " converts tabs to white space
set mouse=a                               " helps not scrolling tmux pane

" }}}

" Misc {{{

filetype plugin indent on                   " allows auto-indenting depending on file type
syntax on                                   " syntax highlighting

" }}}

" All Mappings {{{

map              <space>     <leader>
map     <silent> <leader>n   :source $cwd/.init.vim<cr>
map     <silent> <leader>e   :set cursorline!<CR>
map     <silent> <leader>p   :set paste!<CR>
nmap    <silent> <leader>=   :wincmd _<cr>:wincmd \|<cr>
nmap    <silent> <leader>-   :wincmd =<cr>
nmap    <silent> <F8>        :TagbarToggle<cr>
map     <silent> <leader>v   :vsp <cr>:exec("tag ".expand("<cword>"))<cr>
map     <silent> <leader>o   :only<cr>
nmap    <silent> <leader>u   :set rnu! nu!<cr>

nnoremap <silent> <leader>f :Files<cr>
nnoremap <silent> <leader>F :GFiles<cr>
nnoremap <silent> <leader>l :Lines<cr>
nnoremap <silent> <leader>c :BCommits<cr>
nnoremap <silent> <leader>b :Buffers<cr>
nnoremap <silent> <leader>m :Marks<cr>
nnoremap <silent> <leader>T :BTags<cr>
nnoremap <silent> <leader>t :Tags<cr>
map      <silent> <leader>i :ImportName<cr>

" vim-go bindings
nnoremap <silent> <leader>gr :GoRun<cr>
nnoremap <silent> <leader>gt :GoTest<cr>
nnoremap <silent> <leader>ga :GoAlternate<cr>
nnoremap <silent> <leader>gi :GoImports<cr>

" Ripgrep
nnoremap <leader>rg :Rg<space>
nnoremap <leader>rg! :Rg!<space>

" Lua bindings
map <silent> <leader>a :luafile %<cr>

" Prettier JS
nmap <leader>pr :PrettierAsync %<cr>

" Colors
" :so $VIMRUNTIME/syntax/hitest.vim
nmap <leader>s :call <SID>SynGroup()<cr>

nmap 0 ^
nmap j gj
nmap k gk
imap jk <esc>:w<cr>
imap kj <esc>:w<cr>
nmap <silent> <BS> :nohl<cr>

inoremap <expr> <TAB>   pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"

" Use jumplist in place of changelist
nnoremap <silent> g; <C-o>
nnoremap <silent> g, <C-i>

" ShellCheck in QuickFix window
nnoremap <silent> gb :ShellCheck! <cr>

" }}}

" Command Aliases {{{

command! Q q " Bind :Q to :q
command! Qall qall
command! QA qall
command! E e
command! X x
command! PackMinimal    call PackInit('minimal') | call minpac#update()
command! PackFull       call PackInit('full') | call minpac#update()
command! PackClean      call PackInit('full') | call minpac#clean()
command! PackStatus     packadd minpac | call minpac#status()

" Remove tags cache dir
command! -nargs=0 GutentagsClearCache call system('rm ' . g:gutentags_cache_dir . '/*')

" }}}

" Aesthetics{{{

highlight VertSplit     cterm=NONE
" highlight statusline    ctermbg=white   ctermfg=magenta
" highlight search        ctermbg=white   ctermfg=red
" highlight ColorColumn   ctermbg=234
" highlight CursorLine    ctermbg=234     cterm=None

" QuickScope character highlights
highlight QuickScopePrimary     guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
highlight QuickScopeSecondary   guifg='#5fffff' gui=underline ctermfg=81 cterm=underline

set statusline=\|CWD:%r%{getcwd()}%h\|%=\|Path:%f\|%=\|Total:%L,Line:%l,Column:%c\|

" }}}

" Autocommands {{{

augroup AdhocSettings
    autocmd!
    " Rebalance windows on vim resize
    autocmd VimResized * :wincmd =
    autocmd Filetype help nnoremap <buffer> q :q<CR>

    " Escape inside a FZF terminal window should exit the terminal window
    autocmd FileType fzf tnoremap <buffer> <Esc> <Esc>

    " Close quickfixlist with <esc>
    autocmd FileType qf nnoremap <silent> <buffer> <esc> :cclose<cr>

    " Maybe inconsistent but better than inbuilt
    autocmd BufNewFile,BufRead Dockerfile* set syntax=ruby

    " Unset foldmethod for Nim files
    autocmd FileType nim set foldmethod=manual

    " Spell Check for markdown files
    autocmd BufRead,BufNewFile *.md setlocal spell
    autocmd BufRead,BufNewFile *.md set complete+=kspell

augroup END

" Highlight Window
augroup BgHighlight
    autocmd!
    autocmd WinEnter,BufEnter * set colorcolumn=80 cursorline
    autocmd WinLeave * set colorcolumn=0 nocursorline
augroup END

" Basic Settings for Python
augroup filetype_python
    autocmd!
    autocmd FileType python set textwidth=79  " Break text after reaching textwidth
    autocmd FileType python set autoindent    " indent a new line the same amount as the line just typed
    autocmd Filetype python :iabbrev <buffer> sat self.assertTrue()<left>
    autocmd Filetype python :iabbrev <buffer> sae self.assertEqual()<left>
    autocmd Filetype python set foldmethod=indent foldnestmax=2 nofoldenable
augroup END

" Basic Setting for YAML
augroup filetype_yaml
    autocmd!
    autocmd BufNewFile,BufRead *yaml* set filetype=yaml
    autocmd FileType yaml set ts=2 sts=2 sw=2 expandtab indentkeys-=0#
    autocmd FileType yaml set indentkeys-=<:> foldmethod=indent nofoldenable
augroup END

" Setting for Nim
augroup completion
    autocmd!
    autocmd FileType nim nnoremap <silent> <leader>nr :make -r --out:/tmp/nim-cache<cr>
augroup END

" }}}

" Variable Modifications {{{

" FZF
let g:fzf_commits_log_options = '--graph --color=always
\ --format="%C(yellow)%h%C(red)%d%C(reset)
\ - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)"'
" let $FZF_DEFAULT_COMMAND = 'rg --files --hidden'

" Quickscope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" Gutentags
let g:gutentags_add_default_project_roots = 0
let g:gutentags_modules = ['ctags', 'gtags_cscope']
let g:gutentags_project_root = ['package.json', '.git']
let g:gutentags_cache_dir = expand('~/.cache/ctags/')
let g:gutentags_plus_switch = 1
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 0
let g:gutentags_ctags_extra_args = [
    \ '--tag-relative=yes',
    \ '--fields=+ailmnS',
    \ ]
let g:gutentags_ctags_exclude = [
    \ '*.git', '*.svg', '*.hg', '*/tests/*', 'build', 'dist', '*sites/*/files/*',
    \ 'bin', 'node_modules', 'bower_components', 'cache', 'compiled', 'docs',
    \ 'example', 'bundle', 'vendor', '*.md', '*-lock.json', '*.lock',
    \ '*bundle*.js', '*build*.js', '.*rc*', '*.json', '*.min.*', '*.map',
    \ '*.bak', '*.zip', '*.pyc', '*.class', '*.sln', '*.Master', '*.csproj',
    \ '*.tmp', '*.csproj.user', '*.cache', '*.pdb', 'tags*', 'cscope.*',
    \ '*.css', '*.less', '*.scss', '*.exe', '*.dll', '*.mp3', '*.ogg',
    \ '*.flac', '*.swp', '*.swo', '*.bmp', '*.gif', '*.ico', '*.jpg',
    \ '*.png', '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz',
    \ '*.tar.bz2', '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx',
    \ ]

" vim-go
let g:go_fmt_command = 'goimports'
let g:go_highlight_format_strings = 1
let g:go_highlight_function_arguments = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_functions = 1
let g:go_highlight_operators = 1
let g:go_highlight_types = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_variable_assignments = 1
let g:go_highlight_variable_declarations = 1

" Colorscheme
set termguicolors
colorscheme monokai
highlight String guifg=#dea18a

" }}}
