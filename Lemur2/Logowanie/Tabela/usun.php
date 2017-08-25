<?php

require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

mysqli_query($link, $q="
delete 
  from $tabela 
 where ID=$id
");
if (mysqli_error($link)) {
	die(mysqli_error($link)."<br><br>$q");
} else {
	header("location:../Tabela");
}
