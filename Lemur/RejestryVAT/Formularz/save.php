<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

if ($idd=@$_SESSION["{$baza}DokumentyID_D"])
{
	$_POST['ID_D']=$idd;
}
$_POST['KTO']=$_SESSION['osoba_id'];
$_POST['CZAS']=date('Y-m-d H:i:s');

$_POST['TYP']=explode('-',$_POST['TYP'])[0];

$_POST['NETTO'] =str_replace(',','.',$_POST['NETTO']);
$_POST['VAT']   =str_replace(',','.',$_POST['VAT']);
$_POST['BRUTTO']=str_replace(',','.',$_POST['BRUTTO']);

if (1*$_POST['NETTO'])
//od netto
{
	$_POST['VAT']=round(1*$_POST['VAT']?$_POST['VAT']:($_POST['VAT']=='z'?0:$_POST['NETTO']*$_POST['STAWKA']*0.01),2);
	$_POST['BRUTTO']=(1*$_POST['BRUTTO']?$_POST['BRUTTO']:($_POST['BRUTTO']=='z'?0:$_POST['NETTO']+$_POST['VAT']));
}
elseif(1*$_POST['STAWKA'])
//od brutto ze stawką VAT
{
	$_POST['NETTO']=(1*$_POST['NETTO']?$_POST['NETTO']:($_POST['NETTO']=='z'?0:($_POST['BRUTTO']*100)/(100+$_POST['STAWKA'])));
	$_POST['VAT']=round(1*$_POST['VAT']?$_POST['VAT']:($_POST['VAT']=='z'?0:$_POST['BRUTTO']-$_POST['NETTO']),2);
}
else
{
	$_POST['VAT']=round(1*$_POST['VAT']?$_POST['VAT']:0,2);
	$_POST['NETTO']=(1*$_POST['NETTO']?$_POST['NETTO']:($_POST['NETTO']=='z'?0:$_POST['BRUTTO']-$_POST['VAT']));
}

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveFormFields.php");

if ($idd)
{
	$brutto=mysqli_fetch_row(mysqli_query($link, $q="select sum(BRUTTO) from dokumentr where ID_D=$idd"))[0];
	$netto =mysqli_fetch_row(mysqli_query($link, $q="select sum(NETTO) from dokumentr where ID_D=$idd"))[0];
	$vat   =mysqli_fetch_row(mysqli_query($link, $q="select sum(VAT) from dokumentr where ID_D=$idd"))[0];
	mysqli_query($link, $q="update dokumenty set WARTOSC='$brutto', NETTOVAT='$netto', PODATEK_VAT=if((PODATEK_VAT<>0)and('$vat'*1<>0),PODATEK_VAT,'$vat') where ID=$idd");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
}
