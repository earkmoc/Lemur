<?php 

$firma = $_GET['firma'];

$buttons=array();

$buttons[]=array('klawisz'=>'1','nazwa'=>'','js'=>'Menu("1")');
$buttons[]=array('klawisz'=>'2','nazwa'=>'','js'=>'Menu("2")');
$buttons[]=array('klawisz'=>'3','nazwa'=>'','js'=>'Menu("3")');
$buttons[]=array('klawisz'=>'4','nazwa'=>'','js'=>'Menu("4")');
$buttons[]=array('klawisz'=>'5','nazwa'=>'','js'=>'Menu("5")');

$buttons[]=array('klawisz'=>'A','nazwa'=>'','js'=>'SubMenu("a")');
$buttons[]=array('klawisz'=>'B','nazwa'=>'','js'=>'SubMenu("b")');
$buttons[]=array('klawisz'=>'C','nazwa'=>'','js'=>'SubMenu("c")');
$buttons[]=array('klawisz'=>'D','nazwa'=>'','js'=>'SubMenu("d")');
$buttons[]=array('klawisz'=>'E','nazwa'=>'','js'=>'SubMenu("e")');
$buttons[]=array('klawisz'=>'F','nazwa'=>'','js'=>'SubMenu("f")');
$buttons[]=array('klawisz'=>'G','nazwa'=>'','js'=>'SubMenu("g")');
$buttons[]=array('klawisz'=>'H','nazwa'=>'','js'=>'SubMenu("h")');
$buttons[]=array('klawisz'=>'I','nazwa'=>'','js'=>'SubMenu("i")');
$buttons[]=array('klawisz'=>'J','nazwa'=>'','js'=>'SubMenu("j")');
$buttons[]=array('klawisz'=>'K','nazwa'=>'','js'=>'SubMenu("k")');
$buttons[]=array('klawisz'=>'L','nazwa'=>'','js'=>'SubMenu("l")');
$buttons[]=array('klawisz'=>'M','nazwa'=>'','js'=>'SubMenu("m")');
$buttons[]=array('klawisz'=>'N','nazwa'=>'','js'=>'SubMenu("n")');
$buttons[]=array('klawisz'=>'O','nazwa'=>'','js'=>'SubMenu("o")');
$buttons[]=array('klawisz'=>'P','nazwa'=>'','js'=>'SubMenu("p")');

$buttons[]=array('klawisz'=>'Up','nazwa'=>'','js'=>'Prev()');
$buttons[]=array('klawisz'=>'Down','nazwa'=>'','js'=>'Next()');
$buttons[]=array('klawisz'=>'Right','nazwa'=>'','js'=>'Prawo()');
$buttons[]=array('klawisz'=>'Left','nazwa'=>'','js'=>'Lewo()');

$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj�cie','akcja'=>"save.php?option='+$('a:focus').attr('id')+'&next=/Lemur2/Firmy");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
$title=mysqli_fetch_row(mysqli_query($link,$q="select NAZWA from klienci where PSKONT='$firma'"))[0];
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

$w=mysqli_query($link, $q="
select NR_ROW
	 , NR_COL
  from tabeles
 where ID_TABELE=0
   and ID_OSOBY='$ido'
");
$row='1';
$col='a';
while ($r=mysqli_fetch_row($w))
{
	$row=$r[0];
	$col=chr($r[1]);
}

$_SESSION["{$baza}Menu"]='';

?>

    <div class="container-fluid bs-docs-container">
      <div class="row">
        <div class="col-md-12" role="main">
           <div class="bs-docs-section" id="menu">
		   
                 <div class="col-md-3 szpalta">

<div class="table-responsive" id="menu1">
<table class="table table-hover table-bordered">
<tr><th><a id="1" href="">1. Dokumenty</a></th></tr>
<tr><td><a id="1a" href="../Dokumenty">a) Faktury VAT (FV)</a></td></tr>
<tr><td><a id="1b" href="../Dokumenty">b) Faktury VAT koryguj�ce (FVK)</a></td></tr>
<tr><td><a id="1c" href="../Dokumenty">c) Sprzeda� wysy�kowa (RU)</a></td></tr>
<tr><td style="border-bottom: 1px solid white"><a id="1d" href="../Dokumenty">d) Generator korekt (KOR)</a></td></tr>
<tr><td><a id="1e" href="../Dokumenty">e) Dokumenty RW</a></td></tr>
<tr><td><a id="1f" href="../Dokumenty">f) Dokumenty PW</a></td></tr>
<tr><td><a id="1g" href="../Dokumenty">g) Dokumenty WZ</a></td></tr>
<tr><td><a id="1h" href="../Dokumenty">h) Egzemplarze biblioteczne (WZB)</a></td></tr>
<tr><td><a id="1i" href="../Dokumenty">i) Egzemplarze autorskie (WZA)</a></td></tr>
<tr><td style="border-bottom: 1px solid white"><a id="1j" href="../Dokumenty">j) Likwidacja (WZZ)</a></td></tr>
<tr><td><a id="1k" href="../Dokumenty">k) Przychody wewn�trzne cykliczne (RWC)</a></td></tr>
<tr><td style="border-bottom: 1px solid white"><a id="1l" href="../Dokumenty">l) Rozchody wewn�trzne cykliczne (PWC)</a></td></tr>
<tr><td><a id="1m" href="../Dokumenty">m) Przyj�cia z drukarni (PZ)</a></td></tr>
<tr><td style="border-bottom: 1px solid white"><a id="1n" href="../Dokumenty">n) Inwentaryzacje (INW)</a></td></tr>
<tr><td><a id="1o" href="../Dokumenty">o) Wszystkie dokumenty</a></td></tr>
</table>
</div>
                 </div>
				 
                 <div class="col-md-2 szpalta">
				 
<div class="table-responsive" id="menu2">
<table class="table table-hover table-bordered">
<tr><th><a id="2" href="">2. Kartoteki</a></th></tr>
<tr><td><a id="2a" href="">a) Kontrahenci</td></tr>
<tr><td><a id="2b" href="">b) Notatki</td></tr>
<tr><td><a id="2c" href="">c) Karty tytu��w</td></tr>
<tr><td><a id="2d" href="">d) Tytu�y - syntetyka</td></tr>
<tr><td style="border-bottom: 1px solid white"><a id="2e" href="">e) Tytu�y - analityka</td></tr>
<tr><td><a id="2f" href="">f) Kontrahenci u�ywani</td></tr>
<tr><td style="border-bottom: 1px solid white"><a id="2g" href="">g) Kontrahenci nieu�ywani</td></tr>
<tr><td><a id="2h" href="">h) Tytu�y u�ywane</td></tr>
<tr><td style="border-bottom: 1px solid white"><a id="2i" href="">i) Tytu�y nieu�ywane</td></tr>
<tr><td><a id="2j" href="">j) Sposoby zap�at</td></tr>
<tr><td style="border-bottom: 1px solid white"><a id="2k" href="">k) Osoby uprawnione</td></tr>
<tr><td><a id="2l" href="../TypyDokumentow">l) Typy dokument�w</td></tr>
<tr><td><a id="2m" href="../Parametry">m) Parametry programu</td></tr>
<tr><td><a id="2n" href="../SrodkiTransportu">n) �rodki transportu</td></tr>
</table>
</div>
                 </div>

                 <div class="col-md-4 szpalta">
				 
<div class="table-responsive" id="menu3">
<table class="table table-hover table-bordered">
<tr><th><a id="3" href="">3. Analizy</a></th></tr>
<tr><td><a id="3a" href="">a) Ruch tytu�u</td></tr>
<tr><td><a id="3b" href="">b) Sprzeda� tytu�u przez kontrahent�w</td></tr>
<tr><td><a id="3c" href="">c) Sprzeda� tytu�u przez kontrahent�w (wg mies.)</td></tr>
<tr><td><a id="3d" href="">d) Sprzeda� kontrahenta wed�ug tytu��w</td></tr>
<tr><td><a id="3e" href="">e) Wybrana firma stan na dzie� ...</td></tr>
<tr><td><a id="3f" href="">f) Sprzeda� ��czna tytu��w w okresie</td></tr>
<tr><td><a id="3g" href="">g) Warto�� sprzeda�y kontrahent�w</td></tr>
<tr><td><a id="3h" href="">h) Dokumenty w okresie</td></tr>
<tr><td><a id="3i" href="">i) Dokumenty w okresie - rejestr</td></tr>
<tr><td><a id="3j" href="">j) Kontrahenci dawno bez faktury</td></tr>
<tr><td><a id="3k" href="">k) Kontrahenci dawno bez dokumentu RWC, PWC</td></tr>
<tr><td><a id="3l" href="">l) Sprawdzenie czy da si� skorygowa� dokument KOR</td></tr>
<tr><td><a id="3m" href="">m) Nak�ady tytu��w latami</td></tr>
<tr><td><a id="3n" href="">n) Ewidencja zap�at</td></tr>
<tr><td><a id="3o" href="">o) Rozliczenia w formie kasy</td></tr>
<tr><td><a id="3p" href="">p) Rozliczenia autor�w do PIT-4</td></tr>
</table>
</div>
				</div>

                 <div class="col-md-3 szpalta">
				 
<div class="table-responsive" id="menu4">
<table class="table table-hover table-bordered">
<tr><th><a id="4" href="">4. Rozliczenia</a></th></tr>
<tr><td><a id="4a" href="">a) Wszyscy (FV,RU,FZ)</td></tr>
<tr><td style="border-bottom: 1px solid white"><a id="4b" href="">b) Wybrany kontrahent</td></tr>
<tr><td><a id="4c" href="">c) Rozliczenia autor�w</td></tr>
<tr><td style="border-bottom: 1px solid white"><a id="4d" href="">d) Rachunki autor�w</td></tr>
<tr><td style="border-bottom: 1px solid white"><a id="4e" href="">e) Umowy o dzie�o, rachunki</td></tr>
<tr><td><a id="4f" href="">f) Kasa</td></tr>
</table>
</div>

<div class="table-responsive" id="menu5">
<table class="table table-hover table-bordered">
<tr><th><a id="5" href="">5. Ksi�gowo��</a></th></tr>
<tr><td><a id="5a" href="">a) Rejestr sprzeda�y</td></tr>
<tr><td><a id="5b" href="">b) Rejestr zakup�w</td></tr>
<tr><td><a id="5c" href="">c) Rejestr sprzeda�y VAT</td></tr>
<tr><td style="border-bottom: 1px solid white"><a id="5d" href="">d) Ksi�ga Przychod�w i Rozchod�w</td></tr>
<tr><td><a id="5e" href="">e) Zamkni�te okresy sprawozdawcze</td></tr>
</table>
</div>

                 </div>
			 </div>

        </div>
      </div>
    </div>

<?php 

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");

echo '<script type="text/javascript">'."\n";
echo "var menu='$row';\n";
echo "var option='$col';\n";
echo '</script>'."\n";

?>

<link href="index.css" rel="stylesheet">
<script src="index.js"></script>
