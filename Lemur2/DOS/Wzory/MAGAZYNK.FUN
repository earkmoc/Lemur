Esc|Esc-wyjžcie|won:=.t.|
S|Szukaj|SysMySeek('',nr)|
X|X=Sort |CreateIndex(kolumny[nr],,1)|
W|Wydruk|Drukuj('magazynk')|
D|Do inwentaryzacji|Wydruk('magazyns.wyd')|
T|Total|TotDBES()|
ENTER|dOkumenty=ENTER|SubBase("SPEC,specm.txt,BUFOR,2,ROB->ID_T,ROB->ID_T=ID_T,,,,,,,,DokFor(-99)",.t.,,,6,'CreateIndex(kolumny[4],,1),DokKond()')|
O||SubBase("SPEC,specm.txt,BUFOR,2,ROB->ID_T,ROB->ID_T=ID_T,,,,,,,,DokFor(-99)",.t.,,,6,'CreateIndex(kolumny[4],,1),DokKond()')|
