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
	ln -s ./files/_vimrc ~/.vimrc 
	if [ -f ~/.gvimrc ]; then mv ~/.gvimrc ~/.gvimrc.bak; fi 
	ln -s ./files/_gvimrc ~/.gvimrc

	if [ -d ~/.vim ]; then mv ~/.vim ~/.vim.bak; fi
	ln -s -n ./files/vimfiles ~/.vim

	#zsh
	if [ -f ~/.zshrc ]; then mv ~/.zshrc ~/.zshrc.bak; fi
	ln -s ./files/_zshrc ~/.zshrc

	#svn
	if [ -f ~/.subversion ]; then mv ~/.subversion ~/.subversion.bak; fi
	ln -s -n ./files/subversion ~/.subversion

	#scripts
	if [ -d ~/.bin ]; then mv ~/.bin ~/.bin.bak; fi
	ln -s -n ./files/bin ~/.bin
fi

exit
echo 'Done!'
