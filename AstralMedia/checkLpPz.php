<?php

require('dbconnect.php');

$kl='inez2016';
$dg='nordpol';

echo "Sprawdzenie numerowania LP PZ dla DK 11:";
echo "<table border='1' cellspacing='0' cellpadding='5'>";
		echo "<tr>";
		echo "<td>DOK</td>";
		echo "<td>NR</td>";
		echo "<td>LP</td>";
		echo "<td>PZ</td>";
		echo "</tr>";

$lp=0;
$pz=0;
$zDG=mysqli_query($link,"select * from $kl.$dg where ($dg.NR=11) order by DOK, NR*1, LP*1, PZ*1");
while($dekret=mysqli_fetch_array($zDG))
{
	$lp=(($lp==0)?$dekret['LP']:$lp);
	$pz=(($lp<>$dekret['LP'])?1:$pz+1);
	$lp=(($lp<>$dekret['LP'])?$lp+1:$lp);
	if(	($lp<>$dekret['LP'])
	  ||($pz<>$dekret['PZ'])
	  )
	{
		echo "<tr>";
		echo "<td>$dekret[DOK]</td>";
		echo "<td>$dekret[NR]</td>";
		echo "<td>$dekret[LP]</td>";
		echo "<td>$dekret[PZ]</td>";
		echo "</tr>";
		$lp=$dekret['LP'];
		$pz=$dekret['PZ'];
	}
}
echo "</table>";

