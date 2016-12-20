#!/bin/bash

sudo_command=$(which sudo)

YUM=`which yum 2>/dev/null`
DNF=`which dnf 2>/dev/null`
APT=`which apt-get 2>/dev/null`

# if DNF is available use it
if [ -x "$DNF" ]; then
	YUM=$DNF
fi

if [ -z "$YUM" -a -z "$APT" ]; then
	echo "The package managers can't be found."
	exit 1
fi

if [ ! -z "$YUM" ]; then
	$sudo_command $YUM install -y zsh wget

fi

if [ ! -z "$APT" ]; then
	$sudo_command $APT install -y zsh wget
fi

# Install oh-my-zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# Add stuff to .zshrc
if ! grep -qe "# Added by \$HOME/config/setup.sh" "$HOME/.zshrc"; then    
	cat zshrc.sh >> $HOME/.zshrc
fi

# zsh setting
ln -sf $HOME/config/bashrc.d/ $HOME/.bashrc.d
# tmux settings
ln -sf $HOME/config/tmux/tmux.conf $HOME/.tmux.conf

git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
ln -sf $HOME/config/vim/vimrc $HOME/.vimrc
vim +PluginInstall +qall
