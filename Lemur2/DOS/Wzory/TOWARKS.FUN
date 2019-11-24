Esc|Esc|AktISBN(),won:=.t.|
U|Usu¤|Kasuj('usuwasz t† pozycj‘','TOWARK->WARTOSC:=TOWARK->WARTOSC-(baza)->(Grosz(CENA*NAKLAD))')|
S|Szukaj|SysMySeek('',nr)|
X|X=Sortuj|CreateIndex(kolumny[nr],,1)|
F|Formularz|NewSysForm('TOWARKS,Dane bie§†cej pozycji,73,TOWARK->WARTOSC:=TOWARK->WARTOSC-(baza)->(Grosz(CENA*NAKLAD)),73,TOWARK->WARTOSC:=TOWARK->WARTOSC+(baza)->(Grosz(CENA*NAKLAD)),,,11')|
D|Dopisz=ENTER|NewSysDopisz('TOWARKS,Nowa pozycja,,,73,TOWARK->WARTOSC:=TOWARK->WARTOSC+(baza)->(Grosz(CENA*NAKLAD)),,,6',.t.,,"(baza)->ID:=GetLast(1,1)+1,(baza)->ID_K:=TOWARK->ID,(baza)->DATA:=Date(),(baza)->RZUT:=(baza)->RZUT+1")|
ENTER||NewSysDopisz('TOWARKS,Nowa pozycja,,,73,TOWARK->WARTOSC:=TOWARK->WARTOSC+(baza)->(Grosz(CENA*NAKLAD)),,,6',.t.,,"(baza)->ID:=GetLast(1,1)+1,(baza)->ID_K:=TOWARK->ID,(baza)->DATA:=Date(),(baza)->RZUT:=(baza)->RZUT+1")|
