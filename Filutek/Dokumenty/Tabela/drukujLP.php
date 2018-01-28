<?php

//die(print_r($_POST));
require("setup.php");

mysqli_query($link, "ALTER TABLE `slownik` CHANGE `OPIS` `OPIS` text NOT NULL DEFAULT ''");
mysqli_query($link, "ALTER TABLE `slownik` ADD UNIQUE `TST` (`TYP`, `SYMBOL`, `TRESC`)");

$_POST['lewe']=(@$_POST['lewe']?$_POST['lewe']:'');
$_POST['prawe']=(@$_POST['prawe']?$_POST['prawe']:'');

if	( !$_POST['lewe']
	&&!$_POST['prawe']
	)
{
	$_POST['lewe']=1;
	$_POST['prawe']=0;
}
$_POST['syntetycznie']=(@$_POST['syntetycznie']?$_POST['syntetycznie']:'');
$_POST['syntetycznie']=false;

//$_POST['OdDaty']=(strlen($_POST['rokMc'])==4?"$_POST[rokMc]-01-01":"$_POST[rokMc]-01");
//$_POST['DoDaty']=(strlen($_POST['rokMc'])==4?"$_POST[rokMc]-12-31":mysqli_fetch_row(mysqli_query($link,"select Date_Add(Date_Add('$_POST[odDnia]',interval 1 month),interval -1 day)"))[0]);

$miesiace=array(
 'Styczeñ'
,'Luty'
,'Marzec'
,'Kwiecieñ'
,'Maj'
,'Czerwiec'
,'Lipiec'
,'Sierpieñ'
,'Wrzesieñ'
,'Pa¼dziernik'
,'Listopad'
,'Grudzieñ'
);
$_POST['miesiac']=$miesiace[substr($_POST['odDnia'],5,2)*1-1];
$_POST['rok']=substr($_POST['odDnia'],0,4);
$_POST['rokMc']=substr($_POST['odDnia'],0,7);

foreach($_POST as $key => $value)
{
	$value=AddSlashes($value);
	$sets="TYP='parametry'
	   , SYMBOL='raportK'
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
<title>Raport kasowy</title>

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

//if($_POST['syntetycznie'])
if(false)
{
	require('drukujSY.php');
}
else
{
	
	$strona=1; 
	$polaL=array(
	 'LP'
	,'DDOKUMENTU'
	,"concat(TYP,' ',NUMER)"
	,'PRZEDMIOT'
	,"if(TYP='KP',WARTOSC,0)"
	,"if(TYP='KW',WARTOSC,0)"
	,'NRKONT'
	);
	$pola=''; foreach($polaL as $p) {$pola.="$p,";}; $pola.="0";

	$sumyStrony=array(
	 "if(TYP='KP',WARTOSC,0)" => 0
	,"if(TYP='KW',WARTOSC,0)" => 0
	);

	$sumyPoprzednich=array(
	 "if(TYP='KP',WARTOSC,0)" => 0
	,"if(TYP='KW',WARTOSC,0)" => 0
	);

	$sumyRazem=array(
	 "if(TYP='KP',WARTOSC,0)" => 0
	,"if(TYP='KW',WARTOSC,0)" => 0
	);

	//strona 1 - lewa

	if($_POST['lewe'])
	{
		require('Raport_n.php');
		require('Raport_c.php');
		require('Raport_t.php');

		$w=mysqli_query($link, $q="
			select $pola from $baza.$tabela where TYP IN ('KP','KW') and DDOKUMENTU between '$_POST[odDnia]' and '$_POST[doDnia]' order by DDOKUMENTU, LP, ID limit $_POST[strona1]
		");
		$lp=0;
		require('Raport_L.php');
	}

	//strona 1 - prawa

	$totalLP=mysqli_fetch_row(mysqli_query($link, "select count(*) from $baza.$tabela where TYP IN ('KP','KW') and DDOKUMENTU between '$_POST[odDnia]' and '$_POST[doDnia]'"))[0];
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
				select $pola from $baza.$tabela where TYP IN ('KP','KW') and DDOKUMENTU between '$_POST[odDnia]' and '$_POST[doDnia]' order by DDOKUMENTU, LP, ID limit $offset,$_POST[stronaN]
			");
			require('Raport_L.php');
		}
	}
	echo 'Koniec.';
}
?>

</body>
</html>
