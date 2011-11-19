#!/bin/bash
os=`uname`

#windows setup
if [[ "$os" =~ ".*NT.*" ]]
then
    echo "Run setup.bat to set up windows"
    echo

fi

if [[ "$os" =~ "Linux" ]]
then
    echo "it's linux!"
    #bash
    if [ -f ~/.bashrc ]; then mv ~/.bashrc ~/.bashrc.bak; fi
    ln -s ./_bashrc ~/.bashrc

    #vim
    if [ -f ~/.vimrc ]; then mv ~/.vimrc ~/.vimrc.bak; fi
    ln -s ./_vimrc ~/.vimrc
    if [ -f ~/.gvimrc ]; then mv ~/.gvimrc ~/.gvimrc.bak; fi
    ln -s ./_gvimrc ~/.gvimrc

    #zsh
    if [ -f ~/.zshrc ]; then mv ~/.zshrc ~/.zshrc.bak; fi
    ln -s ./_zshrc ~/.zshrc

    #svn
    if [ -d ~/.subversion ]; then mv ~/.subversion ~/.subversion.bak; fi
    ln -s -n ./subversion ~/.subversion

    #scripts
    if [ -d ~/.bin ]; then mv ~/.bin ~/.bin.bak; fi
    ln -s -n ./bin ~/.bin

    #tmux
    if [ -f ~/.tmux.conf ]; then mv ~/.tmux.conf ~/.tmux.conf.bak; fi
    ln -s -n ./_tmux.conf ~/.tmux.conf
fi

exit
echo 'Done!'
