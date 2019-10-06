<?php

function recurse_copy($src,$dst) 
{ 
	$dir = opendir($src); 
	@mkdir($dst); 
	while(false !== ( $file = readdir($dir)) ) 
	{ 
		if (( $file != '.' ) && ( $file != '..' )) 
		{ 
			if ( is_dir($src . '/' . $file) ) { 
				recurse_copy($src . '/' . $file,$dst . '/' . $file); 
			} 
			else 
			{ 
				copy($src . '/' . $file,$dst . '/' . $file); 
//echo "copy($src . '/' . $file,$dst . '/' . $file); <br>";
			} 
		} 
	} 
	closedir($dir); 
}

require("setup.php");
if($ido==-1)
{
	require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveFormFields.php");
}
else
{
	//die(print_r($_POST));
	$klient=$_POST['KLIENT'];
	$rok=$_POST['ROK'];
	$modul=$_POST['NAZWA'];

	$moduly=mysqli_fetch_row(mysqli_query($link,$q="select ID, OPIS from Lemur2.moduly where NAZWA='$modul'"));
	$r=mysqli_fetch_row(mysqli_query($link,$q="select ID, PSKONT from Lemur.klienci where NAZWA='$klient' and PSKONT like '%$rok' limit 1"));
	if($r)	//jest taki klient i rok
	{
		$sets="ID_POZYCJI=$r[0], ID_OSOBY=$ido, ID_TABELE=841";	//klienci
		mysqli_query($link,$q="insert into Lemur.tabeles set $sets on duplicate key update $sets");

		if($modul&&($moduly[1]))
		{
			$sets="ID_POZYCJI=$moduly[0], ID_OSOBY=$ido, ID_TABELE=868";	//moduly
			mysqli_query($link,$q="insert into $r[1].tabeles set $sets on duplicate key update $sets");

			if(substr($moduly[1],0,1)=='-')
			{
				$moduly[1]=substr($moduly[1],1);
				$sets="WARUNKI='\'$moduly[1]\' not like concat(\'%\',SKROT,\'%\')', ID_OSOBY=$ido, ID_TABELE=844";	//menu
			}
			else
			{
				$sets="WARUNKI='\'$moduly[1]\' like concat(\'%\',SKROT,\'%\')', ID_OSOBY=$ido, ID_TABELE=844";	//menu
			}
			mysqli_query($link,$q="insert into $r[1].tabeles set $sets on duplicate key update $sets");
		}
		else	//nie ma modu≈Çu
		{
			$sets="ID_POZYCJI=1, ID_OSOBY=$ido, ID_TABELE=868";	//moduly
			mysqli_query($link,$q="insert into $r[1].tabeles set $sets on duplicate key update $sets");

			$sets="WARUNKI='', ID_OSOBY=$ido, ID_TABELE=844";	//menu
			mysqli_query($link,$q="insert into $r[1].tabeles set $sets on duplicate key update $sets");
		}

		$_POST['PSKONT']=$r[1];
		$timestampLemur=mysqli_fetch_row(mysqli_query($link,"select CZAS from Lemur.klienci where PSKONT='Lemur'"))[0];
		$timestampLemur=max($timestampLemur,file_get_contents("{$_SERVER['DOCUMENT_ROOT']}/Lemur/timestamp.ver"));
		$timestampKlienta=mysqli_fetch_row(mysqli_query($link,"select CZAS from Lemur.klienci where PSKONT='$_POST[PSKONT]'"))[0];
		//die("($timestampKlienta<=$timestampLemur)");

		if	( (!file_exists("{$_SERVER['DOCUMENT_ROOT']}/{$_POST['PSKONT']}/Menu/index.php"))
			||($timestampKlienta<=$timestampLemur)
			)
		{
			if($_POST['PSKONT'])
			{
				$_POST['PSKONT']=substr($_POST['PSKONT'],0,20);
				mysqli_query($link,"update Lemur.klienci set CZAS=Now() where PSKONT='$_POST[PSKONT]'");
				recurse_copy("{$_SERVER['DOCUMENT_ROOT']}/Lemur","{$_SERVER['DOCUMENT_ROOT']}/$_POST[PSKONT]");

				$tabela='dokumentr';
				mysqli_query($link, $q="ALTER TABLE $_POST[PSKONT].$tabela CHANGE `ID_D` `ID_D` INT(11) NOT NULL DEFAULT '-1'");
//					if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}
				mysqli_query($link, $q="ALTER TABLE $_POST[PSKONT].$tabela CHANGE `TYP` `TYP` char(10) NOT NULL DEFAULT ''");
//					if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}
				mysqli_query($link, $q="ALTER TABLE $_POST[PSKONT].$tabela ADD INDEX `TYP_OKRES` (`TYP`, `OKRES`)");
//					if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}
				mysqli_query($link, $q="ALTER TABLE $_POST[PSKONT].$tabela ADD INDEX `OKRES` (`OKRES`)");
//					if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}
				mysqli_query($link, $q="ALTER TABLE $_POST[PSKONT].$tabela ADD INDEX `TYP` (`TYP`)");
//					if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}
				mysqli_query($link, $q="ALTER TABLE $_POST[PSKONT].towary ADD DATA date");
				mysqli_query($link, $q="update Lemur2.tabele set STRUKTURA=replace(STRUKTURA,
'STATUS char(1) not null default 0,
PRIMARY KEY (ID)',
'STATUS char(1) not null default 0,
DATA date,
PRIMARY KEY (ID)')

, TABELA=replace(TABELA,
'format(STAN*CENA_Z,2)|Warto∂Ê netto w cenach zakupu|@Z+|style=\"text-align:right\"|
from towary',
'format(STAN*CENA_Z,2)|Warto∂Ê netto w cenach zakupu|@Z+|style=\"text-align:right\"|
DATA|Data nabycia|@Z|style=\"text-align:right\"|
from towary') where ID=645");
//					if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}
			}
		}
		header("Location:/$r[1]/Menu");
	}
	else	//nie ma klienta lub roku
	{
		if($klient)
		{
			$sets="WARUNKI='NAZWA=\'$klient\'', ID_OSOBY=$ido, ID_TABELE=841";	//klienci
			mysqli_query($link,$q="insert into Lemur.tabeles set $sets on duplicate key update $sets");
		}
		else
		{
			$sets="WARUNKI='', ID_OSOBY=$ido, ID_TABELE=841";	//klienci
			mysqli_query($link,$q="insert into Lemur.tabeles set $sets on duplicate key update $sets");
		}
		header("Location:/Lemur/Klienci/Tabela");
	}
}

