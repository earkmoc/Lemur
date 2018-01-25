<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$_POST['USER']=$_SESSION['osoba_id'];
$_POST['CZASZMIANY']=date('Y-m-d H:i:s');

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveFormFields.php");
