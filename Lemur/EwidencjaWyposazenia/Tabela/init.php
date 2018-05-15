<?php

$struktura=AddSlashes("
create table if not exists $tabela
(ID int(11) NOT NULL auto_increment
,ID_D int(11) NOT NULL DEFAULT -1
,KTO int(11) NOT NULL DEFAULT 0
,CZAS datetime NOT NULL DEFAULT '0000-00-00 00:00:00'
,LP int(11) NOT NULL default 0
,DATANABYCIA date not null DEFAULT '0000-00-00'
,NUMERDOK char(30) not null default ''
,NAZWA text not null default ''
,CENA decimal(15,2) not null default 0
,NUMERPOZ int(11) NOT NULL default 0
,DATALIKWIDACJI date not null DEFAULT '0000-00-00'
,PRZYCZYNA text not null default ''
,PRIMARY KEY (ID)
,INDEX (ID_D)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1
");

if(!mysqli_fetch_row(mysqli_query($link,$q="
	select count(*)
	  from Lemur2.tabele
	 where NAZWA='$widok'
	"))[0])
{
	if(isset($id_d))
	{
		$tabelaDef="$tabela
ID|ID|0|
LP|LP
DATANABYCIA|Data Nabycia|@Z
NUMERDOK|Numer dokumentu
NAZWA|Nazwa|
CENA|Cena (koszt)|@Z+|style=\"text-align:right\"|
NUMERPOZ|Numer wpisu|@Z|
DATALIKWIDACJI|Data likwidacji|@Z
PRZYCZYNA|Przyczyna likwidacji
KTO|Kto|@s|
CZAS|Kiedy|@s|
from $tabela
order by LP*1";

		$formularzDef="$tabela
DATANABYCIA|Data Nabycia|10||2|1|
NUMERDOK|Numer dokumentu|30||2|1|
NAZWA|Nazwa|99/1||4|1|
CENA|Cena (koszt)|@Z10|right|2|1|
NUMERPOZ|Numer wpisu|@Z10|right|2|1|
DATALIKWIDACJI|Data likwidacji|10||2|2|
PRZYCZYNA|Przyczyna likwidacji|99/1||10|2|
from ewidwypo
where ID=";
	}
	else
	{
		$tabelaDef="$tabela
ID|ID|0|
LP|LP
DATANABYCIA|Data Nabycia|@Z
NUMERDOK|Numer dokumentu
NAZWA|Nazwa
CENA|Cena (koszt)|@Z+|style=\"text-align:right\"|
NUMERPOZ|Numer wpisu|@Z|
DATALIKWIDACJI|Data likwidacji|@Z
PRZYCZYNA|Przyczyna likwidacji
ID_D|ID_D|@s|
KTO|Kto|@s|
CZAS|Kiedy|@s|
from $tabela
order by LP*1";

		$formularzDef="$tabela
DATANABYCIA|Data Nabycia|10|
NUMERDOK|Numer dokumentu|30|
NAZWA|Nazwa|99/5|
CENA|Cena (koszt)|@Z10|right|
NUMERPOZ|Numer wpisu|@Z10|right|
DATALIKWIDACJI|Data likwidacji|10|
PRZYCZYNA|Przyczyna likwidacji|99/5|
from $tabela
where ID=";
	}
	
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
}

