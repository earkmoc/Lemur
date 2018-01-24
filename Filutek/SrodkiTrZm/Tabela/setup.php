<?php

//print_r($_GET);die;
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

if (@$_GET['id_d'])
{
	$_SESSION["{$baza}SrodkiTrID_D"]=$_GET['id_d'];
}

// ----------------------------------------------
// Parametry widoku

$id_d=$_SESSION["{$baza}SrodkiTrID_D"];

$title='Zmiany ';
$title.=($kopia=($id_d<0)?"do kopii ":"");
$title.=($id_d?"¶rodka trwa³ego o ID=".abs($id_d):'');

$tabela='srodkizm';

$widok=$tabela;
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
	$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','js'=>"parent.$('input[name=NRINW]').select().focus(); parent.scrollTo(0,0);");
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
$buttons[]=array('klawisz'=>'Alt1','nazwa'=>'','js'=>"
	parent.$('li').removeClass('active');
	parent.$('div.tab-pane:not(#home)').removeClass('active');
	parent.$('#liOT').addClass('active');
	parent.$('#OT').addClass('active');
	parent.$('#iframeSrodkiTrOT').focus();
");
$buttons[]=array('klawisz'=>'Alt2','nazwa'=>'','js'=>"
	parent.$('li').removeClass('active');
	parent.$('div.tab-pane:not(#home)').removeClass('active');
	parent.$('#liZmiany').addClass('active');
	parent.$('#Zmiany').addClass('active');
	parent.$('#iframeSrodkiTrZmiany').focus();
");
$buttons[]=array('klawisz'=>'Alt3','nazwa'=>'','js'=>"
	parent.$('li').removeClass('active');
	parent.$('div.tab-pane:not(#home)').removeClass('active');
	parent.$('#liHistoria').addClass('active');
	parent.$('#Historia').addClass('active');
	parent.$('#iframeSrodkiTrHistoria').focus();
");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
