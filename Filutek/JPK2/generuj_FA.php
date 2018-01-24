<?php

error_reporting(E_ALL);
ini_set('display_errors', 1);

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
	$raport="B£¡D! UZUPE£NIJ OBOWI¡ZKOWE DANE:\nSprawd¼: kod urzêdu skarbowego, waluta, kraj, miasto, NIP, nazwa";
}
else
{
	$klient['NAZWA']=iconv('ISO-8859-2','UTF-8',StripSlashes($klient['NAZWA']));
	$klient['ADRES']=iconv('ISO-8859-2','UTF-8',StripSlashes($klient['ADRES']));
	$klient['NIP']=preg_replace('/\D/', '', $klient['NIP']);

	mysqli_query($link,$q="update Lemur.klienci set KODUS='$_POST[kodUS]' where PSKONT='$baza'");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}

	$file=fopen($filename,"w");

//--------------------------------------------------------------------------------------------------------------------------------

	fputs($file,'<?xml version="1.0" encoding="UTF-8"?>
<JPK xmlns="http://jpk.mf.gov.pl/wzor/2016/03/09/03095/" xmlns:etd="http://crd.gov.pl/xml/schematy/dziedzinowe/mf/2016/01/25/eD/DefinicjeTypy/">
	<Naglowek>
		<KodFormularza kodSystemowy="JPK_FA (1)" wersjaSchemy="1-0">JPK_FA</KodFormularza>
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
	fputs($file,"\n"."			<etd:KodKraju>$klient[KRAJ]</etd:KodKraju>");
	fputs($file,"\n"."			<etd:Wojewodztwo>".(iconv('ISO-8859-2','UTF-8',StripSlashes($klient['WOJEWODZTWO'])))."</etd:Wojewodztwo>");
	fputs($file,"\n"."			<etd:Powiat>".(iconv('ISO-8859-2','UTF-8',StripSlashes($klient['POWIAT'])))."</etd:Powiat>");
	fputs($file,"\n"."			<etd:Gmina>".(iconv('ISO-8859-2','UTF-8',StripSlashes($klient['GMINA'])))."</etd:Gmina>");
	fputs($file,"\n"."			<etd:Ulica>".(iconv('ISO-8859-2','UTF-8',StripSlashes($klient['ULICA'])))."</etd:Ulica>");
	fputs($file,"\n"."			<etd:NrDomu>$klient[NRDOMU]</etd:NrDomu>");
	$nrLokalu='';
	if($nrLokalu)
	{
		fputs($file,"\n"."			<etd:NrLokalu>$nrLokalu</etd:NrLokalu>");
	}
	fputs($file,"\n"."			<etd:Miejscowosc>".(iconv('ISO-8859-2','UTF-8',StripSlashes($klient['MIEJSCOWOSC'])))."</etd:Miejscowosc>");
	fputs($file,"\n"."			<etd:KodPocztowy>$klient[KOD]</etd:KodPocztowy>");
	fputs($file,"\n"."			<etd:Poczta>".(iconv('ISO-8859-2','UTF-8',StripSlashes($klient['POCZTA'])))."</etd:Poczta>");
	fputs($file,"\n"."		</AdresPodmiotu>");
	fputs($file,"\n"."	</Podmiot1>");

	$lp=0;
	$liczbaFaktur=0;
	$wartoscFaktur=0;
	$faktury=mysqli_query($link,"
		select *
		  from $baza.dokumenty
		 where DOPERACJI between '$_POST[OdDaty]' and '$_POST[DoDaty]'
		   and NUMER<>''
		   and TYP IN ('FV')
	  order by DOPERACJI, ID
	");
	while($faktura=mysqli_fetch_array($faktury))
	{
		++$liczbaFaktur;
		++$lp;
		$prefiksN='';
		$nip=preg_replace('/\D/', '', $faktura['NIP']);
		$nip=(!$nip?'1111111111':$nip);
		$nazwa=iconv('ISO-8859-2','UTF-8',StripSlashes($faktura['NAZWA']));
		if(strpos($nazwa,'&')>0)
		{
			$nazwa=str_replace('&',' and ',$nazwa);
		}
		$adres=iconv('ISO-8859-2','UTF-8',StripSlashes($faktura['ADRES']));
		$numerFaktury=iconv('ISO-8859-2','UTF-8',StripSlashes($faktura['NUMER']));
		
		$prefiksS='';

//--------------------------------------------------------------------------------------------------------------------------------

		fputs($file,"\n".'	<Faktura typ="G">');
		fputs($file,"\n"."		<P_1>$faktura[DDOKUMENTU]</P_1>");
		fputs($file,"\n"."		<P_2A>$numerFaktury</P_2A>");
		fputs($file,"\n"."		<P_3A>$nazwa</P_3A>");
		fputs($file,"\n"."		<P_3B>$adres</P_3B>");
		fputs($file,"\n"."		<P_3C>$klient[NAZWA]</P_3C>");
		fputs($file,"\n"."		<P_3D>$klient[ADRES]</P_3D>");
		if($prefiksS)
		{
			fputs($file,"\n"."		<P_4A>$prefiksS</P_4A>");
		}
		fputs($file,"\n"."		<P_4B>$klient[NIP]</P_4B>");
		if($prefiksN)
		{
			fputs($file,"\n"."		<P_5A>$prefiksN</P_5A>");
		}
		fputs($file,"\n"."		<P_5B>$nip</P_5B>");
		
		//Data dokonania lub zakoñczenia dostawy towarów lub wykonania us³ugi lub data otrzymania zap³aty, o której mowa w art. 106b ust. 1 pkt 4, o ile taka data jest okre¶lona i ró¿ni siê od daty wystawienia faktury
		if($faktura['DDOKUMENTU']<>$faktura['DOPERACJI'])
		{
			fputs($file,"\n"."		<P_6>$faktura[DOPERACJI]</P_6>");
		}
		
		$brutto=$faktura['WARTOSC'];
		$wartoscFaktur+=$brutto;

		$kwota=KwotyWgStawek($link, $baza, $faktura['ID']);

		$n23=$kwota['n23'];
		$n22=$kwota['n22'];

		$v23=$kwota['v23'];
		$v22=$kwota['v22'];

		$n7=$kwota['n7'];
		$n8=$kwota['n8'];

		$v7=$kwota['v7'];
		$v8=$kwota['v8'];

		$n5=$kwota['n5'];
		$n3=$kwota['n3'];

		$v5=$kwota['v5'];
		$v3=$kwota['v3'];

		$n4=$kwota['n4'];
		$n0=$kwota['n0'];
		$nzw=$kwota['nzw'];

		$v4=$kwota['v4'];

		//Suma warto¶ci sprzeda¿y netto ze stawk± podstawow± - aktualnie 23% albo 22%
		if($n22||$n23)
		{
			fputs($file,"\n"."		<P_13_1>".($n22+$n23)."</P_13_1>");
		}

		//Kwota podatku od sumy warto¶ci sprzeda¿y netto ze stawk± podstawow± - aktualnie 23% albo 22%
		if($v22||$v23)
		{
			fputs($file,"\n"."		<P_14_1>".($v22+$v23)."</P_14_1>");
		}

		//Suma warto¶ci sprzeda¿y netto ze stawk± obni¿on± pierwsz± - aktualnie 8 % albo 7%
		if($n7||$n8)
		{
			fputs($file,"\n"."		<P_13_2>".($n22+$n23)."</P_13_2>");
		}

		//Kwota podatku od sumy warto¶ci sprzeda¿y netto ze stawk± obni¿on± - aktualnie 8% albo 7%
		if($v7||$v8)
		{
			fputs($file,"\n"."		<P_14_2>".($v22+$v23)."</P_14_2>");
		}

		//Suma warto¶ci sprzeda¿y netto ze stawk± obni¿on± drug± - aktualnie 5%
		if($n5)
		{
			fputs($file,"\n"."		<P_13_3>".($n5)."</P_13_3>");
		}

		//Kwota podatku od sumy warto¶ci sprzeda¿y netto ze stawk± obni¿on± drug± - aktualnie 5%
		if($v5)
		{
			fputs($file,"\n"."		<P_14_3>".($v5)."</P_14_3>");
		}

		//Suma warto¶ci sprzeda¿y netto ze stawk± obni¿on± trzeci± - pole rezerwowe
		if($n3)
		{
			fputs($file,"\n"."		<P_13_4>".($n3)."</P_13_4>");
		}

		//Kwota podatku od sumy warto¶ci sprzeda¿y netto ze stawk± obni¿on± trzeci± - pole rezerwowe
		if($v3)
		{
			fputs($file,"\n"."		<P_14_4>".($v3)."</P_14_4>");
		}

		//Suma warto¶ci sprzeda¿y netto ze stawk± obni¿on± czwart± - pole rezerwowe
		if($n4)
		{
			fputs($file,"\n"."		<P_13_5>".($n4)."</P_13_5>");
		}

		//Kwota podatku od sumy warto¶ci sprzeda¿y netto ze stawk± obni¿on± czwart± - pole rezerwowe
		if($v4)
		{
			fputs($file,"\n"."		<P_14_5>".($v4)."</P_14_5>");
		}

		//Suma warto¶ci sprzeda¿y netto ze stawk± 0%
		if($n0)
		{
			fputs($file,"\n"."		<P_13_6>".($n0)."</P_13_6>");
		}

		//Suma warto¶ci sprzeda¿y zwolnionej
		if($nzw)
		{
			fputs($file,"\n"."		<P_13_7>".($nzw)."</P_13_7>");
		}

		if($brutto)
		{
			fputs($file,"\n"."		<P_15>$brutto</P_15>");
		}

		$Art19aUst5Pkt1LubArt21Ust1='false';
		fputs($file,"\n"."		<P_16>$Art19aUst5Pkt1LubArt21Ust1</P_16>");	//W przypadku dostawy towarów lub ¶wiadczenia us³ug, w odniesieniu do których obowi±zek podatkowy powstaje zgodnie z art. 19a ust. 5 pkt 1 lub art. 21 ust. 1 - wyrazy "metoda kasowa", nale¿y podaæ warto¶æ "true"; w przeciwnym przypadku - warto¶æ - "false"

		$Art106dUst1='false';
		fputs($file,"\n"."		<P_17>$Art106dUst1</P_17>");	//W przypadku faktur, o których mowa w art. 106d ust. 1 - wyraz "samofakturowanie", nale¿y podaæ warto¶æ "true"; w przeciwnym przypadku - warto¶æ - "false"

		$oo='false';
		fputs($file,"\n"."		<P_18>$oo</P_18>");	//W przypadku dostawy towarów lub wykonania us³ugi, dla których obowi±zanym do rozliczenia podatku, podatku od warto¶ci dodanej lub podatku o podobnym charakterze jest nabywca towaru lub us³ugi - wyrazy "odwrotne obci±¿enie", nale¿y podaæ warto¶æ "true"; w przeciwnym przypadku - warto¶æ - "false"

		$Art43Ust1Art113Ust1i9alboArt82Ust3='false';
		fputs($file,"\n"."		<P_19>$Art43Ust1Art113Ust1i9alboArt82Ust3</P_19>");	//W przypadku dostawy towarów lub ¶wiadczenia us³ug zwolnionych od podatku na podstawie art. 43 ust. 1, art. 113 ust. 1 i 9 albo przepisów wydanych na podstawie art. 82 ust. 3 nale¿y podaæ warto¶æ "true"; w przeciwnym przypadku - warto¶æ - "false"

		$Art43Ust1Art113Ust1i9alboArt82Ust3PrzepisUstawy='';
		if	( $Art43Ust1Art113Ust1i9alboArt82Ust3=='true'
			&&$Art43Ust1Art113Ust1i9alboArt82Ust3PrzepisUstawy
			)
		{
			fputs($file,"\n"."		<P_19A>$Art43Ust1Art113Ust1i9alboArt82Ust3PrzepisUstawy</P_19A>");	//Je¶li pole P_19 równa siê "true" - nale¿y wskazaæ przepis ustawy albo aktu wydanego na podstawie ustawy, na podstawie którego podatnik stosuje zwolnienie od podatku
		}
		
		$Art43Ust1Art113Ust1i9alboArt82Ust3PrzepisDyrektywy='';
		if	( $Art43Ust1Art113Ust1i9alboArt82Ust3=='true'
			&&$Art43Ust1Art113Ust1i9alboArt82Ust3PrzepisDyrektywy
			)
		{
			fputs($file,"\n"."		<P_19B>$Art43Ust1Art113Ust1i9alboArt82Ust3PrzepisDyrektywy</P_19B>");	//Je¶li pole P_19 równa siê "true" - nale¿y wskazaæ przepis dyrektywy 2006/112/WE, który zwalnia od podatku tak± dostawê towarów lub takie ¶wiadczenie us³ug
		}
		
		$Art43Ust1Art113Ust1i9alboArt82Ust3InnaPodstawa='';
		if	( $Art43Ust1Art113Ust1i9alboArt82Ust3=='true'
			&&$Art43Ust1Art113Ust1i9alboArt82Ust3InnaPodstawa
			)
		{
			fputs($file,"\n"."		<P_19C>$Art43Ust1Art113Ust1i9alboArt82Ust3InnaPodstawa</P_19C>");	//Je¶li pole P_19 równa siê "true" - nale¿y wskazaæ inn± podstawê prawn± wskazuj±c± na to, ¿e dostawa towarów lub ¶wiadczenie us³ug korzysta ze zwolnienia
		}
		
		$Art106c='false';
		fputs($file,"\n"."		<P_20>$Art106c</P_20>");	//W przypadku, o którym mowa w art. 106c ustawy nale¿y podaæ warto¶æ "true"; w przeciwnym przypadku - warto¶æ - "false"

		$nazwaOrganuEgzekucyjnego='';
		if	( $Art106c=='true'
			&&$nazwaOrganuEgzekucyjnego
			)
		{
			fputs($file,"\n"."		<P_20A>$nazwaOrganuEgzekucyjnego</P_20A>");	//Je¶li pole P_20 równa siê "true" - nale¿y podaæ nazwê organu egzekucyjnego lub imiê i nazwisko komornika s±dowego
		}

		$adresOrganuEgzekucyjnego='';
		if	( $Art106c=='true'
			&&$adresOrganuEgzekucyjnego
			)
		{
			fputs($file,"\n"."		<P_20B>$adresOrganuEgzekucyjnego</P_20B>");	//Je¶li pole P_20 równa siê "true" - nale¿y podaæ adres organu egzekucyjnego lub komornika s±dowego
		}
		
		$wImieniu='false';
		fputs($file,"\n"."		<P_21>$wImieniu</P_21>");	//W przypadku faktur wystawianych w imieniu i na rzecz podatnika przez jego przedstawiciela podatkowego nale¿y podaæ warto¶æ "true"; w przeciwnym przypadku - warto¶æ - "false"
		
		$nazwaPrzedstawicielaPodatkowego='';
		if	( $wImieniu=='true'
			&&$nazwaPrzedstawicielaPodatkowego
			)
		{
			fputs($file,"\n"."		<P_21A>$nazwaPrzedstawicielaPodatkowego</P_21A>");	//Je¶li pole P_21 równa siê "true" - nale¿y podaæ nazwê lub imiê i nazwisko przedstawiciela podatkowego
		}

		$adresPrzedstawicielaPodatkowego='';
		if	( $wImieniu=='true'
			&&$adresPrzedstawicielaPodatkowego
			)
		{
			fputs($file,"\n"."		<P_21B>$adresPrzedstawicielaPodatkowego</P_21B>");	//Je¶li pole P_21 równa siê "true" - nale¿y podaæ adres przedstawiciela podatkowego
		}

		$numerPrzedstawicielaPodatkowego='';
		if	( $wImieniu=='true'
			&&$numerPrzedstawicielaPodatkowego
			)
		{
			fputs($file,"\n"."		<P_21C>$numerPrzedstawicielaPodatkowego</P_21C>");	//Je¶li pole P_21 równa siê "true" - nale¿y podaæ numer przedstawiciela podatkowego, za pomoc± którego jest on zidentyfikowany na potrzeby podatku
		}

		//W przypadku gdy przedmiotem wewn±trzwspólnotowej dostawy s± nowe ¶rodki transportu nale¿y podaæ datê dopuszczenia nowego ¶rodka transportu do u¿ytku oraz: 
		//A) przebieg pojazdu - w przypadku pojazdów l±dowych, o których mowa w art. 2 pkt 10 lit. a ustawy
		//B) liczbê godzin roboczych u¿ywania nowego ¶rodka transportu - w przypadku jednostek p³ywaj±cych, o których mowa w art. 2 pkt 10 lit. b ustawy , oraz statków powietrznych, o których mowa w art. 2 pkt 10 lit. c ustawy

		$dataDopuszczenia='';
		if($dataDopuszczenia)
		{
			fputs($file,"\n"."		<P_22A>$dataDopuszczenia</P_22A>");	//Data dopuszczenia nowego ¶rodka transportu do u¿ytku
		}

		$Art2Pkt10a='';
		if($Art2Pkt10a)
		{
			fputs($file,"\n"."		<P_22B>$Art2Pkt10a</P_22B>");	//Przebieg pojazdu - w przypadku pojazdów l±dowych, o których mowa w art. 2 pkt 10 lit. a ustawy
		}

		$Art2Pkt10bic='';
		if($Art2Pkt10bic)
		{
			fputs($file,"\n"."		<P_22C>$Art2Pkt10bic</P_22C>");	//Liczba godzin roboczych u¿ywania nowego ¶rodka transportu - w przypadku jednostek p³ywaj±cych, o których mowa w art. 2 pkt 10 lit. b, oraz statków powietrznych, o których mowa w art. 2 pkt 10 lit. c ustawy
		}

		$Art135Ust1Pkt4bic='false';
		if($Art135Ust1Pkt4bic)
		{
			fputs($file,"\n"."		<P_23>$Art135Ust1Pkt4bic</P_23>");	//W przypadku faktur wystawianych przez drugiego w kolejno¶ci podatnika, o którym mowa w art. 135 ust. 1 pkt 4 lit. b i c, w wewn±trzwspólnotowej transakcji trójstronnej (procedurze uproszczonej) - dane okre¶lone w art. 136, nale¿y podaæ warto¶æ "true"; w przeciwnym przypadku - warto¶æ - "false"
		}

		$Art119Ust1='false';
		if($Art119Ust1)
		{
			fputs($file,"\n"."		<P_106E_2>$Art119Ust1</P_106E_2>");	//W przypadku ¶wiadczenia us³ug turystyki, dla których podstawê opodatkowania stanowi zgodnie z art. 119 ust. 1 kwota mar¿y, faktura - w zakresie danych okre¶lonych w ust. 1 pkt 1-17 - powinna zawieraæ wy³±cznie dane okre¶lone w ust. 1 pkt 1-8 i 15-17, a tak¿e wyrazy "procedura mar¿y dla biur podró¿y", nale¿y podaæ warto¶æ "true"; w przeciwnym przypadku - warto¶æ - "false"
		}

		$Art120Ust4i5='false';
		if($Art120Ust4i5)
		{
			fputs($file,"\n"."		<P_106E_3>$Art120Ust4i5</P_106E_3>");	//W przypadku dostawy towarów u¿ywanych, dzie³ sztuki, przedmiotów kolekcjonerskich i antyków, dla których podstawê opodatkowania stanowi zgodnie z art. 120 ust. 4 i 5 mar¿a, nale¿y podaæ warto¶æ "true"; w przeciwnym przypadku - warto¶æ - "false"
		}

		$Art120Ust4i5Opis='';
		if	( $Art120Ust4i5=='true'
			&&$Art120Ust4i5Opis
			)
		{
			fputs($file,"\n"."		<P_106E_3A>$Art120Ust4i5Opis</P_106E_3A>");	//Je¿eli pole P_106E_3 równa siê warto¶ci "true", nale¿y podaæ wyrazy: "procedura mar¿y - towary u¿ywane" lub "procedura mar¿y - dzie³a sztuki" lub "procedura mar¿y - przedmioty kolekcjonerskie i antyki"
		}

		$rodzajFaktury=((substr($faktura['TYP'],-1,1)=='K')?'KOREKTA':'VAT');
		fputs($file,"\n"."		<RodzajFaktury>$rodzajFaktury</RodzajFaktury>");	//Rodzaj faktury: VAT - podstawowa; KOREKTA - koryguj±ca; ZAL - faktura dokumentuj±ca otrzymanie zap³aty lub jej czê¶ci przed dokonaniem czynno¶ci (art.106b ust. 1 pkt 4 ustawy); POZ - pozosta³e

		$przyczynaKorekty=$faktura['UWAGI'];
		if( ($rodzajFaktury=='KOREKTA')
		  &&$przyczynaKorekty
		  )
		{
			fputs($file,"\n"."		<PrzyczynaKorekty>$przyczynaKorekty</PrzyczynaKorekty>");	//Przyczyna korekty dla faktur koryguj±cych
		}
		
		$nrFaKorygowanej=((substr($faktura['DODOK'],0,2)=='FV')?substr($faktura['DODOK'],3):$faktura['DODOK']);
		if( ($rodzajFaktury=='KOREKTA')
		  &&$nrFaKorygowanej
		  )
		{
			fputs($file,"\n"."		<NrFaKorygowanej>$nrFaKorygowanej</NrFaKorygowanej>");	//Numer faktury korygowanej
		}
		
		$okresFaKorygowanej=$faktura['ZDNIA'];
		if( ($rodzajFaktury=='KOREKTA')
		  &&$okresFaKorygowanej
		  )
		{
			fputs($file,"\n"."		<OkresFaKorygowanej>$okresFaKorygowanej</OkresFaKorygowanej>");	//Dla faktury koryguj±cej - okres, do którego odnosi siê udzielany opust lub obni¿ka, w przypadku gdy podatnik udziela opustu lub obni¿ki ceny w odniesieniu do wszystkich dostaw towarów lub us³ug dokonanych lub ¶wiadczonych na rzecz jednego odbiorcy w danym okresie
		}
		
		$zalZaplata='';
		if($zalZaplata)
		{
			fputs($file,"\n"."		<ZALZaplata>$zalZaplata</ZALZaplata>");	//Dla faktury zaliczkowej - otrzymana kwota zap³aty
		}
		
		$zalPodatek='';
		if($zalPodatek)
		{
			fputs($file,"\n"."		<ZALPodatek>$zalPodatek</ZALPodatek>");	//Dla faktury zaliczkowej - kwota podatku wyliczona wed³ug wzoru z art.106f ust. 1 pkt 3 ustawy
		}

		fputs($file,"\n"."	</Faktura>");
	}
	
//--------------------------------------------------------------------------------------------------------------------------------

	fputs($file,"\n"."	<FakturaCtrl>");	//Sumy kontrolne dla faktur
	fputs($file,"\n"."		<LiczbaFaktur>$liczbaFaktur</LiczbaFaktur>");	//Liczba faktur, w okresie którego dotyczy JPK_FA
	fputs($file,"\n"."		<WartoscFaktur>$wartoscFaktur</WartoscFaktur>");	//£±czna warto¶æ kwot brutto faktur w okresie, którego dotyczy JPK_FA
	fputs($file,"\n"."	</FakturaCtrl>");

//--------------------------------------------------------------------------------------------------------------------------------

	fputs($file,"\n"."	<StawkiPodatku>");	//Zestawienie stawek podatku, w okresie którego dotyczy JPK_FA

	$stawka1='0.23';
	fputs($file,"\n"."		<Stawka1>$stawka1</Stawka1>");	//Warto¶æ stawki podstawowej

	$stawka2='0.08';
	fputs($file,"\n"."		<Stawka2>$stawka2</Stawka2>");	//Warto¶æ stawki obni¿onej pierwszej

	$stawka3='0.05';
	fputs($file,"\n"."		<Stawka3>$stawka3</Stawka3>");	//Warto¶æ stawki obni¿onej drugiej

	$stawka4='0.00';
	fputs($file,"\n"."		<Stawka4>$stawka4</Stawka4>");	//Warto¶æ stawki obni¿onej trzeciej - pole rezerwowe

	$stawka5='0.00';
	fputs($file,"\n"."		<Stawka5>$stawka5</Stawka5>");	//Warto¶æ stawki obni¿onej czwartej - pole rezerwowe

	fputs($file,"\n"."	</StawkiPodatku>");

//--------------------------------------------------------------------------------------------------------------------------------

	$liczbaWierszyFaktur=0;
	$wartoscWierszyFaktur=0;
	$faktury=mysqli_query($link,"
		select *
		  from $baza.dokumenty
		 where DOPERACJI between '$_POST[OdDaty]' and '$_POST[DoDaty]'
		   and NUMER<>''
		   and TYP IN ('FV')
	  order by DOPERACJI, ID
	");
	while($faktura=mysqli_fetch_array($faktury))
	{
		$numerFaktury=iconv('ISO-8859-2','UTF-8',StripSlashes($faktura['NUMER']));
		$towary=mysqli_query($link,"
			select *
			  from $baza.dokumentm
			 where ID_D='$faktura[ID]'
		  order by ID
		");
		while($towar=mysqli_fetch_array($towary))
		{
			++$liczbaWierszyFaktur;
			$towar['NAZWA']=iconv('ISO-8859-2','UTF-8',StripSlashes($towar['NAZWA']));
			$towar['NAZWA']=str_replace('&',' and ',$towar['NAZWA']);
			$towar['JM']=($towar['JM']?$towar['JM']:'szt');
			$towar['JM']=iconv('ISO-8859-2','UTF-8',StripSlashes($towar['JM']));

			fputs($file,"\n".'	<FakturaWiersz typ="G">');	//Szczegó³owe pozycje faktur
			fputs($file,"\n"."		<P_2B>$numerFaktury</P_2B>");	//Kolejny numer faktury, nadany w ramach jednej lub wiêcej serii, który w sposób jednoznaczny indentyfikuje fakturê
			fputs($file,"\n"."		<P_7>{$towar['NAZWA']}</P_7>");	//Nazwa (rodzaj) towaru lub us³ugi. Pole opcjonalne wy³±cznie dla przypadku okre¶lonego w art 106j ust.3 pkt 2 ustawy (faktura korekta)
			fputs($file,"\n"."		<P_8A>{$towar['JM']}</P_8A>");	//Miara dostarczonych towarów lub zakres wykonanych us³ug. Pole opcjonalne dla przypadku okre¶lonego w art 106e ust. 5 pkt 3 ustawy
			fputs($file,"\n"."		<P_8B>{$towar['ILOSC']}</P_8B>");	//Ilo¶æ (liczba) dostarczonych towarów lub zakres wykonanych us³ug. Pole opcjonalne dla przypadku okre¶lonego w art 106e ust. 5 pkt 3 ustawy
			fputs($file,"\n"."		<P_9A>{$towar['CENA']}</P_9A>");	//Cena jednostkowa towaru lub us³ugi bez kwoty podatku (cena jednostkowa netto). Pole opcjonalne dla przypadków okre¶lonych w art. 106e ust.2 i 3 ustawy (gdy przynajmniej jedno z pól P_106E_2 i P_106E_3 przyjmuje warto¶æ "true") oraz dla przypadku okre¶lonego w art 106e ust. 5 pkt 3 ustawy
//			fputs($file,"\n"."		<P_9B>$cenaBrutto</P_9B>");	//W przypadku zastosowania art.106e ustawy, cena wraz z kwot± podatku (cena jednostkowa brutto)
//			fputs($file,"\n"."		<P_10>$kwotaRabatow</P_10>");	//Kwoty wszelkich opustów lub obni¿ek cen, w tym w formie rabatu z tytu³u wcze¶niejszej zap³aty, o ile nie zosta³y one uwzglêdnione w cenie jednostkowej netto. Pole opcjonalne dla przypadków okre¶lonych w art. 106e ust.2 i 3 ustawy (gdy przynajmniej jedno z pól P_106E_2 i P_106E_3 przyjmuje warto¶æ "true") oraz dla przypadku okre¶lonego w art. 106e ust. 5 pkt 1 ustawy
			fputs($file,"\n"."		<P_11>{$towar['NETTO']}</P_11>");	//Warto¶æ dostarczonych towarów lub wykonanych us³ug, objêtych transakcj±, bez kwoty podatku (warto¶æ sprzeda¿y netto). Pole opcjonalne dla przypadków okre¶lonych w art. 106e ust.2 i 3 ustawy (gdy przynajmniej jedno z pól P_106E_2 i P_106E_3 przyjmuje warto¶æ "true") oraz dla przypadku okre¶lonego w art. 106e ust. 5 pkt 3 ustawy
			$wartoscWierszyFaktur+=$towar['NETTO'];

			fputs($file,"\n"."		<P_11A>{$towar['BRUTTO']}</P_11A>");	//W przypadku zastosowania art. 106e ust.7 i 8 ustawy, warto¶æ sprzeda¿y brutto
			$stawkaVAT=str_replace('%','',substr($towar['STAWKA'],0,2));	//Max 2 znaki: 23, 22, 8, 7, 5, 3, 0, zw
			fputs($file,"\n"."		<P_12>$stawkaVAT</P_12>");	//Stawka podatku. Pole opcjonalne dla przypadków okre¶lonych w art. 106e ust.2 i 3 ustawy (gdy przynajmniej jedno z pól P_106E_2 i P_106E_3 przyjmuje warto¶æ "true"), a tak¿e art. 106e ust.4 pkt 3 i ust. 5 pkt 1-3 ustawy
			fputs($file,"\n"."	</FakturaWiersz>");
		}
	}

//--------------------------------------------------------------------------------------------------------------------------------

	fputs($file,"\n"."	<FakturaWierszCtrl>");	//Sumy kontrolne dla wierszy faktur
	fputs($file,"\n"."		<LiczbaWierszyFaktur>$liczbaWierszyFaktur</LiczbaWierszyFaktur>");	//Liczba wierszy faktur, w okresie którego dotyczy JPK_FA
	fputs($file,"\n"."		<WartoscWierszyFaktur>$wartoscWierszyFaktur</WartoscWierszyFaktur>");	//£±czna warto¶æ kolumny P_11 tabeli FakturaWiersz w okresie, którego dotyczy JPK_FA
	fputs($file,"\n"."	</FakturaWierszCtrl>");

	fputs($file,"\n".'</JPK>');
	fclose($file);

}

$title="JPK_FA - generowanie pliku: raport";
$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"../Menu");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

echo "<h2>Raport generowania pliku $filename:</h2>";
echo "<hr>";

$raport.='<input style="text-align:right" value="'.number_format($wartoscFaktur,2,'.',',').'"/> = Suma warto¶ci brutto faktur<br>';
$raport.='<input style="text-align:right" value="'.number_format($wartoscWierszyFaktur,2,'.',',').'"/> = Suma warto¶ci netto wierszy faktur<br>';
$raport.='<input style="text-align:right" value="'.number_format(($wartoscFaktur-$wartoscWierszyFaktur),2,'.',',').'"/> = Ró¿nica<br>';

echo '<h3>'.nl2br($raport).'</h3>';

$xml = new DOMDocument();
$xml->load($filename);
echo "Walidacja zgodno¶ci z XSD: ".($xml->schemaValidate("Schemat_JPK_FA_v1-0.xsd")?"OK":"NO");
  
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

function KwotyWgStawek($link, $baza, $fakturaID)
{
	$kwota=array();

	$kwota['n23']=0;
	$kwota['n22']=0;

	$kwota['b23']=0;
	$kwota['b22']=0;

	$kwota['v23']=0;
	$kwota['v22']=0;

	$kwota['n7']=0;
	$kwota['n8']=0;

	$kwota['b7']=0;
	$kwota['b8']=0;

	$kwota['v7']=0;
	$kwota['v8']=0;

	$kwota['n5']=0;
	$kwota['n3']=0;

	$kwota['b5']=0;
	$kwota['b3']=0;

	$kwota['v5']=0;
	$kwota['v3']=0;

	$kwota['n4']=0;
	$kwota['b4']=0;
	$kwota['v4']=0;

	$kwota['n0']=0;
	$kwota['nzw']=0;

	$kwota['b0']=0;
	$kwota['bzw']=0;

	$kwota['v0']=0;
	$kwota['vzw']=0;

	$towary=mysqli_query($link,"
		select *
		  from $baza.dokumentm
		 where ID_D='$fakturaID'
	  order by ID
	");
	while($towar=mysqli_fetch_array($towary))
	{
		$stawkaVAT=str_replace('%','',substr($towar['STAWKA'],0,2));	//Max 2 znaki: 23, 22, 8, 7, 5, 3, 0, zw
		$kwota["b$stawkaVAT"]+=$towar['BRUTTO'];
		$kwota["b$stawkaVAT"]=round($kwota["b$stawkaVAT"],2);
	}

	$kwota['n23']=round($kwota['b23']*100/123,2);
	$kwota['n22']=round($kwota['b22']*100/122,2);
	$kwota['n8']=round($kwota['b8']*100/108,2);
	$kwota['n7']=round($kwota['b7']*100/107,2);
	$kwota['n5']=round($kwota['b5']*100/105,2);
	$kwota['n4']=round($kwota['b4']*100/104,2);
	$kwota['n3']=round($kwota['b3']*100/103,2);
	$kwota['n0']=$kwota['b0'];
	$kwota['nzw']=$kwota['bzw'];

	$kwota['v23']=round($kwota['b23']-$kwota['n23'],2);
	$kwota['v22']=round($kwota['b22']-$kwota['n22'],2);
	$kwota['v8']=round($kwota['b8']-$kwota['n8'],2);
	$kwota['v7']=round($kwota['b7']-$kwota['n7'],2);
	$kwota['v5']=round($kwota['b5']-$kwota['n5'],2);
	$kwota['v4']=round($kwota['b4']-$kwota['n4'],2);
	$kwota['v3']=round($kwota['b3']-$kwota['n3'],2);

	return $kwota;
}
