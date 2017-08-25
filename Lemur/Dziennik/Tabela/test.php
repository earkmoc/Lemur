<?php

//die(print_r($_POST));

$raport='';
$czas=date('Y-m-d H:i:s');
ini_set('max_execution_time', 600);
error_reporting(E_ERROR | E_PARSE);

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$w=mysqli_query($link,"
	  select sum(if(WINIEN<>'',KWOTA,0)) as KwotaWn
	       , sum(if(MA<>'',KWOTA,0)) as KwotaMa
		   , concat(DOK,' nr ', NR, ' z dnia ', DATA, ' gdzie LP=', LP)
		from nordpol
    group by DOK, NR, DATA, LP
	  having KwotaWn<>KwotaMa
");
while($wynik=mysqli_fetch_row($w))
{
	$raport.="<br>$wynik[2]: suma(Wn)=$wynik[0] <> suma(Ma)=$wynik[1], ró¿nica=".($wynik[0]-$wynik[1]);
}

$w=mysqli_query($link,"
	  select DATA
		   , DATA2
		   , concat(DOK,' nr ', NR, ' z dnia ', DATA, ' gdzie LP=', LP, ', PZ=', PZ)
		from nordpol
       order by DOK, NR*1, LP*1, PZ*1
");
$dt='';
while($wynik=mysqli_fetch_row($w))
{
	$raport.=(($wynik[0]<$dt)?"<br>$wynik[2]: problem z chronologi± dat ksiêgowania":"");
	$raport.=(($wynik[0]<$wynik[1])?"<br>$wynik[2]: problem z dat± ksiêgowania i wystawienia":"");
	$dt=$wynik[0];
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