<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$wynik='';
switch($_REQUEST['validType'])
{
case 'abonenci.blok':
   $wynik=strtoupper(preg_replace('/[^A-Za-z0-9]/', '', $_REQUEST['val']));
   if (!mysql_fetch_row(mysql_query("select count(*) from AdresyBudynki where AB_BlokNr='$wynik'"))[0]) {
      $wynik='brak takiego numeru bloku w bazie danych';
   }
   break;
case 'abonenci.idulicy':
   $wynik=strtoupper(preg_replace('/[^A-Za-z0-9]/', '', $_REQUEST['val']));
   if (!mysql_fetch_row(mysql_query("select count(*) from ulice where IDULICY='$wynik'"))[0]) {
      $wynik='brak takiego ID ulicy w bazie danych';
   }
   break;
case 'abonenci.nrdomu':
   $wynik=strtoupper(preg_replace('/[^A-Za-z0-9\/]/', '', $_REQUEST['val']));
   //if (!mysql_fetch_row(mysql_query("select count(*) from AdresyBudynki where AB_UlicaNr='$wynik'"))[0]) {
   //   $wynik='brak takiego numeru domu w bazie danych';
   //}
   break;
case 'abonenci.nrmieszkania':
   $wynik=strtoupper(preg_replace('/[^A-Za-z0-9\/]/', '', $_REQUEST['val']));
   //if (!mysql_fetch_row(mysql_query("select count(*) from AdresyBudynki where AB_Lok='$wynik'"))[0]) {
   //   $wynik='brak takiego numeru mieszkania w bazie danych';
   //}
   break;
}

//print_r(json_encode($wynik));
echo $wynik;
