<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

// ----------------------------------------------
// Parametry widoku

$title='Nabywcy';
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
	$buttons[]=array('klawisz'=>'AltN','nazwa'=>'Alt+N=wyj¶cie','js'=>"parent.$('#myModalN').modal('hide');parent.$('input[name=NAZWA]').focus();");
	$buttons[]=array('klawisz'=>'Enter','nazwa'=>'Enter=wybór','js'=>"
		parent.$('#myModalN').modal('hide');
		parent.$('input[name=NIP]').val($('tr[data-index='+(row-1)+']>td:nth-child(3)').text());
		parent.$('input[name=NAZWA]').val($('tr[data-index='+(row-1)+']>td:nth-child(4)').text());
		parent.$('input[name=PRZEDMIOT]').val('Czynsz za najem boksu nr '+$('tr[data-index='+(row-1)+']>td:nth-child(5)').text());
		parent.$('input[name=UWAGI]').val($('tr[data-index='+(row-1)+']>td:nth-child(6)').text());
		parent.$('input[name=NAZWA]').focus();
	");
	$buttons[]=array('klawisz'=>'F','nazwa'=>'Formularz','akcja'=>$formularz);
} else
{
	$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>$esc);
	$buttons[]=array('klawisz'=>'Enter','nazwa'=>'','akcja'=>$formularz);
	$buttons[]=array('klawisz'=>'F','nazwa'=>'Enter=Formularz','akcja'=>$formularz);
}
$buttons[]=array('klawisz'=>'D','nazwa'=>'Dopisz','akcja'=>$dopisz);
$buttons[]=array('klawisz'=>'C','nazwa'=>'Copy','akcja'=>$kopia);
$buttons[]=array('klawisz'=>'U','nazwa'=>'Usuñ','akcja'=>$usun);
$buttons[]=array('klawisz'=>'S','nazwa'=>'Szukaj','js'=>"$('#modalSzukaj').modal('show')");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
