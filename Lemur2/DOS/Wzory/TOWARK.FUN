Esc|Esc|won:=.t.|
U|Usu¤|Kasuj('usuwasz t† pozycj‘','SkasujRec("TOWARKS"%"1"%"Str((baza)->ID)"%"(baza)->ID==ID_K")')|
S|Szukaj|SysMySeek('',nr)|
X|X=Sortuj|CreateIndex(kolumny[nr])|
W|Wydruk|Drukuj()|
P|Pozycje|SubBase("TOWARKS,towarks.txt,ROBOCZY,1,Str(TOWARK->ID),TOWARK->ID=ID_K,")|
F|Formularz|NewSysForm('TOWARK,Dane bie§†cej pozycji,,,,,,,15')|
D|Dopisz=ENTER|NewSysDopisz('TOWARK,Nowa pozycja,,,,,,,3',,,"TOWARK->ID:=GetLast(1,1)+1,TOWARK->DATA_ZU:=Date(),TOWARK->DATA_WU:=Date(),TOWARK->DATA_OR:=Date()")|
ENTER||NewSysDopisz('TOWARK,Nowa pozycja,,,,,,,3',,,"TOWARK->ID:=GetLast(1,1)+1,TOWARK->DATA_ZU:=Date(),TOWARK->DATA_WU:=Date(),TOWARK->DATA_OR:=Date()")|
A|Akt.ISBN|AktISBNs()|
