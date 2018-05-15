<?php

//die(print_r($_POST));
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

mysqli_query($link, "ALTER TABLE `slownik` CHANGE `OPIS` `OPIS` text NOT NULL DEFAULT ''");
mysqli_query($link, "ALTER TABLE `slownik` ADD UNIQUE `TST` (`TYP`, `SYMBOL`, `TRESC`)");

$_POST['zawijanie']=(@$_POST['zawijanie']?$_POST['zawijanie']:'');
$_POST['lamanie']=(@$_POST['lamanie']?$_POST['lamanie']:'');
$_POST['borderNag']=(@$_POST['borderNag']?$_POST['borderNag']:'');
$_POST['borderPol']=(@$_POST['borderPol']?$_POST['borderPol']:'');
$_POST['osobneStrony']=(@$_POST['osobneStrony']?$_POST['osobneStrony']:'');
$_POST['tylkoSumy']=(@$_POST['tylkoSumy']?$_POST['tylkoSumy']:'');

mysqli_query($link,$q="
				  update slownik
					 set OPIS='$_POST[data]'
				   where TRESC='data'
					 and TYP='parametry'
");

foreach($_POST as $key => $value)
{
	$value=AddSlashes($value);
	$sets="TYP='parametry'
	   , SYMBOL='wydrukepo'
	   , TRESC='$key'
	   , OPIS='$value'
	";
	mysqli_query($link,$q="
					  insert 
						into slownik
						 set $sets
	 on duplicate key update $sets
	");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}
}

//wydruk=Raporta&natab=kpr&strona1=15&stronan=16
$_GET['strona1']=(@$_POST['strona1']?$_POST['strona1']:$_GET['strona1']);
$_GET['stronan']=(@$_POST['stronaN']?$_POST['stronaN']:$_GET['stronan']);

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/Wydruk.php");
