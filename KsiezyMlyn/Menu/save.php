<?php

$_GET['mm']=$_REQUEST['option']*1;
$_GET['m']=ord(str_ireplace($_GET['mm'],'',$_REQUEST['option']));

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveMenuPosition.php");
