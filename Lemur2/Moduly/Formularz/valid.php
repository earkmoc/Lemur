<?php

@session_start();
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$wynik='';
switch($_REQUEST['validType'])
{
	case 'rok':
		$wartosc=$_REQUEST['val']*1;
		$wynik=((1900<=$wartosc)&&($wartosc<=2100)?'':'nieprawid³owa warto¶æ');
		break;
}
echo $wynik;
