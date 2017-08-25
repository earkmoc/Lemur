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

mysqli_query($link,$q="
	update dokumentr
	   set CZAS=Now()
		 , TYP='RPZ'
	 where ID=$idr
");
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

$netto=round($netto*0.89,2);
$vat=round($netto*$stawka*0.01,2);
$brutto=$netto+$vat;

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
