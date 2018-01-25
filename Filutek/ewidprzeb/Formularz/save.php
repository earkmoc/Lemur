<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$idd=@$_SESSION["{$baza}DokumentyID_D"];
if ($idd>0)
{
	$_POST['ID_D']=$idd;
	$dokument=mysqli_fetch_array(mysqli_query($link, "select * from dokumenty where ID=$idd"));
//	$_POST['LPDZ']=$dokument['LP'];
//	$_POST['DATADZ']=$dokument['DDOKUMENTU'];
//	$_POST['NRDZ']=$dokument['NUMER'];
}
if ($idd<0)
{
	$_POST['ID_D']=0;
}

$_POST['KM'] =str_replace(',','.',$_POST['KM']);
$_POST['STAWKA'] =str_replace(',','.',$_POST['STAWKA']);
$_POST['WARTOSCDZ'] =str_replace(',','.',$_POST['WARTOSCDZ']);
$_POST['WARTOSC']=$_POST['KM']*$_POST['STAWKA'];

$_POST['LPDZ']=(@$_POST['LPDZ']?$_POST['LPDZ']:'');
$_POST['NRDZ']=(@$_POST['NRDZ']?$_POST['NRDZ']:'');
$_POST['DATADZ']=(@$_POST['DATADZ']?$_POST['DATADZ']:'');
$_POST['RODZAJ']=(@$_POST['RODZAJ']?$_POST['RODZAJ']:'');

$_POST['KTO']=$_SESSION['osoba_id'];
//die(print_r($_POST));
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveFormFields.php");
