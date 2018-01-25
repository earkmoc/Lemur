<?php

$id='0';
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");
$_SESSION["{$baza}EwidSprzID_D"]=$id;

// ----------------------------------------------
// Parametry widoku

@$id_d=$_SESSION["{$baza}DokumentyID_D"];

$tabela='ewidsprz';
$widok=$tabela.(!isset($id_d)?'':'H');
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/formFields.php");

$title="Ewidencja sprzeda�y, ";
$title.=($kopia=($id<0)?"kopia ":"");
$title.=($id?"ID=".abs($id):"nowa pozycja");

//----------------------------------------------

$buttons=array();
$buttons[]=array('klawisz'=>'_Enter','nazwa'=>'Enter=Zapisz','akcja'=>"save.php?tabela=$tabela&id=$id");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=Anuluj','akcja'=>"../Tabela");
if	(false&!isset($id_d))
{
$buttons[]=array('klawisz'=>'AltK'
                ,'nazwa'=>'Kontrahenci'
				,'js'=>"$('#myModal').modal('show')"
				);
				//,'atrybuty'=>" type='button' data-toggle='modal' data-target='#myModal' "
}

//----------------------------------------------

$dane=array();
$dane['DATAW']=date('Y-m-d');
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