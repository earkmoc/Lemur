*******************************************************************************
*******************  Inicjowanie r¢ßnych typ¢w dokument¢w  ********************
*******************************************************************************
#include 'Inkey.ch'

******************************************************************************

procedure ToExcel( gdzie )

local bb := Alias(), n, v, p, pko := KonwertON

private export := ' '

KonwertON := .t.

ON( 'DOKTYPY' ); DBSeek( DOKUM->TYP )
ON( 'SPEC_XLS',, 'c:\ARCHIWUM',, .t. )
ON( 'SPEC' )
DBSeek( DOKUM->ID )
while DOKUM->ID=ID_D .and. !Eof()
      SPEC_XLS->( DBAppend())
      SPEC_XLS->INDEKS := TOWARY->(GetPole(1,'SPEC->ID_T','INDEKS'))  && ','C',9,0})|
*      SPEC_XLS->DOSTAWCA','N',5,0})|
      SPEC_XLS->CENA_Z := TOWARY->CENA_Z        && ','N',8,2})|
      SPEC_XLS->CENA_S := SPEC->CENA            && ','N',8,2})|
      SPEC_XLS->ILOSC := SPEC->ILOSC            && ','N',11,3})|
p := if( DOKTYPY->( EXPORT ) == "T", 0, TOWARY->VAT )
      SPEC_XLS->VAT := p              && ','N',2,0})|
      SPEC_XLS->UPUST := SPEC->RABAT            && ','N',6,2})|
      SPEC_XLS->NAZWA := TOWARY->NAZWA          && ','C',60,0})|
      SPEC_XLS->JM := TOWARY->JM                && ','C',3,0})|
      SPEC_XLS->CENA_PUP := SPEC->CENABEZR      && ','N',8,2})|
      n := Grosz( ILOSC * CENA )
      v := Grosz( n * NVat( p ))
      SPEC_XLS->BRUTTO := n + v                 && ','N',15,2})|
*      SPEC_XLS->OSTRZEGAL','C',1,0})|
*      SPEC_XLS->ILOSCP','N',11,3})|
*      SPEC_XLS->STAN_M','N',11,3})|
*      SPEC_XLS->INDEKSP','C',9,0})|
*      SPEC_XLS->CENAP','N',8,2})|
*      SPEC_XLS->UPUSTP','N',6,2})|
*      SPEC_XLS->ILOSCPP','N',11,3})|
*      SPEC_XLS->UWAGI','C',20,0})|
*      SPEC_XLS->GR','C',3,0})|
      SPEC_XLS->SWW := TOWARY->SWW              && ','C',15,0})|
*      SPEC_XLS->PRODUCENT','C',12,0})|
      skip
enddo

Select( 'SPEC_XLS' )
go top
while !Eof(); Konw2({ 8 }); DBSkip(); enddo
Zwolnij( 'SPEC_XLS' )

ON( 'SLOW_XLS',, 'c:\ARCHIWUM' )
while LastRec() < 2; DBAppend(); enddo

goto 1
Blokuj_R()
replace POLE with Slownie(( 'DOKUM' )->WARTOSC,, 1 )
Konw2({ 1 })

goto 2
Blokuj_R()
replace POLE with Slownie(( 'DOKUM' )->WARTOSC,, 2 )
Konw2({ 1 })

Zwolnij( 'SLOW_XLS' )

ON( 'DOKU_XLS',, 'c:\ARCHIWUM' )
while LastRec() < 1; DBAppend(); enddo
Blokuj_R()
DOKU_XLS->NR_WZ := DOKUM->( AllTrim( INDEKS ))  && ','C',8,0})|
DOKU_XLS->ODBIORCA := DOKUM->NABYWCA            && ','N',5,0})|
*DOKU_XLS->WG_CEN :=                            && ','C',12,0})|
DOKU_XLS->DATA_FAKT := DOKUM->DATAS             && ','D',8,0})|
DOKU_XLS->ZAPLATA := DOKUM->SPOSOB              && ','C',7,0})|
DOKU_XLS->WYSTAWIL := DOKUM->WYSTAWIL           && ','C',18,0})|
*DOKU_XLS->WYDAL :=                             && ','C',18,0})|
DOKU_XLS->TERM_ZAPL := DOKUM->( DATAT - DATAS ) && ','N',2,0})|
DOKU_XLS->OGOLEM := DOKUM->WARTOSC              && ','N',10,2})|
DOKU_XLS->WRT_ZAKUP := DOKUM->NETTOCZ           && ','N',10,2})|
*DOKU_XLS->UPUST :=                             && ','N',9,6})|
DOKU_XLS->WART_NET0 := DOKUM->NETTO0            && ','N',10,2})|
DOKU_XLS->WART_NET7 := DOKUM->NETTO7            && ','N',10,2})|
DOKU_XLS->WART_VAT7 := DOKUM->VAT7              && ','N',10,2})|
DOKU_XLS->WART_NET22 := DOKUM->NETTO22          && ','N',10,2})|
DOKU_XLS->WART_VAT22 := DOKUM->VAT22            && ','N',10,2})|
DOKU_XLS->WART_NETZW := DOKUM->NETTOZW          && ','N',10,2})|
DOKU_XLS->WPLACONO := DOKUM->WPLACONO           && ','N',10,2})|
DOKU_XLS->DO_DOKUM := DOKUM->NUMERFD            && ','C',8,0})|
*DOKU_XLS->OTWARTY :=                           && ','C',1,0})|
*DOKU_XLS->BIORCA :=                            && ','N',5,0})|
*DOKU_XLS->DOK_KASY :=                          && ','C',8,0})|
*DOKU_XLS->DOK_FISK :=                          && ','C',8,0})|
DOKU_XLS->UPRAWNION := DOKUM->ODEBRAL           && ','C',50,0})|
*DOKU_XLS->DATA_O :=                            && ','D',8,0})|
*DOKU_XLS->CZAS_O :=                            && ','C',8,0})|
*DOKU_XLS->OSOBA_O :=                           && ','C',3,0})|
*DOKU_XLS->WGPARAGONU :=                        && ','N',10,2})|
*DOKU_XLS->DOK_ZAM :=                           && ','C',8,0})|
*DOKU_XLS->OGOLEM_PU :=                         && ','N',10,2})|
*DOKU_XLS->VATOWIEC :=                          && ','C',1,0})|
DOKU_XLS->NAZWA := DOKUM->NAZWA1                && ','C',28,0})|
DOKU_XLS->NAZWA_1 := DOKUM->NAZWA2              && ','C',28,0})|
DOKU_XLS->NAZWA_2 := DOKUM->NAZWA3              && ','C',28,0})|
*DOKU_XLS->NAZWA_3 :=                           && ','C',28,0})|
*DOKU_XLS->NAZWA_4 :=                           && ','C',28,0})|
DOKU_XLS->KOD_POCZT := DOKUM->KOD               && ','C',6,0})|
DOKU_XLS->MIEJSCOW := DOKUM->MIASTO             && ','C',23,0})|
DOKU_XLS->ADRES := DOKUM->ADRES                 && ','C',30,0})|
DOKU_XLS->NUMER_VAT := DOKUM->NIP               && ','C',20,0})|
DOKU_XLS->UWAGI := DOKUM->UWAGI                 && ','C',30,0})|
Konw2({ 6, 7, 24, 32, 33, 34, 35, 36, 38, 39 })
Zwolnij( 'DOKU_XLS' )

Select( bb )
KonwertON := pko

if gdzie = NIL
   Alarm( 'Teraz moßna uruchomiç Excela i wydrukowaç dokument.' )
else
   RunCommand( gdzie )
endif

******************************************************************************

procedure Konw2( tnr )

local i

Blokuj_R()
for i := 1 to Len( tnr )
    FieldPut( tnr[ i ], Konwert( FieldGet( tnr[ i ] ), maz, lat ))
next

*******************************************************************************

procedure MAGClose( dbo1, dbo2 )

d1 := CtoD( '31.12.' + Substr( Str( Year( Datee()) - 1 ), 3 )) + 1
d2 := Datee()

if ( NIL = Get_Okres( @d1, @d2, 'Usuwanie dokument¢w z okresu:' )); return; endif
if dbo1 # NIL
   if ( NIL = ( dtbo := Get_U( 10, 10, 'Nie bëdÜ usuniëte dokumenty "' + dbo1 + '" z dnia:', '99999999', d2 ))); return; endif
elseif dbo2 # NIL
   if ( NIL = ( dtbo := Get_U( 10, 10, 'Dodatkowo bëdÜ usuniëte dokumenty "' + dbo2 + '" z dnia:', '99999999', d1 - 1 ))); return; endif
endif

Czek( 1 )
ON( 'KONTRAKT' )
ON( 'DOKUMENT', 5 )
DBSeek( d1, .t. )
while DATA_Z <= d2 .and. !Eof()
      if dbo1 # NIL .and. TYP = dbo1 .and. DATA_Z = dtbo; skip; loop; endif
      Select( 'KONTRAKT' )
      DBSeek( DOKUMENT->KOD_WEW )
      while DOKUMENT->KOD_WEW == KOD_DOKUM .and. !Eof()
            BDelete()
            skip
      enddo
      Select( 'DOKUMENT' )
      BDelete()
      skip
enddo

if dbo2 # NIL

DBSeek( dtbo, .t. )
while DATA_Z = dtbo .and. !Eof()
   if TYP = dbo2
      Select( 'KONTRAKT' )
      DBSeek( DOKUMENT->KOD_WEW )
      while DOKUMENT->KOD_WEW == KOD_DOKUM .and. !Eof()
            BDelete()
            skip
      enddo
      Select( 'DOKUMENT' )
      BDelete()
   endif
   skip
enddo

endif

DBCommitAll()
Select( 'KONTRAKT' ); pack
Select( 'DOKUMENT' ); pack

Czek( 0 )

*******************************************************************************
* Nr 40

procedure Init_Dokument( a )

local d_typ := PadR( Odetnij( @a ), 3 ), d_nr

ON( 'DOKUMENT', 3 )
DBSeek( d_typ + '99999', .t. )
DBSkip( -1 )
if DOKUMENT->TYP == d_typ
   d_nr := AllTrim( Str( Val( NUMER ) + 1 ))
else
   d_nr := '1'
endif

DBAppend()
Init_DBF_Main( '' )

DOKUMENT->TYP := d_typ
DOKUMENT->NUMER := PadR( d_nr + prafix, Len( NUMER ))
DOKUMENT->DATA_Z := DATA

*******************************************************************************
* Nr 42.

procedure Dodaj_towar( nr, b )

local bb, sy, il, ok, rr, ma, zakryj

bb := Alias()
rr := RecNo()

*cena_systemu := if( b = NIL, 'CENA_1', b )

if nr = 1                     && wpisaliûmy symbol towaru
   Keyboard Chr( K_ENTER )    && wejûcie do wpisania iloûci
   ok := .f.
   sy := Upper( AllTrim( SYMBOL ))
   ON( 'MAGAZYNY', 3 )        && po symbolu
   if ( ok := DBSeek( sy, .t. ))
   else
      ON( 'MAGAZYNY', 5 )     && po nazwie
      if ok := DBSeek( sy, .t. )
         sy := Upper( AllTrim( SYMBOL ))
      endif
   endif
   if ok
      zakryj := 1
      ma := if( Empty( DOKUMENT->MAG1 ), DOKUMENT->MAG2, DOKUMENT->MAG1 )
      while Upper( Left( AllTrim( SYMBOL ), Len( sy ))) == sy .and. !Eof()
            if MAG == ma
               AppendRecord( 'KON_BUF', { KOD_WEW, SYMBOL, NAZWA, VAT, &cena_systemu, ILOSC }, zakryj )
               zakryj := NIL
            endif
            DBSkip()
      enddo
   else
      Alarm( 'Bíëdny symbol towaru !!!' )    && jeûli zíy symbol
      Keyboard 'Q'                             && to powt¢rz jego wpisanie
   endif
else
   DBSkip(); sy := SYMBOL; DBSkip( -1 )  && sp¢jrz na symbol nastëpnego towaru
   Keyboard if( Empty( sy ), Chr( K_HOME ), '' ) + Chr( K_DOWN ) + 'Q'
endif

Select( bb )
DBGoTo( rr )

******************************************************************************

procedure INC_MAG( kod, il, m_skad, m_dokad, przychod, nietr, mn )

local bb := Alias()

if mn = NIL
   if przychod = NIL
      if Empty( m_dokad ); mn := -1
      else; mn := 1
      endif
   else
      if nietr # NIL; mn := 1
      else
         if przychod; mn := 1
         else; mn := -1
         endif
      endif
   endif
endif

if  ( przychod = NIL .or.;
    ( przychod .and. Empty( m_skad )) .or. ;
    (!przychod .and. Empty( m_dokad))) .and.;
   Jest_Towar( kod, m_skad, m_dokad )
   MAGAZYNY->ILOSC += il * mn
   if nietr = NIL; MAGAZYNY->DATA_T := Datee(); endif
endif

Select( bb )

******************************************************************************

procedure Znakuj( a )

local sy := KOD_WEW

if WYBTOW->( DBSeek( sy ))  && odznaczenie
   WYBTOW->( BDelete())
else
   WYBTOW->( DBAppend())    && zaznaczenie
   WYBTOW->KOD_WEW := sy
endif

Keyboard Chr( K_DOWN )

******************************************************************************

function Znak( sy )
return if( WYBTOW->( DBSeek( sy )), '*', ' ' )

******************************************************************************
* Nr 46
* a - dla ViewDBF
* b - nazwa pola ceny pobieranej z magazynu

procedure WybierzTowary( a, b )

local bb := Alias(), rr := RecNo(), juz := .f.

*cena_systemu := if( b = NIL, 'CENA_1', b )

ON( 'WYBTOW' )
ON( 'WYBTOW',,,, .t. )
ViewDBF( a, .t. )      && wskazanie towar¢w

ON( 'MAGAZYNY', 2 )
Select( 'WYBTOW' )
DBSetOrder( 0 )
go top
while !Eof()
      if MAGAZYNY->( DBSeek( WYBTOW->KOD_WEW ))
         Select( 'MAGAZYNY' )
         AppendRecord( 'KON_BUF', { KOD_WEW, SYMBOL, NAZWA, VAT, &cena_systemu, ILOSC })
         if !juz
            juz := .t.
            rr := KON_BUF->( RecNo())
         endif
      endif
      Select( 'WYBTOW' )
      skip
enddo
Keyboard Chr( K_ENTER )
Select( bb )
wy := 2
DBGo( rr )

*****************************************************************************
* ce = NIL -> zerowanie

procedure INC_ROZ( ce, il, po )

local wn, kp

if ce = NIL
   store 0 to n22, n7, n0, nzw, v22, v7, sum_il, sum_ne, sum_va, sum_br
else
   wn := ce * il
   kp := wn * po * 0.01
   sum_il += il
   sum_ne += wn
   sum_va += kp
   sum_br += wn + kp
   do case
   case po = 22; n22 += wn; v22 += kp
   case po =  7; n7  += wn; v7  += kp
   case po =  0; n0  += wn
   otherwise;    nzw += wn
   endcase
endif

******************************************************************************
* Przepisanie kontraktu podanego dokumentu do bufora

procedure KonToBufor( kod )

ON( 'MAGAZYNY', 2 )
ON( 'KON_BUF' )
ON( 'KON_BUF',,,, .t. )
ON( 'KONTRAKT' )
DBSeek( kod )
while kod == KOD_DOKUM .and. !Eof()
      ko := KOD_TOWARU
      il := ILOSC
      if Jest_Towar( ko )
         AppendRecord( 'KON_BUF', { ko, SYMBOL, NAZWA, VAT, &cena_systemu, ILOSC, il })
      endif
      Select( 'KONTRAKT' )
      skip
enddo

******************************************************************************
* Przepisanie kontraktu podanego dokumentu do magazynu

procedure KonToMagazyn( kod, m_skad, m_dokad, przychod )

local bb := Alias()

ON( 'KONTRAKT' )
DBSeek( kod )
while kod == KOD_DOKUM .and. !Eof()
      INC_MAG( KOD_TOWARU, ILOSC, m_skad, m_dokad, przychod, 1 )
      skip
enddo

Select( bb )

******************************************************************************
* Nr 49. Odczyt i przeglÜd obrot¢w towaru : "OBR_BUF,..."

procedure ReadObroty( a )

local kod, il, stan, d_lp, bb

kod := KOD_WEW
bb := Alias()
stan := 0
d_lp := 0

ON( 'OBR_BUF' )
ON( 'OBR_BUF',,,, .t. )
ON( 'KONTRAKT', 2 )
DBSeek( kod )
while kod == KOD_TOWARU .and. !Eof()
      ko := KOD_DOKUM
      il := ILOSC
      if Jest_Dokument( ko )
         d_lp ++
         if DOKUMENT->CZY_PRZ == 'N'     && rozch¢d
            il := -il
         endif
         stan += il
         AppendRecord( 'OBR_BUF', { d_lp, TYP, DATA, DATA_Z, NUMER, NUMER_O, il, stan })
      endif
      Select( 'KONTRAKT' )
      skip
enddo

private zmiana := .f.

SubBase( a, .t. )

if zmiana
endif

Select( bb )

******************************************************************************
* kod - kod wew towaru

function Jest_Towar( kod, m_skad, m_dokad )

local ma, sy, cz, wy, bb

bb := Alias()

ON( 'MAGAZYNY', 2 )
if m_skad = NIL .and. m_dokad = NIL
   wy := DBSeek( kod )
else
   ma := if( m_skad = NIL .or. Empty( m_skad ), m_dokad, m_skad )
   if ( wy := DBSeek( kod ))
      if !( MAG == ma )
         KopiujRec( 'MAGAZYNY', 'MAGAZYNY' )
         Init_DBF_Main( '' )
         ( bb )->KOD_TOWARU := MAGAZYNY->KOD_WEW
         MAGAZYNY->ILOSC := 0
         MAGAZYNY->MAG := ma
         MAGAZYNY->ILS := 0
         MAGAZYNY->ILP := 0
         MAGAZYNY->ILR := 0
         MAGAZYNY->ILK := 0
      endif
   endif
endif

return wy

******************************************************************************
* kod - kod wew dokumentu

function Jest_Dokument( kod )

ON( 'DOKUMENT', 2 )
return DBSeek( kod )

******************************************************************************
* Zmienia KONTRAKT, MAGAZYN, ROZLICZENIE

procedure WpiszKontrakt( d_kod, m_skad, m_dokad, przychod )

INC_ROZ()
ON( 'KONTRAKT' )
ON( 'KON_BUF' )
while !Eof()
      INC_MAG( KOD_TOWARU, ILOSC, m_skad, m_dokad, przychod )
      INC_ROZ( CENA, ILOSC, VAT )
      AppendRecord( 'KONTRAKT', { d_kod, KOD_TOWARU, CENA, ILOSC })
      skip
enddo

******************************************************************************
* Zmienia KONTRAKT, MAGAZYN, ROZLICZENIE

procedure WypiszKontrakt( d_kod, m_skad, m_dokad, przychod, mn )

ON( 'KONTRAKT' )
DBSeek( d_kod )
while KOD_DOKUM == d_kod .and. !Eof()
      INC_MAG( KOD_TOWARU, ILOSC, m_skad, m_dokad, przychod,, mn )
      BDelete()
      skip
enddo

******************************************************************************

procedure WpiszDokument( d_kod, przychod )

ON( 'DOKUMENT', 2 )
if DBSeek( d_kod )
   DOKUMENT->NETTO23 := n23
   DOKUMENT->NETTO22 := n22
   DOKUMENT->NETTO8  := n8
   DOKUMENT->NETTO7  := n7
   DOKUMENT->NETTO5  := n5
   DOKUMENT->NETTO0  := n0
   DOKUMENT->NETTOZW := nzw
   DOKUMENT->VAT23   := v23
   DOKUMENT->VAT22   := v22
   DOKUMENT->VAT8    := v8
   DOKUMENT->VAT7    := v7
   DOKUMENT->VAT5    := v5
   DOKUMENT->WARTOSC := sum_br
   DOKUMENT->ILOSC   := sum_il
   DOKUMENT->NUMER   := PadL( AllTrim( NUMER ), Len( NUMER ))
   DOKUMENT->CZY_PRZ := if( przychod, 'T', 'N' )
else; Alarm( 'Brak dokumentu !!! Kod = ' + AllTrim( d_kod ))
endif

******************************************************************************

procedure WpiszRozlicze( k_kod, przychod )

local mn := if( przychod, -1, 1 )

ON( 'KONTRAHE', 2 )
if DBSeek( k_kod )
   KONTRAHE->ILOSC += sum_il * mn
   KONTRAHE->DATA_T := Datee()
   KONTRAHE->WARTOSC += sum_br * mn
   KONTRAHE->NALEZNOSCI += sum_br * mn
endif

******************************************************************************
* Sprawdzenie poprawnoûci dokumentu

function Dok_OK( w )

Select( 'DOKUMENT' )

if w # NIL
   w := ( Alarm( 'Zapisaç dokument ???', tk ) = 1 )
else
   w := .t.
   do case
   case Empty( MAG1 + MAG2 ); Alarm( ' le okreûlony magazyn !!!' ); w := .f.
   endcase
endif

return w

******************************************************************************
* Nr 43

procedure Done_Dokument( a )

local strona

if !Dok_OK()
   BDelete()
   return
endif

strona := DOK_OPIS->PRZYCHOD == 'T'    && czy strona przychodowa

Zwolnij( 'DOK_OPIS' )
Zwolnij( 'ROD_OPIS' )

ON( 'KON_BUF' )
ON( 'KON_BUF',,,,.t. )
DBAppend()
ViewDBF( a, .t., 'Q', 42 )        && dysponowanie towarami

delete all for Empty( NAZWA ) .or. ILOSC = 0

if !Dok_OK( 1 )
   BDelete()
   return
endif

WpiszKontrakt( DOKUMENT->KOD_WEW, DOKUMENT->MAG1, DOKUMENT->MAG2, strona )

Zwolnij( 'KONTRAKT' )
Zwolnij( 'KON_BUF' )

WpiszDokument( DOKUMENT->KOD_WEW, strona )
*WpiszRozlicze( DOKUMENT->KONTRAHENT, strona  )

*******************************************************************************
* Nr 50. "a" - hasío do usuwania

procedure UsunDokument( a )

local strona := DOKUMENT->CZY_PRZ == 'T'    && czy strona przychodowa

if Alarm( AllTrim( a ), nt ) # 2; return; endif

WypiszKontrakt( DOKUMENT->KOD_WEW, DOKUMENT->MAG1, DOKUMENT->MAG2, !strona )

sum_il := DOKUMENT->ILOSC
sum_br := DOKUMENT->WARTOSC

*WpiszRozlicze( DOKUMENT->KONTRAHENT, !strona )

Select( 'DOKUMENT' )
BDelete()
DBSkip( 0 )
wy := 2

*******************************************************************************
* Nr 51.

procedure ObliczStan( a )

local dd, rr, ii

dd := Get_U( 10, 10, 'Podaj na kt¢ry dzie§ obliczyç stan :' , Sz_X(8), Datee())

if dd = NIL; return; endif

Czek( 1 )

Select( 'MAGAZYNY' )
rr := RecNo()
ii := IndexOrd()

LiczStan( dd )

Zwolnij( 'DOKUMENT' )
Zwolnij( 'KONTRAKT' )

Select( 'MAGAZYNY' )
DBSetOrder( ii )
DBGoTo( rr )
wy := 2

Czek( 0 )

*******************************************************************************

procedure LiczStan( dd )

ON( 'MAGAZYNY' )
while !Eof()
      MAGAZYNY->ILOSC := 0
      DBSkip()
enddo

ON( 'DOKUMENT', 5 )
while DATA_Z <= dd .and. !Eof()
      KonToMagazyn( KOD_WEW, MAG1, MAG2 )
      DBSkip()
enddo

*******************************************************************************
* d1, d2 - okres dla obrot¢w
* przychody - czy tylko przychody ?

procedure LiczObroty( d1, d2, przychody )

ON( 'MAGAZYNY' )
while !Eof()
      MAGAZYNY->ILOSC := 0
      DBSkip()
enddo

ON( 'DOKUMENT', 5 )
DBSeek( d1, .t. )
while DATA_Z <= d2 .and. !Eof()
      KonToMagazyn( KOD_WEW, MAG1, MAG2, przychody )
      DBSkip()
enddo

*      if przychody .and. DOKUMENT->CZY_PRZ == 'T'
*         KonToMagazyn( KOD_WEW, m_skad, m_dokad, .t. )
*      elseif !przychody .and. !( DOKUMENT->CZY_PRZ == 'T' )
*         KonToMagazyn( KOD_WEW, m_skad, m_dokad, .t. )
*      endif

*******************************************************************************
* Przepisuje kolumnë ILOSC do podanego pola magazynu

procedure PutStanTo( p )

private pole := p

ON( 'MAGAZYNY' )
while !Eof()
      MAGAZYNY->&( pole ) := MAGAZYNY->ILOSC
      skip
enddo

*******************************************************************************
* Nr 52

procedure RozlMagazyn( a )

local bb := Alias(), rr, ii

Select( 'MAGAZYNY' )

if Get_Okres( @data_od, @data_do ) # NIL

   Czek( 1 )

   Select( 'MAGAZYNY' )
   rr := RecNo()
   ii := IndexOrd()

   LiczStan( data_od - 1 )   && stan poczÜtkowy
   PutStanTo( 'ILS' )

   LiczObroty( data_od, data_do, .t. )   && przychody
   PutStanTo( 'ILP' )

   LiczObroty( data_od, data_do, .f. )   && rozchody
   PutStanTo( 'ILR' )

   LiczStan( data_do )       && stan ko§cowy
   PutStanTo( 'ILK' )

   LiczStan( Datee())       && stan bießÜcy

   Select( 'MAGAZYNY' )
   DBSetOrder( ii )
   DBGoTo( rr )
   wy := 2

   Czek( 0 )

endif

Select( bb )

*******************************************************************************
* Nr 48. Odczyt i przeglÜd kontraktu dokumentu

procedure ReadKontrakt( a )

local bb := Alias()

KonToBufor( KOD_WEW )
SubBase( a, .t.,, 42 )

Select( bb )

******************************************************************************
* Nr 88

procedure PopKontrakt( a )

local strona := DOKUMENT->CZY_PRZ == 'T'    && czy strona przychodowa

WypiszKontrakt( DOKUMENT->KOD_WEW, DOKUMENT->MAG1, DOKUMENT->MAG2,, if( strona, -1, 1 ))

Select( 'KON_BUF' )
ViewDBF( a, .t.,'', 42 )        && dysponowanie towarami

delete all for Empty( NAZWA ) .or. ILOSC = 0

WpiszKontrakt( DOKUMENT->KOD_WEW, DOKUMENT->MAG1, DOKUMENT->MAG2, strona )
WpiszDokument( DOKUMENT->KOD_WEW, strona )

Select( 'KON_BUF' )
wy := 2
go top

******************************************************************************
* bb - baza rejestru
* z - zakup, = 1 - towar¢w, = 2 - koszt¢w
* rrr - rekord od kr¢rego zaczynajÜ sië pozycje faktury

procedure OblFKRS( bb, z, rrr )

local rr := RecNo()
local k_11, k_12, k_25, k_27, k_14, k_17, k_22, k_13, k_26, k_28, k_15, k_23

if bb = NIL; bb := 'REJ_SP'; endif

if z = NIL             && sprzedaß

( bb )->K11 := 0       && zeruj BRUTTO
( bb )->K12 := 0       && zeruj NETTO 22
( bb )->K25 := 0 && n17
( bb )->K27 := 0 && n12
( bb )->K14 := 0 && n7
( bb )->K16 := 0 && ex 0
( bb )->K17 := 0 && kr 0
( bb )->K22 := 0 && zw
( bb )->K10 := 0 && bezrach sprz brutto
( bb )->K18 := 0 && zaniech pob netto w cz
( bb )->K19 := 0 && zaniech pob vat w cz
( bb )->K20 := 0 && zaniech pob w caíoûci

if rrr = NIL; go top
elseif rrr = 0; DBGoBottom()
else; DBGo( rrr )
endif

while !Eof()

      if rrr = NIL .and. ILOSC < 0; skip; loop; endif   && mija ujemne

      Blokuj_R()
      replace BRUTTO with ILOSC * CENA_PUP
      ( bb )->K11 += BRUTTO                      && sumuj BRUTTO
      do case
         case VAT =23; ( bb )->K12 += BRUTTO
         case VAT =22; ( bb )->K12 += BRUTTO
         case VAT = 3; ( bb )->K25 += BRUTTO
         case VAT = 5; ( bb )->K27 += BRUTTO
         case VAT = 7; ( bb )->K14 += BRUTTO
         case VAT = 8; ( bb )->K14 += BRUTTO
         case !VAT_0_kraj .and. VAT = 0; ( bb )->K16 += BRUTTO    && 0% export
         case  VAT_0_kraj .and. VAT = 0; ( bb )->K17 += BRUTTO    && 0% kraj
         otherwise   ; ( bb )->K22 += BRUTTO
      endcase
      DBSkip()
enddo

if OD_NETTO

*( bb )->K13 := ( bb )->K12 * 0.22            && licz VAT z NETTO
( bb )->K13 := ( bb )->K12 * 0.23            && licz VAT z NETTO
( bb )->K26 := ( bb )->K25 * 0.03        
( bb )->K28 := ( bb )->K27 * 0.05         
*( bb )->K15 := ( bb )->K14 * 0.07       
( bb )->K15 := ( bb )->K14 * 0.08       

* VAT = Sum( VATi )
( bb )->K23 := ( bb )->K13 + ( bb )->K26 + ( bb )->K28 + ( bb )->K15

* Brutto = Suma( NETTOi ) + VAT
( bb )->K11 := ( bb )->K12 + ( bb )->K25 + ( bb )->K27 + ( bb )->K14 + ( bb )->K16 + ( bb )->K17 + ( bb )->K22 + ( bb )->K23

else

*( bb )->K13 := ( bb )->K12 * 0.22 / 1.22     && licz VAT z BRUTTO w NETTO
( bb )->K13 := ( bb )->K12 * 0.23 / 1.23     && licz VAT z BRUTTO w NETTO
( bb )->K26 := ( bb )->K25 * 0.03 / 1.03
( bb )->K28 := ( bb )->K27 * 0.05 / 1.05
*( bb )->K15 := ( bb )->K14 * 0.07 / 1.07
( bb )->K15 := ( bb )->K14 * 0.08 / 1.08

( bb )->K12 := ( bb )->K12 - ( bb )->K13     && licz NETTO z BRUTTO i VAT
( bb )->K25 := ( bb )->K25 - ( bb )->K26
( bb )->K27 := ( bb )->K27 - ( bb )->K28
( bb )->K14 := ( bb )->K14 - ( bb )->K15

( bb )->K23 := ( bb )->K13 + ( bb )->K26 + ( bb )->K28 + ( bb )->K15    && VAT

endif

if rrr = NIL

go top

store 0 to k_11, k_12, k_25, k_27, k_14, k_17, k_22

while !Eof()

      if ILOSC > 0; skip; loop; endif   && mija dodatnie

      Blokuj_R()
      replace BRUTTO with ILOSC * CENA_PUP
      k_11 += BRUTTO                      && sumuj BRUTTO
      do case
         case VAT =22; k_12 += BRUTTO
         case VAT =23; k_12 += BRUTTO
         case VAT = 3; k_25 += BRUTTO
         case VAT = 5; k_27 += BRUTTO
         case VAT = 7; k_14 += BRUTTO
         case VAT = 8; k_14 += BRUTTO
         case VAT = 0; k_17 += BRUTTO
         otherwise   ; k_22 += BRUTTO
      endcase
      DBSkip()
enddo

( bb )->K17 += k_17       && 0%
( bb )->K22 += k_22       && zw.

if OD_NETTO

( bb )->K12 += k_12      && VAT
( bb )->K25 += k_25
( bb )->K27 += k_27
( bb )->K14 += k_14

*( bb )->K13 += ( k_13 := Grosz( k_12 * 0.22 ))           && licz VAT z NETTO
( bb )->K13 += ( k_13 := Grosz( k_12 * 0.23 ))           && licz VAT z NETTO
( bb )->K26 += ( k_26 := Grosz( k_25 * 0.03 ))
( bb )->K28 += ( k_28 := Grosz( k_27 * 0.05 ))
*( bb )->K15 += ( k_15 := Grosz( k_14 * 0.07 ))
( bb )->K15 += ( k_15 := Grosz( k_14 * 0.08 ))

* VAT = Sum( VATi )
( bb )->K23 += ( k_23 := k_13 + k_26 + k_28 + k_15 )

* Brutto = Suma( NETTOi ) + VAT
( bb )->K11 += k_12 + k_25 + k_27 + k_14 + k_17 + k_22 + k_23

else

*( bb )->K13 += ( k_13 := Grosz( k_12 * 0.22 / 1.22 )) && licz VAT z BRUTTO w NETTO
( bb )->K13 += ( k_13 := Grosz( k_12 * 0.23 / 1.23 )) && licz VAT z BRUTTO w NETTO
( bb )->K26 += ( k_26 := Grosz( k_25 * 0.03 / 1.03 ))
( bb )->K28 += ( k_28 := Grosz( k_27 * 0.05 / 1.05 ))
*( bb )->K15 += ( k_15 := Grosz( k_14 * 0.07 / 1.07 ))
( bb )->K15 += ( k_15 := Grosz( k_14 * 0.08 / 1.08 ))

( bb )->K12 += ( k_12 := Grosz( k_12 - k_13 ))     && licz NETTO z BRUTTO i VAT
( bb )->K25 += ( k_25 := Grosz( k_25 - k_26 ))
( bb )->K27 += ( k_27 := Grosz( k_27 - k_28 ))
( bb )->K14 += ( k_14 := Grosz( k_14 - k_15 ))

* VAT = Sum( VATi )
( bb )->K23 += k_13 + k_26 + k_28 + k_15

* Brutto = Suma( NETTOi ) + VAT
( bb )->K11 += k_11

endif
endif

else             && zakup

( bb )->K9  := 0 && zeruj BRUTTO
( bb )->K10 := 0 && N22
( bb )->K14 := 0 && N22
( bb )->K21 := 0 && n17
( bb )->K23 := 0 && n17
( bb )->K27 := 0 && n12
( bb )->K29 := 0 && n12
( bb )->K12 := 0 && n7
( bb )->K16 := 0 && n7
( bb )->K18 := 0 && 0
( bb )->K19 := 0 && zw

go top
while !Eof()
      replace BRUTTO with ILOSC * CENA_PUP
      ( bb )->K9  += BRUTTO                      && sumuj BRUTTO
   if z = 1                      && towary
      do case
         case VAT =22; ( bb )->K10 += BRUTTO
         case VAT =23; ( bb )->K10 += BRUTTO
         case VAT = 3; ( bb )->K21 += BRUTTO
         case VAT = 5; ( bb )->K27 += BRUTTO
         case VAT = 7; ( bb )->K12 += BRUTTO
         case VAT = 8; ( bb )->K12 += BRUTTO
         case VAT = 0; ( bb )->K18 += BRUTTO
         otherwise; ( bb )->K19 += BRUTTO
      endcase
   else                          && koszty
      do case
         case VAT =22; ( bb )->K14 += BRUTTO
         case VAT =23; ( bb )->K14 += BRUTTO
         case VAT = 3; ( bb )->K23 += BRUTTO
         case VAT = 5; ( bb )->K29 += BRUTTO
         case VAT = 7; ( bb )->K16 += BRUTTO
         case VAT = 8; ( bb )->K16 += BRUTTO
         case VAT = 0; ( bb )->K18 += BRUTTO
         otherwise; ( bb )->K19 += BRUTTO
      endcase
   endif
      DBSkip()
enddo

if z = 1                      && towary

if OD_NETTO

*( bb )->K11 := ( bb )->K10 * 0.22            && towary VAT z NETTO
( bb )->K11 := ( bb )->K10 * 0.23            && towary VAT z NETTO
( bb )->K22 := ( bb )->K21 * 0.03       
( bb )->K28 := ( bb )->K27 * 0.05       
*( bb )->K13 := ( bb )->K12 * 0.07       
( bb )->K13 := ( bb )->K12 * 0.08       

* VAT = Suma( VATi )
( bb )->K20 := ( bb )->K11 + ( bb )->K22 + ( bb )->K28 + ( bb )->K13 +;
               ( bb )->K15 + ( bb )->K24 + ( bb )->K30 + ( bb )->K17    && VAT

* Brutto = Suma( NETTOi ) + VAT
( bb )->K9  := ( bb )->K10 + ( bb )->K21 + ( bb )->K27 + ( bb )->K12 + ( bb )->K18 + ( bb )->K19 +;
               ( bb )->K14 + ( bb )->K23 + ( bb )->K29 + ( bb )->K16 + ( bb )->K20

else

*( bb )->K11 := ( bb )->K10 * 0.22 / 1.22     && towary VAT z BRUTTO w NETTO
( bb )->K11 := ( bb )->K10 * 0.23 / 1.23     && towary VAT z BRUTTO w NETTO
( bb )->K22 := ( bb )->K21 * 0.03 / 1.03
( bb )->K28 := ( bb )->K27 * 0.05 / 1.05
*( bb )->K13 := ( bb )->K12 * 0.07 / 1.07
( bb )->K13 := ( bb )->K12 * 0.08 / 1.08

( bb )->K10 := ( bb )->K10 - ( bb )->K11     && licz NETTO z BRUTTO i VAT
( bb )->K21 := ( bb )->K21 - ( bb )->K22
( bb )->K27 := ( bb )->K27 - ( bb )->K28
( bb )->K12 := ( bb )->K12 - ( bb )->K13

* VAT = Suma( VATi )
( bb )->K20 := ( bb )->K11 + ( bb )->K22 + ( bb )->K28 + ( bb )->K13 +;
               ( bb )->K15 + ( bb )->K24 + ( bb )->K30 + ( bb )->K17    && VAT

endif

else

if OD_NETTO

*( bb )->K15 := ( bb )->K14 * 0.22            && koszty VAT z NETTO
( bb )->K15 := ( bb )->K14 * 0.23            && koszty VAT z NETTO
( bb )->K24 := ( bb )->K23 * 0.03       
( bb )->K30 := ( bb )->K29 * 0.05       
*( bb )->K17 := ( bb )->K16 * 0.07        
( bb )->K17 := ( bb )->K16 * 0.08        

* VAT = Suma( VATi )
( bb )->K20 := ( bb )->K11 + ( bb )->K22 + ( bb )->K28 + ( bb )->K13 +;
               ( bb )->K15 + ( bb )->K24 + ( bb )->K30 + ( bb )->K17    && VAT

* Brutto = Suma( NETTOi ) + VAT
( bb )->K9  := ( bb )->K10 + ( bb )->K21 + ( bb )->K27 + ( bb )->K12 + ( bb )->K18 + ( bb )->K19 +;
               ( bb )->K14 + ( bb )->K23 + ( bb )->K29 + ( bb )->K16 + ( bb )->K20

else

*( bb )->K15 := ( bb )->K14 * 0.22 / 1.22     && koszty VAT z BRUTTO w NETTO
( bb )->K15 := ( bb )->K14 * 0.23 / 1.23     && koszty VAT z BRUTTO w NETTO
( bb )->K24 := ( bb )->K23 * 0.03 / 1.03
( bb )->K30 := ( bb )->K29 * 0.05 / 1.05
*( bb )->K17 := ( bb )->K16 * 0.07 / 1.07
( bb )->K17 := ( bb )->K16 * 0.08 / 1.08

( bb )->K14 := ( bb )->K14 - ( bb )->K15     && licz NETTO z BRUTTO i VAT
( bb )->K23 := ( bb )->K23 - ( bb )->K24
( bb )->K29 := ( bb )->K29 - ( bb )->K30
( bb )->K16 := ( bb )->K16 - ( bb )->K17

* VAT = Suma( VATi )
( bb )->K20 := ( bb )->K11 + ( bb )->K22 + ( bb )->K28 + ( bb )->K13 +;
               ( bb )->K15 + ( bb )->K24 + ( bb )->K30 + ( bb )->K17    && VAT

endif
endif
endif

DBGoTo( rr )

******************************************************************************

procedure WydFkDf( bb, tt )

local ok := .f.

if bb = NIL; bb := 'REJ_SP'; endif
if tt = NIL; tt := 'TOWARY'; endif

if Left(( bb )->K24, 4 ) == 'FISK'
   Alarm('Ten dokument juß byí drukowany na drukarce fiskalnej')
elseif !Empty(( bb )->NIP )
   ok := ( Alarm('To jest faktura VAT;Paragon fiskalny mimo to ?', nt ) = 2 )
elseif !File( 'f.exe' )
   Alarm('Brak moduíu obsíugi drukarki fiskalnej')
else
	ok := .t.
endif

if ok
   DBCommitAll()
   use
   RunProgram('f.exe,roboczy' + nr_stacji + '\' + tt + '.dbf ' + StrTran(( bb )->NUMER, ' ', '_' ))
   if File('kolory.txt')
      RunProgram('del,kolory.txt')
   else
      ( bb )->K24 := 'FISK/' + ( bb )->K24
   endif
*   use ( 'roboczy' + nr_stacji + '\' + tt + '.dbf' ) index ( 'roboczy' + nr_stacji + '\' + tt + '.ntx' ) alias ROB
   use ( 'roboczy' + nr_stacji + '\' + tt + '.dbf' ) alias ROB
endif

******************************************************************************
* t - test
* r - rejestr bazowy
* b - baza specyfikacji
* i - indeks
* s - seek
* w - while
* p - pole
* h - has≥o

function SumSpe( t, r, b, i, s, w, p, h )

local bb := Alias(), wy := 0

if t = NIL; t := 'K11-K23'; endif
if r = NIL; r := 'REJ_SP'; endif
if b = NIL; b := 'TOWARY'; endif
if i = NIL; i := 1; endif
if s = NIL; s := r + '->LP'; endif
if w = NIL; w := r + '->LP==LPP'; endif
if p = NIL; p := 'BRUTTO'; endif
if h = NIL; h := 'PROBLEM !!!'; endif

ON( b, i )
DBSeek( RunCommand( s ))
while RunCommand( w ) .and. !Eof()
	wy += RunCommand( p )
	skip
enddo

Select( r )

t := RunCommand( t )
if !Empty( h ) .and. ( Abs( wy - t ) > 0.009 )
	while Alarm( h, { 'Dok=' + AllS( t ), 'Spe=' + AllS( wy ), 'OK=rozumiem'}) # 3; enddo
endif

Select( bb )

return wy

******************************************************************************
