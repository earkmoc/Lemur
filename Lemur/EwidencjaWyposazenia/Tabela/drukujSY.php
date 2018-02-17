<?php 

$pola=array(
 'LP'
,'left(DATA,7)'
,'sum(PRZYCHOD1)'
,'sum(PRZYCHOD2)'
,'sum(PRZYCHOD3)'
,'sum(ZAKUP_TOW)'
,'sum(KOSZTY_UB)'
,'sum(WYNAGRODZENIA)'
,'sum(POZOSTALE)'
,'sum(RAZEM)'
,'sum(INNE)'
,'sum(WARTOSC)'
);
/*
$sumyRazem=array(
 'PRZYCHOD1' => mysqli_fetch_row(mysqli_query($link, "select sum(PRZYCHOD1) from $baza.$tabela where Year(DATA)='$_POST[rok]' and left(DATA,7)<='$_POST[rokMc]'"))[0]
,'PRZYCHOD2' => mysqli_fetch_row(mysqli_query($link, "select sum(PRZYCHOD2) from $baza.$tabela where Year(DATA)='$_POST[rok]' and left(DATA,7)<='$_POST[rokMc]'"))[0]
,'PRZYCHOD3' => mysqli_fetch_row(mysqli_query($link, "select sum(PRZYCHOD3) from $baza.$tabela where Year(DATA)='$_POST[rok]' and left(DATA,7)<='$_POST[rokMc]'"))[0]
,'ZAKUP_TOW' => mysqli_fetch_row(mysqli_query($link, "select sum(ZAKUP_TOW) from $baza.$tabela where Year(DATA)='$_POST[rok]' and left(DATA,7)<='$_POST[rokMc]'"))[0]
,'KOSZTY_UB' => mysqli_fetch_row(mysqli_query($link, "select sum(KOSZTY_UB) from $baza.$tabela where Year(DATA)='$_POST[rok]' and left(DATA,7)<='$_POST[rokMc]'"))[0]
,'WYNAGRODZENIA' => mysqli_fetch_row(mysqli_query($link, "select sum(WYNAGRODZENIA) from $baza.$tabela where Year(DATA)='$_POST[rok]' and left(DATA,7)<='$_POST[rokMc]'"))[0]
,'POZOSTALE' => mysqli_fetch_row(mysqli_query($link, "select sum(POZOSTALE) from $baza.$tabela where Year(DATA)='$_POST[rok]' and left(DATA,7)<='$_POST[rokMc]'"))[0]
,'RAZEM' => mysqli_fetch_row(mysqli_query($link, "select sum(RAZEM) from $baza.$tabela where Year(DATA)='$_POST[rok]' and left(DATA,7)<='$_POST[rokMc]'"))[0]
,'INNE' => mysqli_fetch_row(mysqli_query($link, "select sum(INNE) from $baza.$tabela where Year(DATA)='$_POST[rok]' and left(DATA,7)<='$_POST[rokMc]'"))[0]
,'WARTOSC' => mysqli_fetch_row(mysqli_query($link, "select sum(WARTOSC) from $baza.$tabela where Year(DATA)='$_POST[rok]' and left(DATA,7)<='$_POST[rokMc]'"))[0]
);
*/
$sumyRazem=array(
 'PRZYCHOD1' => mysqli_fetch_row(mysqli_query($link, "select sum(PRZYCHOD1) from $baza.$tabela where DATA between '$_POST[odDnia]' and '$_POST[doDnia]' "))[0]
,'PRZYCHOD2' => mysqli_fetch_row(mysqli_query($link, "select sum(PRZYCHOD2) from $baza.$tabela where DATA between '$_POST[odDnia]' and '$_POST[doDnia]' "))[0]
,'PRZYCHOD3' => mysqli_fetch_row(mysqli_query($link, "select sum(PRZYCHOD3) from $baza.$tabela where DATA between '$_POST[odDnia]' and '$_POST[doDnia]' "))[0]
,'ZAKUP_TOW' => mysqli_fetch_row(mysqli_query($link, "select sum(ZAKUP_TOW) from $baza.$tabela where DATA between '$_POST[odDnia]' and '$_POST[doDnia]' "))[0]
,'KOSZTY_UB' => mysqli_fetch_row(mysqli_query($link, "select sum(KOSZTY_UB) from $baza.$tabela where DATA between '$_POST[odDnia]' and '$_POST[doDnia]' "))[0]
,'WYNAGRODZENIA' => mysqli_fetch_row(mysqli_query($link, "select sum(WYNAGRODZENIA) from $baza.$tabela where DATA between '$_POST[odDnia]' and '$_POST[doDnia]' "))[0]
,'POZOSTALE' => mysqli_fetch_row(mysqli_query($link, "select sum(POZOSTALE) from $baza.$tabela where DATA between '$_POST[odDnia]' and '$_POST[doDnia]' "))[0]
,'RAZEM' => mysqli_fetch_row(mysqli_query($link, "select sum(RAZEM) from $baza.$tabela where DATA between '$_POST[odDnia]' and '$_POST[doDnia]' "))[0]
,'INNE' => mysqli_fetch_row(mysqli_query($link, "select sum(INNE) from $baza.$tabela where DATA between '$_POST[odDnia]' and '$_POST[doDnia]' "))[0]
,'WARTOSC' => mysqli_fetch_row(mysqli_query($link, "select sum(WARTOSC) from $baza.$tabela where DATA between '$_POST[odDnia]' and '$_POST[doDnia]' "))[0]
);

$strona=1; 
require('Raport_n.php');
require('Raport_cSY.php');
require('Raport_tSY.php');

$q="";
foreach($pola as $pole)
{
	$q.=($q?', ':'').$pole;
}
//$w=mysqli_query($link, $q="
//		select $q from $baza.$tabela where Year(DATA)='$_POST[rok]' and left(DATA,7)<='$_POST[rokMc]' group by left(DATA,7)
//");
$w=mysqli_query($link, $q="
		select $q from $baza.$tabela where DATA between '$_POST[odDnia]' and '$_POST[doDnia]' group by left(DATA,7)
");

$lp=0;
require('Raport_SY.php');

echo 'Koniec.';
