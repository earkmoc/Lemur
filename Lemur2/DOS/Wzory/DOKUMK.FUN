Esc|Esc-wyjûcie |SumSub('FIRMY','-WARTOSC+WPLACONO','KOREKTY',,'!("K"$TYP)')|
S|Szukaj |SysMySeek('2,2,3,5,7,3,13,4',nr)|
X|X=Sort |CreateIndex(kolumny[nr])|
W|Wydruk |Drukuj('dokuml5')|
F|Formularz |NewSysForm('DOKUM,Dane bießÜcej pozycji,,,,,,,13',BLOKADA=" ")|
P|Pozycje |SubBase("SPEC,specz2.txt,BUFOR,1,ROB->ID,ROB->ID=ID_D,",.t.,,,6)|
R|Rozlicz=Enter |DBSkip(1),globalbuf:=RecNo(),DBSkip(-1),NewSysForm('DOKUMR,Rozliczenie bießÜcej pozycji,,,73,DokumSetRoz(),,,4'),DBGoTo(globalbuf),DBSkip(-1)|
T|Total |TotDBES()|
Z|Zapíaty|SubBase("DOKSPL,dokspl.txt,BUFOR,1,Str(FIRMY->ID_F)+Str(ROB->ID),FIRMY->ID_F=ID_F.and.ROB->ID=ID_D,",.t.,,,6),DokumSetRoz()|
Enter||DBSkip(1),globalbuf:=RecNo(),DBSkip(-1),NewSysForm('DOKUMR,Rozliczenie bießÜcej pozycji,,,73,DokumSetRoz(),,,4'),DBGoTo(globalbuf),DBSkip(-1)|
I||Indeks({'Typ dokumentu','Data sprzedaßy','Kontrahent','Rozliczenia','kolejnoûç wprowadzania danych'},{2,3,4,6,0})
