<?php

require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

mysqli_query($link, "
	delete 
	  from listyplacp 
	 where ID_D=$id
"); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

mysqli_query($link, "
	delete 
	  from $tabela 
	 where ID=$id
");
if (mysqli_error($link)) {
	die(mysqli_error($link));
} else {
	header("location:../Tabela");
}
