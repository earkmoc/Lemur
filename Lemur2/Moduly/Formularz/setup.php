<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

//----------------------------------------------

$buttons=array();

// ----------------------------------------------
// Parametry widoku

$kopia=($id<0);

$tabela='moduly';
$widok=$tabela;
if($ido==-1)
{
	//$widok.='z';
	$title='Modu³y';
	$title.=", ";
	$title.=($kopia=($id<0)?"kopia ":"");
	$title.=($id?"ID=".abs($id):"nowa pozycja");
	$buttons[]=array('klawisz'=>'_Enter','nazwa'=>'Enter=Zapisz','akcja'=>"save.php?tabela=$tabela&id=$id");
	$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=Anuluj','akcja'=>"../Tabela");
}
else
{
	$title='Lemur&sup2; - wybór klienta i roku';
	$buttons[]=array('klawisz'=>'_Enter','nazwa'=>'Enter=Wejd¼','akcja'=>"save.php?tabela=$tabela&id=$id");
	$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=Wyloguj','akcja'=>"../../Logowanie/Tabela/logout.php");
}

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/formFields.php");

//----------------------------------------------

$dane=array();
$dane['DATA']=date('Y-m-d');

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

$idKlienta=mysqli_fetch_row(mysqli_query($link,$q="select ID_POZYCJI from Lemur.tabeles where ID_TABELE=841 and ID_OSOBY=$ido"))[0];
$dane['KLIENT']=mysqli_fetch_row(mysqli_query($link,$q="select NAZWA from Lemur.klienci where ID=$idKlienta"))[0];

$dane['ROK']=preg_replace('/[^0-9]/', '', mysqli_fetch_row(mysqli_query($link,$q="select PSKONT from Lemur.klienci where ID=$idKlienta"))[0]);

$skrotKlienta=mysqli_fetch_row(mysqli_query($link,$q="select PSKONT from Lemur.klienci where ID=$idKlienta"))[0];
$idModulu=mysqli_fetch_row(mysqli_query($link,$q="select ID_POZYCJI from {$skrotKlienta}.tabeles where ID_TABELE=868 and ID_OSOBY=$ido"))[0];
$dane['NAZWA']=($w=mysqli_query($link,$q="select NAZWA from Lemur2.moduly where ID=$idModulu")?mysqli_fetch_row($w)[0]:'');
