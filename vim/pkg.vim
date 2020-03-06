packadd minpac
call minpac#init()

call minpac#add('tpope/vim-surround')
call minpac#add('tpope/vim-unimpaired')
call minpac#add('tpope/vim-repeat')
call minpac#add('tpope/vim-commentary')

call minpac#add('christoomey/vim-tmux-navigator')

call minpac#add('machakann/vim-highlightedyank')

call minpac#add('k-takata/minpac', {'type':'opt'})

" minpac commands
command! PackUpdate call minpac#update()
command! PackClean  call minpac#clean()
