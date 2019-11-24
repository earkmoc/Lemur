Esc|Esc-wyjžcie |won:=.t.|
S|Szukaj |SysMySeek('2,2,3,5,7,3,13,4',nr)|
X|X=Sort |CreateIndex(kolumny[nr],,1)|
W|Wydruk |Drukuj(if(Alarm('Tylko nierozliczone?',tk)=1,'dokuml','dokuml3') + if(Alias()="ROB",'r',''))|
L|Lista|if((globalbuf2:=Get_U(10,10,'Podaj rok rozliczenia:','9999',Year(Date())-1))=NIL,,Drukuj('dokuml4'))|
M|M |if((globalbuf2:=Get_U(10,10,'Podaj rok rozliczenia:','9999',Year(Date())-1))=NIL,,if((globalbuf3:=Get_U(10,10,'Podaj miesi†c rozliczenia:','99',12))=NIL,,Drukuj('dokuml6')))|
F|Formularz |NewSysForm('DOKUM,Dane bie§†cej pozycji,,,,,,,13',.t.)|
P|Pozycje |SubBase("SPEC,specz2.txt,BUFOR,1,ROB->ID,ROB->ID=ID_D,",.t.,,,6)|
R|Rozlicz=Enter |DBSkip(1),globalbuf:=RecNo(),DBSkip(-1),NewSysForm('DOKUMR,Rozliczenie bie§†cej pozycji,,,73,SetNaleznosci(),,,4'),DokumSetRoz(),DBGoTo(globalbuf),DBSkip(-1)|
Enter||          DBSkip(1),globalbuf:=RecNo(),DBSkip(-1),NewSysForm('DOKUMR,Rozliczenie bie§†cej pozycji,,,73,SetNaleznosci(),,,4'),DokumSetRoz(),DBGoTo(globalbuf),DBSkip(-1)|
T|Total |TotDBES()|
I||Indeks({'Typ dokumentu','Data sprzeda§y','Kontrahent','Rozliczenia','kolejnož wprowadzania danych'},{2,3,4,6,0})
Z||SubBase("DOKSPL,dokspl.txt,BUFOR,1,Str(FIRMY->ID_F)+Str(ROB->ID),FIRMY->ID_F=ID_F.and.ROB->ID=ID_D,",.t.,,,6),DokumSetRoz()|
