Esc|Esc-wyjûcie |won:=.t.|
S|Szukaj |SysMySeek('2,2,3,5,7,3,13,4',nr)|
X|X=Sort |CreateIndex(kolumny[nr],,1)|
W|Wydruk |Drukuj(if(Alarm('Tylko nierozliczone?',tk)=1,'dokuml','dokuml3') + if(Alias()="ROB",'r',''))|
L|Lista|if((globalbuf2:=Get_U(10,10,'Podaj rok rozliczenia:','9999',Year(Date())-1))=NIL,,Drukuj('dokuml7'))|
M|M |if((globalbuf2:=Get_U(10,10,'Podaj rok rozliczenia:','9999',Year(Date())-1))=NIL,,if((globalbuf3:=Get_U(10,10,'Podaj miesiÜc rozliczenia:','99',12))=NIL,,Drukuj('dokuml8')))|
F|Formularz |NewSysForm('DOKUM,Dane bießÜcej pozycji,,,,,,,13',.t.)|
A|Aktualizacja=Enter |KontrUzup()|
Enter||KontrUzup()|
T|Total|TotDBES()|
I||Indeks({'Typ dokumentu','Data sprzedaßy','Kontrahent','Rozliczenia','kolejnoûç wprowadzania danych'},{2,3,4,6,0})
