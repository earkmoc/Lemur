<?php

require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

if($ido==1)
{
	mysqli_query($link, "update dokumenty set GDZIE=if(GDZIE='bufor','ksiêgi','bufor') where ID=$id");
}
header("location:../Tabela");
