<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$_SESSION['od_netto']=true;

// ----------------------------------------------
// Parametry widoku

$tabela='slownik';
$widok=$tabela;
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$tabela='schematy';
$widok=$tabela;
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$tabela='dokumentr';
$widok=$tabela;
mysqli_query($link,$q="create index ID_D on $tabela(ID_D)");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$tabela='dokumentm';
$widok=$tabela;
mysqli_query($link,$q="create index ID_D on $tabela(ID_D)");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$tabela='dokumentk';
$widok=$tabela;
mysqli_query($link,$q="create index ID_D on $tabela(ID_D)");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$tabela='kpr';
$widok=$tabela;
mysqli_query($link,$q="create index ID_D on $tabela(ID_D)");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$tabela='ewidsprz';
$widok=$tabela;
mysqli_query($link,$q="create index ID_D on $tabela(ID_D)");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$tabela='ewidprzeb';
$widok=$tabela;
mysqli_query($link,$q="create index ID_D on $tabela(ID_D)");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$tabela='osoby';
$widok=$tabela;
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$title='Dokumenty';
$tabela='dokumenty';
$widok=$tabela;
$mandatory='';
$sortowanie="$tabela.DOPERACJI, $tabela.ID";
$sortowanieDoLiczenia="$tabela.DOPERACJI desc, $tabela.ID desc";

mysqli_query($link, "ALTER TABLE $tabela CHANGE `SPOSZAPL` `SPOSZAPL` char(30) NOT NULL DEFAULT 'przelew'");
mysqli_query($link, "ALTER TABLE $tabela CHANGE `PRZEDMIOT` `PRZEDMIOT` char(99) NOT NULL DEFAULT ''");
  
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$params="idTabeli=$idTabeli&row='+row+'&col='+col+'&str='+str+'&id=";
$formularz="../Formularz/?$params'+GetID()+'";

$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>"saveTablePosition.php?next=http://{$_SERVER['HTTP_HOST']}/$baza/Menu/&$params'+GetID()+'");
$buttons[]=array('klawisz'=>'Enter','nazwa'=>'','akcja'=>$formularz);
$buttons[]=array('klawisz'=>'AltF','nazwa'=>'Enter=Formularz','akcja'=>$formularz);
$buttons[]=array('klawisz'=>'AltD','nazwa'=>'Dopisz','akcja'=>"../Formularz/?{$params}0'+'");
$buttons[]=array('klawisz'=>'AltC','nazwa'=>'Copy','akcja'=>"../Formularz/?$params-'+GetID()+'");
$buttons[]=array('klawisz'=>'AltS','nazwa'=>'Szukaj','js'=>"$('#modalSzukaj').modal('show')");
//$buttons[]=array('klawisz'=>'AltU','nazwa'=>'Usuñ','akcja'=>"usun.php?$params'+GetID()+'");
$buttons[]=array('klawisz'=>'AltU','nazwa'=>'Usuñ','js'=>"buttonsShow();return confirm('Czy na pewno chcesz usun±æ t± pozycjê?')",'akcja'=>"usun.php?$params'+GetID()+'");
$buttons[]=array('klawisz'=>'AltI','nazwa'=>'Import XML','akcja'=>"/$baza/ImportXML/");
//$buttons[]=array('klawisz'=>'AltR','nazwa'=>'Renumeruj','akcja'=>"renumeracja.php?$params'+GetID()+'");
$buttons[]=array('klawisz'=>'AltT','nazwa'=>'Test','akcja'=>"test.php?$params'+GetID()+'");
$buttons[]=array('klawisz'=>'AltM','nazwa'=>'Masowo dekretuj','akcja'=>"dekretowanie.php?$params'+GetID()+'");
$buttons[]=array('klawisz'=>'AltZ','nazwa'=>'Zamykaj','akcja'=>"zamykanie.php?$params'+GetID()+'");
//$buttons[]=array('klawisz'=>'AltW','nazwa'=>'Wydruk','akcja'=>"Wydruk.php?$params'+GetID()+'");
$buttons[]=array('klawisz'=>'AltW','nazwa'=>'Wydruk','akcja'=>"WydrukFakturyParametry.php?$params'+GetID()+'");
$buttons[]=array('klawisz'=>'AltO','nazwa'=>'','akcja'=>"otworz.php?$params'+GetID()+'");
//$buttons[]=array('klawisz'=>'AltX','nazwa'=>'','akcja'=>"generowanie.php?$params'+GetID()+'");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
