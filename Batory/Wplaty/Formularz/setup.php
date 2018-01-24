<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

// ----------------------------------------------
// Parametry widoku

$title="Wp³ata, ";
$title.=($kopia=($id<0)?"kopia ":"");
$title.=($id?"ID=".abs($id):"nowa pozycja");

$tabela='dokumentz';
$widok=$tabela;
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/formFields.php");

//----------------------------------------------

$buttons=array();
$buttons[]=array('klawisz'=>'_Enter','nazwa'=>'Enter=Zapisz','akcja'=>"save.php?tabela=$tabela&id=$id");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=Anuluj','akcja'=>"../Tabela");
$buttons[]=array('klawisz'=>'AltR'
                ,'nazwa'=>'Alt+R=Rozliczenia'
				,'js'=>"parent.$('#myModalRozliczenia').modal('show')"
				);
//----------------------------------------------

$dane=array();
$dane['CZAS']=date('Y-m-d H:i:s');
$dane['DATA']=date('Y-m-d');

if ($id==0)
{
	$numery=mysqli_fetch_row(mysqli_query($link,$q="select group_concat(PRZEDMIOT) from $tabela where ID_D<=0"))[0];
	$numery=str_replace(',',"','",$numery);
	$warunki=mysqli_fetch_row(mysqli_query($link,$q="select WARUNKI from tabeles where ID_OSOBY=$ido and ID_TABELE=716"))[0];
	if($wartosc=$_GET['nazwa'])
	{
		$warunki="NAZWA like '%$wartosc%'";
		$sets="WARUNKI='NAZWA like \'%$wartosc%\'', ID_OSOBY=$ido, ID_TABELE=716, NR_STR=1, NR_ROW=1, NR_COL=8";
		mysqli_query($link,$q="insert into tabeles set $sets on duplicate key update $sets");
	}
	$ostatnio=mysqli_fetch_array(mysqli_query($link, "
		select NUMER
			 , WARTOSC-WPLACONO as kwota
		  from dokumenty
		 where WARTOSC-WPLACONO<>0 and ($warunki) and (NUMER not IN ('$numery'))
	  order by DOPERACJI desc, ID desc
		 limit 1
	"));
	$dane['PRZEDMIOT']=$ostatnio['NUMER'];
	$dane['KWOTA']=$ostatnio['kwota'];
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
