Esc|Esc-wyjžcie|SumSub('ANALIZAR','5,-5','3,4')|
S|Szukaj|SysMySeek('',nr)|
T|Total|TotDBES()|
W|Wydruk|Drukuj('dokzal')|
F|TAB=Formularz|NewSysForm('DOKZA,Dane bie§†cej pozycji')|
TAB||NewSysForm('DOKZA,Dane bie§†cej pozycji')|
D|Dopisz=Enter|NewSysDopisz('DOKZA,Nowa pozycja,,,,,,,3',,,"ROB->ID_F:=ANALIZAR->ID_F,ROB->ID_D:=ANALIZAR->ID_D,ROB->ID:=ROB->(GetLast(2,2)+1),ROB->DATAW:=Date()")|
Enter||NewSysDopisz('DOKZA,Nowa pozycja,,,,,,,3',,,"ROB->ID_F:=ANALIZAR->ID_F,ROB->ID_D:=ANALIZAR->ID_D,ROB->ID:=ROB->(GetLast(2,2)+1),ROB->DATAW:=Date()")|
