<?php

require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

$okres=mysqli_fetch_row(mysqli_query($link,$q="
	select left(DOPERACJI,7)
	  from dokumenty
	 where ID=$id
"))[0];
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

$typ=mysqli_fetch_row(mysqli_query($link,$q="
	select TYP
	  from dokumenty
	 where ID=$id
"))[0];
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

$title="Masowe generowanie dokumentów PZ i WZ";
$buttons=array();
$buttons[]=array('klawisz'=>'AltD','nazwa'=>'Enter=Generuj','akcja'=>"generuj.php");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"..");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

echo "<table width='100%' height='100%'>";
echo "<tr align='center'>";
echo "<td>";

echo '<div class="form-group">';
echo '<span class="btn btn-default btn-file">';
echo 'Lista typów dokumentów zakupu towarów dla PZ: <input class="form-control" name="typZT" value="ZT" placeholder="zakupowe">';
echo '<br><br>';
echo 'Lista typów dokumentów sprzeda¿y towarów dla WZ: <input class="form-control" name="typST" value="ST" placeholder="sprzeda¿owe">';
echo '<br><br>';
echo 'Próg kwoty netto do podzielenia dokumentów PZ: <input class="form-control" name="prog" value="1000" placeholder="próg kwoty">';
echo '<br><br>';
echo 'Procent kwoty netto dla dokumentów WZ: <input class="form-control" name="procent" value="90" placeholder="procent kwoty">';
echo '<br><br>';
echo 'Nazwa towaru w magazynie: <input class="form-control" name="towar" value="Czê¶ci samochodowe" placeholder="nazwa towaru">';
echo '<br><br>';
echo 'Zast±piæ istniej±ce PZ i WZ?: <input type="checkbox" class="form-control" name="zastapic" value="1" checked>';
echo '</span>';
echo '</div>';

echo "</td>";
echo "</tr></table>";

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");
?>

<script type="text/javascript" src="/Lemur2/js/bootstrap-filestyle.min.js"> </script>
<script type="text/javascript" src="view.js"> </script>
