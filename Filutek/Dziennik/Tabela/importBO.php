<?php

require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

$parametry='';
foreach($_GET as $key => $value)
{
	$parametry.="&$key=$value";
}

$zKlienta=str_replace('16','..',$baza);
$zKlienta=str_replace('17','16',$baza);

$title="Import BO";
$buttons=array();
$buttons[]=array('klawisz'=>'AltI','nazwa'=>'Enter=Importuj','akcja'=>"importujBO.php?$parametry");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"..");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

echo "<table width='100%' height='100%'>";
echo "<tr align='center'>";
echo "<td>";

echo '<div class="form-group">';
echo '<span class="btn btn-default btn-file">';
echo '<br>';
echo "Import BO na podstawie Zestawienia Obrotów i Sald (ZOS) klienta: <input type='text' class='form-control' name='zKlienta' value='$zKlienta' />";
echo '<br>';
echo '</span>';
echo '</div>';

echo '<br>';
echo 'Uwaga: dotychczasowe BO jest usuwane, a w jego miejsce jest wpisywane nowe.';

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");
?>

<link href="view.css" rel="stylesheet">
<script type="text/javascript" src="view.js"> </script>
