<?php

$idPoprzedni=($_GET['id']);

$_POST['CZAS']=date('Y-m-d H:i:s');
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveFormFields.php");

if(false&&($idPoprzedni<0))
{
	$idPoprzedni=abs($idPoprzedni);
	$tmp=mysqli_fetch_row(mysqli_query($link, $q="
		select PSKONT from Lemur2.klienci where ID=$idPoprzedni
	"));
	$bazaPoprzednia=$tmp[0];

	//źródło skryptów musi być aktualne
	mysqli_query($link,$q="
		update Lemur2.klienci set CZAS=Now() where PSKONT='Lemur'
	");

	//utworzenie nowej bazy danych
	$innaBaza=$bazaNowa=$_POST['PSKONT'];
	require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

	//kopiowanie wybranych tabel
	$kopiowane=array(
		 'menu'
		,'schematy'
		,'schematys'
		,'rejestry'
		,'knordpol'
		,'dnordpol'
		,'slownik'
		,'listyplac'
		,'listyplacp'
		,'pracownicy'
		,'absencje'
		,'historiap'
		,'srodkitr'
		,'srodkiot'
		,'srodkizm'
		,'srodkihi'
		,'zest1'
		,'bilans'
		,'bilansp'
		,'rachwyn'
		,'towary'
	);

	foreach($kopiowane as $tabela)
	{
		mysqli_query($link,$q="
			create table $bazaNowa.$tabela like $bazaPoprzednia.$tabela
		");
		mysqli_query($link,$q="
			insert into $bazaNowa.$tabela select * from $bazaPoprzednia.$tabela
		");
	}
	mysqli_query($link,$q="
		update $bazaNowa.menu set CZAS=Now()
	");
}

if	(false
    &&($_POST['PSKONT']<>'Batory')
	&&($_POST['PSKONT']<>'Filutek')
	)
{
	require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/update_dump_all.php");
}
