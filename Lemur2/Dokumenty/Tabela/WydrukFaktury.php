<?php

require("setup.php");

mysqli_query($link, "ALTER TABLE `slownik` CHANGE `OPIS` `OPIS` text NOT NULL DEFAULT ''");
mysqli_query($link, "ALTER TABLE `slownik` ADD UNIQUE `TST` (`TYP`, `SYMBOL`, `TRESC`)");

$problemy='';

//$_POST['uwagi']=trim($_POST['uwagi']);

foreach($_POST as $key => $value)
{
	$value=AddSlashes($value);
	$sets="TYP='parametry'
	   , SYMBOL='faktura'
	   , TRESC='$key'
	   , OPIS='$value'
	";
	mysqli_query($link,$q="
					  insert 
						into slownik
						 set $sets
	 on duplicate key update $sets
	");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}
}

$q=mysqli_query($link,"
update dokumenty
   set SPOSZAPL='$_POST[sposZapl]'
     , DTERMIN='$_POST[termin]'
     , WPLACONO='$_POST[wplacono]'
 where ID='$_GET[id]'
");

?>
<html>
<head>
<meta http-equiv="Content-type" content="text/html; charset=iso-8859-2">
<meta http-equiv="Reply-to" content="AMoch@pro.onet.pl">
<meta name="Author" content="Arkadiusz Moch">
<title>: Administrator</title>

<!-- jQuery -->
<script type="text/javascript" src="<?php echo "http://{$_SERVER['HTTP_HOST']}/Lemur2/";?>js/jquery-1.10.2.min.js"></script>

<style type="text/css">
<!--
@media print  {.breakhere {page-break-before: always;}}	
td {
	font-family: <?php echo $_POST['czcionka'];?>;
	font-size:   <?php echo $_POST['wielkosc'];?>pt;
}
.small {font-size: 8pt;}
.podkreslone {border-bottom: 1pt solid black;}
-->
</style>

<script type="text/javascript" language="JavaScript">
<!--

$(document).keydown(function(e) 
{
   $key=e.keyCode;
   if ($key==27) {
		location.href='index.php';      
		return false;
   }
   return true;
});

-->
</script>

</head>

<body>

<?php 

$klient=mysqli_fetch_array($q=mysqli_query($link,"
select *
  from Lemur2.klienci
 where PSKONT='$baza'
"));

$problemy.=(!$klient['NAZWA']?'Brak nazwy sprzedawcy. ':'');
$problemy.=(!$klient['ADRES']?'Brak adresu sprzedawcy. ':'');
$problemy.=(!$klient['NIP']?'Brak NIPu sprzedawcy. ':'');

$dokument=mysqli_fetch_array($q=mysqli_query($link,"
select *
  from dokumenty
 where ID='$_GET[id]'
"));

$problemy.=(!$dokument['NAZWA']?'Brak nazwy nabywcy. ':'');
$problemy.=(!$dokument['ADRES']?'Brak adresu nabywcy. ':'');
$problemy.=(!$dokument['NIP']?'Brak NIPu nabywcy. ':'');

$problemy.=(!$dokument['NUMER']?'Brak numeru dokumentu. ':'');
$problemy.=(!$dokument['SPOSZAPL']?'Brak sposobu płatności. ':'');
$problemy.=(($dokument['WPLACONO']<>$dokument['WARTOSC'])&&($dokument['DTERMIN']*1==0)?'Brak terminu płatności dla nieuregulowanej należności. ':'');
$problemy.=((stripos($dokument['SPOSZAPL'],'przelew')!==false)&&($_POST['konto']=='')?'Brak konta bankowego przy płatności przelewem. ':'');

?>
<table border="0" width="100%">
	<tr>
		<td colspan="2" align="right">
		</td>
		<td colspan="1" align="right">
			<table cellspacing="0" cellpadding="3" rules="none" border="0">
				<tr align="center">
					<td class="podkreslone"><?php echo $_POST['miasto'];?></td>
					<td>dnia</td>
					<td class="podkreslone"><?php echo $_POST['dataWystawienia'];?></td>
				</tr>
				<tr align="center">
					<td class="small">miejscowość</td>
					<td class="small"> </td>
					<td class="small">data wystawienia</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td width="48%" valign="top">
			<table cellspacing="0" cellpadding="3" rules="none" width="100%" border="1">
				<tbody>
					<tr align="left"><td>Sprzedawca:</td></tr>
					<tr align="middle"><td><font style="font-size:14pt"><?php echo $klient['NAZWA'];?></font></td></tr>
					<tr align="middle"><td><?php echo $klient['ADRES'];?></td></tr>
					<tr align="middle"><td><b>NIP: <?php echo $klient['NIP'];?></b></td></tr>
				</tbody>
			</table>
		</td>
		<td width="4%"> </td>
		<td width="48%" valign="top">
			<table cellspacing="0" cellpadding="3" rules="none" width="100%" height="100%" border="1">
				<tbody>
					<tr align="left"><td>Nabywca:</td></tr>
					<tr align="middle"><td><font style="font-size:14pt"><?php echo $dokument['NAZWA'];?></font></td></tr>
					<tr align="middle"><td><?php echo $dokument['ADRES'];?></td></tr>
					<tr align="middle"><td><b>NIP: <?php echo $dokument['NIP'];?></b></td></tr>
				</tbody>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="3" align="center"><br><b><font style="font-size:16pt"><?php echo $_POST['nazwaDokumentu'];?> Nr <?php echo $dokument['NUMER'];?></font></b><br><br></td>
	</tr>
</table>

<table border="0" width="100%">
	<tr>
		<td width="5%"> </td>
		<td width="20%" class="podkreslone"><?php echo $_POST['zamowienie'];?></td>
		<td width="5%"> </td>
		<td width="20%" class="podkreslone"><?php echo $_POST['srodekTransportu'];?></td>
		<td width="5%"> </td>
		<td width="20%" class="small" nowrap valign="bottom">Data dokonania lub zakończenia</td>
		<td width="20%" class="podkreslone"  valign="bottom" align="center"><?php echo $_POST['dataWykonania'];?></td>
		<td width="5%"> </td>
	</tr>
	<tr>
		<td width="5%"> </td>
		<td width="20%" class="small">zamówienie</td>
		<td width="5%"> </td>
		<td width="20%" class="small">środek transportu</td>
		<td width="5%"> </td>
		<td width="40%" class="small" colspan="2">dostawy towarów lub wykonania usługi (zaliczki)</td>
		<td width="5%">&nbsp;</td>
	</tr>
</table>

<br>

<table border="0" width="100%">
	<tr>
		<td width="30%" rowspan="3" valign="top">Sposób&nbsp;płatności:&nbsp;<?php echo $_POST['sposZapl'];?></td>
		<td align="right" nowrap>Termin płatności: </td>
		<td class="podkreslone" nowrap><?php echo $_POST['termin'];?> </td>
		<td> </td>
	</tr>
	<tr>
		<td align="right" nowrap>Nazwa Banku: </td>
		<td class="podkreslone" colspan="2" nowrap><?php echo $_POST['bank'];?> </td>
	</tr>
	<tr>
		<td align="right" nowrap>Nr konta: </td>
		<td class="podkreslone" colspan="2" nowrap><?php echo $_POST['konto'];?> </td>
	</tr>
</table>

<table border="1" width="100%" cellpadding="3" cellspacing="0">
	<tr align="center">
		<td rowspan="3">Lp.</td>
<?php
	$podstawyPrawne=(mysqli_fetch_row(mysqli_query($link,$q="
	select count(*)
	  from dokumentm
	 where ID_D='$_GET[id]'
	   and LOT<>''
	"))[0]<>0);

	if($podstawyPrawne)
	{
		echo '		<td rowspan="3">Nazwa towaru lub usługi</td>';
		echo '		<td rowspan="3" class="small">Podstawa prawna zwolnienia od podatku</td>';
	}
	else
	{
		echo '		<td rowspan="3" colspan="2">Nazwa towaru lub usługi</td>';
	}
?>
		<td rowspan="3" class="small">Symb. j.m.</td>
		<td rowspan="3" align="right">Ilość</td>
		<td rowspan="2" class="small" style="border-bottom:0">Cena jednostkowa bez podatku</td>
		<td rowspan="2" class="small" style="border-bottom:0">Wartość towaru (usługi) bez podatku</td>
		<td rowspan="1" class="small" colspan="2">Podatek</td>
		<td rowspan="2" class="small" style="border-bottom:0">Wartość towaru (usługi) z podatkiem</td>
	</tr>
	<tr align="center">
		<td rowspan="1" class="small" style="border-bottom:0" >Stawka</td>
		<td rowspan="1" class="small" style="border-bottom:0" align="right">Kwota</td>
	</tr>
	<tr>
		<td rowspan="1" class="small" align="right"  style="border-top:0">zł. gr.</td>
		<td rowspan="1" class="small" align="right"  style="border-top:0">zł. gr.</td>
		<td rowspan="1" class="small" align="center" style="border-top:0">%</td>
		<td rowspan="1" class="small" align="right"  style="border-top:0">zł. gr.</td>
		<td rowspan="1" class="small" align="right"  style="border-top:0">zł. gr.</td>
	</tr>
<?php 

$lp=0;

$towary=mysqli_query($link,$q="
select *
  from dokumentm
 where ID_D='$_GET[id]'
 order by ID
");

$nettos=array();
$vats=array();
$bruttos=array();
while($towar=mysqli_fetch_array($towary))
{
	++$lp;
	
	$nettos[$towar['STAWKA']]=((@!isset($nettos[$towar['STAWKA']]))?$towar['NETTO']:1*$nettos[$towar['STAWKA']]+$towar['NETTO']);
	$vats[$towar['STAWKA']]=((@!isset($vats[$towar['STAWKA']]))?$towar['VAT']:1*$vats[$towar['STAWKA']]+$towar['VAT']);
	$bruttos[$towar['STAWKA']]=((@!isset($bruttos[$towar['STAWKA']]))?$towar['BRUTTO']:1*$bruttos[$towar['STAWKA']]+$towar['BRUTTO']);

	$problemy.=($towar['ILOSC']==0?"W specyfikacji towarowej w pozycji o LP=$lp ilość towaru/usługi jest zerowa. ":'');

	$iloscCena=round($towar['ILOSC']*$towar['CENA'],2);
	$iloscCenaF=number_format($iloscCena,2,'.',',');
	$problemy.=(round(abs($towar['NETTO']-$iloscCena),2)>=0.01?"W specyfikacji towarowej w pozycji o LP=$lp wartość netto towaru ($towar[NETTO]) jest inna niż wynikająca z ilość*cena ($iloscCena). ":'');

	$vat=round($towar['NETTO']*$towar['STAWKA']*0.01,2);
	$vatF=number_format($vat,2,'.',',');
	$problemy.=(round(abs($towar['VAT']-$vat),2)>=0.01?"W specyfikacji towarowej w pozycji o LP=$lp wartość VAT towaru ($towar[VAT]) jest inna niż wynikająca z netto*stawka ($vatF). ":'');

	$brutto=$towar['NETTO']+$towar['VAT'];
	$bruttoF=number_format($brutto,2,'.',',');
	$problemy.=(round(abs($towar['BRUTTO']-$brutto),2)>=0.01?"W specyfikacji towarowej w pozycji o LP=$lp wartość brutto towaru ($towar[BRUTTO]) jest inna niż wynikająca z netto+VAT ($bruttoF). ":'');

	$towar['ILOSC']=number_format($towar['ILOSC'],3,'.',',');
	$towar['ILOSC']=trim(str_replace('.000',' ',$towar['ILOSC']),'0');
	$towar['CENA']=number_format($towar['CENA'],2,'.',',');
	$towar['NETTO']=number_format($towar['NETTO'],2,'.',',');
	$towar['VAT']=number_format($towar['VAT'],2,'.',',');
	$towar['BRUTTO']=number_format($towar['BRUTTO'],2,'.',',');

	$problemy.=((($towar['STAWKA']=='zw.')&&($towar['LOT']==''))?"W specyfikacji towarowej w pozycji o LP=$lp stawka \"zw.\" nie jest uzasadniona w polu \"Podstawa prawna zwolnienia od podatku\". ":'');
	$problemy.=((($towar['STAWKA']<>'zw.')&&($towar['LOT']<>''))?"W specyfikacji towarowej w pozycji o LP=$lp stawka inna niż \"zw.\" jest niepotrzebnie uzasadniona w polu \"Podstawa prawna zwolnienia od podatku\". ":'');
?>
	<tr>
		<td><?php echo $lp;?></td>
<?php
	if($podstawyPrawne)
	{
		echo '<td>'.($towar['NAZWA']).'</td>';
		echo '<td class="small">'.($towar['LOT']).'</td>';
	}
	else
	{
		echo '<td colspan="2">'.($towar['NAZWA']).'</td>';
	}
?>
		<td align="center"><?php echo $towar['JM'];?></td>
		<td align="right"><?php echo $towar['ILOSC'];?></td>
		<td align="right"><?php echo $towar['CENA'];?></td>
		<td align="right"><?php echo $towar['NETTO'];?></td>
		<td align="center"><?php echo $towar['STAWKA'];?></td>
		<td align="right"><?php echo $towar['VAT'];?></td>
		<td align="right"><?php echo $towar['BRUTTO'];?></td>
	</tr>
<?php 
}

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/funkcje.php");

$slownie=Slownie($dokument['WARTOSC'],'',1).' i '.(1*Slownie($dokument['WARTOSC'],'',2)).'/100 zł';

$dokument['NETTOVAT']=number_format($dokument['NETTOVAT'],2,'.',',');
$dokument['PODATEK_VAT']=number_format($dokument['PODATEK_VAT'],2,'.',',');

$pozostalo=$dokument['WARTOSC']-$dokument['WPLACONO'];
$problemy.=($dokument['WARTOSC']<$dokument['WPLACONO']?'Zapłacono jest większe niż wartość do zapłaty. ':'');

$dokument['WARTOSC']=number_format($dokument['WARTOSC'],2,'.',',');
$dokument['WPLACONO']=number_format($dokument['WPLACONO'],2,'.',',');
$pozostalo=number_format($pozostalo,2,'.',',');

$nettoSuma=0;
$vatSuma=0;
$bruttoSuma=0;
foreach($nettos as $key => $value)
{
	$nettoSuma+=$value;
	$vats[$key]=round($value*$key*0.01,2);
	$vatSuma+=$vats[$key];
	$bruttos[$key]=$value+$vats[$key];
	$bruttoSuma+=$bruttos[$key];
	$nettos[$key]=number_format($nettos[$key],2,'.',',');
	$vats[$key]=number_format($vats[$key],2,'.',',');
	$bruttos[$key]=number_format($bruttos[$key],2,'.',',');
}

$nettoSuma=number_format($nettoSuma,2,'.',',');
$problemy.=($dokument['NETTOVAT']<>$nettoSuma?"Netto dokumentu ($dokument[NETTOVAT]) jest inne niż suma netto ($nettoSuma) wynikająca ze stopki specyfikacji towarów/usług. ":'');

$vatSuma=number_format($vatSuma,2,'.',',');
$problemy.=($dokument['PODATEK_VAT']<>$vatSuma?"VAT dokumentu ($dokument[PODATEK_VAT]) jest inny niż suma VAT ($vatSuma) wynikająca ze stopki specyfikacji towarów/usług. ":'');

$bruttoSuma=number_format($bruttoSuma,2,'.',',');
$problemy.=($dokument['WARTOSC']<>$bruttoSuma?"Brutto dokumentu ($dokument[WARTOSC]) jest inne niż suma brutto ($bruttoSuma) wynikająca ze stopki specyfikacji towarów/usług. ":'');

?>
	<tr>
		<td colspan="10" style="border-left:0; border-right:0;border-top:1; border-bottom:0;"> </td>
	</tr>
	<tr>
		<td colspan="5" style="border-left:0; border-right:0;border-top:0; border-bottom:0;"><b>Do zapłaty: <?php echo $dokument['WARTOSC'];?> zł</b></td>
		<td align="right" style="border-left:0; border-right:0;border-top:0; border-bottom:0;"><b>RAZEM:</b></td>
		<td align="right" style="border-left:2px solid black; border-right:1px solid black;border-top:2px solid black; border-bottom:2px solid black;"><?php echo $dokument['NETTOVAT'];?></td>
		<td align="right" style="border-left:1px solid black; border-right:1px solid black;border-top:2px solid black; border-bottom:2px solid black;"> </td>
		<td align="right" style="border-left:1px solid black; border-right:1px solid black;border-top:2px solid black; border-bottom:2px solid black;"><?php echo $dokument['PODATEK_VAT'];?></td>
		<td align="right" style="border-left:1px solid black; border-right:2px solid black;border-top:2px solid black; border-bottom:2px solid black;"><?php echo $dokument['WARTOSC'];?></td>
	</tr>
	<tr>
		<td colspan="5" style="border-left:0; border-right:0;border-top:0; border-bottom:0;">(<span class="small">słownie:</span> <?php echo $slownie;?>)</td>
		<td align="right"colspan="1" style="border-left:0; border-right:0;border-top:0; border-bottom:0;">W tym:</td>
		<td align="right"><?php echo @$nettos['23%'];?></td>
		<td align="right">23</td>
		<td align="right"><?php echo @$vats['23%'];?></td>
		<td align="right"><?php echo @$bruttos['23%'];?></td>
	</tr>
	<tr>
		<td colspan="5" style="border-left:0; border-right:0;border-top:0; border-bottom:0;">Zapłacono: <?php echo $dokument['WPLACONO'];?> zł</td>
		<td align="right"colspan="1" style="border-left:0; border-right:0;border-top:0; border-bottom:0;"></td>
		<td align="right"><?php echo @$nettos['8%'];?></td>
		<td align="right">8</td>
		<td align="right"><?php echo @$vats['8%'];?></td>
		<td align="right"><?php echo @$bruttos['8%'];?></td>
	</tr>
	<tr>
		<td colspan="5" style="border-left:0; border-right:0;border-top:0; border-bottom:0;">Pozostało do zapłaty: <?php echo $pozostalo;?> zł</td>
		<td align="right"colspan="1" style="border-left:0; border-right:0;border-top:0; border-bottom:0;"></td>
		<td align="right"><?php echo @$nettos['5%'];?></td>
		<td align="right">5</td>
		<td align="right"><?php echo @$vats['5%'];?></td>
		<td align="right"><?php echo @$bruttos['5%'];?></td>
	</tr>
	<tr>
		<td rowspan="7" colspan="6" style="border-left:0; border-right:0;border-top:0; border-bottom:0;">Uwagi: <?php echo nl2br($_POST['uwagi']);?></td>
		<td align="right"><?php echo @$nettos['0%'];?></td>
		<td align="right">0</td>
		<td align="right"> </td>
		<td align="right"><?php echo @$bruttos['0%'];?></td>
	</tr>
	<tr>
		<td align="right"><?php echo @$nettos['zw.'];?></td>
		<td align="right">zw.</td>
		<td align="right"> </td>
		<td align="right"><?php echo @$bruttos['zw.'];?></td>
	</tr>
	<tr>
		<td rowspan="5" colspan="4" style="border-left:0; border-right:0;border-top:0; border-bottom:0;"> </td>
	</tr>
</table>

</body>
</html>

<script type="text/javascript" language="JavaScript">
<!--
$(document).ready(function() {
<?php
	echo ($problemy?"$('body').css('background','red');alert('$problemy');":'print();');
?>
});
-->
</script>
