#!/bin/bash

echo 'Creating symlinks...'

ln -s ./files/_bashrc ~/.bashrc
ln -s ./files/_vimrc ~/.vimrc
ln -s ./files/_gvimrc ~/.gvimrc
ln -s ./files/_zshrc ~/.zshrc
ln -s ./files/_zshrc.local ~/.zshrc.local
ln -s ./files/_zshrc.pre ~/.zshrc.pre
ln -s ./files/_gitconfig ~/.gitconfig
ln -s ./files/subversion ~/.subversion
ln -s ./files/vimfiles ~/.vim

echo 'Done!'
