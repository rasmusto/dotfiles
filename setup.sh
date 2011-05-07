#!/bin/bash

echo 'Creating symlinks...'

#bash
ln -s ./files/_bashrc ~/.bashrc

#vim
ln -s ./files/_vimrc ~/.vimrc
ln -s ./files/_gvimrc ~/.gvimrc
ln -s ./files/vimfiles ~/.vim

#zsh
ln -s ./files/_zshrc ~/.zshrc
ln -s ./files/_zshrc.local ~/.zshrc.local
ln -s ./files/_zshrc.pre ~/.zshrc.pre

#git
ln -s ./files/_gitconfig ~/.gitconfig

#svn
ln -s ./files/subversion ~/.subversion

#scripts
ln -s ./files/bin ~/.bin

echo 'Done!'
