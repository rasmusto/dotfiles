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
if [ -f ~/.bashrc ]; then 
    mv ~/.bashrc ~/.bashrc.bak 
fi
ln -s ~/setup/files/_bashrc ~/.bashrc

#vim
if [ -f ~/.vimrc ]; then 
    mv ~/.vimrc ~/.vimrc.bak 
fi
ln -s ~/setup/files/_vimrc ~/.vimrc

if [ -f ~/.gvimrc ]; then 
    mv ~/.gvimrc ~/.gvimrc.bak 
fi
ln -s ~/setup/files/_gvimrc ~/.gvimrc

if [ -d ~/.vim ]; then 
    mv ~/.vim ~/.vim.bak 
fi
ln -s -n ~/setup/files/vimfiles ~/.vim

#zsh
if [ -f ~/.zshrc ]; then 
    mv ~/.zshrc ~/.zshrc.bak 
fi
ln -s ~/setup/files/_zshrc ~/.zshrc

if [ -f ~/.zshrc.local ]; then 
    mv ~/.zshrc.local ~/.zshrc.local.bak 
fi
ln -s ~/setup/files/_zshrc.local ~/.zshrc.local

if [ -f ~/.zshrc.pre ]; then 
    mv ~/.zshrc.pre ~/.zshrc.pre.bak 
fi
ln -s ~/setup/files/_zshrc.pre ~/.zshrc.pre

#git
if [ -f ~/.gitconfig ]; then 
    mv ~/.gitconfig ~/.gitconfig.bak 
fi
ln -s ~/setup/files/_gitconfig ~/.gitconfig

#svn
if [ -f ~/.subversion ]; then 
    mv ~/.subversion ~/.subversion.bak 
fi
ln -s -n ~/setup/files/subversion ~/.subversion

#scripts
if [ -d ~/.bin ]; then 
    mv ~/.bin ~/.bin.bak 
fi
ln -s -n ~/setup/files/bin ~/.bin

echo 'Done!'

#echo "Enter your git name: "
#echo "i.e. "Firstname Lastname""
#read name
#git config --global user.name "$name"

#echo "Enter your git email: "
#echo "i.e. "user@address.com""
#read email
#git config --global user.email $email
