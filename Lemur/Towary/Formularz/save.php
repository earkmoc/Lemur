<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
$od_netto=$_SESSION['od_netto'];

if ($idd=$_SESSION["{$baza}DokumentyID_D"])
{
	$_POST['ID_D']=$idd;
}
$_POST['KTO']=$_SESSION['osoba_id'];
$_POST['CZAS']=date('Y-m-d H:i:s');

$_POST['CENABEZR']  =str_replace(',','.',$_POST['CENABEZR']);
$_POST['RABAT']  =str_replace(',','.',$_POST['RABAT']);

$_POST['RABAT'] =(1*$_POST['RABAT']?$_POST['RABAT']:0);
$_POST['CENA']  =($_POST['CENABEZR']-0.01*$_POST['RABAT']*$_POST['CENABEZR']);
$_POST['STAWKA']=(!$_POST['STAWKA']?'23%':$_POST['STAWKA']);

$_POST['ILOSC'] =str_replace(',','.',$_POST['ILOSC']);
$_POST['CENA']  =str_replace(',','.',$_POST['CENA']);
$_POST['NETTO'] =str_replace(',','.',$_POST['NETTO']);
$_POST['VAT']   =str_replace(',','.',$_POST['VAT']);
$_POST['BRUTTO']=str_replace(',','.',$_POST['BRUTTO']);

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
	$_POST['BRUTTO']=round($_POST['ILOSC']*$_POST['CENA'],2);
	$_POST['NETTO']=round(($_POST['BRUTTO']*100)/(100+($_POST['STAWKA']*1)),2);
	$_POST['VAT']=($_POST['BRUTTO']-$_POST['NETTO']);
}

$_POST['OG_WA_PRZ']=$_POST['BRUTTO'];

$noHeader=true;
$nowaPozycja=($_GET['id']==0);
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveFormFields.php");
require("../przelicz.php");

if($nowaPozycja)
{
	require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/SetStrRow.php");
	SetStrRow($link, $id, 5);
}
