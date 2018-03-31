<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$raport='';
$czas=date('Y-m-d H:i:s');
$baza=$_GET['baza'];
$klient=$_POST['klient'];
$odDaty=$_POST['odDaty'];
$doDaty=$_POST['doDaty'];

$title="Export danych z '$baza' do '$klient': raport";
$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"../Klienci");

$iluKlientow=mysqli_fetch_row(mysqli_query($link, $q="
	select count(*) from Lemur2.klienci where PSKONT='$klient'
"))[0];

if	( ($baza==$klient)
	||($klient=='')
	||($iluKlientow<>1)
	)
{
	$raport='Niew³a¶ciwe dane klienta docelowego';
}
else
{
	//kopiowanie wybranych tabel
	$kopiowane=array(
		 'kpr'
		,'dokumenty'
		,'dokumentr'
		,'dokumentm'
		,'dokumentk'
		,'ewidprzeb'
	);

	foreach($kopiowane as $tabela)
	{
		mysqli_query($link,$q="
			create table IF NOT EXISTS $klient.$tabela like $baza.$tabela
		");
		mysqli_query($link,$q="
			truncate $klient.$tabela
		");
		mysqli_query($link,$q="
			insert into $klient.$tabela select * from $baza.$tabela
		");
	}

	mysqli_query($link,$q="
		delete from $klient.kpr where not DATA between '$odDaty' and '$doDaty'
	");
	mysqli_query($link,$q="
		delete from $klient.dokumenty where not DOPERACJI between '$odDaty' and '$doDaty'
	");

	$czyszczone=array(
		 'dokumentr'
		,'dokumentm'
		,'dokumentk'
		,'ewidprzeb'
	);

	foreach($czyszczone as $tabela)
	{
		mysqli_query($link,$q="
			update $klient.$tabela left join dokumenty on dokumenty.ID=$tabela.ID_D set $tabela.ID_D=-2 where isnull(dokumenty.ID) and $tabela.ID_D<>0
		");
		mysqli_query($link,$q="
			delete from $klient.$tabela where ID_D=-2
		");
	}

	foreach($kopiowane as $tabela)
	{
		$ile=mysqli_fetch_row(mysqli_query($link,$q="
			select count(*) from $klient.$tabela
		"))[0];
		$raport.="$tabela: $ile szt.\n";
	}
}

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

echo "<h2>Raport exportu danych z '$baza' do '$klient':</h2>";
echo "<hr>";
echo '<h3>'.nl2br($raport).'</h3>';

echo '<hr>';

echo $czas.' czas rozpoczêcia';
echo '<br>';
echo date('Y-m-d H:i:s').' czas zakoñczenia';

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");
