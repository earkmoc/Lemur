<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

// ----------------------------------------------
// Parametry widoku

//@$baza=($innaBaza?$innaBaza:$bazaLinku=explode('/',$_SERVER['REQUEST_URI'])[1]);

$title='Tabele';
$tabela='tabele';
$widok=$tabela.'z';
$mandatory='';
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$params="idTabeli=$idTabeli&row='+row+'&col='+col+'&str='+str+'&id=";
$formularz="../Formularz/?$params'+GetID()+'";

$buttons=array();
//$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>'../../');
$buttons[]=array('klawisz'=>'Enter','nazwa'=>'','akcja'=>$formularz);
$buttons[]=array('klawisz'=>'F','nazwa'=>'Enter=Formularz','akcja'=>$formularz);
$buttons[]=array('klawisz'=>'D','nazwa'=>'Dopisz','akcja'=>"../Formularz/?{$params}0'+'");
$buttons[]=array('klawisz'=>'C','nazwa'=>'Copy','akcja'=>"../Formularz/?$params-'+GetID()+'");
$buttons[]=array('klawisz'=>'S','nazwa'=>'Szukaj','js'=>"$('#modalSzukaj').modal('show')");
$buttons[]=array('klawisz'=>'U','nazwa'=>'Usuñ','akcja'=>"usun.php?$params'+GetID()+'");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
