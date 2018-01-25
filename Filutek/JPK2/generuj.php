<?php

error_reporting(E_ALL);
ini_set('display_errors', 1);

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$raport='';
$czas=date('Y-m-d H:i:s');
$filename=$_POST['filename']; 
$baza=$_GET['baza'];

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

$klient=mysqli_fetch_array(mysqli_query($link,$q="select * from Lemur.klienci where PSKONT='$baza'"));

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
	mysqli_query($link,$q="update Lemur.klienci set KODUS='$_POST[kodUS]' where PSKONT='$baza'");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}

	$file=fopen($filename,"w");

	fputs($file,'<?xml version="1.0" encoding="UTF-8"?>
<JPK xmlns="http://jpk.mf.gov.pl/wzor/2016/10/26/10261/" xmlns:etd="http://crd.gov.pl/xml/schematy/dziedzinowe/mf/2016/01/25/eD/DefinicjeTypy/">
	<Naglowek>
		<KodFormularza kodSystemowy="JPK_VAT (2)" wersjaSchemy="1-0">JPK_VAT</KodFormularza>
		<WariantFormularza>2</WariantFormularza>');
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
	fputs($file,"\n"."			<KodKraju>$klient[KRAJ]</KodKraju>");
	fputs($file,"\n"."			<Wojewodztwo>".(iconv('ISO-8859-2','UTF-8',StripSlashes($klient['WOJEWODZTWO'])))."</Wojewodztwo>");
	fputs($file,"\n"."			<Powiat>".(iconv('ISO-8859-2','UTF-8',StripSlashes($klient['POWIAT'])))."</Powiat>");
	fputs($file,"\n"."			<Gmina>".(iconv('ISO-8859-2','UTF-8',StripSlashes($klient['GMINA'])))."</Gmina>");
	fputs($file,"\n"."			<Ulica>".(iconv('ISO-8859-2','UTF-8',StripSlashes($klient['ULICA'])))."</Ulica>");
	fputs($file,"\n"."			<NrDomu>$klient[NRDOMU]</NrDomu>");
	fputs($file,"\n"."			<Miejscowosc>".(iconv('ISO-8859-2','UTF-8',StripSlashes($klient['MIEJSCOWOSC'])))."</Miejscowosc>");
	fputs($file,"\n"."			<KodPocztowy>$klient[KOD]</KodPocztowy>");
	fputs($file,"\n"."			<Poczta>".(iconv('ISO-8859-2','UTF-8',StripSlashes($klient['POCZTA'])))."</Poczta>");
	fputs($file,"\n"."		</AdresPodmiotu>");
	fputs($file,"\n"."	</Podmiot1>");

	$lp=0;
	$podatekNalezny=0;
	$podatekNaliczony=0;

	$sumaKS=array();
	for($i=10;$i<=39;++$i)
	{
		if($_POST["K$i"])
		{
			$sumaKS["K$i"]=0;
		}
	}

	$sumaKZ=array();
	for($i=43;$i<=46;++$i)
	{
		if($_POST["K$i"])
		{
			$sumaKZ["K$i"]=0;
		}
	}

	$w=mysqli_query($link,"
		select *
		  from $baza.dokumenty
		 where DOPERACJI between '$_POST[OdDaty]' and '$_POST[DoDaty]'
		   and NUMER<>''
	  order by DOPERACJI, ID
	");
	while($r=mysqli_fetch_array($w))
	{
		$KS=array();
		$ok=false;
		for($i=10;$i<=39;++$i)
		{
			if($kwota=Formula($link,$baza,$r,$i,$_POST["K$i"]))
			{
				$ok=true;
				$KS["K_$i"]=$kwota;
				$sumaKS["K$i"]+=$kwota;
				if(in_array($i,array(16,18,20,24,26,28,30,33,35,36,37)))
				{
					$podatekNalezny+=$kwota;
				}
			}
		}
		if(!$ok)
		{
			continue;
		}
		
		++$lp;

		$nip=preg_replace('/\D/', '', $r['NIP']);
		$nip=(!$nip?'brak':$nip);
		$nazwa=iconv('ISO-8859-2','UTF-8',StripSlashes($r['NAZWA']));
		if(strpos($nazwa,'&')>0)
		{
			$nazwa=str_replace('&',' and ',$nazwa);
		}
		$adres=iconv('ISO-8859-2','UTF-8',StripSlashes($r['ADRES']));
		$numer=iconv('ISO-8859-2','UTF-8',StripSlashes($r['NUMER']));

		fputs($file,"\n".'	<SprzedazWiersz typ="G">');
		fputs($file,"\n"."		<LpSprzedazy>$lp</LpSprzedazy>");
		fputs($file,"\n"."		<NrKontrahenta>$nip</NrKontrahenta>");
		fputs($file,"\n"."		<NazwaKontrahenta>$nazwa</NazwaKontrahenta>");
		fputs($file,"\n"."		<AdresKontrahenta>$adres</AdresKontrahenta>");
		fputs($file,"\n"."		<DowodSprzedazy>$numer</DowodSprzedazy>");
		fputs($file,"\n"."		<DataWystawienia>".($r['DDOKUMENTU'])."</DataWystawienia>");
		foreach($KS as $key => $value)
		{
			fputs($file,"\n"."		<$key>$value</$key>");
		}
		fputs($file,"\n".'	</SprzedazWiersz>');
	}

	$raport.="Sprzeda¿: $lp szt.\n";
	foreach($sumaKS as $key => $value)
	{
		$value=($value?number_format($value,2,'.',','):'');
		$raport.="$key=<input style='text-align:right' value='$value' /> z³\n";
	}
	$value=$podatekNalezny;
	$value=($value?number_format($value,2,'.',','):'');
	$raport.="Podatek nale¿ny=<input style='text-align:right' value='$value' /> z³\n";

	fputs($file,"\n"."	<SprzedazCtrl>");
	fputs($file,"\n"."		<LiczbaWierszySprzedazy>$lp</LiczbaWierszySprzedazy>");
	fputs($file,"\n"."		<PodatekNalezny>$podatekNalezny</PodatekNalezny>");
	fputs($file,"\n"."	</SprzedazCtrl>");

	$lp=0;
	$w=mysqli_query($link,"
		select *
		  from $baza.dokumenty
		 where DOPERACJI between '$_POST[OdDaty]' and '$_POST[DoDaty]'
		   and NUMER<>''
	  order by DOPERACJI, ID
	");
	while($r=mysqli_fetch_array($w))
	{
		$KZ=array();
		$ok=false;
		for($i=43;$i<=46;++$i)
		{
			if($kwota=Formula($link,$baza,$r,$i,$_POST["K$i"]))
			{
				$ok=true;
				$KZ["K_$i"]=$kwota;
				$sumaKZ["K$i"]+=$kwota;
				if(in_array($i,array(44,46)))
				{
					$podatekNaliczony+=$kwota;
				}
			}
		}
		if(!$ok)
		{
			continue;
		}

		++$lp;

		$nip=preg_replace('/\D/', '', $r['NIP']);
		$nip=(!$nip?'brak':$nip);
		$nazwa=iconv('ISO-8859-2','UTF-8',StripSlashes($r['NAZWA']));
		if(strpos($nazwa,'&')>0)
		{
			$nazwa=str_replace('&','and',$nazwa);
		}
		$adres=iconv('ISO-8859-2','UTF-8',StripSlashes($r['ADRES']));
		$numer=iconv('ISO-8859-2','UTF-8',StripSlashes($r['DODOK']?$r['DODOK']:$r['TYP'].' Nr '.$r['NUMER']));

		fputs($file,"\n".'	<ZakupWiersz typ="G">');
		fputs($file,"\n"."		<LpZakupu>$lp</LpZakupu>");
		fputs($file,"\n"."		<NrDostawcy>$nip</NrDostawcy>");
		fputs($file,"\n"."		<NazwaDostawcy>$nazwa</NazwaDostawcy>");
		fputs($file,"\n"."		<AdresDostawcy>$adres</AdresDostawcy>");
		fputs($file,"\n"."		<DowodZakupu>$numer</DowodZakupu>");
		fputs($file,"\n"."		<DataZakupu>".($r['DDOKUMENTU'])."</DataZakupu>");
		fputs($file,"\n"."		<DataWplywu>".($r['DOPERACJI'])."</DataWplywu>");
		$jestK45=false;
		$jestK46=false;
		foreach($KZ as $key => $value)
		{
			fputs($file,"\n"."		<$key>$value</$key>");
			$jestK45=(($key=='K_45')&&($value>0));
			$jestK46=(($key=='K_46')&&($value>0));
		}
		if($jestK45&&!$jestK46)
		{
			fputs($file,"\n"."		<K_46>0</K_46>");
		}
		fputs($file,"\n".'	</ZakupWiersz>');
	}
	
	fputs($file,"\n"."	<ZakupCtrl>");
	fputs($file,"\n"."		<LiczbaWierszyZakupow>$lp</LiczbaWierszyZakupow>");
	fputs($file,"\n"."		<PodatekNaliczony>$podatekNaliczony</PodatekNaliczony>");
	fputs($file,"\n"."	</ZakupCtrl>");
	fputs($file,"\n"."</JPK>");

	fclose($file);

	$raport.="\nZakup: $lp szt.\n";
	foreach($sumaKZ as $key => $value)
	{
		$value=($value?number_format($value,2,'.',','):'');
		$raport.="$key=<input style='text-align:right' value='$value' /> z³\n";
	}
	$value=$podatekNaliczony;
	$value=($value?number_format($value,2,'.',','):'');
	$raport.="Podatek naliczony=<input style='text-align:right' value='$value' /> z³\n";
}

$title="JPK_VAT (2) - generowanie pliku: raport";
$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"../Menu");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

echo "<h2>Raport generowania pliku $filename:</h2>";
echo "<hr>";

$xml = new DOMDocument();
$xml->load($filename);
echo "Walidacja zgodno¶ci z XSD: ".($xml->schemaValidate("Schemat_JPK_VAT_v1-0.xsd")?"OK":"NO");

echo '<h3>'.nl2br($raport).'</h3>';

echo '<hr>';

echo $czas.' czas rozpoczêcia';
echo '<br>';
echo date('Y-m-d H:i:s').' czas zakoñczenia';

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");

echo '<pre>';
echo "<h2>Podgl±d kontrolny fragmentu zawarto¶ci pliku $filename:</h2>";
echo iconv('UTF-8','ISO-8859-2',str_replace(array('<','>'),array('&lt;','&gt;'),file_get_contents($filename,null,null,0,6000))).' [...]';
//echo iconv('UTF-8','ISO-8859-2',str_replace(array('<','>'),array('&lt;','&gt;'),file_get_contents($filename)));
echo '</pre>';

function Formula($link,$baza,$dokument,$i,$formula)
{
	if(!$formula)
	{
		return false;
	}
	$formula=str_replace('"',"'",$formula);
	$formula=str_replace('`',"'",$formula);
	$formula=str_replace('Netto(','Netto($link,$baza,$dokument,',$formula);
	$formula=str_replace('VAT(',    'VAT($link,$baza,$dokument,',$formula);

	return eval('return '.$formula.';');
}

function Netto($link,$baza,$dokument,$typDokumentu,$bezStawki)
{
	if($bezStawki)
	{
		$bezStawki=str_replace('-','',$bezStawki);	//wyrzuæ minus
		$bezNetto=mysqli_fetch_row(mysqli_query($link,"
			select sum(NETTO)
			  from $baza.dokumentr
			 where ID_D='$dokument[ID]'
			   and STAWKA like '%$bezStawki%'
		"))[0];
		$dokument['NETTOVAT']-=$bezNetto;
	}
	if($gwiazdka=strpos($typDokumentu,'*'))
	{
		return ((substr($dokument['TYP'],0,$gwiazdka)==substr($typDokumentu,0,$gwiazdka))?$dokument['NETTOVAT']:0);
	}
	else
	{
		return (($dokument['TYP']==$typDokumentu)?$dokument['NETTOVAT']:0);
	}
}

function VAT($link,$baza,$dokument,$typDokumentu)
{
	if($gwiazdka=strpos($typDokumentu,'*'))
	{
		return ((substr($dokument['TYP'],0,$gwiazdka)==substr($typDokumentu,0,$gwiazdka))?$dokument['PODATEK_VAT']:0);
	}
	else
	{
		return (($dokument['TYP']==$typDokumentu)?$dokument['PODATEK_VAT']:0);
	}
}
