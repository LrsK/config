#!/bin/bash

if ! grep -qe "#Added by \$HOME/config/setup.sh" "$HOME/.bashrc"; then    
	cat bashrc.sh >> $HOME/.bashrc
fi


ln -sf $HOME/config/bashrc.d/ $HOME/.bashrc.d
ln -sf $HOME/config/tmux/tmux.conf $HOME/.tmux.conf

git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
