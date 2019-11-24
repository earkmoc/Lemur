Esc|Esc |won:=.t.|
P|Pozycje |SubBase("SPEC,"+if(BLOKADA=' ','specz','spec')+'rw.txt'+",ROBOCZY,1,DOKUM->ID,DOKUM->ID=ID_D,")|
U|Usu¤ |if(BLOKADA=' ',Alarm('Dokument zamkni‘ty'),Kasuj('usuwasz t† pozycj‘','DOKTYPY->(DokIncNr(DOKUM->TYP,Val(DOKUM->INDEKS)))','SkasujRec("SPEC"%"1"%"(baza)->ID"%"(baza)->ID==ID_D")'))|
S|Szukaj |SysMySeek('2,2,3,5,7,3,16,4',nr)|
X|X=Sort |CreateIndex(kolumny[nr])|
Z|Zamknij |DokClose('DOKUM,Zamkni‘cie dokumentu,,,,,,,29')|
W|Wydruk |RunMenu(49,,1,1)|
R|Rozlicz |DBSkip(1),globalbuf:=RecNo(),DBSkip(-1),NewSysForm('DOKUMR,Rozliczenie bie§†cej pozycji,,,73,SetNaleznosci(),,,4'),DBGoTo(globalbuf),DBSkip(-1)|
M|Mark |Mark('DOKUMZ',ID)|
F|Formularz |NewSysForm('DOKUM,Dane bie§†cej pozycji,,,,,,,16',BLOKADA=" ")|
D|Dopisz=ENTER|UGBT(),NewSysDopisz('DOKUM,Nowa pozycja,,,73,DIN("Q"),,,5',,,'AppendRecord("DOKUM",{GetLast(1,1)+1,"O",globalbuf,,-1,,Date(),Date(),Date(),Date(),PadR("przelew/got¢wka",20),,,,,,,,,,,,"incydental","N",,,,,,,,-1},1)')|
ENTER||UGBT(),NewSysDopisz('DOKUM,Nowa pozycja,,,73,DIN("Q"),,,5',,,'AppendRecord("DOKUM",{GetLast(1,1)+1,"O",globalbuf,,-1,,Date(),Date(),Date(),Date(),PadR("przelew/got¢wka",20),,,,,,,,,,,,"incydental","N",,,,,,,,-1},1)')|
I||Indeks({'Typ dokumentu','Data sprzeda§y','Kontrahent','Rozliczenia','kolejnož wprowadzania danych'},{2,3,4,6,0})
O||DokClose(,1)|
Q||SubBase("SPEC,"+if(BLOKADA=' ','specz','spec')+'.txt'+",ROBOCZY,1,DOKUM->ID,DOKUM->ID=ID_D,"),LastZero(90)|
