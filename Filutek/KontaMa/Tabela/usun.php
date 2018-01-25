<?php

require("setup.php");
require("{$_SESSION[INCLUDE_PATH]}/saveTablePosition.php");

mysqli_query($link,"
delete 
  from $tabela 
 where ID=$id
");
if (mysqli_error($link)) {
	die(mysqli_error($link));
} else {
	header("location:../Tabela");
}
