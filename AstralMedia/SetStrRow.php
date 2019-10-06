<?php

function SetStrRow($link, $id)
{
	require('../Tabela/setup.php');

	$sortowanie='DOPERACJI desc, ID desc';
	$mandatory=($mandatory?$mandatory:'1');
	$q="select ID from dokumenty where $mandatory order by $sortowanie";
	$w=mysqli_query($link, $q);
	$row=mysqli_num_rows($w);
	while($r=mysqli_fetch_row($w))
	{
		$str=floor(($row-1)/(($ido==10)?20:15))+1;
		if($r[0]==$id)
		{
			break;
		}
		--$row;
	}

	$row-=floor(($str-1)*(($ido==10)?20:15));
	require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");
}
