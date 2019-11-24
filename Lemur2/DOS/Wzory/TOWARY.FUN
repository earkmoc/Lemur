Esc|Esc=wyjžcie |won:=.t.|
S|Szukaj |SysMySeek('1,3',nr)|
X|X=Sortuj |CreateIndex(kolumny[nr])|
I|Indeks |Indeks({ 'LP', 'Indeks', 'Nazwa' })|
O|dOkumenty |SubBase("SPEC,spect.txt,ROBOCZY,2,TOWARY->ID,TOWARY->ID=ID_T,,,,,,,,ID_D>0",,,,,"CreateIndex(kolumny[6],,1),DBGoTop()")|
P|Podmagazyny |SubBase("MAGAZYNY,magazynt.txt,ROBOCZY,2,Str(TOWARY->ID),TOWARY->ID=ID_T",,,,,"CreateIndex(kolumny[6],,1),DBGoTop()")|
W|Wydruki |if((globalbuf:=Alarm('Wybierz wariant:',{'Cennik','Magazyn','Magazynu minus MG', 'MG'}))=1,if(NIL=(globalbuf:=Get_U(10,10,'Podaj rabat:','999.99%',0)),,PressKey('!')),Drukuj('towary'+AllS(globalbuf)))|
F|Formularz |NewSysForm('TOWARY,Dane bie§†cej pozycji')|
T|Totalizer |TotDBES()|
Z|Zaznacz do cennika |Mark('TOWARYZN',ID)|
D|Dopisz=ENTER |if(NewSysDopisz('TOWARY,Nowa pozycja',,,"TOWARY->ID:=GetLast(1,1)+1,TOWARY->JM:=PadR('egz.',10),TOWARY->SWW:=PadR('58.11.1',15)"),PLID(TOWARY->ID),)|
ENTER||if(NewSysDopisz('TOWARY,Nowa pozycja',,,"TOWARY->ID:=GetLast(1,1)+1,TOWARY->JM:=PadR('egz.',10),TOWARY->SWW:=PadR('58.11.1',15)"),PLID(TOWARY->ID),)|
~||if(NIL=(globalbuf:=Get_U(10,10,'Podaj rabat:','999.99%',0)),,PressKey('!'))|
!||if(NIL=(globalbuf1:=Get_U(10,10,'Podaj numer cennika:','9',1)),,Drukuj('towaryce'))|
TAB|TAB=poka§ nazw‘|CSay(0,0,Len(NAZWA),NAZWA,jasny)|
