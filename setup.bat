@echo off
set PWD=%~dp0
echo %PWD%

mklink "C:\Users\%USERNAME%\.vimrc" "%PWD%_vimrc"
