<?php

//die(print_r($_POST));

$raport='<table border="1" cellpadding="3" cellspacing="0">';
$raport.="<tr><td>Nr dowodu</td><td>Data</td><td>KPR ID</td><td>KPR Kwota</td><td>Dokumenty ID</td><td>Rejestry Kwota</td><td>Ró¿nica</td></tr>";
$czas=date('Y-m-d H:i:s');
ini_set('max_execution_time', 600);
error_reporting(E_ERROR | E_PARSE);

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$w=mysqli_query($link,"
	  select PRZYCHOD3+ZAKUP_TOW+KOSZTY_UB+RAZEM
		   , concat(NRDOW, '</td><td>', DATA)
		   , ID_D
		   , ID
		from kpr
	   where ID_D>0
");
while($wynik=mysqli_fetch_row($w))
{
	$dokumenty=mysqli_fetch_row(mysqli_query($link,"
		  select NETTOVAT
			from dokumenty
		   where ID='{$wynik[2]}'
	"));
	$rejestry=mysqli_fetch_row(mysqli_query($link,"
		  select sum(NETTO)
			from dokumentr
		   where ID_D='{$wynik[2]}'
	"));
	if	( (abs($deltr=round($wynik[0]-$rejestry[0],2))>=0.01)
		)
	{
		$raport.="<tr style='text-align:right'><td>$wynik[1]</td><td>{$wynik[3]}</td><td>{$wynik[0]}</td><td>{$wynik[2]}</td><td>{$rejestry[0]}</td><td>".($deltr)."</td></tr>";
	}
}
$raport.='</table>';

$title="Test: raport";
$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"..");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

echo "<table width='100%' height='100%'>";
echo "<tr>";
echo "<td>";

echo "<h1>Raport testowania:</h1>";

echo $raport;

echo '<hr>';

echo '<div class="form-group">';
echo $czas.' czas rozpoczêcia';
echo '</div>';

echo '<div class="form-group">';
echo date('Y-m-d H:i:s').' czas zakoñczenia';
echo '</div>';

echo "</td>";
echo "</tr></table>";

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");