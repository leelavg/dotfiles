Dotfiles
========
The dotfiles in this repo is specifically targeted to RHEL 7, however with little modifications they can be made to work with any flavour of Linux systems. Posted to GitHub as a backup and can used PUBLICLY on your own risk.

Background
----------
Above scripts assumes that we don't have access to github or any online resources on which these scripts are deployed. Downloads are transferred to our secure environment after verifying locally.

Setup
-----
The installation script is not optimized in any way and at the same time accomplishes the job at hand (creating symbolic links among others)

Installation without extra downloads (assuming downloads folder- generally created with `./setup.sh 1 0` is populated)
```
chmod +x setup.sh
./setup.sh 0 1
```

Installation with external downloads
```
chmod +x setup.sh
./setup.sh 1 1
```

Existing config files/directories in your system will be backed to pwd as `dotfile_bakup-<TIMESTAMP>.tar.gz`
STDOUT and STDERR are logged in current directory as `setup_<TIMESTAMP>.log`

Following files/directories will be backed up:
- .vimrc, .bashrc, .profile, .tmux.conf, .bash_aliases, .cshrc
- .vim

Tasks
-----
- [x] Create configs (bash, vim, tmux)
- [x] Create an installation script
- [x] Test the installation
- [ ] Optimize/re-write/change configs, installation script when need araises
