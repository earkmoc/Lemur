<?php

require("setup.php");

if($ido==1)
{
	unset($_POST['NX']);
	unset($_POST['NY']);
	require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveFormFields.php");
}
else
{
	//die(print_r($_POST));
	$user=trim(explode('-',$_POST['USER'])[0]);
	$w=mysqli_query($link,$q="select ID, NAZWA, PASS from $tabela where USER='$user' limit 1");
	$r=mysqli_fetch_row($w);
	if	(	$user
		&&	($r[2]==$_POST['PASS'])
		)
	{
		$id=$r[0];
		$_SESSION['osoba_id']=$r[0];
		$_SESSION['osoba_upr']=$r[1];

		$q="update $tabela SET CZAS=Now()";
		if	(	($_POST['NX']<>'')
			&&	($_POST['NX']==$_POST['NY'])
			)
		{
			$q.=", PASS='$_POST[NX]'";
		}

		$w=mysqli_query($link,$q.=" where ID=$id limit 1");
		if(mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

		//zmiana lokalizacji tabeli klientów
		require_once("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/funkcje.php");
		if	( !FieldsOd($link, 'klienci', 1)
			||(mysqli_fetch_row(mysqli_query($link,$q="select count(*) from Lemur2.klienci"))[0]==0)
			)
		{
			mysqli_query($link,$q="create table if not exists klienci like Lemur.klienci");
			mysqli_query($link,$q="insert into  klienci select * from Lemur.klienci");
		}

		//określenie docelowego menu
		$klient='Lemur2/Firmy';
//		$klient=(mysqli_fetch_row(mysqli_query($link,$q="select count(*) from Lemur2.klienci where PSKONT='Batory'"))[0]?'Batory/Menu/index.php':$klient);
//		$klient=(mysqli_fetch_row(mysqli_query($link,$q="select count(*) from Lemur2.klienci where PSKONT='Filutek'"))[0]?'Filutek/Menu/index.php':$klient);
//		$klient='Lemur2/Klienci/Tabela/index.php';

		header("Location:/$klient");

		//aktualizacja baz danych do archiwizacji
		require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/update_dump_all.php");
	} 
	else
	{
		header('Location:/Lemur2/Logowanie/Tabela/logout.php');
	}
}