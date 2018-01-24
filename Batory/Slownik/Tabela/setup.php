<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

// ----------------------------------------------
// Parametry widoku

$title='S³ownik';
$tabela='slownik';
$widok=$tabela;
$mandatory='';
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

//----------------------------------------------

$params="idTabeli=$idTabeli&row='+row+'&col='+col+'&str='+str+'&id=";
$esc="saveTablePosition.php?next=http://{$_SERVER['HTTP_HOST']}/$baza/Menu/&$params'+GetID()+'";
//$enter="saveTablePosition.php?next=http://{$_SERVER['HTTP_HOST']}/$baza/RejestryVAT/Tabela/?rejestr='+GetCol(2)+','+GetCol(4)+','+GetCol(3)+'&$params'+GetID()+'";
$formularz="../Formularz/?$params'+GetID()+'";
$dopisz="../Formularz/?{$params}0'+'";
$kopia="../Formularz/?$params-'+GetID()+'";
$usun="usun.php?$params'+GetID()+'";

$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>$esc);
$buttons[]=array('klawisz'=>'Enter','nazwa'=>'','akcja'=>$formularz);
$buttons[]=array('klawisz'=>'F','nazwa'=>'Formularz','akcja'=>$formularz);
$buttons[]=array('klawisz'=>'D','nazwa'=>'Dopisz','akcja'=>$dopisz);
$buttons[]=array('klawisz'=>'C','nazwa'=>'Copy','akcja'=>$kopia);
$buttons[]=array('klawisz'=>'U','nazwa'=>'Usuñ','akcja'=>$usun);
$buttons[]=array('klawisz'=>'S','nazwa'=>'Szukaj','js'=>"$('#modalSzukaj').modal('show')");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
