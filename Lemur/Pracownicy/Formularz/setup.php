<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

// ----------------------------------------------
// Parametry widoku

$tabela='pracownicy';
$widok=$tabela;
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/formFields.php");

$title="Pracownicy, ";
$title.=($kopia=($id<0)?"kopia ":"");
$title.=($id?"ID=".abs($id):"nowa osoba");

//----------------------------------------------

$buttons=array();
$buttons[]=array('klawisz'=>'_Enter','nazwa'=>'Enter=Zapisz','akcja'=>"save.php?tabela=$tabela&id=$id");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=Anuluj','akcja'=>"../Tabela");
$buttons[]=array('klawisz'=>'Alt1','nazwa'=>'','js'=>"
	$('li').removeClass('active');
	$('div.tab-pane:not(#home)').removeClass('active');
	$('#liDane').addClass('active');
	$('#Dane').addClass('active');
	$('input[name=NAZWISKOIMIE]').focus();
");
$buttons[]=array('klawisz'=>'Alt2','nazwa'=>'','js'=>"
	$('li').removeClass('active');
	$('div.tab-pane:not(#home)').removeClass('active');
	$('#liAbsencje').addClass('active');
	$('#Absencje').addClass('active');
	$('#iframeRejestryVAT').focus();
");
$buttons[]=array('klawisz'=>'Alt3','nazwa'=>'','js'=>"
	$('li').removeClass('active');
	$('div.tab-pane:not(#home)').removeClass('active');
	$('#liListyPlac').addClass('active');
	$('#ListyPlac').addClass('active');
	$('#iframePracownicyListy').focus();
");
$buttons[]=array('klawisz'=>'Alt4','nazwa'=>'','js'=>"
	$('li').removeClass('active');
	$('div.tab-pane:not(#home)').removeClass('active');
	$('#liHistoriaP').addClass('active');
	$('#HistoriaP').addClass('active');
	$('#iframeHistoriaP').focus();
");

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