<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

// ----------------------------------------------
// Parametry widoku

@$baza=($innaBaza?$innaBaza:$bazaLinku=explode('/',$_SERVER['REQUEST_URI'])[1]);

$title='Modu³y';
$tabela='moduly';
$widok=$tabela;
$mandatory='';
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$params="idTabeli=$idTabeli&row='+row+'&col='+col+'&str='+str+'&id=";
$esc="saveTablePosition.php?next=/Lemur2/Logowanie/Tabela/logout.php&$params'+GetID()+'";
$formularz="../Formularz/?$params'+GetID()+'";
$dopisz="../Formularz/?{$params}0'+'";
$kopia="../Formularz/?$params-'+GetID()+'";
$usun="usun.php?$params'+GetID()+'";

$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wylogowanie','akcja'=>$esc);
if($ido==1)
{
	$buttons[]=array('klawisz'=>'Enter','nazwa'=>'Enter=Formularz','akcja'=>$formularz);
	$buttons[]=array('klawisz'=>'AltF','nazwa'=>'','akcja'=>$formularz);
	$buttons[]=array('klawisz'=>'AltD','nazwa'=>'Dopisz','akcja'=>"../Formularz/?{$params}0'+'");
	$buttons[]=array('klawisz'=>'AltC','nazwa'=>'Copy','akcja'=>"../Formularz/?$params-'+GetID()+'");
	$buttons[]=array('klawisz'=>'AltU','nazwa'=>'Usuñ','akcja'=>"usun.php?$params'+GetID()+'");
}
else
{
	$buttons[]=array('klawisz'=>'Enter','nazwa'=>'Enter=wej¶cie','akcja'=>$formularz);
}

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
