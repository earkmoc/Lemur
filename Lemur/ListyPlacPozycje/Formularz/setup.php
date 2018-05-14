<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

// ----------------------------------------------
// Parametry widoku

$tabela='pracownicy';
$widok=$tabela;
$mandatory='';
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$title="Specyfikacja listy p³ac, ";
$title.=($kopia=($id<0)?"kopia ":"");
$title.=($id?"ID=".abs($id):"nowa pozycja");

$tabela='listyplacp';
$widok=$tabela;
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/formFields.php");

//----------------------------------------------

$buttons=array();
$buttons[]=array('klawisz'=>'_Enter','nazwa'=>'Enter=Zapisz','akcja'=>"save.php?tabela=$tabela&id=$id");
$buttons[]=array('klawisz'=>'AltB','nazwa'=>'Bez obliczania zapisz','akcja'=>"save.php?tabela=$tabela&id=$id&bez=1");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>"../Tabela");

//----------------------------------------------

$dane=array();
$dane['CZAS']=date('Y-m-d H:i:s');

//mandatory
$_POST['CZAS']=date('Y-m-d H:i:s');

if ($id==0)
{
	$ostatnio=mysqli_fetch_array(mysqli_query($link, "
	select *
	  from $tabela
	 where KTO=$ido
  order by ID desc
	 limit 1
	"));
	if($ostatnio)
	{
		foreach($ostatnio as $k => $v)
		{
			if (in_array($k,array('P_PODST')))
			{
				$dane[$k]=StripSlashes($v);
			}
		}
	}
}
else
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