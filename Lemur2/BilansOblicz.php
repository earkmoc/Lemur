<?php
	
function Wn($link, $ido,$tabela, $maski)
{
	$source=($tabela=='rachwyn'?'zest1s':'zest1');
	$ido=@$_SESSION['osoba_id'];
	$wynik=0;
	$maski=explode(',',$maski);
	foreach($maski as $maska)
	{
		$maska=str_replace('*','%',$maska);
		$wynik+=mysqli_fetch_row(mysqli_query($link,$q="select sum(SALDOWN) from $source where ID_OSOBYUPR=$ido and KONTO like '$maska'"))[0];
		if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}
	}
	return $wynik;
}

function Ma($link, $ido,$tabela, $maski)
{
	$source=($tabela=='rachwyn'?'zest1s':'zest1');
	$wynik=0;
	$maski=explode(',',$maski);
	foreach($maski as $maska)
	{
		$maska=str_replace('*','%',$maska);
		$wynik+=mysqli_fetch_row(mysqli_query($link,$q="select sum(SALDOMA) from $source where ID_OSOBYUPR=$ido and KONTO like '$maska'"))[0];
		if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}
	}
	return $wynik;
}

function Wy($link, $ido,$tabela, $maski)
{
	$source=($tabela=='rachwyn'?'zest1s':'zest1');
	$wynik=Wn($link, $ido,$tabela, $maski)-Ma($link, $ido,$tabela, $maski);
	return abs($wynik);
}

function Su($link, $ido, $tabela, $maski)
{
	$wynik=0;
	$maski=explode(',',$maski);
	foreach($maski as $maska)
	{
		$maska=str_replace(' ','',$maska);
		$maska=str_replace('?','.',$maska);
		$maska='^'.$maska.'$';
		$wynik+=mysqli_fetch_row(mysqli_query($link,$q="select sum(WARTOSC) from $tabela where LPPOZ regexp '$maska'"))[0];
		if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}
	}
	return $wynik;
}

function Po($link, $ido, $tabela, $maski)
{
	$wynik=0;
	$maski=explode(',',$maski);
	foreach($maski as $maska)
	{
		$maska=str_replace(' ','',$maska);
		$maska=str_replace('?','.',$maska);
		$maska='^'.$maska.'$';
		$wynik+=mysqli_fetch_row(mysqli_query($link,$q="select sum(WARTOSC) from $tabela where LPPOZ regexp '$maska'"))[0];
		if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}
	}
	return $wynik;
}

function Wynik($link, $ido, $tabela, $def)
{
	$def=str_replace('"',"'",$def);
	$def=str_replace('`',"'",$def);
	$def=str_replace('Ma(','Ma($link,$ido,$tabela,',$def);
	$def=str_replace('Wn(','Wn($link,$ido,$tabela,',$def);
	$def=str_replace('Wy(','Wy($link,$ido,$tabela,',$def);
	$def=str_replace('Su(','Su($link,$ido,$tabela,',$def);
	$def=str_replace('Po(','Po($link,$ido,$tabela,',$def);
	return eval('return '.$def.';');
}

$zysk=0;
$tabele=array('rachwyn','bilans','bilansp');
foreach($tabele as $tabela)
{
	mysqli_query($link, "ALTER TABLE `$tabela` CHANGE `WARTOSC` `WARTOSC` DECIMAL(15,2) NOT NULL DEFAULT '0.00'");
	mysqli_query($link,$q="update $tabela set WARTOSC=0");

	$w=mysqli_query($link,"select * from $tabela where (DEFINICJA<>'') and (DEFINICJA not like 'Su%') and (DEFINICJA not like 'Po%')");
	while ($r=mysqli_fetch_array($w))
	{
		$r['DEFINICJA']=str_replace('RACHWYN->WARTOSC',$zysk,$r['DEFINICJA']);
		$wynik=Wynik($link, $ido, $tabela, $r['DEFINICJA']);
		mysqli_query($link,$q="update $tabela set WARTOSC='$wynik' where ID=$r[ID]");
		if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}
	}

	$w=mysqli_query($link,"select * from $tabela where (DEFINICJA<>'') and (DEFINICJA like 'Su%') and (DEFINICJA not like '%?%') order by LPPOZ desc");
	while ($r=mysqli_fetch_array($w))
	{
		$wynik=Wynik($link, $ido, $tabela, $r['DEFINICJA']);
		mysqli_query($link,$q="update $tabela set WARTOSC='$wynik' where ID=$r[ID]");
		if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}
	}

	$w=mysqli_query($link,"select * from $tabela where (DEFINICJA<>'') and (DEFINICJA like 'Su%') and (DEFINICJA like '%?%') order by LPPOZ desc");
	while ($r=mysqli_fetch_array($w))
	{
		$wynik=Wynik($link, $ido, $tabela, $r['DEFINICJA']);
		mysqli_query($link,$q="update $tabela set WARTOSC='$wynik' where ID=$r[ID]");
		if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}
	}

	$w=mysqli_query($link,"select * from $tabela where (DEFINICJA<>'') and (DEFINICJA like 'Po%') and (DEFINICJA not like '%?%') order by LPPOZ asc");
	while ($r=mysqli_fetch_array($w))
	{
		$wynik=Wynik($link, $ido, $tabela, $r['DEFINICJA']);
		mysqli_query($link,$q="update $tabela set WARTOSC='$wynik' where ID=$r[ID]");
		if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}
	}

	$w=mysqli_query($link,"select * from $tabela where (DEFINICJA<>'') and (DEFINICJA like 'Po%') and (DEFINICJA like '%?%') order by LPPOZ asc");
	while ($r=mysqli_fetch_array($w))
	{
		$wynik=Wynik($link, $ido, $tabela, $r['DEFINICJA']);
		mysqli_query($link,$q="update $tabela set WARTOSC='$wynik' where ID=$r[ID]");
		if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}
	}
	if($tabela=='rachwyn')
	{
		$zysk=$wynik;
	}
}
