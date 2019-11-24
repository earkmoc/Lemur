Esc|Esc|Zwolnij('TOWARY',1),won:=.t.|
Z|Znak|Mark('TOWARYZ',ID)|
T|Transfer|Transfer('STAROCIE','TOWARY','TOWARYZ','ID')|
S|Szukaj|SysMySeek('2,2,3,3',nr)|
X|X=Sortuj|CreateIndex(kolumny[nr])|
I|Indeks|Indeks({ 'LP', 'Indeks', 'Nazwa' })|
W|Wydruk|Drukuj()|
O|dOkumenty|SubBase("SPEC,spect.txt,ROBOCZY,2,TOWARY->ID,TOWARY->ID=ID_T,,,,,,,,ID_D>0",,,,,"CreateIndex(kolumny[6],,1),DBGoTop()")|
P|Podmagazyny|SubBase("MAGAZYNY,magazynt.txt,ROBOCZY,2,Str(TOWARY->ID),TOWARY->ID=ID_T",,,,,"CreateIndex(kolumny[6],,1),DBGoTop()")|
F|Formularz|NewSysForm('TOWARY,Dane bie§†cej pozycji')|
