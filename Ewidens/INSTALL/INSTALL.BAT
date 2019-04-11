c:\

mkdir c:\archiwum
mkdir c:\arrakis

copy a:\system.exe c:\archiwum
copy a:\%1.exe c:\arrakis

cd \archiwum
system.exe
del system.exe

cd\arrakis
%1.exe
del %1.exe
