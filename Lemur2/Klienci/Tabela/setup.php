<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

// ----------------------------------------------
// Parametry widoku

$title='Klienci';
$tabela='klienci';
$widok=$tabela;
$mandatory='';

mysqli_query($link, "ALTER TABLE `$tabela` ADD REGON char(9) NOT NULL DEFAULT ''");
mysqli_query($link, "ALTER TABLE `$tabela` ADD ULICA text not null default ''");
mysqli_query($link, "ALTER TABLE `$tabela` ADD NRDOMU char(10) not null default ''");
mysqli_query($link, "ALTER TABLE `$tabela` ADD NRLOKALU char(10) not null default ''");
mysqli_query($link, "ALTER TABLE `$tabela` ADD KOD char(6) not null default ''");
mysqli_query($link, "ALTER TABLE `$tabela` ADD MIEJSCOWOSC char(170) not null default '£ód¼'");
mysqli_query($link, "ALTER TABLE `$tabela` ADD POCZTA char(170) not null default ''");
mysqli_query($link, "ALTER TABLE `$tabela` ADD GMINA char(170) not null default ''");
mysqli_query($link, "ALTER TABLE `$tabela` ADD POWIAT char(170) not null default ''");
mysqli_query($link, "ALTER TABLE `$tabela` ADD WOJEWODZTWO char(170) not null default ''");
mysqli_query($link, "ALTER TABLE `$tabela` ADD KRAJ char(2) not null default 'PL'");
mysqli_query($link, "ALTER TABLE `$tabela` ADD WALUTA char(3) not null default 'PLN'");
mysqli_query($link, "ALTER TABLE `$tabela` ADD KODUS char(4) not null default ''");

/*
mysqli_query($link, "
UPDATE
  `klienci`
SET
  `MIEJSCOWOSC` = '£ód¼',
  `POCZTA` = '',
  `GMINA` = '',
  `POWIAT` = '',
  `WOJEWODZTWO` = '',
  `KRAJ` = 'PL',
  `WALUTA` = 'PLN'
WHERE
  1
");
*/

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$params="idTabeli=$idTabeli&row='+row+'&col='+col+'&str='+str+'&id=";

$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>'/Lemur2/Moduly');
$buttons[]=array('klawisz'=>'Enter','nazwa'=>'Enter=wej¶cie','akcja'=>"saveTablePosition.php?next=http://{$_SERVER['HTTP_HOST']}/'+GetCol(2)+'/Menu/&$params'+GetID()+'");
$buttons[]=array('klawisz'=>'AltF','nazwa'=>'Formularz','akcja'=>"../Formularz/?$params'+GetID()+'");
$buttons[]=array('klawisz'=>'AltD','nazwa'=>'Dopisz','akcja'=>"../Formularz/?{$params}0'+'");
$buttons[]=array('klawisz'=>'AltC','nazwa'=>'Copy','akcja'=>"../Formularz/?$params-'+GetID()+'");
$buttons[]=array('klawisz'=>'AltS','nazwa'=>'Szukaj','js'=>"$('#modalSzukaj').modal('show')");
//$buttons[]=array('klawisz'=>'AltU','nazwa'=>'Usuñ','akcja'=>"usun.php?$params'+GetID()+'");
$buttons[]=array('klawisz'=>'AltU','nazwa'=>'Usuñ','js'=>"buttonsShow();return confirm('Czy na pewno chcesz usun±æ t± pozycjê?')",'akcja'=>"usun.php?$params'+GetID()+'");
$buttons[]=array('klawisz'=>'AltI','nazwa'=>'Import','akcja'=>"/$baza/ImportMAX/");
$buttons[]=array('klawisz'=>'AltE','nazwa'=>'Export','akcja'=>"/$baza/Export/?baza='+GetCol(2)+'");
$buttons[]=array('klawisz'=>'AltJ','nazwa'=>'JPK(2)','akcja'=>"/$baza/JPK2/?baza='+GetCol(2)+'");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
