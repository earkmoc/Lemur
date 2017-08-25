<?php

//die(print_r($_POST));
require("setup.php");

$ile=mysqli_fetch_row(mysqli_query($link,$q="
	select count(*)
	  from $tabela
	 where concat(rpad(DOK,8,' '),lpad(NR,8,' '),lpad(LP,8,' '),lpad(PZ,8,' '))
		  <concat(rpad('$_POST[pk]',8,' '),lpad('$_POST[nr]',8,' '),lpad('$_POST[lp]',8,' '),lpad('$_POST[pz]',8,' '))
  order by DOK, NR*1, LP*1, PZ*1
"))[0];

$_GET['str']=1+floor($ile/(($ido==10)?20:15));
$_GET['row']=1+$ile-(($_GET['str']-1)*(($ido==10)?20:15));

mysqli_query($link,$q="
	update tabeles
	   set WARUNKI=''
		 , SORTOWANIE=''
		 , NR_STR='$_GET[str]'
		 , NR_ROW='$_GET[row]'
	 where ID=$idTabeles
");

if (mysqli_error($link)) {
	die(mysqli_error($link).'<br>'.$q);
} else {
	header("location:../Tabela");
}
