<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

mysqli_query($link,$q="create index KONTO on knordpol(KONTO)");
mysqli_query($link,$q="create index NUMER on knordpol(NUMER)");
mysqli_query($link,$q="create index PSEUDO on knordpol(PSEUDO)");
mysqli_query($link,$q="create index NIP on knordpol(NIP)");

// ----------------------------------------------
// Parametry widoku

$tabela='zest1b';
$widok=$tabela;
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$title='Zestawienie Obrotów i Sald';
$tabela='zest1';
$widok=$tabela;
$mandatory="ID_OSOBYUPR=$ido";
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

//----------------------------------------------

$params="idTabeli=$idTabeli&row='+row+'&col='+col+'&str='+str+'&id=";
$esc="saveTablePosition.php?next=http://{$_SERVER['HTTP_HOST']}/$baza/Menu/&$params'+GetID()+'";

$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>$esc);
$buttons[]=array('klawisz'=>'Enter','nazwa'=>'Enter=Analityka','akcja'=>"analityka.php?$params'+GetID()+'&konto='+GetCol(2)+'");
$buttons[]=array('klawisz'=>'AltS','nazwa'=>'Szukaj','js'=>"$('#modalSzukaj').modal('show')");
$buttons[]=array('klawisz'=>'AltP','nazwa'=>'Przetwórz','akcja'=>"przetwarzanie.php?$params'+GetID()+'");
$buttons[]=array('klawisz'=>'AltW','nazwa'=>'Wydruk','akcja'=>"Wydruk.php?wydruk=Raporta&natab=$tabela&strona1=15&stronan=16&tytul=$title");
$buttons[]=array('klawisz'=>'AltU','nazwa'=>'Ukryj konta bez salda','akcja'=>"ukryj.php?$params'+GetID()+'");
$buttons[]=array('klawisz'=>'AltK','nazwa'=>'Kompensaty','akcja'=>"kompensaty.php?$params'+GetID()+'");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");

$w=mysqli_query($link,$q="
	select $tabela.KONTO
	  from $tabela
 left join knordpol
		on knordpol.KONTO=$tabela.KONTO
	 where isnull(knordpol.ID)
");
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

while($r=mysqli_fetch_row($w))
{
	if( ((substr($r[0],0,4)=='201-')
		||(substr($r[0],0,4)=='202-')
		||(substr($r[0],0,4)=='204-')
		||(substr($r[0],0,4)=='246-')
		)
		and(
			mysqli_fetch_row(mysqli_query($link,$q="
				select count(*)
				  from knordpol
				 where KONTO='$r[0]'
			"))[0]==0
		)
	  )
	{
		$konto=((substr($r[0],0,4)=='201-')?'202-':'201-').substr($r[0],4);
		$dane=mysqli_fetch_row(mysqli_query($link,$q="
			select *
			  from knordpol
			 where KONTO='$konto'
		"));
		if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

		if(count($dane))
		{
			$dane[0]=0;
			$dane[1]=$r[0];
			$dane="'".implode("','",$dane)."'";
			//die(print_r($dane));
			mysqli_query($link,$q="
				insert
				  into knordpol
				values ($dane)
			");
			if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
		}
		else
		{
			$numer=explode('-',$konto);
			$numer=$numer[count($numer)-1];
			$dane=mysqli_fetch_row(mysqli_query($link,$q="
				select *
				  from knordpol
				 where NUMER='$numer'
				   and '$numer'*1>0
			  order by if(	(KONTO like '201-%')
						 or	(KONTO like '202-%')
						 ,0,1
						 )
			"));
			if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

			if(count($dane))
			{
				$dane[0]=0;
				$dane[1]=$r[0];
				$dane[2]=($dane[2]?$dane[2]:$dane[5]);
				$dane="'".implode("','",$dane)."'";
				//die(print_r($dane));
				mysqli_query($link,$q="
					insert
					  into knordpol
					values ($dane)
				");
				if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
			}
		}
	}
}