<?php

function SetStrRow($link, $id, $ileNaStrone=15)
{
	require('../Tabela/setup.php');

	$ileNaStrone=(($ido==10)?20:$ileNaStrone);

	$mandatory=($mandatory?$mandatory:'1');
	$q="select ID from $tabela where $mandatory order by $sortowanieDoLiczenia";
	$w=mysqli_query($link, $q);	//if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
	$row=mysqli_num_rows($w);
	while($r=mysqli_fetch_row($w))
	{
		$str=floor(($row-1)/($ileNaStrone))+1;
		if($r[0]==$id)
		{
			break;
		}
		--$row;
	}

	$row-=floor(($str-1)*$ileNaStrone);
	$resetWarunki=true;
	$resetSortowanie=true;
 	require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");
}
