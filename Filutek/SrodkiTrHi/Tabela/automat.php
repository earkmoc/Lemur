<?php

//die(print_r($_GET));

error_reporting(E_ERROR | E_PARSE | E_WARNING);//E_NOTICE | 

//automatyczne generowanie zapisów na podstawie danych z srodkizm

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$idd=$_GET[idd];
$idd=($idd==0?-1:$idd);

//usuniecie dotychczasowych zapisów
mysqli_query($link,$q="
	delete
	  from srodkihi
	 where ID_D='$idd'
	   and if(1*'$idd'=-1,KTO='$ido',1)
"); 
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

$zmiany=mysqli_query($link,$q="
	select *
	  from srodkizm
	 where ID_D='$idd'
	   and if(1*'$idd'=-1,KTO='$ido',1)
  order by DATA, ID
");
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

$dt='';
$wi=0;
$wu=0;
$st=0;
$waam=0;
$wi=0;
$wibo=0;
$wu=0;
if($zmiana=mysqli_fetch_array($zmiany))
{
	$dt=$zmiana['DATA'];
	$wi+=$zmiana['ZMWI'];
	$wibo+=$zmiana['ZMWI'];
	$wu+=$zmiana['ZMWU'];
	$st=$zmiana['ZMSTOPY'];

	mysqli_query($link,$q="
		insert
		  into srodkihi
		   set ID_D='$idd'
			 , KTO='$ido'
			 , CZAS=Now()
			 , DATA='$dt'
			 , WAAM='$waam'
			 , ZMWI='$zmiana[ZMWI]'
			 , WIBZ='$wi'
			 , ZMWU='$zmiana[ZMWU]'
			 , WUBZ='$wu'
			 , ZMSTOPY='$zmiana[ZMSTOPY]'
			 , STOPAB='$st'
	");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
	
	while(($st<>0)
		&&(round($wi,2)>0)
		)
	{
		$dt=substr($dt,0,7).'-01';
		$dt=mysqli_fetch_row(mysqli_query($link,$q="select Date_Add('$dt',interval 1 month)"))[0];
		if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

		$waam=round(($wibo*$st*0.01)/12,2);
		if($waam>$wi)
		{
			$waam=round($wi,2);
		}
		$wi-=$waam;
		$wu+=$waam;

		if($waam<>0)
		{
			mysqli_query($link,$q="
				insert
				  into srodkihi
				   set ID_D='$idd'
					 , KTO='$ido'
					 , CZAS=Now()
					 , DATA='$dt'
					 , WAAM='$waam'
					 , ZMWI='0'
					 , WIBZ='$wi'
					 , ZMWU='0'
					 , WUBZ='$wu'
					 , ZMSTOPY='0'
					 , STOPAB='$st'
			");
			if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
		}

		$zmiany=mysqli_query($link,$q="
			select *
			  from srodkizm
			 where ID_D='$idd'
			   and if(1*'$idd'=-1,KTO='$ido',1)
			   and left(DATA,7)=left('$dt',7)
		  order by DATA, ID
		");
		if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

		if($zmiana=mysqli_fetch_array($zmiany))
		{
			$dt=$zmiana['DATA'];
			$wi+=$zmiana['ZMWI'];
			if($wi<0)
			{
				$wi=0;
			}
			$wibo+=$zmiana['ZMWI'];
			if($wibo<0)
			{
				$wibo=0;
			}
			$wu+=$zmiana['ZMWU'];
			$st=$zmiana['ZMSTOPY'];

			mysqli_query($link,$q="
				insert
				  into srodkihi
				   set ID_D='$idd'
					 , KTO='$ido'
					 , CZAS=Now()
					 , DATA='$dt'
					 , WAAM=''
					 , ZMWI='$zmiana[ZMWI]'
					 , WIBZ='$wi'
					 , ZMWU='$zmiana[ZMWU]'
					 , WUBZ='$wu'
					 , ZMSTOPY='$zmiana[ZMSTOPY]'
					 , STOPAB='$st'
			");
			if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
		}
	}
}

if ($idd)
{
	$rok=mysqli_fetch_row(mysqli_query($link,$q="
				  select OPIS 
					from slownik
				   where TYP='parametry'
					 and SYMBOL='SrodkiTr'
					 and TRESC='rok'
	"))[0];
	if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}

	require_once("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/SrodkiTrOblicz.php");
	Oblicz($link, $idd, $rok);
/*
	for($mc=1;$mc<=12;++$mc)
	{
		if($waam=mysqli_fetch_row(mysqli_query($link, $q="select sum(WAAM) from srodkihi where ID_D=$idd and Year(DATA)=Year(CurDate()) and Month(DATA)=$mc"))[0])
		{
			mysqli_query($link, $q="update srodkitr set WMUA$mc=$waam where ID=$idd");
			if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
		}
	}
*/
}

header('location:..');
