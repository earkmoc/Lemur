Esc|Esc|won:=.t.|
U|Usu¤|Kasuj('usuwasz t† pozycj‘')|
S|Szukaj|SysMySeek('',nr)|
X|X=Sortuj|CreateIndex(kolumny[nr])|
W|Wydruk|Drukuj()|
L|Lista|Drukuj(if(Alarm('Tylko bie§†cy autor?',tk)=1,'autorzy1','autorzyl'))|
F|Formularz|NewSysForm('AUTORZY,Dane bie§†cej pozycji,,,,,,,3')|
D|Dopisz=ENTER|NewSysDopisz('AUTORZY,Nowa pozycja,,,73,AutorzySet(),,,2',,,'AppendRecord("AUTORZY",{GetLast(1,1)+1,,,,,,Date(),Date(),Date(),Date(),Date(),,50,,,18},1)')|
ENTER||NewSysDopisz('AUTORZY,Nowa pozycja,,,73,AutorzySet(),,,2',,,'AppendRecord("AUTORZY",{GetLast(1,1)+1,,,,,,Date(),Date(),Date(),Date(),Date(),,50,,,18},1)')|
