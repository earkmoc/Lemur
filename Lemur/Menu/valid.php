<?php

@session_start();
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$wynik='';
switch($_REQUEST['validType'])
{
	case 'NIP':
		$wartosc=strtoupper(preg_replace('/[^0-9]/', '', $_REQUEST['val']));
		if($wartosc=='')
		{
			$wynik='';
		}
		else
		{
			if ($wynik=mysqli_fetch_row($w=mysqli_query($link, $q="select concat(NIP,',',NAZWA) from knordpol where replace(replace(replace(NIP,'-',''),'PL',''),' ','') like '%$wartosc%'"))[0]) 
			{
				$wynik.=',2'.mysqli_num_rows($w);
				$sets="WARUNKI='replace(replace(replace(NIP,\'-\',\'\'),\'PL\',\'\'),\' \',\'\') like \'%$wartosc%\'', ID_OSOBY=$ido, ID_TABELE=658, NR_STR=1, NR_ROW=1, NR_COL=4";
				mysqli_query($link,$q="insert into tabeles set $sets on duplicate key update $sets");
			}
			else
			{
				$wynik='nie ma takiego NIP w lokalnej bazie danych';
			}
		}
		break;
	case 'NAZWA':
		$wartosc=$_REQUEST['val'];
		if($wartosc=='')
		{
			$wynik='';
		}
		else
		{
			if ($wynik=mysqli_fetch_row($w=mysqli_query($link, $q="select concat(NIP,',',NAZWA) from knordpol where NAZWA like '%$wartosc%'"))[0]) 
			{
				$wynik.=',2'.mysqli_num_rows($w);
				$sets="WARUNKI='NAZWA like \'%$wartosc%\'', ID_OSOBY=$ido, ID_TABELE=658, NR_STR=1, NR_ROW=1, NR_COL=5";
				mysqli_query($link,$q="insert into tabeles set $sets on duplicate key update $sets");
			}
			else
			{
				$wynik='nie ma takiej nazwy kontrahenta w lokalnej bazie danych';
			}
		}
		break;
}
echo $wynik;
