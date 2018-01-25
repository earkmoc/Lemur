<?php

//wymaga zainstalowania rozszerzenia "php_dbase", np.: C:\wamp\bin\php\php5.6.25\ext\php_dbase.dll

//die(print_r($_POST));

ini_set('max_execution_time', 600);
error_reporting(E_ERROR | E_PARSE | E_WARNING);//E_NOTICE | 

$dzis=date('Y-m-d');
$czas=date('Y-m-d H:i:s');

$file=$_POST['path'].'\\max.txt';
$cosJest=file_exists($file);

if($cosJest)
{
	require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

	//Inicjowanie tabel
	$tabele=array();
	if($_POST['NORDPOL'])
	{
		$tabele[]='nordpol';
	}
	if	( ($_POST['KNORDPOL'])
		||($_POST['MEGAKO'])
		||($_POST['MEGAWN'])
		||($_POST['MEGAWW'])
		||($_POST['MEGAPN'])
		||($_POST['MEGAPW'])
		)
	{
		$tabele[]='knordpol';
		$tabele[]='dnordpol';
		$tabele[]='bilans';
		$tabele[]='bilansp';
		$tabele[]='rachwyn';
		$tabele[]='dokumenty';
		$tabele[]='dokumentr';
		$tabele[]='dokumentk';
		$tabele[]='dokumentm';
		$tabele[]='kpr';
	}
	if($_POST['SRODKITR'])
	{
		$tabele[]='srodkitr';
		$tabele[]='srodkiot';
		$tabele[]='srodkihi';
		$tabele[]='srodkizm';
	}
	if($_POST['LPLAC'])
	{
		$tabele[]='pracownicy';
		$tabele[]='listyplac';
		$tabele[]='listyplacp';
	}
	if	( ($_POST['TOWARY'])
		||($_POST['MEGAKM'])
		)
	{
		$tabele[]='towary';
		mysqli_query($link,$q="drop table towary");
		$towaryStruktura=mysqli_fetch_row(mysqli_query($link,$q="select STRUKTURA from Lemur2.tabele where NAZWA='towary'"))[0];
		mysqli_query($link,$towaryStruktura);
	}
	foreach($tabele as $tabela)
	{
		$widok=$tabela;
		require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");
		mysqli_query($link,$q="truncate $tabela");
	}

//KNORDPOL
	//Mazovia  134 141 145 146 164 162 158 166 167 143 149 144 156 165 163 152 160 161
	//ISO88592 177 230 234 179 241 243 182 188 191 161 198 202 163 209 211 166 172 175
	$maz=array(134,141,145,146,164,162,158,166,167,161,143,149,144,163,156,165,152,160);
	$iso=array(177,230,234,179,241,243,182,188,191,175,161,198,202,211,163,209,166,172);
	//Array (  ± > æ > ê > ³ > ñ > ó > ¶ > ¼ > ¿ > ¯ > ¡ > Æ > Ê > Ó > £ > Ñ > ¦ > ¬ )

	foreach($maz as $key => $value) {$maz[$key]=chr($value);}
	foreach($iso as $key => $value) {$iso[$key]=chr($value);}

	$wyniki=array('dubli'=>0);

	//Importowane tabele
	$pliki=array(
		 'megako'=>'Kontrahenci'
		,'megakm'=>'Magazyn'
		,'megawn'=>'Dokumenty WZ'
		,'megaww'=>'Dokumenty WZ - specyfikacja'
		,'megapn'=>'Dokumenty PZ'
		,'megapw'=>'Dokumenty PZ - specyfikacja'
		,'nordpol'=>'Dziennik g³ówny'
		,'knordpol'=>'Plan Kont i dane kontrahentów'
		,'dnordpol'=>'Typy dokumentów ksiêgowych'
		,'bilans'=>'Bilans AKTYWA'
		,'bilansp'=>'Bilans PASYWA'
		,'rachwyn'=>'Rachunek Wyników'
		,'ksiega'=>'Ksiêga Przychodów i Rozchodów'
		,'r_sprz'=>'rejestr sprzeda¿y VAT'
		,'rej_sp'=>'rejestr sprzeda¿y VAT'
		,'rksprz'=>'rejestr korekt sprzeda¿y VAT'
		,'r_sprzzw'=>'rejestr sprzeda¿y export'
		,'r_zakuzw'=>'rejestr zakupu export'
		,'r_swdt'=>'rejestr sprzeda¿y WDT'
		,'r_swnt'=>'rejestr sprzeda¿y WNT'
		,'r_zakup'=>'rejestr zakupów towarów'
		,'r_zakut'=>'rejestr zakupów towarów'
		,'rej_zk'=>'rejestr zakupów towarów'
		,'r_zakuu'=>'rejestr zakupów us³ug'
		,'r_zakua'=>'rejestr zakupów zwolnionych z VAT'
		,'r_zakum'=>'rejestr zakupów materia³ów'
		,'r_zakus'=>'rejestr zakupów ¶rodków trwa³ych'
		,'r_zakuw'=>'rejestr zakupów ...'
		,'r_zakuz'=>'rejestr zakupów zwolnionych'
		,'srodkitr'=>'Srodki trwale'
		,'srodkiot'=>'Srodki trwale - dokumenty OT'
		,'srodkihi'=>'Srodki trwale - historia'
		,'srodkizm'=>'Srodki trwale - zmiany'
		,'lprac'=>'Listy plat - pracownicy'
		,'lplac'=>'Listy plat - naglówki'
		,'lplacp'=>'Listy plat - pozycje'
		,'lplacpp'=>'Listy plat - skladniki pozycji'
		,'towary'=>'Magazyny - towary'
		,'dokum'=>'Magazyny - dokumenty'
		,'spec'=>'Magazyny - specyfikacje'
		,'rej_pcc'=>'rejestr podatku PCC'
	);
//		,'doktypy'=>'Magazyny - parametry'

	function Rejestruj($link, $skrot, $rejestr)
	{
		if(!$rejestr) {return;}
		
		$idd=mysqli_insert_id($link);
		
		$query=("
			insert
			  into dokumentr
			select 0
				 , ID
				 , KTO
				 , CZAS
				 , '$rejestr'
				 , ''
				 , 0
				 , 0
		");

		$vat='23%';
		$vat=($skrot=='r_sprzzw'?'0%e':$vat);
		$vat=($skrot=='r_zakuzw'?'0%e':$vat);
		$vat=($skrot=='r_swdt'?'0%w':$vat);
		//$vat=($skrot=='r_zakua'?'zw.':$vat);
		
		$sk6=substr($skrot,0,6);
		$sk6=($skrot=='r_sprzzw'?'0%e':$sk6);
		$sk6=($skrot=='r_zakuzw'?'0%e':$sk6);
		$w=mysqli_query($link,$q=$query."
				 , if(NETTOVATU or '$sk6'='r_zaku',NETTOVATU,NETTOVAT)
				 , '$vat'
				 , if(NETTOWALU or '$sk6'='r_zaku',NETTOWALU,PODATEK_VAT)
				 , if(NETTOVATU or '$sk6'='r_zaku',NETTOVATU,NETTOVAT)+if(NETTOWALU or '$sk6'='r_zaku',NETTOWALU,PODATEK_VAT)
				 , left(DOPERACJI,7)
			  from dokumenty
			 where ID=$idd
			   and if(NETTOWALU or '$sk6'='r_zaku',NETTOWALU,PODATEK_VAT)<>0
		");
		if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
/*
		if($skrot=='r_sprzzw')
		{
			echo "<br>$q = ".mysql_affected_rows();
		}
*/		
		//insert rejestry dla '8%'
		$w=mysqli_query($link,$q=$query."
				 , NETTOVATT
				 , '8%'
				 , NETTOWALT
				 , NETTOVATT+NETTOWALT
				 , left(DOPERACJI,7)
			  from dokumenty
			 where ID=$idd
			   and NETTOVATT+NETTOWALT<>0
		");
		if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

		//insert rejestry dla '5%'
		$w=mysqli_query($link,$q=$query."
				 , NETTOVATW
				 , '5%'
				 , NETTOWALW
				 , NETTOVATW+NETTOWALW
				 , left(DOPERACJI,7)
			  from dokumenty
			 where ID=$idd
			   and NETTOVATW+NETTOWALW<>0
		");
		if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

		$vat=($skrot=='r_swdt'?'0%w':'0%');
		//insert rejestry dla materia³y.VAT='0%'
		$w=mysqli_query($link,$q=$query."
				 , NETTOPDU
				 , '$vat'
				 , 0
				 , NETTOPDU
				 , left(DOPERACJI,7)
			  from dokumenty
			 where ID=$idd
			   and dokumenty.NETTOPDU<>0
		");
		if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

		//insert rejestry dla materia³y.VAT='zw.'
		$w=mysqli_query($link,$q=$query."
				 , NETTOVATM
				 , 'zw.'
				 , 0
				 , NETTOVATM
				 , left(DOPERACJI,7)
			  from dokumenty
			 where ID=$idd
			   and dokumenty.NETTOVATM<>0
		");
		if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

		//sprz±tanie
		$w=mysqli_query($link,$q="
			 update dokumenty 
				set NETTOVATU=0 
				  , NETTOWALU=0 
				  , NETTOVATT=0 
				  , NETTOWALT=0 
				  , NETTOVATW=0 
				  , NETTOWALW=0 
				  , NETTOVATM=0
				  , NETTOPDU=0
			  where ID=$idd
		");
		if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
	}

	foreach($pliki as $skrot => $opis)
	{
		//wybrany checkbox?
		if(!$_POST[strtoupper($skrot)])
		{
			continue;
		}

		$typ='';
		$rejestr='';
		$przedmiot='';
		$w=mysqli_query($link, "
			select TYP
				 , REJESTR
				 , OPIS
			  from schematy
			 where DBF='$skrot'
		");
		if($r=mysqli_fetch_array($w))
		{
			$typ=$r['TYP'];
			$rejestr=$r['REJESTR'];
			$przedmiot=$r['OPIS'];
		}
		
		$wyniki[$skrot]=0;

		if($skrot=='lprac')
		{
			//Mazovia  134 141 145 146 164 162 158 166 167 143 149 144 156 165 163 152 160 161
			//ISO88592 177 230 234 179 241 243 182 188 191 161 198 202 163 209 211 166 172 175
			//$maz=ray(141,134,145,146,143,162,158,166,167,161,164,149,144,163,156,165,152,160);
			$maz=array(141,134,145,146,164,162,158,166,167,161,164,149,144,163,156,165,152,160);
			$iso=array(177,230,234,179,241,243,182,188,191,175,161,198,202,211,163,209,166,172);
			//Array (  ± > æ > ê > ³ > ñ > ó > ¶ > ¼ > ¿ > ¯ > ¡ > Æ > Ê > Ó > £ > Ñ > ¦ > ¬ )

			foreach($maz as $key => $value) {$maz[$key]=chr($value);}
			foreach($iso as $key => $value) {$iso[$key]=chr($value);}
		}
/*		
		//KNORDPOL
			//Mazovia  134 141 145 146 164 162 158 166 167 143 149 144 156 165 163 152 160 161
			//ISO88592 177 230 234 179 241 243 182 188 191 161 198 202 163 209 211 166 172 175
			$maz=array(134,141,145,146,164,162,158,166,167,161,143,149,144,163,156,165,152,160);
			$iso=array(177,230,234,179,241,243,182,188,191,175,161,198,202,211,163,209,166,172);
			//Array (  ± > æ > ê > ³ > ñ > ó > ¶ > ¼ > ¿ > ¯ > ¡ > Æ > Ê > Ó > £ > Ñ > ¦ > ¬ )
*/			
		$file=$_POST['path'].'\\'.$skrot.'.dbf';
		$dbf = dbase_open($file,0);
		$i=1;
		while ($zapis=dbase_get_record_with_names($dbf,$i++))
		{
			if($zapis['deleted']==0)
			{
				$q='';
				$koniec=false;
				$indeks='';
				$cz='';
				$dt='';
				foreach($zapis as $key=>$value)
				{
					if	( ($key!='deleted')
						&&(!$koniec)
						)
					{
						//$value=iconv('windows-1250','iso-8859-2',$value);
						$value=str_replace($maz,$iso,$value);
						$value=str_replace("'","`",$value);
						$value=AddSlashes($value);
						$value=trim($value);
						switch (true)
						{
							case $skrot=='bilans':
							case $skrot=='bilansp':
							case $skrot=='rachwyn':
								$q.=(!$q?"insert into $skrot set $key='$value'":", $key='$value'");
								break;
							case $skrot=='megako':
								switch ($key)
								{
									case 'ODBIORCA': 
										$key='NUMER';
										break;
									case 'SYMBOL': 
										$key='PSEUDO';
										break;
									case 'TELEFON': 
										$key='SKR_POCZT';
										break;
									case 'MIEJSCOW': 
										$key='MIASTO';
										break;
									case 'ADRES': 
										$key='ULICA';
										break;
									case 'KONTO_BANK': 
										$key='RACH';
										break;
									case 'NUMER_VAT': 
										$key='NIP';
										break;
									case 'NAZWA': 
										$nazwa='';
									case 'NAZWA_1': 
									case 'NAZWA_2': 
									case 'NAZWA_3': 
										$key='';
										$nazwa.=' '.trim($value);
										break;
									case 'NAZWA_4': 
										$key='NAZWA';
										$nazwa.=' '.trim($value);
										$value=$nazwa;
										break;
									case 'NAZWISKO': 
										$key='BRANZA';
										break;
									case 'DEF_UPUST': 
									case 'DEF_CENNIK': 
									case 'BO_WIZYT': 
									case 'ILE_WIZYT': 
									case 'BO_OBROTU': 
									case 'WA_OBROTU': 
									case 'BO_KONTA': 
									case 'STAN_KONTA': 
									case 'DATA_WPR':
									case 'OPIS':
									case 'UWAGA_1':
									case 'UWAGA_2':
									case 'UWAGA_3':
									case 'TYP':
									case 'TELEFON1':
									case 'STARYNUMER':
									case 'UWAGA_4':
										$key='';
										break;
								}
								$q.=(!$q?"insert into knordpol set $key='$value'":($key?", $key='$value'":''));
								break;
							case $skrot=='megakm':
								switch ($key)
								{
									case 'INDEKS':
										$indeks=$value;
										break;
									case 'CENA_ZAKUP': 
										$cz=$value;
										$key='CENA_Z';
										break;
									case 'CENA_ZBYTU': 
										$key="CENA_B=round($value*1.23,2), CENA_S";
										break;
									case 'CENA_DETAL': 
										$key="CENA_B2=round($value*1.23,2), CENA_S2";
										break;
									case 'CENA_SPEC':
										$key="CENA_B3=round($value*1.23,2), CENA_S3";
										break;
									case 'STAN_MGZ': 
										$key='STAN';
										break;
									case 'VAT': 
										$key='STAWKA';
										$value.='%';
										break;
									case 'FLAGA':
										$key='ISBN';
										break;
									case 'DATA_BO': 
										$key='DATA';
										break;
									case 'JM':
										$value=(($value=='/')?'':$value);
										break;
									case 'SWW': 
									case 'DATA_TRAN': 
									case 'IL_BO': 
									case 'WART_BO': 
									case 'WART_MGZ': 
									case 'DOSTAWCA': 
									case 'ILR_ZAK': 
									case 'WARTR_ZAK': 
									case 'ILM_ZAK': 
									case 'WARTM_ZAK': 
									case 'ILR_INW': 
									case 'WARTR_INW': 
									case 'ILM_INW': 
									case 'WARTM_INW': 
									case 'ILR_SP': 
									case 'WARTR_SP': 
									case 'ILM_SP': 
									case 'WARTM_SP': 
									case 'ILR_SPZK': 
									case 'WARTR_SPZK': 
									case 'ILM_SPZK': 
									case 'WARTM_SPZK': 
									case 'ILR_SPZB':
									case 'WARTR_SPZB':
									case 'ILM_SPZB':
									case 'WARTM_SPZB':
									case 'ILR_SPDT':
									case 'WARTR_SPDT':
									case 'ILM_SPDT':
									case 'WARTM_SPDT':
									case 'DBCR':
									case 'PRZECENA':
									case 'ZN_M':
									case 'ZN_R':
									case 'ZN_M2':
									case 'ZN_R2':
									case 'WZ_M':
									case 'WZ_R':
									case 'ILM_SPS':
									case 'ILR_SPS':
									case 'LP_INWENT':
									case 'GR':
									case 'ILM_SPSP':
									case 'UWAGI':
									case 'ILR_SPSP':
									case 'PRODUCENT':
									case 'PKWIU':
									case 'KODPAS':
									case 'CENNIK_1':
									case 'CENNIK_2':
										$key='';
										break;
								}
								if($q||$key)
								{
									$q.=(!$q?"insert into towary set STATUS='T', $key='$value'":($key?", $key='$value'":''));
								}
								break;
							case $skrot=='megawn':
								switch ($key)
								{
									case 'NR_WZ':
										$key='NUMER';
										break;
									case 'ODBIORCA':
										$pseudo=mysqli_fetch_row(mysqli_query($link, "select PSEUDO from knordpol where NUMER='$value'"))[0];
										$key="PSKONT='$pseudo'";
										$key.=', NRKONT';
										break;
									case 'DATA_FAKT':
										$dt=$value;
										$key="DDOKUMENTU='$value', DOPERACJI";
										break;
									case 'ZAPLATA':
										$key='SPOSZAPL';
										$value=($value==null?' ':$value);
										break;
									case 'TERM_ZAPL':
										$key="DTERMIN=Date_Add('$dt',interval $value day)";
										$value=null;
										break;
									case 'OGOLEM':
										$key='WARTOSC';
										break;
									case 'DOK_KASY':
										$key='DODOK';
										$value=($value==null?' ':$value);
										break;
									case 'OTWARTY':
										$value=($value=='O'?'bufor':'ksiêgi');
										$key='GDZIE';
										break;
									case 'BIORCA':
										$nazwa=mysqli_fetch_row(mysqli_query($link, "select NAZWA from knordpol where NUMER='$value'"))[0];
										$adres=mysqli_fetch_row(mysqli_query($link, "select concat(KOD_POCZT,' ',MIASTO,', UL. ',ULICA) from knordpol where NUMER='$value'"))[0];
										$nip=mysqli_fetch_row(mysqli_query($link, "select NIP from knordpol where NUMER='$value'"))[0];
										$key="DELIVERY='$nip'";
										$key.=", PAYMENT='$nazwa'";
										$key.=", ADDINFO='$adres'";
										$key.=', HCCODE';
										break;
//									case 'UPRAWNION':
//										$key='UWAGI';
//										break;
									case 'DATA_O':
										$dt=$value;
										$dt=substr($dt,0,4).'-'.substr($dt,4,2).'-'.substr($dt,6,2);
										$key='';
										break;
									case 'CZAS_O':
										$key='CZAS';
										$value="$dt $value";
										break;
									case 'NAZWA': 
										$nazwa='';
									case 'NAZWA_1': 
									case 'NAZWA_2': 
									case 'NAZWA_3': 
										$key='';
										$nazwa.=' '.trim($value);
										break;
									case 'NAZWA_4': 
										$key='NAZWA';
										$nazwa.=' '.trim($value);
										$value=$nazwa;
										break;
									case 'KOD_POCZT': 
										$nazwa='';
									case 'MIEJSCOW': 
										$key='';
										$nazwa.=' '.trim($value);
										break;
									case 'ADRES': 
										$key='ADRES';
										$nazwa.=', UL. '.trim($value);
										$value=$nazwa;
										break;
									case 'NUMER_VAT': 
										$key='NIP';
										$value=($value==null?' ':$value);
										break;
									case 'WART_NET0':
										$netto=$value;
										$key='';
										break;
									case 'WART_NET7':
										$netto+=$value;
										$key='';
										break;
									case 'WART_VAT7':
										$vat=$value;
										$key='';
										break;
									case 'WART_NET22':
										$netto+=$value;
										$key='';
										break;
									case 'WART_VAT22':
										$vat+=$value;
										$key='';
										break;
									case 'WART_NETZW':
										$netto+=$value;
										$key='';
										break;
									case 'WART_NET3':
										$netto+=$value;
										$key='';
										break;
									case 'WART_VAT3':
										$vat+=$value;
										$key='';
										break;
									case 'WART_NET12':
										$netto+=$value;
										$value=($netto?$netto:'0');
										$key='NETTOVAT';
										break;
									case 'WART_VAT12':
										$vat+=$value;
										$value=($vat?$vat:'0');
										$key='PODATEK_VAT';
										break;
									case 'DO_DOKUM':
									case 'DOK_FISK':
									case 'WG_CEN':
									case 'WYSTAWIL':
									case 'WYDAL':
									case 'WRT_ZAKUP':
									case 'UPUST':
									case 'OSOBA_O':
									case 'WGPARAGONU':
									case 'DOK_ZAM':
									case 'OGOLEM_PU':
									case 'VATOWIEC':
									case 'WRT_ZAKUPN':
									case 'PLATNIK':
									case 'UPRAWNION':
									case 'UWAGI':
										$key='';
										break;
								}
								$q.=(!$q?"insert into dokumenty set TYP='FV', $key='$value'":($key?($value==null?", $key":", $key='$value'"):''));
								break;
							case $skrot=='megaww':
								switch ($key)
								{
									case 'NR_WZ':
										$key='ID_D';
										$value=mysqli_fetch_row(mysqli_query($link, "select ID from dokumenty where NUMER='$value' and TYP='FV'"))[0];
										break;
									case 'INDEKS':
										$indeks=$value;
										$key='';
										break;
									case 'CENA_ZAKUP':
										$cz=$value;
										$key='';
										break;
									case 'CENA':
										$cena=$value;
										$r=mysqli_fetch_row(mysqli_query($link, "select NAZWA, JM, PKWIU from towary where INDEKS='$indeks' and CENA_Z='$cz'"));
										$nazwa=$r[0];
										$jm=($r[1]=='\\'?'':$r[1]);
										$pkwiu=$r[2];
										if(!$nazwa)
										{
											$r=mysqli_fetch_row(mysqli_query($link, "select NAZWA, JM, PKWIU from towary where INDEKS='$indeks'"));
											$nazwa=$r[0];
											$jm=$r[1];
											$pkwiu=$r[2];
										}
										$key="INDEKS='$indeks', NAZWA='$nazwa', JM='$jm', PKWIU='$pkwiu', CENABEZR='$cena', CENA";
										break;
									case 'ILOSC':
										$brutto=round($value*$cena,2);
										$key="BRUTTO='$brutto', ILOSC";
										break;
									case 'VAT':
										$netto=round($brutto*100/(100+$value),2);
										$podatek=$brutto-$netto;
										$key="VAT='$podatek', NETTO='$netto', STAWKA";
										$value.='%';
										break;
									case 'UPUST':
										$key='RABAT';
										break;
									case 'ODBIORCA':
									case 'WG_CEN':
									case 'DATA_FAKT':
									case 'DOSTAWCA':
									case 'JM':
									case 'WARTOSC':
									case 'FLAGA':
										$key='';
										break;
								}
								$q.=(!$q?"insert into dokumentm set TYP='T', $key='$value'":($key?($value==null?", $key":", $key='$value'"):''));
								break;
							case $skrot=='megapn':
								switch ($key)
								{
									case 'NR_PZ':
										$key='NUMER';
										break;
									case 'DOSTAWCA':
										$pseudo=mysqli_fetch_row(mysqli_query($link, "select PSEUDO from knordpol where NUMER='$value'"))[0];
										$nazwa=mysqli_fetch_row(mysqli_query($link, "select NAZWA from knordpol where NUMER='$value'"))[0];
										$adres=mysqli_fetch_row(mysqli_query($link, "select concat(KOD_POCZT,' ',MIASTO,', UL. ',ULICA) from knordpol where NUMER='$value'"))[0];
										$nip=mysqli_fetch_row(mysqli_query($link, "select NIP from knordpol where NUMER='$value'"))[0];

										$key="PSKONT='$pseudo'";
										$key.=", NAZWA='$nazwa'";
										$key.=", ADRES='$adres'";
										$key.=", NIP='$nip'";
										$key.=', NRKONT';
										break;
									case 'DATA_DOST':
										$key="DOPERACJI";
										break;
									case 'WART_FKPZ':
										$key='WARTOSC';
										break;
//									case 'OGOLEM':
//										$key='NETTOVAT';
//										break;
									case 'NR_FK':
										$key='DODOK';
										$value=($value==null?' ':$value);
										break;
									case 'TERMIN':
										$key="DTERMIN";
										break;
									case 'DATA_WYST':
										$key="DDOKUMENTU";
										break;
//									case 'WYSTAWIL':
//										$key='UWAGI';
//										break;
									case 'OTWARTY':
										$value=($value=='O'?'bufor':'ksiêgi');
										$key='GDZIE';
										break;
									case 'NETTO_22':
										$netto=$value;
										$key='';
										break;
									case 'NETTO_7':
										$netto+=$value;
										$key='';
										break;
									case 'NETTO_0':
										$netto+=$value;
										$key='';
										break;
									case 'NETTO_ZW':
										$netto+=$value;
										$key='';
										break;
									case 'VAT_22':
										$vat=$value;
										$key='';
										break;
									case 'VAT_7':
										$vat+=$value;
										$key='';
										break;
									case 'DATA_O':
										$dt=$value;
										$dt=substr($dt,0,4).'-'.substr($dt,4,2).'-'.substr($dt,6,2);
										$key='';
										break;
									case 'CZAS_O':
										$key='CZAS';
										$value="$dt $value";
										break;
									case 'NETTO_3':
										$netto+=$value;
										$key='';
										break;
									case 'VAT_3':
										$vat+=$value;
										$key='';
										break;
									case 'NETTO_12':
										$netto+=$value;
										$value=($netto?$netto:'0');
										$key='NETTOVAT';
										break;
									case 'VAT_12':
										$vat+=$value;
										$value=($vat?$vat:'0');
										$key='PODATEK_VAT';
										break;
									case 'ZAPLATA':
										$key='SPOSZAPL';
										$value=($value==null?' ':$value);
										break;
									case 'OGOLEM':
									case 'WYSTAWIL':
									case 'OSOBA_O':
									case 'TPZ':
									case 'MARZA':
									case 'DATA_WYD':
										$key='';
										break;
								}
								$q.=(!$q?"insert into dokumenty set TYP='PZ', $key='$value'":($key?($value==null?", $key":", $key='$value'"):''));
								break;
							case $skrot=='megapw':
								switch ($key)
								{
									case 'NR_PZ':
										$key='ID_D';
										$value=mysqli_fetch_row(mysqli_query($link, "select ID from dokumenty where NUMER='$value' and TYP='PZ'"))[0];
										break;
									case 'INDEKS':
										$indeks=$value;
										$key='';
										break;
									case 'CENA_ZAKUP':
										$cena=$value;
										$r=mysqli_fetch_row(mysqli_query($link, "select NAZWA, JM, PKWIU, STAWKA from towary where INDEKS='$indeks' and CENA_Z='$cz'"));
										$nazwa=$r[0];
										$jm=($r[1]=='\\'?'':$r[1]);
										$pkwiu=$r[2];
										$stawka=$r[3];
										if(!$nazwa)
										{
											$r=mysqli_fetch_row(mysqli_query($link, "select NAZWA, JM, PKWIU, STAWKA from towary where INDEKS='$indeks'"));
											$nazwa=$r[0];
											$jm=$r[1];
											$pkwiu=$r[2];
											$stawka=$r[3];
										}
										$key="INDEKS='$indeks', NAZWA='$nazwa', JM='$jm', PKWIU='$pkwiu', CENABEZR='$cena', STAWKA='$stawka', CENA";
										break;
									case 'ILOSC':
										$netto=round($value*$cena,2);
										$podatek=round($netto*$stawka*0.01,2);
										$brutto=$netto+$podatek;
										$key="NETTO='$netto', BRUTTO='$brutto', VAT='$podatek', ILOSC";
										break;
									case 'DOSTAWCA':
									case 'DATA_DOST':
									case 'JM':
									case 'FLAGA':
									case 'WARTOSC':
										$key='';
										break;
								}
								$q.=(!$q?"insert into dokumentm set TYP='T', $key='$value'":($key?($value==null?", $key":", $key='$value'"):''));
								break;
							case $skrot=='towary':
								switch ($key)
								{
									case 'ID': 
										$q="insert into towary set KTO='$ido', CZAS=Now()";
										break;
									case 'SWW': 
										$key='PKWIU';
										break;
									case 'VAT': 
										$value="$value%";
										$key='STAWKA';
										break;
									case 'STATUS': 
										$value=(($value==' ')?'T':"$value");
										break;
								}
								$q.=($key?", $key='$value'":"");
								break;
							case $skrot=='spec':
								switch ($key)
								{
									case 'ID_D': 
										if($ok=($value*1>0))
										{
											$value=mysqli_fetch_row(mysqli_query($link, "select ID from dokumenty where ID_KNORDPOL='$value'"))[0];
											$q="insert into dokumentm set KTO='$ido', CZAS=Now(), ID_D='$value'";
										}
										$key='';
										break;
									case 'ID_T': 
										$key='LOT';	//do relacji z towarami (towary.dbf); masowy update na koñcu tego skryptu
										break;
								}
								$key=($ok?$key:"");
								$q.=($key?", $key='$value'":"");
								break;
							case $skrot=='dokum':
								switch ($key)
								{
									case 'ID': 
										$key='ID_KNORDPOL'; //do relacji ze specyfikacj± (spec.dbf)
										$q="insert into dokumenty set KTO='$ido', LP='$value'";
										break;
									case 'BLOKADA':
										$key='GDZIE';
										$value=($value='O'?'bufor':'ksiêgi');
										break;
									case 'INDEKS':
										$key='NUMER';
										break;
									case 'NABYWCA':
										$key='NRKONT';
										break;
									case 'DATAW':
										$q.=", DWYSTAWIENIA='$value'";
										$key='DDOKUMENTU';
										break;
									case 'DATAS':
										$q.=", DSPRZEDAZY='$value'";
										$key='DOPERACJI';
										break;
									case 'DATAO':
										$q.=", DWPROWADZE='$value'";
										$key='DWPLYWU';
										break;
									case 'DATAT':
										$key='DTERMIN';
										break;
									case 'SPOSOB':
										$key='SPOSZAPL';
										break;
									case 'NUMERFD':
										$key='DODOK';
										break;
									case 'VAT22':
									case 'VAT7':
									case 'NETTO22':
									case 'NETTO7':
									case 'NETTO0':
									case 'NETTOZW':
									case 'NETTOCZ':
									case 'TYP_F':
									case 'NAZWA2':
									case 'NAZWA3':
									case 'MAGAZYN':
									case 'WYSTAWIL':
									case 'ODEBRAL':
									case 'MAGAZYN':
										$key='';
										break;
									case 'INDEKS_F':
										$key='PSKONT';
										break;
									case 'NAZWA1':
										$key='NAZWA';
										break;
									case 'KOD':
										$key='';
										$kod=$value;
										break;
									case 'MIASTO':
										$key='';
										$miasto=$value;
										break;
									case 'ADRES':
										$value="$kod $miasto, $value";
										break;
									case 'NETTO23':
										$key='';
										$netto23=$value;
										break;
									case 'NETTO8':
										$key='';
										$netto8=$value;
										break;
									case 'NETTO3':
										$key='';
										$netto3=$value;
										break;
									case 'NETTO5':
										$key='';
										$value=$netto23+$netto8+$value;
										$q.=", NETTOVAT=$value";
										break;
									case 'VAT23':
										$key='';
										$vat23=$value;
										break;
									case 'VAT8':
										$key='';
										$vat8=$value;
										break;
									case 'VAT3':
										$key='';
										$vat3=$value;
										break;
									case 'VAT5':
										$key='';
										$value=$vat23+$vat8+$value;
										$q.=", PODATEK_VAT=$value";
										break;
								}
								$q.=($key?", $key='$value'":"");
								break;
							case $skrot=='lplacpp':
								$value=str_replace(".","",$value);
								$value=str_replace(",",".",$value);
								switch ($key)
								{
									case 'ID': 
										$key=''; 
										break;
									case 'ID_LPLAC': 
										$key=''; 
										$idLP=$value; 
										break;
									case 'ID_LPLACP': 
										$key=''; 
										$idLPP=$idLP*100+$value; 
										break;
									case 'ID_LPDPD': 
										$key=''; 
										$idLPDPD=$value; 
										break;
									case 'WARTOSC': 
										switch ($idLPDPD)
										{
											case 0: 
											case 1: 
											case 2: 
												$key=''; 
												break;
											case 3: 
												$key='P_PODST'; 
												break;
											case 4: 
												$key='DOD1'; 
												break;
											case 5: 
												$key='DOD2'; 
												break;
											case 6: 
												$key='DOD3'; 
												break;
											case 7: 
												$key='ZAS_CHOR'; 
												break;
											case 8: 
												$key='OGPRZYCHOD'; 
												break;
											case 9: 
												$key='PSUS'; 
												break;
											case 10: 
												$key='SUE'; 
												break;
											case 11: 
												$key='SUR'; 
												break;
											case 12: 
												$key='SUCH'; 
												break;
											case 13: 
												$key='SRAZEM'; 
												break;
											case 14: 
												$key='KUZPRZYCH'; 
												break;
											case 25: 
												$key='KWOLNA'; 
												break;
											case 15: 
												$key='PSUZ'; 
												break;
											case 16: 
												$key='PONAPODOCH'; 
												break;
											case 26: 
												$key='POZANAPODO'; 
												break;
											case 140: 
												$key='SUZNA'; 
												break;
											case 27: 
												$key='SUZ'; 
												break;
											case 28: 
												$key='NAZANAPODO'; 
												break;
											case 29: 
												$key='SGRUBNAZY'; 
												break;
											case 30: 
												$key='POINNE'; 
												break;
											case 64: 
												$key='PORAZEM'; 
												break;
											case 31: 
												$key='ZARO'; 
												break;
											case 32: 
												$key='DOWY'; 
												break;
											case 33: 
												$key=''; 
												break;
											case 74: 
												$key='SUEP'; 
												break;
											case 75: 
												$key='SURP'; 
												break;
											case 76: 
												$key='SUCHP'; 
												break;
											case 77: 
												$key='SRAZEMP'; 
												break;
											case 79: 
												$key='FPRACY'; 
												break;
											case 80: 
												$key='FGSP'; 
												break;
											case 85: 
												$key='ZASWYPLAC'; 
												break;
											case 73: 
												$key=''; 
												break;
										}
										break;
								}
								if($key)
								{
									$q="update listyplacp set $key='$value' where ID=$idLPP";
								}
								break;
							case $skrot=='lplacp':
								switch ($key)
								{
									case 'ID': 
										$idLPP=$value;
										$key=''; 
										break;
									case 'ID_LPLAC': 
										$key='ID_D'; 
										$q="insert into listyplacp set KTO='$ido', CZAS=Now(), $key='$value', ID=$value*100+$idLPP";
										$key='';
										break;
										break;
									case 'ID_PRAC': 
										$key='ID_P'; 
										break;
								}
								if($key)
								{
									$q.=", $key='$value'";
								}
								break;
							case $skrot=='lplac':
								switch ($key)
								{
									case 'ID_LPD': 
									case 'ID_LPD2': 
										$key=''; 
										break;
									case 'DATAD': 
										$key='DOTYCZY';
										$value=substr($value,0,4).'-'.substr($value,4,2);
										$koniec=true;
										break;
								}
								if($key)
								{
									$q.=(!$q?"insert into listyplac set KTO='$ido', CZAS=Now()":"");
									$q.=", $key='$value'";
								}
								break;
							case $skrot=='lprac':
								switch ($key)
								{
									case 'NAZWA': 
										$key='NAZWISKOIMIE'; 
										break;
									case 'DATAURODZ': 
										$key='DATAURODZENIA'; 
										break;
									case 'MIEJSCEUR': 
										$key='MIEJSCEURODZENIA'; 
										break;
									case 'MIEJSCEZAM': 
										$key=''; 
										break;
									case 'ULICA': 
										$ulica=$value;
										$key='';
										break;
									case 'ULICANR': 
										$ulicaNr=$value;
										$key='';
										break;
									case 'ULICAM': 
										$q.=", ADRES=concat('$ulica',' $ulicaNr',' m. $value')";
										$key='';
										break;
									case 'KODPOCZT': 
										$key='KODPOCZTOWY'; 
										break;
									case 'ZATRUD_OD': 
										$key='DATAZATRUDNIENIA'; 
										break;
									case 'ZATRUD_DO': 
										$key='DATAZWOLNIENIA'; 
										break;
									case 'ODKOUZPRZY': 
										$key='ODLICZANEKOSZTY'; 
										break;
									case 'ODKWWOODPO': 
										$key='ODLICZANAKWOP'; 
										break;
									case 'DOROOBPODO': 
										$key='CZYROZLICZAC'; 
										break;
									case 'US_NAZWA': 
										$key='URZADSKARBOWY'; 
										break;
									case 'US_MIASTO': 
										$key='MIASTOUS'; 
										break;
									case 'US_ULICA': 
										$usUlica=$value;
										$key=''; 
										break;
									case 'US_ULICANR': 
										$q.=", ADRESUS=concat('$usUlica',' $value')";
										$key='';
										break;
									case 'US_KODPOCZ': 
										$key='KODPOCZTOWYUS'; 
										break;
									case 'US_BANK': 
										$key='BANK'; 
										break;
									case 'US_KONTO': 
										$key='KONTO'; 
										break;
								}
								if($key)
								{
									$q.=(!$q?"insert into pracownicy set KTO='$ido', CZAS=Now()":"");
									$q.=", $key='$value'";
								}
								break;
							case substr($skrot,0,6)=='srodki':
								$q.=(!$q?"insert into $skrot set $key='$value'":", $key='$value'");
								if( ($skrot=='srodkitr')
								  &&($key=='LP')
								  )
								{
									$q.=", ID='$value'";
								}
								elseif( ($skrot!='srodkitr')
									  &&($key=='LPP')
									  )
								{
									$q.=", ID_D='$value'";
								}
								break;
							case $skrot=='nordpol':
								$q.=(!$q?"insert into nordpol set $key='$value'":", $key='$value'");
								break;
							case $skrot=='knordpol':
								$q.=(!$q?"insert into knordpol set $key='$value'":", $key='$value'");
								break;
							case $skrot=='dnordpol':
								$q.=(!$q?"insert into dnordpol set $key='$value'":", $key='$value'");
								break;
							case $skrot=='ksiega':
								switch ($key)
								{
									case 'FIRMA': 
										$key='NAZWA'; 
										if($pos=strpos($value,'NIP:'))
										{
											$nip=trim(substr($value,$pos+4));
											$value=substr($value,0,$pos);
											$q.=", NIP='$nip'";
										}
										break;
									case 'GOTOWKA':
										$key='WYNAGRODZENIA'; 
										break;
									case 'UWAGI_20':
										$key='INNE'; 
										break;
									case 'UWAGI_21':
										$key='UWAGI'; 
										break;
									case 'PODATEK':
									case 'PRZEROB':
									case 'KOSZTY_RE':
									case 'NATURA':
									case 'WYPOSAZEN':
									case 'ANULOWANO':
									case 'DEKRETY':
										$key=''; 
										break;
								}
								if($key)
								{
									$q.=(!$q?"insert into kpr set ID_D=0, KTO='$ido', $key='$value'":", $key='$value'");
								}
								break;
							case $skrot=='rksprz':
							case $skrot=='r_sprz':
								switch ($key)
								{
									case 'NUMER_FAK':
										$key='NUMER';
										break;
									case 'D1':
										$key='DDOKUMENTU';
										$q.=", DWYSTAWIENIA='$value'";
										$q.=", DWPROWADZE='$value'";
										$q.=", DWPLYWU='$value'";
										break;
									case 'D2':
										$key='DOPERACJI';
										$q.=", DSPRZEDAZY='$value'";
										break;
									case 'K7':
										$key='WARTOSC';
										break;
									case 'K8':	//n22
										$key='NETTOVATU';
										$netto22=$value;
										break;
									case 'K9':	//v22
										$key='NETTOWALU';
										$vat22=$value;
										break;
									case 'K10':	//n7
										$key='NETTOVATT';
										$netto7=$value;
										break;
									case 'K11':	//v7
										$key='NETTOWALT';
										$q.=", PODATEK_VAT=$vat22+$value";
										$vat22=0;
										break;
									case 'K12':	//0%e
										if(($n0e=$value)<>0)
										{
											$key='NETTOPDU';
											$q.=", NETTOVAT=$netto22+$netto7+$value";
											$q.=", NETTOPD=$netto22+$netto7+$value";
											$n0e=$value;
											$netto22=0;
											$netto7=0;
											break;
										}
										$key='';
										break;
									case 'K13':	//0%k
										if($n0e==0)
										{
											$key='NETTOPDU';
											$q.=", NETTOVAT=$netto22+$netto7+$value";
											$q.=", NETTOPD=$netto22+$netto7+$value";
											$netto22=0;
											$netto7=0;
											break;
										}
										$key='';
										break;
									case 'K14':
										$key='NETTOVATM';
										break;
									case 'K16':
										$key='WPLACONO';
										$value="WARTOSC-$value";
										break;
									case 'K15':
									case 'WDT':
									case 'WTT':
									case 'EXP':
										$key=''; 
										break;
								}
								if($key)
								{
									$q.=(!$q?"insert into dokumenty set KTO='$ido', CZAS=Now(), GDZIE='bufor', TYP='$typ', PRZEDMIOT='$przedmiot', $key='$value'":", $key='$value'");
								}
								break;
							case $skrot=='rksprz':
								switch ($key)
								{
									case 'NUMER_FAK':
										$key='NUMER';
										break;
									case 'D1':
										$key='DDOKUMENTU';
										$q.=", DWYSTAWIENIA='$value'";
										$q.=", DWPROWADZE='$value'";
										$q.=", DWPLYWU='$value'";
										break;
									case 'D2':
										$key='DOPERACJI';
										$q.=", DSPRZEDAZY='$value'";
										break;
									case 'K7':
										$key='WARTOSC';
										break;
									case 'K8':
										$key='NETTOVAT';
										$q.=", NETTOPD='$value'";
										break;
									case 'K9':
										$key='PODATEK_VAT';
										break;
									case 'K16':
										$key='WPLACONO';
										$value="WARTOSC-$value";
										break;
									case 'K10':
										$key='NETTOVATT';
										break;
									case 'K11':
										$key='NETTOWALT';
										break;
									case 'K12':
									case 'K13':
									case 'K14':
									case 'K15':
									case 'WDT':
									case 'WTT':
									case 'EXP':
										$key=''; 
										break;
								}
								if($key)
								{
									$q.=(!$q?"insert into dokumenty set KTO='$ido', CZAS=Now(), GDZIE='bufor', TYP='$typ', PRZEDMIOT='$przedmiot', $key='$value'":", $key='$value'");
								}
								break;
							case $skrot=='r_swnt':
								switch ($key)
								{
									case 'NUMER_FAK':
										$key='NUMER';
										break;
									case 'D1':
										$key='DDOKUMENTU';
										$q.=", DWYSTAWIENIA='$value'";
										$q.=", DWPROWADZE='$value'";
										$q.=", DWPLYWU='$value'";
										break;
									case 'D2':
										$key='DOPERACJI';
										$q.=", DSPRZEDAZY='$value'";
										break;
									case 'K7':
										$key='WARTOSC';
										break;
									case 'K8':
										$key='NETTOVAT';
										$q.=", NETTOPD='$value'";
										break;
									case 'K9':
										$key='PODATEK_VAT';
										break;
									case 'K16':
										$key='WPLACONO';
										$value="WARTOSC-$value";
										break;
									case 'K10':
									case 'K11':
									case 'K12':
									case 'K13':
									case 'K14':
									case 'K15':
									case 'WDT':
									case 'WTT':
									case 'EXP':
										$key=''; 
										break;
								}
								if($key)
								{
									$q.=(!$q?"insert into dokumenty set KTO='$ido', CZAS=Now(), GDZIE='bufor', TYP='$typ', PRZEDMIOT='$przedmiot', $key='$value'":", $key='$value'");
								}
								break;
							case $skrot=='r_zakuzw':
							case $skrot=='r_sprzzw':
								switch ($key)
								{
									case 'NUMER_FAK':
										$key='NUMER';
										break;
									case 'D1':
										$key='DDOKUMENTU';
										$q.=", DWYSTAWIENIA='$value'";
										$q.=", DWPROWADZE='$value'";
										$q.=", DWPLYWU='$value'";
										break;
									case 'D2':
										$key='DOPERACJI';
										$q.=", DSPRZEDAZY='$value'";
										break;
									case 'K7':
										$key='WARTOSC';
										$q.=", NETTOVAT='$value'";
										$q.=", NETTOPD='$value'";
										$q.=", NETTOPDU='$value'";
										break;
									case 'K16':
										$key='WPLACONO';
										$value="WARTOSC-$value";
										break;
									case 'K15':
										$key='UWAGI'; 
										break;
								}
								if($key)
								{
									$q.=(!$q?"insert into dokumenty set KTO='$ido', CZAS=Now(), GDZIE='bufor', TYP='$typ', PRZEDMIOT='$przedmiot', $key='$value'":", $key='$value'");
								}
								break;
							case $skrot=='r_swdt':
								switch ($key)
								{
									case 'NUMER_FAK':
										$key='NUMER';
										break;
									case 'D1':
										$key='DDOKUMENTU';
										$q.=", DWYSTAWIENIA='$value'";
										$q.=", DWPROWADZE='$value'";
										$q.=", DWPLYWU='$value'";
										break;
									case 'D2':
										$key='DOPERACJI';
										$q.=", DSPRZEDAZY='$value'";
										break;
									case 'K7':
										$key='WARTOSC';
										$q.=", NETTOPDU='$value'";
										$q.=", NETTOVAT='$value'";
										$q.=", NETTOPD='$value'";
										break;
									case 'K16':
										$key='WPLACONO';
										$value="WARTOSC-$value";
										break;
									case 'K15':
										$key=''; 
										break;
								}
								if($key)
								{
									$q.=(!$q?"insert into dokumenty set KTO='$ido', CZAS=Now(), GDZIE='bufor', TYP='$typ', PRZEDMIOT='$przedmiot', $key='$value'":", $key='$value'");
								}
								break;
							case $skrot=='r_zakup':
							case $skrot=='r_zakut':
							case $skrot=='r_zakuu':
							case $skrot=='r_zakua':
							case $skrot=='r_zakus':
							case $skrot=='r_zakum':
							case $skrot=='r_zakuw':
							case $skrot=='r_zakuz':
								switch ($key)
								{
									case 'NUMER_FAK':
										$key='NUMER';
										break;
									case 'D1':
										$key='DDOKUMENTU';
										$q.=", DWYSTAWIENIA='$value'";
										$q.=", DWPROWADZE='$value'";
										$q.=", DWPLYWU='$value'";
										break;
									case 'D2':
										$key='DOPERACJI';
										$q.=", DSPRZEDAZY='$value'";
										break;
									case 'K7':
										$key='WARTOSC';
										break;
									case 'K8':	//netto 23%
										$key='NETTOVATU';
										break;
									case 'K9':	//netto 8%
										$key='NETTOVATT';
										break;
									case 'K10':
									case 'K11':
									case 'K12':	//VAT 23%
										$key=(($value*1<>0)?'NETTOWALU':'');
										break;
									case 'K13':
									case 'K14':
									case 'K15':	//VAT 8%
										$key=(($value*1<>0)?'NETTOWALT':'');
										break;
									case 'K22':	//0%
										$key='NETTOPDU';
										break;
									case 'K23':	//zw.
										$key='NETTOVATM';
										break;
									case 'K24':
										$key='PODATEK_VAT';
										$q.=", NETTOVAT=WARTOSC-$value";
										$q.=", NETTOPD=WARTOSC-$value";
										break;
									case 'K27':
										$key='WPLACONO';
										break;
									case 'K_3_N':
										$key=(($value*1<>0)?'NETTOVATW':'');
										break;
									case 'K_3_1':
									case 'K_3_2':
									case 'K_3_3':	//VAT 5%
										$key=(($value*1<>0)?'NETTOWALW':'');
										break;
									case 'K16':
									case 'K17':
									case 'K18':
									case 'K19':
									case 'K20':
									case 'K21':
									case 'K22':
									case 'K25':
									case 'K26':
									case 'K28':
										$key=''; 
										break;
								}
								if($key)
								{
									$q.=(!$q?"insert into dokumenty set KTO='$ido', CZAS=Now(), GDZIE='bufor', TYP='$typ', PRZEDMIOT='$przedmiot', $key='$value'":", $key='$value'");
								}
								break;
							case $skrot=='rej_pcc':
								switch ($key)
								{
									case 'D1':
										$key='DWPLYWU';
										break;
									case 'D2':
										$key='DDOKUMENTU';
										$q.=", DWYSTAWIENIA='$value'";
										$q.=", DWPROWADZE='$value'";
										$q.=", DOPERACJI='$value'";
										$q.=", DSPRZEDAZY='$value'";
										break;
									case 'WARTOSC':
										$q.=", NETTOPDU='$value'";
										break;
									case 'K21':
										$key='WPLACONO';
										break;
									case 'STAWKA':
									case 'KWOTA':
									case 'NKS':
										$key=''; 
										break;
								}
								if($key)
								{
									$q.=(!$q?"insert into dokumenty set KTO='$ido', CZAS=Now(), GDZIE='bufor', TYP='$typ', $key='$value'":", $key='$value'");
								}
								break;
							case $skrot=='rej_sp':
								switch ($key)
								{
									case 'NUMER':
										$key='NUMER';
										break;
									case 'D1':
										$key='DWPLYWU';
										break;
									case 'D2':
										$key='DDOKUMENTU';
										$q.=", DWYSTAWIENIA='$value'";
										$q.=", DWPROWADZE='$value'";
										break;
									case 'D3':
										$key='DOPERACJI';
										$q.=", DSPRZEDAZY='$value'";
										break;
									case 'D4':
										$key='DTERMIN';
										break;
									case 'K11':
										$key='WARTOSC';
										break;
									case 'K12':	//23%
										$key='NETTOVATU';
										break;
									case 'K13':
										$key='PODATEK_VAT';
										$q.=", NETTOVAT=WARTOSC-$value";
										$q.=", NETTOPD=WARTOSC-$value";
										break;
									case 'K21':
										$key='WPLACONO';
										break;
									case 'K10':
									case 'K14':
									case 'K15':
									case 'K16':
									case 'K17':
									case 'K18':
									case 'K19':
									case 'K20':
									case 'K22':
									case 'K23':
									case 'K24':
									case 'K25':
									case 'K26':
									case 'K27':
									case 'K28':
										$key=''; 
										break;
								}
								if($key)
								{
									$q.=(!$q?"insert into dokumenty set KTO='$ido', CZAS=Now(), GDZIE='bufor', TYP='$typ', $key='$value'":", $key='$value'");
								}
								break;
							case $skrot=='rej_zk':
								switch ($key)
								{
									case 'NUMER':
										$key='NUMER';
										break;
									case 'D1':
										$key='DWPLYWU';
										break;
									case 'D2':
										$key='DDOKUMENTU';
										$q.=", DWYSTAWIENIA='$value'";
										$q.=", DWPROWADZE='$value'";
										break;
									case 'D3':
										$key='DOPERACJI';
										$q.=", DSPRZEDAZY='$value'";
										break;
									case 'D4':
										$key='DTERMIN';
										break;
									case 'K9':
										$key='WARTOSC';
										break;
									case 'K14':	//netto 23%
										$key='NETTOVATU';
										break;
									case 'K15':	//VAT 23%
										$key='NETTOWALU';
										break;
									case 'K16':	//netto 8%
										$key='NETTOVATT';
										break;
									case 'K17':	//VAT 8%
										$key='NETTOWALT';
										break;
									case 'K18':	//netto 0%
										$key='NETTOPDU';
										break;
									case 'K19':	//netto zw.
										$key='NETTOVATM';
										break;
									case 'K23':	//netto 5%
										$key='NETTOVATW';
										break;
									case 'K24':	//VAT 5%
										$key='NETTOWALW';
										break;
									case 'K20':
										$key='PODATEK_VAT';
										$q.=", NETTOVAT=WARTOSC-$value";
										$q.=", NETTOPD=WARTOSC-$value";
										break;
									case 'K26':
										$key='WPLACONO';
										break;
									case 'K10':
									case 'K11':
									case 'K12':
									case 'K13':
									case 'K21':
									case 'K22':
									case 'K25':
									case 'K27':
									case 'K28':
									case 'K29':
									case 'K30':
									case 'K31':
										$key=''; 
										break;
								}
								if($key)
								{
									$q.=(!$q?"insert into dokumenty set KTO='$ido', CZAS=Now(), GDZIE='bufor', TYP='$typ'":"");
									$q.=", $key='$value'";
								}
								break;
						}
					}
				}
				
				$q.=(substr($q,0,6)=='insert'?' on duplicate key update ID=ID':'');

				mysqli_query($link,$q);
				if (mysqli_error($link)) {die($skrot.'<br>'.mysqli_error($link).'<br>'.$q);}
				
				Rejestruj($link, $skrot, $rejestr);

				++$wyniki[$skrot];
			}
		}
	}

	//update kpr.NRKONT
	if($_POST['KNORDPOL'])
	{
	$w=mysqli_query($link,$q="
		update kpr
	 left join knordpol
			on if(kpr.NIP,replace(knordpol.NIP,'-','') like concat(replace(kpr.NIP,'-',''),'%'),1)
		   and upper(replace(replace(replace(knordpol.NAZWA,'`',''),'£','L'),'³','l')) like concat(upper(replace(replace(replace(kpr.NAZWA,'`',''),'£','L'),'³','l')),'%')
		   set kpr.NRKONT=knordpol.NUMER
			 , kpr.PSKONT=knordpol.PSEUDO
			 , kpr.NIP=knordpol.NIP
		 where kpr.NRKONT=0
	");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
	}
	
	//update dokumentm
	if  ( $_POST['TOWARY']
		&&$_POST['KNORDPOL']
		)
	{
		$w=mysqli_query($link,$q="
			update dokumentm
		 left join towary
				on towary.ID=dokumentm.LOT
			   set dokumentm.TYP=towary.STATUS
				 , dokumentm.STAWKA=towary.STAWKA
				 , dokumentm.NAZWA=towary.NAZWA
				 , dokumentm.INDEKS=towary.INDEKS
				 , dokumentm.PKWIU=towary.PKWIU
				 , dokumentm.JM=towary.JM
				 , dokumentm.NETTO=round(dokumentm.ILOSC*dokumentm.CENA,2)
				 , dokumentm.VAT=round(round(dokumentm.ILOSC*dokumentm.CENA,2)*towary.STAWKA*0.01,2)
				 , dokumentm.BRUTTO=round(dokumentm.ILOSC*dokumentm.CENA,2)+round(round(dokumentm.ILOSC*dokumentm.CENA,2)*towary.STAWKA*0.01,2)
			 where dokumentm.LOT<>0
		");
		if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

		$w=mysqli_query($link,$q="
			update dokumentm
			   set dokumentm.LOT=''
		");
		if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
	}
	
	if($_POST['KNORDPOL'])
	{
		//inne stawki
		$w=mysqli_query($link,$q="
			update dokumentr
			   set STAWKA=concat(round((VAT/NETTO)*100,0),'%')
			 where STAWKA<>'zw.'
		");
	/*		 where 1*STAWKA=22
				or 1*STAWKA=7
				or 1*STAWKA=3
	*/
		if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

		$w=mysqli_query($link,$q="
			update dokumentr
			   set STAWKA='23%'
			 where STAWKA not IN ('23%','8%','5%','2%','zw.','0%')
		");
		if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
	}
}

$title="Import plików DBF: raport";
$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"../Menu");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

echo "<table width='100%' height='100%'>";
echo "<tr>";
echo "<td width='33%'></td>";
echo "<td>";

if($cosJest)
{
	echo "<h1>Raport importu danych:</h1>";

	echo "<table>";
	foreach($pliki as $skrot => $opis)
	{
		echo '<tr>';
		echo '<td align="right">'.$wyniki[$skrot].'</td><td align="left"> : '.$opis." ($skrot)".'</td>';
		echo '</tr>';
	}
	echo "<table>";
}
else
{
	echo "<h1>Brak wskazanych plików w podanej lokalizacji...</h1>";
}

echo '<hr>';

echo $czas.' czas rozpoczêcia';
echo '<br>';
echo date('Y-m-d H:i:s').' czas zakoñczenia';

echo "</td>";
echo "<td width='33%'></td>";
echo "</tr></table>";

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");