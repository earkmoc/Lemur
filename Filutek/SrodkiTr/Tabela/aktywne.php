<?php

require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

$idTabeles=($idTabeles?$idTabeles:0);

mysqli_query($link,$q="
	update tabeles
	   set WARUNKI=if(WARUNKI='','(UMWUR<>0)','')
	 where ID=$idTabeles
");
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

$dane=mysqli_fetch_row(mysqli_query($link,$q="
	select *
	  from tabeles
	 where ID=$idTabeles
"));
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

$dane[0]=0;
$warunki=$dane[7];

$idTabel=mysqli_fetch_row(mysqli_query($link,$q="
	select group_concat(ID)
	  from Lemur2.tabele
	 where NAZWA like '$tabela%'
"))[0];
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

foreach(explode(',',$idTabel) as $key => $value)
{
	$dane[2]=$value;
	$wartosci=implode("','",$dane);
	mysqli_query($link,$q="
		insert
		  into tabeles
		values ('$wartosci')
		on duplicate key update ID=ID
	");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
}

mysqli_query($link,$q="
	update tabeles
	   set WARUNKI='$warunki'
	 where ID_TABELE IN ($idTabel)
	   and ID_OSOBY=$ido
");
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

header("location:index.php");
