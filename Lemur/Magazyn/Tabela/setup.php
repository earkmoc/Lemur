<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

// ----------------------------------------------
// Parametry widoku

$title='Magazyn';
$tabela='towary';
$widok=$tabela;
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
	)
{
	$buttons[]=array('klawisz'=>'AltM','nazwa'=>'M=wyj¶cie','js'=>"
		parent.$('#myModalMagazyn').modal('hide');
		parent.$('#iframeTowary').focus();
		parent.$('input[name=NAZWA]',parent.$('#iframeTowary').contents()).focus();
	");
	$buttons[]=array('klawisz'=>'Enter','nazwa'=>'Enter=wybór','js'=>"
		parent.$('#myModalMagazyn').modal('hide');
		parent.$('select[name=TYP]',parent.$('#iframeTowary').contents()).val(parent.$('select[name=TYP] option:contains(\"'+$('tr[data-index='+(row-1)+']>td:nth-child(5)').text()+' -\")',parent.$('#iframeTowary').contents()).text());
		parent.$('input[name=NAZWA]',parent.$('#iframeTowary').contents()).val($('tr[data-index='+(row-1)+']>td:nth-child(2)').text());
		parent.$('input[name=INDEKS]',parent.$('#iframeTowary').contents()).val($('tr[data-index='+(row-1)+']>td:nth-child(3)').text());
		parent.$('input[name=PKWIU]',parent.$('#iframeTowary').contents()).val($('tr[data-index='+(row-1)+']>td:nth-child(4)').text());
		parent.$('input[name=JM]',parent.$('#iframeTowary').contents()).val($('tr[data-index='+(row-1)+']>td:nth-child(10)').text());
		parent.$('select[name=STAWKA]',parent.$('#iframeTowary').contents()).val(parent.$('select[name=STAWKA] option:contains(\"'+$('tr[data-index='+(row-1)+']>td:nth-child(11)').text()+' -\")',parent.$('#iframeTowary').contents()).text());
		parent.$('input[name=CENABEZR]',parent.$('#iframeTowary').contents()).val($('tr[data-index='+(row-1)+']>td:nth-child(8)').text());
		parent.$('input[name=RABAT]',parent.$('#iframeTowary').contents()).val('');
		parent.$('input[name=CENA]',parent.$('#iframeTowary').contents()).val('');
		parent.$('input[name=NETTO]',parent.$('#iframeTowary').contents()).val('');
		parent.$('input[name=VAT]',parent.$('#iframeTowary').contents()).val('');
		parent.$('input[name=BRUTTO]',parent.$('#iframeTowary').contents()).val('');
		if($('tr[data-index='+(row-1)+']>td:nth-child(5)').text()=='U')
		{
			parent.$('input[name=ILOSC]',parent.$('#iframeTowary').contents()).val(1);
		}
		else
		{
			parent.$('input[name=ILOSC]',parent.$('#iframeTowary').contents()).val($('tr[data-index='+(row-1)+']>td:nth-child(9)').text());
		}
		parent.$('#iframeTowary').focus();
		parent.$('input[name=ILOSC]',parent.$('#iframeTowary').contents()).focus();
		parent.$('input[name=ILOSC]',parent.$('#iframeTowary').contents()).select();
	");
	$buttons[]=array('klawisz'=>'AltF','nazwa'=>'Formularz','akcja'=>$formularz);
} else
{
	$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>$esc);
	$buttons[]=array('klawisz'=>'Enter','nazwa'=>'','akcja'=>$formularz);
	$buttons[]=array('klawisz'=>'AltF','nazwa'=>'Enter=Formularz','akcja'=>$formularz);
	$buttons[]=array('klawisz'=>'AltW','nazwa'=>'Wydruk','akcja'=>"Wydruk.php?wydruk=Raporta&natab=$tabela&strona1=15&stronan=20");
}
$buttons[]=array('klawisz'=>'AltD','nazwa'=>'Dopisz','akcja'=>$dopisz);
$buttons[]=array('klawisz'=>'AltC','nazwa'=>'Copy','akcja'=>$kopia);
$buttons[]=array('klawisz'=>'AltU','nazwa'=>'Usuñ','akcja'=>$usun);
$buttons[]=array('klawisz'=>'AltS','nazwa'=>'Szukaj','js'=>"$('#modalSzukaj').modal('show')");
$buttons[]=array('klawisz'=>'AltA','nazwa'=>'Aktywne','akcja'=>"aktywne.php?$params'+GetID()+'");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
