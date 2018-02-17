<?php

//die(print_r($_POST));

$czas=date('Y-m-d H:i:s');
ini_set('max_execution_time', 600);
error_reporting(E_ERROR | E_PARSE);

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

if($_POST['poczLP'])
{
	$nr=$_POST['poczLP']*1-1;
}
else
{
	$nr=mysqli_fetch_row(mysqli_query($link,$q="
		select LP
		  from ewidwypo
		 where left(DATANABYCIA,length('$_POST[okres]'))<'$_POST[okres]'
	  order by DATANABYCIA desc, LP*1 desc
		 limit 1
	"))[0];
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
}

$w=mysqli_query($link,$q="
	select ID
	  from ewidwypo
	 where left(DATANABYCIA,length('$_POST[okres]'))='$_POST[okres]'
  order by DATANABYCIA, if(left(NUMERDOK,2)='PK',9999999,if(left(NUMERDOK,2)='WB',99999,0))+ID
");
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

$wynik=0;
while($r=mysqli_fetch_row($w))
{
	++$nr;
	++$wynik;
	mysqli_query($link,$q="
		update ewidwypo
		   set LP=$nr
		 where ID=$r[0]
	");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
}

$title="Renumeracja dokumentów: raport";
$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"..");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

echo "<table width='100%' height='100%'>";
echo "<tr>";
echo "<td width='33%'></td>";
echo "<td>";

echo "<h1>Raport renumeracji:</h1>";
echo "<br>$wynik dokumentów przerenumerowanych";
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