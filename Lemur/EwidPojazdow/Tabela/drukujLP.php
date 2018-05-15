<?php

//die(print_r($_POST));
require("setup.php");

mysqli_query($link, "ALTER TABLE `slownik` CHANGE `OPIS` `OPIS` text NOT NULL DEFAULT ''");
mysqli_query($link, "ALTER TABLE `slownik` ADD UNIQUE `TST` (`TYP`, `SYMBOL`, `TRESC`)");

foreach($_POST as $key => $value)
{
	$value=AddSlashes($value);
	$sets="TYP='parametry'
	   , SYMBOL='wydruk1'
	   , TRESC='$key'
	   , OPIS='$value'
	";
	mysqli_query($link,$q="
					  insert 
						into slownik
						 set $sets
	 on duplicate key update $sets
	");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}
}

?>

<html>
<head>
<meta http-equiv="Content-type" content="text/html; charset=iso-8859-2">
<meta http-equiv="Reply-to" content="AMoch@pro.onet.pl">
<meta name="Author" content="Arkadiusz Moch">
<title>: Administrator</title>

<!-- jQuery -->
<script type="text/javascript" src="<?php echo "http://{$_SERVER['HTTP_HOST']}/Lemur2/";?>js/jquery-1.10.2.min.js"></script>

<style type="text/css">
<!--
@media print  {.breakhere {page-break-before: always;}}	
-->
</style>

<script type="text/javascript" language="JavaScript">
<!--

$(document).keydown(function(e) 
{
   $key=e.keyCode;
   if ($key==27) {
		location.href='index.php';      
		return false;
   }
   return true;
});

-->
</script>

</head>

<body onload="print();">

<?php 

$strona=1; 
$polaL=array(
 'LP'
,'DATANABYCIA'
,'NUMERDOK'
,'NAZWA'
,'CENA'
,'NUMERPOZ'
,'DATALIKWIDACJI'
,'PRZYCZYNA'
);

$polaP=array(
 'LP'
);

$sumyStrony=array(
 'CENA' => 0
);

$sumyPoprzednich=array(
 'CENA' => 0
);

$sumyRazem=array(
 'CENA' => 0
);

//strona 1 - lewa

require('Raport_n.php');
require('Raport_c.php');
require('Raport_t.php');

$w=mysqli_query($link, $q="
	select * from $baza.$tabela where 1 order by LP, ID limit $_POST[strona1]
");

$lp=0;
require('Raport_L.php');

$totalLP=mysqli_fetch_row(mysqli_query($link, "select count(*) from $baza.$tabela where 1"))[0];

while ($lp<$totalLP)
{
	$startLP=$lp;
	++$strona;
	$offset=$_POST['strona1']+$_POST['stronaN']*($strona-2);
	
	//strona kolejna - lewa

	echo '<div class="breakhere"></div>'.nl2br($_POST['naglowekN']);

	require('Raport_c.php');
	require('Raport_t.php');

	$w=mysqli_query($link, $q="
		select * from $baza.$tabela where 1 order by LP, ID limit $offset,$_POST[stronaN]
	");
	require('Raport_L.php');
}
echo 'Koniec.';

?>

</body>
</html>
