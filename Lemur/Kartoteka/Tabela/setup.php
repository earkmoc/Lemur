<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

// ----------------------------------------------
// Parametry widoku

$title=$baza.': Kartoteka CRM';
$tabela='kartoteka';
$widok=$tabela;
$mandatory='';
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$params="idTabeli=$idTabeli&row='+row+'&col='+col+'&str='+str+'&id=";
$esc="saveTablePosition.php?next=http://{$_SERVER['HTTP_HOST']}/Lemur/Programy/&$params'+GetID()+'";
$formularz="../Formularz/?$params'+GetID()+'";
$dopisz="../Formularz/?{$params}0'+'";
$kopia="../Formularz/?$params-'+GetID()+'";
$usun="usun.php?$params'+GetID()+'";

$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>$esc);
$buttons[]=array('klawisz'=>'Enter','nazwa'=>'','akcja'=>$formularz);
$buttons[]=array('klawisz'=>'AltF','nazwa'=>'Enter=Formularz','akcja'=>$formularz);
$buttons[]=array('klawisz'=>'AltD','nazwa'=>'Dopisz','akcja'=>$dopisz);
$buttons[]=array('klawisz'=>'AltK','nazwa'=>'Kopia','akcja'=>$kopia);
$buttons[]=array('klawisz'=>'AltS','nazwa'=>'Szukaj','js'=>"$('#modalSzukaj').modal('show')");
//$buttons[]=array('klawisz'=>'AltU','nazwa'=>'Usuñ','atrybuty'=>" type='button' data-toggle='modal' data-target='#myModal'");
$buttons[]=array('klawisz'=>'AltU','nazwa'=>'Usuñ','akcja'=>$usun);
$buttons[]=array('klawisz'=>'AltW','nazwa'=>'Wydruk','akcja'=>"Wydruk.php?wydruk=Raporta&natab=kartoteka&strona1=15&stronan=20");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
