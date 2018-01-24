<?php

error_reporting(E_ERROR | E_PARSE | E_WARNING);//E_NOTICE | 

//automatyczne generowanie zapisów na podstawie danych z dokumentu

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$idd=$_GET[idd];
$idd=($idd==0?-1:$idd);

$dokument=array();
$dokument['TYP']=trim(explode('-',$_GET['typ'])[0]);
$dokument['DOPERACJI']=$_GET['data'];
$dokument['WARTOSC']=str_replace(',','.',$_GET['brutto']);

//usuniecie dotychczasowych zapisów
mysqli_query($link,$q="
	delete
	  from dokumentr
	 where ID_D='$idd'
	   and if(1*'$idd'=-1,KTO='$ido',1)
"); 
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

$schematy=mysqli_query($link,$q="
	select schematy.*
	  from schematy
	 where schematy.TYP='$dokument[TYP]'
");
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

while($schemat=mysqli_fetch_array($schematy))
{
	//jaka stawka VAT byla ostatnio dla takiego rejestru
	$stawka=mysqli_fetch_row(mysqli_query($link,$q="
		select STAWKA
		  from dokumentr
		 where TYP='$schemat[REJESTR]'
		   and KTO=$ido
	  order by ID desc 
		 limit 1
	"))[0]; 
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

	if(!$stawka)
	{
		$stawka=mysqli_fetch_row(mysqli_query($link,$q="
			select STAWKA
			  from dokumentr
			 where TYP='$schemat[REJESTR]'
		  order by ID desc 
			 limit 1
		"))[0]; 
		if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
	}

	$okres=$dokument['DOPERACJI'];
	$brutto=$dokument['WARTOSC'];
	$stawka=(!$stawka?'23%':$stawka);
	$vat=$brutto*$stawka/(100+$stawka*1);
	$netto=$brutto-$vat;
	mysqli_query($link,$q="
		insert
		  into dokumentr
		   set ID_D='$idd'
			 , KTO='$ido'
			 , CZAS=Now()
			 , TYP='$schemat[REJESTR]'
			 , NETTO='$netto'
			 , STAWKA='$stawka'
			 , VAT='$vat'
			 , BRUTTO='$brutto'
			 , OKRES='$okres'
	");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
}

if ($idd)
{
	$brutto=mysqli_fetch_row(mysqli_query($link, $q="select sum(BRUTTO) from dokumentr where ID_D='$idd'"))[0];
	$netto =mysqli_fetch_row(mysqli_query($link, $q="select sum(NETTO) from dokumentr where ID_D='$idd'"))[0];
	$vat   =mysqli_fetch_row(mysqli_query($link, $q="select sum(VAT) from dokumentr where ID_D='$idd'"))[0];
	mysqli_query($link, $q="update dokumenty set WARTOSC='$brutto', NETTOVAT='$netto', PODATEK_VAT='$vat' where ID='$idd'");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
}

header('location:..');
