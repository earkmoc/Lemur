<?php

error_reporting(E_ERROR | E_PARSE | E_WARNING);//E_NOTICE | 

$title="Import plik�w DBF";

$innaBaza='Lemur';
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
$path=mysqli_fetch_row(mysqli_query($link, "select OPIS from klienci where PSKONT='$baza'"))[0];
$path=str_replace("/","\\",$path);

$buttons=array();
$buttons[]=array('klawisz'=>'AltI','nazwa'=>'Enter=Importuj','akcja'=>"importuj.php");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powr�t','akcja'=>"../Menu");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

echo "<table width='100%' height='100%'>";
echo "<tr align='center'>";
echo "<td>";

$pliki=array(
	 'knordpol'=>'Plan Kont i dane kontrahent�w'
	,'rej_sp'=>'rejestr sprzeda�y VAT - dokumenty'
	,'towary'=>'rejestr sprzeda�y VAT - towary'
	,'splaty'=>'rejestr sprzeda�y VAT - wp�aty'
	,'rej_sk'=>'rejestr sprzeda�y VAT - kaucje dokumenty'
	,'towaryk'=>'rejestr sprzeda�y VAT - kaucje towary'
	,'splatyk'=>'rejestr sprzeda�y VAT - kaucje wp�aty'
	,'rej_ka'=>'rejestr kasowy - dokumenty KP/KW'
	,'megako'=>'Kontrahenci'
	,'megakm'=>'Magazyn'
	,'megawn'=>'Dokumenty WZ'
	,'megaww'=>'Dokumenty WZ - specyfikacja'
	,'megapn'=>'Dokumenty PZ'
	,'megapw'=>'Dokumenty PZ - specyfikacja'
	,'nordpol'=>'Dziennik g��wny'
	,'dnordpol'=>'Typy dokument�w ksi�gowych'
	,'bilans'=>'Bilans AKTYWA'
	,'bilansp'=>'Bilans PASYWA'
	,'rachwyn'=>'Rachunek Wynik�w'
	,'ksiega'=>'Ksi�ga Przychod�w i Rozchod�w'
	,'r_sprz'=>'rejestr sprzeda�y VAT'
	,'rksprz'=>'rejestr korekt sprzeda�y VAT'
	,'r_sprzzw'=>'rejestr sprzeda�y export'
	,'r_zakuzw'=>'rejestr zakupu export'
	,'r_swdt'=>'rejestr sprzeda�y WDT'
	,'r_swnt'=>'rejestr sprzeda�y WNT'
	,'r_zakup'=>'rejestr zakup�w towar�w'
	,'r_zakut'=>'rejestr zakup�w towar�w'
	,'rej_zk'=>'rejestr zakup�w towar�w'
	,'r_zakuu'=>'rejestr zakup�w us�ug'
	,'r_zakua'=>'rejestr zakup�w zwolnionych z VAT'
	,'r_zakum'=>'rejestr zakup�w materia��w'
	,'r_zakus'=>'rejestr zakup�w �rodk�w trwa�ych'
	,'r_zakuw'=>'rejestr zakup�w ...'
	,'r_zakuz'=>'rejestr zakup�w zwolnionych'
	,'srodkitr'=>'�rodki trwa�e'
	,'srodkiot'=>'�rodki trwa�e - dokumenty OT'
	,'srodkihi'=>'�rodki trwa�e - historia'
	,'srodkizm'=>'�rodki trwa�e - zmiany'
	,'lprac'=>'Listy p�at - pracownicy'
	,'lplac'=>'Listy p�at - nag��wki'
	,'lplacp'=>'Listy p�at - pozycje'
	,'lplacpp'=>'Listy p�at - sk�adniki pozycji'
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
echo '�cie�ka dost�pu do plik�w DBF na serwerze: <br><input class="form-control" name="path" value="'.$path.'" size="50">';
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
