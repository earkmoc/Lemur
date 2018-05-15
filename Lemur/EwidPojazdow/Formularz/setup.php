<?php

$id='0';
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");
$_SESSION["{$baza}EwidPojaID_D"]=$id;

// ----------------------------------------------
// Parametry widoku

@$id_d=$_SESSION["{$baza}DokumentyID_D"];

$tabela='ewidpoja';
$widok=$tabela;	//.(!isset($id_d)?'':'H');
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/formFields.php");

$title='Ewidencja Pojazdów i Przebiegu, ';
$title.=($kopia=($id<0)?"kopia ":"");
$title.=($id?"ID=".abs($id):"nowa pozycja");

//----------------------------------------------

$buttons=array();
$buttons[]=array('klawisz'=>'_Enter','nazwa'=>'Enter=Zapisz','akcja'=>"save.php?tabela=$tabela&id=$id");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>"../Tabela");

require('zakladkiButtons.php');

//----------------------------------------------

$dane=array();

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
		$dane['LP']=mysqli_fetch_row(mysqli_query($link, "
			select LP
			  from $tabela
			 where 1
		  order by LP*1 desc
			 limit 1
		"))[0]+1;
	}
}
else
{
	$_SESSION["{$baza}PojazdID_D"]=0;
}