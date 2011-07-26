@echo off
set PWD=%~dp0
echo %PWD%
for /f %%A in ('dir /b') do echo %%A
rem for /f %%A in ('dir /b') do if exist %%A\NUL mklink /D "%PWD%files\vimfiles\bundle\%%A" "C:\Users\%USERNAME%\repos\setup\%%A"
rem for /f %%A in ('dir /b') do if exist %%A\NUL mklink /D "C:\Users\%USERNAME%\repos\setup\files\vimfiles\bundle\%%A" "C:\Users\%USERNAME%\repos\setup\%%A"

mkdir "C:\Users\%USERNAME%\vimfiles"
mkdir "C:\Users\%USERNAME%\vimfiles\bundle"
for /f %%A in ('dir /b') do if exist %%A\NUL mklink /D "C:\Users\%USERNAME%\vimfiles\bundle\%%A" "%PWD%%%A"
mklink /D "C:\Users\%USERNAME%\vimfiles\autoload" "%PWD%files\vimfiles\autoload"
rem mklink /D "C:\Users\%USERNAME%\vimfiles" "%PWD%files\vimfiles"
rem mklink /D "C:\Users\%USERNAME%\vimfiles" "C:\Users\%USERNAME%\repos\setup\files\vimfiles"

mklink "C:\Users\%USERNAME%\.vimrc" "%PWD%files\_vimrc"
rem mklink "C:\Users\%USERNAME%\.vimrc" "C:\Users\%USERNAME%\repos\setup\files\_vimrc"
