<?php

require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

$od_netto=$_SESSION['od_netto'];

$idd=mysqli_fetch_row(mysqli_query($link, "
select ID_D
  from $tabela 
 where ID=$id
"))[0];

mysqli_query($link, "
delete 
  from $tabela 
 where ID=$id
");
if (mysqli_error($link)) {
	die(mysqli_error($link));
}

require("../przelicz.php");
