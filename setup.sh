#!/bin/bash

# Break on failures
set -e
set -o pipefail

ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
echo "BEGIN ${SCRIPT_NAME%.sh}"

# Logging to file and displaying on terminal
# https://unix.stackexchange.com/questions/323142/send-to-log-and-display-on-console
TIME=`date +%b-%d-%y`
exec 3<&1
coproc mytee { tee setup_$TIME.log >&3; }
exec >&${mytee[1]} 2>&1

# Download required resources if not exists
if [[ ! -d $HOME/dotfiles/downloads || -z "$(ls -A $HOME/dotfiles/downloads)" ]]; then
    mkdir -pv $HOME/dotfiles/downloads
    cd $HOME/dotfiles/downloads
    curl -OL https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz
    curl -OL https://github.com/tmux/tmux/releases/download/2.7/tmux-2.7.tar.gz
    git clone https://github.com/tpope/vim-surround.git
    git clone https://github.com/tpope/vim-repeat.git
    git clone https://github.com/tpope/vim-commentary.git
    git clone https://github.com/tpope/vim-unimpaired.git
    git clone https://github.com/christoomey/vim-tmux-navigator.git
    git clone https://github.com/machakann/vim-highlightedyank.git

    # https://gist.github.com/facelordgists/80e868ff5e315878ecd6
    find . \( -name ".git" -o -name ".gitignore" -o -name ".gitmodules" -o -name ".gitattributes" \) -exec rm -rf -- {} +
    cd $ABSOLUTE_PATH

fi

# Steps to install (tmux 2.7) and some handy tools on fresh RHEL 7
if [[ -n $1 && $1 == 1 ]]; then

    # Install dependencies
    sudo yum -y groupinstall "Development Tools"
    sudo yum -y install glibc-static ncurses-devel

    tar -xvzf $HOME/dotfiles/downloads/libevent-2.1.8-stable.tar.gz
    cd libevent-2.1.8-stable
    ./configure --prefix=/usr/local
    make
    sudo make install
    cd ..

    tar -xvzf $HOME/dotfiles/downloads/tmux-2.7.tar.gz
    cd tmux-2.7
    LDFLAGS="-L/usr/local/lib -Wl,-rpath=/usr/local/lib" ./configure --prefix=/usr/local
    make
    sudo make install
    cd ..

    pkill tmux
    rm -rfv libevent-2.1.8-stable
    rm -rfv tmux-2.7

    # Extras
    sudo yum -y install neovim tree dos2unix

fi

# Start afresh with dotfiles
if [[ -n $2 && $2 == 1]]; then

    mkdir -pv $HOME/dot_bkp

    # Shell
    mv -fv $HOME/{.profile,.cshrc,.bashrc} $HOME/dot_bkp/
    ln -sfv $HOME/dotfiles/shell/profile $HOME/.profile
    ln -sfv $HOME/dotfiles/shell/cshrc $HOME/.cshrc
    ln -sfv $HOME/dotfiles/shell/bashrc $HOME/.bashrc

    # Vim
    mv -rfv $HOME/.vim* $HOME/dot_bkp/
    rm -rfv $HOME/.vim*
    mkdir -pv $HOME/.vim/pack/bundle/start
    mkdir -pv $HOME/.vim/configs

    for dir in $HOME/dotfiles/downloads/*
    do
        dir=`basename $dir`
        if [[ $dir =~ vim ]]; then
            ln -sfv $HOME/dotfiles/downloads/$dir $HOME/.vim/pack/bundle/start/
        fi
    done

    for file in $HOME/dotfiles/vim/*
    do
        file=`basename $file`
        if [[ $file =~ vimrc ]]; then
            ln -sfv $HOME/dotfiles/vim/$file $HOME/.$file
        elif [[ $file =~ init ]]; then
            ln -sfv $HOME/dotfiles/vim/$file $HOME/.config/nvim/
        elif [[ $file =~ config ]]; then
            ln -sfv $HOME/dotfiles/vim/$file $HOME/.vim/
        else
            ln -sfv $HOME/dotfiles/downloads/$dir $HOME/.vim/configs/
        fi
    done

    # Tmux
    mv -fv $HOME/.tmux.conf $HOME/dot_bkp/
    ln -sfv $HOME/dotfiles/tmux/tmux.conf $HOME/.tmux.conf

    FILENAME=dotfile_bakup-$TIME.tar.gz        
    tar -cpzf $HOME/$FILENAME $HOME/dot_bkp   
    rm -rf dot_bkp                           

fi

echo "${SCRIPT_NAME%.sh} END"

# find . -type f -print0 -exec dos2unix {} + # Convert scripts written in WSL/Windows to change to Unix line endings
