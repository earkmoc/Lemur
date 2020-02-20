<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
mysqli_query($link, "update tabeles ID_OSOBY=1 where ID_OSOBY=0");

// ----------------------------------------------
// Parametry widoku

@$tmp=explode('/',$_SERVER['REQUEST_URI']);
@$baza=($innaBaza?$innaBaza:$bazaLinku=$tmp[1]);

$title=($ido==1?'U¿ytkownicy':'Logowanie');
$tabela='osoby';
$widok=$tabela;
$mandatory='';
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$params="idTabeli=$idTabeli&row='+row+'&col='+col+'&str='+str+'&id=";
$esc="saveTablePosition.php?next=logout.php&$params'+GetID()+'";
$formularz="../Formularz/?$params'+GetID()+'";
$dopisz="../Formularz/?{$params}0'+'";
$kopia="../Formularz/?$params-'+GetID()+'";
$usun="usun.php?$params'+GetID()+'";

$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wylogowanie','akcja'=>$esc);
if($ido==1)
{
	$buttons[]=array('klawisz'=>'Enter','nazwa'=>'Enter=Formularz','akcja'=>$formularz);
	$buttons[]=array('klawisz'=>'AltD','nazwa'=>'Dopisz','akcja'=>"../Formularz/?{$params}0'+'");
	$buttons[]=array('klawisz'=>'AltC','nazwa'=>'Copy','akcja'=>"../Formularz/?$params-'+GetID()+'");
	$buttons[]=array('klawisz'=>'AltU','nazwa'=>'Usuñ','akcja'=>"usun.php?$params'+GetID()+'");
}
else
{
	$buttons[]=array('klawisz'=>'Enter','nazwa'=>'Enter=zalogowanie','akcja'=>$formularz);
}

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
