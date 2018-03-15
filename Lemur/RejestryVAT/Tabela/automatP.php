<?php

require("automat.php");

$w=mysqli_fetch_row(mysqli_query($link,$q="
	select ID
	     , NETTO
	  from dokumentr
	 where KTO=$ido
  order by ID desc 
	 limit 1
"));
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

$idr=$w[0];
$netto=$w[1];
$podzial=mysqli_fetch_row(mysqli_query($link, "select TRESC from slownik where TYP='inne' and SYMBOL='Podzial'"))[0];

if($podzial*1>0)
{
	mysqli_query($link,$q="
		update dokumentr
		   set CZAS=Now()
			 , TYP='RPZ'
		 where ID=$idr
	");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

	$vat=round($vat*$podzial*0.01,2);

	mysqli_query($link,$q="
		insert
		  into dokumentr
		   set ID_D='$idd'
			 , KTO='$ido'
			 , CZAS=Now()
			 , TYP='RZM'
			 , NETTO='$netto'
			 , STAWKA='$stawka'
			 , VAT='$vat'
			 , BRUTTO='$brutto'
			 , OKRES='$okres'
	");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

	mysqli_query($link,$q="
		update dokumenty
		   set CZAS=Now()
			 , PODATEK_VAT='$vat'
		 where ID=$idd
	");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
}