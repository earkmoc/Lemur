<?php

//die(print_r($_POST));

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

// ----------------------------------------------
// Parametry widoku

$tabela='slownik';
$widok=$tabela;
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$tabela='schematy';
$widok=$tabela;
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$tabela='dokumentr';
$widok=$tabela;
mysqli_query($link,$q="create index ID_D on $tabela(ID_D)");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$tabela='dokumentm';
$widok=$tabela;
mysqli_query($link,$q="create index ID_D on $tabela(ID_D)");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$tabela='dokumentk';
$widok=$tabela;
mysqli_query($link,$q="create index ID_D on $tabela(ID_D)");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$tabela='kpr';
$widok=$tabela;
mysqli_query($link,$q="create index ID_D on $tabela(ID_D)");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$tabela='ewidsprz';
$widok=$tabela;
mysqli_query($link,$q="create index ID_D on $tabela(ID_D)");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$tabela='ewidprzeb';
$widok=$tabela;
mysqli_query($link,$q="create index ID_D on $tabela(ID_D)");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$tabela='osoby';
$widok=$tabela;
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$nip=mysqli_fetch_row(mysqli_query($link, "select WARUNKI from tabeles where ID_TABELE=0 and ID_OSOBY='$ido'"))[0];
$nazwa=mysqli_fetch_row(mysqli_query($link, "select SORTOWANIE from tabeles where ID_TABELE=0 and ID_OSOBY='$ido'"))[0];

$title=$nazwa;
$tabela='dokumenty';
$widok=$tabela.'K';

$nazwa=AddSlashes($nazwa);

$mandatory='';
$mandatory.=($nip?($mandatory?' or ':'')."($tabela.NIP='$nip')":"");
$mandatory.=($nazwa?($mandatory?' or ':'')."($tabela.NAZWA='$nazwa')":"");

mysqli_query($link, "ALTER TABLE $tabela CHANGE `SPOSZAPL` `SPOSZAPL` char(30) NOT NULL DEFAULT 'przelew'");
mysqli_query($link, "ALTER TABLE $tabela CHANGE `PRZEDMIOT` `PRZEDMIOT` char(99) NOT NULL DEFAULT ''");
  
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$params="idTabeli=$idTabeli&row='+row+'&col='+col+'&str='+str+'&id=";
$formularz="../Formularz/?$params'+GetID()+'";

$buttons=array();//Esc=wyj¶cie//Enter=Formularz
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'','akcja'=>"saveTablePosition.php?next=http://{$_SERVER['HTTP_HOST']}/$baza/Menu/&$params'+GetID()+'");
$buttons[]=array('klawisz'=>'Enter','nazwa'=>'','akcja'=>$formularz);
$buttons[]=array('klawisz'=>'AltF','nazwa'=>'','akcja'=>$formularz);
$buttons[]=array('klawisz'=>'Alt1','nazwa'=>'1. Sprzeda¿','akcja'=>"../Formularz/?{$params}0&typy=sprz&typDefault=ST'+'");
$buttons[]=array('klawisz'=>'Alt2','nazwa'=>'2. Zakup','akcja'=>"../Formularz/?{$params}0&typy=zakup&typDefault=ZT'+'");
$buttons[]=array('klawisz'=>'Alt3','nazwa'=>'3. WZ','akcja'=>"../Formularz/?{$params}0&typy=wydanie&typDefault=WZ'+'");
$buttons[]=array('klawisz'=>'Alt4','nazwa'=>'4. PZ','akcja'=>"../Formularz/?{$params}0&typy=przyjêcie&typDefault=PZ'+'");
$buttons[]=array('klawisz'=>'Alt5','nazwa'=>'5. PW','akcja'=>"../Formularz/?{$params}0&typy=przyjêcie&typDefault=PW'+'");
$buttons[]=array('klawisz'=>'AltC','nazwa'=>'Cennik','akcja'=>"");
$buttons[]=array('klawisz'=>'AltK','nazwa'=>'Kopiuj','akcja'=>"../Formularz/?$params-'+GetID()+'");
$buttons[]=array('klawisz'=>'AltR','nazwa'=>'Rozrachunki','akcja'=>"");
$buttons[]=array('klawisz'=>'AltZ','nazwa'=>'Zamówienia','akcja'=>"");
$buttons[]=array('klawisz'=>'AltS','nazwa'=>'','js'=>"$('#modalSzukaj').modal('show')");
$buttons[]=array('klawisz'=>'AltU','nazwa'=>'Usuñ','js'=>"buttonsShow();return confirm('Czy na pewno chcesz usun±æ t± pozycjê?')",'akcja'=>"usun.php?$params'+GetID()+'");
//$buttons[]=array('klawisz'=>'AltW','nazwa'=>'Wydruk','akcja'=>"Wydruk.php?$params'+GetID()+'");
$buttons[]=array('klawisz'=>'AltW','nazwa'=>'Wydruk','akcja'=>"WydrukParametry.php?$params'+GetID()+'&typ='+GetCol(2)+'");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
