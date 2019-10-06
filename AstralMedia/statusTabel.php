<?php

//$tabela=$_GET['tabela'];

require('dbconnect.php');

$tabela='kpr';

echo '<hr>masowe testowanie "kpr.DATA"<br>';

$klienci=mysqli_query($link,"select * from Lemur.klienci order by PSKONT");
while($klient=mysqli_fetch_array($klienci))
{
	$ile=mysqli_fetch_row(mysqli_query($link,"
				select count(*) 
				  from $klient[PSKONT].$tabela 
				 where DATA*1=0
		"))[0];
	echo "$klient[PSKONT].$tabela=$ile".($ile>0?' <----------------- ':'')."<br>";
}

echo '<hr>masowe testowanie "kpr.ADRES"<br>';

$klienci=mysqli_query($link,"select * from Lemur.klienci order by PSKONT");
while($klient=mysqli_fetch_array($klienci))
{
	$ile=mysqli_fetch_row(mysqli_query($link,"
				select count(*) 
				  from $klient[PSKONT].$tabela 
				 where ADRES=''
		"))[0];
	echo "$klient[PSKONT].$tabela=$ile".($ile>0?' <----------------- ':'')."<br>";
}

echo '<hr>masowe testowanie rejestrów: zapisy bez po³±czenia z dokumentem"<br>';

$tabela='dokumentr';

$klienci=mysqli_query($link,"select * from Lemur.klienci order by PSKONT");
while($klient=mysqli_fetch_array($klienci))
{
	$ile=mysqli_fetch_row(mysqli_query($link,"
				select count(*) 
				  from $klient[PSKONT].$tabela 
			 left join $klient[PSKONT].dokumenty 
					on $klient[PSKONT].dokumenty.ID=$klient[PSKONT].$tabela.ID_D 
				 where isnull($klient[PSKONT].dokumenty.ID)
		"))[0];
	echo "$klient[PSKONT].$tabela=$ile".($ile>0?' <----------------- ':'')."<br>";
	if($ile>0)
	{
		$r=mysqli_fetch_array(mysqli_query($link,$q="
				select *
				  from $klient[PSKONT].$tabela 
			 left join $klient[PSKONT].dokumenty 
					on $klient[PSKONT].dokumenty.ID=$klient[PSKONT].$tabela.ID_D 
				 where isnull($klient[PSKONT].dokumenty.ID)
		"));
		if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
		print_r($r);
	}
}

echo '<hr>masowe testowanie "dekretów: zapisy z und"<br>';
$slowo='undefi';
$tabela='dokumentk';

$klienci=mysqli_query($link,"select * from Lemur.klienci order by PSKONT");
while($klient=mysqli_fetch_array($klienci))
{
	$ile=mysqli_fetch_row(mysqli_query($link,"
				select count(*) 
				  from $klient[PSKONT].$tabela 
				 where $klient[PSKONT].dokumentk.KONTOWN like '%un%'
				    or $klient[PSKONT].dokumentk.KONTOMA like '%un%'
		"))[0];
	echo "$klient[PSKONT].$tabela=$ile".($ile>0?' <----------------- ':'')."<br>";
	if($ile>0)
	{
		mysqli_query($link,$q="
				update $klient[PSKONT].$tabela 
			 left join $klient[PSKONT].dokumenty 
					on $klient[PSKONT].dokumenty.ID=$klient[PSKONT].$tabela.ID_D 
				   set $klient[PSKONT].$tabela.KONTOWN=replace($klient[PSKONT].$tabela.KONTOWN,'$slowo',$klient[PSKONT].dokumenty.NRKONT)
				     , $klient[PSKONT].$tabela.KONTOMA=replace($klient[PSKONT].$tabela.KONTOMA,'$slowo',$klient[PSKONT].dokumenty.NRKONT)
				 where $klient[PSKONT].dokumentk.KONTOWN like '%$slowo%'
				    or $klient[PSKONT].dokumentk.KONTOMA like '%$slowo%'
		");
		if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
	}
}

echo '<hr>Duble w planie kont<br>';

$tabela='knordpol';

$klienci=mysqli_query($link,"select * from Lemur.klienci order by PSKONT");
while($klient=mysqli_fetch_array($klienci))
{
	$ile=mysqli_fetch_row(mysqli_query($link,"
				select count(*) 
				  from $klient[PSKONT].$tabela 
				 where KONTO<>''
			  group by KONTO
				having count(*)>1
		"))[0];
	echo "$klient[PSKONT].$tabela=$ile".($ile>0?' <----------------- ':'')."<br>";
	if($ile)
	{
		$w=mysqli_query($link,"
					select KONTO
					  from $klient[PSKONT].$tabela 
					 where KONTO<>''
				  group by KONTO
					having count(*)>1
			");
		while($r=mysqli_fetch_row($w))
		{
			echo "\t$r[0]<br>";
		}
	}
}
echo '<hr>Stawki -1 wmagazynie<br>';

$tabela='towary';

$klienci=mysqli_query($link,"select * from Lemur.klienci order by PSKONT");
while($klient=mysqli_fetch_array($klienci))
{
	$ile=mysqli_fetch_row(mysqli_query($link,"
				select count(*) 
				  from $klient[PSKONT].$tabela 
				 where STAWKA='-1%'
		"))[0];
	echo "$klient[PSKONT].$tabela=$ile".($ile>0?' <----------------- ':'')."<br>";
	if($ile)
	{
		mysqli_query($link,"
					update $klient[PSKONT].$tabela 
					   set STAWKA='zw.'
					 where STAWKA='-1%'
		");
	}
}
echo '<hr>masowa zmiana "srodkitr" na "SrodkiTr" w menu<br>';

$tabela='menu';

$klienci=mysqli_query($link,"select * from Lemur.klienci order by PSKONT");
while($klient=mysqli_fetch_array($klienci))
{
	$ile=mysqli_fetch_row(mysqli_query($link,"
				select count(*) 
				  from $klient[PSKONT].$tabela 
				 where SKROT='srodkitr'
		"))[0];
	echo "$klient[PSKONT].$tabela=$ile".($ile>0?' <----------------- ':'')."<br>";
	if($ile)
	{
		mysqli_query($link,"
					update $klient[PSKONT].$tabela 
					   set SKROT='SrodkiTr'
					 where SKROT='srodkitr'
		");
	}
}
echo '<hr>masowa zmiana "ewidsprz" na "EwidSprz" w menu<br>';

$tabela='menu';

$klienci=mysqli_query($link,"select * from Lemur.klienci order by PSKONT");
while($klient=mysqli_fetch_array($klienci))
{
	$ile=mysqli_fetch_row(mysqli_query($link,"
				select count(*) 
				  from $klient[PSKONT].$tabela 
				 where SKROT='ewidsprz'
		"))[0];
	echo "$klient[PSKONT].$tabela=$ile".($ile>0?' <----------------- ':'')."<br>";
	if($ile)
	{
		mysqli_query($link,"
					update $klient[PSKONT].$tabela 
					   set SKROT='EwidSprz'
					 where SKROT='ewidsprz'
		");
	}
}
echo '<hr>masowa zmiana "ewidprzeb" na "EwidPrzeb" w menu<br>';

$tabela='menu';

$klienci=mysqli_query($link,"select * from Lemur.klienci order by PSKONT");
while($klient=mysqli_fetch_array($klienci))
{
	$ile=mysqli_fetch_row(mysqli_query($link,"
				select count(*) 
				  from $klient[PSKONT].$tabela 
				 where SKROT='ewidprzeb'
		"))[0];
	echo "$klient[PSKONT].$tabela=$ile".($ile>0?' <----------------- ':'')."<br>";
	if($ile)
	{
		mysqli_query($link,"
					update $klient[PSKONT].$tabela 
					   set SKROT='EwidPrzeb'
					 where SKROT='ewidprzeb'
		");
	}
}
echo '<hr>masowa zmiana "SKROT=Rejestry" na "NAZWA=Rejestry VAT" w menu<br>';

$tabela='menu';

$klienci=mysqli_query($link,"select * from Lemur.klienci order by PSKONT");
while($klient=mysqli_fetch_array($klienci))
{
	$ile=mysqli_fetch_row(mysqli_query($link,"
				select count(*) 
				  from $klient[PSKONT].$tabela 
				 where SKROT='Rejestry'
		"))[0];
	echo "$klient[PSKONT].$tabela=$ile".($ile>0?' <----------------- ':'')."<br>";
	if($ile)
	{
		mysqli_query($link,"
					update $klient[PSKONT].$tabela 
					   set NAZWA='Rejestry VAT'
					 where SKROT='Rejestry'
		");
	}
}
echo '<hr>masowe usuwanie "TypyDokKs" w menu<br>';

$tabela='menu';

$klienci=mysqli_query($link,"select * from Lemur.klienci order by PSKONT");
while($klient=mysqli_fetch_array($klienci))
{
	$ile=mysqli_fetch_row(mysqli_query($link,"
				select count(*) 
				  from $klient[PSKONT].$tabela 
				 where SKROT='TypyDokKs'
		"))[0];
	echo "$klient[PSKONT].$tabela=$ile".($ile>0?' <----------------- ':'')."<br>";
	if($ile)
	{
		mysqli_query($link,"
					delete 
					  from $klient[PSKONT].$tabela 
					 where SKROT='TypyDokKs'
		");
	}
}
echo '<hr>masowe testowanie i zmiana "nordpol.KWOTA"<br>';

$tabela='nordpol';

$klienci=mysqli_query($link,"select * from Lemur.klienci order by PSKONT");
while($klient=mysqli_fetch_array($klienci))
{
	$ile=mysqli_fetch_row(mysqli_query($link,"
				select count(*) 
				  from $klient[PSKONT].$tabela 
				 where 1
		"))[0];
	$wynik=mysqli_fetch_row(mysqli_query($link,"
				  show fields
				  from $klient[PSKONT].$tabela 
				 where FIELD='KWOTA'
		"))[1];
	echo "$klient[PSKONT].$tabela=$wynik".(substr($wynik,0,1)=='f'?' <----------------- ':'')." $ile<br>";
	if(substr($wynik,0,1)=='f')
	{
		mysqli_query($link,"
					 alter 
					 table $klient[PSKONT].$tabela 
					change KWOTA 
						   KWOTA decimal(15,2) not null default '0.00'
		");
	}
}
