<?php

require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

$title="Usuwanie pozycji";
$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powr�t','akcja'=>"../Tabela");
$buttons[]=array('klawisz'=>'Enter','nazwa'=>'Enter=usuni�cie pozycji','akcja'=>"usuwaj.php?id=$id");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");
echo "<table width='100%' height='100%'>";
echo "<tr align='center'>";
echo "<td><h1>Czy na pewno usun�� pozycj� o ID=$id ?<h1></td>";
echo "</tr></table>";
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");
