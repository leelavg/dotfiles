# Filename:     config/bashrc
# Github:       https://github.com/leelavg/dotfiles

#====== Functions {{{

fill() {

  # Command to generate simple IO with random data
  echo
  for i in $(seq $1 $2); do
    # Create a file
    cat /dev/urandom | tr -dc [:space:][:print:] | head -c $3 >file$i
    # Symlinks and hard links
    if ! ln -srf file$i file_s$i 2>/dev/null; then ln -sf file$i file_s$i; fi
    ln -f file_s$i file_sh$i
    ln -f file$i file_oh$i
    echo file$i is created, symlinked and hardlinked successfully
    sleep ${4:-0}
  done
  # Stat all the files
  stat file*
  echo $2 files are created in $(pwd) directory

}

pathadd() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="${PATH:+"$PATH:"}$1"
  fi
}

s() {
  # Search bash history
  rg "$@" $HOME/.bash_history*
}

goi() {
  # Install a specific version of go
  local v=$(wget -qO- https://golang.org/dl/ | grep -Po '(?<=>)go.*(?=.linux-amd64.tar.gz<)' | fzf)
  cd /tmp && go install golang.org/dl/${v}@latest && $v download && cd - > /dev/null
}

sg() {
  # Set temporary go path
  PATH=$(echo $HOME/sdk/$(ls $HOME/sdk | fzf))/bin:${PATH}
}

rp() {
  # reset path
  export PATH=${FINALPATH}
}

osd() {
  if [ -z ${1+x} ]; then
    echo '$1 = dev/qe; $2 = plain/addon; $3 = [addon_name]'
    return
  fi
  # TODO: reduce repetition
  local team=${1:-dev}
  local config=${2:-plain}
  local addon=$3
  local cluster

  if [ $team == "dev" ]; then
    if [ $config == "plain" ]; then
      cluster=$(ocm list clusters --no-headers --columns name,state | awk '{print $2":"$1}' | fzf --print0 | xargs -0 -r | awk -F: '{print $2}')
    elif [ $config == "addon" ]; then
      cluster=$(ocm addons installations $addon --no-headers --no-color --columns addon_id,cluster_name,cluster_state,state | fzf --print0 | xargs -0 -r | awk '{print $3}')
    fi

    local details=$(ocm describe cluster $cluster --json)
    local url=$(jq -r '.api.url' <<<"$details")
    local cid=$(jq -r '.id' <<<"$details")
    local kube="$cid-$cluster"

    if [ ! -f "/tmp/$kube" ]; then
      touch /tmp/$kube
      local creds=$(ocm get /api/clusters_mgmt/v1/clusters/$cid/credentials)
      jq -r .kubeconfig <<<"$creds" >/tmp/$kube
      export KLOGIN=$(echo oc login --server $(grep -oP 'https.*$' /tmp/$kube) -u kubeadmin -p $(jq -r .admin.password <<<"$creds"))
    fi

  elif [ $team == "qe" ]; then
    if [ $config == "plain" ]; then
      cluster=$(ssh -i dev.pem jenkins@ms-qe "ocm list clusters --no-headers --columns name,state" | awk '{print $2":"$1}' | fzf --print0 | xargs -0 -r | awk -F: '{print $2}')
    elif [ $config == "addon" ]; then
      cluster=$(ssh -i dev.pem jenkins@ms-qe "ocm addons installations $addon --no-headers --no-color --columns addon_id,cluster_name,cluster_state,state" | fzf --print0 | xargs -0 -r | awk '{print $3}')
    fi

    local details=$(ssh -i dev.pem jenkins@ms-qe "ocm describe cluster $cluster --json")
    local url=$(jq -r '.api.url' <<<"$details")
    local cid=$(jq -r '.id' <<<"$details")
    local kube="$cid-$cluster"

    if [ ! -f "/tmp/$kube" ]; then
      touch /tmp/$kube
      local creds=$(ssh -i dev.pem jenkins@ms-qe "ocm get /api/clusters_mgmt/v1/clusters/$cid/credentials")
      jq -r .kubeconfig <<<"$creds" >/tmp/$kube
      export KLOGIN=$(echo oc login --server $(grep -oP 'https.*$' /tmp/$kube) -u kubeadmin -p $(jq -r .admin.password <<<"$creds"))
    fi

  fi

  export KUBECONFIG=/tmp/$kube
}

ocml() {
  ln -sfr ~/.config/ocm/ocm-${1}.json ~/.config/ocm/ocm.json
}

# }}}

#====== Defaults {{{

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
  PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# }}}

#====== Shell Options {{{

set -m
# bind -x '"\C-l": clear;'
shopt -s histappend
shopt -s cmdhist
shopt -s checkwinsize

# }}}

#====== Exports {{{

export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=10000
export HISTFILESIZE=20000
EDITOR=$(command -v hx)
EDITOR=${EDITOR:-vi}
export EDITOR
if command -v go 1>/dev/null; then
  export GOPATH=$(go env GOPATH)
  export GOBIN=$GOPATH/bin
  pathadd $GOBIN
fi

if [ -d ~/toolbox/venv ]; then
  # postactivate script
  # PS1="\n(`basename \"$VIRTUAL_ENV\"`) $_OLD_VIRTUAL_PS1"
  export WORKON_HOME=$HOME/toolbox/venv
  export VIRTUALENVWRAPPER_SCRIPT=/usr/local/bin/virtualenvwrapper.sh
  source /usr/local/bin/virtualenvwrapper_lazy.sh
fi

if [ -d ~/Downloads/adhoc/venv ]; then
  export WORKON_HOME=~/Downloads/adhoc/venv
  export VIRTUALENVWRAPPER_SCRIPT=~/.local/bin/virtualenvwrapper.sh
  source ~/.local/bin/virtualenvwrapper_lazy.sh
fi

# }}}

#====== Archive command history {{{

KEEP=200
for FILE in ~/.bash_history ~/.python_history; do
  BACKUP=$FILE.$(date +%y%m)
  if [ -s "$FILE" -a "$FILE" -nt "$BACKUP" ]; then
    # history file is newer than backup
    if [[ -f $BACKUP ]]; then
      # there is already a backup
      $(command -v cp) -f $FILE $BACKUP
    else
      # create new backup, leave last few commands and reinitialize
      mv -f $FILE $BACKUP
      tail -n$KEEP $BACKUP >$FILE
      history -r
    fi
  fi
done

# }}}

#====== Aliases {{{

alias l='ls -lF'
alias ll='ls -AlF'
alias lt='ls -thAlF'
alias ..='cd ..'
alias ...='cd ../..'
alias less='less -R '
alias re="source $HOME/.bashrc && echo reloaded bashrc"
alias g='git'
# tmux
alias tm='tmux -2 new -s '
alias td='tmux attach -d '
alias ta='tmux attach -t '
alias tl='tmux ls'
# zellij
# alias zl='zellij -s '
# alias za='zellij attach -c '
# alias zs='zellij list-sessions'
# File Preview
alias fp="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"
# VPN
alias nu='nmcli -g name,uuid,type c | fzf | cut -d: -f2 | xargs -I uuid nmcli c up uuid -a'
alias nd='nmcli -g name,uuid,type c s --active | grep vpn | cut -d: -f2 | xargs -I uuid nmcli c down uuid'
# Piping json to jq and less
alias jc='jq -C | less -R '
alias yc='yq -C | less -R '
alias gr='gluster'

#==== git
alias gs='git s'
alias gl='git lg'
alias gh='git hist'
alias gal='git aliases'
alias gfa='git fza' # fuzzy add
alias gfc='git fzc' # fuzzy checkout

alias ga='git add'
alias gb='git branch'
alias gc='git checkout'
alias gco='git commit'
alias gpl='git pull'
alias gph='git push'
alias gd='git diff'
alias gpr='git pr'

alias cfg='git --git-dir=$HOME/.dot/ --work-tree=$HOME'

#===== Orchestration
alias k='kubectl'
alias kx='kubectx'
alias kn='kubens'
alias sp='shipyard'
alias n='nomad'
alias osc='oc whoami --show-console'

#===== Docker/Podman/Buildah
alias d='docker'
alias dl='docker ps -l -q'
alias dp='docker ps -a'
alias dre='docker rm $(docker ps -a -q)'
alias drd='docker rmi $(docker images -f "dangling=true" -q) && docker volume rm $(docker volume ls -qf dangling=true)'
alias did='docker images --format "{{.Repository}}:{{.Tag}}" | fzf --print0 -m | xargs -0 -t -r docker rmi'

alias p='podman'
alias b='buildah'

# }}}

#====== Prompt [https://linux.101hacks.com/ps1-examples/prompt-color-using-tput/] {{{
# Colors
cyan='\[$(tput bold)$(tput setaf 6)\]'
green='\[$(tput bold)$(tput setaf 2)\]'
red='\[$(tput bold)$(tput setaf 1)\]'
blue='\[$(tput bold)$(tput setaf 4)\]'
yellow='\[$(tput bold)$(tput setaf 3)\]'
magenta='\[$(tput bold)$(tput setaf 5)\]'
white='\[$(tput bold)$(tput setaf 7)\]'
end='\[$(tput sgr0)\]'

function in_git() {
  if $(git rev-parse --is-inside-work-tree 2>/dev/null); then
    return 0
  fi
  return 1
}

function get_branch() {
  echo "$(git branch --show-current 2>/dev/null)"
}

function get_dirty() {
  dirty=''
  if [ -n "$(git status -s)" ]; then
    dirty='𝓧'
  fi
  echo "$dirty"
}

function get_git() {
  if in_git; then
    echo " [$(echo $(in_git && get_branch && get_dirty))]"
  else
    echo ''
  fi
}

function set_ps1() {

  #-- Local
  h=$(hostname -s | cut -c 1-10)
  prompt="\n$cyan\u$yellow@$red$h $blue\w$yellow\$(get_git) $magenta\$PS2\n$white\\$ $end"

  echo "$prompt"

}

export PROMPT_DIRTRIM=1
if [ -n "${ASCIINEMA_REC}" ]; then
  PS1='~ \$ '
else
  PS1=$(set_ps1)
fi

# }}}

#====== Set by Packages {{{

# If `fzf` is installed using a package manager (dnf) key bindings has to be sourced separately
[ -d /usr/share/fzf/shell ] && source /usr/share/fzf/shell/key-bindings.$(basename $SHELL)

# Jump
command -v jump 1>/dev/null && eval "$(jump shell)"

# AWS
complete -C '/usr/local/bin/aws_completer' aws

# Krew
[ -d ${HOME}/.krew/bin ] && export PATH="${PATH}:${HOME}/.krew/bin"

export FINALPATH="${PATH}"
