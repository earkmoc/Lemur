<?php

while($r=mysqli_fetch_array($w))
{
	++$lp;
	echo "
		<tr style='font-size: $_POST[wielkosc]px; font-family: $_POST[czcionka];'>
	";
	$col=0;
	foreach($pola as $pole)
	{
		++$col;
		if(!($col==1||$col==2))
		{
			$r[$pole]=(($r[$pole]==0)?'&nbsp;':number_format($r[$pole],2));
		}
		if($col==1)
		{
			$r[$pole]=$lp;
		}
		echo "
			<td align='".($col==2?'center':'right')."'>$r[$pole]</td>";
	}
	echo "
		</tr>
	";
}

echo "<tr style='font-size: $_POST[wielkosc]px;'>
		<td rowspan='3' colspan='2' style='border: 0 0 0 0' align='right'>Razem:</td>";
foreach($sumyRazem as $suma)
{
	$suma=(($suma==0)?'&nbsp;':number_format($suma,2));
	echo "<td align='right' style='border-top: double black'>$suma</td>\n";
}
echo "</tr>\n";

echo "</table>\n";
