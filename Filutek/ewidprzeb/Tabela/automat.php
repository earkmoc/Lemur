<?php

error_reporting(E_ERROR | E_PARSE | E_WARNING);//E_NOTICE | 

//automatyczne generowanie zapisów na podstawie danych z dokumentu

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
if (($idd=@$_SESSION["{$baza}DokumentyID_D"])!==null)
{
	$idd=($idd==0?-1:$idd);
	$_POST['ID_D']=$idd;

	$dokument=mysqli_fetch_array(mysqli_query($link, "select * from dokumenty where ID=$idd"));
	$_POST['LPDZ']=$dokument['LP'];
	$_POST['DATAW']=$dokument['DDOKUMENTU'];
	$_POST['NRDZ']=$dokument['NUMER'];

	if(!$dokument['TYP'])
	{
		$dokument['TYP']=trim(explode('-',$_GET['typ'])[0]);
	}
	
	$stawka=mysqli_fetch_row(mysqli_query($link, "select STAWKA from ewidprzeb where STAWKA<>0 order by ID desc limit 1"))[0];
	$_POST['STAWKA']=$ewidencja[0];

	//usuniecie dotychczasowych zapisów
	mysqli_query($link,$q="
		delete
		  from ewidprzeb
		 where ID_D='$idd'
		   and if(1*'$idd'=-1,KTO='$ido',1)
	"); 
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
}

unset($_POST['szukaj']);
$_POST['KTO']=$_SESSION['osoba_id'];

$id=0;
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveFormFields.php");

header('location:..');
