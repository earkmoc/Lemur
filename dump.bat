@ECHO OFF
 
SET u=root
SET p=223
SET baza=%1
SET ext=Dump
SET sql=%baza%_%ext%.sql
SET arch=%baza%_%ext%.7z

rem del %sql%
rem del %arch%

echo ******************************************************************************
echo DUMP bazy: %baza%
echo ******************************************************************************

C:\wamp64\bin\mysql\mysql5.7.11\bin\mysqldump.exe -u%u% -p%p% %baza% > %sql%
"C:\Program Files\7-Zip\7z.exe" a %arch% %sql% -pEla!@#223#@!
del %sql%

echo ==============================================================================
echo DUMP bazy: %baza% wykonany
echo ==============================================================================

cls
