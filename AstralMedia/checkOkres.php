<?php

require('dbconnect.php');

$kl='makler2010';
$dk='dokumenty';
$rej='dokumentr';
$od='2010-01-01';
$do='2010-12-31';

echo "Sprawdzanie okresu sprawozdawczego dokumentów i zak³adek:";
echo "<table border='1' cellspacing='0' cellpadding='5'>";

$lp=0;
$zDK=mysqli_query($link,"select * from $kl.$dk");
while($dokument=mysqli_fetch_array($zDK))
{
	++$lp;
	$zREJ=mysqli_query($link,"select * from $kl.$rej where ID_D=$dokument[ID]");
	while($rejestr=mysqli_fetch_array($zREJ))
	{
		if($rejestr['OKRES']<>substr($dokument['DOPERACJI'],0,7))
		{
			echo "<tr>";
			echo "<td>$lp.</td><td>$dokument[ID]</td><td>$dokument[TYP]</td><td>$dokument[NUMER]</td><td>$dokument[DOPERACJI]</td><td>$rejestr[OKRES]</td>";
			echo "</tr>";
		}
	}
}
echo "</table>";

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
	 where $kl.$dk.DOPERACJI between '$od' and '$do'
  group by $kl.$dk.ID
	having sn<>dn
		or sv<>dv
		or sb<>db
  order by $kl.$dk.DOPERACJI
");

echo "Sprawdzanie dokumentów (wy¿ej) i zak³adki rejestrów (ni¿ej):";
echo "<table border='1' cellspacing='0' cellpadding='5'>";
$lp=0;
while($dokument=mysqli_fetch_array($delty))
{
	++$lp;
	//die(print_r($delta));
	echo "<tr>";
	echo "<td>$lp.</td><td>$dokument[ID]</td><td>$dokument[TYP]</td><td>$dokument[NUMER]</td><td>$dokument[DOPERACJI]</td><td>$dokument[dn]</td><td>$dokument[dv]</td><td>$dokument[db]</td>";
	echo "</tr>";
	echo "<tr>";
	echo "<td colspan='5'></td><td>$dokument[sn]</td><td>$dokument[sv]</td><td>$dokument[sb]</td>";
	echo "</tr>";
	if	( ($dokument['db']==$dokument['sb'])
		&&($dokument['dn']==0)
		&&($dokument['dv']==0)
		)
	{
		mysqli_query($link,$q="
			update $kl.$dk
			   set $kl.$dk.NETTOVAT=$dokument[sn]
				 , $kl.$dk.PODATEK_VAT=$dokument[sv]
			 where $kl.$dk.ID=$dokument[ID]
			 limit 1
		");
	}
}
echo "</table>";


$delty=mysqli_query($link,"
	select $kl.$dk.ID
		 , $kl.$dk.TYP
		 , $kl.$dk.NUMER
		 , $kl.$dk.DOPERACJI
		 , $kl.$dk.NETTOVAT as dn
		 , $kl.$dk.PODATEK_VAT as dv
		 , $kl.$dk.WARTOSC as db
	  from $kl.$dk 
 left join $kl.$rej 
		on $kl.$rej.ID_D=$kl.$dk.ID
	 where ($kl.$dk.DOPERACJI between '$od' and '$do')
	   and isnull($kl.$rej.ID)
  order by $kl.$dk.DOPERACJI
");

echo "Sprawdzanie dokumentów (wy¿ej) i zak³adki rejestrów (ni¿ej):";
echo "<table border='1' cellspacing='0' cellpadding='5'>";
$lp=0;
while($dokument=mysqli_fetch_array($delty))
{
	++$lp;
	//die(print_r($delta));
	echo "<tr>";
	echo "<td>$lp.</td><td>$dokument[ID]</td><td>$dokument[TYP]</td><td>$dokument[NUMER]</td><td>$dokument[DOPERACJI]</td><td>$dokument[dn]</td><td>$dokument[dv]</td><td>$dokument[db]</td>";
	echo "</tr>";
	echo "<tr>";
	echo "<td colspan='5'></td><td>$dokument[sn]</td><td>$dokument[sv]</td><td>$dokument[sb]</td>";
	echo "</tr>";
	if	( ($dokument['db']==$dokument['sb'])
		&&($dokument['dn']==0)
		&&($dokument['dv']==0)
		)
	{
		mysqli_query($link,$q="
			update $kl.$dk
			   set $kl.$dk.NETTOVAT=$dokument[sn]
				 , $kl.$dk.PODATEK_VAT=$dokument[sv]
			 where $kl.$dk.ID=$dokument[ID]
			 limit 1
		");
	}
}
echo "</table>";
