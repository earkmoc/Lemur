<?php

require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

$okres=mysqli_fetch_row(mysqli_query($link,$q="
	select left(DOPERACJI,7)
	  from dokumenty
	 where ID=$id
"))[0];
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

$title="Zamykanie dokument�w";
$buttons=array();
$buttons[]=array('klawisz'=>'AltZ','nazwa'=>'Enter=Zamykaj','akcja'=>"zamykaj.php");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powr�t','akcja'=>"..");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

echo "<table width='100%' height='100%'>";
echo "<tr align='center'>";
echo "<td>";

echo '<div class="form-group">';
echo '<span class="btn btn-default btn-file">';
echo '<br>';
echo 'Dokument bie��cy o ID: <input class="form-control" name="id" value="'.$id.'" title="ID bie��cego dokumentu">';
echo '<br>';
echo '</span>';
echo '</div>';

echo '<br>albo<br><br>';

echo '<div class="form-group">';
echo '<span class="btn btn-default btn-file">';
echo '<br>';
echo 'Okres sprawozdawczy (pusty powoduje zamkni�cie tylko 1 dokumentu o ID podanym wy�ej): <input class="form-control" name="okres" value="" placeholder="yyyy-mm" maxlength="10">';
echo '<br>';
echo 'Data ksi�gowania (pusta powoduje pobieranie tych dat z dokument�w): <input class="form-control" name="dataks" value="" placeholder="yyyy-mm-dd" maxlength="10">';
echo '<br>';
echo 'Typy dokument�w (lista typ�w dokument�w oddzielonych przecinkami (pusta oznacza dowolny typ)): <input class="form-control" name="typy" value="ZT,ZTK,ZME,ZU,KP" placeholder="lista typ�w dokument�w" maxlength="100" >';
echo '<br>';
echo '</span>';
echo '</div>';

echo "</td>";
echo "</tr>";
echo "</table>";

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");
?>

<script type="text/javascript" src="/Lemur2/js/bootstrap-filestyle.min.js"> </script>
<script type="text/javascript" src="view.js"> </script>
