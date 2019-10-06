<?php

$host='p:localhost';
$user='';
$pass='';
$bazaLinku='';

@session_start();
$ido=@$_SESSION['osoba_id'];

date_default_timezone_set('Europe/Warsaw');

//$bazaLinku=explode('/',$_SERVER['REQUEST_URI'])[1];

if (!$linkLemur = mysqli_connect($host, $user, $pass, $bazaLinku)) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    exit;
}

@$baza=($innaBaza?$innaBaza:$bazaLinku);
//if (!@$link = mysqli_connect($host, $user, $pass, $baza)) {
//	$link=mysql_connect($host,$user,$pass);
//	if (!$link){
//			echo "Problem z po³±czeniem z MYSQL dla $baza";
//			exit;
//	}
//}

@$baza=$bazaLinku;
@$link=$linkLemur;