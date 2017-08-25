<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

// ----------------------------------------------
// Parametry widoku

$title='Dziennik g³ówny';
$tabela='nordpol';
$widok=$tabela;
$mandatory='';
mysqli_query($link, "ALTER TABLE `$tabela` CHANGE `KWOTA` `KWOTA` DECIMAL(15,2) NOT NULL DEFAULT '0.00'");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

//----------------------------------------------

$params="idTabeli=$idTabeli&idTabeles=$idTabeles&row='+row+'&col='+col+'&str='+str+'&id=";

$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>"saveTablePosition.php?next=http://{$_SERVER['HTTP_HOST']}/$baza/Menu/&$params'+GetID()+'");
$buttons[]=array('klawisz'=>'Enter','nazwa'=>'','akcja'=>$formularz="../Formularz/?$params'+GetID()+'");
$buttons[]=array('klawisz'=>'AltF','nazwa'=>'Formularz','akcja'=>$formularz);
$buttons[]=array('klawisz'=>'AltD','nazwa'=>'Dopisz','akcja'=>"../Formularz/?{$params}0'+'");
$buttons[]=array('klawisz'=>'AltC','nazwa'=>'Copy','akcja'=>"../Formularz/?$params-'+GetID()+'");
//$buttons[]=array('klawisz'=>'AltU','nazwa'=>'Usuñ','akcja'=>"usun.php?$params'+GetID()+'");
$buttons[]=array('klawisz'=>'AltU','nazwa'=>'Usuñ','js'=>"buttonsShow();return confirm('Czy na pewno chcesz usun±æ t± pozycjê?')",'akcja'=>"usun.php?$params'+GetID()+'");
$buttons[]=array('klawisz'=>'AltS','nazwa'=>'Szukaj','js'=>"$('#modalSzukaj').modal('show')");
$buttons[]=array('klawisz'=>'AltT','nazwa'=>'Test','akcja'=>"test.php?$params'+GetID()+'");
$buttons[]=array('klawisz'=>'AltG','nazwa'=>'GoTo','akcja'=>"gotoGet.php?$params'+GetID()+'");
$buttons[]=array('klawisz'=>'AltI','nazwa'=>'Import BO','akcja'=>"importBO.php?$params'+GetID()+'");
$buttons[]=array('klawisz'=>'AltP','nazwa'=>'PK','akcja'=>"pk.php?$params'+GetID()+'&wzor=PK");
$buttons[]=array('klawisz'=>'AltO','nazwa'=>'PK-O','akcja'=>"pk.php?$params'+GetID()+'&wzor=PKO");
$buttons[]=array('klawisz'=>'AltW','nazwa'=>'Wydruk','akcja'=>"Wydruk.php?wydruk=Raporta&natab=$widok&strona1=15&stronan=16&tytul=$title");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
