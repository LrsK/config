#!/bin/bash

GOVERSION=1.7.4

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
	$sudo_command $YUM install -y zsh curl wget git automake gcc gcc-c++ kernel-devel cmake python-devel python3-devel clang
	curl --silent --location https://rpm.nodesource.com/setup_7.x | $sudo_command bash -
	$sudo_command $YUM install -y nodejs
fi

if [ ! -z "$APT" ]; then
	$sudo_command $APT install -y zsh curl wget git build-essential cmake python-dev python3-dev clang
	curl -sL https://deb.nodesource.com/setup_7x | $sudo_command -E bash -
	$APT install -y nodejs
fi

# Install oh-my-zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# Install pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
git clone https://github.com/tpope/vim-pathogen ~/.vim/autoload/pathogen.vim

# Install Go
GOFILE=go${GOVERSION}.linux-amd64.tar.gz
if [ ! -f ${GOFILE} ]; then
	wget https://storage.googleapis.com/golang/${GOFILE}
fi
$sudo_command rm -rf /usr/local/go
$sudo_command tar -C /usr/local -xzf ${GOFILE}
if [ "0" -ne "$?" ]; then
	echo "Go install failed"
	exit 1
fi

# make some symlinks
ln -sf $HOME/config/bashrc.d/ $HOME/.bashrc.d
ln -sf $HOME/config/tmux/tmux.conf $HOME/.tmux.conf
ln -sf $HOME/config/eslintrc/eslinstrc $HOME/.eslintrc

# Add stuff to .zshrc
if ! grep -qe "# Added by \$HOME/config/setup.sh" "$HOME/.zshrc"; then    
	cat $HOME/config/bashrc.sh >> $HOME/.zshrc
fi

# Use zshrc
source $HOME/.zshrc

# Install vim-go-ide
git clone https://github.com/farazdagi/vim-go-ide.git ~/.vim_go_runtime
sh ~/.vim_go_runtime/bin/install


git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
# vim settings
ln -sf $HOME/config/vim/vimrc $HOME/.vimrc
# Install pliugins through vundle
vim +PluginInstall +qall
vim +GoInstallBinaries +qall

# Compile YCM
cd ~/.vim/bundle/YouCompleteMe
./install.py --clang-completer --gocode-completer --system-libclang
cd -

# Install npm globals
# First change globals dir
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
# Install global packages
npm install -g eslint babel-eslint eslint-plugin-react
