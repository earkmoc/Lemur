<?php

require("setup.php");

mysqli_query($link, $q="
delete 
  from $tabela 
 where ID=$_GET[id]
");
if (mysqli_error($link)) {
	die(mysqli_error($link)."<br>$q");
} else {
	header("location:../Tabela");
}
