#!/bin/bash

# Break on failures
set -e
set -o pipefail

ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

# Logging to file and displaying on terminal
# https://unix.stackexchange.com/questions/323142/send-to-log-and-display-on-console
TIME=`date +%b_%d_%y-%H-%M-%S`
exec 3<&1
coproc mytee { tee $ABSOLUTE_PATH/setup_$TIME.log >&3; }
exec >&${mytee[1]} 2>&1
echo "BEGIN ${SCRIPT_NAME%.sh}"

# Symlinks
[ -L $HOME/.dotfiles ] && rm $HOME/.dotfiles
ln -sfv $ABSOLUTE_PATH/config $HOME/.dotfiles
ln -sfv /etc/hosts $HOME/.dotfiles/etc_hosts

for file in $HOME/.dotfiles/*
do
    file=`basename $file`
    ln -sfv $HOME/.dotfiles/$file $HOME/.$file
done


# Creating required directories
mkdir -pv $HOME/.local/share/kyrat
mkdir -pv $HOME/.config/nvim && ln -sfv $HOME/.init.vim $HOME/.config/nvim/init.vim
git clone https://github.com/leelavg/kyrat $HOME/.local/share/kyrat &> /dev/null
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm &> /dev/null

echo "${SCRIPT_NAME%.sh} END"

# find . -type f -print0 -exec dos2unix {} + # Convert scripts written in WSL/Windows to change to Unix line endings
# install `fzf` using `git` method and link minpac path to ~/.fzf
