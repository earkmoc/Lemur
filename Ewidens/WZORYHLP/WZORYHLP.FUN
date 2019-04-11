Esc|Esc |DBEFiltr('SIZE#0, ( istniej†ce )',,,1),won:=.t.|
S|Szukaj |MySeek(nr,{1,2},{1,2})|
X|X=Sortuj |CreateIndex(kolumny[nr])|
A|Aktualizacja |AktWzory()|
I|Indeks |SysIndeks('Nazwa,1,Baza+nazwa,2,Extension,3,natura,0')|
.1|1|globalbuf:=BASE,DBSkip(),Blokuj_R(),WZORYHLP->BASE:=globalbuf,OdBlokuj_R()|
.2|2|globalbuf:=OPIS,DBSkip(),Blokuj_R(),WZORYHLP->OPIS:=globalbuf,OdBlokuj_R()|
.3|3|globalbuf:=NAME,Blokuj_R(),WZORYHLP->BASE:=Left(globalbuf,At('.',globalbuf)-1),OdBlokuj_R(),PressKey('d¢’')|
.4|4|globalbuf:=NAME,Blokuj_R(),WZORYHLP->OPIS:=MemoLine(ReadWzor(globalbuf),254,5),OdBlokuj_R()|
.5|5|globalbuf:=NAME,Blokuj_R(),WZORYHLP->OPIS:=MemoLine(ReadWzor(globalbuf),254,1),OdBlokuj_R()|
.6|6|globalbuf:=NAME,Blokuj_R(),globalbuf:=MemoLine(ReadWzor(globalbuf),254,1),globalbuf:=Substr(globalbuf,33),globalbuf:=Substr(globalbuf,1,At(',',globalbuf)-1),WZORYHLP->OPIS:='Definicja '+globalbuf,OdBlokuj_R()|
.7|7|globalbuf:=NAME,Blokuj_R(),globalbuf:=MemoLine(ReadWzor(globalbuf),254,1),globalbuf:=Substr(globalbuf,At(',',globalbuf)+1),globalbuf:=Substr(globalbuf,1,At(',',globalbuf)-1),WZORYHLP->OPIS:=globalbuf,OdBlokuj_R()|
.8|8|Blokuj_R(),WZORYHLP->OPIS:='Definicja struktury bazy danych',OdBlokuj_R(),PressKey('d¢’')|
.9|9|Blokuj_R(),WZORYHLP->OPIS:='Definicja wydruku',OdBlokuj_R(),PressKey('d¢’')|
.0|0|Blokuj_R(),WZORYHLP->OPIS:='Definicja tabeli "' + Alltrim(WZORYHLP->OPIS) + '"',OdBlokuj_R(),PressKey('d¢’')|
.B|B|Blokuj_R(),WZORYHLP->OPIS:='Definicja funkcji tabeli',OdBlokuj_R(),PressKey('d¢’')|
.C|C|Blokuj_R(),WZORYHLP->OPIS:='Parametry tabeli',OdBlokuj_R(),PressKey('d¢’')|
.D|D|Blokuj_R(),WZORYHLP->OPIS:='Parametry wydruku przez Windows',OdBlokuj_R(),PressKey('d¢’')|
.F|F|Blokuj_R(),WZORYHLP->OPIS:='Plik prze’†cznikowy',OdBlokuj_R(),PressKey('d¢’')|
.G|G|Blokuj_R(),WZORYHLP->OPIS:='Plik systemowy',OdBlokuj_R(),PressKey('d¢’')|
.H|H|Blokuj_R(),WZORYHLP->OPIS:='Definicja wydruku "' + Alltrim(WZORYHLP->OPIS) + '"',OdBlokuj_R(),PressKey('d¢’')|
.Z|Z|DBEFiltr('SIZE#0, ( istniej†ce )')|
.P| Popraw |Popraw(Str(nr,2))|
E|Edycja=Enter|ne_edit:=.t.,Opis(NAME)|
Enter||ne_edit:=.t.,Opis(NAME)|
.~||RunCommand('run del '+cat_wzorow+NAME),BDelete(),wy:=2|
