<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$id=$_GET['id'];
$rok=$_GET['rok'];
$wynik=array();

$q="
select *
  from absencje
 where ID_D='$id'
   and left(DATA,4)='$rok'
   and KOD<>''
";
$w=mysqli_query($link,$q); if(mysqli_error($link)) {echo "Error: ".$_SESSION['error'].=mysqli_error($link)." in $q";}
while($r=mysqli_fetch_array($w))
{
	$wynik[]=$r;
}

$q="
select UWAGI
  from pracownicy
 where ID='$id'
";
$w=mysqli_query($link,$q); if(mysqli_error($link)) {echo "Error: ".$_SESSION['error'].=mysqli_error($link)." in $q";}
while($r=mysqli_fetch_array($w))
{
	$wynik[]='UWAGI: '.$r[0];
}

//print_r($wynik);die;
if($wynik=json_encode($wynik))
{
	echo $wynik;
} 
else 
{
	echo 'Error: json_encode';
}
