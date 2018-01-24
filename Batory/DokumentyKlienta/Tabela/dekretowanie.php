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

$title="Masowe dekretowanie dokumentów";
$buttons=array();
$buttons[]=array('klawisz'=>'AltD','nazwa'=>'Enter=Dekretuj','akcja'=>"dekretuj.php");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"..");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

echo "<table width='100%' height='100%'>";
echo "<tr align='center'>";
echo "<td>";

echo '<div class="form-group">';
echo '<span class="btn btn-default btn-file">';
echo 'Dokumenty typu: <input class="form-control" name="typ" value="'.$typ.'" placeholder="typ" maxlength="3">';
echo '<br>i<br><br>';
echo 'Okres sprawozdawczy: <input class="form-control" name="okres" value="'.$okres.'" placeholder="yyyy-mm" maxlength="7">';
echo '<br><br>';
echo 'Zast±piæ istniej±ce dekrety?: <input type="checkbox" class="form-control" name="zastapic" value="1" >';
echo '</span>';
echo '</div>';

echo "</td>";
echo "</tr></table>";

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");
?>

<script type="text/javascript" src="/Lemur2/js/bootstrap-filestyle.min.js"> </script>
<script type="text/javascript" src="view.js"> </script>
