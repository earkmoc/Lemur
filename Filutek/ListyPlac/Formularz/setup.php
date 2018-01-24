<?php

$id='0';
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");
$_SESSION["{$baza}ListyPlacID_D"]=$id;

// ----------------------------------------------
// Parametry widoku

$tabela='listyplac';
$widok=$tabela;
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/formFields.php");

$title='Lista p³ac, ';
$title.=($kopia=($id<0)?"kopia ":"");
$title.=($id?"ID=".abs($id):"nowa lista");

//----------------------------------------------

$buttons=array();
$buttons[]=array('klawisz'=>'_Enter','nazwa'=>'Enter=Zapisz','akcja'=>"save.php?tabela=$tabela&id=$id");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=Anuluj','akcja'=>"../Tabela");
$buttons[]=array('klawisz'=>'Alt1','nazwa'=>'','js'=>"
	$('li').removeClass('active');
	$('div.tab-pane:not(#home)').removeClass('active');
	$('#liSpecyfikacja').addClass('active');
	$('#Specyfikacja').addClass('active');
	$('#iframeSpecyfikacja').focus();
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
		if(mysqli_fetch_row(mysqli_query($link, $q="
			select count(*) from listyplacp where ID_D=-1 and KTO=$ido
		"))[0]==0)
		{
			$x=mysqli_fetch_row(mysqli_query($link, $q="
				select ID+1 from listyplacp order by ID desc limit 1
			"))[0]; if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
			mysqli_query($link, $q="
				create temporary table tmp like listyplacp
			"); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
			mysqli_query($link, $q="
				ALTER TABLE tmp MODIFY ID INT NOT NULL;
			"); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
			mysqli_query($link, $q="
				ALTER TABLE tmp DROP PRIMARY KEY;
			"); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
			mysqli_query($link, $q="
				insert 
				  into tmp
				select *
				  from listyplacp
				 where ID_D=abs($id)
			"); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
			mysqli_query($link, $q="
				update tmp
				   set ID=0
					 , ID_D=-1
					 , KTO=$ido
					 , CZAS=Now()
			"); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
			mysqli_query($link, $q="
				insert 
				  into listyplacp
				select *
				  from tmp
			"); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
		}
		
		$id=0;
		$dane['ID']=0;	//dopisanie nowej pozycji
		$_SESSION["{$baza}ListyPlacID_D"]=0;
	}
}