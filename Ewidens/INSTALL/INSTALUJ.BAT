@echo off

c:
mkdir c:\archiwum
mkdir c:\arrakis

copy a:\system.exe c:\archiwum
copy a:\kpr.exe c:\arrakis
copy a:\kpr1998.bat c:\archiwum
copy a:\kpr1999.bat c:\archiwum
copy a:\kpr1998.pif c:\windows\pulpit
copy a:\kpr1999.pif c:\windows\pulpit
copy a:\kpr1998.pif d:\windows\pulpit
copy a:\kpr1999.pif d:\windows\pulpit
type a:\a>>c:\autoexec.bat
type a:\b>>c:\config.sys

cd\archiwum
system.exe
del system.exe

cd\arrakis
kpr.exe
del kpr.exe
del wzory\tak_ne.txt
del system\*.ntx

c:\archiwum\pol_znak vga
cd\
cls
type a:\napis.txt
pause