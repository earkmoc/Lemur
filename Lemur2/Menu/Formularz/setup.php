<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

// ----------------------------------------------
// Parametry widoku

$tabela='menu';
$widok=$tabela;
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/formFields.php");

$title="Dane opcji menu, ";
$title.=($kopia=($id<0)?"kopia ":"");
$title.=($id?"ID=".abs($id):"nowa pozycja");

//----------------------------------------------

$buttons=array();
$buttons[]=array('klawisz'=>'_Enter','nazwa'=>'Enter=Zapisz','akcja'=>"save.php?tabela=$tabela&id=$id");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>"../Tabela");

//----------------------------------------------

$dane=array();
$dane['CZAS']=date('Y-m-d H:i:s');

if ($id)
{
	$dane=mysqli_fetch_array(mysqli_query($link, "
	select *
	  from $tabela
	 where ID=$id
	"));
	foreach($dane as $k => $v)
	{
		//$dane[$k]=StripSlashes(iconv ( 'iso-8859-2', 'utf-8', $v));
		$dane[$k]=StripSlashes($v);
	}
}