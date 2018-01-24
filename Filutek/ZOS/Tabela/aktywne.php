<?php

require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

$idTabeles=($idTabeles?$idTabeles:0);

mysqli_query($link,$q="
	update tabeles
	   set WARUNKI=if(WARUNKI='','(UMWUR<>0)','')
	 where ID=$idTabeles
");
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

header("location:index.php");
