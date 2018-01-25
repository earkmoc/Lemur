<?php

require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

mysqli_query($link, "
update $tabela
   set STAWKA='zw.' 
 where TYP='RZW'
   and STAWKA='0%'
");
if (mysqli_error($link)) {
	die(mysqli_error($link));
} else {
	header("location:../Tabela");
}
