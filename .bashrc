#====== Defaults

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
  PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

#====== Shell Options

shopt -s histappend

#====== Exports

export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=-1
export HISTFILESIZE=-1

EDITOR=$(command -v hx)
EDITOR=${EDITOR:-vi}
export EDITOR

#====== Aliases

# General
alias l='ls -thAlF'
alias ..='cd ..'
alias ...='cd ../..'
alias less='less -R '
alias re='source $HOME/.bashrc && echo reloaded bashrc'
alias i='incus'
alias jc='jq -C | less -R '
alias yc='yq -C | less -R '
alias gr='gluster'

# tmux
alias tm='tmux -2 new -s '
alias td='tmux attach -d '
alias ta='tmux attach -t '
alias tl='tmux ls'

# File Preview
alias fp='fzf --preview "bat --style=numbers --color=always --line-range :500 {}"'

# VPN
alias nu='nmcli -g name,uuid,type c | fzf | cut -d: -f2 | xargs -I uuid nmcli c up uuid -a'
alias nd='nmcli -g name,uuid,type c s --active | grep vpn | cut -d: -f2 | xargs -I uuid nmcli c down uuid'

# git
alias g='git'

alias gs='git s'
alias gl='git lg'
alias gh='git hist'
alias ga='git add'
alias gb='git branch'
alias gd='git diff'
alias gw='git worktree'

alias gcp='git cherry-pick'
alias gco='git commit'
alias gpl='git pull'
alias gph='git fpush'
alias gpr='git pr'
alias gal='git als'
alias gst='git switch'
alias grt='git restore'
alias gfa='git fza'
alias gfc='git fzc'

alias cfg='git --git-dir=$HOME/.dot/ --work-tree=$HOME'

#===== Orchestration
alias k='kubectl'
alias kx='kubectx'
alias kn='kubens'
alias sp='shipyard'
alias n='nomad'
alias osc='oc whoami --show-console'

#===== Containers
alias d='docker'
alias dl='docker ps -l -q'
alias dp='docker ps -a'
alias dre='docker rm $(docker ps -a -q)'
alias drd='docker rmi $(docker images -f "dangling=true" -q) && docker volume rm $(docker volume ls -qf dangling=true)'
alias did='docker images --format "{{.Repository}}:{{.Tag}}" | fzf --print0 -m | xargs -0 -t -r docker rmi'

alias p='podman'
alias b='buildah'

#====== For packages

[ -d /usr/share/fzf/shell ] && source /usr/share/fzf/shell/key-bindings.$(basename $SHELL)
command -v zoxide >/dev/null && eval "$(zoxide init bash)"
command -v starship >/dev/null && eval "$(starship init bash)"
command -v vfox >/dev/null && eval "$(vfox activate bash)"
