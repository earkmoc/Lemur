<?php

$_GET['mm']=$_REQUEST['option']*1;
$_GET['m']=ord(str_ireplace($_GET['mm'],'',$_REQUEST['option']));
$_GET['NIP']=AddSlashes(str_replace("'","`",$_REQUEST['NIP']));
$_GET['NAZWA']=AddSlashes(str_replace(" and ","&",str_replace("'","`",$_REQUEST['NAZWA'])));	//iconv('utf-8','iso-8859-2',

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveMenuPosition.php");
