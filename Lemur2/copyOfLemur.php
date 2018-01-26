<?php

//require_once("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/copyOfLemur.php");

$timestampLemur=mysqli_fetch_row(mysqli_query($link,"select CZAS from Lemur2.klienci where PSKONT='Lemur'"))[0];
$timestampLemur=max($timestampLemur,file_get_contents("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/timestamp.ver"));
$timestampKlienta=mysqli_fetch_row(mysqli_query($link,"select CZAS from Lemur2.klienci where PSKONT='$_POST[PSKONT]'"))[0];

if	( (!file_exists("{$_SERVER['DOCUMENT_ROOT']}/{$_POST['PSKONT']}/Menu/index.php"))
	||($timestampKlienta<=$timestampLemur)
	)
{
	if	( ($_POST['PSKONT'])
		&&($_POST['PSKONT']<>'Batory')
		&&($_POST['PSKONT']<>'Filutek')
		)
	{
		$_POST['PSKONT']=substr($_POST['PSKONT'],0,20);
		mysqli_query($link,"update Lemur2.klienci set CZAS=Now() where PSKONT='$_POST[PSKONT]'");

		require_once("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/funkcje.php");
		recurse_copy("{$_SERVER['DOCUMENT_ROOT']}/Lemur","{$_SERVER['DOCUMENT_ROOT']}/$_POST[PSKONT]");

		$tabela='dokumentr';
		mysqli_query($link, $q="ALTER TABLE $_POST[PSKONT].$tabela CHANGE `ID_D` `ID_D` INT(11) NOT NULL DEFAULT '-1'");
		mysqli_query($link, $q="ALTER TABLE $_POST[PSKONT].$tabela CHANGE `TYP` `TYP` char(10) NOT NULL DEFAULT ''");
		mysqli_query($link, $q="ALTER TABLE $_POST[PSKONT].$tabela ADD INDEX `TYP_OKRES` (`TYP`, `OKRES`)");
		mysqli_query($link, $q="ALTER TABLE $_POST[PSKONT].$tabela ADD INDEX `OKRES` (`OKRES`)");
		mysqli_query($link, $q="ALTER TABLE $_POST[PSKONT].$tabela ADD INDEX `TYP` (`TYP`)");
	}
}
