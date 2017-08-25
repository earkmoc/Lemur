<?php

//die(print_r($_POST));

$raport='';
$czas=date('Y-m-d H:i:s');
ini_set('max_execution_time', 600);
error_reporting(E_ERROR | E_PARSE);

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$w=mysqli_query($link,"
	  select PRZYCHOD3+ZAKUP_TOW+KOSZTY_UB+RAZEM
		   , concat(NRDOW, ' z dnia ', DATA)
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
	if(abs($delta=round($wynik[0]-$dokumenty[0],2))>=0.01)
	{
		$raport.="<br>$wynik[1]: KPR(ID={$wynik[3]})={$wynik[0]} <> Dokumenty(ID={$wynik[2]})={$dokumenty[0]}, ró¿nica=".($delta);
	}
}

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