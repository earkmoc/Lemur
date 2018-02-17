<?php

error_reporting(E_ERROR | E_PARSE | E_WARNING);//E_NOTICE | 

//automatyczne generowanie zapisów na podstawie danych z dokumentu

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
if (($idd=@$_SESSION["{$baza}DokumentyID_D"])!==null)
{
	$idd=($idd==0?-1:$idd);
	$_POST['ID_D']=$idd;
}

//usuniecie dotychczasowych zapisów
mysqli_query($link,$q="
	delete
	  from ewidwypo
	 where ID_D='$idd'
	   and if(1*'$idd'=-1,KTO='$ido',1)
"); 
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

unset($_POST['szukaj']);
$_POST['KTO']=$_SESSION['osoba_id'];
$_POST['CZAS']=date('Y-m-d H:i:s');
$_POST['LP']=mysqli_fetch_row(mysqli_query($link,$q="select LP from ewidwypo order by LP desc limit 1"))[0]+1;
$_POST['DATANABYCIA']=$_GET['data'];
$_POST['NUMERDOK']=$_GET['numer'];
$_POST['NAZWA']=$_GET['przedmiot'];
$_POST['CENA']=$_GET['brutto'];

$id=0;
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveFormFields.php");

header('location:..');
