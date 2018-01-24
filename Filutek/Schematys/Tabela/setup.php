<?php

//print_r($_GET);die;
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
$_SESSION["{$baza}SchematyID_D"]=$_GET['id'];

if ($_GET['typ'])
{
	$typ=explode(',',$_GET['typ']);
	$_SESSION['typ']=$typ[0];
	$_SESSION['typOpis']=$typ[1];
}

// ----------------------------------------------
// Parametry widoku

$id_d=$_SESSION["{$baza}SchematyID_D"];
$typ=$_SESSION['typ'];
$typOpis=$_SESSION['typOpis'];

$title="Schemat ksiêgowy $typ ($typOpis)";
$title.=($kopia=($id_d<0)?"do kopii ":"");
$title.=($id_d?"dokumentu o ID=".abs($id_d):'');

$tabela='schematys';
mysqli_query($link, "ALTER TABLE `$tabela` CHANGE `ID_D` `ID_D` INT(11) NOT NULL DEFAULT '-1'");

$widok='schematys';
$mandatory="if('$id_d'='0',$tabela.ID_D=-1 and $tabela.KTO='$ido',$tabela.ID_D='$id_d')";
$mandatory=(!isset($id_d)?'':$mandatory);

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$params="idTabeli=$idTabeli&row='+row+'&col='+col+'&str='+str+'&id=";
$esc="saveTablePosition.php?next=http://{$_SERVER['HTTP_HOST']}/$baza/Schematy/&$params'+GetID()+'";
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

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
