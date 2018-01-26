<?php

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
	$r=mysqli_fetch_row(mysqli_query($link,$q="select ID, PSKONT from Lemur2.klienci where NAZWA='$klient' and PSKONT like '%$rok' limit 1"));
	if($r)	//jest taki klient i rok
	{
		$sets="ID_POZYCJI=$r[0], ID_OSOBY=$ido, ID_TABELE=841";	//klienci
		mysqli_query($link,$q="insert into Lemur2.tabeles set $sets on duplicate key update $sets");

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
		else	//nie ma modułu
		{
			$sets="ID_POZYCJI=1, ID_OSOBY=$ido, ID_TABELE=868";	//moduly
			mysqli_query($link,$q="insert into $r[1].tabeles set $sets on duplicate key update $sets");

			$sets="WARUNKI='', ID_OSOBY=$ido, ID_TABELE=844";	//menu
			mysqli_query($link,$q="insert into $r[1].tabeles set $sets on duplicate key update $sets");
		}

		$_POST['PSKONT']=$r[1];
		require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/copyOfLemur.php");
		header("Location:/$r[1]/Menu");
	}
	else	//nie ma klienta lub roku
	{
		if($klient)
		{
			$sets="WARUNKI='NAZWA=\'$klient\'', ID_OSOBY=$ido, ID_TABELE=841";	//klienci
			mysqli_query($link,$q="insert into Lemur2.tabeles set $sets on duplicate key update $sets");
		}
		else
		{
			$sets="WARUNKI='', ID_OSOBY=$ido, ID_TABELE=841";	//klienci
			mysqli_query($link,$q="insert into Lemur2.tabeles set $sets on duplicate key update $sets");
		}
		header("Location:/Lemur2/Klienci/Tabela");
	}
}
