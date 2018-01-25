<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$_POST['KTO']=$_SESSION['osoba_id'];
$_POST['CZAS']=date('Y-m-d H:i:s');

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveFormFields.php");

$idd=$_SESSION["{$baza}SchematyID_D"];

if ($idd==0)
{
	$idd=mysqli_insert_id($link);
	$_SESSION["{$baza}SchematyID_D"]=$idd;
	mysqli_query($link, $q="update schematys set ID_D='$idd' where ID_D=-1 and KTO='$ido'");if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
}
