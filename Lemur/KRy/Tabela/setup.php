<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

// ----------------------------------------------
// Parametry widoku

$title=$baza.': Firmy na Ksiêgach Rachunkowych';
$tabela='kry';
$widok=$tabela;
$mandatory='';
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$params="idTabeli=$idTabeli&row='+row+'&col='+col+'&str='+str+'&id=";
$enter="saveTablePosition.php?next=http://{$_SERVER['HTTP_HOST']}/'+GetCol(2)+'/Menu/&$params'+GetID()+'";
$formularz="../Formularz/?$params'+GetID()+'";
$dopisz="../Formularz/?{$params}0'+'";
$usun="usun.php?$params'+GetID()+'";

$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>'../../');
//$buttons[]=array('klawisz'=>'Enter','nazwa'=>'Enter=wej¶cie','akcja'=>"saveTablePosition.php?next=http://{$_SERVER['HTTP_HOST']}/'+GetCol(2)+'/KPiR'+'");
$buttons[]=array('klawisz'=>'Enter','nazwa'=>'Enter=wej¶cie','akcja'=>$enter);
$buttons[]=array('klawisz'=>'AltF','nazwa'=>'Formularz','akcja'=>$formularz);
$buttons[]=array('klawisz'=>'AltD','nazwa'=>'Dopisz','akcja'=>$dopisz);
$buttons[]=array('klawisz'=>'AltS','nazwa'=>'Szukaj','js'=>"$('#modalSzukaj').modal('show')");
//$buttons[]=array('klawisz'=>'AltU','nazwa'=>'Usuñ','atrybuty'=>" type='button' data-toggle='modal' data-target='#myModal'");
$buttons[]=array('klawisz'=>'AltU','nazwa'=>'Usuñ','akcja'=>$usun);

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
