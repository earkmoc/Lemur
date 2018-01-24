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
  from Lemur.klienci
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

$problemy.=(!$dokument['NAZWA']?'Brak nazwy odbiorcy. ':'');
$problemy.=(!$dokument['ADRES']?'Brak adresu odbiorcy. ':'');

$problemy.=(!$dokument['NUMER']?'Brak numeru dokumentu. ':'');

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
					<tr align="left"><td>Odbiorca:</td></tr>
					<tr align="middle"><td><font style="font-size:14pt"><?php echo $dokument['NAZWA'];?></font></td></tr>
					<tr align="middle"><td><?php echo $dokument['ADRES'];?></td></tr>
					<tr align="middle"><td><b>NIP: <?php echo $dokument['NIP'];?></b></td></tr>
				</tbody>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="3" align="center"><br><b><font style="font-size:16pt"><?php echo $_GET['typ'];?> Nr <?php echo $dokument['NUMER'];?></font></b><br><br></td>
	</tr>
</table>

<table border="0" width="100%">
	<tr>
		<td width="5%"> </td>
		<td width="20%" class="podkreslone"><?php echo $_POST['zamowienie'];?></td>
		<td width="5%"> </td>
		<td width="20%" class="podkreslone"><?php echo $_POST['srodekTransportu'];?></td>
		<td width="5%"> </td>
		<td width="20%" class="small" nowrap valign="bottom">Data Dostawy / Wykonania</td>
		<td width="20%" class="podkreslone"  valign="bottom" align="center"><?php echo $_POST['dataWykonania'];?></td>
		<td width="5%"> </td>
	</tr>
	<tr>
		<td width="5%"> </td>
		<td width="20%" class="small">zamówienie</td>
		<td width="5%"> </td>
		<td width="20%" class="small">środek transportu</td>
		<td width="5%"> </td>
		<td width="40%" class="small" colspan="2"></td>
		<td width="5%">&nbsp;</td>
	</tr>
</table>

<br>

<table border="1" width="100%" cellpadding="3" cellspacing="0">
	<tr align="center">
		<td rowspan="1">Lp.</td>
		<td rowspan="1" colspan="1">Nazwa towaru</td>
		<td rowspan="1" colspan="1">Indeks</td>
		<td rowspan="1" align="right">Ilość</td>
		<td rowspan="1" class="small">j.m.</td>
	</tr>
<?php 

$lp=0;

$towary=mysqli_query($link,$q="
select *
  from dokumentm
 where ID_D='$_GET[id]'
 order by ID
");

$ileRazem=0;
while($towar=mysqli_fetch_array($towary))
{
	++$lp;
	$ileRazem+=$towar['ILOSC'];
	$problemy.=($towar['ILOSC']==0?"W specyfikacji towarowej w pozycji o LP=$lp ilość towaru/usługi jest zerowa. ":'');

	$towar['ILOSC']=number_format($towar['ILOSC'],3,'.',',');
	$towar['ILOSC']=trim(str_replace('.000',' ',$towar['ILOSC']),'0');
?>
	<tr>
		<td><?php echo $lp;?></td>
<?php
	echo '<td colspan="1">'.($towar['NAZWA']).'</td>';
	echo '<td colspan="1">'.($towar['INDEKS']).'</td>';
?>
		<td align="right"><?php echo $towar['ILOSC'];?></td>
		<td align="center"><?php echo $towar['JM'];?></td>
	</tr>
<?php 
}

?>
	<tr>
		<td colspan="5" style="border-left:0; border-right:0;border-top:1; border-bottom:0;"> </td>
	</tr>
	<tr>
		<td colspan="3" align="right" style="border-left:0; border-right:0;border-top:0; border-bottom:0;"><b>Razem:</b></td>
		<td align="right" style="border-left:2px solid black; border-right:1px solid black;border-top:2px solid black; border-bottom:2px solid black;"><?php echo $ileRazem;?></td>
	</tr>
</table>

<table border="0" width="100%" cellpadding="3" cellspacing="0">
<tr>
<td>Towar wydał(a)</td>
<td>&nbsp;</td>
<td>Towar odebrał(a)</td>
</tr>
<tr>
<td style="border-bottom:1px dotted black;">&nbsp</td>
<td>&nbsp;</td>
<td style="border-bottom:1px dotted black;">&nbsp</td>
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
