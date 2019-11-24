Esc|Esc |won:=.t.|
D|Dopisz |NewSysDopisz('KSIEGA,Nowa pozycja,,,,,,,2',,,"KSIEGA->LP:=PopRec('LP')+1,KSIEGA->DEKRETY:='',KSIEGA->DATA:=Date()")|
 C|Copy |NewSysDopisz('KSIEGA,Nowa pozycja,,,,,,,2',1,,"KSIEGA->LP:=PopRec('LP')+1,KSIEGA->DEKRETY:='',KSIEGA->DATA:=Date()")|
U|Usu§ |UsunDz('usuwasz tÜ pozycjë')|
A|Anuluj |Blokuj_R(),KSIEGA->ANULOWANO:=!ANULOWANO,LastZero(24)|
R|Ren |Renum('DATA','LP','Data')|
S|Szukaj |Szukaj(nr)|
X|X=Sortuj |CreateIndex(kolumny[nr])|
W|Wydruki |RunMenu(16,,1,,'Wybierz wariant wydruku :',1)|
I|Import |RunMenu(17,,1,,'Wybierz wariant importu :')|
F|Formularz=ENTER |FormDz('KSIEGA,Formularz danych,,,,,,,2')|
            ENTER||FormDz('KSIEGA,Formularz danych,,,,,,,2')|
P|PK |Drukuj('ksiegap')|
TAB||Znacz('NRDOW')|
~||DBZap('Wyczyûciç tabelë ?')|
!||Opis('impRSKPN.txt')|
@||Opis('impRZKON.txt')|
