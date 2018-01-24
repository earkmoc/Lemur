<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

// ----------------------------------------------
// Parametry widoku

$title='Konto Winien';
$tabela='knordpol';
$widok=$tabela.'15';
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
if(isset($_SESSION["{$baza}DokumentyID_D"]))
{
	$poleKonta='KONTOWN';
	$buttons[]=array('klawisz'=>'AltW','nazwa'=>'W=wyj¶cie','js'=>"
		parent.$('#myModalWn').modal('hide')
		parent.$('#iframeDekrety').focus();
		$('input[name=$poleKonta]',parent.$('#iframeDekrety').contents()).focus();
	");
	$buttons[]=array('klawisz'=>'Enter','nazwa'=>'Enter=wybór','js'=>"
		parent.$('#myModalWn').modal('hide');
		$('input[name=$poleKonta]',parent.$('#iframeDekrety').contents()).val($('tr[data-index='+(row-1)+']>td:nth-child(2)').text());
		parent.$('#iframeDekrety').focus();
		$('input[name=$poleKonta]',parent.$('#iframeDekrety').contents()).focus();
	");
}
else
{
	$buttons[]=array('klawisz'=>'AltW','nazwa'=>'W=wyj¶cie','js'=>"parent.$('#myModalWn').modal('hide')");
	$poleKonta='WINIEN';
	$buttons[]=array('klawisz'=>'Enter','nazwa'=>'Enter=wybór','js'=>"
		parent.$('input[name=$poleKonta]').val($('tr[data-index='+(row-1)+']>td:nth-child(2)').text());
		parent.$('#myModalWn').modal('hide');
	");
}
$buttons[]=array('klawisz'=>'AltF','nazwa'=>'Formularz','akcja'=>$formularz);
$buttons[]=array('klawisz'=>'AltD','nazwa'=>'Dopisz','akcja'=>$dopisz);
$buttons[]=array('klawisz'=>'AltC','nazwa'=>'Copy','akcja'=>$kopia);
$buttons[]=array('klawisz'=>'AltU','nazwa'=>'Usuñ','akcja'=>$usun);
$buttons[]=array('klawisz'=>'AltS','nazwa'=>'Szukaj','js'=>"$('#modalSzukaj').modal('show')");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
