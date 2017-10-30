<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$raport='';
$czas=date('Y-m-d H:i:s');
$filename=$_POST['filename']; 
$baza=$_GET['baza'];

$_POST['kodUS']=substr($_POST['kodUS'],0,4);

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

$klient['KODUS']=$_POST['kodUS'];

if	( ($klient['NAZWA']=='')
	||($klient['NIP']=='')
	||($klient['MIEJSCOWOSC']=='')
	||($klient['KRAJ']=='')
	||($klient['WALUTA']=='')
	||($klient['KODUS']=='')
	)
{
	$raport="B��D! UZUPE�NIJ OBOWI�ZKOWE DANE:\nSprawd�: kod urz�du skarbowego, waluta, kraj, miasto, NIP, nazwa";
}
else
{
	mysqli_query($link,$q="update Lemur.klienci set KODUS='$_POST[kodUS]' where PSKONT='$baza'");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}

	$file=fopen($filename,"w");

//--------------------------------------------------------------------------------------------------------------------------------

	fputs($file,'<?xml version="1.0" encoding="UTF-8"?>
<JPK xmlns="http://jpk.mf.gov.pl/wzor/2016/03/09/03095/" xmlns:etd="http://crd.gov.pl/xml/schematy/dziedzinowe/mf/2016/01/25/eD/DefinicjeTypy/">
	<Naglowek>
		<KodFormularza kodSystemowy="JPK_FA(1)" wersjaSchemy="1-0">JPK_FA</KodFormularza>
		<WariantFormularza>1</WariantFormularza>');
	fputs($file,"\n".'		<CelZlozenia>'.(substr($_POST['cel'],0,1)).'</CelZlozenia>');
	fputs($file,"\n".'		<DataWytworzeniaJPK>'.(date('Y-m-d').'T'.date('H:i:s')).'</DataWytworzeniaJPK>');
	fputs($file,"\n"."		<DataOd>$_POST[OdDaty]</DataOd>");
	fputs($file,"\n"."		<DataDo>$_POST[DoDaty]</DataDo>");
	fputs($file,"\n"."		<DomyslnyKodWaluty>$klient[WALUTA]</DomyslnyKodWaluty>");
	fputs($file,"\n"."		<KodUrzedu>$klient[KODUS]</KodUrzedu>");
	fputs($file,"\n"."	</Naglowek>");

//--------------------------------------------------------------------------------------------------------------------------------

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
	$w=mysqli_query($link,"
		select *
		  from $baza.dokumenty
		 where DOPERACJI between '$_POST[OdDaty]' and '$_POST[DoDaty]'
		   and NUMER<>''
	  order by DOPERACJI, ID
	");
	while($r=mysqli_fetch_array($w))
	{
		++$lp;
		$prefiksN='';
		$nip=preg_replace('/\D/', '', $r['NIP']);
		$nip=(!$nip?'brak':$nip);
		$nazwa=iconv('ISO-8859-2','UTF-8',StripSlashes($r['NAZWA']));
		if(strpos($nazwa,'&')>0)
		{
			$nazwa=str_replace('&',' and ',$nazwa);
		}
		$adres=iconv('ISO-8859-2','UTF-8',StripSlashes($r['ADRES']));
		$numer=iconv('ISO-8859-2','UTF-8',StripSlashes($r['NUMER']));
		
		$prefiksS='';
		$klient['NAZWA']=iconv('ISO-8859-2','UTF-8',StripSlashes($klient['NAZWA']));
		$klient['ADRES']=iconv('ISO-8859-2','UTF-8',StripSlashes($klient['ADRES']));
		$klient['NIP']=preg_replace('/\D/', '', $klient['NIP']);

//--------------------------------------------------------------------------------------------------------------------------------

		fputs($file,"\n".'	<Faktura typ="G">');
		fputs($file,"\n"."		<P_1>$r[DDOKUMENTU]</P_1>");
		fputs($file,"\n"."		<P_2A>$numer</P_2A>");
		fputs($file,"\n"."		<P_3A>$nazwa</P_3A>");
		fputs($file,"\n"."		<P_3B>$adres</P_3B>");
		fputs($file,"\n"."		<P_3C>$klient[NAZWA]</P_3C>");
		fputs($file,"\n"."		<P_3D>$klient[ADRES]</P_3D>");
		fputs($file,"\n"."		<P_4A>$prefiksS</P_4A>");
		fputs($file,"\n"."		<P_4B>$klient[NIP]</P_4B>");
		fputs($file,"\n"."		<P_5A>$prefiksN</P_5A>");
		fputs($file,"\n"."		<P_5B>$nip</P_5B>");
		
		//Data dokonania lub zako�czenia dostawy towar�w lub wykonania us�ugi lub data otrzymania zap�aty, o kt�rej mowa w art. 106b ust. 1 pkt 4, o ile taka data jest okre�lona i r�ni si� od daty wystawienia faktury
		if($r['DDOKUMENTU']<>$r['DOPERACJI'])
		{
			fputs($file,"\n"."		<P_6>$r[DOPERACJI]</P_6>");
		}
		
		//Suma warto�ci sprzeda�y netto ze stawk� podstawow� - aktualnie 23% albo 22%
		if($n22||$n23)
		{
			fputs($file,"\n"."		<P_13_1>".($n22+$n23)."</P_13_1>");
		}

		//Kwota podatku od sumy warto�ci sprzeda�y netto ze stawk� podstawow� - aktualnie 23% albo 22%
		if($v22||$v23)
		{
			fputs($file,"\n"."		<P_14_1>".($v22+$v23)."</P_14_1>");
		}

		//Suma warto�ci sprzeda�y netto ze stawk� obni�on� pierwsz� - aktualnie 8 % albo 7%
		if($n7||$n8)
		{
			fputs($file,"\n"."		<P_13_2>".($n22+$n23)."</P_13_2>");
		}

		//Kwota podatku od sumy warto�ci sprzeda�y netto ze stawk� obni�on� - aktualnie 8% albo 7%
		if($v7||$v8)
		{
			fputs($file,"\n"."		<P_14_2>".($v22+$v23)."</P_14_2>");
		}

		//Suma warto�ci sprzeda�y netto ze stawk� obni�on� drug� - aktualnie 5%
		if($n5)
		{
			fputs($file,"\n"."		<P_13_3>".($n5)."</P_13_3>");
		}

		//Kwota podatku od sumy warto�ci sprzeda�y netto ze stawk� obni�on� drug� - aktualnie 5%
		if($v5)
		{
			fputs($file,"\n"."		<P_14_3>".($v5)."</P_14_3>");
		}

		//Suma warto�ci sprzeda�y netto ze stawk� obni�on� trzeci� - pole rezerwowe
		if($n3)
		{
			fputs($file,"\n"."		<P_13_4>".($n3)."</P_13_4>");
		}

		//Kwota podatku od sumy warto�ci sprzeda�y netto ze stawk� obni�on� trzeci� - pole rezerwowe
		if($v3)
		{
			fputs($file,"\n"."		<P_14_4>".($v3)."</P_14_4>");
		}

		//Suma warto�ci sprzeda�y netto ze stawk� obni�on� czwart� - pole rezerwowe
		if($n4)
		{
			fputs($file,"\n"."		<P_13_5>".($n4)."</P_13_5>");
		}

		//Kwota podatku od sumy warto�ci sprzeda�y netto ze stawk� obni�on� czwart� - pole rezerwowe
		if($v4)
		{
			fputs($file,"\n"."		<P_14_5>".($v4)."</P_14_5>");
		}

		//Suma warto�ci sprzeda�y netto ze stawk� 0%
		if($n0)
		{
			fputs($file,"\n"."		<P_13_6>".($n0)."</P_13_6>");
		}

		//Suma warto�ci sprzeda�y zwolnionej
		if($nzw)
		{
			fputs($file,"\n"."		<P_13_7>".($nzw)."</P_13_7>");
		}

		fputs($file,"\n"."		<P_15>$brutto</P_15>");

		$Art19aUst5Pkt1LubArt21Ust1='false';
		fputs($file,"\n"."		<P_16>$Art19aUst5Pkt1LubArt21Ust1</P_16>");	//W przypadku dostawy towar�w lub �wiadczenia us�ug, w odniesieniu do kt�rych obowi�zek podatkowy powstaje zgodnie z art. 19a ust. 5 pkt 1 lub art. 21 ust. 1 - wyrazy "metoda kasowa", nale�y poda� warto�� "true"; w przeciwnym przypadku - warto�� - "false"

		$Art106dUst1='false';
		fputs($file,"\n"."		<P_17>$Art106dUst1</P_17>");	//W przypadku faktur, o kt�rych mowa w art. 106d ust. 1 - wyraz "samofakturowanie", nale�y poda� warto�� "true"; w przeciwnym przypadku - warto�� - "false"

		$oo='false';
		fputs($file,"\n"."		<P_18>$oo</P_18>");	//W przypadku dostawy towar�w lub wykonania us�ugi, dla kt�rych obowi�zanym do rozliczenia podatku, podatku od warto�ci dodanej lub podatku o podobnym charakterze jest nabywca towaru lub us�ugi - wyrazy "odwrotne obci��enie", nale�y poda� warto�� "true"; w przeciwnym przypadku - warto�� - "false"

		$Art43Ust1Art113Ust1i9alboArt82Ust3='false';
		fputs($file,"\n"."		<P_19>$Art43Ust1Art113Ust1i9alboArt82Ust3</P_19>");	//W przypadku dostawy towar�w lub �wiadczenia us�ug zwolnionych od podatku na podstawie art. 43 ust. 1, art. 113 ust. 1 i 9 albo przepis�w wydanych na podstawie art. 82 ust. 3 nale�y poda� warto�� "true"; w przeciwnym przypadku - warto�� - "false"

		$Art43Ust1Art113Ust1i9alboArt82Ust3PrzepisUstawy='';
		if	( $Art43Ust1Art113Ust1i9alboArt82Ust3=='true'
			&&$Art43Ust1Art113Ust1i9alboArt82Ust3PrzepisUstawy
			)
		{
			fputs($file,"\n"."		<P_19A>$Art43Ust1Art113Ust1i9alboArt82Ust3PrzepisUstawy</P_19A>");	//Je�li pole P_19 r�wna si� "true" - nale�y wskaza� przepis ustawy albo aktu wydanego na podstawie ustawy, na podstawie kt�rego podatnik stosuje zwolnienie od podatku
		}
		
		$Art43Ust1Art113Ust1i9alboArt82Ust3PrzepisDyrektywy='';
		if	( $Art43Ust1Art113Ust1i9alboArt82Ust3=='true'
			&&$Art43Ust1Art113Ust1i9alboArt82Ust3PrzepisDyrektywy
			)
		{
			fputs($file,"\n"."		<P_19B>$Art43Ust1Art113Ust1i9alboArt82Ust3PrzepisDyrektywy</P_19B>");	//Je�li pole P_19 r�wna si� "true" - nale�y wskaza� przepis dyrektywy 2006/112/WE, kt�ry zwalnia od podatku tak� dostaw� towar�w lub takie �wiadczenie us�ug
		}
		
		$Art43Ust1Art113Ust1i9alboArt82Ust3InnaPodstawa='';
		if	( $Art43Ust1Art113Ust1i9alboArt82Ust3=='true'
			&&$Art43Ust1Art113Ust1i9alboArt82Ust3InnaPodstawa
			)
		{
			fputs($file,"\n"."		<P_19C>$Art43Ust1Art113Ust1i9alboArt82Ust3InnaPodstawa</P_19C>");	//Je�li pole P_19 r�wna si� "true" - nale�y wskaza� inn� podstaw� prawn� wskazuj�c� na to, �e dostawa towar�w lub �wiadczenie us�ug korzysta ze zwolnienia
		}
		
		$Art106c='false';
		fputs($file,"\n"."		<P_20>$Art106c</P_20>");	//W przypadku, o kt�rym mowa w art. 106c ustawy nale�y poda� warto�� "true"; w przeciwnym przypadku - warto�� - "false"

		$nazwaOrganuEgzekucyjnego='';
		if	( $Art106c=='true'
			&&$nazwaOrganuEgzekucyjnego
			)
		{
			fputs($file,"\n"."		<P_20A>$nazwaOrganuEgzekucyjnego</P_20A>");	//Je�li pole P_20 r�wna si� "true" - nale�y poda� nazw� organu egzekucyjnego lub imi� i nazwisko komornika s�dowego
		}

		$adresOrganuEgzekucyjnego='';
		if	( $Art106c=='true'
			&&$adresOrganuEgzekucyjnego
			)
		{
			fputs($file,"\n"."		<P_20B>$adresOrganuEgzekucyjnego</P_20B>");	//Je�li pole P_20 r�wna si� "true" - nale�y poda� adres organu egzekucyjnego lub komornika s�dowego
		}
		
		$wImieniu='false';
		fputs($file,"\n"."		<P_21>$wImieniu</P_21>");	//W przypadku faktur wystawianych w imieniu i na rzecz podatnika przez jego przedstawiciela podatkowego nale�y poda� warto�� "true"; w przeciwnym przypadku - warto�� - "false"
		
		$nazwaPrzedstawicielaPodatkowego='';
		if	( $wImieniu=='true'
			&&$nazwaPrzedstawicielaPodatkowego
			)
		{
			fputs($file,"\n"."		<P_21A>$nazwaPrzedstawicielaPodatkowego</P_21A>");	//Je�li pole P_21 r�wna si� "true" - nale�y poda� nazw� lub imi� i nazwisko przedstawiciela podatkowego
		}

		$adresPrzedstawicielaPodatkowego='';
		if	( $wImieniu=='true'
			&&$adresPrzedstawicielaPodatkowego
			)
		{
			fputs($file,"\n"."		<P_21B>$adresPrzedstawicielaPodatkowego</P_21B>");	//Je�li pole P_21 r�wna si� "true" - nale�y poda� adres przedstawiciela podatkowego
		}

		$numerPrzedstawicielaPodatkowego='';
		if	( $wImieniu=='true'
			&&$numerPrzedstawicielaPodatkowego
			)
		{
			fputs($file,"\n"."		<P_21C>$numerPrzedstawicielaPodatkowego</P_21C>");	//Je�li pole P_21 r�wna si� "true" - nale�y poda� numer przedstawiciela podatkowego, za pomoc� kt�rego jest on zidentyfikowany na potrzeby podatku
		}

		//W przypadku gdy przedmiotem wewn�trzwsp�lnotowej dostawy s� nowe �rodki transportu nale�y poda� dat� dopuszczenia nowego �rodka transportu do u�ytku oraz: 
		//A) przebieg pojazdu - w przypadku pojazd�w l�dowych, o kt�rych mowa w art. 2 pkt 10 lit. a ustawy
		//B) liczb� godzin roboczych u�ywania nowego �rodka transportu - w przypadku jednostek p�ywaj�cych, o kt�rych mowa w art. 2 pkt 10 lit. b ustawy , oraz statk�w powietrznych, o kt�rych mowa w art. 2 pkt 10 lit. c ustawy

		$dataDopuszczenia='';
		if($dataDopuszczenia)
		{
			fputs($file,"\n"."		<P_22A>$dataDopuszczenia</P_22A>");	//Data dopuszczenia nowego �rodka transportu do u�ytku
		}

		$Art2Pkt10a='';
		if($Art2Pkt10a)
		{
			fputs($file,"\n"."		<P_22B>$Art2Pkt10a</P_22B>");	//Przebieg pojazdu - w przypadku pojazd�w l�dowych, o kt�rych mowa w art. 2 pkt 10 lit. a ustawy
		}

		$Art2Pkt10bic='';
		if($Art2Pkt10bic)
		{
			fputs($file,"\n"."		<P_22C>$Art2Pkt10bic</P_22C>");	//Liczba godzin roboczych u�ywania nowego �rodka transportu - w przypadku jednostek p�ywaj�cych, o kt�rych mowa w art. 2 pkt 10 lit. b, oraz statk�w powietrznych, o kt�rych mowa w art. 2 pkt 10 lit. c ustawy
		}

		$Art135Ust1Pkt4bic='';
		if($Art135Ust1Pkt4bic)
		{
			fputs($file,"\n"."		<P_23>$Art135Ust1Pkt4bic</P_23>");	//W przypadku faktur wystawianych przez drugiego w kolejno�ci podatnika, o kt�rym mowa w art. 135 ust. 1 pkt 4 lit. b i c, w wewn�trzwsp�lnotowej transakcji tr�jstronnej (procedurze uproszczonej) - dane okre�lone w art. 136, nale�y poda� warto�� "true"; w przeciwnym przypadku - warto�� - "false"
		}

		$Art119Ust1='false';
		if($Art119Ust1)
		{
			fputs($file,"\n"."		<P_106E_2>$Art119Ust1</P_106E_2>");	//W przypadku �wiadczenia us�ug turystyki, dla kt�rych podstaw� opodatkowania stanowi zgodnie z art. 119 ust. 1 kwota mar�y, faktura - w zakresie danych okre�lonych w ust. 1 pkt 1-17 - powinna zawiera� wy��cznie dane okre�lone w ust. 1 pkt 1-8 i 15-17, a tak�e wyrazy "procedura mar�y dla biur podr�y", nale�y poda� warto�� "true"; w przeciwnym przypadku - warto�� - "false"
		}

		$Art120Ust4i5='false';
		if($Art120Ust4i5)
		{
			fputs($file,"\n"."		<P_106E_3>$Art120Ust4i5</P_106E_3>");	//W przypadku dostawy towar�w u�ywanych, dzie� sztuki, przedmiot�w kolekcjonerskich i antyk�w, dla kt�rych podstaw� opodatkowania stanowi zgodnie z art. 120 ust. 4 i 5 mar�a, nale�y poda� warto�� "true"; w przeciwnym przypadku - warto�� - "false"
		}

		$Art120Ust4i5Opis='';
		if	( $Art120Ust4i5=='true'
			&&$Art120Ust4i5Opis
			)
		{
			fputs($file,"\n"."		<P_106E_3A>$Art120Ust4i5Opis</P_106E_3A>");	//Je�eli pole P_106E_3 r�wna si� warto�ci "true", nale�y poda� wyrazy: "procedura mar�y - towary u�ywane" lub "procedura mar�y - dzie�a sztuki" lub "procedura mar�y - przedmioty kolekcjonerskie i antyki"
		}

		$rodzajFaktury='';
		fputs($file,"\n"."		<RodzajFaktury>$rodzajFaktury</RodzajFaktury>");	//Rodzaj faktury: VAT - podstawowa; KOREKTA - koryguj�ca; ZAL - faktura dokumentuj�ca otrzymanie zap�aty lub jej cz�ci przed dokonaniem czynno�ci (art.106b ust. 1 pkt 4 ustawy); POZ - pozosta�e

		$przyczynaKorekty='';
		fputs($file,"\n"."		<PrzyczynaKorekty>$przyczynaKorekty</PrzyczynaKorekty>");	//Przyczyna korekty dla faktur koryguj�cych

		$nrFaKorygowanej='';
		fputs($file,"\n"."		<NrFaKorygowanej>$nrFaKorygowanej</NrFaKorygowanej>");	//Numer faktury korygowanej

		$okresFaKorygowanej='';
		fputs($file,"\n"."		<OkresFaKorygowanej>$okresFaKorygowanej</OkresFaKorygowanej>");	//Dla faktury koryguj�cej - okres, do kt�rego odnosi si� udzielany opust lub obni�ka, w przypadku gdy podatnik udziela opustu lub obni�ki ceny w odniesieniu do wszystkich dostaw towar�w lub us�ug dokonanych lub �wiadczonych na rzecz jednego odbiorcy w danym okresie

		$zalZaplata='';
		fputs($file,"\n"."		<ZALZaplata>$zalZaplata</ZALZaplata>");	//Dla faktury zaliczkowej - otrzymana kwota zap�aty

		$zalPodatek='';
		fputs($file,"\n"."		<ZALPodatek>$zalPodatek</ZALPodatek>");	//Dla faktury zaliczkowej - kwota podatku wyliczona wed�ug wzoru z art.106f ust. 1 pkt 3 ustawy

		fputs($file,"\n"."	</Faktura>");
		
//--------------------------------------------------------------------------------------------------------------------------------

		fputs($file,"\n"."	<FakturaCtrl>");	//Sumy kontrolne dla faktur

		$liczbaFaktur='';
		fputs($file,"\n"."		<LiczbaFaktur>$liczbaFaktur</LiczbaFaktur>");	//Liczba faktur, w okresie kt�rego dotyczy JPK_FA

		$wartoscFaktur='';
		fputs($file,"\n"."		<WartoscFaktur>$wartoscFaktur</WartoscFaktur>");	//��czna warto�� kwot brutto faktur w okresie, kt�rego dotyczy JPK_FA

		fputs($file,"\n"."	</FakturaCtrl>");

//--------------------------------------------------------------------------------------------------------------------------------

		fputs($file,"\n"."	<StawkiPodatku>");	//Zestawienie stawek podatku, w okresie kt�rego dotyczy JPK_FA

		$stawka1='';
		fputs($file,"\n"."		<Stawka1>$stawka1</Stawka1>");	//Warto�� stawki podstawowej

		$stawka2='';
		fputs($file,"\n"."		<Stawka2>$stawka2</Stawka2>");	//Warto�� stawki obni�onej pierwszej

		$stawka3='';
		fputs($file,"\n"."		<Stawka3>$stawka3</Stawka3>");	//Warto�� stawki obni�onej drugiej

		$stawka4='';
		fputs($file,"\n"."		<Stawka4>$stawka4</Stawka4>");	//Warto�� stawki obni�onej trzeciej - pole rezerwowe

		$stawka5='';
		fputs($file,"\n"."		<Stawka5>$stawka5</Stawka5>");	//Warto�� stawki obni�onej czwartej - pole rezerwowe

		fputs($file,"\n"."	</StawkiPodatku>");

//--------------------------------------------------------------------------------------------------------------------------------

		fputs($file,"\n"."	<FakturaWiersz>");	//Szczeg�owe pozycje faktur

		$numerFaktury='';
		fputs($file,"\n"."		<P_2B>$numerFaktury</P_2B>");	//Kolejny numer faktury, nadany w ramach jednej lub wi�cej serii, kt�ry w spos�b jednoznaczny indentyfikuje faktur�

		$nazwaTowaru='';
		fputs($file,"\n"."		<P_7>$nazwaTowaru</P_7>");	//Nazwa (rodzaj) towaru lub us�ugi. Pole opcjonalne wy��cznie dla przypadku okre�lonego w art 106j ust.3 pkt 2 ustawy (faktura korekta)

		$jm='';
		fputs($file,"\n"."		<P_8A>$jm</P_8A>");	//Miara dostarczonych towar�w lub zakres wykonanych us�ug. Pole opcjonalne dla przypadku okre�lonego w art 106e ust. 5 pkt 3 ustawy

		$ilosc='';
		fputs($file,"\n"."		<P_8B>$ilosc</P_8B>");	//Ilo�� (liczba) dostarczonych towar�w lub zakres wykonanych us�ug. Pole opcjonalne dla przypadku okre�lonego w art 106e ust. 5 pkt 3 ustawy

		$cena='';
		fputs($file,"\n"."		<P_9A>$cena</P_9A>");	//Cena jednostkowa towaru lub us�ugi bez kwoty podatku (cena jednostkowa netto). Pole opcjonalne dla przypadk�w okre�lonych w art. 106e ust.2 i 3 ustawy (gdy przynajmniej jedno z p�l P_106E_2 i P_106E_3 przyjmuje warto�� "true") oraz dla przypadku okre�lonego w art 106e ust. 5 pkt 3 ustawy

		$cenaBrutto='';
		fputs($file,"\n"."		<P_9B>$cenaBrutto</P_9B>");	//W przypadku zastosowania art.106e ustawy, cena wraz z kwot� podatku (cena jednostkowa brutto

		$kwotaRabatow='';
		fputs($file,"\n"."		<P_10>$kwotaRabatow</P_10>");	//Kwoty wszelkich opust�w lub obni�ek cen, w tym w formie rabatu z tytu�u wcze�niejszej zap�aty, o ile nie zosta�y one uwzgl�dnione w cenie jednostkowej netto. Pole opcjonalne dla przypadk�w okre�lonych w art. 106e ust.2 i 3 ustawy (gdy przynajmniej jedno z p�l P_106E_2 i P_106E_3 przyjmuje warto�� "true") oraz dla przypadku okre�lonego w art. 106e ust. 5 pkt 1 ustawy

		$netto='';
		fputs($file,"\n"."		<P_11>$netto</P_11>");	//Warto�� dostarczonych towar�w lub wykonanych us�ug, obj�tych transakcj�, bez kwoty podatku (warto�� sprzeda�y netto). Pole opcjonalne dla przypadk�w okre�lonych w art. 106e ust.2 i 3 ustawy (gdy przynajmniej jedno z p�l P_106E_2 i P_106E_3 przyjmuje warto�� "true") oraz dla przypadku okre�lonego w art. 106e ust. 5 pkt 3 ustawy

		$brutto='';
		fputs($file,"\n"."		<P_11A>$brutto</P_11A>");	//W przypadku zastosowania art. 106e ust.7 i 8 ustawy, warto�� sprzeda�y brutto

		$stawkaVAT='';	//Max 2 znaki: 23, 22, 8, 7, 5, 3, 0, zw
		fputs($file,"\n"."		<P_12>$stawkaVAT</P_12>");	//Stawka podatku. Pole opcjonalne dla przypadk�w okre�lonych w art. 106e ust.2 i 3 ustawy (gdy przynajmniej jedno z p�l P_106E_2 i P_106E_3 przyjmuje warto�� "true"), a tak�e art. 106e ust.4 pkt 3 i ust. 5 pkt 1-3 ustawy

		fputs($file,"\n"."	</FakturaWiersz>");

//--------------------------------------------------------------------------------------------------------------------------------

		fputs($file,"\n"."	<FakturaWierszCtrl>");	//Sumy kontrolne dla wierszy faktur

		$liczbaWierszyFaktur='';
		fputs($file,"\n"."		<LiczbaWierszyFaktur>$liczbaWierszyFaktur</LiczbaWierszyFaktur>");	//Liczba wierszy faktur, w okresie kt�rego dotyczy JPK_FA

		$wartoscWierszyFaktur='';
		fputs($file,"\n"."		<WartoscWierszyFaktur>$wartoscWierszyFaktur</WartoscWierszyFaktur>");	//��czna warto�� kolumny P_11 tabeli FakturaWiersz w okresie, kt�rego dotyczy JPK_FA

		fputs($file,"\n"."	</FakturaWierszCtrl>");

	}

	fputs($file,"\n".'</JPK>');
	fclose($file);

}

$title="JPK_FA - generowanie pliku: raport";
$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powr�t','akcja'=>"../Menu");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

echo "<h2>Raport generowania pliku $filename:</h2>";
echo "<hr>";
echo '<h3>'.nl2br($raport).'</h3>';

echo '<hr>';

echo $czas.' czas rozpocz�cia';
echo '<br>';
echo date('Y-m-d H:i:s').' czas zako�czenia';

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");

echo '<pre>';
echo "<h2>Podgl�d kontrolny fragmentu zawarto�ci pliku $filename:</h2>";
echo iconv('UTF-8','ISO-8859-2',str_replace(array('<','>'),array('&lt;','&gt;'),file_get_contents($filename,null,null,0,6000))).' [...]';
//echo iconv('UTF-8','ISO-8859-2',str_replace(array('<','>'),array('&lt;','&gt;'),file_get_contents($filename)));
echo '</pre>';
