<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

// ----------------------------------------------
// Parametry widoku

$title='Bilans PASYWA';
$tabela='bilansp';
$widok=$tabela;
$mandatory="1";
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

//----------------------------------------------

$params="idTabeli=$idTabeli&row='+row+'&col='+col+'&str='+str+'&id=";

$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>"saveTablePosition.php?next=http://{$_SERVER['HTTP_HOST']}/$baza/Menu/&$params'+GetID()+'");
$buttons[]=array('klawisz'=>'Enter','nazwa'=>'','akcja'=>$formularz="../Formularz/?$params'+GetID()+'");
$buttons[]=array('klawisz'=>'AltF','nazwa'=>'Formularz','akcja'=>$formularz);
$buttons[]=array('klawisz'=>'AltD','nazwa'=>'Dopisz','akcja'=>"../Formularz/?{$params}0'+'");
$buttons[]=array('klawisz'=>'AltC','nazwa'=>'Copy','akcja'=>"../Formularz/?$params-'+GetID()+'");
$buttons[]=array('klawisz'=>'AltU','nazwa'=>'Usuñ','akcja'=>"usun.php?$params'+GetID()+'");
$buttons[]=array('klawisz'=>'AltS','nazwa'=>'Szukaj','js'=>"$('#modalSzukaj').modal('show')");
$buttons[]=array('klawisz'=>'AltP','nazwa'=>'Przetwórz','akcja'=>"przetwarzanie.php?$params'+GetID()+'");
$buttons[]=array('klawisz'=>'AltW','nazwa'=>'Wydruk','akcja'=>"Wydruk.php?wydruk=Raporta&natab=$widok&strona1=15&stronan=16&tytul=$title");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
