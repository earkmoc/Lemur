<?php

require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

$r=mysqli_fetch_array(mysqli_query($link, $q="
select *
  from $tabela
 where ID=$id
"));
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

$_GET['wzor']=$r['TYP'];

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/WydrukWzor.php");
