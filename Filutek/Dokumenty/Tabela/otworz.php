<?php

require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

mysqli_query($link, "update dokumenty set GDZIE=if(GDZIE='bufor','ksi�gi','bufor') where ID=$id");
header("location:../Tabela");
