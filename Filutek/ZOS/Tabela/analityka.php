<?php

//die(print_r($_GET));

$gets='maska='.$_GET['konto'];

require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

$w=mysqli_query($link,$q="
	select TRESC
		 , OPIS
	  from slownik
	 where TYP='parametry'
	   and SYMBOL='ZOS'
");
while($r=mysqli_fetch_array($w))
{
	if(	($r[0]=='data1')
	  ||($r[0]=='data2')
	  ||($r[0]=='gdzie')
	  )
	{
		$gets.='&'.$r[0].'='.StripSlashes($r[1]);
	}
}

header("location:/$bazaLinku/AOK/Tabela/przetwarzaj.php?$gets");
