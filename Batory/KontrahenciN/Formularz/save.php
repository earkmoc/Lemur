<?php

if(!@$_POST['NAZWA'])
{
	$_POST['NAZWA']=$_POST['PSEUDO'];
}

if(!@$_POST['TRESC'])
{
	$_POST['TRESC']=$_POST['NAZWA'];
}

if($_POST['NUMER']*1==0)
{
	$tableInit='NUMER desc';
	require("setup.php");
	$_POST['NUMER']=mysqli_fetch_row(mysqli_query($link, "
		select NUMER from $tabela where 1 order by NUMER desc limit 1
	"))[0]+1;
}

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveFormFields.php");
