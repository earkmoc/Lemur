<?php

function SetStrRow($link, $id, $ileNaStrone=15)
{
//$raport="0. q=$q; rows=$row; idTabeli=$idTabeli; id=$id\n";
	require('../Tabela/setup.php');

	$ileNaStrone=(($ido==10)?20:$ileNaStrone);

	$mandatory=($mandatory?$mandatory:'1');
	$q="select ID from $tabela where $mandatory order by $sortowanie";
	$w=mysqli_query($link, $q);
	$row=mysqli_num_rows($w);
//$raport.="1. q=$q; rows=$row; idTabeli=$idTabeli; id=$id\n";
	while($r=mysqli_fetch_row($w))
	{
		$str=floor(($row-1)/($ileNaStrone))+1;
//$raport.="; 2. row=$row; str=$str; id=$id; r[0]=$r[0]\n";
		if($r[0]==$id)
		{
			break;
		}
		--$row;
	}

	$row-=floor(($str-1)*$ileNaStrone);
//$raport.="; 3. row=$row; str=$str\n";
	$resetWarunki=true;
	$resetSortowanie=true;
//die(nl2br($raport));
 	require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");
}
