<?php
@session_start();

date_default_timezone_set('Europe/Warsaw');

$host='localhost';
$user='root';
$pass='krasnal';
$pass='223';
$ido=@$_SESSION['osoba_id'];

//if (!$linkLemur = mysqli_connect($host, $user, $pass, 'Lemur2')) {
if (!$linkLemur = mysqli_connect('p:'.$host, $user, $pass, 'Lemur2')) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    exit;
}

$bazaLinku=explode('/',$_SERVER['REQUEST_URI'])[1];
@$baza=($innaBaza?$innaBaza:$bazaLinku);
if (!@$link = mysqli_connect('p:'.$host, $user, $pass, $baza)) {
	$link=mysql_connect($host,$user,$pass);
	if (!$link){
			echo 'Problem z po³±czeniem z MYSQL';
			exit;
	}
	if (!mysql_select_db($baza)) {
		mysql_query("
			create database $baza
		");
		if (!$link = mysqli_connect($host, $user, $pass, $baza)) {
			echo "Error: Unable to connect to MySQL." . PHP_EOL;
			echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
			echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
			exit;
		}
		mysqli_query($link,"
			CREATE TABLE `tabeles` (
			  `ID` int(11) NOT NULL auto_increment,
			  `ID_OSOBY` int(11) NOT NULL DEFAULT '0',
			  `ID_TABELE` int(11) NOT NULL DEFAULT '0',
			  `ID_POZYCJI` int(11) NOT NULL DEFAULT '0',
			  `NR_STR` int(11) NOT NULL DEFAULT '0',
			  `NR_ROW` int(11) NOT NULL DEFAULT '0',
			  `NR_COL` int(11) NOT NULL DEFAULT '0',
			  `WARUNKI` text NOT NULL,
			  `SORTOWANIE` text NOT NULL,
			  `OX_POZYCJI` int(11) NOT NULL DEFAULT '0',
			  `OY_POZYCJI` int(11) NOT NULL DEFAULT '0',
			  `MX_POZYCJI` int(11) NOT NULL DEFAULT '0',
			  `screenLeft` int(11) NOT NULL DEFAULT '0',
			  `screenTop` int(11) NOT NULL DEFAULT '0',
			  `screenWidth` int(11) NOT NULL DEFAULT '100',
			  `screenHeight` int(11) NOT NULL DEFAULT '100',
			  PRIMARY KEY (ID),
			  UNIQUE KEY `ID_OSOBY` (`ID_OSOBY`,`ID_TABELE`)
			) ENGINE=MyISAM  DEFAULT CHARSET=latin1;
		");
	}
}

@$baza=$bazaLinku;

//mysqli_query($link,$q="SET GLOBAL query_cache_type = 'ON'"); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
//mysqli_query($link,$q="SET GLOBAL query_cache_type=1"); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
//mysqli_query($link,$q="SET GLOBAL log_slow_queries=1"); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
mysqli_query($link,$q="SET GLOBAL slow_query_log=1"); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
mysqli_query($link,$q="SET GLOBAL long_query_time=1"); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

$chs='latin2';
//$col='utf8_polish_ci';
$col='latin2_general_ci';	//domyœlna collacja dla porównañ pól tabel z tekstami, np. : if(opldod.TYPOPER='o'

mysqli_query($link,$q='SET CHARACTER SET '.$chs); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
mysqli_query($link,$q='SET character_set_client='.$chs, $db); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
mysqli_query($link,$q='SET character_set_connection='.$chs, $db); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
mysqli_query($link,$q='SET character_set_database='.$chs, $db); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
mysqli_query($link,$q='SET character_set_results='.$chs, $db); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
mysqli_query($link,$q='SET character_set_server='.$chs, $db); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

mysqli_query($link,$q='SET collation_connection = '.$col); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
mysqli_query($link,$q='SET collation_database = '.$col); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
mysqli_query($link,$q='SET collation_server = '.$col); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
