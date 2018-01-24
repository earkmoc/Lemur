<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

if ($idd=$_SESSION["{$baza}SchematyID_D"])
{
	$_POST['ID_D']=$idd;
}
$_POST['KTO']=$_SESSION['osoba_id'];
$_POST['CZAS']=date('Y-m-d H:i:s');

if (1*$_POST['NETTO'])
//od netto
{
	$_POST['VAT']=round(1*$_POST['VAT']?$_POST['VAT']:$_POST['NETTO']*$_POST['STAWKA']*0.01,2);
	$_POST['BRUTTO']=(1*$_POST['BRUTTO']?$_POST['BRUTTO']:$_POST['NETTO']+$_POST['VAT']);
}
elseif(1*$_POST['STAWKA'])
//od brutto ze stawką VAT
{
	$_POST['NETTO']=(1*$_POST['NETTO']?$_POST['NETTO']:($_POST['BRUTTO']*100)/(100+$_POST['STAWKA']));
	$_POST['VAT']=round(1*$_POST['VAT']?$_POST['VAT']:$_POST['BRUTTO']-$_POST['NETTO'],2);
}
else
{
	$_POST['VAT']=round(1*$_POST['VAT']?$_POST['VAT']:0,2);
	$_POST['NETTO']=(1*$_POST['NETTO']?$_POST['NETTO']:$_POST['BRUTTO']-$_POST['VAT']);
}
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveFormFields.php");
