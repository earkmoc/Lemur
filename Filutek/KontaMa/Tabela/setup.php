<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

// ----------------------------------------------
// Parametry widoku

$title='Konto Ma';
$tabela='knordpol';
$widok=$tabela.'16';
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
	$poleKonta='KONTOMA';
	$buttons[]=array('klawisz'=>'AltM','nazwa'=>'M=wyj�cie','js'=>"
		parent.$('#myModalMa').modal('hide')
		parent.$('#iframeDekrety').focus();
		$('input[name=$poleKonta]',parent.$('#iframeDekrety').contents()).focus();
	");
	$buttons[]=array('klawisz'=>'Enter','nazwa'=>'Enter=wyb�r','js'=>"
		parent.$('#myModalMa').modal('hide');
		$('input[name=$poleKonta]',parent.$('#iframeDekrety').contents()).val($('tr[data-index='+(row-1)+']>td:nth-child(2)').text());
		parent.$('#iframeDekrety').focus();
		$('input[name=$poleKonta]',parent.$('#iframeDekrety').contents()).focus();
	");
}
else
{
	$buttons[]=array('klawisz'=>'AltM','nazwa'=>'M=wyj�cie','js'=>"parent.$('#myModalMa').modal('hide')");
	$poleKonta='MA';
	$buttons[]=array('klawisz'=>'Enter','nazwa'=>'Enter=wyb�r','js'=>"
		parent.$('input[name=$poleKonta]').val($('tr[data-index='+(row-1)+']>td:nth-child(2)').text());
		parent.$('#myModalMa').modal('hide');
	");
}
$buttons[]=array('klawisz'=>'AltF','nazwa'=>'Formularz','akcja'=>$formularz);
$buttons[]=array('klawisz'=>'AltD','nazwa'=>'Dopisz','akcja'=>$dopisz);
$buttons[]=array('klawisz'=>'AltC','nazwa'=>'Copy','akcja'=>$kopia);
$buttons[]=array('klawisz'=>'AltU','nazwa'=>'Usu�','akcja'=>$usun);
$buttons[]=array('klawisz'=>'AltS','nazwa'=>'Szukaj','js'=>"$('#modalSzukaj').modal('show')");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
