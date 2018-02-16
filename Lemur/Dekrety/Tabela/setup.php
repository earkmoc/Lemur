<?php

error_reporting(E_ERROR | E_PARSE | E_WARNING);//E_NOTICE | 

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

if ($_GET['id_d'])
{
	$_SESSION["{$baza}DokumentyID_D"]=$_GET['id_d'];
}

// ----------------------------------------------
// Parametry widoku

$title='Konta ksiêgowe';
$tabela='knordpol';
$widok=$tabela;
$mandatory='';

mysqli_query($link,$q="create index KONTO on $tabela(KONTO)");
mysqli_query($link,$q="create index NUMER on $tabela(NUMER)");
mysqli_query($link,$q="create index PSEUDO on $tabela(PSEUDO)");
mysqli_query($link,$q="create index NIP on $tabela(NIP)");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$id_d=$_SESSION["{$baza}DokumentyID_D"];

$title='Dekrety ';
$title.=($kopia=($id_d<0)?"do kopii ":"");
//$title.=($id_d?"dokumentu o ID=".abs($id_d):'');

$tabela='dokumentk';
mysqli_query($link, "ALTER TABLE `$tabela` CHANGE `ID_D` `ID_D` INT(11) NOT NULL DEFAULT '-1'");
mysqli_query($link,$q="create index ID_D on $tabela(ID_D)");

$widok=$tabela;//.(!isset($id_d)?'':'H');
$mandatory="if('$id_d'='0',$tabela.ID_D=-1 and KTO='$ido',$tabela.ID_D='$id_d')";
$mandatory=(!isset($id_d)?'':$mandatory);
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$params="idTabeli=$idTabeli&row='+row+'&col='+col+'&str='+str+'&id=";
$esc="saveTablePosition.php?next=http://{$_SERVER['HTTP_HOST']}/$baza/Menu/&$params'+GetID()+'";
$formularz="../Formularz/?$params'+GetID()+'";
$dopisz="../Formularz/?{$params}0'+'";
$kopia="../Formularz/?$params-'+GetID()+'";
$usun="usun.php?$params'+GetID()+'";
$automat="automat.php?idd=$id_d&typ='+parent.$('select[name=TYP]').val()+'&numer='+parent.$('input[name=NUMER]').val()+'&doperacji='+parent.$('input[name=DOPERACJI]').val()+'&wplacono='+parent.$('input[name=WPLACONO]').val()+'&przedmiot='+parent.$('input[name=PRZEDMIOT]').val()+'&NIP='+parent.$('input[name=NIP]').val()+'&NAZWA='+parent.$('input[name=NAZWA]').val()+'";

$readonly=false;
$buttons=array();
if (!isset($id_d))
{
	$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>$esc);
} else
{
	$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','js'=>"parent.$('input[name=NUMER]').select().focus(); parent.scrollTo(0,0);");
	$readonly=( ((mysqli_fetch_row(mysqli_query($link, "select GDZIE from dokumenty where ID=$id_d"))[0])=='ksiêgi')
				||( ($ido==0)
				  &&($id_d)
				  &&((mysqli_fetch_row(mysqli_query($link, "select KTO from dokumenty where ID=$id_d"))[0])!=$ido)
				  )
	);
}

if (!$readonly)
{
	$buttons[]=array('klawisz'=>'Enter','nazwa'=>'','akcja'=>$formularz);
	$buttons[]=array('klawisz'=>'AltF','nazwa'=>'Enter=Formularz','akcja'=>$formularz);
	$buttons[]=array('klawisz'=>'AltD','nazwa'=>'Dopisz','akcja'=>$dopisz);
	$buttons[]=array('klawisz'=>'AltC','nazwa'=>'Copy','akcja'=>$kopia);
	$buttons[]=array('klawisz'=>'AltU','nazwa'=>'Usuñ','akcja'=>$usun);
	$buttons[]=array('klawisz'=>'AltA','nazwa'=>'Automat','akcja'=>$automat);
}

if (isset($id_d))
{
	require('../../Dokumenty/Formularz/zakladkiButtons.php');
}
else
{
	$buttons[]=array('klawisz'=>'AltS','nazwa'=>'Szukaj','js'=>"$('#modalSzukaj').modal('show')");
}

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
