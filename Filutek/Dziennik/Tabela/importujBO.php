<?php

//die(print_r($_POST));

$raport='';
$czas=date('Y-m-d H:i:s');
ini_set('max_execution_time', 600);
error_reporting(E_ERROR | E_PARSE);

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$w=mysqli_query($link,"
	delete from nordpol where DOK='BO'
");

$raport.=mysqli_affected_rows($link).' usuniêtych pozycji<br>';

$w=mysqli_query($link,"
	  insert 
		into nordpol
	  select 0
	       , 'BO'
	       , '1'
	       , '2016-12-31'
	       , '1'
	       , '1'
	       , IF(SALDOWN>0,SALDOWN,SALDOMA)
	       , IF(SALDOWN>0,KONTO,'')
	       , IF(SALDOMA>0,KONTO,'')
		   , 'B.O.'
		   , 'B.O.'
	       , '2016-12-31'
		   , 'B.O.'
		   , ''
		   , $ido
		   , Now()
		from $_POST[zKlienta].zest1
	   where (  SALDOWN>0 
			 or SALDOMA>0
			 )
		 and ID_OSOBYUPR=$ido
	order by KONTO
");

$pozycji=mysqli_affected_rows($link);
$raport.="$pozycji dodanych pozycji";

$lastID=mysqli_insert_id($link);
$w=mysqli_query($link,$q="
	 update nordpol 
		set PZ=ID-$lastID+1
	  where DOK='BO'
");

$title="Import BO: raport";
$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"..");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

echo "<table width='100%' height='100%'>";
echo "<tr>";
echo "<td>";

echo "<h1>Raport importu BO:</h1>";

echo "<h2>$raport</h2>";

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