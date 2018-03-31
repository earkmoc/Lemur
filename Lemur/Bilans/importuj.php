<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$raport='';
$czas=date('Y-m-d H:i:s');
$baza=$_POST['baza'];
$klient=$_GET['klient'];

$title="Import bilansu z '$baza' do '$klient': raport";
$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"../Klienci");

$iluKlientow=mysqli_fetch_row(mysqli_query($link, $q="
	select count(*) from Lemur2.klienci where PSKONT='$baza'
"))[0];

if	( ($baza==$klient)
	||($baza=='')
	||($iluKlientow<>1)
	)
{
	$raport='Niew³a¶ciwe dane klienta ¼ród³owego';
}
else
{
	//kopiowanie wybranych tabel
	$kopiowane=array(
		 'bilans'
		,'bilansp'
		,'rachwyn'
		,'zest1'
		,'zest1b'
		,'zest1s'
		,'zest1sr'
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

	foreach($kopiowane as $tabela)
	{
		$ile=mysqli_fetch_row(mysqli_query($link,$q="
			select count(*) from $klient.$tabela
		"))[0];
		$raport.="$tabela: $ile szt.\n";
	}
}

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

echo "<h2>Raport importu bilansu z '$baza' do '$klient':</h2>";
echo "<hr>";
echo '<h3>'.nl2br($raport).'</h3>';

echo '<hr>';

echo $czas.' czas rozpoczêcia';
echo '<br>';
echo date('Y-m-d H:i:s').' czas zakoñczenia';

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");
