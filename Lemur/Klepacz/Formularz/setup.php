<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

// ----------------------------------------------
// Parametry widoku

$title='Modu³ klepacza by Artur, ';
$title.=($kopia=($id<0)?"kopia ":"");
$title.=($id?"ID=".abs($id):"nowa pozycja");

$title='';
$tabela='klepacz';
$widok=$tabela;
//require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/formFields.php");

//----------------------------------------------

$buttons=array();
$buttons[]=array('klawisz'=>'_Enter','nazwa'=>'Enter=Zapisz','js'=>"parent.$('#myModalKlepacz').modal('hide');parent.$('input[name=NUMER]').focus();");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','js'=>"parent.$('#myModalKlepacz').modal('hide');parent.$('input[name=NUMER]').focus();");

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
	}
}