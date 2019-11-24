<?php

$wzor=$_GET['Wzory'];
$firma=$_GET['firma'];
require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");
$tabelaNazwa=strtolower((@$firma&&(!stripos($tabela,'_')||stripos($tabela,'_X'))?"{$firma}_{$tabela}":$tabela));

mysqli_query($link, "
delete 
  from $tabelaNazwa 
 where ID=$id
");
if (mysqli_error($link)) {
	die(mysqli_error($link));
} else {
	header("location:../Tabela/?Wzory=$wzor&firma=$firma");
}
