<?php

require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

$okres=mysqli_fetch_row(mysqli_query($link,$q="
	select left(DATAW,7)
	  from ewidsprz
	 where ID=$id
"))[0];
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

$title="Renumeracja dokumentów";
$buttons=array();
$buttons[]=array('klawisz'=>'AltR','nazwa'=>'Enter=Renumeruj','akcja'=>"renumeruj.php");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"..");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

echo "<table width='100%' height='100%'>";
echo "<tr align='center'>";
echo "<td>";

echo '<div class="form-group">';
echo '<span class="btn btn-default btn-file">';
echo 'Okres sprawozdawczy: <input class="form-control" name="okres" value="'.$okres.'" size="7">';
echo '</span>';
echo '</div>';

echo "</td>";
echo "</tr></table>";

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");
?>

<script type="text/javascript" src="/Lemur2/js/bootstrap-filestyle.min.js"> </script>
<script type="text/javascript" src="view.js"> </script>
