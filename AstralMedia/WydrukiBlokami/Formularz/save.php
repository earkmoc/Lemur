<?php

//print_r($_POST); die;

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$_POST['ID_OSOBYUPR']=$ido;
$_POST['CZASRUN']=date('Y-m-d H:i:s');
$_POST['BL1']=(!$_POST['BL1']?1:$_POST['BL1']);
$_POST['BL2']=(!$_POST['BL2']?$_POST['BL1']:$_POST['BL2']);
$_POST['BL1']=($_POST['BL1']*1==$_POST['BL1']?substr('0000'.$_POST['BL1'],-3,3):substr('0000'.$_POST['BL1'],-4,4));
$_POST['BL2']=($_POST['BL2']*1==$_POST['BL2']?substr('0000'.$_POST['BL2'],-3,3):substr('0000'.$_POST['BL2'],-4,4));

$filtr=mysqli_fetch_row(mysqli_query($link, $q="
	select OPIS
	  from filtry
	 where ID_TABELE=270
	   and NAZWA='{$_POST['RAPORT']}'
"))[0];

$w=mysqli_query($link, "
	select ID, NRBLOKU
	  from abonenci
	 where NRBLOKU between {$_POST['BL1']} and {$_POST['BL2']}
	   and $filtr
  order by NRBLOKU, NRMIESZK, ID
");

$i=0;
$zaznaczone='';
while	(	($r=mysqli_fetch_row($w))
		)
{
	++$i;
	if($i==1)
	{
		$_POST['BL1']=$r[1];
	}
	$_POST['BL2']=$r[1];
	$zaznaczone.=($zaznaczone?',':'').$r[0];
}
$_POST['CZASEND']=date('Y-m-d H:i:s');
$_POST['RAPORT']=$zaznaczone;
$_POST['ILE']=$i;

$noHeader=true;
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveFormFields.php");

$_POST['zaznaczone']=$zaznaczone;
//$_GET['wzor']=$_POST['WZOR'];
//require("{$_SERVER['DOCUMENT_ROOT']}/WydrukWzor.php");
header("Location:/WydrukWzor.php?wzor={$_POST['WZOR']}&zaznaczone=$zaznaczone");
