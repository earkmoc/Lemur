<?php 

if(@$_GET['save']==1)
{
	//die(print_r($_POST));
}

require("Tabela/setup.php");

$buttons=array();
//$buttons[]=array('klawisz'=>'Enter','nazwa'=>'','akcja'=>'?save=1');

$buttons[]=array('klawisz'=>'C','nazwa'=>'','js'=>'SubMenu("c")');

$buttons[]=array('klawisz'=>'1','nazwa'=>'','js'=>'Menu("1")');
$buttons[]=array('klawisz'=>'2','nazwa'=>'','js'=>'Menu("2")');
$buttons[]=array('klawisz'=>'3','nazwa'=>'','js'=>'Menu("3")');
$buttons[]=array('klawisz'=>'4','nazwa'=>'','js'=>'Menu("4")');
$buttons[]=array('klawisz'=>'5','nazwa'=>'','js'=>'Menu("5")');
$buttons[]=array('klawisz'=>'6','nazwa'=>'','js'=>'Menu("6")');
$buttons[]=array('klawisz'=>'7','nazwa'=>'','js'=>'Menu("7")');
$buttons[]=array('klawisz'=>'8','nazwa'=>'','js'=>'Menu("8")');
$buttons[]=array('klawisz'=>'9','nazwa'=>'','js'=>'Menu("9")');
$buttons[]=array('klawisz'=>'0','nazwa'=>'','js'=>'Menu("0")');
$buttons[]=array('klawisz'=>'A','nazwa'=>'','js'=>'SubMenu("a")');
$buttons[]=array('klawisz'=>'B','nazwa'=>'','js'=>'SubMenu("b")');

$buttons[]=array('klawisz'=>'D','nazwa'=>'','js'=>'SubMenu("d")');
$buttons[]=array('klawisz'=>'E','nazwa'=>'','js'=>'SubMenu("e")');
$buttons[]=array('klawisz'=>'F','nazwa'=>'','js'=>'SubMenu("f")');
$buttons[]=array('klawisz'=>'G','nazwa'=>'','js'=>'SubMenu("g")');
$buttons[]=array('klawisz'=>'H','nazwa'=>'','js'=>'SubMenu("h")');
$buttons[]=array('klawisz'=>'I','nazwa'=>'','js'=>'SubMenu("i")');
$buttons[]=array('klawisz'=>'J','nazwa'=>'','js'=>'SubMenu("j")');
$buttons[]=array('klawisz'=>'K','nazwa'=>'','js'=>'SubMenu("k")');
$buttons[]=array('klawisz'=>'L','nazwa'=>'','js'=>'SubMenu("l")');
$buttons[]=array('klawisz'=>'Up','nazwa'=>'','js'=>'Prev()');
$buttons[]=array('klawisz'=>'Down','nazwa'=>'','js'=>'Next()');
$buttons[]=array('klawisz'=>'Right','nazwa'=>'','js'=>'Prawo()');
$buttons[]=array('klawisz'=>'Left','nazwa'=>'','js'=>'Lewo()');
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>'/Lemur/Klienci/?baza='.$baza);
$buttons[]=array('klawisz'=>'AltO','nazwa'=>'Old menu','akcja'=>'Tabela');

$title="Menu";
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

$w=mysqli_query($link, $q="
select NR_ROW
	 , NR_COL
	 , WARUNKI
	 , SORTOWANIE
  from tabeles
 where ID_TABELE=0
   and ID_OSOBY='$ido'
");
$row='8';
$col='a';
$nip='';
$nazwa='';
while ($r=mysqli_fetch_row($w))
{
	$row=$r[0];
	$col=chr($r[1]);
	$nip=StripSlashes(str_replace("'","`",$r[2]));
	$nazwa=StripSlashes(str_replace("'","`",$r[3]));
}

$_SESSION["{$baza}Menu"]='';

?>

<div class="modal" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
   <div class="modal-dialog modal-lg">
      <div class="modal-content">
         <div class="modal-body">
				<iframe  id="iframeKontrahenci" width='100%' height='700' src='<?php echo "http://{$_SERVER['HTTP_HOST']}/$baza/Kontrahenci/Tabela/?Menu=1";?>'></iframe>
         </div>
      </div>
   </div>
</div>

    <div class="container-fluid bs-docs-container">
      <div class="row">

        <div class="col-md-2">
          <div class="bs-sidebar hidden-print" role="complementary">

			<ul class="nav bs-sidenav">
				<li><a href="Tabela">... Old menu ...</a></li>
				<li><a href="#obsluga">1. Obs³uga klienta</a></li>
				<li><a href="#magazyny">2. Magazyny</a></li>
				<li><a href="#produkcja">3. Produkcja</a></li>
				<li><a href="#handel">4. Handel +</a></li>
				<li><a href="#srodki">5. ¦rodki trwa³e</a></li>
				<li><a href="#kadry">6. Kadry i p³ace</a></li>
				<li><a href="#kartoteka">7. Kartoteka</a></li>
				<li><a href="#analityka">8. Ksiêgowo¶æ i analityka</a></li>
				<li><a href="#ksiegowosc">9. Ksiêgowo¶æ +</a></li>
				<li><a href="#ustawienia">0. Ustawienia programu</a></li>
            </ul>
<div id="uwaga">
Wci¶niêcie&nbsp;cyfry&nbsp;wybiera&nbsp;menu<br>
Wci¶niêcie&nbsp;litery&nbsp;wybiera&nbsp;opcjê<br>
Klawisze&nbsp;góra/dó³:&nbsp;zmiana&nbsp;opcji<br>
Klawisze&nbsp;lewo/prawo:&nbsp;zmiana&nbsp;menu<br>
</div>
		</div>
	</div>


        <div class="col-md-10" role="main">

           <div class="bs-docs-section" id="menu">
                 <div class="col-md-4">

<div class="table-responsive" id="obsluga">
<table class="table table-hover table-bordered table-striped">
<tr><th><a href="" id="1">1. Obs³uga klienta</a></th></tr>
<tr><td><a href="" id="1a" onclick="$('input[name=NIP]').focus(); return false;">a) NIP:</a> <input name="NIP" value="<?php echo $nip;?>" onchange="valid('NIP','NIP')" /> <button hidden>dane z GUS</button></td></tr>
<tr><td><a href="" id="1b" onclick="$('input[name=NAZWA]').focus(); return false;">b) Nazwa:</a> <input name="NAZWA" value='<?php echo $nazwa;?>' onchange="valid('NAZWA','NAZWA')" /></td></tr>
<tr><td><a href="../DokumentyKlienta" id="1c">c) Obs³u¿ klienta</a></td></tr>
<tr><td><a href="" id="1d">d) Sprzeda¿</a></td></tr>
<tr><td><a href="" id="1e">e) Zakup</a></td></tr>
<tr><td><a href="" id="1f">f) Rozliczenia</a></td></tr>
<tr><td><a href="" id="1g">g) Import/Export danych</a></td></tr>
</table>
</div>

<div class="table-responsive" id="magazyny">
<table class="table table-hover table-bordered table-striped">
<tr><th><a href="" id="2">2. Magazyny</a></th></tr>
<tr><td><a href="../Magazyn" id="2a">a) Wybrany magazyn:</a> <select name="magazyn"><?php
if(mysqli_fetch_row(mysqli_query($link, $q="
select count(*)
  from slownik
 where TYP='magazyny'
"))[0]==0)
{
	mysqli_query($link, $q="
	insert
	  into slownik
	   set TYP='magazyny'
	     , LP=1
		 , SYMBOL='G'
	     , TRESC='G³ówny'
	");
}
$w=mysqli_query($link, $q="
select TRESC
  from slownik
 where TYP='magazyny'
");
while($r=mysqli_fetch_row($w))
{
	echo "<option>$r[0]";
}
?></select></td></tr>
<tr><td><a href="" id="2b">b) PZ - Przyjêcie Zewnêtrzne</a></td></tr>
<tr><td><a href="" id="2c">c) WZ - Wydanie Zewnêtrzne</a></td></tr>
<tr><td><a href="" id="2d">d) PW - Przyjêcie Wewnêtrzne</a></td></tr>
<tr><td><a href="" id="2e">e) RW - Rozchód Wewnêtrzny</a></td></tr>
<tr><td><a href="" id="2f">f) MM - Miêdzy Magazynami</a></td></tr>
<tr><td><a href="" id="2g">g) KPL - Kompletacja</a></td></tr>
<tr><td><a href="" id="2h">h) Import/Export danych</a></td></tr>
</table>
</div>

<div class="table-responsive" id="produkcja">
<table class="table table-hover table-bordered table-striped">
<tr><th><a href="" id="3">3. Produkcja</a></th></tr>
<tr><td><a href="" id="3a">a) Przegl±daj produkty</td></tr>
<tr><td><a href="" id="3b">b) Utwórz nowy produkt</td></tr>
<tr><td><a href="" id="3c">c) Import/Export danych</td></tr>
</table>
</div>
                 </div>
                 <div class="col-md-4">
<div class="table-responsive" id="handel">
<table class="table table-hover table-bordered table-striped">
<tr><th><a href="" id="4">4. Handel +</a></th></tr>
<tr><td><a href="" id="4a">a) Moje cenniki</td></tr>
<tr><td><a href="" id="4b">b) Moje oferty</td></tr>
<tr><td><a href="" id="4c">c) Utwórz grupê klientów</td></tr>
<tr><td><a href="" id="4d">d) Utwórz sprzeda¿ cykliczn±</td></tr>
<tr><td><a href="" id="4e">e) Utwórz relacje z klientem/grup±</td></tr>
<tr><td><a href="" id="4f">f) Kartoteka CRM</td></tr>
</table>
</div>

<div class="table-responsive" id="srodki">
<table class="table table-hover table-bordered table-striped">
<tr><th><a href="" id="5">5. ¦rodki trwa³e</a></th></tr>
<tr><td><a href="../SrodkiTr" id="5a">a) Amortyzacja - plan</td></tr>
<tr><td><a href="../SrodkiTr" id="5b">b) Ksiêga Inwentarzowa</td></tr>
<tr><td><a href="" id="5c">c) Dodaj nowy</td></tr>
</table>
</div>

<div class="table-responsive" id="kadry">
<table class="table table-hover table-bordered table-striped">
<tr><th><a href="" id="6">6. Kadry i p³ace</a></th></tr>
<tr><td><a href="" id="6a">a) Przypomnienia
<tr><td><a href="" id="6b">b) Terminarz
<tr><td><a href="../ListyPlac" id="6c">c) Listy p³ac
<tr><td><a href="../Pracownicy" id="6d">d) Pracownicy
<tr><td><a href="" id="6e">e) ZUS
<tr><td><a href="" id="6f">f) Delegacje
<tr><td><a href="" id="6g">g) ¦wiadczenia
</table>
</div>

<div class="table-responsive" id="kartoteka">
<table class="table table-hover table-bordered table-striped">
<tr><th><a href="" id="7">7. Kartoteka firmy</a></th></tr>
<tr><td><a href="" id="7a">a) Samochody</td></tr>
<tr><td><a href="" id="7b">b) Analizy sprzeda¿y itp.</td></tr>
<tr><td><a href="" id="7c">c) Inne wa¿ne rzeczy dla prezesa</td></tr>
</table>
</div>
                 </div>
                 <div class="col-md-4">
				 
<div class="table-responsive" id="analityka">
<table class="table table-hover table-bordered table-striped">
<tr><th><a href="" id="8">8. Ksiêgowo¶æ i analityka</a></th></tr>
<tr><td><a href="../Dokumenty" id="8a">a) Dokumenty</td></tr>
<tr><td><a href="../Rejestry" id="8b">b) Rejestry VAT / inne rejestry</td></tr>
<tr><td><a href="../KPIR" id="8c">c) KPiR</td></tr>
<tr><td><a href="../EwidencjaWyposazenia" id="8d">d) Ewidencja Wyposa¿enia</td></tr>
<tr><td><a href="../Sprawozdawczosc" id="8e">e) Sprawozdawczo¶æ</td></tr>
</table>
</div>

<div class="table-responsive" id="ksiegowosc">
<table class="table table-hover table-bordered table-striped">
<tr><th><a href="" id="9">9. Ksiêgowo¶æ +</a></th></tr>
<tr><td><a href="../PlanKont" id="9a">a) Plan kont</td></tr>
<tr><td><a href="../Dziennik" id="9b">b) Dziennik g³ówny</td></tr>
<tr><td><a href="../AOK" id="9c">c) Analityka konta</td></tr>
<tr><td><a href="../RachunekWynikow" id="9d">d) Rachunek Wyników</td></tr>
<tr><td><a href="../BilansAktywa" id="9e">e) Bilans Aktywa</td></tr>
<tr><td><a href="../BilansPasywa" id="9f">f) Bilans Pasywa</td></tr>
<tr><td><a href="../ZOS" id="9g">g) Zestawienie obrotów i sald</td></tr>
<tr><td><a href="../ZSY" id="9h">h) Zestawienie syntetyczne</td></tr>
<tr><td><a href="<?php echo "../JPK2/JPK_FA.php?baza=$baza";?>" id="9i">i) JPK_FA (1)</td></tr>
<tr><td><a href="<?php echo "../JPK2/?baza=$baza";?>" id="9j">j) JPK_VAT (2)</td></tr>
<tr><td><a href="<?php echo "../JPK_VAT3/?baza=$baza";?>" id="9k">k) JPK_VAT (3)</td></tr>
</table>
</div>
		
<div class="table-responsive" id="ustawienia">
<table class="table table-hover table-bordered table-striped">
<tr><th><a href="" id="0">0. Ustawienia programu</a></th></tr>
<tr><td><a href="../Schematy" id="0a">a) Schematy</td></tr>
<tr><td><a href="../Slownik" id="0b">b) S³ownik</td></tr>
<tr><td><a href="" id="0c">c) Dane</td></tr>
<tr><td><a href="" id="0d">d) Licencja programu</td></tr>
<tr><td><a href="" id="0e">e) Panel</td></tr>
<tr><td><a href="" id="0f">f) Infolinia/helpdesk/zamów us³ugê</td></tr>
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
