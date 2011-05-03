#!/bin/bash

#Download the tarball of config files
wget http://dl.dropbox.com/u/1857337/vim.tar

if [ -e setup.tar.gz ];
then
    echo 'Extracting files...'
else
    exit
fi
tar -xf vim.tar
echo 'Moving files into place...'
mv ./vim/_bashrc ~/.bashrc
mv ./vim/_vimrc ~/.vimrc
mv ./vim/_gvimrc ~/.gvimrc
mv ./vim/_zshrc ~/.zshrc
mv ./vim/_zshrc.pre ~/.zshrc.pre
mv ./vim/_gitconfig ~/.gitconfig
mv ./vim/subversion ~/.subversion
mv ./vim/vimfiles ~/.vim
echo 'Cleaning up...'
rm -rf ./vim
rm vim.tar
echo 'Done!'
