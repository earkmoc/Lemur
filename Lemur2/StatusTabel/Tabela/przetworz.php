<?php

ini_set('max_execution_time', 600);
error_reporting(E_ERROR | E_PARSE | E_WARNING);//E_NOTICE | 

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

mysqli_query($link,"truncate table Status");

$klienci=mysqli_query($link,"select * from Lemur2.klienci order by PSKONT");
while($klient=mysqli_fetch_array($klienci))
{
	mysqli_query($link,"
		insert 
		  into Status
		   set Klient='$klient[PSKONT]'
	");
	
	$tabele=mysqli_query($link,$q="
		SELECT TABLE_NAME 
		FROM Information_schema.`KEY_COLUMN_USAGE` 
		where `CONSTRAINT_SCHEMA`='$klient[PSKONT]'
		group by TABLE_NAME 
	");
	
	if (mysqli_error($link)) {mysqli_query($link,"update Status set Klient=concat(Klient,'".mysqli_error($link).'<br>'.$q."')");}
	
	$errors='';
	while($tabela=mysqli_fetch_row($tabele))
	{
		$w=mysqli_query($link,$q="
				select count(*) from $klient[PSKONT].$tabela[0]
		");
		$ile=($w?mysqli_fetch_row($w)[0]:'');

		if (mysqli_error($link)) {$errors.=mysqli_error($link).'<br>'.$q.'<br>';}

		if($tabela[0]=='dokumenty')
		{
			$w=mysqli_query($link,$q="
				select concat(', N=',sum(NETTOVAT),', V=',sum(PODATEK_VAT),', B=',sum(WARTOSC),', S=',sum(if(TYP like 'S%',NETTOVAT,0)),', Z=',sum(if(TYP not like 'S%',NETTOVAT,0))) from $klient[PSKONT].$tabela[0]
			");
			$ile.=($w?mysqli_fetch_row($w)[0]:'');
			if (mysqli_error($link)) {$errors.=mysqli_error($link).'<br>'.$q.'<br>';}

			$w=mysqli_query($link,$q="
				select concat(', 0=',count(*)) from $klient[PSKONT].$tabela[0] where NETTOVAT=0
			");
			$ile.=($w?mysqli_fetch_row($w)[0]:'');
			if (mysqli_error($link)) {$errors.=mysqli_error($link).'<br>'.$q.'<br>';}

			$w=mysqli_query($link,$q="
				select concat(', od=',DOPERACJI) from $klient[PSKONT].$tabela[0] where DOPERACJI*1<>0 order by DOPERACJI asc limit 1
			");
			$ile.=($w?mysqli_fetch_row($w)[0]:'');
			if (mysqli_error($link)) {$errors.=mysqli_error($link).'<br>'.$q.'<br>';}

			$w=mysqli_query($link,$q="
				select concat(', do=',DOPERACJI) from $klient[PSKONT].$tabela[0] where DOPERACJI*1<>0 order by DOPERACJI desc limit 1
			");
			$ile.=($w?mysqli_fetch_row($w)[0]:'');
			if (mysqli_error($link)) {$errors.=mysqli_error($link).'<br>'.$q.'<br>';}
		}
		
		if($tabela[0]=='dokumentr')
		{
			$w=mysqli_query($link,$q="
				select concat(', N=',sum(NETTO),', V=',sum(VAT),', B=',sum(BRUTTO)) from $klient[PSKONT].$tabela[0]
			");
			$ile.=($w?mysqli_fetch_row($w)[0]:'');
			if (mysqli_error($link)) {$errors.=mysqli_error($link).'<br>'.$q.'<br>';}

			$w=mysqli_query($link,$q="
				select concat(', %=',STAWKA,', N=',sum(NETTO),', V=',sum(VAT),', B=',sum(BRUTTO)) from $klient[PSKONT].$tabela[0] group by STAWKA
			");
			if (mysqli_error($link)) {$errors.=mysqli_error($link).'<br>'.$q.'<br>';}
			while($r=mysqli_fetch_row($w))
			{
				$ile.=$r[0];
			}
		}
		
		if($tabela[0]=='kpr')
		{
			$w=mysqli_query($link,$q="
				select concat(', P=',sum(PRZYCHOD3),', Z=',sum(ZAKUP_TOW),', K=',sum(KOSZTY_UB),', R=',sum(RAZEM)) from $klient[PSKONT].$tabela[0]
			");
			$ile.=($w?mysqli_fetch_row($w)[0]:'');
			if (mysqli_error($link)) {$errors.=mysqli_error($link).'<br>'.$q.'<br>';}
			
			$w=mysqli_query($link,$q="
				select concat(', 0=',count(*)) from $klient[PSKONT].$tabela[0] where DATA*1=0
			");
			$ile.=($w?mysqli_fetch_row($w)[0]:'');
			if (mysqli_error($link)) {$errors.=mysqli_error($link).'<br>'.$q.'<br>';}

			$w=mysqli_query($link,$q="
				select concat(', od=',DATA) from $klient[PSKONT].$tabela[0] where DATA*1<>0 order by DATA asc limit 1
			");
			$ile.=($w?mysqli_fetch_row($w)[0]:'');
			if (mysqli_error($link)) {$errors.=mysqli_error($link).'<br>'.$q.'<br>';}

			$w=mysqli_query($link,$q="
				select concat(', do=',DATA) from $klient[PSKONT].$tabela[0] where DATA*1<>0 order by DATA desc limit 1
			");
			$ile.=($w?mysqli_fetch_row($w)[0]:'');
			if (mysqli_error($link)) {$errors.=mysqli_error($link).'<br>'.$q.'<br>';}
		}
		
		mysqli_query($link,"
			update Status
			   set $tabela[0]='$ile $errors'
			 where Klient='$klient[PSKONT]'
		");
	}
}

header("location:../Tabela");
