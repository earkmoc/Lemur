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
$widok=$tabela.'K';
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/formFields.php");

if($_GET['typy'])
{
	//die(print_r($fields));
	foreach($fields as $key => $value)
	{
		if($value['pole']=='TYP')
		{
			if(@$_GET['typDefault'])
			{
				$fields[$key]['query']=str_replace('where',"where ((TRESC like '%{$_GET['typy']}%') or (SYMBOL='{$_GET['typDefault']}')) and ",$fields[$key]['query']);
			}
			else
			{
				$fields[$key]['query']=str_replace('where',"where TRESC like '%{$_GET['typy']}%' and ",$fields[$key]['query']);
			}
			break;
		}
	}
}

$title="Dokumenty, ";
$title.=($kopia=($id<0)?"kopia ":"");
//$title.=($id?"ID=".abs($id):"nowa pozycja");
$title.=($id?"":"nowa pozycja");

//----------------------------------------------

$buttons=array();
$buttons[]=array('klawisz'=>'_Enter','nazwa'=>'Enter=Zapisz','akcja'=>"save.php?tabela=$tabela&id=$id");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj�cie','akcja'=>"../Tabela");
$buttons[]=array('klawisz'=>'Alt1','nazwa'=>'','js'=>"
	$('li').removeClass('active');
	$('div.tab-pane:not(#home)').removeClass('active');
	$('#liTowary').addClass('active');
	$('#Towary').addClass('active');
	$('#iframeTowary').focus();
");

//----------------------------------------------

$dane=array();

$typy=1;

//jeśli jest preferowany zbiór typów dokumentów luźno określony w "typy", to ustal jego konkretną postać typami po przecinkach, np.: ST, SU, SE
if($_GET['typy'])
{
	if(@$_GET['typDefault'])
	{
		$q="
		select group_concat(SYMBOL)
		  from slownik 
		 where TYP='dokumenty'
		   and  (  (TRESC like '%{$_GET['typy']}%')
				or (SYMBOL='{$_GET['typDefault']}')
				)
		";
	}
	else
	{
		$q="
		select group_concat(SYMBOL)
		  from slownik 
		 where TYP='dokumenty'
		   and TRESC like '%{$_GET['typy']}%'
		";
	}
	$typy=mysqli_fetch_row(mysqli_query($link, $q))[0];
	$typy.=(@$_GET['typDefault']?($typy?',':'').$_GET['typDefault']:'');
	$typy=str_replace(",","','",$typy);
	$typy="TYP IN ('$typy')";
}

if ($id==0)
{
	//użyj niektórych danych ostatniego dokumentu ze zbioru "typy"
	$ostatnio=mysqli_fetch_array(mysqli_query($link, $q="
	select *
	  from $tabela
	 where $typy
  order by ID desc
	 limit 1
	"));
	foreach($ostatnio as $k => $v)
	{
		if (in_array($k,array('PRZEDMIOT','TYP','OKRES')))
		{
			$dane[$k]=StripSlashes($v);
		}
	}
	$dane['NUMER']=(@$_GET['typDefault']<>'ZT'?'automat':'');
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
		if (!$_POST['CZAS'])		//pierwsze wywołanie "setup" tuż po wciśnięciu buttona opcji "Kopiuj"
		{
			mysqli_query($link, $q="
				create temporary table dokmTmp like dokumentm
			"); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q.'<br>'.mysqli_affected_rows($link));}
			mysqli_query($link, $q="
				select * from dokmTmp
			"); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q.'<br>'.mysqli_affected_rows($link));}
			mysqli_query($link, $q="
				ALTER TABLE dokmTmp CHANGE `ID` `ID` INT(11) NOT NULL
			"); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q.'<br>'.mysqli_affected_rows($link));}
			mysqli_query($link, $q="
				alter table dokmTmp drop primary key
			"); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q.'<br>'.mysqli_affected_rows($link));}
			mysqli_query($link, $q="
				insert 
				  into dokmTmp
				select *
				  from dokumentm
				 where ID_D=abs($id)
			"); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q.'<br>'.mysqli_affected_rows($link));}
			mysqli_query($link, $q="
				update dokmTmp
				   set ID=0
					 , ID_D=-1
					 , KTO=$ido
			"); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q.'<br>'.mysqli_affected_rows($link));}
			mysqli_query($link, $q="
				insert 
				  into dokumentm
				select *
				  from dokmTmp
			"); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q.'<br>'.mysqli_affected_rows($link));}
		}
		
		$id=0;
		$dane['ID']=0;	//dopisanie nowej pozycji
		$_SESSION["{$baza}DokumentyID_D"]=0;
	} 
	else
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

//jeśli dotąd nie było dokumentu ze zbioru "typy" to użyj typu domyślnego
if	( (!$dane['TYP'])
	&&(@$_GET['typDefault'])
	)
{
	$dane['TYP']=$_GET['typDefault'];
}

//jeśli w słowniku nie ma dokumentu tego typu to go dopisz
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

//jeśli ich nie ma, to pobranie NIP i nazwa kontrahenta z pól menu głównego
if	(  (!$dane['NIP'])
	&& (!$dane['NAZWA'])
	)
{
	$w=mysqli_query($link, $q="select * from tabeles where ID_OSOBY=$ido and ID_TABELE=0"); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
	$r=mysqli_fetch_array($w);
	$dane['NIP']=$r['WARUNKI'];
	$dane['NAZWA']=$r['SORTOWANIE'];
}

$dane['DDOKUMENTU']=date('Y-m-d');
$dane['DOPERACJI']=date('Y-m-d');
