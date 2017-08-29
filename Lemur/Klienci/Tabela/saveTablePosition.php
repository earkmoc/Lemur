<?php

//print_r(explode('/',$_GET['next']));
//die(print_r($_GET));
//$_GET['next']='';

function recurse_copy($src,$dst) 
{ 
	$dir = opendir($src); 
	@mkdir($dst); 
	while(false !== ( $file = readdir($dir)) ) 
	{ 
		if (( $file != '.' ) && ( $file != '..' )) 
		{ 
			if ( is_dir($src . '/' . $file) ) { 
				recurse_copy($src . '/' . $file,$dst . '/' . $file); 
			} 
			else 
			{ 
				copy($src . '/' . $file,$dst . '/' . $file); 
//echo "copy($src . '/' . $file,$dst . '/' . $file); <br>";
			} 
		} 
	} 
	closedir($dir); 
}

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

$_POST['PSKONT']=explode('/',$_GET['next'])[3];
$timestampLemur=mysqli_fetch_row(mysqli_query($link,"select CZAS from klienci where PSKONT='Lemur'"))[0];
$timestampLemur=max($timestampLemur,file_get_contents("{$_SERVER['DOCUMENT_ROOT']}/Lemur/timestamp.ver"));
$timestampKlienta=mysqli_fetch_row(mysqli_query($link,"select CZAS from klienci where PSKONT='$_POST[PSKONT]'"))[0];

if	( (!file_exists("{$_SERVER['DOCUMENT_ROOT']}/{$_POST['PSKONT']}/Menu/index.php"))
	||($timestampKlienta<=$timestampLemur)
	)
{
	if($_POST['PSKONT'])
	{
		$_POST['PSKONT']=substr($_POST['PSKONT'],0,20);
		mysqli_query($link,"update klienci set CZAS=Now() where PSKONT='$_POST[PSKONT]'");
		recurse_copy("{$_SERVER['DOCUMENT_ROOT']}/Lemur","{$_SERVER['DOCUMENT_ROOT']}/$_POST[PSKONT]");

		$tabela='dokumentr';
		mysqli_query($link, $q="ALTER TABLE $_POST[PSKONT].$tabela CHANGE `ID_D` `ID_D` INT(11) NOT NULL DEFAULT '-1'");
//			if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}
		mysqli_query($link, $q="ALTER TABLE $_POST[PSKONT].$tabela CHANGE `TYP` `TYP` char(10) NOT NULL DEFAULT ''");
//			if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}
		mysqli_query($link, $q="ALTER TABLE $_POST[PSKONT].$tabela ADD INDEX `TYP_OKRES` (`TYP`, `OKRES`)");
//			if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}
		mysqli_query($link, $q="ALTER TABLE $_POST[PSKONT].$tabela ADD INDEX `OKRES` (`OKRES`)");
//			if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}
		mysqli_query($link, $q="ALTER TABLE $_POST[PSKONT].$tabela ADD INDEX `TYP` (`TYP`)");
//			if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}
	}
}
