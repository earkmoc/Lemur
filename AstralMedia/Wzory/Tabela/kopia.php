<?php

require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

$r=mysqli_fetch_row(mysqli_query($link, $q="
select *
  from $tabela
 where ID=$id
"));
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

$sety="insert into $tabela values (0";
foreach($r as $key => $value)
{
	if($key>0)
	{
		$value=AddSlashes($value);
		$sety.=", '$value'";
	}
}
$sety.=")";

mysqli_query($link, $q=$sety);
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

$idd=mysqli_insert_id($link);

$sety="insert into wzoryumows (select 0, $idd, NAZWA, TEKST, FORMAT from wzoryumows where ID_WZORYUMOW=$id)";
mysqli_query($link, $q=$sety);
if (mysqli_error($link)) {
	die(mysqli_error($link).'<br>'.$q);
} else {
	header("location:..");
}
