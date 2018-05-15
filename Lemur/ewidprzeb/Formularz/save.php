<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

@$id_d=$_SESSION["{$baza}PojazdID_D"];
$_POST['ID_D']=($idd>0?$idd:0);

$_POST['KM'] =str_replace(',','.',$_POST['KM']);
$_POST['STAWKA'] =str_replace(',','.',$_POST['STAWKA']);
$_POST['WARTOSCDZ'] =str_replace(',','.',$_POST['WARTOSCDZ']);
$_POST['WARTOSC']=$_POST['KM']*$_POST['STAWKA'];

$_POST['REJESTRACJA']=$_GET['rejestracja'];
$_POST['KTO']=$_SESSION['osoba_id'];
//die(print_r($_POST));
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveFormFields.php");
