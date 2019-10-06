<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

// ----------------------------------------------
// Parametry widoku

$tabela='wydrukiBlo';
$widok=$tabela;
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/formFields.php");

$title="Wydruki masowe wed³ug bloków";
$title.=($kopia=($id<0)?", kolejna pozycja":"");
//$title.=($id?"ID=".abs($id):"nowa pozycja");

//----------------------------------------------

$buttons=array();
$buttons[]=array('klawisz'=>'_Enter','nazwa'=>'Enter=Zapisz','akcja'=>"save.php?tabela=$tabela&id=$id");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=Anuluj','akcja'=>"../Tabela");

//----------------------------------------------

$dane=array();
$dane['CZAS']=date('Y-m-d H:i:s');

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
		$dane['BL1']=$dane['BL1']*1+1;
		$dane['BL2']=$dane['BL1'];
	}
}
