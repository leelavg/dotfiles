# Dotfiles

## Motive
---

To use same **dotfiles** across multiple linux machines (Red Hat family). Only _bashrc_ and _init.vim_ are shared across the network and trying best not to install any packages on remote server, however with little tweaking other dotfiles can also be shared on demand.

### Neovim
---

The following tools are installed impliclity if the remote server doesn't have **neovim**

1. neovim: _appimage incase nvim is not installed_
2. minpac: _package manager for neovim_
3. git: _for cloning minpac and other plugins on demand_

### Bash
---

Required dotfiles are transferred to remote server on **_every_** login and **_deleted_** on every logout. This is made possible by [kyrat](https://github.com/fsquillace/kyrat). However neovim _appimage_ (if downloaded) and plugins will not be deleted.

### Configs
---

Symlinks for other files are created upon running ```chmod +x setup.sh && ./setup.sh```. Current repo consists of below configs:
```ansible, bashrc, gitconfig, init.vim, tmux.conf```

Each config only span a single file and separated using fold markers (easy to maintain with nvim).

### Backups
---

Currently **no** backups are provided, all configs are symlinked to ```~/.dotfiles/```and individiual configs are symlinked based on this directory. Only a log is created and the ouput on running `setup.sh` is mirrored in this log.


### Compatibility
---

- [x] Fedora 32
- [x] RHEL 8
- [x] CentOS 8

### ToDo
---
- [ ] Backup of existing dotfiles

---
## **PS:** Please raise an issue for any info and **Use at your own risk**
---
