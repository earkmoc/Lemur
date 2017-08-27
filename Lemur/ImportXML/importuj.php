<?php

ini_set('max_execution_time', 600);
error_reporting(E_ERROR | E_PARSE);

$dzis=date('Y-m-d');
$czas=date('Y-m-d H:i:s');

$pliki=array(
	 'kl'=>''
	,'fz'=>'ZT,RZT'
	,'fv'=>'ST,RST'
	,'fk'=>'STK,RSTK'
	,'fe'=>'SE,RSE'
	,'wb_bgz'=>'WB,'
	,'wb_pko'=>'WB,'
);

$cosJest=false;
foreach($pliki as $skrot => $opis)
{
	if ($_POST[$skrot]&&$_POST['path'])
	{
		$file=$_POST['path'].'\\'.$_POST[$skrot];
		if(file_exists($file))
		{
			$cosJest=true;
		}
	}
}

if($cosJest)
{

	require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

	//mysqli_query($link,$q="update slownik set SYMBOL='FEX' where typ='dokumenty' and SYMBOL='WEX'");
	//mysqli_query($link,$q="truncate dokumenty");
	//mysqli_query($link,$q="truncate dokumentr");
	//mysqli_query($link,$q="delete from knordpol where KONTO='' or (KONTO like '2%')");

	$wyniki=array('dubli'=>0);

	/*
	//last numbers
	$w=mysqli_query($link,$q="
		select NUMER, upper(replace(replace(replace(NAZWA,'`',''),'£','L'),'³','l'))
		  from knordpol
		 where NUMER IN (3559,6726)
	");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
	while($r=mysqli_fetch_row($w)) {$lastNumbers[$r[0]]=$r[1];}
	print_r($lastNumbers);die;
	*/

	$w=mysqli_query($link,$q="
		select TYP, MAX(LP*1)
		  from dokumenty
		 where TYP IN ('ZT','ST','STK','SE')
	  group by TYP
	");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
	while($r=mysqli_fetch_row($w)) {$lastNumbers[$r[0]]=$r[1];}

	foreach($pliki as $skrot => $opis)
	{
		$typ=explode(',',$opis)[0];
		$rej=explode(',',$opis)[1];

		if ($_POST[$skrot]&&$_POST['path'])
		{
			$wyniki[$skrot]=0;
			
			$file=$_POST['path'].'\\'.$_POST[$skrot];
			$xml = simplexml_load_file($file);
			foreach($xml->children() as $zapis)
			{
				foreach($zapis as $key=>$value)
				{
					$zapis[$key]=iconv('utf-8','iso-8859-2',$value);
					$zapis[$key]=str_replace("'","`",$zapis[$key]);
					$zapis[$key]=AddSlashes($zapis[$key]);
				}
				
				switch(true)
				{
					case (	  (in_array($skrot,array('fv','fk','fe')))
							&&($zapis->attributes()['co']=='faktury')
						 ):

						$okres=substr($zapis['DSp'],0,4).'-'.substr($zapis['DSp'],4,2);

						$lp=++$lastNumbers[$typ];

						mysqli_query($link,$q="
							insert 
							  into dokumenty
							   set NUMER='$zapis[NrR]'
								 , DDOKUMENTU='$zapis[DWy]'
								 , DOPERACJI='$zapis[DSp]'
								 , DWYSTAWIENIA='$zapis[DWy]'
								 , DSPRZEDAZY='$zapis[DSp]'
								 , SPOSZAPL='$zapis[Fp]'
								 , DTERMIN='$zapis[Tpl]'
								 , WARTOSC='$zapis[Wart]'
								 , PODATEK_VAT='$zapis[V2]'
								 , NETTOVAT='$zapis[N2]'
								 , NETTOPD='$zapis[N2]'
								 , WPLACONO='$zapis[Zap]'
								 , PSKONT='$zapis[Alias]'
								 , NIP='$zapis[NIP]'
								 , NAZWA='$zapis[Nazw]'
								 , ADRES=concat('$zapis[Kodp]',' ','$zapis[Mias]',', ','$zapis[Ulic]')
								 , TYP='$typ'
								 , LP='$lp'
								 , KTO='$ido'
								 , GDZIE='bufor'
								 , DWPLYWU='$dzis'
								 , DWPROWADZE='$dzis'
								 , CZAS='$czas'
						");
						if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

						++$wyniki[$skrot];

						$id_d=mysqli_insert_id($link);

						if($zapis['N0']*1>0)
						{
							mysqli_query($link, $q="
							insert 
							  into dokumentr 
							   set ID_D='$id_d'
								 , KTO='$ido'
								 , CZAS='$czas'
								 , TYP='$rej'
								 , NETTO='$zapis[N0]'
								 , STAWKA='0%e'
								 , VAT='$zapis[V0]'
								 , BRUTTO='$zapis[Wart]'
								 , OKRES='$okres'
							");if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
						} else {
							mysqli_query($link, $q="
							insert 
							  into dokumentr 
							   set ID_D='$id_d'
								 , KTO='$ido'
								 , CZAS='$czas'
								 , TYP='$rej'
								 , NETTO='$zapis[N2]'
								 , STAWKA='23%'
								 , VAT='$zapis[V2]'
								 , BRUTTO='$zapis[Wart]'
								 , OKRES='$okres'
							");if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
						}
						break;

					case (	  (in_array($skrot,array('fz')))
							&&($zapis->attributes()['co']=='zakupy')
						 ):

						$okres=substr($zapis['Dfa'],0,4).'-'.substr($zapis['Dfa'],4,2);
						$lp=++$lastNumbers[$typ];

						$w=mysqli_query($link,$q="
							select ID
							  from dokumenty
							 where NUMER='$zapis[Fak]'
							   and NIP='$zapis[NIP]'
							   and TYP='$typ'
						");
						if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

						if(	  ($r=mysqli_fetch_row($w))
							&&($id_d=$r[0])
						  )
						{
							mysqli_query($link,$q="
							update dokumenty
							   set WARTOSC=WARTOSC+'$zapis[Wart]'
								 , PODATEK_VAT=PODATEK_VAT+'$zapis[V2]'
								 , NETTOVAT=NETTOVAT+'$zapis[N2]'
								 , NETTOPD=NETTOPD+'$zapis[N2]'
								 , WPLACONO=WPLACONO+'$zapis[Zap]'
								 , KTO='$ido'
								 , DWPLYWU='$dzis'
								 , DWPROWADZE='$dzis'
								 , CZAS='$czas'
							 where ID=$id_d
							");
							if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

							++$wyniki['dubli'];

						} else
						{
							mysqli_query($link,$q="
							insert 
							  into dokumenty
							   set NUMER='$zapis[Fak]'
								 , DDOKUMENTU='$zapis[DWy]'
								 , DOPERACJI='$zapis[Dfa]'
								 , DWYSTAWIENIA='$zapis[DWy]'
								 , DSPRZEDAZY='$zapis[Dfa]'
								 , SPOSZAPL='$zapis[Fp]'
								 , DTERMIN='$zapis[Tpl]'
								 , WARTOSC='$zapis[Wart]'
								 , PODATEK_VAT='$zapis[V2]'
								 , NETTOVAT='$zapis[N2]'
								 , NETTOPD='$zapis[N2]'
								 , WPLACONO='$zapis[Zap]'
								 , PSKONT='$zapis[Alias]'
								 , NIP='$zapis[NIP]'
								 , NAZWA='$zapis[Nazw]'
								 , ADRES=concat('$zapis[Kodp]',' ','$zapis[Mias]',', ','$zapis[Ulic]')
								 , TYP='$typ'
								 , LP='$lp'
								 , KTO='$ido'
								 , GDZIE='bufor'
								 , DWPLYWU='$dzis'
								 , DWPROWADZE='$dzis'
								 , CZAS='$czas'
							");
							if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

							++$wyniki[$skrot];

							$id_d=mysqli_insert_id($link);
						}

						mysqli_query($link, $q="
							insert 
							  into dokumentr 
							   set ID_D='$id_d'
								 , KTO='$ido'
								 , CZAS='$czas'
								 , TYP='$rej'
								 , NETTO='$zapis[N2]'
								 , STAWKA='23%'
								 , VAT='$zapis[V2]'
								 , BRUTTO='$zapis[Wart]'
								 , OKRES='$okres'
						");if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
						
						break;

					case (	  (in_array($skrot,array('kl')))
							&&($zapis->attributes()['co']=='klienci')
						 ):

						$zapis['Alias']=substr($zapis['Alias'],0,10);
						$zapis['Nazw']=substr($zapis['Nazw'],0,120);
						 
						$w=mysqli_query($link,$q="
							select ID
							  from knordpol
							 where replace(NIP,'-','')=replace('$zapis[NIP]','-','')
							   and replace(upper(PSEUDO),'`','')=replace(upper('$zapis[Alias]'),'`','')
							   and upper(replace(replace(replace(NAZWA,'`',''),'£','L'),'³','l'))=upper(replace(replace(replace('$zapis[Nazw]','`',''),'£','L'),'³','l'))
						");
						if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

						if(	  ($r=mysqli_fetch_row($w))
							&&($id_k=$r[0])
						  )
						{
							mysqli_query($link,$q="
							update knordpol
							   set KOD_POCZT='$zapis[kodP]'
								 , MIASTO='$zapis[Mias]'
								 , ULICA='$zapis[Ulic]'
							 where replace(NIP,'-','')=replace('$zapis[NIP]','-','')
							   and replace(upper(PSEUDO),'`','')=replace(upper('$zapis[Alias]'),'`','')
							   and upper(replace(replace(replace(NAZWA,'`',''),'£','L'),'³','l'))=upper(replace(replace(replace('$zapis[Nazw]','`',''),'£','L'),'³','l'))
							");
							if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
						} else
						{
							$nextNr=1;
							$w=mysqli_query($link,$q="
								select NUMER
								  from knordpol
								 where 1
							  order by NUMER*1 desc
								 limit 1
							");
							if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

							if(	  ($r=mysqli_fetch_row($w))
								&&($lastNr=$r[0])
							  )
							{
								$nextNr=$lastNr+1;
							}
							$konto='201-D12-'.$nextNr;
						
							mysqli_query($link,$q="
							insert 
							  into knordpol
							   set KONTO='$konto'
								 , TRESC='$zapis[Nazw]'
								 , NUMER='$nextNr'
								 , PSEUDO='$zapis[Alias]'
								 , NIP='$zapis[NIP]'
								 , NAZWA='$zapis[Nazw]'
								 , KOD_POCZT='$zapis[kodP]'
								 , MIASTO='$zapis[Mias]'
								 , ULICA='$zapis[Ulic]'
							");
							if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

							++$wyniki[$skrot];

						}

						break;
						
					case (	  (in_array($skrot,array('wb_bgz')))
						 ):

						die(print_r($zapis));

						break;

					case (	  (in_array($skrot,array('wb_pko')))
						 ):

						switch($zapis->getName())
						{
							case 'search':
								$kontoWB=$zapis->account;
								$dataWB=date("Y-m-t", strtotime($zapis->date['since']));
								$nrWB=substr($dataWB,5,2)*1;

								$kontoKsiegoweBank=mysqli_fetch_row(mysqli_query($link, $q="
									select KONTO
									  from knordpol
									 where (replace(replace(replace(NAZWA,'-',''),'PL',''),' ','') like '%$kontoWB%')
									   and KONTO like '13%'
									 limit 1
								"))[0];
								
								mysqli_query($link, $q="
									create temporary table temp_dokumentk like dokumentk
								");
								if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

								mysqli_query($link, $q="
									insert 
									  into dokumenty
									   set NUMER='WB Nr $nrWB'
										 , DDOKUMENTU='$dataWB'
										 , DOPERACJI='$dataWB'
										 , DWYSTAWIENIA='$dataWB'
										 , DSPRZEDAZY='$dataWB'
										 , DTERMIN='$dataWB'
										 , NAZWA='$kontoWB'
										 , TYP='WB'
										 , KTO='$ido'
										 , GDZIE='bufor'
										 , DWPLYWU='$dataWB'
										 , DWPROWADZE='$dataWB'
										 , CZAS='$czas'
								");
								if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

								$idWB=mysqli_insert_id($link);
								
								break;

							case 'operations':
								//$nr=0;
								foreach($zapis->children() as $operation)
								{
									$kwota=$operation->amount;
									$execDate='0000-00';
									foreach($operation as $key => $value)
									{
										if($key=='exec-date')
										{
											$execDate=$value;
										}
									}

									if(substr($execDate,0,7)!=substr($dataWB,0,7))	//nie ten miesi±c
									{
											continue;
									}
										
									++$wyniki[$skrot];

									//++$nr;
									//echo "<hr>Operation Nr $nr";

									foreach($operation as $key => $value)
									{
										$value=iconv('utf-8','iso-8859-2',$value);
										$value=str_replace("'","`",$value);
										$value=AddSlashes($value);

										$rachunek='';
										$nazwa='';
										$adres='';
										$tytul='';
										$symbolFormularza='';
										$okresPlatnosci='';
										
										if($key=='description')
										{
											//echo "<br>$key:";
											$linie=explode("\n",$value);		//ciêcie description na linie

											foreach($linie as $linia)
											{
												$slowo=explode(' ',explode(':',$linia)[0])[0];	//pierwsze s³owo w linii z dwukropkiem lub spacjami
												$wartosc=addSlashes(trim(substr($linia,strpos($linia,':')+1)));
												switch($slowo)
												{
													case 'Rachunek': 	$rachunek=$wartosc; break;
													case 'Nazwa': 		$nazwa=$wartosc; break;
													case 'Adres': 		$adres=$wartosc; break;
													case 'Tytu³': 		$tytul=$wartosc; break;
													case 'Symbol': 		$symbolFormularza=$wartosc; break;
													case 'Okres': 		$okresPlatnosci=$wartosc; break;
												}
											}

											switch(iconv('utf-8','iso-8859-2',$operation->type))
											{
												case 'Przelew na rachunek':
													mysqli_query($link, $q="
														insert 
														  into temp_dokumentk
														   set ID_D='$idWB'
															 , KTO='$ido'
															 , CZAS='$czas'
															 , PRZEDMIOT='Zap³ata za Fa: $tytul'
															 , WINIEN='$kwota'
															 , KONTOWN='$kontoKsiegoweBank'
															 , KONTOMA='$nazwa'
													");
													if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

													break;
													
												case 'Przelew z rachunku':
													mysqli_query($link, $q="
														insert 
														  into temp_dokumentk
														   set ID_D='$idWB'
															 , KTO='$ido'
															 , CZAS='$czas'
															 , PRZEDMIOT='$tytul'
															 , WINIEN='$kwota'*-1
															 , KONTOWN='$nazwa'
															 , KONTOMA='$kontoKsiegoweBank'
													");
													if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

													break;
													
												case 'Przelew podatkowy':
													mysqli_query($link, $q="
														insert 
														  into temp_dokumentk
														   set ID_D='$idWB'
															 , KTO='$ido'
															 , CZAS='$czas'
															 , PRZEDMIOT='$symbolFormularza $okresPlatnosci $tytul'
															 , WINIEN='$kwota'*-1
															 , KONTOWN='221'
															 , KONTOMA='$kontoKsiegoweBank'
													");
													if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

													break;
													
												case 'Op³ata za u¿ytkowanie karty':
												case 'Obci±¿enie':
													$tytul.=($tytul!=''?' - ':'');
													mysqli_query($link, $q="
														insert 
														  into temp_dokumentk
														   set ID_D='$idWB'
															 , KTO='$ido'
															 , CZAS='$czas'
															 , PRZEDMIOT='{$tytul}zakup us³ug brutto'
															 , WINIEN='$kwota'*-1
															 , KONTOWN='402'
															 , KONTOMA='302'
													");
													if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

													mysqli_query($link, $q="
														insert 
														  into temp_dokumentk
														   set ID_D='$idWB'
															 , KTO='$ido'
															 , CZAS='$czas'
															 , PRZEDMIOT='{$tytul}zakup us³ug netto'
															 , WINIEN='$kwota'*-1
															 , KONTOWN='302'
															 , KONTOMA='$kontoKsiegoweBank'
													");
													if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

													mysqli_query($link, $q="
														insert 
														  into temp_dokumentk
														   set ID_D='$idWB'
															 , KTO='$ido'
															 , CZAS='$czas'
															 , PRZEDMIOT='przeksiêgowanie kosztów'
															 , WINIEN='$kwota'*-1
															 , KONTOWN='502'
															 , KONTOMA='490'
													");
													if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

													break;
													
												default:
													foreach($linie as $linia => $tresc)
													{
														echo "<br>_____$linia ___ $tresc";
													}
													die;
											}
										}
										else
										{
											//echo "<br>$key: ".iconv('utf-8','iso-8859-2',$value);
										}
									}
								}

								require_once("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/funkcje.php");
								$pola=FieldsOd($link, 'dokumentk', 1);
								mysqli_query($link, $q="
									insert into dokumentk select 0, $pola from temp_dokumentk order by ID desc
								");
								if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

								break;
						}

						break;
				}
			}
		}
	}

	//update dokumenty.NRKONT
	$w=mysqli_query($link,$q="
		update dokumenty
	 left join knordpol
			on replace(knordpol.NIP,'-','')=replace(dokumenty.NIP,'-','')
		   and replace(upper(knordpol.PSEUDO),'`','')=replace(upper(dokumenty.PSKONT),'`','')
		   and upper(replace(replace(replace(knordpol.NAZWA,'`',''),'£','L'),'³','l'))=upper(replace(replace(replace(dokumenty.NAZWA,'`',''),'£','L'),'³','l'))
		   set dokumenty.NRKONT=knordpol.NUMER
		 where dokumenty.NRKONT=0
	");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
}

$title="Import plików XML: raport";
$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"../Menu");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

echo "<table width='100%' height='100%'>";
echo "<tr>";
echo "<td width='33%'></td>";
echo "<td>";

if($cosJest)
{
	$pliki=array(
		 'kl'=>'klientów'
		,'fz'=>'faktur zakupu towarów'
		,'fv'=>'faktur sprzeda¿y VAT'
		,'fk'=>'faktur koryguj±cych sprzeda¿'
		,'fe'=>'faktur exportowych'
		,'wb_bgz'=>'WB BG¯'
		,'wb_pko'=>'WB PKO'
		,'dubli'=>'dubli faktur zakupu dosumowanych do wcze¶niejszych dokumentów'
	);

	echo "<h1>Raport importu danych:</h1>";

	foreach($pliki as $skrot => $opis)
	{
		echo '<div class="form-group">';
		echo $wyniki[$skrot].' '.$opis;
		echo '</div>';
	}
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