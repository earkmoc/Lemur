<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

// ----------------------------------------------
// Parametry widoku

$title='Odbiorcy';
$tabela='knordpol';
$widok=$tabela.'2';
$mandatory='1';
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

//----------------------------------------------

$params="idTabeli=$idTabeli&row='+row+'&col='+col+'&str='+str+'&id=";
$esc="saveTablePosition.php?next=http://{$_SERVER['HTTP_HOST']}/$baza/Menu/&$params'+GetID()+'";
$formularz="../Formularz/?$params'+GetID()+'";
$dopisz="../Formularz/?{$params}0'+'";
$kopia="../Formularz/?$params-'+GetID()+'";
$usun="usun.php?$params'+GetID()+'";

$buttons=array();

if	( (isset($_SESSION["{$baza}DokumentyID_D"]))
	||(isset($_SESSION["{$baza}KprID_D"]))
	||(isset($_SESSION["{$baza}SrodkiTrID_D"]))
	||(isset($_GET["Menu"]))
	)
{
	$buttons[]=array('klawisz'=>'AltO','nazwa'=>'Alt+O=wyj�cie','js'=>"parent.$('#myModalO').modal('hide');parent.$('input[name=PAYMENT]').focus();");
	$buttons[]=array('klawisz'=>'Enter','nazwa'=>'Enter=wyb�r','js'=>"
		parent.$('#myModalO').modal('hide');
		parent.$('input[name=DELIVERY]').val($('tr[data-index='+(row-1)+']>td:nth-child(3)').text());
		parent.$('input[name=PAYMENT]').val($('tr[data-index='+(row-1)+']>td:nth-child(4)').text());
		parent.$('input[name=PAYMENT]').focus();
	");
	$buttons[]=array('klawisz'=>'F','nazwa'=>'Formularz','akcja'=>$formularz);
} else
{
	$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj�cie','akcja'=>$esc);
	$buttons[]=array('klawisz'=>'Enter','nazwa'=>'','akcja'=>$formularz);
	$buttons[]=array('klawisz'=>'F','nazwa'=>'Enter=Formularz','akcja'=>$formularz);
}
$buttons[]=array('klawisz'=>'D','nazwa'=>'Dopisz','akcja'=>$dopisz);
$buttons[]=array('klawisz'=>'C','nazwa'=>'Copy','akcja'=>$kopia);
$buttons[]=array('klawisz'=>'U','nazwa'=>'Usu�','akcja'=>$usun);
$buttons[]=array('klawisz'=>'S','nazwa'=>'Szukaj','js'=>"$('#modalSzukaj').modal('show')");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
