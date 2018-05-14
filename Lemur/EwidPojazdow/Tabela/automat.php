<?php

require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

if($_SESSION["{$baza}PojazdID_D"]==$id)	//odwiązanie
{
	$id=-1;
}

$_SESSION["{$baza}PojazdID_D"]=$id;		//powiązanie
if($id_d>0)
{
	mysqli_query($link, "
	update dokumenty 
	   set ID_S=$id
	 where ID=$id_d
	 limit 1
	");
}
if (mysqli_error($link)) {
	die(mysqli_error($link));
} else {
	header("location:../Tabela");
}
