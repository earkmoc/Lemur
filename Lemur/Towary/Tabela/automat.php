<?php

error_reporting(E_ERROR | E_PARSE | E_WARNING);//E_NOTICE | 

//automatyczne generowanie zapisów na podstawie danych z dokumentu

$stawka='23%';

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
if (($idd=@$_SESSION["{$baza}DokumentyID_D"])!==null)
{
	$idd=($idd==0?-1:$idd);
	$_POST['ID_D']=$idd;

	$dokument=mysqli_fetch_array(mysqli_query($link, "select * from dokumenty where ID=$idd"));
	if(!$dokument['TYP'])
	{
		$dokument['TYP']=trim(explode('-',$_GET['typ'])[0]);
	}
	
	$rejestr=mysqli_fetch_row(mysqli_query($link, "select sum(NETTO), sum(VAT), sum(BRUTTO) from dokumentr where ID_D=$idd"));

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
		$stawka=(!$stawka?'23%':$stawka);
		$vat=$brutto*$stawka/(100+$stawka*1);
		$rejestr[0]=$netto=$brutto-$vat;
		$rejestr[1]=$vat;
		$rejestr[2]=$brutto;
	}
	
	$_POST['NETTO']=$rejestr[0];
	$_POST['VAT']=$rejestr[1];
	$_POST['BRUTTO']=$rejestr[2];

	//usuniecie dotychczasowych zapisów
	mysqli_query($link,$q="
		delete
		  from dokumentm
		 where ID_D='$idd'
		   and if(1*'$idd'=-1,KTO='$ido',1)
	"); 
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
}

unset($_POST['szukaj']);
$_POST['KTO']=$_SESSION['osoba_id'];

$_POST['TYP']='T';
$_POST['CZAS']=date('Y-m-d H:i:s');
$_POST['STAWKA']=(!$stawka?'23%':$stawka);
$_POST['NAZWA']='Towary';
$_POST['INDEKS']='';
$_POST['PKWIU']='';
$_POST['ILOSC']=1;
$_POST['JM']='szt.';
$_POST['CENABEZR']=$_POST['NETTO'];
$_POST['CENA']=$_POST['NETTO'];

$id=0;
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveFormFields.php");

header('location:..');
