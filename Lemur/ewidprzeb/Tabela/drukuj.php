<?php

//die('POST:'.print_r($_POST,1)."<br>GET:".print_r($_GET,1));
$mandatory="ewidprzeb.REJESTRACJA='{$_GET['rejestracja']}'";
$mandatory.=(@$_GET['okres']?" and ewidprzeb.DATAW like '%{$_GET['okres']}%'":'');

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

mysqli_query($link, "ALTER TABLE `slownik` CHANGE `OPIS` `OPIS` text NOT NULL DEFAULT ''");
mysqli_query($link, "ALTER TABLE `slownik` ADD UNIQUE `TST` (`TYP`, `SYMBOL`, `TRESC`)");

$_POST['zawijanie']=(@$_POST['zawijanie']?$_POST['zawijanie']:'');
$_POST['borderNag']=(@$_POST['borderNag']?$_POST['borderNag']:'');
$_POST['borderPol']=(@$_POST['borderPol']?$_POST['borderPol']:'');
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
	   , SYMBOL='ewidprzeb'
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

$_POST['tytul']="<h1 style='margin:0 0 0 0; width:100%; text-align:center'>{$_POST['tytul']}</h1>";
$_POST['tytul'].=($_POST['okres']?"<br><h2 style='margin:0 0 0 0; width:100%; text-align:center'>za okres {$_POST['okres']}</h2>":'');
$_POST['tytul'].="<br>Numer rejestracyjny: {$_POST['rejestracja']}";
$_POST['tytul'].="<br>Pojemno¶æ silnika: {$_POST['pojemnosc']} cm3";
$_POST['tytul'].="<br>Kierowca: ".nl2br($_POST['opis']);

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/Wydruk.php");
