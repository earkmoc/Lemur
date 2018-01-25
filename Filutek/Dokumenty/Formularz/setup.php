<?php

$id='0';
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");
$_SESSION["{$baza}DokumentyID_D"]=$id;
$typ=$_SESSION['typ'];

// ----------------------------------------------
// Parametry widoku

$tabela='dokumenty';
$widok=$tabela;
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/formFields.php");

$title="Dokumenty, ";
$title.=($kopia=($id<0)?"kopia ":"");
$title.=($id?"ID=".abs($id):"nowa pozycja");

//----------------------------------------------

$buttons=array();
$buttons[]=array('klawisz'=>'_Enter','nazwa'=>'Enter=Zapisz','akcja'=>"save.php?tabela=$tabela&id=$id");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=Anuluj','akcja'=>"../Tabela");
$buttons[]=array('klawisz'=>'Alt1','nazwa'=>'','js'=>"
	$('li').removeClass('active');
	$('div.tab-pane:not(#home)').removeClass('active');
	$('#liTowary').addClass('active');
	$('#Towary').addClass('active');
	$('#iframeTowary').focus();
");
$buttons[]=array('klawisz'=>'AltN'
                ,'nazwa'=>'Alt+N=Nabywcy'
				,'js'=>"$('#myModalN').modal('show')"
				);
$buttons[]=array('klawisz'=>'AltO'
                ,'nazwa'=>'Alt+O=Odbiorcy'
				,'js'=>"$('#myModalO').modal('show')"
				);
//----------------------------------------------

$dane=array();

if ($id==0)
{
	$ostatnio=mysqli_fetch_array(mysqli_query($link, "
	select *
	  from $tabela
	 where TYP='$typ'
  order by ID desc
	 limit 1
	"));
	foreach($ostatnio as $k => $v)
	{
		if (in_array($k,array('TYP')))
		{
			$dane[$k]=StripSlashes($v);
		}
	}
	if(substr($ostatnio['NUMER'],-2,2)<>date('y'))
	{
		$dane['NUMER']='0001'.'-'.date('y');
	}
	else
	{
		$dane['NUMER']=substr('000'.($ostatnio['NUMER']+1),-4,4).'-'.date('y');
	}
	$dane['TYP']=$typ;
	$dane['DWPROWADZE']=date('Y-m-d');
	$dane['DDOKUMENTU']=date('Y-m-d');
	$dane['DOPERACJI']=date('Y-m-d');
	$dane['DTERMIN']=date('Y-m-d');
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
	$dane['WARTOSC-WPLACONO']=$dane['WARTOSC']-$dane['WPLACONO'];
	if ($kopia)
	{
		$id=0;
		$dane['ID']=0;	//dopisanie nowej pozycji
		$_SESSION["{$baza}DokumentyID_D"]=0;
	} else
	{
		if	( ($dane['GDZIE']!='bufor')
			||( ($dane['KTO']!=$ido)
			  &&($ido==0)
			  )
			)
		{
			unset($buttons[0]);
		}
	}
}

if($dane['TYP'])
{
	if(!mysqli_fetch_row(mysqli_query($link, $q="
		select count(*)
		  from slownik 
		 where TYP='dokumenty'
		   and SYMBOL='{$dane['TYP']}'
	"))[0])
	{
		mysqli_query($link, $q="
		insert
		  into slownik 
		   set TYP='dokumenty'
		     , SYMBOL='{$dane['TYP']}'
			 , TRESC='{$dane['TYP']}'
		");
	}
}
