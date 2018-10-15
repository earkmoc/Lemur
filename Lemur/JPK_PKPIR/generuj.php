<?php

error_reporting(E_ALL);
ini_set('display_errors', 1);

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$raport='';
$czas=date('Y-m-d H:i:s');
$filename=$_POST['filename']; 
$baza=$_GET['baza'];

$_POST["P_1"]=number_format(1*str_replace(',','',$_POST["P_1"]),2,'.','');
$_POST["P_2"]=number_format(1*str_replace(',','',$_POST["P_2"]),2,'.','');
$_POST["P_3"]=number_format(1*str_replace(',','',$_POST["P_3"]),2,'.','');
$_POST["P_4"]=number_format(1*str_replace(',','',$_POST["P_4"]),2,'.','');
$_POST["P_5B"]=number_format(1*str_replace(',','',$_POST["P_5B"]),2,'.','');

foreach($_POST as $key => $value)
{
	$value=AddSlashes($value);
	$sets="TYP='parametry'
	   , SYMBOL='JPK'
	   , TRESC='$key'
	   , OPIS='$value'
	";
	mysqli_query($link,$q="
					  insert 
						into Lemur.slownik
						 set $sets
	 on duplicate key update $sets
	");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}
}

$klient=mysqli_fetch_array(mysqli_query($link,$q="select * from Lemur2.klienci where PSKONT='$baza'"));

$klient['KODUS']=substr($_POST['kodUS'],0,4);

if	( ($klient['NAZWA']=='')
	||($klient['NIP']=='')
	||($klient['MIEJSCOWOSC']=='')
	||($klient['KRAJ']=='')
	||($klient['WALUTA']=='')
	||($klient['KODUS']=='')
	)
{
	$raport="B£¡D! UZUPE£NIJ OBOWI¡ZKOWE DANE:\nSprawd¼: kod urzêdu skarbowego, waluta, kraj, miasto, NIP, nazwa";
}
else
{
	mysqli_query($link,$q="update Lemur2.klienci set KODUS='$_POST[kodUS]' where PSKONT='$baza'");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}

	$file=fopen($filename,"w");

	fputs($file,'<?xml version="1.0" encoding="UTF-8"?>
<JPK xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://jpk.mf.gov.pl/wzor/2016/03/09/03096/" xmlns:etd="http://crd.gov.pl/xml/schematy/dziedzinowe/mf/2016/01/25/eD/DefinicjeTypy/"  >
	<Naglowek>
        <KodFormularza kodSystemowy="JPK_PKPIR (1)" wersjaSchemy="1-0" >JPK_PKPIR</KodFormularza>
        <WariantFormularza>1</WariantFormularza>');
	fputs($file,"\n".'		<CelZlozenia>'.(substr($_POST['cel'],0,1)).'</CelZlozenia>');
	fputs($file,"\n".'		<DataWytworzeniaJPK>'.(date('Y-m-d').'T'.date('H:i:s')).'</DataWytworzeniaJPK>');
	fputs($file,"\n"."		<DataOd>$_POST[OdDaty]</DataOd>");
	fputs($file,"\n"."		<DataDo>$_POST[DoDaty]</DataDo>");
	fputs($file,"\n"."		<DomyslnyKodWaluty>$klient[WALUTA]</DomyslnyKodWaluty>");
	fputs($file,"\n"."		<KodUrzedu>$klient[KODUS]</KodUrzedu>");
	fputs($file,"\n"."	</Naglowek>");

	fputs($file,"\n"."	<Podmiot1>");
	fputs($file,"\n"."		<IdentyfikatorPodmiotu>");
	fputs($file,"\n"."			<etd:NIP>".(preg_replace('/\D/', '', $klient['NIP']))."</etd:NIP>");
	fputs($file,"\n"."			<etd:PelnaNazwa>".(iconv('ISO-8859-2','UTF-8',StripSlashes($klient['NAZWA'])))."</etd:PelnaNazwa>");
	fputs($file,"\n"."			<etd:REGON>$klient[REGON]</etd:REGON>");
	fputs($file,"\n"."		</IdentyfikatorPodmiotu>");

	fputs($file,"\n"."		<AdresPodmiotu>");
	fputs($file,"\n"."			<etd:KodKraju>$klient[KRAJ]</etd:KodKraju>");
	fputs($file,"\n"."			<etd:Wojewodztwo>".(iconv('ISO-8859-2','UTF-8',StripSlashes($klient['WOJEWODZTWO'])))."</etd:Wojewodztwo>");
	fputs($file,"\n"."			<etd:Powiat>".(iconv('ISO-8859-2','UTF-8',StripSlashes($klient['POWIAT'])))."</etd:Powiat>");
	fputs($file,"\n"."			<etd:Gmina>".(iconv('ISO-8859-2','UTF-8',StripSlashes($klient['GMINA'])))."</etd:Gmina>");
	fputs($file,"\n"."			<etd:Ulica>".(iconv('ISO-8859-2','UTF-8',StripSlashes($klient['ULICA'])))."</etd:Ulica>");
	fputs($file,"\n"."			<etd:NrDomu>$klient[NRDOMU]</etd:NrDomu>");
	fputs($file,"\n"."			<etd:Miejscowosc>".(iconv('ISO-8859-2','UTF-8',StripSlashes($klient['MIEJSCOWOSC'])))."</etd:Miejscowosc>");
	fputs($file,"\n"."			<etd:KodPocztowy>$klient[KOD]</etd:KodPocztowy>");
	fputs($file,"\n"."			<etd:Poczta>".(iconv('ISO-8859-2','UTF-8',StripSlashes($klient['POCZTA'])))."</etd:Poczta>");
	fputs($file,"\n"."		</AdresPodmiotu>");

	fputs($file,"\n"."	</Podmiot1>");

	fputs($file,"\n"."  <PKPIRInfo>");
	fputs($file,"\n"."      <P_1>$_POST[P_1]</P_1>");
	fputs($file,"\n"."      <P_2>$_POST[P_2]</P_2>");
	fputs($file,"\n"."      <P_3>$_POST[P_3]</P_3>");
	fputs($file,"\n"."      <P_4>$_POST[P_4]</P_4>");
	if($_POST['P_5A'])
	{
		fputs($file,"\n"."      <P_5A>$_POST[P_5A]</P_5A>");
		fputs($file,"\n"."      <P_5B>$_POST[P_5B]</P_5B>");
	}
	fputs($file,"\n"."  </PKPIRInfo>");

	$lp=0;
	$sumaPrzychodow=0;

	$w=mysqli_query($link,"
		select *
		  from $baza.kpr
		 where DATA between '$_POST[OdDaty]' and '$_POST[DoDaty]'
	  order by LP, DATA, ID
	");
	while($r=mysqli_fetch_array($w))
	{
		++$lp;

//		$nip=preg_replace('/\D/', '', $r['NIP']);
		$nip=(str_replace('-','',str_replace(' ','',$r['NIP'])));
		$nip=(!$nip?'brak':$nip);
		$nazwa=iconv('ISO-8859-2','UTF-8',StripSlashes($r['NAZWA']));
		if(strpos($nazwa,'&')>0)
		{
			$nazwa=str_replace('&',' and ',$nazwa);
		}
		$adres=iconv('ISO-8859-2','UTF-8',StripSlashes($r['ADRES']));
		$numer=iconv('ISO-8859-2','UTF-8',StripSlashes($r['NRDOW']));

		$przedmiot=iconv('ISO-8859-2','UTF-8',StripSlashes($r['OPIS']));
		$przedmiot=$przedmiot?$przedmiot:'brak';

		$uwagi=iconv('ISO-8859-2','UTF-8',StripSlashes($r['UWAGI']));

		fputs($file,"\n".'  <PKPIRWiersz typ="G">');
		fputs($file,"\n"."		<K_1>$lp</K_1>");
		fputs($file,"\n"."		<K_2>$r[DATA]</K_2>");
		fputs($file,"\n"."		<K_3>$numer</K_3>");
		fputs($file,"\n"."		<K_4>$nazwa</K_4>");
		fputs($file,"\n"."		<K_5>$adres</K_5>");
		fputs($file,"\n"."		<K_6>$przedmiot</K_6>");
		fputs($file,"\n"."		<K_7>$r[PRZYCHOD1]</K_7>");
		fputs($file,"\n"."		<K_8>$r[PRZYCHOD2]</K_8>");
		fputs($file,"\n"."		<K_9>$r[PRZYCHOD3]</K_9>");$sumaPrzychodow+=$r['PRZYCHOD3'];
		fputs($file,"\n"."		<K_10>$r[ZAKUP_TOW]</K_10>");
		fputs($file,"\n"."		<K_11>$r[KOSZTY_UB]</K_11>");
		fputs($file,"\n"."		<K_12>$r[WYNAGRODZENIA]</K_12>");
		fputs($file,"\n"."		<K_13>$r[POZOSTALE]</K_13>");
		fputs($file,"\n"."		<K_14>$r[RAZEM]</K_14>");
		fputs($file,"\n"."		<K_15>$r[INNE]</K_15>");
		if($uwagi)
		{
			fputs($file,"\n"."		<K_16>$uwagi</K_16>");
		}
		fputs($file,"\n".'  </PKPIRWiersz>');
	}

	$raport.="Pozycji: $lp szt.\n";
	$value=$sumaPrzychodow;
	$value=($value?number_format($value,2,'.',','):'');
	$raport.="Suma przychodów=<input style='text-align:right' value='$value' /> z³\n";

	if($lp>0)
	{
		fputs($file,"\n"."  <PKPIRCtrl>");
		fputs($file,"\n"."	  <LiczbaWierszy>$lp</LiczbaWierszy>");
		fputs($file,"\n"."	  <SumaPrzychodow>$sumaPrzychodow</SumaPrzychodow>");
		fputs($file,"\n"."  </PKPIRCtrl>");
	}
	
	fputs($file,"\n"."</JPK>");

	fclose($file);
}

$title="JPK_PKPIR (1) - generowanie pliku: raport";
$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"../Menu");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

echo "<h2>Raport generowania pliku $filename:</h2>";
echo "<hr>";

$xml = new DOMDocument();
$xml->load($filename);
echo "Walidacja zgodno¶ci z XSD: ".($xml->schemaValidate("Schemat_JPK_PKPIR_v1-0.xsd")?"OK":"NO");

echo '<h3>'.nl2br($raport).'</h3>';

echo '<hr>';

echo $czas.' czas rozpoczêcia';
echo '<br>';
echo date('Y-m-d H:i:s').' czas zakoñczenia';

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");

echo '<pre>';
echo "<h2>Podgl±d kontrolny fragmentu zawarto¶ci pliku $filename:</h2>";
echo iconv('UTF-8','ISO-8859-2',str_replace(array('<','>'),array('&lt;','&gt;'),file_get_contents($filename,null,null,0,7000))).' [...]';
//echo iconv('UTF-8','ISO-8859-2',str_replace(array('<','>'),array('&lt;','&gt;'),file_get_contents($filename)));
echo '</pre>';
