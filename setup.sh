#!/bin/bash

if [ -d ~/setup ];
then
    echo "There is a setup dir"
    echo 'Creating symlinks...'
else
    echo "No setup dir detected, creating one..."
    mkdir ~/setup
    if [ -e ./files.tar.gz ]
    then
        echo "files.tar.gz is here!"
        tar xvzf files.tar.gz -C ~/setup/
    else
        echo "files.tar.gz isn't here :("
    fi
fi

#bash
ln -s ~/setup/files/_bashrc ~/.bashrc

#vim
ln -s ~/setup/files/_vimrc ~/.vimrc
ln -s ~/setup/files/_gvimrc ~/.gvimrc
ln -s -n ~/setup/files/vimfiles ~/.vim

#zsh
ln -s ~/setup/files/_zshrc ~/.zshrc
ln -s ~/setup/files/_zshrc.local ~/.zshrc.local
ln -s ~/setup/files/_zshrc.pre ~/.zshrc.pre

#git
ln -s ~/setup/files/_gitconfig ~/.gitconfig

#svn
ln -s -n ~/setup/files/subversion ~/.subversion

#scripts
ln -s -n ~/setup/files/bin ~/.bin

echo 'Done!'

echo "Enter your git name: "
read name
git config --global user.name "$name"

echo "Enter your git email: "
read email
git config --global user.email $email
