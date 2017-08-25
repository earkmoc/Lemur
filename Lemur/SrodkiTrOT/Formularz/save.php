<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
$idd=$_SESSION["{$baza}SrodkiTrID_D"];
if ($idd)
{
	$_POST['ID_D']=$idd;
}

$_POST['KTO']=$_SESSION['osoba_id'];
$_POST['CZAS']=date('Y-m-d H:i:s');

$_POST['WARTOSCNLW']=1*str_replace(',','.',$_POST['WARTOSCNLW']);
$_POST['KOSZTYW1']=1*str_replace(',','.',$_POST['KOSZTYW1']);
$_POST['KOSZTYW2']=1*str_replace(',','.',$_POST['KOSZTYW2']);
$_POST['KOSZTYRAZE']=$_POST['WARTOSCNLW']+$_POST['KOSZTYW1']+$_POST['KOSZTYW2'];

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveFormFields.php");

if ($idd)
{
	$nrKST=mysqli_fetch_row(mysqli_query($link, $q="select PKSUK from srodkiot where ID_D=$idd"))[0];
	mysqli_query($link, $q="update srodkitr set SYMBOLGR='$nrKST' where ID=$idd");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
}
