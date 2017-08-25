<?php

error_reporting(E_ERROR | E_PARSE | E_WARNING);//E_NOTICE | 

$title="Import pliku MAX";

$path='C:\Archiwa\Arrakis\KPR\2016';

$buttons=array();
$buttons[]=array('klawisz'=>'AltI','nazwa'=>'Enter=Importuj','akcja'=>"importuj.php");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"../Klienci");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

echo "<table width='100%' height='100%'>";
echo "<tr align='center'>";
echo "<td>";

echo '<div class="form-group">';
echo '<span class="btn btn-default btn-file">';
echo '¦cie¿ka dostêpu do pliku MAX z serwera: <br><input class="form-control" name="path" value="'.$path.'" size="50">';
echo '</span>';
echo '</div>';

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");
?>

<script type="text/javascript" src="/Lemur2/js/bootstrap-filestyle.min.js"> </script>
<script type="text/javascript" src="view.js"> </script>
