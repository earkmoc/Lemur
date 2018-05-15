<?php

error_reporting(E_ERROR | E_PARSE | E_WARNING);//E_NOTICE | 

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

if (@$_GET['id_d'])
{
	$id_d=$_GET['id_d'];
	$_SESSION["{$baza}PojazdID_D"]=mysqli_fetch_row(mysqli_query($link,$q="select ID_S from dokumenty where ID=$id_d"))[0];
	@$id_s=$_SESSION["{$baza}PojazdID_D"];
	if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}
}

// ----------------------------------------------
// Parametry widoku

@$id_s=$_SESSION["{$baza}PojazdID_D"];
@$id_d=$_SESSION["{$baza}DokumentyID_D"];

$kopia=($id_d<0);

$tabela='ewidpoja';
$widok=$tabela;	//.(!isset($id_d)?'':'H');
if(isset($id_d))
{
	$title='Ewidencja Pojazdów'.($id_s>0?' (Dokument<=>'.mysqli_fetch_row(mysqli_query($link,$q="select REJESTRACJA from $tabela where ID=$id_s"))[0].')':' (brak powi±zania)');
}
else
{
	$title='Ewidencja Pojazdów i Przebiegu';
}
//$mandatory="if('$id_s'='0',$tabela.ID_D=-1 and $tabela.KTO='$ido',$tabela.ID='$id_s')";
//$mandatory=(!isset($id_d)?'':$mandatory);
$mandatory='';

require('init.php');
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

if(!mysqli_fetch_row(mysqli_query($link,$q="
	select count(*)
	  from $tabela
	"))[0])
{
	mysqli_query($link,$q="
	insert
	  into $tabela
	 ( select 0, $ido, Now(), 0, REJESTRACJA, POJEMNOSC, KIEROWCA, 0, '', 0, 0
	     from ewidprzeb
	 group by REJESTRACJA
	 )
	");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}
}

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

if (isset($id_d))
{
	if (!$readonly)
	{
		$buttons[]=array('klawisz'=>'AltP','nazwa'=>'Powi±¿ dokument i pojazd','akcja'=>"automat.php?$params'+GetID()+'");
	}
	require('../../Dokumenty/Formularz/zakladkiButtons.php');
} 
else
{
	$buttons[]=array('klawisz'=>'Enter','nazwa'=>'','akcja'=>$formularz);
	$buttons[]=array('klawisz'=>'AltF','nazwa'=>'Enter=Formularz','akcja'=>$formularz);
	$buttons[]=array('klawisz'=>'AltD','nazwa'=>'Dopisz','akcja'=>"../Formularz/?{$params}0'+'");
	$buttons[]=array('klawisz'=>'AltU','nazwa'=>'Usuñ','akcja'=>"usun.php?$params'+GetID()+'");
	$buttons[]=array('klawisz'=>'AltS','nazwa'=>'Szukaj','js'=>"$('#modalSzukaj').modal('show')");
	$buttons[]=array('klawisz'=>'AltO','nazwa'=>'Okres/przelicz','akcja'=>"okresGet.php?$params'+GetID()+'");
	$buttons[]=array('klawisz'=>'AltW','nazwa'=>'Wydruk','akcja'=>"Wydruk.php?$params'+GetID()+'&tytul=$title&wydruk=Raporta&natab=ewidpoja&strona1=15&stronan=16");
}

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
