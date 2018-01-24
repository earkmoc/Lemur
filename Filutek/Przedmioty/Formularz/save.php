<?php

$_POST['TYP']='przedmioty';
if(!$_GET['id'])
{
	$tableInit='ID desc';
	require("setup.php");
}
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveFormFields.php");
