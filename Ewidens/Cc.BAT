del c:\AREK.M\FIRMY\OBJEKTY\*.obj
SET PATH=C:\ARRAKIS
sprawy.exe sprawy
@echo off
set OSOBA=
set LOKALNA=
set DRIVER=
set HANDEL=
set AREK=
set STACJA=
SET PATH=c:\CLIP53\BIN
set INCLUDE=c:\CLIP53\INCLUDE
set LIB=c:\CLIP53\LIB
set OBJ=c:\CLIP53\OBJ;c:\AREK.M\FIRMY\OBJEKTY
rem set
rem pause
rmake program.rmk
pause
call o.bat
h.bat
