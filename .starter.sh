# curl -Lks https://raw.githubusercontent.com/leelavg/dotfiles/main/.starter.sh | /bin/bash
git clone --bare git@github.com:leelavg/dotfiles.git $HOME/.dot
function cfg {
  /usr/bin/git --git-dir=$HOME/.dot/ --work-tree=$HOME $@
}
cfg checkout 2>&1 | grep -E "\s+\." | awk {'print $1'} | xargs -I{} mv -f {} /tmp/
cfg checkout
cfg config status.showUntrackedFiles no
