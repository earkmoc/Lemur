call dump.bat Lemur2
call dump.bat Lemur

"C:\Program Files\7-Zip\7z.exe" a -m0=Copy -sdel \Archiwa\BazaDanych_%date:~0,13%_%RANDOM%.7z *Dump.7z 
"C:\Program Files\7-Zip\7z.exe" a -p223 \Archiwa\Program_Lemur2_%date:~0,13%_%RANDOM%.7z Lemur* bootstrap* *.php *.bat

echo .
echo .
echo ******************************************************************************
echo **                                                                          **
echo ** Archiwizacja bazy danych i programu wykonana. Wszystko jest w C:\Archiwa **
echo **                                                                          **
echo ******************************************************************************
echo .
pause
