<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

// ----------------------------------------------
// Parametry widoku

$kopia=($id<0);

$tabela='osoby';
$widok=$tabela;
if($ido==1)
{
	$widok.='z';
	$title='Lemur&sup2; - zarz±dzanie osobami';
	$title.=", ";
	$title.=($kopia=($id<0)?"kopia ":"");
	$title.=($id?"ID=".abs($id):"nowa pozycja");
}
else
{
	$title='Lemur&sup2; - Logowanie';
}

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/formFields.php");

if($ido==1)
{
	for($i=0;$i<count($fields);++$i)
	{
		$fields[$i]['readonly']=0;
	}
	//die(print_r($fields));
}

//----------------------------------------------

$buttons=array();
$buttons[]=array('klawisz'=>'_Enter','nazwa'=>'Enter=Zaloguj','akcja'=>"save.php?tabela=$tabela&id=$id");
if($ido==1)
{
	$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=Anuluj','akcja'=>"../Tabela");
}
else
{
	$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=Wyloguj','akcja'=>"../Tabela/logout.php");
}

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
else
{
	$dane=mysqli_fetch_array(mysqli_query($link, "
	select *
	  from $tabela
	 where 1
  order by ID
	 limit 1
	"));
	foreach($dane as $k => $v)
	{
		//$dane[$k]=StripSlashes(iconv ( 'iso-8859-2', 'utf-8', $v));
		$dane[$k]=StripSlashes($v);
	}
}

//wszyscy musz± podaæ swoje dotychczasowe has³o, wyj±tkiem jest admin (1) w trybie zmiany danych u¿ytkownika
if($ido!=1)
{
	$dane['PASS']='';
}

