Esc|Esc - wyjžcie|won:=.t.|
S|Szukaj|Szukaj(nr)|
X|X=Sortuj|CreateIndex(kolumny[nr])|
T|Total|ShowDBES()|
W|Wydruk|RunMenu(51,,1,1)|
A|Aktualizacja=ENTER|Zwolnij(baza),ON(baza),DokAna4('ANALIZA4,Podaj parametry procedury,,,,,,,3','FV,RU,FVK,RUK','Sprzeda§ ’†czna tytu’¢w',' (užredniana cena sprzeda§y)','PWX','RWX','FZ,FZK',''),Jest_baza('ANALIZA4'),CreateIndex(kolumny[1]),DBGoTop()|
              ENTER||Zwolnij(baza),ON(baza),DokAna4('ANALIZA4,Podaj parametry procedury,,,,,,,3','FV,RU,FVK,RUK','Sprzeda§ ’†czna tytu’¢w',' (užredniana cena sprzeda§y)','PWX','RWX','FZ,FZK',''),Jest_baza('ANALIZA4'),CreateIndex(kolumny[1]),DBGoTop()|
B|Bez zaplat|Zwolnij(baza),ON(baza),DokAna4('ANALIZA4a,Podaj parametry procedury,,,,,,,3','FV,RU,FVK,RUK','Sprzeda§ ’†czna tytu’¢w',' (užredniana cena sprzeda§y)','PWX','RWX','FZ,FZK',''),Jest_baza('ANALIZA4'),CreateIndex(kolumny[1]),DBGoTop()|
          ~||x:=ID_T,Zwolnij(baza),ON(baza),DokAna4('ANALIZA4,Podaj parametry procedury,,,,,,,3','FV,RU,FVK,RUK','Sprzeda§ ’†czna tytu’¢w',' (užredniana cena sprzeda§y)','PWX','RWX','FZ,FZK','',x),Jest_baza('ANALIZA4'),CreateIndex(kolumny[1]),DBGoTop()|
pozycja||CSay(mr-1,1,mc,TOWARY->(GetPole(-1,'ANALIZA4->ID_T','NAZWA','TOWARY',,,1,,,'STAROCIE\TOWARY')),jasny)|
