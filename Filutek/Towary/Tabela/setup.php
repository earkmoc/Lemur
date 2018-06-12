<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

if (@$_GET['id_d'])
{
	$_SESSION["{$baza}DokumentyID_D"]=$_GET['id_d'];
}

// ----------------------------------------------
// Parametry widoku

$id_d=$_SESSION["{$baza}DokumentyID_D"];

$title='Towary lub us³ugi ';
$title.=($kopia=($id_d<0)?"do kopii ":"");
//$title.=($id_d?"dokumentu o ID=".abs($id_d):'');

$tabela='dokumentm';
mysqli_query($link, "ALTER TABLE `$tabela` CHANGE `ID_D` `ID_D` INT(11) NOT NULL DEFAULT '-1'");

$widok=$tabela;//.(!isset($id_d)?'':'H');
$mandatory="if('$id_d'='0',$tabela.ID_D=-1 and KTO='$ido',$tabela.ID_D='$id_d')";
$mandatory=(!isset($id_d)?'':$mandatory);
$sortowanieDoLiczenia='ID desc';
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$params="idTabeli=$idTabeli&row='+row+'&col='+col+'&str='+str+'&id=";
$esc="saveTablePosition.php?next=http://{$_SERVER['HTTP_HOST']}/$baza/Menu/&$params'+GetID()+'";
$formularz="../Formularz/?$params'+GetID()+'";
$dopisz="../Formularz/?{$params}0'+'";
$kopia="../Formularz/?$params-'+GetID()+'";
$usun="usun.php?$params'+GetID()+'";
$ilosc="ilosc.php?$params'+GetID()+'";

$readonly=false;
$buttons=array();
if (!isset($id_d))
{
	$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>$esc);
} else
{
	$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','js'=>"parent.$('input[name=WPLACONO]').select().focus(); parent.scrollTo(0,0);");
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
	$buttons[]=array('klawisz'=>'F','nazwa'=>'Enter=Formularz','akcja'=>$formularz);
	$buttons[]=array('klawisz'=>'D','nazwa'=>'Dopisz','akcja'=>$dopisz);
	$buttons[]=array('klawisz'=>'C','nazwa'=>'Copy','akcja'=>$kopia);
	$buttons[]=array('klawisz'=>'U','nazwa'=>'Usuñ','akcja'=>$usun);
	$buttons[]=array('klawisz'=>'I','nazwa'=>'Ilo¶æ','akcja'=>$ilosc);
	$buttons[]=array('klawisz'=>'S','nazwa'=>'Szukaj','js'=>"$('#modalSzukaj').modal('show')");
	if (isset($id_d))
	{
//		$buttons[]=array('klawisz'=>'AltA','nazwa'=>'Automat','akcja'=>"automat.php?idd=$id_d&typ='+parent.$('select[name=TYP] option:selected').val()+'&brutto='+parent.$('input[name=WARTOSC]').val()+'");
	}
}

if	( (isset($id_d))
	&&(!isset($_GET['short']))
	)
{
	require('../../Dokumenty/Formularz/zakladkiButtons.php');
}
else
{
	$buttons[]=array('klawisz'=>'S','nazwa'=>'Szukaj','js'=>"$('#modalSzukaj').modal('show')");
}

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
$buttons[]=array('klawisz'=>'AltQ','nazwa'=>'','akcja'=>'dosprawdzenia.php');
