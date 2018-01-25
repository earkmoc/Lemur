<?php

require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

$rok=mysqli_fetch_row(mysqli_query($link,$q="
				  select OPIS 
					from slownik
				   where TYP='parametry'
					 and SYMBOL='SrodkiTr'
					 and TRESC='rok'
"))[0];
if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}

$parametry='';
foreach($_GET as $key => $value)
{
	$parametry.="&$key=$value";
}

$title="Przeliczanie amortyzacji";
$buttons=array();
$buttons[]=array('klawisz'=>'AltP','nazwa'=>'Enter=Przelicz','akcja'=>"przeliczaj.php?$parametry");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"..");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

echo "<table width='100%' height='100%'>";
echo "<tr align='center'>";
echo "<td>";

echo '<div class="form-group">';
echo '<span class="btn btn-default btn-file">';
echo '<br>';
echo 'Wed³ug stanu na rok: <input type="text" class="form-control" name="rok" value="'.($rok).'" placeholder="yyyy" />';
echo '<br>';
echo '</span>';
echo '</div>';

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");
?>

<link href="view.css" rel="stylesheet">
<script type="text/javascript" src="view.js"> </script>
