<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

// ----------------------------------------------
// Parametry widoku

$tabela='zest2r';
$widok=$tabela;
mysqli_query($link, "ALTER TABLE `$tabela` ADD SALDO decimal(15,2) not null default 0");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$tabela='zest2rr';
$widok=$tabela;
mysqli_query($link, "ALTER TABLE `$tabela` ADD SALDO decimal(15,2) not null default 0");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$title='Analityka Obrotów Konta '.($_GET['maska']?$_GET['maska'].' za okres '.$_GET['data1'].' - '.$_GET['data2']:'');
$tabela='zest2';
$widok=$tabela;
$mandatory="ID_OSOBYUPR=$ido";
mysqli_query($link, "ALTER TABLE `$tabela` ADD SALDO decimal(15,2) not null default 0");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

//----------------------------------------------

$params="idTabeli=$idTabeli&row='+row+'&col='+col+'&str='+str+'&id=";
$esc="saveTablePosition.php?next=http://{$_SERVER['HTTP_HOST']}/$baza/".($_GET['maska']?(($_GET['data2']=='2999-12-31')?'PlanKont':'ZOS'):'Menu')."/&$params'+GetID()+'";

$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>$esc);
$buttons[]=array('klawisz'=>'AltS','nazwa'=>'Szukaj','js'=>"$('#modalSzukaj').modal('show')");
$buttons[]=array('klawisz'=>'AltP','nazwa'=>'Przetwórz','akcja'=>"przetwarzanie.php?$params'+GetID()+'");
$buttons[]=array('klawisz'=>'AltW','nazwa'=>'Wydruk','akcja'=>"Wydruk.php?wydruk=Raporta&natab=$tabela&strona1=15&stronan=16&tytul=$title");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
