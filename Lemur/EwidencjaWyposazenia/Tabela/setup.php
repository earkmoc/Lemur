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

$titleBase='Ewidencja Wyposa¿enia';
$title=$titleBase;
$kopia=($id_d<0);

$tabela='ewidwypo';
$widok=$tabela.(!isset($id_d)?'':'H');
$mandatory="if('$id_d'='0',$tabela.ID_D=-1 and $tabela.KTO='$ido',$tabela.ID_D='$id_d')";
$mandatory=(!isset($id_d)?'':$mandatory);

require('init.php');
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$params="idTabeli=$idTabeli&row='+row+'&col='+col+'&str='+str+'&id=";
$formularz="../Formularz/?$params'+GetID()+'";

$readonly=false;
$buttons=array();
if (!isset($id_d))
{
	$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>"saveTablePosition.php?next=http://{$_SERVER['HTTP_HOST']}/$baza/Menu/&$params'+GetID()+'");
} 
else
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
	$buttons[]=array('klawisz'=>'AltD','nazwa'=>'Dopisz','akcja'=>"../Formularz/?{$params}0'+'");
	$buttons[]=array('klawisz'=>'AltC','nazwa'=>'Copy','akcja'=>"../Formularz/?$params-'+GetID()+'");
	$buttons[]=array('klawisz'=>'AltU','nazwa'=>'Usuñ','akcja'=>"usun.php?$params'+GetID()+'");
}

if (isset($id_d))
{
	if (!$readonly)
	{
		$buttons[]=array('klawisz'=>'AltA','nazwa'=>'Automat','akcja'=>"automat.php"
		."?idd=$id_d"
		."&numer='+parent.$('input[name=NUMER]').val()+'"
		."&data='+parent.$('input[name=DOPERACJI]').val()+'"
		."&przedmiot='+parent.$('input[name=PRZEDMIOT]').val()+'"
		."&brutto='+parent.$('input[name=WARTOSC]').val()+'"
		);
	}
	require('../../Dokumenty/Formularz/zakladkiButtons.php');
} 
else
{
	$buttons[]=array('klawisz'=>'AltR','nazwa'=>'Renumeruj','akcja'=>"renumeracja.php?$params'+GetID()+'");
	$buttons[]=array('klawisz'=>'AltS','nazwa'=>'Szukaj','js'=>"$('#modalSzukaj').modal('show')");
//	$buttons[]=array('klawisz'=>'AltP','nazwa'=>'PK','akcja'=>"pk.php?$params'+GetID()+'&wzor=PKKPR");
	$buttons[]=array('klawisz'=>'AltT','nazwa'=>'Test','akcja'=>"test.php?$params'+GetID()+'");
	$buttons[]=array('klawisz'=>'AltW','nazwa'=>'Wydruk','akcja'=>"Wydruk1.php?$params'+GetID()+'");
}

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
