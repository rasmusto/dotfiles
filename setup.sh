#!/bin/bash

#Download the tarball of config files
wget http://dl.dropbox.com/u/1857337/setup/files.tar.gz

if [ -e files.tar.gz ];
then
    echo 'Extracting files...'
else
    exit
fi
tar -xf files.tar.gz
echo 'Moving files into place...'
mv ./files/_bashrc ~/.bashrc
mv ./files/_vimrc ~/.vimrc
mv ./files/_gvimrc ~/.gvimrc
mv ./files/_zshrc ~/.zshrc
mv ./files/_zshrc.local ~/.zshrc.local
mv ./files/_zshrc.pre ~/.zshrc.pre
mv ./files/_gitconfig ~/.gitconfig
mv ./files/subversion ~/.subversion
mv ./files/vimfiles ~/.vim
echo 'Cleaning up...'
rm -rf ./files
rm files.tar.gz
echo 'Done!'
