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
if [ -f ~/.vimrc ] mv ~/.bashrc ~/.bashrc.bak
ln -s ~/setup/files/_bashrc ~/.bashrc

#vim
if [ -f ~/.vimrc ] mv ~/.vimrc ~/.vimrc.bak
ln -s ~/setup/files/_vimrc ~/.vimrc

if [ -f ~/.vimrc ] mv ~/.vimrc ~/.vimrc.bak
ln -s ~/setup/files/_gvimrc ~/.gvimrc

if [ -d ~/.vim ] mv ~/.vim ~/.vim.bak
ln -s -n ~/setup/files/vimfiles ~/.vim

#zsh
if [ -f ~/.zshrc ] mv ~/.zshrc ~/.zshrc.bak
ln -s ~/setup/files/_zshrc ~/.zshrc

if [ -f ~/.zshrc.local ] mv ~/.zshrc.local ~/.zshrc.local.bak
ln -s ~/setup/files/_zshrc.local ~/.zshrc.local

if [ -f ~/.zshrc.pre ] mv ~/.zshrc.pre ~/.zshrc.pre.bak
ln -s ~/setup/files/_zshrc.pre ~/.zshrc.pre

#git
if [ -f ~/.gitconfig ] mv ~/.gitconfig ~/.gitconfig.bak
ln -s ~/setup/files/_gitconfig ~/.gitconfig

#svn
if [ -f ~/.subversion ] mv ~/.subversion ~/.subversion.bak
ln -s -n ~/setup/files/subversion ~/.subversion

#scripts
if [ -d ~/.bin ] mv ~/.bin ~/.bin.bak
ln -s -n ~/setup/files/bin ~/.bin

echo 'Done!'

echo "Enter your git name: "
echo "i.e. "Firstname Lastname""
read name
git config --global user.name "$name"

echo "Enter your git email: "
echo "i.e. "user@address.com""
read email
git config --global user.email $email
