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

# Installing required Binaries
if [[ -n $1 && $1 == 1 ]]; then

    sudo dnf -y install vim neovim tmux

fi

# Start afresh with dotfiles
if [[ -n $2 && $2 == 1 ]]; then

    mkdir -pv $ABSOLUTE_PATH/dot_bkp

    # Shell
    for rc_file in bashrc bash_aliases gitconfig
    do
        [ -f $HOME/.$rc_file ] && mv -fv $HOME/.$rc_file $ABSOLUTE_PATH/dot_bkp/$rc_file
        ln -sfv $ABSOLUTE_PATH/shell/$rc_file $HOME/.$rc_file
    done

    # Vim
    [ -d $HOME/.vim ] && mv -fv $HOME/.vim $ABSOLUTE_PATH/dot_bkp/vim
    [ -f $HOME/.vimrc ] && mv -fv $HOME/.vimrc $ABSOLUTE_PATH/dot_bkp/vimrc
    [ -f $HOME/.vimrc ] && mv -fv $HOME/.config/nvim/init $ABSOLUTE_PATH/dot_bkp/init
    rm -rfv $HOME/.vim*
    mkdir -pv $HOME/.vim/pack/minpac/opt/minpac
    mkdir -pv $HOME/.vim/configs

    cd $HOME/.vim/pack/minpac/opt
    git clone https://github.com/k-takata/minpac.git
    cd $ABSOLUTE_PATH
    for file in $ABSOLUTE_PATH/vim/*
    do
        file=`basename $file`
        if [[ $file =~ vimrc ]]; then
            ln -sfv $ABSOLUTE_PATH/vim/$file $HOME/.$file
        elif [[ $file =~ init ]]; then
            [ -d $HOME/.config/nvim ] && mv -fv $HOME/.config/nvim $ABSOLUTE_PATH/dot_bkp/nvim
            mkdir -pv $HOME/.config/nvim; ln -sfv $ABSOLUTE_PATH/vim/$file $HOME/.config/nvim/
        elif [[ $file =~ config || $file =~ pkg ]]; then
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
