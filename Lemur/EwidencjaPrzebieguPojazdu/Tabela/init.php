<?php

mysqli_query($link,$q="
alter table $tabela add 
REJESTRACJA char(30) not null default '',
POJEMNOSC decimal(10,0) not null default 0,
KIEROWCA text not null default ''
");
if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}

$struktura=AddSlashes("
CREATE TABLE ewidprzeb (
ID int(11) NOT NULL auto_increment,
ID_D int(11) NOT NULL DEFAULT '-1',
KTO int(11) NOT NULL DEFAULT '0',
LP int(11) NOT NULL default 0,
DATAW date not null,
OPIS text not null default '',
CEL text not null default '',
KM decimal(15,2) not null default 0,
STAWKA decimal(5,4) not null default 0,
WARTOSC decimal(15,2) not null default 0,
UWAGI text not null default '',
LPDZ int(11) NOT NULL default 0,
NRDZ char(30) not null default '',
DATADZ date not null,
RODZAJ text not null default '',
WARTOSCDZ decimal(15,2) not null default 0,
REJESTRACJA char(30) not null default '',
POJEMNOSC decimal(10,0) not null default 0,
KIEROWCA text not null default '',
PRIMARY KEY (ID)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1
");

if(isset($id_d))
{
	$tabelaDef="$tabela
ID|ID|0|
REJESTRACJA|Numer rejestracyjny pojazdu
POJEMNOSC|Pojemno¶æ silnika [cm3]
KIEROWCA|Dane osoby u¿ywaj±cej pojazd
DATAW|Data wyjazdu||style=\"white-space:nowrap;text-align:center\"|
OPIS|Opis trasy
CEL|Cel wyjazdu
KM|km|@Z+|style=\"text-align:right\"|
STAWKA|Stawka|@Z|style=\"text-align:right\"|
WARTOSC|Warto¶æ|@Z+|style=\"text-align:right\"|
UWAGI|Uwagi
LPDZ|LP|@Z|
NRDZ|Numer dokumentu zakupu
DATADZ|Data dokumentu zakupu|@Z|style=\"white-space:nowrap;text-align:center\"|
RODZAJ|Rodzaj wydatku
WARTOSCDZ|Warto¶æ wydatku|@Z+|style=\"text-align:right\"|
from ewidprzeb
order by DATAW, LP*1
";

	$formularzDef="$tabela
REJESTRACJA|Numer rejestracyjny pojazdu|30||3|1|
POJEMNOSC|Pojemno¶æ silnika [cm3]|10||3|1|
KIEROWCA|Dane osoby u¿ywaj±cej pojazd|240||3|1|
DATAW|Data wyjazdu|10|style=\"white-space:nowrap;text-align:center\"|2|1|
OPIS|Opis trasy|240||3|1|
CEL|Cel wyjazdu|240||2|1|
KM|km|@Z15+|style=\"text-align:right\"|2|1|
STAWKA|Stawka|@Z15+|style=\"text-align:right\"|1|1|
WARTOSC|Warto¶æ|@Z15+|right|2|1|
UWAGI|Uwagi|240||2|2|
LPDZ|LP|10||1|2|
NRDZ|Numer dokumentu zakupu|10||3|2|
DATADZ|Data dokumentu zakupu|10||2|2|
RODZAJ|Rodzaj wydatku|240||2|2|
WARTOSCDZ|Warto¶æ wydatku|@Z15+|style=\"text-align:right\"|2|2|
from ewidprzeb
where ID=
";
}
else
{
	$tabelaDef="$tabela
ID|ID|0|
LP|LP
REJESTRACJA|Numer rejestracyjny pojazdu
POJEMNOSC|Pojemno¶æ silnika [cm3]
KIEROWCA|Dane osoby u¿ywaj±cej pojazd
DATAW|Data wyjazdu||style=\"white-space:nowrap;text-align:center\"|
OPIS|Opis trasy
CEL|Cel wyjazdu
KM|km|@Z+|style=\"text-align:right\"|
STAWKA|Stawka|@Z|style=\"text-align:right\"|
WARTOSC|Warto¶æ|@Z+|style=\"text-align:right\"|
UWAGI|Uwagi
LPDZ|LP|@Z|
NRDZ|Numer dokumentu
DATADZ|Data dokumentu|@Z|style=\"white-space:nowrap;text-align:center\"|
RODZAJ|Rodzaj wydatku
WARTOSCDZ|Warto¶æ wydatku|@Z+|style=\"text-align:right\"|
ID_D|ID_D|@s|
KTO|Osoba|@s|
from ewidprzeb
order by DATAW, LP*1";

	$formularzDef="$tabela
LP|LP|10||2|
REJESTRACJA|Numer rejestracyjny pojazdu|30||3|1|
POJEMNOSC|Pojemno¶æ silnika [cm3]|10||3|1|
KIEROWCA|Dane osoby u¿ywaj±cej pojazd|240||3|1|
DATAW|Data wyjazdu|10|style=\"white-space:nowrap;text-align:center\"|2|
OPIS|Opis trasy|240|
CEL|Cel wyjazdu|240|
KM|km|@Z15+|style=\"text-align:right\"|2|
STAWKA|Stawka|@Z15+|style=\"text-align:right\"|2|
WARTOSC|Warto¶æ|@Z15+|right|2|
UWAGI|Uwagi|240/2|
LPDZ|LP|10||2|
NRDZ|Numer dokumentu|100||2|
DATADZ|Data dokumentu|10|style=\"white-space:nowrap;text-align:center\"|2|
RODZAJ|Rodzaj wydatku|240|
WARTOSCDZ|Warto¶æ wydatku|@Z15+|style=\"text-align:right\"|2|
from ewidprzeb
where ID=";
}
	
mysqli_query($link,$q="
	update Lemur2.tabele
	   set STRUKTURA='$struktura'
		 , TABELA='$tabelaDef'
		 , FORMULARZ='$formularzDef'
	 where NAZWA='$widok'
");
if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}
