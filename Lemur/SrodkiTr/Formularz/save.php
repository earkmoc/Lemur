<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$_POST['KTO']=$_SESSION['osoba_id'];
$_POST['CZAS']=date('Y-m-d H:i:s');

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveFormFields.php");

$idd=$_SESSION["{$baza}SrodkiTrID_D"];
if ($idd==0)
{
	$idd=mysqli_insert_id($link);
	$_SESSION["{$baza}SrodkiTrID_D"]=$idd;
	mysqli_query($link, $q="update srodkiot set ID_D='$idd' where ID_D=-1 and KTO='$ido'");if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
	mysqli_query($link, $q="update srodkihi set ID_D='$idd' where ID_D=-1 and KTO='$ido'");if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
	mysqli_query($link, $q="update srodkizm set ID_D='$idd' where ID_D=-1 and KTO='$ido'");if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
}

if ($idd)
{
	$rok=mysqli_fetch_row(mysqli_query($link,$q="
				  select OPIS 
					from slownik
				   where TYP='parametry'
					 and SYMBOL='SrodkiTr'
					 and TRESC='rok'
	"))[0];
	if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}

	require_once("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/SrodkiTrOblicz.php");
	Oblicz($link, $idd, $rok);
/*
for($mc=1;$mc<=12;++$mc)
{
	if($waam=mysqli_fetch_row(mysqli_query($link, $q="select sum(WAAM) from srodkihi where ID_D=$idd and Year(DATA)=Year(CurDate()) and Month(DATA)=$mc"))[0])
	{
		mysqli_query($link, $q="update srodkitr set WMUA$mc=$waam where ID=$idd");
		if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
	}
}
*/
}
