<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

mysqli_query($link, "ALTER TABLE `pracownicy` ADD `STANOWISKO` char(50) NOT NULL DEFAULT ''");
mysqli_query($link, "ALTER TABLE `pracownicy` ADD `SYSCZASUPRACY` char(50) NOT NULL DEFAULT ''");
mysqli_query($link, "ALTER TABLE `pracownicy` ADD `OBOWOKRROZL` char(50) NOT NULL DEFAULT ''");
mysqli_query($link, "ALTER TABLE `pracownicy` ADD `GODZINYPRACY` char(50) NOT NULL DEFAULT ''");
mysqli_query($link, "ALTER TABLE `pracownicy` ADD `NRDOWODU` char(50) NOT NULL DEFAULT ''");
mysqli_query($link, "ALTER TABLE `pracownicy` ADD `NRTELEFONU` char(50) NOT NULL DEFAULT ''");
mysqli_query($link, "ALTER TABLE `pracownicy` ADD `NAZWISKORODOWE` char(50) NOT NULL DEFAULT ''");

mysqli_query($link, "ALTER TABLE `absencje` change `KOD` `KOD` char(20) NOT NULL DEFAULT ''");
mysqli_query($link, "update absencje set KOD='Uw' where KOD='U'");
mysqli_query($link, "update absencje set KOD='Za' where KOD='Z'");
mysqli_query($link, "update absencje set KOD='Ch' where KOD='C'");

$id_d=@$_SESSION["{$baza}ListyPlacID_D"];

// ----------------------------------------------
// Parametry widoku

$tabela='absencje';
$widok=$tabela;
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$title='Pracownicy';
$tabela='pracownicy';
$widok=$tabela;
$mandatory='';
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$params="idTabeli=$idTabeli&row='+row+'&col='+col+'&str='+str+'&id=";
$esc="saveTablePosition.php?next=http://{$_SERVER['HTTP_HOST']}/$baza/Menu/&$params'+GetID()+'";
$formularz="../Formularz/?$params'+GetID()+'";
$dopisz="../Formularz/?{$params}0'+'";
$kopia="../Formularz/?$params-'+GetID()+'";
$usun="usun.php?$params'+GetID()+'";

$buttons=array();
if (!isset($id_d))
{
	$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>$esc);
} else
{
	$buttons[]=array('klawisz'=>'AltP','nazwa'=>'P=wyj¶cie','js'=>"parent.$('#myModal').modal('hide');parent.$('input[name=NUMER]').focus();");
}
$buttons[]=array('klawisz'=>'Enter','nazwa'=>'','akcja'=>$formularz);
$buttons[]=array('klawisz'=>'AltF','nazwa'=>'Enter=Formularz','akcja'=>$formularz);
$buttons[]=array('klawisz'=>'AltD','nazwa'=>'Dopisz','akcja'=>$dopisz);
$buttons[]=array('klawisz'=>'AltC','nazwa'=>'Copy','akcja'=>$kopia);
$buttons[]=array('klawisz'=>'AltS','nazwa'=>'Szukaj','js'=>"$('#modalSzukaj').modal('show')");
$buttons[]=array('klawisz'=>'AltU','nazwa'=>'Usuñ','akcja'=>$usun);
$buttons[]=array('klawisz'=>'AltW','nazwa'=>'Wydruk','akcja'=>"Wydruk.php?wydruk=Raporta&natab=$tabela&strona1=15&stronan=20");
$buttons[]=array('klawisz'=>'AltK','nazwa'=>'Karta wynagrodzeñ','akcja'=>"kwp.php?$params'+GetID()+'&wzor=KWP");
$buttons[]=array('klawisz'=>'AltE','nazwa'=>'Ewidencja czasu pracy','akcja'=>"ecp.php?$params'+GetID()+'&wzor=ECP");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
