<?php

require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

$idTabeles=($idTabeles?$idTabeles:0);

$w=mysqli_query($link,$q="
	select *
	  from $tabela
	 where ID_OSOBYUPR=$ido
  order by abs(SALDOWN)+abs(SALDOMA)
");
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

$ids='';
$popID=0;
$popSaldo=0;
$popStrona='';
$curSaldo=0;
while($r=mysqli_fetch_array($w))
{
	$curSaldo=abs($r['SALDOWN'])+abs($r['SALDOMA']);
	$curStrona=(abs($r['SALDOWN'])?'Wn':'Ma');
	if(	($curSaldo>0)
	  &&($curSaldo==$popSaldo)
	  &&($curStrona!=$popStrona)
	  )
	{
		$ids.=($ids?',':'').$r['ID'].','.$popID;
	}
	$popStrona=$curStrona;
	$popSaldo=$curSaldo;
	$popID=$r['ID'];
}

mysqli_query($link,$q="
	update tabeles
	   set SORTOWANIE='abs(SALDOWN)+abs(SALDOMA)'
		 , WARUNKI='$tabela.ID IN ($ids)'
	 where ID=$idTabeles
");
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

header("location:index.php");
