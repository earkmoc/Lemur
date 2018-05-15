<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

if ($_GET['id_d'])
{
	$_SESSION["{$baza}PojazdID_D"]=$_GET['id_d'];
}

@$id_d=$_SESSION["{$baza}PojazdID_D"];

// ----------------------------------------------
// Parametry widoku

$title="Dokumenty powi±zane z pojazdem";
$tabela='dokumenty';
$widok=$tabela;

$okres=mysqli_fetch_row(mysqli_query($link,$q="select OKRES from ewidpoja where ID=$id_d"))[0];
$warOkresu=($okres?" and ($tabela.DOPERACJI like '%$okres%')":'');
$mandatory="$tabela.ID_S=$id_d $warOkresu";
$mandatory=(!isset($id_d)?'':$mandatory);
$sortowanie="$tabela.DOPERACJI, $tabela.ID";
$sortowanieDoLiczenia="$tabela.DOPERACJI desc, $tabela.ID desc";

mysqli_query($link, "ALTER TABLE $tabela CHANGE `SPOSZAPL` `SPOSZAPL` char(30) NOT NULL DEFAULT 'przelew'");
mysqli_query($link, "ALTER TABLE $tabela CHANGE `PRZEDMIOT` `PRZEDMIOT` char(99) NOT NULL DEFAULT ''");
  
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','js'=>"parent.$('input[name=LP]').select().focus(); parent.scrollTo(0,0);");
$buttons[]=array('klawisz'=>'AltS','nazwa'=>'Szukaj','js'=>"$('#modalSzukaj').modal('show')");

require('../../EwidPojazdow/Formularz/zakladkiButtons.php');
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
