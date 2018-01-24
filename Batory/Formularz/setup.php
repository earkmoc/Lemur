<?php

require("{$_SERVER[DOCUMENT_ROOT]}/Lemur2/dbconnect.php");
require("{$_SERVER[DOCUMENT_ROOT]}/Lemur2/saveTablePosition.php");

// ----------------------------------------------
// Parametry widoku

$title="Dane Ksiêgi Przychodów i Rozchodów, ID=$id";
$tabela='Klienci';
$widok=$tabela;
require("{$_SERVER[DOCUMENT_ROOT]}/Lemur2/formFields.php");

//----------------------------------------------

$buttons=array();
$buttons[]=array('klawisz'=>'_Enter','nazwa'=>'Enter=Zapisz','akcja'=>"save.php?tabela=$tabela&id=$id");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=Anuluj','akcja'=>"../Tabela");

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