<?php

$id='0';
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");
$_SESSION["{$baza}SrodkiTrID_D"]=$id;

// ----------------------------------------------
// Parametry widoku

$tabela='srodkitr';
$widok=$tabela;
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/formFields.php");

$title='¦rodki trwa³e, ';
$title.=($kopia=($id<0)?"kopia ":"");
$title.=($id?"ID=".abs($id):"nowy");

//----------------------------------------------

$buttons=array();
$buttons[]=array('klawisz'=>'_Enter','nazwa'=>'Enter=Zapisz','akcja'=>"save.php?tabela=$tabela&id=$id");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>"../Tabela");
$buttons[]=array('klawisz'=>'Alt1','nazwa'=>'','js'=>"
	$('li').removeClass('active');
	$('div.tab-pane:not(#home)').removeClass('active');
	$('#liOT').addClass('active');
	$('#OT').addClass('active');
	$('#iframeSrodkiTrOT').focus();
");
$buttons[]=array('klawisz'=>'Alt2','nazwa'=>'','js'=>"
	$('li').removeClass('active');
	$('div.tab-pane:not(#home)').removeClass('active');
	$('#liZmiany').addClass('active');
	$('#Zmiany').addClass('active');
	$('#iframeSrodkiTrZmiany').focus();
");
$buttons[]=array('klawisz'=>'Alt3','nazwa'=>'','js'=>"
	$('li').removeClass('active');
	$('div.tab-pane:not(#home)').removeClass('active');
	$('#liHistoria').addClass('active');
	$('#Historia').addClass('active');
	$('#iframeSrodkiTrHistoria').focus();
");
$buttons[]=array('klawisz'=>'AltK','nazwa'=>'Kontrahenci','js'=>"$('#myModal').modal('show')");

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
		$_SESSION["{$baza}SrodkiTrID_D"]=0;
	}
}