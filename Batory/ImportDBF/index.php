<?php

error_reporting(E_ERROR | E_PARSE | E_WARNING);//E_NOTICE | 

$title="Import plików DBF";

$innaBaza='Lemur';
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
$path=mysqli_fetch_row(mysqli_query($link, "select OPIS from klienci where PSKONT='$baza'"))[0];
$path=str_replace("/","\\",$path);

$buttons=array();
$buttons[]=array('klawisz'=>'AltI','nazwa'=>'Enter=Importuj','akcja'=>"importuj.php");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"../Menu");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

echo "<table width='100%' height='100%'>";
echo "<tr align='center'>";
echo "<td>";

$pliki=array(
	 'knordpol'=>'Plan Kont i dane kontrahentów'
	,'rej_sp'=>'rejestr sprzeda¿y VAT - dokumenty'
	,'towary'=>'rejestr sprzeda¿y VAT - towary'
	,'splaty'=>'rejestr sprzeda¿y VAT - wp³aty'
	,'rej_sk'=>'rejestr sprzeda¿y VAT - kaucje dokumenty'
	,'towaryk'=>'rejestr sprzeda¿y VAT - kaucje towary'
	,'splatyk'=>'rejestr sprzeda¿y VAT - kaucje wp³aty'
	,'rej_ka'=>'rejestr kasowy - dokumenty KP/KW'
	,'megako'=>'Kontrahenci'
	,'megakm'=>'Magazyn'
	,'megawn'=>'Dokumenty WZ'
	,'megaww'=>'Dokumenty WZ - specyfikacja'
	,'megapn'=>'Dokumenty PZ'
	,'megapw'=>'Dokumenty PZ - specyfikacja'
	,'nordpol'=>'Dziennik g³ówny'
	,'dnordpol'=>'Typy dokumentów ksiêgowych'
	,'bilans'=>'Bilans AKTYWA'
	,'bilansp'=>'Bilans PASYWA'
	,'rachwyn'=>'Rachunek Wyników'
	,'ksiega'=>'Ksiêga Przychodów i Rozchodów'
	,'r_sprz'=>'rejestr sprzeda¿y VAT'
	,'rksprz'=>'rejestr korekt sprzeda¿y VAT'
	,'r_sprzzw'=>'rejestr sprzeda¿y export'
	,'r_zakuzw'=>'rejestr zakupu export'
	,'r_swdt'=>'rejestr sprzeda¿y WDT'
	,'r_swnt'=>'rejestr sprzeda¿y WNT'
	,'r_zakup'=>'rejestr zakupów towarów'
	,'r_zakut'=>'rejestr zakupów towarów'
	,'rej_zk'=>'rejestr zakupów towarów'
	,'r_zakuu'=>'rejestr zakupów us³ug'
	,'r_zakua'=>'rejestr zakupów zwolnionych z VAT'
	,'r_zakum'=>'rejestr zakupów materia³ów'
	,'r_zakus'=>'rejestr zakupów ¶rodków trwa³ych'
	,'r_zakuw'=>'rejestr zakupów ...'
	,'r_zakuz'=>'rejestr zakupów zwolnionych'
	,'srodkitr'=>'¦rodki trwa³e'
	,'srodkiot'=>'¦rodki trwa³e - dokumenty OT'
	,'srodkihi'=>'¦rodki trwa³e - historia'
	,'srodkizm'=>'¦rodki trwa³e - zmiany'
	,'lprac'=>'Listy p³at - pracownicy'
	,'lplac'=>'Listy p³at - nag³ówki'
	,'lplacp'=>'Listy p³at - pozycje'
	,'lplacpp'=>'Listy p³at - sk³adniki pozycji'
	,'dokum'=>'Magazyny - dokumenty'
	,'doktypy'=>'Magazyny - parametry'
	,'spec'=>'Magazyny - specyfikacje'
	,'rej_pcc'=>'rejestr podatku PCC'
);
/*
	,'towary'=>'Magazyny - towary'
*/
echo '<div class="form-group">';
echo '<span class="btn btn-default btn-file">';
echo '¦cie¿ka dostêpu do plików DBF na serwerze: <br><input class="form-control" name="path" value="'.$path.'" size="50">';
echo '</span>';
echo '</div>';

echo "<hr>";

echo "<b>Importowane pliki:</b><br><br>";

echo "<table>";
foreach($pliki as $skrot => $opis)
{
	echo '<tr>';
	echo '<td align="left"><input type="checkbox" name="'.strtoupper($skrot).'" cchecked /> '.strtoupper($skrot).'.DBF</td><td align="left"> : '.$opis.'</td>';
	echo '</tr>';
}
echo "<table>";
		
echo "</td>";
echo "</tr></table>";

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");
?>

<script type="text/javascript" src="/Lemur2/js/bootstrap-filestyle.min.js"> </script>
<script type="text/javascript" src="view.js"> </script>
