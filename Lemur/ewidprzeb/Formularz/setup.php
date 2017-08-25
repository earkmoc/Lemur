<?php

$id='0';
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");
$_SESSION["{$baza}EwidPrzebID_D"]=$id;

// ----------------------------------------------
// Parametry widoku

@$id_d=$_SESSION["{$baza}DokumentyID_D"];

$tabela='ewidprzeb';
$widok=$tabela.(!isset($id_d)?'':'H');
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/formFields.php");

$title="Ewidencja Przebiegu Pojazdu, ";
$title.=($kopia=($id<0)?"kopia ":"");
$title.=($id?"ID=".abs($id):"nowa pozycja");

//----------------------------------------------

$buttons=array();
$buttons[]=array('klawisz'=>'_Enter','nazwa'=>'Enter=Zapisz','akcja'=>"save.php?tabela=$tabela&id=$id");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=Anuluj','akcja'=>"../Tabela");

//----------------------------------------------

$dane=array();
$dane['LPDZ']=$_GET['lp'];
$dane['DATAW']=$_GET['ddokumentu'];
$dane['DATADZ']=$_GET['ddokumentu'];
$dane['NRDZ']=$_GET['numer'];
$dane['WARTOSCDZ']=$_GET['wartosc'];
$dane['RODZAJ']=$_GET['przedmiot'];

$dane['OPIS']="Maratońska--Maratońska";
$dane['CEL']="Badania profilaktyczne";
$dane['STAWKA']=0.8358;

if ($id<>0)
{
	$dane=mysqli_fetch_array(mysqli_query($link, "
	select *
	  from $tabela
	 where ID=abs($id)
	"));
	foreach($dane as $k => $v)
	{
		//$dane[$k]=StripSlashes(iconv ( 'iso-8859-2', 'utf-8', $v));
		$dane[$k]=StripSlashes($v);
	}
	if ($kopia)
	{
		$id=0;
		$dane['ID']=0;	//dopisanie nowej pozycji
	}
}