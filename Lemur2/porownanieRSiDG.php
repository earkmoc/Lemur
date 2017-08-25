<?php

require('dbconnect.php');

$mc='12';
$rok='2016';
$kl="inez$rok";
$rokmc="$rok-$mc";

$dg='nordpol';
$rs='dokumentr';
$do='dokumenty';

$suma=0;

echo "Ró¿nica (DG) Dziennik G³ówny - (RS) Rejestr Sprzeda¿y:";
echo "<table border='1' cellspacing='0' cellpadding='5'>";
		echo "<tr>";
		echo "<td>vatDG</td>";
		echo "<td>vatRS</td>";
		echo "<td>roznica</td>";
		echo "<td>DG.Dowód</td>";
		echo "<td>dokumenty.id</td>";
		echo "<td>typ</td>";
		echo "<td>numer</td>";
		echo "<td>data operacyjna</td>";
		echo "</tr>";

$zDG=mysqli_query($link,"select * from $kl.$dg where ($dg.MA like '%222-23%') and ($dg.NR=$mc)");
while($dekret=mysqli_fetch_array($zDG))
{
	$nrFaktury=$dekret['NAZ1'];
	$vatDG=$dekret['KWOTA'];
	
	$w=mysqli_query($link,"select * from $kl.$do where NUMER='$nrFaktury' and left(DOPERACJI,7)='$rokmc'");
	$dok=mysqli_fetch_array($w);
	$idd=$dok['ID'];
	$typ=$dok['TYP'];
	$num=$dok['NUMER'];
	$dop=$dok['DOPERACJI'];
	
	$vatRS=mysqli_fetch_row(mysqli_query($link,"select VAT from $kl.$rs where ID_D=$idd"))[0];
	if($vatDG<>$vatRS)
	{
		$roznica=($vatDG-$vatRS);
		$suma+=$roznica;
		echo "<tr>";
		echo "<td align='right'>$vatDG</td>";
		echo "<td align='right'>$vatRS</td>";
		echo "<td align='right'>$roznica</td>";
		echo "<td>$dekret[NAZ1]</td>";
		echo "<td>$idd</td>";
		echo "<td>$typ</td>";
		echo "<td>$num</td>";
		echo "<td>$dop</td>";
		echo "</tr>";
	}
}
echo "<tr>";
echo "<td>Suma</td>";
echo "<td>ró¿nic</td>";
echo "<td align='right'>$suma</td>";
echo "</tr>";

echo "</table>";

echo "<hr>";

echo "Ró¿nica (DG) Dziennik G³ówny - (RZ) Rejestr Zakupu:";
echo "<table border='1' cellspacing='0' cellpadding='5'>";
		echo "<tr>";
		echo "<td align='right'>vatDG</td>";
		echo "<td align='right'>vatRZ</td>";
		echo "<td align='right'>roznica</td>";
		echo "<td>DG.Dowód</td>";
		echo "<td>dokumenty.id</td>";
		echo "<td>typ</td>";
		echo "<td>numer</td>";
		echo "<td>data operacyjna</td>";
		echo "</tr>";

$suma=0;
$zDG=mysqli_query($link,"select * from $kl.$dg where ($dg.WINIEN like '%223%') and ($dg.NR=$mc)");
while($dekret=mysqli_fetch_array($zDG))
{
	$nrFaktury=$dekret['NAZ1'];
	$vatDG=$dekret['KWOTA'];

	$w=mysqli_query($link,"select * from $kl.$do where NUMER='$nrFaktury' and left(DOPERACJI,7)='$rokmc' and TYP<>'ST'");
	$dok=mysqli_fetch_array($w);
	$idd=$dok['ID'];
	$typ=$dok['TYP'];
	$num=$dok['NUMER'];
	$dop=$dok['DOPERACJI'];
	
	$vatRS=mysqli_fetch_row(mysqli_query($link,"select VAT from $kl.$rs where ID_D=$idd"))[0];
	if($vatDG<>$vatRS)
	{
		$roznica=($vatDG-$vatRS);
		$suma+=$roznica;
		echo "<tr>";
		echo "<td align='right'>$vatDG</td>";
		echo "<td align='right'>$vatRS</td>";
		echo "<td align='right'>$roznica</td>";
		echo "<td>$dekret[NAZ1]</td>";
		echo "<td>$idd</td>";
		echo "<td>$typ</td>";
		echo "<td>$num</td>";
		echo "<td>$dop</td>";
		echo "</tr>";
	}
}

echo "<tr>";
echo "<td>Suma</td>";
echo "<td>ró¿nic</td>";
echo "<td align='right'>$suma</td>";
echo "</tr>";

echo "</table>";


/*
$zDG=mysqli_query($link,"select * from $kl.$dg where ($dg.NAZ2 IN ('','Zakup materia³ów i energii','Zakup us³ug','Sprzeda¿ towarów')) and ($dg.NR=$mc)");
while($dekret=mysqli_fetch_array($zDG))
{
	$nrFaktury=$dekret['NAZ1'];
	$w=mysqli_query($link,"select * from $kl.$do where NUMER='$nrFaktury' and left(DOPERACJI,7)='$rokmc'");
	$dok=mysqli_fetch_array($w);
	$idd=$dok['ID'];
	$naz=$dok['NAZWA'];
	
	mysqli_query($link,"update $kl.$dg SET NAZ2='$naz' where ID=$dekret[ID]");
}
*/