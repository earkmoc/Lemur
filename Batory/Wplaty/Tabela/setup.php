<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

if (@$_GET['id_d'])
{
	$_SESSION["{$baza}DokumentyID_D"]=$_GET['id_d'];
}

// ----------------------------------------------
// Parametry widoku

$id_d=$_SESSION["{$baza}DokumentyID_D"];
$typ=@$_GET['typ'];
$typ=($typ?$typ:'KP');

$title='Wp³aty ';
$kopia=($id_d<0);

$tabela='dokumentz';
$widok=$tabela;//.(!isset($id_d)?'':'H');
$mandatory="if('$id_d'='0',$tabela.ID_D=-1 and $tabela.KTO='$ido',$tabela.ID_D='$id_d')";
$mandatory=(!isset($id_d)?'':$mandatory);
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$params="idTabeli=$idTabeli&row='+row+'&col='+col+'&str='+str+'&id=";
$esc="saveTablePosition.php?next=http://{$_SERVER['HTTP_HOST']}/$baza/Menu/&$params'+GetID()+'";
$formularz="../Formularz/?$params'+GetID()+'";
$dopisz="../Formularz/?{$params}0&nazwa='+parent.$('input[name=NAZWA]').val()+'";
$kopia="../Formularz/?$params-'+GetID()+'";
$usun="usun.php?$params'+GetID()+'";

$readonly=false;
$buttons=array();
if (!isset($id_d))
{
	$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>$esc);
} 
else
{
	$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','js'=>"parent.$('input[name=PRZEDMIOT]').select().focus(); parent.scrollTo(0,0);");
	$readonly=( ((mysqli_fetch_row(mysqli_query($link, "select GDZIE from dokumenty where ID=$id_d"))[0])=='ksiêgi')
				||( ($ido==0)
				  &&($id_d)
				  &&((mysqli_fetch_row(mysqli_query($link, "select KTO from dokumenty where ID=$id_d"))[0])!=$ido)
				  )
	);
}

if  (!$readonly)
{
	if( ($typ=='KP')
	  ||($typ=='KW')
	  )
	{
		$buttons[]=array('klawisz'=>'D','nazwa'=>'Dopisz','akcja'=>$dopisz);
		$buttons[]=array('klawisz'=>'C','nazwa'=>'Copy','akcja'=>$kopia);
	}
	$buttons[]=array('klawisz'=>'Enter','nazwa'=>'','akcja'=>$formularz);
	$buttons[]=array('klawisz'=>'F','nazwa'=>'Enter=Formularz','akcja'=>$formularz);
	$buttons[]=array('klawisz'=>'U','nazwa'=>'Usuñ','akcja'=>$usun);
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
