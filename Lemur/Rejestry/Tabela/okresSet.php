<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

mysqli_query($link,$q="
				  update slownik
					 set OPIS='$_POST[okres]'
				   where TYP='dokumentr'
");

if (mysqli_error($link)) {
	die(mysqli_error($link));
} else {
	header("location:../Tabela");
}
