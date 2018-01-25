<?php

//die(print_r($_POST));
require("setup.php");

mysqli_query($link, "ALTER TABLE `slownik` CHANGE `OPIS` `OPIS` text NOT NULL DEFAULT ''");
mysqli_query($link, "ALTER TABLE `slownik` ADD UNIQUE `TST` (`TYP`, `SYMBOL`, `TRESC`)");

$_POST['lewe']=(@$_POST['lewe']?$_POST['lewe']:'');
$_POST['prawe']=(@$_POST['prawe']?$_POST['prawe']:'');
$_POST['naprzemiennie']=(@$_POST['naprzemiennie']?$_POST['naprzemiennie']:'');

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
,'DATA'
,'NRDOW'
,'NAZWA'
,'ADRES'
,'OPIS'
,'PRZYCHOD1'
,'PRZYCHOD2'
,'PRZYCHOD3'
);

$polaP=array(
 'LP'
,'ZAKUP_TOW'
,'KOSZTY_UB'
,'WYNAGRODZENIA'
,'POZOSTALE'
,'RAZEM'
,'INNE'
,'OPISKOSZTU'
,'WARTOSC'
,'UWAGI'
);

$sumyStrony=array(
 'PRZYCHOD1' => 0
,'PRZYCHOD2' => 0
,'PRZYCHOD3' => 0
,'ZAKUP_TOW' => 0
,'KOSZTY_UB' => 0
,'WYNAGRODZENIA' => 0
,'POZOSTALE' => 0
,'RAZEM' => 0
,'INNE' => 0
,'OPISKOSZTU' => 0
,'WARTOSC' => 0
,'UWAGI' => 0
);

$sumyPoprzednich=array(
 'PRZYCHOD1' => 0
,'PRZYCHOD2' => 0
,'PRZYCHOD3' => 0
,'ZAKUP_TOW' => 0
,'KOSZTY_UB' => 0
,'WYNAGRODZENIA' => 0
,'POZOSTALE' => 0
,'RAZEM' => 0
,'INNE' => 0
,'OPISKOSZTU' => 0
,'WARTOSC' => 0
,'UWAGI' => 0
);

$sumyRazem=array(
 'PRZYCHOD1' => mysqli_fetch_row(mysqli_query($link, "select sum(PRZYCHOD1) from $baza.$tabela where DATA < '$_POST[OdDaty]' and Year(DATA)='$_POST[rok]'"))[0]
,'PRZYCHOD2' => mysqli_fetch_row(mysqli_query($link, "select sum(PRZYCHOD2) from $baza.$tabela where DATA < '$_POST[OdDaty]' and Year(DATA)='$_POST[rok]'"))[0]
,'PRZYCHOD3' => mysqli_fetch_row(mysqli_query($link, "select sum(PRZYCHOD3) from $baza.$tabela where DATA < '$_POST[OdDaty]' and Year(DATA)='$_POST[rok]'"))[0]
,'ZAKUP_TOW' => mysqli_fetch_row(mysqli_query($link, "select sum(ZAKUP_TOW) from $baza.$tabela where DATA < '$_POST[OdDaty]' and Year(DATA)='$_POST[rok]'"))[0]
,'KOSZTY_UB' => mysqli_fetch_row(mysqli_query($link, "select sum(KOSZTY_UB) from $baza.$tabela where DATA < '$_POST[OdDaty]' and Year(DATA)='$_POST[rok]'"))[0]
,'WYNAGRODZENIA' => mysqli_fetch_row(mysqli_query($link, "select sum(WYNAGRODZENIA) from $baza.$tabela where DATA < '$_POST[OdDaty]' and Year(DATA)='$_POST[rok]'"))[0]
,'POZOSTALE' => mysqli_fetch_row(mysqli_query($link, "select sum(POZOSTALE) from $baza.$tabela where DATA < '$_POST[OdDaty]' and Year(DATA)='$_POST[rok]'"))[0]
,'RAZEM' => mysqli_fetch_row(mysqli_query($link, "select sum(RAZEM) from $baza.$tabela where DATA < '$_POST[OdDaty]' and Year(DATA)='$_POST[rok]'"))[0]
,'INNE' => mysqli_fetch_row(mysqli_query($link, "select sum(INNE) from $baza.$tabela where DATA < '$_POST[OdDaty]' and Year(DATA)='$_POST[rok]'"))[0]
,'OPISKOSZTU' => ''
,'WARTOSC' => mysqli_fetch_row(mysqli_query($link, "select sum(WARTOSC) from $baza.$tabela where DATA < '$_POST[OdDaty]' and Year(DATA)='$_POST[rok]'"))[0]
,'UWAGI' => ''
);

//strona 1 - lewa

if($_POST['lewe'])
{
	require('Raport_n.php');
	require('Raport_c.php');
	require('Raport_t.php');

	$w=mysqli_query($link, $q="
		select * from $baza.$tabela where DATA between '$_POST[OdDaty]' and '$_POST[DoDaty]' order by LP, ID limit $_POST[strona1]
	");

	$lp=0;
	require('Raport_L.php');
}

//strona 1 - prawa

if($_POST['prawe'])
{
	echo '<div class="breakhere"></div>';

	require('Raport_n.php');
	require('Raport_c.php');
	require('Raport_tP.php');

	$w=mysqli_query($link, $q="
		select * from $baza.$tabela where DATA between '$_POST[OdDaty]' and '$_POST[DoDaty]' order by LP, ID limit $_POST[strona1]
	");

	$lp=0;
	require('Raport_P.php');
}

$totalLP=mysqli_fetch_row(mysqli_query($link, "select count(*) from $baza.$tabela where DATA between '$_POST[OdDaty]' and '$_POST[DoDaty]'"))[0];

while ($lp<$totalLP)
{
	$startLP=$lp;
	++$strona;
	$offset=$_POST['strona1']+$_POST['stronaN']*($strona-2);
	
	//strona kolejna - lewa

	if($_POST['lewe'])
	{
		echo '<div class="breakhere"></div>'.nl2br($_POST['naglowekN']);

		require('Raport_c.php');
		require('Raport_t.php');

		$w=mysqli_query($link, $q="
			select * from $baza.$tabela where DATA between '$_POST[OdDaty]' and '$_POST[DoDaty]' order by LP, ID limit $offset,$_POST[stronaN]
		");
		require('Raport_L.php');
	}

	//strona kolejna - prawa

	if($_POST['prawe'])
	{
		$lp=$startLP;

		echo '<div class="breakhere"></div>'.nl2br($_POST['naglowekN']);

		require('Raport_c.php');
		require('Raport_tP.php');

		$w=mysqli_query($link, $q="
			select * from $baza.$tabela where DATA between '$_POST[OdDaty]' and '$_POST[DoDaty]' order by LP, ID limit $offset,$_POST[stronaN]
		");
		require('Raport_P.php');
	}
}
echo 'Koniec.';
?>

</body>
</html>
