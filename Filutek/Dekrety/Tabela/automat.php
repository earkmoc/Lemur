<?php

error_reporting(E_ERROR | E_PARSE | E_WARNING);//E_NOTICE | 

//automatyczne ksiêgowanie na podstawie schematu ksiêgowania

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$idd=$_GET[idd];
$idd=($idd==0?-1:$idd);

//die(print_r($_GET));

$_GET['nrKont']=mysqli_fetch_row(mysqli_query($link, $q="select NUMER from knordpol where NIP='$_GET[NIP]' and NAZWA like '%$_GET[NAZWA]%' order by ID desc limit 1"))[0];

if(substr($_GET['typ'],0,2)=='LP')	//Listy p³ac
{
	$idListy=mysqli_fetch_row(mysqli_query($link,$q="
		select ID from listyplac where NUMER='$_GET[numer]' order by ID desc limit 1
	"))[0];

	$pozycjeListy=mysqli_query($link,$q="
		select *
		  from listyplacp
		 where ID_D='$idListy'
	  order by ID
	");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

	$pracownicy=mysqli_query($link,$q="
		select *
		  from pracownicy
		 where 1
	  order by ID
	");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
	while($pracownik=mysqli_fetch_array($pracownicy))
	{
		if(	mysqli_fetch_row(mysqli_query($link,$q="
				select count(*) from knordpol where KONTO='231-$pracownik[ID]'
			"))[0]==0
		)
		{
			mysqli_query($link,$q="
				insert
				  into knordpol
				   set KONTO='231-$pracownik[ID]'
					 , TRESC='$pracownik[NAZWISKOIMIE]'
					 , NAZWA='$pracownik[NAZWISKOIMIE]'
					 , NUMER='$pracownik[ID]'
			");
		}
		if(	mysqli_fetch_row(mysqli_query($link,$q="
				select count(*) from knordpol where KONTO='241-$pracownik[ID]'
			"))[0]==0
		)
		{
			mysqli_query($link,$q="
				insert
				  into knordpol
				   set KONTO='241-$pracownik[ID]'
					 , TRESC='$pracownik[NAZWISKOIMIE]'
					 , NAZWA='$pracownik[NAZWISKOIMIE]'
					 , NUMER='$pracownik[ID]'
			");
		}
	}

	$kolumny=array();
	$kolumnyPozycjiListy=mysqli_query($link,$q="
		show fields from listyplacp
	"); 
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
	while($kolumnaPozycjiListy=mysqli_fetch_array($kolumnyPozycjiListy))
	{
		$kolumny[]=$kolumnaPozycjiListy[0];
	}
	//die(print_r($kolumny));

	function cmp($a, $b)
	{
		$a=strlen($a);
		$b=strlen($b);
		if ($a == $b) {
			return 0;
		}
		return ($a > $b) ? -1 : 1;
	}

	usort($kolumny, "cmp");
	//die(print_r($kolumny));

	//usuniecie dotychczasowych dekretow
	mysqli_query($link,$q="
		delete
		  from dokumentk
		 where ID_D='$idd'
		   and if(1*'$idd'=-1,KTO='$ido',1)
	"); 
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

	while($pozycjaListy=mysqli_fetch_array($pozycjeListy))
	{
		$pozycjeSchematu=mysqli_query($link,$q="
			select schematys.*
			  from schematys
		 left join schematy
				on schematy.ID=schematys.ID_D
			 where schematy.TYP='LP'
		  order by schematys.LP
		");
		if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

		while($pozycjaSchematu=mysqli_fetch_array($pozycjeSchematu))
		{
			//print_r($pozycjaSchematu);die;

			$kwota=$pozycjaSchematu['KWOTAS'];

			foreach($kolumny as $key => $value)
			{
				$kwota=str_replace($value,$pozycjaListy[$value],$kwota);
			}

			$pozycjaSchematu['KONTOWN']=str_replace('x',$pozycjaListy['ID_P'],$pozycjaSchematu['KONTOWN']);
			$pozycjaSchematu['KONTOMA']=str_replace('x',$pozycjaListy['ID_P'],$pozycjaSchematu['KONTOMA']);

			mysqli_query($link,$q="
				insert
				  into dokumentk
				   set ID_D='$idd'
					 , KTO='$ido'
					 , CZAS=Now()
					 , PRZEDMIOT='$pozycjaSchematu[OPIS]'
					 , WINIEN=$kwota
					 , MA=0
					 , KONTOWN='$pozycjaSchematu[KONTOWN]'
					 , KONTOMA='$pozycjaSchematu[KONTOMA]'
			");
			if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
		}
	}
}
elseif(substr($_GET['typ'],0,3)=='STR')
{
	//¦rodki Trwa³e
	
	$srodki=mysqli_query($link,$q="
		select *
		  from srodkitr
		 where 1
	  order by ID
	");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

	while($srodek=mysqli_fetch_array($srodki))
	{
		if(	mysqli_fetch_row(mysqli_query($link,$q="
				select count(*) from knordpol where KONTO='065-$srodek[ID]'
			"))[0]==0
		)
		{
			mysqli_query($link,$q="
				insert
				  into knordpol
				   set KONTO='065-$srodek[ID]'
					 , TRESC='$srodek[NAZWASR]'
					 , NAZWA='$srodek[NAZWASR]'
					 , NUMER='$srodek[ID]'
			");
		}
	}

	$pozycjeListy=mysqli_query($link,$q="
		select *
		  from srodkihi
		 where left(DATA,7)=left('$_GET[doperacji]',7)
	"); 
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

	$kolumny=array();
	$kolumnyPozycjiListy=mysqli_query($link,$q="
		show fields from srodkihi
	"); 
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
	while($kolumnaPozycjiListy=mysqli_fetch_array($kolumnyPozycjiListy))
	{
		$kolumny[]=$kolumnaPozycjiListy[0];
	}
	//die(print_r($kolumny));

	//usuniecie dotychczasowych dekretow
	mysqli_query($link,$q="
		delete
		  from dokumentk
		 where ID_D='$idd'
		   and if(1*'$idd'=-1,KTO='$ido',1)
	"); 
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

	while($pozycjaListy=mysqli_fetch_array($pozycjeListy))
	{
		//die(print_r($pozycjaListy));
		$pozycjeSchematu=mysqli_query($link,$q="
			select schematys.*
			  from schematys
		 left join schematy
				on schematy.ID=schematys.ID_D
			 where schematy.TYP='STR'
		  order by schematys.LP
		");
		if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

		while($pozycjaSchematu=mysqli_fetch_array($pozycjeSchematu))
		{
			//print_r($pozycjaSchematu);die;

			$kwota=$pozycjaSchematu['KWOTAS'];

			foreach($kolumny as $key => $value)
			{
				$kwota=str_replace($value,$pozycjaListy[$value],$kwota);
			}

			$pozycjaSchematu['KONTOWN']=str_replace('x',$pozycjaListy['ID_D'],$pozycjaSchematu['KONTOWN']);
			$pozycjaSchematu['KONTOMA']=str_replace('x',$pozycjaListy['ID_D'],$pozycjaSchematu['KONTOMA']);

			mysqli_query($link,$q="
				insert
				  into dokumentk
				   set ID_D='$idd'
					 , KTO='$ido'
					 , CZAS=Now()
					 , PRZEDMIOT='$pozycjaSchematu[OPIS]'
					 , WINIEN=$kwota
					 , MA=0
					 , KONTOWN='$pozycjaSchematu[KONTOWN]'
					 , KONTOMA='$pozycjaSchematu[KONTOMA]'
			");
			if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
		}
	}
}
elseif(substr($_GET['typ'],0,2)=='KP')
{
	//usuniecie dotychczasowych dekretow
	mysqli_query($link,$q="
		delete
		  from dokumentk
		 where ID_D='$idd'
		   and if(1*'$idd'=-1,KTO='$ido',1)
	"); 
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

	$pozycjeSchematu=mysqli_query($link,$q="
		select schematys.*
		  from schematys
	 left join schematy
			on schematy.ID=schematys.ID_D
		 where schematy.TYP='KP'
		  order by schematys.LP
	");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

	while($pozycjaSchematu=mysqli_fetch_array($pozycjeSchematu))
	{
		$kwota=$pozycjaSchematu['KWOTAS'];
		$_GET['wplacono']=(!$_GET['wplacono']?'0':$_GET['wplacono']);
		$kwota=str_replace('gotówka',str_replace(',','.',$_GET['wplacono']),$kwota);
		$pozycjaSchematu['KONTOWN']=str_replace('x',$_GET['nrKont'],$pozycjaSchematu['KONTOWN']);
		$pozycjaSchematu['KONTOMA']=str_replace('x',$_GET['nrKont'],$pozycjaSchematu['KONTOMA']);
		$pozycjaSchematu['OPIS']=str_replace('przedmiot',$_GET['przedmiot'],$pozycjaSchematu['OPIS']);
		
		mysqli_query($link,$q="
			insert
			  into dokumentk
			   set ID_D='$idd'
				 , KTO='$ido'
				 , CZAS=Now()
				 , PRZEDMIOT='$pozycjaSchematu[OPIS]'
				 , WINIEN=$kwota
				 , MA=0
				 , KONTOWN='$pozycjaSchematu[KONTOWN]'
				 , KONTOMA='$pozycjaSchematu[KONTOMA]'
		");
		if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
	}
}
else
{
	//Rejestry VAT
	$pozycjeRejestru=mysqli_query($link,$q="
		select *
		  from dokumentr
		 where ID_D='$idd'
		   and if(1*'$idd'=-1,KTO='$ido',1)
	"); 
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

	//usuniecie dotychczasowych dekretow
	mysqli_query($link,$q="
		delete
		  from dokumentk
		 where ID_D='$idd'
		   and if(1*'$idd'=-1,KTO='$ido',1)
	"); 
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

	$ileRazyDekretWplaty=0;
	while($pozycjaListy=mysqli_fetch_array($pozycjeRejestru))
	{
		$pozycjeSchematu=mysqli_query($link,$q="
			select schematys.*
			  from schematys
		 left join schematy
				on schematy.ID=schematys.ID_D
			 where schematy.REJESTR='$pozycjaListy[TYP]'
		  order by schematys.LP
		");
		if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

		while($pozycjaSchematu=mysqli_fetch_array($pozycjeSchematu))
		{
			//print_r($pozycjaSchematu);die;

			$kwota=$pozycjaSchematu['KWOTAS'];

			$kwota=str_replace('brutto',$pozycjaListy['BRUTTO'],$kwota);
			$kwota=str_replace('netto',$pozycjaListy['NETTO'],$kwota);
			$kwota=str_replace('vat',$pozycjaListy['VAT'],$kwota);

			$_GET['wplacono']=(!$_GET['wplacono']?'0':$_GET['wplacono']);
			$pozycjaListy['GOTOWKA']=str_replace(',','.',$_GET['wplacono']);
			$pozycjaListy['PRZELEW']='0';
			if($kwota<>str_replace('gotówka',$pozycjaListy['GOTOWKA'],$kwota))
			{
				++$ileRazyDekretWplaty;
			}
			if($ileRazyDekretWplaty>1)
			{
				$pozycjaListy['GOTOWKA']=0;
			}
			
			$kwota=str_replace('gotówka',$pozycjaListy['GOTOWKA'],$kwota);
			$kwota=str_replace('przelew',$pozycjaListy['PRZELEW'],$kwota);

			$pozycjaSchematu['KONTOWN']=str_replace('x',$_GET['nrKont'],$pozycjaSchematu['KONTOWN']);
			$pozycjaSchematu['KONTOMA']=str_replace('x',$_GET['nrKont'],$pozycjaSchematu['KONTOMA']);

			mysqli_query($link,$q="
				insert
				  into dokumentk
				   set ID_D='$idd'
					 , KTO='$ido'
					 , CZAS=Now()
					 , PRZEDMIOT='$pozycjaSchematu[OPIS]'
					 , WINIEN=$kwota
					 , MA=0
					 , KONTOWN='$pozycjaSchematu[KONTOWN]'
					 , KONTOMA='$pozycjaSchematu[KONTOMA]'
			");
			if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
		}
	}
}

//usuniecie zerowych dekretow
mysqli_query($link,$q="
	delete
	  from dokumentk
	 where ID_D='$idd'
	   and if(1*'$idd'=-1,KTO='$ido',1)
	   and WINIEN=0
"); 
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

header('location:..');
