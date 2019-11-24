Esc|Esc |won:=.t.|
S|Szukaj |Szukaj(nr)|
X|X=Sortuj |CreateIndex(kolumny[nr])|
T|Total |ShowDBES()|
W|Wydruk |Drukuj()|
L|Lista |Drukuj('ANALIZAT')|
G|Generuj |GenDOKSPL()|
R|Tab=Rozl. |SubBase("DOKSPL,doksplr.txt,BUFOR,1,Str(ANALIZAR->ID_F)+Str(ANALIZAR->ID_D),ANALIZAR->ID_F=ID_F.and.ANALIZAR->ID_D=ID_D,",.t.),DokumSetRoz(ANALIZAR->ID_D,ANALIZAR->WPLATY)|
A|Aktualizuj=ENTER |DokAnaR('ANALIZA6,Podaj parametry procedury,,,,,,,3','FV,RU,FVK,RUK','Zap’aty')|
             ENTER||DokAnaR('ANALIZA6,Podaj parametry procedury,,,,,,,3','FV,RU,FVK,RUK','Zap’aty')|
Tab||SubBase("DOKSPL,doksplr.txt,BUFOR,1,Str(ANALIZAR->ID_F)+Str(ANALIZAR->ID_D),ANALIZAR->ID_F=ID_F.and.ANALIZAR->ID_D=ID_D,",.t.),DokumSetRoz(ANALIZAR->ID_D,ANALIZAR->WPLATY)|
P|Pozycje |SubBase("SPEC,specz.txt,ROBOCZY,1,ANALIZAR->ID_D,ANALIZAR->ID_D=ID_D,")|
