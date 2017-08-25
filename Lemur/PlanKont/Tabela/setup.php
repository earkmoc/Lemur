<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

// ----------------------------------------------
// Parametry widoku

$title='Plan kont';
$tabela='knordpol';
$widok=$tabela.'1';
$mandatory='';
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

//----------------------------------------------

$params="idTabeli=$idTabeli&idTabeles=$idTabeles&row='+row+'&col='+col+'&str='+str+'&id=";

$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>"saveTablePosition.php?next=http://{$_SERVER['HTTP_HOST']}/$baza/Menu/&$params'+GetID()+'");
$buttons[]=array('klawisz'=>'Enter','nazwa'=>'','akcja'=>$formularz="../Formularz/?$params'+GetID()+'");
$buttons[]=array('klawisz'=>'AltF','nazwa'=>'Formularz=Enter','akcja'=>$formularz);
$buttons[]=array('klawisz'=>'AltD','nazwa'=>'Dopisz','akcja'=>"../Formularz/?{$params}0'+'");
$buttons[]=array('klawisz'=>'AltC','nazwa'=>'Copy','akcja'=>"../Formularz/?$params-'+GetID()+'");
$buttons[]=array('klawisz'=>'AltU','nazwa'=>'Usuñ','akcja'=>"usun.php?$params'+GetID()+'");
$buttons[]=array('klawisz'=>'AltS','nazwa'=>'Szukaj','js'=>"$('#modalSzukaj').modal('show')");
$buttons[]=array('klawisz'=>'AltW','nazwa'=>'Wydruk','akcja'=>"Wydruk.php?wydruk=Raporta&natab=$widok&strona1=15&stronan=16&tytul=$title");
$buttons[]=array('klawisz'=>'AltA','nazwa'=>'Analityka','akcja'=>"analityka.php?$params'+GetID()+'&konto='+GetCol(2)+'");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
