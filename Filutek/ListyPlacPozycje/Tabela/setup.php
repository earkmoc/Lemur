<?php

//print_r($_GET);die;
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

if (@$_GET['id_d'])
{
	$_SESSION["{$baza}ListyPlacID_D"]=$_GET['id_d'];
}

// ----------------------------------------------
// Parametry widoku

$id_d=$_SESSION["{$baza}ListyPlacID_D"];

$title='Specyfikacja ';
$title.=($kopia=($id_d<0)?"do kopii ":"");
$title.=($id_d?"listy p³ac o ID=".abs($id_d):'');

$tabela='listyplacp';

mysqli_query($link, "ALTER TABLE `$tabela` ADD `ZASWYPLAC` decimal(15,2) NOT NULL DEFAULT '0.00'");

$widok=$tabela;//.(!isset($id_d)?'':'H');
$mandatory="if('$id_d'='0',$tabela.ID_D=-1 and $tabela.KTO='$ido',$tabela.ID_D='$id_d')";
$mandatory=(!isset($id_d)?'':$mandatory);
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$params="idTabeli=$idTabeli&row='+row+'&col='+col+'&str='+str+'&id=";
$esc="saveTablePosition.php?next=http://{$_SERVER['HTTP_HOST']}/$baza/Menu/&$params'+GetID()+'";
$formularz="../Formularz/?$params'+GetID()+'";
$dopisz="../Formularz/?{$params}0'+'";
$kopia="../Formularz/?$params-'+GetID()+'";
$usun="usun.php?$params'+GetID()+'";

$buttons=array();
if (!isset($id_d))
{
	$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>$esc);
} else
{
	$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','js'=>"parent.$('input[name=NUMER]').select().focus()");
}

$buttons[]=array('klawisz'=>'Enter','nazwa'=>'','akcja'=>$formularz);
$buttons[]=array('klawisz'=>'AltF','nazwa'=>'Enter=Formularz','akcja'=>$formularz);
$buttons[]=array('klawisz'=>'AltD','nazwa'=>'Dopisz','akcja'=>$dopisz);
$buttons[]=array('klawisz'=>'AltC','nazwa'=>'Copy','akcja'=>$kopia);
$buttons[]=array('klawisz'=>'AltU','nazwa'=>'Usuñ','akcja'=>$usun);
if (!isset($id_d))
{
	$buttons[]=array('klawisz'=>'AltS','nazwa'=>'Szukaj','js'=>"$('#modalSzukaj').modal('show')");
}

$buttons[]=array('klawisz'=>'AltW','nazwa'=>'Wydruk','akcja'=>"Wydruk.php?wydruk=Raporta&natab=$widok&strona1=15&stronan=20");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
