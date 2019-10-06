<?php

//print_r($_POST); die;

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$_POST['ID_OSOBYUPR']=$ido;
$_POST['CZASRUN']=date('Y-m-d H:i:s');

$filtr=mysqli_fetch_row(mysqli_query($link, $q="
	select OPIS
	  from filtry
	 where ID_TABELE=270
	   and NAZWA='{$_POST['RAPORT']}'
"))[0];

$w=mysqli_query($link, "
	select ID
	  from abonenci
	 where ID>={$_POST['ID1']}
	   and $filtr
  order by ID
");

$i=0;
$zaznaczone='';
while	(	($r=mysqli_fetch_row($w))
		&&	($i<$_POST['ILE'])
		)
{
	++$i;
	if($i==1)
	{
		$_POST['ID1']=$r[0];
	}
	$_POST['ID2']=$r[0];
	$zaznaczone.=($zaznaczone?',':'').$r[0];
}
$_POST['CZASEND']=date('Y-m-d H:i:s');
$_POST['RAPORT']=$zaznaczone;

$noHeader=true;
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveFormFields.php");

$_POST['zaznaczone']=$zaznaczone;
//$_GET['wzor']=$_POST['WZOR'];
//require("{$_SERVER['DOCUMENT_ROOT']}/WydrukWzor.php");
header("Location:/WydrukWzor.php?wzor={$_POST['WZOR']}&zaznaczone=$zaznaczone");
