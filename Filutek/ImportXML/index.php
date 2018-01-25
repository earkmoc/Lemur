<?php

$title="Import plików XML";
$buttons=array();
$buttons[]=array('klawisz'=>'AltI','nazwa'=>'Enter=Importuj','akcja'=>"importuj.php");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"../Dokumenty");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

echo "<table width='100%' height='100%'>";
echo "<tr align='center'>";
echo "<td>";

echo '<div class="form-group">';
echo '<span class="btn btn-default btn-file">';
echo '¦cie¿ka dostêpu do plików XML na serwerze: <input class="form-control" name="path" value="C:\Users\PROSPER\Desktop" size="50">';
echo '</span>';
echo '</div>';

$pliki=array(
	 'kl'=>'klientów'
	,'fz'=>'faktur zakupu towarów'
	,'fv'=>'faktur sprzeda¿y VAT'
	,'fk'=>'faktur koryguj±cych sprzeda¿'
	,'fe'=>'faktur exportowych'
	,'wb_bgz'=>'WB BG¯'
	,'wb_pko'=>'WB PKO'
);

foreach($pliki as $skrot => $opis)
{
	echo '<div class="form-group">';
	echo '<span class="btn btn-default btn-file">';
	echo '<input name="'.$skrot.'" type="file" class="filestyle" data-buttonBefore="true" data-buttonText="Wybierz plik ('.strtoupper($skrot).').XML" data-placeholder="plik z danymi '.$opis.'...">';
	echo '	</span>';
	echo '</div>';
}
		
echo "</td>";
echo "</tr></table>";

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");
?>

<script type="text/javascript" src="/Lemur2/js/bootstrap-filestyle.min.js"> </script>
<script type="text/javascript" src="view.js"> </script>
