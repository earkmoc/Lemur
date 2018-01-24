<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
$od_netto=$_SESSION['od_netto'];

if ($idd=$_SESSION["{$baza}DokumentyID_D"])
{
	$_POST['ID_D']=$idd;
}
$_POST['KTO']=$_SESSION['osoba_id'];
$_POST['CZAS']=date('Y-m-d H:i:s');

$_POST['ILOSC'] =str_replace(',','.',$_POST['ILOSC']);
$_POST['RABAT']  =str_replace(',','.',$_POST['RABAT']);
$_POST['RABAT'] =(1*$_POST['RABAT']?$_POST['RABAT']:0);
$_POST['STAWKA']=(!$_POST['STAWKA']?'23%':$_POST['STAWKA']);
$_POST['CENABEZR']=str_replace(',','.',$_POST['CENABEZR']);
$_POST['BRUTTO']=str_replace(',','.',$_POST['BRUTTO']);

$liczCene_i_Brutto=true;
//	  ||(round($_POST['NETTO']*1.00,2)==0.00)
//	  ||(round($_POST['VAT']*1.00,2)==0.00)
if	( ($_POST['BRUTTO']*1<>0)
	&&(round(($_POST['ILOSC']*1.000),3)<>0.000)
	&&( (round($_POST['CENABEZR']*1.00,2)==0.00)
	  ||(round($_POST['CENABEZR']*$_POST['ILOSC'],2)==$_POST['BRUTTO']*1)
	  )
	)
{
	$_SESSION['od_netto']=false;
	$od_netto=$_SESSION['od_netto'];
	$liczCene_i_Brutto=false;
	$_POST['CENA']=round($_POST['BRUTTO']/$_POST['ILOSC'],2);
	$_POST['CENABEZR']=round(($_POST['CENA']*100/(100-1*$_POST['RABAT'])),2);
}
else
{
	$_POST['CENA']  =str_replace(',','.',$_POST['CENA']);
}

if($liczCene_i_Brutto)
{
	$_POST['CENABEZR']  =round(1*str_replace(',','.',$_POST['CENABEZR']),2);
	$_POST['CENA']  =round(($_POST['CENABEZR']-0.01*$_POST['RABAT']*$_POST['CENABEZR']),2);
}

$_POST['NETTO'] =str_replace(',','.',$_POST['NETTO']);
$_POST['VAT']   =str_replace(',','.',$_POST['VAT']);

if($od_netto)
{
	//od cen netto
	$_POST['NETTO']=round($_POST['ILOSC']*$_POST['CENA'],2);
	$_POST['VAT']=round($_POST['NETTO']*$_POST['STAWKA']*0.01,2);
	$_POST['BRUTTO']=($_POST['NETTO']+$_POST['VAT']);
}
else
{
	//od cen brutto
	if($liczCene_i_Brutto)
	{
		$_POST['BRUTTO']=round($_POST['ILOSC']*$_POST['CENA'],2);
	}
	$_POST['NETTO']=round(($_POST['BRUTTO']*100)/(100+($_POST['STAWKA']*1)),2);
	$_POST['VAT']=($_POST['BRUTTO']-$_POST['NETTO']);
}

$_POST['OG_WA_PRZ']=$_POST['BRUTTO'];

$noHeader=true;
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveFormFields.php");
require("../przelicz.php");

/*
//usuniecie dotychczasowych zapisów
mysqli_query($link,$q="
	delete
	  from dokumentr
	 where ID_D='$idd'
	   and if(1*'$idd'=-1,KTO='$ido',1)
"); 
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

$dokument['TYP']=$_POST['TYP'];
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
	$vat=round($brutto*$stawka/(100+$stawka*1),2);
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
}*/