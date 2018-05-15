<?php

if(!mysqli_fetch_row(mysqli_query($link,$q="
	select count(*)
	  from Lemur2.tabele
	 where NAZWA='$widok'
	"))[0])
{
	$struktura=AddSlashes("
create table if not exists $tabela
(ID int(11) NOT NULL auto_increment
,KTO int(11) NOT NULL DEFAULT 0
,CZAS datetime NOT NULL DEFAULT '0000-00-00 00:00:00'
,LP int(11) NOT NULL default 0
,REJESTRACJA char(10) not null default ''
,POJEMNOSC char(10) not null default ''
,OPIS text not null default ''
,PRZEBIEGBAZA decimal(15,0) not null default 0
,OKRES char(10) not null default ''
,PRZEBIEGPOCZ decimal(15,0) not null default 0
,PRZEBIEGKONC decimal(15,0) not null default 0
,PRIMARY KEY (ID)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1");

	$tabelaDef="$tabela
ID|ID|0|
LP|LP
REJESTRACJA|Numer rejestracyjny pojazdu
POJEMNOSC|Pojemno¶æ silnika [cm3]|@Z|style=\"text-align:center\"|
PRZEBIEGBAZA|Przebieg bazowy [km]|@Z|style=\"text-align:center\"|
OKRES|Okres|@Z|style=\"white-space:nowrap\"|
PRZEBIEGPOCZ|Przebieg pocz±tkowy okresu [km]|@Z|style=\"text-align:center\"|
PRZEBIEGKONC|Przebieg koñcowy okresu [km]|@Z|style=\"text-align:center\"|
OPIS|Dane osoby u¿ywaj±cej pojazd|99|
KTO|Kto|@s|
CZAS|Kiedy|@s|
from $tabela
order by LP*1";

	$formularzDef="$tabela
LP|LP|10||1|1|
REJESTRACJA|Numer rejestracyjny|10||2|1|
POJEMNOSC|Pojemno¶æ silnika [cm3]|10|right|2|1|
PRZEBIEGBAZA|Przebieg bazowy [km]|@Z|right|2|1|
OKRES|Okres|@Z||1|1|
PRZEBIEGPOCZ|Przebieg pocz±tkowy okresu [km]|10|right|2|1|
PRZEBIEGKONC|Przebieg koñcowy okresu [km]|10|right|2|1|
OPIS|Dane osoby u¿ywaj±cej pojazd (nazwisko, imiê, adres zamieszkania)|99/3||12|2|
from $tabela
where ID=";

	mysqli_query($link,$q="
		insert 
		  into Lemur2.tabele
		   set NAZWA='$widok'
			 , OPIS='$widok'
			 , STRUKTURA='$struktura'
			 , TABELA='$tabelaDef'
			 , FORMULARZ='$formularzDef'
	");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}

	mysqli_query($link,"
		alter table dokumenty add ID_S int(11) not null default -1
	");

}
