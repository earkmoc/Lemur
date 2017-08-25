<?php

$id='0';
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");
$_SESSION["{$baza}DokumentyID_D"]=$id;

mysqli_query($link, "
	ALTER TABLE `dokumenty` CHANGE `NAZWA` `NAZWA` CHAR(120) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT ''
");

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
	$('#liRejestryVAT').addClass('active');
	$('#RejestryVAT').addClass('active');
	$('#iframeRejestryVAT').focus();
");
$buttons[]=array('klawisz'=>'Alt2','nazwa'=>'','js'=>"
	$('li').removeClass('active');
	$('div.tab-pane:not(#home)').removeClass('active');
	$('#liTowary').addClass('active');
	$('#Towary').addClass('active');
	$('#iframeTowary').focus();
");
$buttons[]=array('klawisz'=>'Alt3','nazwa'=>'','js'=>"
	$('li').removeClass('active');
	$('div.tab-pane:not(#home)').removeClass('active');
	$('#liDekrety').addClass('active');
	$('#Dekrety').addClass('active');
	$('#iframeDekrety').focus();
");
$buttons[]=array('klawisz'=>'Alt4','nazwa'=>'','js'=>"
	$('li').removeClass('active');
	$('div.tab-pane:not(#home)').removeClass('active');
	$('#liKPiR').addClass('active');
	$('#KPiR').addClass('active');
	$('#iframeKPiR').focus();
");
$buttons[]=array('klawisz'=>'Alt5','nazwa'=>'','js'=>"
	$('li').removeClass('active');
	$('div.tab-pane:not(#home)').removeClass('active');
	$('#liEwidSprz').addClass('active');
	$('#EwidSprz').addClass('active');
	$('#iframeEwidSprz').focus();
");
$buttons[]=array('klawisz'=>'Alt6','nazwa'=>'','js'=>"
	$('li').removeClass('active');
	$('div.tab-pane:not(#home)').removeClass('active');
	$('#liEwidPrzeb').addClass('active');
	$('#EwidPrzeb').addClass('active');
	$('#iframeEwidPrzeb').focus();
");
$buttons[]=array('klawisz'=>'AltK'
                ,'nazwa'=>'Kontrahenci'
				,'js'=>"$('#myModal').modal('show')"
				);
$buttons[]=array('klawisz'=>'AltP'
                ,'nazwa'=>'Przedmioty'
				,'js'=>"$('#myModalP').modal('show')"
				);
/*
$buttons[]=array('klawisz'=>'Alt0'
                ,'nazwa'=>''
				,'js'=>"$('#myModalKlepacz').modal('show')"
				);
*/
//----------------------------------------------

$dane=array();

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
		if (in_array($k,array('DOPERACJI','DDOKUMENTU','DWPLYWU','DWPROWADZE','DATAC','DATAP','TYP','OKRES')))
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
