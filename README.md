Dotfiles
========
The dotfiles in this repo is specifically targeted to Fedora 30, however with little modifications they can be made to work with any flavour of Linux systems. Posted to GitHub as a backup and can used PUBLICLY on your own risk.

Setup
-----
The installation script is not optimized in any way and at the same time accomplishes the job at hand (creating symbolic links among others)

Dotfiles without binaries installation
```
chmod +x setup.sh
./setup.sh 0 1
```

Dotfiles along with binaries installation
```
chmod +x setup.sh
./setup.sh 1 1
```

Existing config files/directories in your system will be backed to pwd as `dotfile_backup-<TIMESTAMP>.tar.gz`
STDOUT and STDERR are logged in current directory as `setup_<TIMESTAMP>.log`

Following files/directories will be backed up:
- .vimrc, .bashrc, .tmux.conf, .bash_aliases, init (nvim)
- .vim

Tasks
-----
- [x] Create configs (bash, vim, tmux)
- [x] Create an installation script
- [x] Test the installation
- [ ] Optimize/re-write/change configs, installation script when need araises
