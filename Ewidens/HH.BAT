@echo off

rem subst g: c:\arek.m\firmy\ewidens
rem set include=

set PATH=C:\WINDOWS\COMMAND;c:\ARRAKIS
set arek=
set arek=OK
set stacja=

set MONITOR=
set MONITOR=HIGH

REM set HANDEL=1
set HANDEL=

set ARRAKIS=1
rem set ARRAKIS=2

c:
cd\arrakis
keybpl.exe MA ON
egapl.exe MA ACTIVE

rem pol_klaw
rem pol_znak vga

REM cd\stem2003.10
REM c:\arrakis\r.exe . wzory.ewi system

cd\arrakis\fk\drozd
c:\arrakis\r.exe

rem c:\arrakis\r.exe . c:\arrakis\fk\clch\wzory c:\arrakis\fk\clch\system 

c:
cd\arrakis
keybpl.exe MA RE
egapl.exe MA REMOVE

cd\arek.m\firmy\ewidens
