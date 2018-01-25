<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
$idd=$_SESSION["{$baza}SrodkiTrID_D"];
if ($idd)
{
	$_POST['ID_D']=$idd;
}

$_POST['KTO']=$_SESSION['osoba_id'];
$_POST['CZAS']=date('Y-m-d H:i:s');

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveFormFields.php");
