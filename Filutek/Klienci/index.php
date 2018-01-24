<?php
@session_start();
$ido=@$_SESSION['osoba_id'];
//header("location:".($ido==1?"Tabela":"/Lemur2/Moduly/Formularz"));
header("location:/Lemur2/Moduly/Formularz");

/*
if($innabaza=$_GET['baza'])
{
	require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
	mysqli_close($link);
}
*/