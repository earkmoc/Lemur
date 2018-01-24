<?php

//die(print_r($_POST));
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$rok=$_POST['rok']*1;
$czas=date('Y-m-d H:i:s');
$ileZmian=0;

$sets="TYP='parametry'
   , SYMBOL='SrodkiTr'
   , TRESC='rok'
   , OPIS='$rok'
";
mysqli_query($link,$q="
				  insert 
					into slownik
					 set $sets
 on duplicate key update $sets
");
if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}

$srodkiTrwale=mysqli_query($link,$q="
	select ID
	  from srodkitr
");
if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}

while($srodekTrwaly=mysqli_fetch_array($srodkiTrwale))
{
	require_once("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/SrodkiTrOblicz.php");
	$ileZmian+=Oblicz($link, $srodekTrwaly['ID'], $rok);
}

$title="Przeliczanie: raport";
$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"..");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

echo "<table width='100%' height='100%'>";
echo "<tr>";
echo "<td width='33%'></td>";
echo "<td>";

echo "<h1>Raport przeliczania ¶rodków trwa³ych na $rok r.:</h1>";
echo "<br>$ileZmian pozycji zmienionych";
echo '<hr>';

echo '<div class="form-group">';
echo $czas.' czas rozpoczêcia';
echo '</div>';

echo '<div class="form-group">';
echo date('Y-m-d H:i:s').' czas zakoñczenia';
echo '</div>';

echo "</td>";
echo "<td width='33%'></td>";
echo "</tr></table>";

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");
