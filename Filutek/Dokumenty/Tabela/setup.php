<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

if(@$_GET['typ'])
{
	$typ=($_GET['typ']=='_'?'':$_GET['typ']);
	$_SESSION['typ']=$typ;
}
else
{
	$typ=$_SESSION['typ'];
}

$_SESSION['od_netto']=false;
if(in_array($typ,array('FZ','FZK','PZ','PZK','WZ','WZK','MM','PW','RW','INW')))
{
	$_SESSION['od_netto']=true;
}

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

$title='Dokumenty'.($typ?" typu \"{$typ}\"":'');
$tabela='dokumenty';
$widok=$tabela;
$mandatory=($typ?"TYP='{$typ}'":'');
$sortowanieDoLiczenia='DOPERACJI desc, ID desc';

mysqli_query($link, "ALTER TABLE $tabela CHANGE `SPOSZAPL` `SPOSZAPL` char(30) NOT NULL DEFAULT 'przelew'");
mysqli_query($link, "ALTER TABLE $tabela CHANGE `PRZEDMIOT` `PRZEDMIOT` char(99) NOT NULL DEFAULT ''");
  
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$params="idTabeli=$idTabeli&row='+row+'&col='+col+'&str='+str+'&id=";
$formularz="../Formularz/?$params'+GetID()+'";

$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>"saveTablePosition.php?next=http://{$_SERVER['HTTP_HOST']}/$baza/Menu/&$params'+GetID()+'");
$buttons[]=array('klawisz'=>'Enter','nazwa'=>'','akcja'=>$formularz);
$buttons[]=array('klawisz'=>'F','nazwa'=>'Enter=Formularz','akcja'=>$formularz);
$buttons[]=array('klawisz'=>'D','nazwa'=>'Dopisz','akcja'=>"../Formularz/?{$params}0'+'");
$buttons[]=array('klawisz'=>'S','nazwa'=>'Szukaj','js'=>"$('#modalSzukaj').modal('show')");
$buttons[]=array('klawisz'=>'U','nazwa'=>'Usuñ','js'=>"buttonsShow();return confirm('Czy na pewno chcesz usun±æ t± pozycjê?')",'akcja'=>"usun.php?$params'+GetID()+'");
$buttons[]=array('klawisz'=>'W','nazwa'=>'Wydruk','akcja'=>"Wydruk.php?$params'+GetID()+'");
$buttons[]=array('klawisz'=>'K','nazwa'=>'KP','akcja'=>"Wydruk.php?wzor=KP&$params'+GetID()+'");
$buttons[]=array('klawisz'=>'O','nazwa'=>'','akcja'=>"otworz.php?$params'+GetID()+'");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
