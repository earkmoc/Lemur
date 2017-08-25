<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

// ----------------------------------------------
// Parametry widoku

@$baza=($innaBaza?$innaBaza:$bazaLinku=explode('/',$_SERVER['REQUEST_URI'])[1]);

$title=$baza.': Tabele';
$tabela='tabele';
$widok=$tabela.'z';
$mandatory='';
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$params="idTabeli=$idTabeli&row='+row+'&col='+col+'&str='+str+'&id=";
$enter="saveTablePosition.php?next=http://{$_SERVER['HTTP_HOST']}/Lemur/'+GetCol(2)+'/&$params'+GetID()+'";
$formularz="../Formularz/?$params'+GetID()+'";
$dopisz="../Formularz/?{$params}0'+'";
$kopia="../Formularz/?$params-'+GetID()+'";
$usun="usun.php?$params'+GetID()+'";

$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>'../../');
//$buttons[]=array('klawisz'=>'Enter','nazwa'=>'Enter=wej¶cie','akcja'=>"saveTablePosition.php?next=http://{$_SERVER['HTTP_HOST']}/'+GetCol(2)+'/KPiR'+'");
$buttons[]=array('klawisz'=>'Enter','nazwa'=>'Enter=wej¶cie','akcja'=>$formularz);
$buttons[]=array('klawisz'=>'AltF','nazwa'=>'Alt+Formularz','akcja'=>$formularz);
$buttons[]=array('klawisz'=>'AltD','nazwa'=>'Alt+Dopisz','akcja'=>$dopisz);
$buttons[]=array('klawisz'=>'AltC','nazwa'=>'Alt+Copy','akcja'=>$kopia);
$buttons[]=array('klawisz'=>'AltS','nazwa'=>'Szukaj','js'=>"$('#modalSzukaj').modal('show')");
//$buttons[]=array('klawisz'=>'AltU','nazwa'=>'Alt+Usuñ','atrybuty'=>" type='button' data-toggle='modal' data-target='#myModal'");
$buttons[]=array('klawisz'=>'AltU','nazwa'=>'Alt+Usuñ','akcja'=>$usun);

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
