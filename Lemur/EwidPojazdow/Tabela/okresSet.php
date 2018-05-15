<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$sets="TYP='parametry'
   , SYMBOL='wydrukepo'
   , TRESC='okres'
   , OPIS='$_POST[okres]'
";
mysqli_query($link,$q="
				  insert 
					into slownik
					 set $sets
 on duplicate key update $sets
");
if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}

mysqli_query($link,$q="
				  update ewidpoja
					 set OKRES='$_POST[okres]'
");
if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}

$w=mysqli_query($link,$q="
				  select *
				    from ewidpoja
");
if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}

while($r=mysqli_fetch_array($w))
{
	$id=$r['ID'];
	$rej=$r['REJESTRACJA'];
	$pocz=mysqli_fetch_row(mysqli_query($link, "select sum(KM) from ewidprzeb where REJESTRACJA='$rej' and substr(DATAW,1,7)<'$_POST[okres]'"))[0]+$r['PRZEBIEGBAZA'];
	$konc=mysqli_fetch_row(mysqli_query($link, "select sum(KM) from ewidprzeb where REJESTRACJA='$rej' and if('$_POST[okres]'='',1,substr(DATAW,1,7)<='$_POST[okres]')"))[0]+$r['PRZEBIEGBAZA'];
	mysqli_query($link,$q="
				  update ewidpoja
				     set PRZEBIEGPOCZ='$pocz'
					   , PRZEBIEGKONC='$konc'
				   where ID=$id
	");
}

header("location:../Tabela");
