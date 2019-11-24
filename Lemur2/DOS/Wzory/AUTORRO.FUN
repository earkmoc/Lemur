Esc|Esc |won:=.t.|
U|Usu¤ |Kasuj('usuwasz t† pozycj‘')|
S|Szukaj |SysMySeek('',nr)|
X|X=Sortuj |CreateIndex(kolumny[nr])|
W|Wydruk |Drukuj()|
L|Lista |Drukuj(if(Alarm('Tylko bie§†cy autor?',tk)=1,'AUTORRO1','AUTORROl'))|
F|Formularz |NewSysForm('AUTORRO,Dane bie§†cej pozycji,,,,,,,3')|
Y|Y=generuj rachunki |AutorRoY()|
D|Dopisz=ENTER|NewSysDopisz('AUTORRO,Nowa pozycja,,,73,AutorRoSet(),,,2',,,"(baza)->ID:=GetLast(1,1)+1,(baza)->DATA_W:=Date(),(baza)->DATA_2:=Date()-1")|
ENTER||NewSysDopisz('AUTORRO,Nowa pozycja,,,73,AutorRoSet(),,,2',,,"(baza)->ID:=GetLast(1,1)+1,(baza)->DATA_W:=Date(),(baza)->DATA_2:=Date()-1")|
