Esc|Esc|won:=.t.|
U|Usu¤|Kasuj('usuwasz t† pozycj‘')|
S|Szukaj|SysMySeek('',nr)|
X|X=Sortuj|CreateIndex(kolumny[nr])|
W|Wydruk|Drukuj(if(Alarm('Wydruk umowy ?',tk)=1,'UMOWYZLE','UMOWYZLR')),Jest_baza(baza)|
L|Lista|Drukuj(if(Alarm('Tylko bie§†cy kontrahent?',tk)=1,'UMOWYZL1','UMOWYZLl'))|
F|Formularz|NewSysForm('UMOWYZLE,Dane bie§†cej pozycji,,,,,,,4')|
D|Dopisz=ENTER|NewSysDopisz('UMOWYZLE,Nowa pozycja,,,,,,,2',,,'AppendRecord("UMOWYZLE",{GetLast(1,1)+1,-1,Date(),Date(),Date(),,,,,20,,,18},1)')|
ENTER||NewSysDopisz('UMOWYZLE,Nowa pozycja,,,,,,,2',,,'AppendRecord("UMOWYZLE",{GetLast(1,1)+1,-1,Date(),Date(),Date(),,,,,20,,,18},1)')|
