<?php

error_reporting(E_ERROR | E_PARSE | E_WARNING);//E_NOTICE | 

//automatyczne generowanie zapisów na podstawie danych z dokumentu

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
if (($idd=@$_SESSION["{$baza}DokumentyID_D"])!==null)
{
	$idd=($idd==0?-1:$idd);
	$_POST['ID_D']=$idd;

	$dokument=mysqli_fetch_array(mysqli_query($link, "select * from dokumenty where ID=$idd"));
	$_POST['DATA']=$dokument['DOPERACJI'];
	$_POST['NRDOW']=$dokument['NUMER'];
	$_POST['NRKONT']=$dokument['NRKONT'];
	$_POST['PSKONT']=$dokument['PSKONT'];
	$_POST['NIP']=$dokument['NIP'];
	$_POST['NAZWA']=$dokument['NAZWA'];
	$_POST['ADRES']=$dokument['ADRES'];
	$_POST['OPIS']=$dokument['PRZEDMIOT'];

	if(!$dokument['TYP'])
	{
		$dokument['TYP']=trim(explode('-',$_GET['typ'])[0]);
	}
	
//	$rejestr=mysqli_fetch_row(mysqli_query($link, "select sum(NETTO) from dokumentr where ID_D=$idd"));

	$typRejestru=mysqli_fetch_row(mysqli_query($link, "select TYP from dokumentr where ID_D=$idd and if(1*'$idd'=-1,KTO='$ido',1) order by ID limit 1"))[0];
	$rejestr=mysqli_fetch_row(mysqli_query($link, "select sum(NETTO) from dokumentr where ID_D=$idd and TYP='$typRejestru' and if(1*'$idd'=-1,KTO='$ido',1)"));

	if(!$rejestr[0])
	{
		$schematy=mysqli_query($link,$q="
			select schematy.*
			  from schematy
			 where schematy.TYP='$dokument[TYP]'
		");
		if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

		if($schemat=mysqli_fetch_array($schematy))
		{
			//jaka stawka VAT byla ostatnio dla takiego rejestru
			$stawka=mysqli_fetch_row(mysqli_query($link,$q="
				select STAWKA
				  from dokumentr
				 where TYP='$schemat[REJESTR]'
			  order by ID desc 
				 limit 1
			"))[0]; 
			if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
		}
		
		$brutto=str_replace(',','.',$_GET['brutto']);
		$stawka=(!$stawka?'brak':$stawka);
		$vat=$brutto*$stawka/(100+$stawka*1);
		$rejestr[0]=$netto=$brutto-$vat;
	}
	
	if(substr($dokument['TYP'],0,1)=='S')
	{
		$_POST['PRZYCHOD1']=$rejestr[0];
	} else
	{
		if($stawka=='brak')
		{
			$_POST['POZOSTALE']=$rejestr[0];
		}
		else
		{
			$_POST['ZAKUP_TOW']=$rejestr[0];
		}
	}

	//usuniecie dotychczasowych zapisów
	mysqli_query($link,$q="
		delete
		  from kpr
		 where ID_D='$idd'
		   and if(1*'$idd'=-1,KTO='$ido',1)
	"); 
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
}

unset($_POST['szukaj']);
$_POST['KTO']=$_SESSION['osoba_id'];

$_POST['PRZYCHOD3']=$_POST['PRZYCHOD1']+$_POST['PRZYCHOD2'];
$_POST['RAZEM']=$_POST['WYNAGRODZENIA']+$_POST['POZOSTALE'];

$id=0;
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveFormFields.php");

header('location:..');
