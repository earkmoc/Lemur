<?php

if  ( ($tabela<>'osoby')
	&&($widok<>'osoby')
	&&(!$_SESSION['osoba_id'])
	)
{
	header('Location:/Lemur2/Logowanie');
}

$fields=array();

$idTabeli=0;
$w=mysqli_query($linkLemur, $q="
	select ID, FORMULARZ
	  from tabele
	 where NAZWA='$widok'
	 limit 1
");
$i=0;
while(@$r=mysqli_fetch_row($w))
{
	$idTabeli=$r[0];
	$wiersze=explode("\n",stripSlashes($r[1]));
	foreach($wiersze as $wiersz)
	{
		if 	( ($i++==0)
			||(substr($wiersz,0,1)=="(")
			||(substr($wiersz,0,3)=="if(")
			||(substr($wiersz,0,7)=="format(")
			||(substr($wiersz,0,4)=="from")
			||(substr($wiersz,0,5)=="where")
			)
		{
			continue;
		}
		$kolumny[4]='';
		$kolumny=explode("|",$wiersz);
		$pole=trim($kolumny[0]);
		$nazwa=($kolumny[1]?trim($kolumny[1]):ucfirst(strtolower(trim($kolumny[0]))));
		$bezZer=(strpos($kolumny[2],'@Z')!==false);
		$pass=(strpos($kolumny[2],'pass')!==false);
		$checkbox=(strpos($kolumny[2],'checkbox')!==false);
		$szerokosc=(str_replace('@Z','',$kolumny[2])*1);
		$tmp=explode('/',$kolumny[2]); $wysokosc=(($tmp[1])*1);
		$tmp=explode('option:',$kolumny[2]); $query=($tmp[1]);
		$style=(strpos($kolumny[3],'style')!==false?$kolumny[3]:'');
		$align=(strpos($kolumny[3],'right')!==false?'right':'');
		$grid=($kolumny[4]*1);
		$tmp=explode(',',$kolumny[4]); $gridLabel=($tmp[1]*1);
		$gridrow=($kolumny[5]*1);
		$valid=$kolumny[6];
		//$nazwa=iconv ( 'iso-8859-2', 'utf-8', $nazwa);
		//if (!strpos($nazwa,'.')) {
		$data=( (substr($pole,0,4)=='DATA')
			  ||(substr($nazwa,0,4)=='Data') 
			  ||(substr($nazwa,0,6)=='Z dnia')
			  ||(substr($nazwa,0,6)=='Termin')
			  );
		$dataczas=(
			    (substr($nazwa,0,4)=='Czas') 
			  );
		$readonly=(
				(strpos($kolumny[3],'blue')!==false)?1:0
			  );

		$fields[]=array(
			 'pole'=>$pole
			,'nazwa'=>$nazwa
			,'bezZer'=>$bezZer
			,'szerokosc'=>$szerokosc
			,'wysokosc'=>$wysokosc
			,'style'=>$style
			,'align'=>$align
			,'query'=>$query
			,'grid'=>$grid
			,'gridLabel'=>$gridLabel
			,'gridrow'=>$gridrow
			,'data'=>$data
			,'dataczas'=>$dataczas
			,'readonly'=>$readonly
			,'pass'=>$pass
			,'checkbox'=>$checkbox
			,'valid'=>$valid
		);
	}
}
