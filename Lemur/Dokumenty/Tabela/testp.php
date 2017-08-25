<?php

header('location:test.php');
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$kl=$baza;
$dk='dokumenty';
$rej='dokumentr';

//----------------------------------------------------------------------------------------------------------------------------------------------

$delty=mysqli_query($link,"
	select $kl.$dk.ID
		 , $kl.$dk.TYP
		 , $kl.$dk.NUMER
		 , $kl.$dk.DOPERACJI
		 , $kl.$dk.NETTOVAT as dn
		 , $kl.$dk.PODATEK_VAT as dv
		 , $kl.$dk.WARTOSC as db
		 , sum($kl.$rej.NETTO) as sn
		 , sum($kl.$rej.VAT) as sv
		 , sum($kl.$rej.BRUTTO) as sb
	  from $kl.$dk 
 left join $kl.$rej 
		on $kl.$rej.ID_D=$kl.$dk.ID
	 where 1
  group by $kl.$dk.ID
	having sn<>dn
		or sv<>dv
		or sb<>db
  order by $kl.$dk.DOPERACJI
");

$lp=0;
while($dokument=mysqli_fetch_array($delty))
{
	mysqli_query($link,$q="
		update $kl.$dk
		   set $kl.$dk.NETTOVAT=$dokument[sn]
		 where $kl.$dk.ID=$dokument[ID]
		 limit 1
	");
	mysqli_query($link,$q="
		update $kl.$rej
		   set $kl.$rej.BRUTTO=$dokument[db]
		 where $kl.$rej.ID_D=$dokument[ID]
		 limit 1
	");
}
