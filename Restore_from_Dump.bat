rem @ECHO OFF
 
SET u=root
SET p=223
SET baza=%1
SET ext=Dump
SET sql=%baza%_%ext%.sql
SET arch=%baza%_%ext%.7z

"C:\Program Files\7-Zip\7z.exe" x %arch% -pEla!@#223#@!
C:\wamp64\bin\mysql\mysql5.7.11\bin\mysql.exe -u%u% -p%p% -e "drop database %1";
C:\wamp64\bin\mysql\mysql5.7.11\bin\mysql.exe -u%u% -p%p% -e "create database %1";
C:\wamp64\bin\mysql\mysql5.7.11\bin\mysql.exe -u%u% -p%p% %baza% < %sql%
del %sql%
del %arch%
@echo
@echo ****************************************************
@echo ******     Restore from DUMP: WYKONANE      ********
@echo ****************************************************
