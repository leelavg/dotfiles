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

Existing files in your system will be backed to your home directory as `dotfile_bakup-<TIMESTAMP>.tar.gz`
STDOUT and STDERR are logged in current directory as `setup_<TIMESTAMP>.log`

Tasks
-----
- [x] Create configs (bash, vim, tmux)
- [x] Create an installation script
- [ ] Test the installation
- [ ] Optimize/re-write/change configs, installation script when need araises

Note
----
The installation script as a whole isn't run as of this posting, this dotfiles repo will be updated as and when required or any GitHub issue is raised.
