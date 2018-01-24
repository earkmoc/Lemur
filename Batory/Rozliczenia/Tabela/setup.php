<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

// ----------------------------------------------
// Parametry widoku

$title='Rozliczenia';
$tabela='dokumenty';
$widok='dokumentzs';
$mandatory='dokumenty.WARTOSC<>dokumenty.WPLACONO';
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
	)
{
	$buttons[]=array('klawisz'=>'AltR','nazwa'=>'Alt+R=wyj¶cie','js'=>"
		parent.$('#myModalRozliczenia').modal('hide');
		parent.$('#iframeWplaty').focus();
		parent.$('input[name=KWOTA]',parent.$('#iframeWplaty').contents()).focus();
	");
	$buttons[]=array('klawisz'=>'Enter','nazwa'=>'Enter=wybór','js'=>"
		parent.$('#myModalRozliczenia').modal('hide');
		parent.$('input[name=KWOTA]',    parent.$('#iframeWplaty').contents()).val($('tr[data-index='+(row-1)+']>td:nth-child(8)').text());
		parent.$('input[name=PRZEDMIOT]',parent.$('#iframeWplaty').contents()).val($('tr[data-index='+(row-1)+']>td:nth-child(3)').text());
		parent.$('#iframeWplaty').focus();
		parent.$('input[name=KWOTA]',parent.$('#iframeWplaty').contents()).focus();
		parent.$('input[name=KWOTA]',parent.$('#iframeWplaty').contents()).select();
	");
//	$buttons[]=array('klawisz'=>'AltF','nazwa'=>'Formularz','akcja'=>$formularz);
} else
{
	$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>$esc);
//	$buttons[]=array('klawisz'=>'Enter','nazwa'=>'','akcja'=>$formularz);
//	$buttons[]=array('klawisz'=>'AltF','nazwa'=>'Enter=Formularz','akcja'=>$formularz);
//	$buttons[]=array('klawisz'=>'AltW','nazwa'=>'Wydruk','akcja'=>"Wydruk.php?wydruk=Raporta&natab=$tabela&strona1=15&stronan=20");
}
//$buttons[]=array('klawisz'=>'AltD','nazwa'=>'Dopisz','akcja'=>$dopisz);
//$buttons[]=array('klawisz'=>'AltC','nazwa'=>'Copy','akcja'=>$kopia);
//$buttons[]=array('klawisz'=>'AltU','nazwa'=>'Usuñ','akcja'=>$usun);
$buttons[]=array('klawisz'=>'S','nazwa'=>'Szukaj','js'=>"$('#modalSzukaj').modal('show')");
//$buttons[]=array('klawisz'=>'AltA','nazwa'=>'Aktywne','akcja'=>"aktywne.php?$params'+GetID()+'");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
