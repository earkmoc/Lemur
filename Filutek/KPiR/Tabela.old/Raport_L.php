<?php

for($i=6;$i<9;++$i)
{
	$sumyStrony[$polaL[$i]]=0;
	$sumyPoprzednich[$polaL[$i]]=$sumyRazem[$polaL[$i]];
}

while($r=mysqli_fetch_array($w))
{
	++$lp;
	echo "
		<tr style='font-size: $_POST[wielkosc]px; font-family: $_POST[czcionka];'>
	";
	$col=0;
	foreach($polaL as $pole)
	{
		++$col;
		if($col>6)
		{
			$sumyStrony[$pole]+=$r[$pole];
			$sumyRazem[$pole]+=$r[$pole];
			$r[$pole]=(($r[$pole]==0)?'&nbsp;':number_format($r[$pole],2));
		}
		echo "
			<td align='".($col==2?'center':($col==1||$col>6?'right':'left'))."'>$r[$pole]</td>";
	}
	echo "
		</tr>
	";
}

echo "<tr style='font-size: $_POST[wielkosc]px;'>
		<td colspan='5' rowspan='3' style='border: 0 0 0 0'> </td>
";
echo "	<td align='left' nowrap style='border-top: double black'>Suma strony</td>\n";
for($col=7;$col<=9;++$col)
{
	$pole=$polaL[$col-1];
	$r[$pole]=$sumyStrony[$pole];
	$r[$pole]=(($r[$pole]==0)?'':number_format($r[$pole],2));
	echo "<td align='right' style='border-top: double black'>$r[$pole]</td>\n";
}
echo "</tr>";

echo "<tr style='font-size: $_POST[wielkosc]px;'>";
echo "	<td align='left' nowrap>Przeniesienie z poprzedniej strony</td>\n";
for($col=7;$col<=9;++$col)
{
	$pole=$polaL[$col-1];
	$r[$pole]=$sumyPoprzednich[$pole];
	$r[$pole]=(($r[$pole]==0)?'':number_format($r[$pole],2));
	echo "<td align='right'>$r[$pole]</td>";
}
echo "</tr>\n";

echo "<tr style='font-size: $_POST[wielkosc]px;'>";
echo "	<td align='left' nowrap>Razem od pocz±tku roku</td>\n";
for($col=7;$col<=9;++$col)
{
	$pole=$polaL[$col-1];
	$r[$pole]=$sumyRazem[$pole];
	$r[$pole]=(($r[$pole]==0)?'':number_format($r[$pole],2));
	echo "<td align='right'>$r[$pole]</td>\n";
}
echo "</tr>\n";
echo "</table>\n";
