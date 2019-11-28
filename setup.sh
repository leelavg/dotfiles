#!/bin/bash

# Break on failures
set -e
set -o pipefail


# Logging to file and displaying on terminal
# https://unix.stackexchange.com/questions/323142/send-to-log-and-display-on-console
TIME=`date +%b_%d_%y-%H-%M-%S`
exec 3<&1
coproc mytee { tee setup_$TIME.log >&3; }
exec >&${mytee[1]} 2>&1

ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
echo "BEGIN ${SCRIPT_NAME%.sh}"

# Download required resources if not exists
if [[ ! -d $ABSOLUTE_PATH/downloads || -z "$(ls -A $ABSOLUTE_PATH/downloads)" ]]; then
    mkdir -pv $ABSOLUTE_PATH/downloads
    cd $ABSOLUTE_PATH/downloads
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

    tar -xvzf $ABSOLUTE_PATH/downloads/libevent-2.1.8-stable.tar.gz
    cd libevent-2.1.8-stable
    ./configure --prefix=/usr/local
    make
    sudo make install
    cd ..

    tar -xvzf $ABSOLUTE_PATH/downloads/tmux-2.7.tar.gz
    cd tmux-2.7
    LDFLAGS="-L/usr/local/lib -Wl,-rpath=/usr/local/lib" ./configure --prefix=/usr/local
    make
    sudo make install
    cd ..

    rm -rfv libevent-2.1.8-stable
    rm -rfv tmux-2.7

    # Extras
    sudo yum -y install neovim tree dos2unix

fi

# Start afresh with dotfiles
if [[ -n $2 && $2 == 1 ]]; then

    mkdir -pv $ABSOLUTE_PATH/dot_bkp

    # Shell
    for rc_file in profile cshrc bashrc bash_profile bash_aliases
    do
        [ -f $HOME/.$rc_file ] && mv -fv $HOME/.$rc_file $ABSOLUTE_PATH/dot_bkp/$rc_file
        ln -sfv $ABSOLUTE_PATH/shell/$rc_file $HOME/.$rc_file
    done

    # Vim
    [ -d $HOME/.vim ] && mv -fv $HOME/.vim $ABSOLUTE_PATH/dot_bkp/vim
    [ -f $HOME/.vimrc ] && mv -fv $HOME/.vimrc $ABSOLUTE_PATH/dot_bkp/vimrc
    rm -rfv $HOME/.vim*
    mkdir -pv $HOME/.vim/pack/bundle/start
    mkdir -pv $HOME/.vim/configs

    for dir in $ABSOLUTE_PATH/downloads/*
    do
        dir=`basename $dir`
        if [[ $dir =~ vim ]]; then
            ln -sfv $ABSOLUTE_PATH/downloads/$dir $HOME/.vim/pack/bundle/start/
        fi
    done

    for file in $ABSOLUTE_PATH/vim/*
    do
        file=`basename $file`
        if [[ $file =~ vimrc ]]; then
            ln -sfv $ABSOLUTE_PATH/vim/$file $HOME/.$file
        elif [[ $file =~ init ]]; then
            [ -d $HOME/.config/nvim ] && mv -fv $HOME/.config/nvim $ABSOLUTE_PATH/dot_bkp/nvim
            [ -z $HOME/.config/nvim ] && mkdir -p $HOME/.config/nvim
            [ -d $HOME/.config/nvim ] && ln -sfv $ABSOLUTE_PATH/vim/$file $HOME/.config/nvim/
        elif [[ $file =~ config ]]; then
            ln -sfv $ABSOLUTE_PATH/vim/$file $HOME/.vim/
        else
            ln -sfv $ABSOLUTE_PATH/vim/$file $HOME/.vim/configs/
        fi
    done

    # Tmux
    [ -f $HOME/.tmux.conf ] && mv -fv $HOME/.tmux.conf $ABSOLUTE_PATH/dot_bkp/
    ln -sfv $ABSOLUTE_PATH/tmux/tmux.conf $HOME/.tmux.conf

    FILENAME=dotfile_backup-$TIME.tar.gz
    tar -cpzfv $FILENAME dot_bkp
    rm -rf dot_bkp

fi

echo "${SCRIPT_NAME%.sh} END"

# find . -type f -print0 -exec dos2unix {} + # Convert scripts written in WSL/Windows to change to Unix line endings
