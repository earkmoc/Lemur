<?php

error_reporting(E_ERROR | E_PARSE | E_WARNING);//E_NOTICE | 

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

if ($_GET['id_d'])
{
	$_SESSION["{$baza}PojazdID_D"]=$_GET['id_d'];
}

// ----------------------------------------------
// Parametry widoku

@$id_d=$_SESSION["{$baza}PojazdID_D"];
$rej=mysqli_fetch_row(mysqli_query($link,$q="select REJESTRACJA from ewidpoja where ID=$id_d"))[0];
$okres=mysqli_fetch_row(mysqli_query($link,$q="select OKRES from ewidpoja where ID=$id_d"))[0];

$titleBase='Ewidencja Przebiegu Pojazdu ';
$title=$titleBase;
$kopia=($id_d<0);

$tabela='ewidprzeb';

$widok=$tabela.(!isset($id_d)?'':'H');
$warOkresu=($okres?" and ($tabela.DATAW like '%$okres%')":'');
$mandatory="if('$id_d'='0',$tabela.ID_D=-1 and KTO='$ido',$tabela.REJESTRACJA='$rej' $warOkresu)";
$mandatory=(!isset($id_d)?'':$mandatory);

require('init.php');
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$params="idTabeli=$idTabeli&row='+row+'&col='+col+'&str='+str+'&id=";

$readonly=false;
$buttons=array();
if (!isset($id_d))
{
	$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>"saveTablePosition.php?next=http://{$_SERVER['HTTP_HOST']}/$baza/Menu/&$params'+GetID()+'");
} else
{
	$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','js'=>"parent.$('input[name=LP]').select().focus(); parent.scrollTo(0,0);");
	$readonly=( ((mysqli_fetch_row(mysqli_query($link, "select GDZIE from dokumenty where ID=$id_d"))[0])=='ksiêgi')
				||( ($ido==0)
				  &&($id_d)
				  &&((mysqli_fetch_row(mysqli_query($link, "select KTO from dokumenty where ID=$id_d"))[0])!=$ido)
				  )
	);
}

if (!$readonly)
{
	$formularz="../Formularz/?$params'+GetID()+'&rejestracja='+parent.$('input[name=REJESTRACJA]').val()+'";
	$buttons[]=array('klawisz'=>'Enter','nazwa'=>'','akcja'=>$formularz);
	$buttons[]=array('klawisz'=>'AltF','nazwa'=>'Enter=Formularz','akcja'=>$formularz);
	$buttons[]=array('klawisz'=>'AltD','nazwa'=>'Dopisz','akcja'=>"../Formularz/?{$params}0'+'&rejestracja='+parent.$('input[name=REJESTRACJA]').val()+'");
	$buttons[]=array('klawisz'=>'AltC','nazwa'=>'Copy','akcja'=>"../Formularz/?$params-'+GetID()+'&rejestracja='+parent.$('input[name=REJESTRACJA]').val()+'");
	$buttons[]=array('klawisz'=>'AltU','nazwa'=>'Usuñ','akcja'=>"usun.php?$params'+GetID()+'");
}

if (isset($id_d))
{
	if (!$readonly)
	{
		/*
		$buttons[]=array('klawisz'=>'AltA','nazwa'=>'Automat','akcja'=>"automat.php?idd=$id_d&typ='+parent.$('select[name=TYP] option:selected').val()+'&brutto='+parent.$('input[name=WARTOSC]').val()+'");
		*/
	}
	require('../../EwidPojazdow/Formularz/zakladkiButtons.php');
} 

$buttons[]=array('klawisz'=>'AltS','nazwa'=>'Szukaj','js'=>"$('#modalSzukaj').modal('show')");
$buttons[]=array('klawisz'=>'AltR','nazwa'=>'Renumeruj','akcja'=>"renumeracja.php?$params'+GetID()+'&rejestracja='+parent.$('input[name=REJESTRACJA]').val()+'");
$wydruk="?wydruk=Raporta";
$wydruk.="&tabela=$widok";
$wydruk.="&batab=$tabela";
$wydruk.="&strona1=15";
$wydruk.="&stronan=16";
$wydruk.="&tytul=$titleBase";
$wydruk.="&rejestracja='+parent.$('input[name=REJESTRACJA]').val()+'";
$wydruk.="&pojemnosc='+parent.$('input[name=POJEMNOSC]').val()+'";
$wydruk.="&opis='+parent.$('textarea[name=OPIS]').val().split(/\\n/).join('<br>')+'";
$wydruk.="&okres='+parent.$('input[name=OKRES]').val()+'";
$buttons[]=array('klawisz'=>'AltW','nazwa'=>'Wydruk','akcja'=>"Wydruk.php$wydruk");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
