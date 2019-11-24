Esc|Esc-wyjžcie|SumSub('FIRMY','4','26')|
S|Szukaj|SysMySeek('',nr)|
T|Total|TotDBES()|
W|Wydruk|Drukuj('dokza')|
F|Formularz|NewSysForm('DOKZA,Dane bie§†cej pozycji')|
U|Usu¤|Kasuj()|
D|Dopisz=Enter|NewSysDopisz('DOKZA,Nowa pozycja,,,,,,,3',,,"ROB->ID_F:=FIRMY->ID_F,ROB->ID:=ROB->(GetLast(2,2)+1),ROB->DATAW:=Date()")|
Enter||NewSysDopisz('DOKZA,Nowa pozycja,,,,,,,3',,,"ROB->ID_F:=FIRMY->ID_F,ROB->ID:=ROB->(GetLast(2,2)+1),ROB->DATAW:=Date()")|
