<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

// ----------------------------------------------
// Parametry widoku

$title='Typy dokumentów';
$widok='doktypy';
$tabela=$widok;
$mandatory='';
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

//----------------------------------------------

$params="firma=$firma&idTabeli=$idTabeli&row='+row+'&col='+col+'&str='+str+'&id=";
$esc="saveTablePosition.php?next=http://{$_SERVER['HTTP_HOST']}/$baza/Menu/?$params'+GetID()+'";
$formularz="../Formularz/?$params'+GetID()+'";

$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>$esc);
$buttons[]=array('klawisz'=>'Enter','nazwa'=>'','akcja'=>"../Formularz/?{$params}0'+'");
$buttons[]=array('klawisz'=>'F','nazwa'=>'Formularz','akcja'=>$formularz);
$buttons[]=array('klawisz'=>'D','nazwa'=>'Enter=Dopisz','akcja'=>"../Formularz/?{$params}0'+'");
$buttons[]=array('klawisz'=>'C','nazwa'=>'Copy','akcja'=>"../Formularz/?$params-'+GetID()+'");
$buttons[]=array('klawisz'=>'U','nazwa'=>'Usuñ','js'=>"buttonsShow();return confirm('Czy na pewno chcesz usun±æ t± pozycjê?')",'akcja'=>"usun.php?$params'+GetID()+'");
$buttons[]=array('klawisz'=>'S','nazwa'=>'Szukaj','js'=>"$('#modalSzukaj').modal('show')");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
