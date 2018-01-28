<?php 

if(@$_GET['save']==1)
{
	//die(print_r($_POST));
}

require("Tabela/setup.php");

$buttons=array();
//$buttons[]=array('klawisz'=>'Enter','nazwa'=>'','akcja'=>'?save=1');

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
//$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>'/Lemur2/Klienci/?baza='.$baza);
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>($ido==1?'/Lemur2/Klienci/Tabela/?baza='.$baza:'/Lemur2/Logowanie/Tabela/logout.php'));
$buttons[]=array('klawisz'=>'AltO','nazwa'=>'Old menu','akcja'=>'Tabela');

$title=mysqli_fetch_array(mysqli_query($link,$q="select * from Lemur2.klienci where PSKONT='$baza'"))['NAZWA'];
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
		   
                 <div class="col-md-6">

<div class="table-responsive" id="menu1">
<table class="table table-hover table-bordered table-striped">
<tr><th><a id="1" href="">1. Dokumenty</a></th></tr>
<tr><td><a id="1a" href="../Dokumenty/Tabela/?typ=FV">a) Faktury VAT (FV)</a></td></tr>
<tr><td><a id="1b" href="../Dokumenty/Tabela/?typ=FVK">b) Faktury VAT koryguj±ce (FVK)</a></td></tr>
<tr><td><a id="1c" href="../Dokumenty/Tabela/?typ=FZ">c) Faktury zakupu (FZ)</a></td></tr>
<tr><td><a id="1d" href="../Dokumenty/Tabela/?typ=FVK">d) Faktury zakupu koryguj±ce (FZK)</a></td></tr>
<tr><td><a id="1e" href="../Dokumenty/Tabela/?typ=PZ">e) Dokumenty PZ</a></td></tr>
<tr><td><a id="1f" href="../Dokumenty/Tabela/?typ=WZ">f) Dokumenty WZ</a></td></tr>
<tr><td><a id="1g" href="../Dokumenty/Tabela/?typ=MM">g) Dokumenty MM</a></td></tr>
<tr><td><a id="1h" href="../Dokumenty/Tabela/?typ=PW">h) Dokumenty PW</a></td></tr>
<tr><td><a id="1i" href="../Dokumenty/Tabela/?typ=RW">i) Dokumenty RW</a></td></tr>
<tr><td><a id="1j" href="../Dokumenty/Tabela/?typ=INW">j) Inwentaryzacje (INW)</a></td></tr>
<tr><td><a id="1k" href="../Dokumenty/Tabela/?typ=_">k) Wszystkie dokumenty</a></td></tr>
</table>
</div>
                 </div>
				 
                 <div class="col-md-6">
				 
<div class="table-responsive" id="menu2">
<table class="table table-hover table-bordered table-striped">
<tr><th><a id="2" href="">2. Kartoteki</a></th></tr>
<tr><td><a id="2a" href="..\Kontrahenci">a) Kontrahenci</td></tr>
<tr><td><a id="2b" href="..\Magazyn">b) Magazyn</td></tr>
<tr><td><a id="2c" href="..\Slownik">c) S³ownik</td></tr>
</table>
</div>

<div class="table-responsive" id="menu3">
<table class="table table-hover table-bordered table-striped">
<tr><th><a id="3" href="">3. Ksiêgowo¶æ</a></th></tr>
<tr><td><a id="3a" href="../JPK2/?baza=Filutek">a) JPK_VAT (2) do 2017-12-31</td></tr>
<tr><td><a id="3b" href="../JPK_VAT3/?baza=Filutek">b) JPK_VAT (3) od 2018-01-31</td></tr>
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
