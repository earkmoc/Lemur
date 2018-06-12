<?php

require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

$w=mysqli_query($link, $q="
	select ID
	  from $tabela 
	 where TYP='FZ'
	   and year(DDOKUMENTU)=2018
  order by DDOKUMENTU, ID
");if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

$pz=1;
while($r=mysqli_fetch_row($w))
{
	$idd=$r[0];
	$cpz=substr('000'.($pz++),-4,4).'-'.date('y');
	mysqli_query($link, $q="update dokumenty set DODOK='PZ $cpz' where ID=$idd");if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
}

header("location:../Tabela");
