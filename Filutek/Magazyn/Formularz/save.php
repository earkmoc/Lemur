<?php

if(!$_POST['INDEKS'])
{
	$tableInit='INDEKS*1 desc';
	require("setup.php");
	$_POST['INDEKS']=mysqli_fetch_row(mysqli_query($link, "
		select INDEKS from $tabela where 1 order by INDEKS*1 desc limit 1
	"))[0]+1;
}

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveFormFields.php");
