Esc|Esc|won:=.t.|
S|Szukaj|SysMySeek('',nr)|
X|X=Sortuj|CreateIndex(kolumny[nr])|
I||Indeks({'ID podmagazynu','ID towaru + ID podmagazynu','ID towaru + cena + ID podmagazynu','kolejnož wprowadzania danych'},{1,2,3,0})|
U|Usu¤|Kasuj('usuwasz t† pozycj‘')|
N|Netto|AktCZVAT()|
C|Czyž|globalbuf:=ID,if(Alarm('Usun† analityk‘ bie§†cego kontrahenta ?',nt)=2,DBEBD('ID',globalbuf),)|
Z|Zera|if(Alarm('Usun† analityki z zerowymi stanami ?',nt)=2,DBEBD('ILOSC',0),)|
A|Aktualizacja MZ|AktMZ('Aktualizacja magazynu zbiorczego wed’ug podmagazyn¢w ?')|
ENTER|Dokumenty=ENTER|SubBase("SPEC,specm.txt,ROBOCZY,2,MAGAZYNY->ID_T,MAGAZYNY->ID_T=ID_T,,,,,,,,DokFor()",,,,,'CreateIndex(kolumny[4],,1),DBGoTop()')|
D||SubBase("SPEC,specm.txt,ROBOCZY,2,MAGAZYNY->ID_T,MAGAZYNY->ID_T=ID_T,,,,,,,,DokFor()",,,,,'CreateIndex(kolumny[4],,1),DBGoTop()')|
1||SubBase("SPEC,specm.txt,ROBOCZY,2,MAGAZYNY->ID_T,MAGAZYNY->ID_T=ID_T,,,,,,,,DokFor("+Str(CENA_Z)+')',,,,,'CreateIndex(kolumny[4],,1),DBGoTop()')|
Q||Blokuj_R(),MAGAZYNY->ILOSC:=0,OdBlokuj_R(),PressKey('d¢’'),wy:=2|
