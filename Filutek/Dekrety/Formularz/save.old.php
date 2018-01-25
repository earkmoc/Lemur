<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

if ($idd=$_SESSION["{$baza}DokumentyID_D"])
{
	$_POST['ID_D']=$idd;
}

$_POST['KTO']=$_SESSION['osoba_id'];

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveFormFields.php");
