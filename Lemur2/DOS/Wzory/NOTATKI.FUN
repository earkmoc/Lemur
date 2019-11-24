Esc|Esc=wyjžcie|won:=.t.|
U|Usu¤|Kasuj('usuwasz t† pozycj‘')|
S|Szukaj|SysMySeek('',nr)|
X|X=Sortuj|CreateIndex(kolumny[nr])|
F|Formularz|NewSysForm('NOTATKI,Dane bie§†cej pozycji,,,73,if(wynik.and.((baza)->(Blokuj_R())=NIL)%(baza)->DATAM:=Date()%NIL)')|
T|Trež|Blokuj_R(),NOTATKI->TRESC:=Edit(NOTATKI->TRESC,NOTATKI->NAZWA,1),OdBlokuj_R()|
D|Dopisz=Enter|NewSysDopisz('NOTATKI,Nowa notatka',,,"(baza)->DATAW:=Date(),(baza)->DATAM:=Date()")|
Enter||NewSysDopisz('NOTATKI,Nowa notatka',,,"(baza)->DATAW:=Date(),(baza)->DATAM:=Date()")|
