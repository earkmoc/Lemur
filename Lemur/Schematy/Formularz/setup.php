<?php

$id='0';
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");
$_SESSION["{$baza}SchematyID_D"]=$id;

// ----------------------------------------------
// Parametry widoku

$tabela='Schematy';
$widok=$tabela;
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/formFields.php");

$title='Schematy ksi�gowe, ';
$title.=($kopia=($id<0)?"kopia ":"");
$title.=($id?"ID=".abs($id):"nowa pozycja");

//----------------------------------------------

$buttons=array();
$buttons[]=array('klawisz'=>'_Enter','nazwa'=>'Enter=Zapisz','akcja'=>"save.php?tabela=$tabela&id=$id");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj�cie','akcja'=>"../Tabela");
$buttons[]=array('klawisz'=>'AltS','nazwa'=>'Specyfikacja','js'=>"$('a[href=#Specyfikacja]').click();$('#iframePozycje').focus()");
//$buttons[]=array('klawisz'=>'AltP','nazwa'=>'Pracownicy','js'=>"$('#myModal').modal('show')");

//----------------------------------------------

$dane=array();

if ($id==0)
{
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
		$_SESSION["{$baza}SchematyID_D"]=0;
	}
}