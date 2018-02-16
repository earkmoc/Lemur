<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

mysqli_query($link, $q="
update dokumentm
   set LOT=concat(replace(ILOSC,'.000',''),' ?')
 where ID_D=1266
   and KTO<>2
   and LOT=''
");
mysqli_query($link, $q="
update dokumentm
   set ILOSC=0
 where ID_D=1266
   and KTO<>2
");