<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

// ----------------------------------------------
// Parametry widoku

$title='S�ownik';
$tabela='slownik';
$widok=$tabela;
$mandatory='';
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$title="Dane towaru, ";
$title.=($kopia=($id<0)?"kopia ":"");
$title.=($id?"ID=".abs($id):"nowa pozycja");

$tabela='dokumentm';
$widok=$tabela;
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/formFields.php");

//----------------------------------------------

$buttons=array();
$buttons[]=array('klawisz'=>'_Enter','nazwa'=>'Enter=Zapisz','akcja'=>"save.php?tabela=$tabela&id=$id");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=Anuluj','akcja'=>"../Tabela");
$buttons[]=array('klawisz'=>'AltM'
                ,'nazwa'=>'Alt+M=Magazyn'
				,'js'=>"parent.$('#myModalMagazyn').modal('show')"
				);

//----------------------------------------------

$dane=array();
$dane['CZAS']=date('Y-m-d H:i:s');

if ($id==0)
{
	$ostatnio=mysqli_fetch_array(mysqli_query($link, "
	select *
	  from $tabela
	 where 1
  order by ID desc
	 limit 1
	"));
	foreach($ostatnio as $k => $v)
	{
		if (in_array($k,array('TYP','STAWKA','JM')))
		{
			$dane[$k]=StripSlashes($v);
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

$dane['ILOSC']=str_replace('.000','',$dane['ILOSC']);
if (strpos($dane['ILOSC'],'.')!==false)
{
	$dane['ILOSC']=rtrim($dane['ILOSC'],'.0');
}
