<?php

error_reporting(E_ERROR | E_PARSE | E_WARNING);//E_NOTICE | 

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

if ($_GET['id_d'])
{
	$_SESSION["{$baza}DokumentyID_D"]=$_GET['id_d'];
}

// ----------------------------------------------
// Parametry widoku

@$id_d=$_SESSION["{$baza}DokumentyID_D"];

$titleBase='Ewidencja sprzeda�y';
$title=$titleBase;
$kopia=($id_d<0);

$tabela='ewidsprz';

$widok=$tabela.(!isset($id_d)?'':'H');
$mandatory="if('$id_d'='0',$tabela.ID_D=-1 and KTO='$ido',$tabela.ID_D='$id_d')";
$mandatory=(!isset($id_d)?'':$mandatory);
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$params="idTabeli=$idTabeli&row='+row+'&col='+col+'&str='+str+'&id=";
$formularz="../Formularz/?$params'+GetID()+'";

$readonly=false;
$buttons=array();
if (!isset($id_d))
{
	$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj�cie','akcja'=>"saveTablePosition.php?next=http://{$_SERVER['HTTP_HOST']}/$baza/Menu/&$params'+GetID()+'");
} else
{
	$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj�cie','js'=>"parent.$('input[name=NUMER]').select().focus(); parent.scrollTo(0,0);");
	$readonly=( ((mysqli_fetch_row(mysqli_query($link, "select GDZIE from dokumenty where ID=$id_d"))[0])=='ksi�gi')
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
	$buttons[]=array('klawisz'=>'AltD','nazwa'=>'Dopisz','akcja'=>"../Formularz/?{$params}0'+'");
	$buttons[]=array('klawisz'=>'AltC','nazwa'=>'Copy','akcja'=>"../Formularz/?$params-'+GetID()+'");
	$buttons[]=array('klawisz'=>'AltU','nazwa'=>'Usu�','akcja'=>"usun.php?$params'+GetID()+'");
}

if (isset($id_d))
{
	if (!$readonly)
	{
		$buttons[]=array('klawisz'=>'AltA','nazwa'=>'Automat','akcja'=>"automat.php?idd=$id_d&typ='+parent.$('select[name=TYP] option:selected').val()+'&brutto='+parent.$('input[name=WARTOSC]').val()+'&ddokumentu='+parent.$('input[name=DDOKUMENTU]').val()+'&doperacji='+parent.$('input[name=DOPERACJI]').val()+'");
	}
	require('../../Dokumenty/Formularz/zakladkiButtons.php');
} 
else
{
	$buttons[]=array('klawisz'=>'AltR','nazwa'=>'Renumeruj','akcja'=>"renumeracja.php?$params'+GetID()+'");
	$buttons[]=array('klawisz'=>'AltS','nazwa'=>'Szukaj','js'=>"$('#modalSzukaj').modal('show')");
	$buttons[]=array('klawisz'=>'AltW','nazwa'=>'Wydruk','akcja'=>"Wydruk.php?wydruk=Raporta&natab=$tabela&strona1=15&stronan=16&tytul=$titleBase");
}

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
