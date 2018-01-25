<?php

//die(print_r($_POST));

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$_POST['KTO']=$_SESSION['osoba_id'];
$_POST['CZAS']=date('Y-m-d H:i:s');
$_POST['GDZIE']='bufor';
$_POST['DWPLYWU']=date('Y-m-d');
$_POST['DWPROWADZE']=date('Y-m-d');

$idd=$_SESSION["{$baza}DokumentyID_D"];

if (!@$_POST['LP'])
{
	$w=mysqli_query($link, $q="select LP+1 from dokumenty where '$_POST[TYP]' like concat(TYP,'%') order by ID desc limit 1"); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
	$_POST['LP']=(($r=mysqli_fetch_row($w))?$r[0]:'1');
}

if (!@$_POST['ADRES'])
{
	if($_POST['NAZWA'])
	{
		$w=mysqli_query($link, $q="select * from knordpol where NIP='$_POST[NIP]' and NAZWA='$_POST[NAZWA]' order by ID desc limit 1"); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
		if($r=mysqli_fetch_array($w))
		{
			$_POST['NRKONT']=$r['NUMER'];
			$_POST['PSKONT']=$r['PSEUDO'];
			$_POST['ADRES']=$r['KOD_POCZT'].' '.$r['MIASTO'].', '.$r['ULICA'];
		}
	}
	else
	{
		$_POST['NRKONT']='';
		$_POST['PSKONT']='';
		$_POST['ADRES']='';
	}
}

if (!@$_POST['ADDINFO'])
{
	if($_POST['PAYMENT'])
	{
		$w=mysqli_query($link, $q="select * from knordpol where NIP='$_POST[DELIVERY]' and NAZWA='$_POST[PAYMENT]' order by ID desc limit 1"); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
		if($r=mysqli_fetch_array($w))
		{
			$_POST['HCCODE']=$r['NUMER'];
	//		$_POST['PSKONT']=$r['PSEUDO'];
			$_POST['ADDINFO']=$r['KOD_POCZT'].' '.$r['MIASTO'].', '.$r['ULICA'];
		}
	}
	else
	{
		$_POST['HCCODE']='';
		$_POST['ADDINFO']='';
	}
}

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveFormFields.php");

$nowyDokument=false;
if ($idd==0)
{
	$nowyDokument=true;
	$idd=mysqli_insert_id($link);
	$_SESSION["{$baza}DokumentyID_D"]=$idd;
	mysqli_query($link, $q="update dokumentk set ID_D='$idd' where ID_D=-1 and KTO='$ido'");if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
	mysqli_query($link, $q="update dokumentm set ID_D='$idd' where ID_D=-1 and KTO='$ido'");if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
	mysqli_query($link, $q="update dokumentr set ID_D='$idd' where ID_D=-1 and KTO='$ido'");if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
	mysqli_query($link, $q="update kpr       set ID_D='$idd' where ID_D=-1 and KTO='$ido'");if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
	mysqli_query($link, $q="update ewidsprz  set ID_D='$idd' where ID_D=-1 and KTO='$ido'");if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
	mysqli_query($link, $q="update ewidprzeb set ID_D='$idd' where ID_D=-1 and KTO='$ido'");if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
}

mysqli_query($link, $q="
	update kpr
 left join dokumenty 
		on dokumenty.ID=kpr.ID_D
	   set kpr.DATA=DOPERACJI
		 , kpr.NRDOW=dokumenty.NUMER
		 , kpr.NRKONT=dokumenty.NRKONT
		 , kpr.PSKONT=dokumenty.PSKONT
		 , kpr.NIP=dokumenty.NIP
		 , kpr.NAZWA=dokumenty.NAZWA
		 , kpr.ADRES=dokumenty.ADRES
		 , kpr.OPIS=dokumenty.PRZEDMIOT
	 where kpr.ID_D=$idd
");
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

mysqli_query($link, $q="
	update ewidsprz
 left join dokumenty 
		on dokumenty.ID=ewidsprz.ID_D
	   set ewidsprz.DATAW=DOPERACJI
		 , ewidsprz.DATA=DDOKUMENTU
		 , ewidsprz.NRDOW=dokumenty.NUMER
		 , ewidsprz.NRKONT=dokumenty.NRKONT
		 , ewidsprz.PSKONT=dokumenty.PSKONT
		 , ewidsprz.NIP=dokumenty.NIP
		 , ewidsprz.NAZWA=dokumenty.NAZWA
		 , ewidsprz.ADRES=dokumenty.ADRES
		 , ewidsprz.OPIS=dokumenty.PRZEDMIOT
	 where ewidsprz.ID_D=$idd
");
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

if ($idd)
{
	$typ=mysqli_fetch_row(mysqli_query($link, $q="select TYP from dokumentr where ID_D=$idd order by ID limit 1"))[0];
	$brutto=mysqli_fetch_row(mysqli_query($link, $q="select sum(BRUTTO) from dokumentr where ID_D=$idd and TYP='$typ'"))[0];
	$netto =mysqli_fetch_row(mysqli_query($link, $q="select sum(NETTO) from dokumentr where ID_D=$idd and TYP='$typ'"))[0];
	$vat   =mysqli_fetch_row(mysqli_query($link, $q="select sum(VAT) from dokumentr where ID_D=$idd and TYP='$typ'"))[0];

	if($brutto!=0)
	{
		mysqli_query($link, $q="update dokumenty set WARTOSC='$brutto', NETTOVAT='$netto', PODATEK_VAT='$vat', KTO='$ido', CZAS=Now() where ID=$idd");
		if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
	}
	else
	{
		$od_netto=$_SESSION['od_netto'];
		require("{$_SERVER['DOCUMENT_ROOT']}/Filutek/Towary/przelicz.php");
	}
	
	$dtop=mysqli_fetch_row(mysqli_query($link, $q="select DOPERACJI from dokumenty where ID=$idd"))[0];
	mysqli_query($link, $q="update dokumentr set OKRES='$dtop', KTO='$ido', CZAS=Now() where ID_D=$idd");if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

	if($_POST['WPLACONO']*1>0)
	{
		$kp=mysqli_fetch_row(mysqli_query($link, $q="select DODOK from dokumenty where ID=$idd"))[0];
		if(!$kp)
		{
			$kp=mysqli_fetch_row(mysqli_query($link, $q="select DODOK from dokumenty where ID<$idd and TYP='FV' and DODOK<>'' order by ID desc limit 1"))[0];
			if(substr($kp,-2,2)<>date('y'))
			{
				$kp='0001'.'-'.date('y');
			}
			else
			{
				$kp=substr('000'.($kp+1),-4,4).'-'.date('y');
			}
			mysqli_query($link, $q="update dokumenty set DODOK='$kp', SPOSZAPL='Gotówka', DTERMIN=DDOKUMENTU, KTO='$ido', CZAS=Now() where ID=$idd");if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
		}
	}
	else
	{
		mysqli_query($link, $q="update dokumenty set DODOK='', SPOSZAPL='Przelew', DTERMIN=if(DTERMIN*1=0,Date_Add(DDOKUMENTU,interval 7 day),DTERMIN), KTO='$ido', CZAS=Now() where ID=$idd");if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
	}
	
	if($nowyDokument)
	{
		require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/SetStrRow.php");
		SetStrRow($link, $idd);
	}
}
