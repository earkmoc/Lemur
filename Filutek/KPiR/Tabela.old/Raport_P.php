<?php

for($i=1;$i<9;++$i)
{
	$sumyStrony[$polaP[$i]]=0;
	$sumyPoprzednich[$polaP[$i]]=$sumyRazem[$polaP[$i]];
}

while($r=mysqli_fetch_array($w))
{
	++$lp;
	echo "
		<tr style='font-size: $_POST[wielkosc]px; font-family: $_POST[czcionka];'>
	";
	$col=0;
	foreach($polaP as $pole)
	{
		++$col;
		if(!($col==1||$col==8||$col==10))
		{
			$sumyStrony[$pole]+=$r[$pole];
			$sumyRazem[$pole]+=$r[$pole];
			$r[$pole]=(($r[$pole]==0)?'&nbsp;':number_format($r[$pole],2));
		}
		echo "
			<td align='".($col==8||$col==10?'left':'right')."'>$r[$pole]</td>";
	}
	echo "
		</tr>
	";
}

echo "<tr style='font-size: $_POST[wielkosc]px;'>
		<td rowspan='3' style='border: 0 0 0 0'> </td>";
for($col=2;$col<=9;++$col)
{
	$pole=$polaP[$col-1];
	$r[$pole]=$sumyStrony[$pole];
	$r[$pole]=(($r[$pole]==0)?'&nbsp;':number_format($r[$pole],2));
	echo "<td align='right' style='border-top: double black'>$r[$pole]</td>\n";
}
echo "</tr>\n";

echo "<tr style='font-size: $_POST[wielkosc]px;'>\n";
for($col=2;$col<=9;++$col)
{
	$pole=$polaP[$col-1];
	$r[$pole]=$sumyPoprzednich[$pole];
	$r[$pole]=(($r[$pole]==0)?'&nbsp;':number_format($r[$pole],2));
	echo "<td align='right'>$r[$pole]</td>\n";
}
echo "</tr>\n";

echo "<tr style='font-size: $_POST[wielkosc]px;'>\n";
for($col=2;$col<=9;++$col)
{
	$pole=$polaP[$col-1];
	$r[$pole]=$sumyRazem[$pole];
	$r[$pole]=(($r[$pole]==0)?'&nbsp;':number_format($r[$pole],2));
	echo "<td align='right'>$r[$pole]</td>\n";
}
echo "</tr>\n";
echo "</table>\n";
