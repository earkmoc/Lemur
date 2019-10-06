<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$baza="Inez2017";
$data='2017-04-30';
$lp=1419;
$nazwa='Listy p³ac z okresu: 01.04.2017 - 30.04.2017';

$w=mysqli_query($link, "
select *
  from $baza.nordpol
 where DATA='$data' 
   and LP=$lp
order by PZ
");

$suma=0;
$idpracownika=0;
while($r=mysqli_fetch_array($w))
{
	if(substr($r['MA'],0,3)=='241')
	{
		$idpracownika=str_replace('241-','',$r['MA']);
		$pracownik=mysqli_fetch_row(mysqli_query($link, "select NAZWISKOIMIE from $baza.pracownicy where ID=$idpracownika"))[0];
	}
	if(substr($r['WINIEN'],0,3)=='241')
	{
		$idpracownika=str_replace('241-','',$r['WINIEN']);
		$pracownik=mysqli_fetch_row(mysqli_query($link, "select NAZWISKOIMIE from $baza.pracownicy where ID=$idpracownika"))[0];
	}
	if(substr($r['WINIEN'],0,3)=='231')
	{
		$idpracownika=str_replace('231-','',$r['WINIEN']);
		$pracownik=mysqli_fetch_row(mysqli_query($link, "select NAZWISKOIMIE from $baza.pracownicy where ID=$idpracownika"))[0];
	}
	if	( (substr($r['WINIEN'],0,3)=='404')
		&&(substr($r['MA'],0,3)=='241')
		)
	{
		$suma=0;
	}
	if	( (substr($r['WINIEN'],0,3)=='404')
		||(substr($r['WINIEN'],0,3)=='405')
		)
	{
		$suma+=$r['KWOTA'];
	}
	if	( (substr($r['WINIEN'],0,3)=='503')
		)
	{
/*
		mysqli_query($link, $q="
			update nordpol
			   set KWOTA='$suma'
			 where DATA='$data'
			   and LP=$lp
			   and ID=$r[ID]
		");
*/
		
		if($suma<>($kw=mysqli_fetch_row(mysqli_query($link, $q="
			select KWOTA
			  from nordpol
			 where DATA='$data'
			   and LP=$lp
			   and ID=$r[ID]
		"))[0]))
		{
			echo "Pracownik $idpracownika, $pracownik: $suma <> $kw <br>";
		}
	}
	mysqli_query($link, $q="
		update $baza.nordpol
		   set NAZ1='$nazwa'
		     , NAZ2='$pracownik'
		 where DATA='$data'
		   and LP=$lp
		   and ID=$r[ID]
	");
}