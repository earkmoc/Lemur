<?php

require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

//mysqli_query($link, $q="update $tabela set GDZIE='ksiêgi', KTO='$ido', CZAS=Now() where ID=$id");

$r=mysqli_fetch_array(mysqli_query($link, $q="
select *
  from $tabela
 where ID=$id
"));
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

$_GET['wzor']=($_GET['wzor']?$_GET['wzor']:$r['TYP']);

if($r['GDZIE']=='bufor')	//otwarty
{
	$noHeader=true;
	require("otworz.php");	//zamknij
}

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/WydrukWzor.php");
