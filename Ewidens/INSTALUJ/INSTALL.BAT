@echo off
echo Instalacja programu drukowania z poziomu Windows
echo.
copy a:\wydruki.r00 c:\arrakis>nul
cls
echo Teraz dyskietka Nr 2
echo.
echo.
pause
cls
echo Instalacja programu drukowania z poziomu Windows
copy a:\wydruki.exe c:\arrakis>nul
c:
cd\arrakis
wydruki.exe
del wydruki.exe
del wydruki.r00
cd\
cls
echo Koniec.
