******************************************************************************
********************      Procedury  F K    **********************************
******************************************************************************
#include 'directry.ch'
#include 'Inkey.ch'

******************************************************************************
* Minus odejmuje od p¢l rekordu, na kt¢rym stoi, to co zaraz dopisze
* odp - od pola
* dop - do pola

procedure MinusForm( a, b, odp, dop )

local poz[ FCount()], i, rr := RecNo()

if NewSysDopisz( a,,, b )
   OdBlokuj_R()
   for i := 1 to Len( poz ); poz[ i ] := FieldGet( i ); next   && nowy rekord
   DBGoTo( rr ); Blokuj_R()                                    && stary rekord
   for i := odp to dop; FieldPut( i, FieldGet( i ) - poz[ i ]); next  && delta
   OdBlokuj_R()
endif

LastZero()
rn := rr
wy := 2

******************************************************************************
* ni - NIP
* nu - NUMER
* re - skr¢t nazwy rejestru
* wa - wartoûç WN
* wm - wartoûç MA
* do - dokument

procedure Zamknij( ni, nu, re, wa, wm, do )

local bb := Alias(), ok := .f., zam := .f.

if OTWARTY # ' '
   Alarm( 'Dokument zamkniëty' )
else
   ON( 'KNORDPOL', 3 )                        && NIP
   set filter to
   if Empty( ni ) .or. !( ok := DBSeek( ni ))
      ON( 'KNORDPOL', 5 )                     && Str(NUMER)
      if nu = 0 .or. !( ok := DBSeek( Str( nu )))
      endif
   endif
   if Empty( KNORDPOL->KONTO )
      ok := .f.
   endif      
  
   if !ok
      if Alarm( "Nie udaje sië znale¶ç konta rozliczeniowego kontrahenta;ani po NIP'ie, ani po numerze kontrahenta.;Czy mimo wszystko zamknÜç ten dokument ?", nt ) = 2
         zam := .t.
      endif
   else
      ON( 'ROZLICZ' )
      Select( bb )
      if do = NIL; do := NUMER; endif
      AppendRecord( 'ROZLICZ', { KNORDPOL->KONTO, AllTrim( do ) + ', ' + re + ' ' + AllS( LP ) + ', ' + PRZEDMIOT, LP, D3, D4, wa, wm, re,,, Datee()})
      zam := .t.
   endif
endif

Select( bb )

if zam
   Blokuj_R()
     replace OTWARTY with 'z'
   OdBlokuj_R()
   zmiana := .t.
   PressKey('d¢í')
endif

******************************************************************************
* bz - baza znak¢w
* h - hasío pojedyncze
* hh - hasío mnogie

procedure BABAU( bz, h, hh )

local n, rr

if h = NIL; h := ''; endif
if hh = NIL; hh := ''; endif

n := 0
( bz )->( DBGoTop())
while ( bz )->( !Eof())
      n++
      ( bz )->( DBSkip())
enddo

if n < 2
   if Mark( bz, RecNo(), '*' ) == '*'
      Mark( bz, RecNo())
   endif
   Kasuj( h )
   wy := 2
   zmiana := .t.
else
   h := Alarm( 'Iloûç zaznaczonych pozycji: ' + AllS( n ) + ';' + hh,;
             { ' NIE ', ' TAK ', ' tylko podûwietlony dekret ' })
   if h = 3
      wy := 2
      zmiana := .t.
      if Mark( bz, RecNo(), '*' ) == '*'
         Mark( bz, RecNo())
      endif
      BDelete()
   endif

   if h = 2
      rr := NIL
      skip -1
      if Mark( bz, RecNo(), '*' ) == '*'  && wyßej jest gwiazdka
         rr := RecNo()
      endif
      skip
      while ( Mark( bz, RecNo(), '*' ) == '*' ) .and. !Eof()   && w d¢í
            Mark( bz, RecNo())
            BDelete()
            wy := 2
            zmiana := .t.
            skip
      enddo
      if rr # NIL
         DBGoTo( rr )
         while ( Mark( bz, RecNo(), '*' ) == '*' ) .and. !Bof()   && w g¢rë
               Mark( bz, RecNo())
               BDelete()
               wy := 2
               zmiana := .t.
               skip -1
         enddo
      endif
   endif
endif

LastZero()

******************************************************************************
* Nr 54

procedure DoneDopisz( a )

local ii := IndexOrd(), w, m, h, rr, sio, bb := Alias()

if LastKey() = K_ESC; return; endif

if ( bb )->( FieldPos( 'SOURCE_BA' )) # 0
   if !Empty(( bb )->SOURCE_BA )
      ( bb )->( Blokuj_R())
      ( bb )->SOURCE_UW := 'Zmiana (' + AllS( numer_o ) + ') ' + DtoC( Date()) + ', ' + Time() +', ' + ( bb )->SOURCE_UW
      ( bb )->( OdBlokuj_R())
   endif
endif

if a # NIL .and. !Empty( a )
   if ( sio := ( Left( a, 1 ) == '-' ))
      a := SubStr( a, 2 )
   endif   
   store 0 to w, m
   rr := RecNo()
   DBEval({|| w += if( !Empty( WINIEN ), KWOTA, 0 ), m += if( !Empty( MA ), KWOTA, 0 )})
   DBGoTo( rr )
   SetColor( jasny )
   h := AllS( w, '999,999,999.99' ) + ' / ' + AllS( m, '999,999,999.99' )
   @ Val( Left( a, 2 )), Val( Right( a, 2 )) - Len( h ) say h
   SetColor( STC )
   if sio
      return
   endif
endif

DBSetOrder( 0 )
*DBGoTop()
go bottom
DBSetOrder( ii )
DBSkip( -1 )
Keyboard Chr( K_DOWN )

******************************************************************************
* Ußywa drugiego indeksu BABA: DtoS( DATA ) + Str( LP ) + Str( PZ )

procedure RenPK()

local xnr, xlp, xpz, xdt, r, rr, bb, bazabuf

if Alarm( 'Renumerowaç dokumenty wedíug dat ?', nt ) # 2; return; endif

Czek( 1 )

bazabuf := if( osobne = NIL, '', osobne ) + '\BABABUF'

bb := Alias()
DBSetOrder( 2 )         && DtoS( DATA ) + Str( LP ) + Str( PZ )

go top
xnr := NR
xlp := LP - 1
xpz := PZ
xdt := DATA
copy to &bazabuf

use &bazabuf new exclusive
Przerwa( LastRec())
while !Eof()

      if xpz < PZ    && kolejne PZ
         xpz := PZ
      else           && nowe PZ
         xpz := PZ
         xlp ++
      endif

      if xdt # DATA
         xdt := DATA
         xnr ++
         xlp := 1
      endif

      replace NR with xnr
      replace LP with xlp
      replace DATA2 with xdt

      skip

      Przerwa()

enddo
use
Przerwa( 0 )

Select( bb )
DBZap()
append from &bazabuf
DBSetOrder( 1 )
go top
wy := 2

Czek( 0 )

******************************************************************************

procedure OWezwania()

local w, m

WEZWANIA->( Blokuj_R())
WEZWANIA->KONTO1_WN := 0; WEZWANIA->KONTO1_MA := 0
WEZWANIA->KONTO2_WN := 0; WEZWANIA->KONTO2_MA := 0
WEZWANIA->KONTO3_WN := 0; WEZWANIA->KONTO3_MA := 0
WEZWANIA->KONTO4_WN := 0; WEZWANIA->KONTO4_MA := 0
go top
while !Eof()
      if KONTO = WEZWANIA->NR_KONTA1; WEZWANIA->KONTO1_WN += WN; WEZWANIA->KONTO1_MA += MA;endif
      if KONTO = WEZWANIA->NR_KONTA2; WEZWANIA->KONTO2_WN += WN; WEZWANIA->KONTO2_MA += MA;endif
      if KONTO = WEZWANIA->NR_KONTA3; WEZWANIA->KONTO3_WN += WN; WEZWANIA->KONTO3_MA += MA;endif
      if KONTO = WEZWANIA->NR_KONTA4; WEZWANIA->KONTO4_WN += WN; WEZWANIA->KONTO4_MA += MA;endif
      skip
enddo

w := Max( WEZWANIA->KONTO1_WN - WEZWANIA->KONTO1_MA, 0 )
m := Max( WEZWANIA->KONTO1_MA - WEZWANIA->KONTO1_WN, 0 )

WEZWANIA->KONTO1_WN := w
WEZWANIA->KONTO1_MA := m

w := Max( WEZWANIA->KONTO2_WN - WEZWANIA->KONTO2_MA, 0 )
m := Max( WEZWANIA->KONTO2_MA - WEZWANIA->KONTO2_WN, 0 )

WEZWANIA->KONTO2_WN := w
WEZWANIA->KONTO2_MA := m

w := Max( WEZWANIA->KONTO3_WN - WEZWANIA->KONTO3_MA, 0 )
m := Max( WEZWANIA->KONTO3_MA - WEZWANIA->KONTO3_WN, 0 )

WEZWANIA->KONTO3_WN := w
WEZWANIA->KONTO3_MA := m

w := Max( WEZWANIA->KONTO4_WN - WEZWANIA->KONTO4_MA, 0 )
m := Max( WEZWANIA->KONTO4_MA - WEZWANIA->KONTO4_WN, 0 )

WEZWANIA->KONTO4_WN := w
WEZWANIA->KONTO4_MA := m

WEZWANIA->( OdBlokuj_R())

******************************************************************************
* Automatyczna eliminacja pozycji specyfikacji wezwa§ do zapíaty

procedure AWezwania( a )

local rr, kwn, kma, jest

if Alarm( a, nt ) # 2; return; endif

go top
while !Eof()
      rr := RecNo()
      kwn := WN
      kma := MA
      skip
      jest := .f.
      while !Eof() .and. !jest
            if ( kma # 0.00 .and. WN = kma ) .or.;
               ( kwn # 0.00 .and. MA = kwn )
               BDelete()
               jest := .t.
            endif
            skip
      enddo
      DBGoTo( rr )
      if jest
         BDelete()
         zmiana := .t.
      endif
      skip
enddo
go top
wy := 2

******************************************************************************
* Generowanie wezwa§ do zapíaty

procedure GWezwania( a, b )

go top

if Eof()

   private kontowez

   if Alarm( b, tk ) # 1; return; endif

   if !Empty( kontowez := WEZWANIA->NR_KONTA1 ); AutoDekret( a, -1 ); endif
   if !Empty( kontowez := WEZWANIA->NR_KONTA2 ); AutoDekret( a, -1 ); endif
   if !Empty( kontowez := WEZWANIA->NR_KONTA3 ); AutoDekret( a, -1 ); endif
   if !Empty( kontowez := WEZWANIA->NR_KONTA4 ); AutoDekret( a, -1 ); endif

   zmiana := .t.

endif

go top
wy := 2

******************************************************************************

procedure KorPlanuKont( xpole )

local x, bb := Alias()

if Alarm( 'WyciÜç skrajne prawe kreski z KONT ?', nt ) # 2; return; endif

private pole

if xpole = NIL; xpole := 'KONTO'; endif
pole := xpole

DBSetOrder( 0 )
go top
while !Eof()
      x := AllTrim( &pole )
      if Right( x, 1 ) == '-'
         Blokuj_R()
         replace &pole with Left( x, Len( x ) - 1 )
         OdBlokuj_R()
      endif
      skip
enddo

******************************************************************************

procedure RenNORDPOL()

local nLP, nPZ, s, s2

if Alarm( 'Totalna renumeracja p¢l "LP" i "PZ" dekret¢w ?', nt ) # 2
   RenNrLpPz()
   return
endif

Czek( 1 )

s := ''
s2:= ''

@ 0,0 say 'Kopia danych z dziennika do bufora "BUF.DBF"'
DBSetOrder( 2 )
copy all to buf

@ 0,0 say PadR( 'Renumeracja danych w buforze', mc )
use buf new
Przerwa( LastRec())
while !Eof()
      if !( s == DOK )
         s   := DOK
         s2  := NAZ1
         nLP := 1
         nPZ := 1
      else
         nPZ ++
         if !Empty( NAZ1 ) .and. !( s2 == NAZ1 )
            s2  := NAZ1
            nLP ++
            nPZ := 1
         endif
      endif
      buf->LP := nLP
      buf->PZ := nPZ
      if Przerwa(); exit; endif
      skip
enddo
use
Przerwa( 0 )

Select( 'NORDPOL' )

@ 0,0 say PadR( 'Usuwanie danych z dziennika', mc )
DBZap( '' )

@ 0,0 say PadR( 'Wypeínianie dziennika danymi z bufora', mc )
append all from buf
@ 0,0 say PadR( '', mc )
go top
wy := 2

Czek( 0 )

******************************************************************************

procedure RenNrLpPz()

local nNR, nLP, nPZ, dDK, s2, nDK := DOK

if Alarm( 'Renumeracja p¢l "Nr", "Lp" i "Pz" dokument¢w "' + nDK + '" ?', nt ) # 2; return; endif

Czek( 1 )

@ 0,0 say 'Kopia danych z dziennika do bufora "BUF.DBF"'
DBSetOrder( 2 )
copy all to buf

@ 0,0 say PadR( 'Renumeracja danych w buforze', mc )
use buf new EXCLUSIVE
Przerwa( LastRec())

while ( nDk # DOK ) .and. !Eof()
      skip
enddo

dDk := DATA
s2  := NAZ1
nLP := 1
nPZ := 0
nNR := NR

while !Eof()
      if nDk # DOK; skip; loop; endif
      if dDk # DATA
         dDk := DATA
         s2  := NAZ1
         nLP := 1
         nPZ := 1
         nNR ++
      else
         nPZ ++
         if !Empty( NAZ1 ) .and. !( s2 == NAZ1 )
            s2  := NAZ1
            nLP ++
            nPZ := 1
         endif
      endif
      buf->NR := nNR
      buf->LP := nLP
      buf->PZ := nPZ
      if Przerwa(); exit; endif
      skip
enddo
use
Przerwa( 0 )

Select( 'NORDPOL' )

@ 0,0 say PadR( 'Usuwanie danych z dziennika', mc )
DBZap( '' )

@ 0,0 say PadR( 'Wypeínianie dziennika danymi z bufora', mc )
append all from buf
@ 0,0 say PadR( '', mc )
go top
wy := 2

Czek( 0 )

******************************************************************************
* Agregacja z ußyciem zamiennik¢w kont

procedure A_ZAM_KONT( h )

local n, i, j, k, r, bb := Alias(), ii := IndexOrd(), re[ FCount()]

if Alarm( h, tk ) # 1; return; endif

ON( 'KNORDPOL' )
ON( 'ZAM_KONT' )

Select( bb )
DBSetOrder( 1 )
go top
Przerwa( LastRec())
while !Eof()
      k := KONTO
      Select( 'ZAM_KONT' ); DBGoTop()
      while !Eof()
            i := FieldGet( 1 )  && co
            j := FieldGet( 2 )  && w co
            if j # k .and. Szablon( k, i )    && 201 # 201
               Select( bb )
               r := RecNo()
               for n := 1 to FCount(); re[ n ] := FieldGet( n ); next
               BDelete()
               if !DBSeek( j )
                  DBAppend()
                  replace KONTO with j
                  KNORDPOL->( DBSeek( j ))
                  replace NAZWA with KNORDPOL->TRESC
               endif
               Blokuj_R()
               for n := 1 to FCount()
                   k := FieldGet( n )



















                   if ValType( k ) == 'N'
                      FieldPut( n, k + re[ n ])
                   endif
               next
               DBGoTo( r )
               exit
            endif
            skip
      enddo

      if Przerwa(); exit; endif

      Select( bb )
      skip
enddo
Przerwa( 0 )

wy := 2

DBSetOrder( ii )
go top

******************************************************************************
* Dopisanie zamiennika kont

procedure D_ZAM_KONT

local k := KONTO, bb := Alias()

ON( 'ZAM_KONT' )
DBAppend()
FieldPut( 1, k )
FieldPut( 2, k )
if !NewSysForm('ZAM_KONT,Nowy zamiennik kont')
   BDelete()
endif

Select( bb )

******************************************************************************
* bez = bez ZEST1 i ZAZESTAW

procedure ZamknijOkres( a, bez )

local dd1, dd2, rr

private mm_rr := SubStr( DtoS( data_od ), 5, 2 ) + '.' + SubStr( DtoS( data_od ), 3, 2 )

if NewSysDopisz( a )

   rr := RecNo()
   dd1 := CtoD( '01.' + mm_rr )
   dd2 := ODPM( CtoD( '27.' + mm_rr ) + 10 )  && na pewno jesteòmy w next month

   DBSetOrder( 1 )
   if DBSeek( DtoS( dd2 ))

      Alarm( 'Ten okres jest juß zamkniëty.' )
      DBGo( rr )
      BDelete()

   else

      DBGo( rr )
      ZAOKRESY->( Blokuj_R())
      ZAOKRESY->DATA1 := dd1
      ZAOKRESY->DATA2 := dd2

      if ( bez = NIL ) .and. ZEST1_Tworz( ,,, dd1, dd2, .f., 1 )
         Czek( 1 )
         ON( 'ZAZESTAW' )
         Select( 'ZEST1' )
         KopiaRec( 'ZEST1', 'ZAZESTAW',, .t.,, { || ZAZESTAW->DATA := dd2, .f. })
         Czek( 0 )
         Tone( ton2, 1 )
      endif
   endif
endif

Select( 'ZAOKRESY' )

******************************************************************************
* Nr 62 a - parametry dla formularza okreûlania warunk¢w
*       b - tytuí dla tabeli wynikowej
*       c - wariant - NIL=>oba, 1-synt, 2-anal
*       e - data_od
*       f - data_do
*       g - czy stosowac skroty liczenia caíego miesiÜca ?
*    bezb - bez BEEP

function ZEST1_Tworz( a, b, c, e, f, g, bezb )

local i, k, n, dt

private ok_bo := "T", k_bil := "T", k_pozabil := "T", do_lp:=0

g := if( g = NIL, .t., g )

if e = NIL .or. f = NIL

   if a = NIL .or. Empty( a )
      if Get_Okres( @data_od, @data_do ) = NIL; return .f.; endif
   else
      k_bil := "T"
      k_pozabil := "N"
      if !NewSysForm( a ); return .f.; endif
   endif

   if c = NIL
      DBE_Tyt := 'Zestawienie obrot¢w i sald w okresie ' + DtoC( data_od ) + '-' + DtoC( data_do )
   else
      DBE_Tyt := 'Zestawienie obrot¢w i sald ' + b + ' w okresie ' + DtoC( data_od ) + '-' + DtoC( data_do )
   endif

else

   data_od := e
   data_do := f

endif

ok_bo := ( ok_bo == "T" )
k_bil := ( k_bil == "T" )
k_pozabil := ( k_pozabil == "T" )

data1 := data_od
data2 := data_do

Czek( 1 )

ON( 'ZEST1' )
ON( 'ZEST1',,,, .t. )

**ON( 'ZAZESTAW' )
**ON( 'ZAOKRESY' )
**
**do case
**
* peíny zamkniëty okres, 01.01.98-31.01.98
**
**   case g;
**        .and.;
**        DBSeek( DtoS( data_do ));
**        .and.;
**        DATA1 = data_od
**
**   Select( 'ZAZESTAW' )
**   DBSeek( DtoS( data_do ))
**   KopiaRec( 'ZAZESTAW', 'ZEST1', { || ZAZESTAW->DATA = data_do })
**
* tuß za zamkniëtym okresem, ale okres do m-ca, np.: 01.04.98-15.04.98
**
**   case Year( data_od ) = Year( data_do );
**        .and.;
**        Month( data_od ) = Month( data_do );
**        .and.;
**        DBSeek( DtoS( data_od - 1 ))
**        
**   Select( 'ZAZESTAW' )
**   DBSeek( DtoS( data_od - 1 ))
**   KopiaRec( 'ZAZESTAW', 'ZEST1', { || ZAZESTAW->DATA = data_od - 1 })
**
**   Select( 'ZEST1' ); DBGoTop()   && init ZEST1 na 01.04.98
**   while !Eof()
**         ZEST1->BO_WINIEN := OBROTYWN
**         ZEST1->BO_MA     := OBROTYMA
**         ZEST1->OBROTYMW  := 0
**         ZEST1->OBROTYMM  := 0
**         skip
**   enddo
**
**   ZOS( .f., c, k_bil, k_pozabil )    && B.O. jest juß policzony, wiëc tylko dopeínij
**
* tuß za zamkniëtym okresem, ale okres > 1mc, np.: 01.01.98-15.04.98
**
**   case DBSeek( DtoS( data_od - 1 ));
**        .and.;
**        !DBSeek( DtoS( data_do ));
**        .and.;
**        DBSeek( DtoS( dt := ODPM( data_do )))
**
**   Select( 'ZAZESTAW' )
**   DBSeek( DtoS( dt ))
**   KopiaRec( 'ZAZESTAW', 'ZEST1', { || ZAZESTAW->DATA = dt })
**
**   if ZAZESTAW->( DBSeek( DtoS( data_od - 1 ))) && m-c wczeûniej jest zamkniëty
**      ZAZESTAW->( DBSetOrder( 2 ))   && konto+data
**      Select( 'ZEST1' ); DBGoTop()   && przepisz obroty nar. na B.O.
**      while !Eof()
**            ZAZESTAW->( DBSeek( ZEST1->KONTO + DtoS( data_od - 1 )))
**            ZEST1->BO_WINIEN := ZAZESTAW->OBROTYWN
**            ZEST1->BO_MA     := ZAZESTAW->OBROTYMA
**            ZEST1->OBROTYMW  := 0
**            ZEST1->OBROTYMM  := 0
**            skip
**      enddo
**   endif
**
**   data_od := dt + 1
**   ZOS( .f., c, k_bil, k_pozabil ) && B.O. jest juß policzony, wiëc tylko dopeínij
**
* peíne zamkniëte okresy, 01.01.98-31.03.98
**
**   case g;
**       .and.;
**       DBSeek( DtoS( data_do ));
**       .and.;
**       DBSetOrder( 2 ) = NIL;
**       .and.;
**       DBSeek( DtoS( data_od ))
**
**   Select( 'ZAZESTAW' )
**   DBSeek( DtoS( data_do ))
**   KopiaRec( 'ZAZESTAW', 'ZEST1', { || ZAZESTAW->DATA = data_do })
**
**   if ZAZESTAW->( DBSeek( DtoS( data_od - 1 ))) && m-c wczeûniej jest zamkniëty
**      ZAZESTAW->( DBSetOrder( 2 ))   && konto+data
**      Select( 'ZEST1' ); DBGoTop()   && przepisz obroty nar. na B.O.
**      while !Eof()
**            ZAZESTAW->( DBSeek( ZEST1->KONTO + DtoS( data_od - 1 )))
**            ZEST1->BO_WINIEN := ZAZESTAW->OBROTYWN
**            ZEST1->BO_MA     := ZAZESTAW->OBROTYMA
**            skip
**      enddo
**   endif
**
**otherwise
**
**   ON( 'ZAOKRESY' )      && 15.06.98-20.07.98
**
**   if Eof()
**
      ZOS( ok_bo, c, k_bil, k_pozabil, do_lp )
**
**   else
**
**      DBGoBottom()       && 01.04.98-30.04.98 => najblißszy zamkniëty
**      while DATA2 >= data_od .and. !Bof(); DBSkip( -1 ); enddo
**
**      if Bof()
**
**         ZOS( ok_bo, c, k_bil, k_pozabil )
**
**      else
**

**         Select( 'ZAZESTAW' )
**         DBSeek( DtoS( ZAOKRESY->DATA2 ))   && kopia zamkniëtego 30.04.98
**         KopiaRec( 'ZAZESTAW', 'ZEST1', { || ZAZESTAW->DATA = ZAOKRESY->DATA2 })
**
**         Select( 'ZEST1' ); DBGoTop()   && init ZEST1 na 01.05.98
**         while !Eof()
**               ZEST1->BO_WINIEN := OBROTYWN
**               ZEST1->BO_MA     := OBROTYMA
**               ZEST1->OBROTYMW  := 0
**               ZEST1->OBROTYMM  := 0
**               skip
**         enddo
**
**         dt := data_do                      && pamiëtaj 20.07.98
**         data_do := data_od - 1             && robimy do 14.06.98
**         data_od := ZAOKRESY->DATA2 + 1     && robimy od 01.05.98
**         ZOS( .f., c, k_bil, k_pozabil )
**
**         Select( 'ZEST1' ); DBGoTop()   && init ZEST1 na 15.06.98
**         while !Eof()
**               ZEST1->BO_WINIEN := OBROTYWN
**               ZEST1->BO_MA     := OBROTYMA
**               ZEST1->OBROTYMW  := 0
**               ZEST1->OBROTYMM  := 0
**               skip
**         enddo
**
**         data_od := data_do + 1             && robimy od 15.06.98
**         data_do := dt                      && robimy do 20.07.98
**
**         ZOS( .f., c, k_bil, k_pozabil )
**
**      endif
**   endif
**endcase

ON( 'ZEST1' )
Przerwa( LastRec())
IncDBES( 1 )
while !Eof(); IncDBES(); Przerwa(); DBSkip(); enddo
Przerwa( 0 )

ON( 'ZEST1' )
PutIni()
if bezb = NIL     && Tone( ton2, 1 ); endif
   ShowDBES( 1 )  && bez GETIni() na poczatku
endif
Czek( 0 )
wy := 2

return .t.

******************************************************************************

procedure ZOS( ok_bo, c, kbila, kpoza, do_lp )


ON( 'KNORDPOL' )
ON( 'NORDPOL', 2 )

if ok_bo
   Przerwa( LastRec())
      while !Eof()
            if DATA <= data_do .and. iif(NORDPOL->DATA <> data_do .or. do_lp==0, .t., NORDPOL->LP <= do_lp)
               if KontoOK( WINIEN, c, kbila, kpoza )
                  if !( ZEST1->( DBSeek( Upper( NORDPOL->WINIEN ))))
                     AppendRecord( 'ZEST1', { NORDPOL->WINIEN, KNORDPOL->TRESC })
                     ZEST1->TRESCG := KNORDPOL->TRESCG
                  endif
                  ZEST1->SALDOWN += KWOTA
                  if NORDPOL->DATA <= data_do     && narastajaco obroty
                     ZEST1->OBROTYWN += KWOTA
                  endif
                  if NORDPOL->DATA < data_od      && b.o. konta
                     ZEST1->BO_WINIEN += KWOTA
                  endif
                  if Year( NORDPOL->DATA ) = Year( data_do );
                     .and.;
                     Month( NORDPOL->DATA ) = Month( data_do )
                     ZEST1->OBROTYMW += KWOTA
                  endif
               endif

               if KontoOK( MA, c, kbila, kpoza )
                  if !( ZEST1->( DBSeek( Upper( NORDPOL->MA ))))
                     AppendRecord( 'ZEST1', { NORDPOL->MA, KNORDPOL->TRESC })
                     ZEST1->TRESCG := KNORDPOL->TRESCG
                  endif
                  ZEST1->SALDOMA += KWOTA
                  if NORDPOL->DATA <= data_do     && narastajaco obroty
                     ZEST1->OBROTYMA += KWOTA
                  endif
                  if NORDPOL->DATA <  data_od     && b.o. konta
                     ZEST1->BO_MA += KWOTA
                  endif
                  if Year( NORDPOL->DATA ) = Year( data_do );
                     .and.;
                     Month( NORDPOL->DATA ) = Month( data_do )
                     ZEST1->OBROTYMM += KWOTA
                  endif
               endif
           endif
           if Przerwa(); exit; endif
           DBSkip()
      enddo
      Przerwa( 0 )
else                                             && bez BO
      DBSeek( DtoS( data_od ), .t. )
      Przerwa( LastRec())

      while DATA <= data_do .and. !Eof()
                                                 
            if KontoOK( WINIEN, c, kbila, kpoza ) .and. iif(NORDPOL->DATA <> data_do .or. do_lp==0, .t., NORDPOL->LP <= do_lp)
               if !( ZEST1->( DBSeek( Upper( NORDPOL->WINIEN ))))
                  AppendRecord( 'ZEST1', { NORDPOL->WINIEN, KNORDPOL->TRESC })

                  ZEST1->TRESCG := KNORDPOL->TRESCG
               endif
               ZEST1->SALDOWN  += KWOTA
               ZEST1->OBROTYWN += KWOTA        && narastajaco obroty

*               if NORDPOL->DATA < data_od      && b.o. konta
*                  ZEST1->BO_WINIEN += KWOTA
*               endif

               if Year( NORDPOL->DATA ) = Year( data_do );
                  .and.;
                  Month( NORDPOL->DATA ) = Month( data_do )
                  ZEST1->OBROTYMW += KWOTA
               endif
            endif

            if KontoOK( MA, c, kbila, kpoza ).and. iif(NORDPOL->DATA <> data_do .or. do_lp==0, .t., NORDPOL->LP <= do_lp)
               if !( ZEST1->( DBSeek( Upper( NORDPOL->MA ))))
                  AppendRecord( 'ZEST1', { NORDPOL->MA, KNORDPOL->TRESC })
                  ZEST1->TRESCG := KNORDPOL->TRESCG
               endif
               ZEST1->SALDOMA  += KWOTA
               ZEST1->OBROTYMA += KWOTA     && narastajaco obroty

*               if NORDPOL->DATA < data_od      && b.o. konta
*                  ZEST1->BO_MA += KWOTA
*               endif

               if Year( NORDPOL->DATA ) = Year( data_do );
                  .and.;
                  Month( NORDPOL->DATA ) = Month( data_do )
                  ZEST1->OBROTYMM += KWOTA
               endif
            endif

            if Przerwa(); exit; endif

            DBSkip()
      enddo
      Przerwa( 0 )
endif

ON( 'ZEST1' )

Przerwa( LastRec())
while !Eof()

      n := SALDOWN - SALDOMA

      ZEST1->SALDOWN := if( n > 0, n, 0 )
      ZEST1->SALDOMA := if( n < 0,-n, 0 )

      if Przerwa(); exit; endif

      DBSkip()
enddo
Przerwa( 0 )

******************************************************************************

procedure TotDBES( poledaty, h )

local bb, ii, rr

if poledaty # NIL
   if NIL = Get_Okres( @data1, @data2, h ); return; endif
endif

bb := Alias()
ii := IndexOrd()
rr := RecNo()

Czek( 1 )
IncDBES( 1 )
go top
while !Eof()
      if poledaty = NIL .or. ( data1 <= &poledaty .and. &poledaty <= data2 )
         IncDBES()
      endif
      skip
enddo
Czek( 0 )


ShowDBES( 1 )

Select( bb )
DBSetOrder( ii )
DBGoTo( rr )

******************************************************************************
* mode = NIL - inkrementacja
* mode # NIL - zerowanie

procedure IncDBES( mode )

static d
local i

if mode = NIL

   for i := 1 to Len( d )
       DBE_Sumy[ i ] += &( d[ i ])
   next

else

   d := {}
   DBE_Sumy := {}

   for i := 1 to Len( naglowki )
       if ',999' $ szablon[ i ]
          Aadd( d, kolumny[ i ])
       endif
   next

   AEval( d, { || Aadd( DBE_Sumy, 0 )})

endif

******************************************************************************
* mode = NIL z GETIni
* mode # NIL bez GETIni

procedure ShowDBES( mode )

local i, j, mm, maxl, ekran

if mode = NIL; GetIni(); endif

j := 1
mm := {}
maxl := 0
for i := 1 to Len( naglowki )
    if j <= Len( DBE_Sumy ) .and. ',999' $ szablon[ i ]
       maxl := Max( maxl, Len( naglowki[ i ]))
    endif
next
for i := 1 to Len( naglowki )
    if j <= Len( DBE_Sumy ) .and. ',999' $ szablon[ i ]
       Aadd( mm, PadL( StrTran( naglowki[ i ], ';', ' ' ), maxl ) + ': ' + TransForm( DBE_Sumy[ j++ ], szablon[ i ]))
    endif
next

ekran := SaveScreen()
@ mr, 0 clear to mr, mc
Esc(1)
Alarm( 'Totalizer', mm )
RestScreen(,,,,ekran)

******************************************************************************

procedure PutIni( nazwa )

local plik, i

if nazwa = NIL; nazwa := Alias(); endif

plik := Transform( MemVar->data1, '@S10' ) + EOL
plik += Transform( MemVar->data2, '@S10' ) + EOL
plik += AllTrim( DBE_Tyt ) + EOL
for i := 1 to Len( DBE_Sumy )
    plik += Str( DBE_Sumy[ i ]) + EOL
next

MemoWrit( if( osobne # NIL, osobne, '.' ) + '\' + nazwa + '.win', plik )

******************************************************************************
* mode = NIL = all
* mode # NIL = tylko daty
* @tab - pozostaíe parametry za tytuíem

procedure GetIni( nazwa, mode, tab )

local dane, i, a

if nazwa = NIL; nazwa := Alias(); endif
dane := if( osobne # NIL, osobne, '.' ) + '\' + nazwa + '.win'
if !FFile( dane )
   dane := ''
else
   dane := ReadWzor( dane )
endif
tab := {}
DBE_Sumy := {}
for i := 1 to MLCount( dane, dl_memo )
    do case
       case i = 1; MemVar->data1 := CtoD( MemoLine( dane, dl_memo, i ))
       case i = 2; MemVar->data2 := CtoD( MemoLine( dane, dl_memo, i ))
       case i = 3 .and. mode # NIL; return
       case i = 3
            a := AllTrim( MemoLine( dane, dl_memo, i ))
            DBE_Tyt := Odetnij( @a, '|' )
            while !Empty( a ); Aadd( tab, Odetnij( @a, '|' )); enddo
    otherwise
       Aadd( DBE_Sumy, Val( MemoLine( dane, dl_memo, i )))
    endcase
next

return tab

******************************************************************************
* ko - konto badane
* c - wariant - NIL=>oba, 1-synt, 2-anal

function KontoOK( ko, c, kbila, kpoza )

if Empty( ko ); return .f.; endif

KNORDPOL->( DBSeek( ko ))

do case
   case c = NIL                               && oba => przechodzi
   case c = 1 .and. KNORDPOL->WT =='*'        && synt
   case c = 2 .and. !( KNORDPOL->WT =='*' )   && anal
otherwise
   return .f.
endcase

if kbila # NIL .and. !kbila .and. KNORDPOL->(FCount()) > 17 .and. KNORDPOL->POZABILANS == ' '
   return .f.
endif

if kpoza # NIL .and. !kpoza .and. KNORDPOL->(FCount()) > 17 .and. KNORDPOL->POZABILANS == '*'
   return .f.
endif

return .t.

******************************************************************************
* Zapisuje po≥πczenia miÍdzy danymi z rejestrÛw i dziennika g≥Ûwnego
*Aadd(pola,{'SOURCE_BA','C',8,0})|
*Aadd(pola,{'SOURCE_LP','N',10,0})|
*Aadd(pola,{'SOURCE_DT','D',8,0})|
*Aadd(pola,{'SOURCE_CZ','C',8,0})|
*Aadd(pola,{'SOURCE_OS','N',2,0})|
*Aadd(pola,{'SOURCE_UW','C',30,0})|
*Aadd(pola,{'DEST_DOK','C',8,0})|
*Aadd(pola,{'DEST_NR','N',4,0})|
*Aadd(pola,{'DEST_DATA','D',8,0})|
*Aadd(pola,{'DEST_LP','N',4,0})|
*Aadd(pola,{'DEST_PZ','N',4,0})|

procedure Rejestruj()

AppendRecord( 'LINKI', {;
( sour )->SOURCE_BA,;
( sour )->SOURCE_LP,;
( sour )->SOURCE_DT,;
( sour )->SOURCE_CZ,;
( sour )->SOURCE_OS,;
( sour )->SOURCE_UW,;
( dest )->DOK,;
( dest )->NR,;
( dest )->LP,;
( dest )->PZ,;
Date(),;
Time(),;
numer_o })

******************************************************************************
* Nr 53

procedure InitDekret( a )

local bb := Alias(), n1, n2

a := Val( a )

( bb )->WINIEN := ''                  
( bb )->MA := ''
( bb )->KWOTA := 0

n1 := 6
n2 := 9

if ( bb )->( FieldPos( 'SOURCE_BA' )) # 0
   ( bb )->SOURCE_BA := ''
   ( bb )->SOURCE_LP := 0
   ( bb )->SOURCE_DT := CtoD( '' )
   ( bb )->SOURCE_CZ := ''
   ( bb )->SOURCE_OS := 0
   ( bb )->SOURCE_UW := ''
endif

if ( bb )->( FieldPos( 'DATAOG' )) # 0
   n1 ++
   n2 ++
endif

if a > 1
  ( bb )->NAZ1 := ''
  ( bb )->NAZ2 := ''
  ( bb )->OPIS := ''
   Keyboard Replicate( Chr( K_DOWN ), n1 )
endif

do case
case a = 1
    ( bb )->PZ ++                            && kolejne PZ
     Keyboard Replicate( Chr( K_DOWN ), n2 )
case a = 2                                  && kolejne LP
    ( bb )->LP ++
    ( bb )->PZ := 1
case a = 3                                  && kolejne NR
    ( bb )->NR ++
    ( bb )->LP := 1
    ( bb )->PZ := 1
case a = 4                                  && kolejne DOK
    ( bb )->DOK := ''
    ( bb )->NR := 1

    ( bb )->LP := 1
    ( bb )->PZ := 1
endcase

if Empty(( bb )->DATA )
  ( bb )->DATA := Datee()
  ( bb )->DATA2:= Datee()
endif

if( bb )->LP = 0
  ( bb )->LP := 1
  ( bb )->PZ := 1
endif

if Empty(( bb )->DOK )
   Keyboard ''
endif

******************************************************************************
* Nr 55, np. : a = 'BABA,NORDPOL,Wpisaç dekrety do bazy gí¢wnej ?,4,5'

procedure WpiszDekrety( a )

local hh, takrej
private sour, dest

if Eof()
   Alarm( 'Brak danych !!!' )
   return
endif

sour := Odetnij( @a )   && bufor danych
dest := Odetnij( @a )   && baza gí¢wna dekret¢w
hh   := Odetnij( @a )   && hasío przed wpisaniem

SprawdzKonta( a, sour )

hh := Alarm( hh, { ' TAK ', ' NIE = Esc ', ' wyczyûç tabelë ' })

if hh = 3
   if DBZap( 'Na pewno usunÜç wszystkie dane z tej tabeli ?,' + sour )
      if File( cat_wzorow + sour + '_Z.str' )     && struktura bazy znak¢w
         ON( sour + '_Z',,,, .t. )                && wyczyûç
      endif
   endif
endif

if hh = 1

   wy := 2
   Czek( 1 )

   if File( cat_wzorow + sour + '_Z.str' )     && struktura bazy znak¢w
      ON( sour + '_Z',,,, .t. )                && wyczyûç
   endif

   ON( 'DNORDPOL' )
   ON( sour, 0 )       && BABA ...
   Przerwa( LastRec())
   while !Eof()
         if DNORDPOL->( DBSeek( Upper(( sour )->DOK )))

            if ( sour )->NR = 0                    && automat

               DNORDPOL->( Blokuj_R())
               hh := DNORDPOL->NR                  && current
               DNORDPOL->NR := hh + 1              && dla innych next
               DNORDPOL->DATA := ( sour )->DATA
               DNORDPOL->( OdBlokuj_R())

               while !Eof()                        && auto num
                     ( sour )->( Blokuj_R())
                     ( sour )->NR := hh
                     ( sour )->( OdBlokuj_R())
                     if Przerwa(); exit; endif
                     DBSkip()
               enddo

               Select( sour ); go top
               Czek( 0 )

               Alarm( 'Dokument "' + AllTrim(( sour )->DOK ) + '" otrzymaí numer: ' + AllS( hh ))
               Czek( 1 )
               exit

            else
               if DNORDPOL->NR < ( sour )->NR + 1
                  DNORDPOL->( Blokuj_R())
                  DNORDPOL->NR := ( sour )->NR + 1
                  DNORDPOL->DATA := ( sour )->DATA
               endif
            endif
         endif
         if Przerwa(); exit; endif
         DBSkip()
   enddo
   Przerwa( 0 )

takrej := .f.
if FFile( cat_wzorow + 'LINKI.str' )
   ON( 'LINKI' )
   takrej := .t.
endif

   ON( dest )
   Select( sour )
   Przerwa( LastRec())
   KopiaRec( sour, dest,, .t.,, {|| if( takrej, Rejestruj(),), Przerwa()})
   Przerwa( 0 )
   ON( sour,,,, .t. )
   DBCommitAll()

   Czek( 0 )

endif

Select( sour )
DBSetOrder( 1 )

******************************************************************************
* Nr 67 : a - warunek przepisywania rekord¢w

procedure ZEST1W_Tworz( a )


private warunek := Odetnij( @a, ';' )

Czek( 1 )

ON( SysMenu )
DBSeek( Odetnij( @a, ';' ) + Odetnij( @a, ';' ))  && pobranie nazwy opcji
OpcLastName := N_OPCJI

ON( 'ZEST1' ); Przerwa( LastRec())
ON( 'ZEST1W' )
ON( 'ZEST1W',,,, .t. )
KopiaRec( 'ZEST1', 'ZEST1W',,, { || &warunek }, { || Przerwa()})
Przerwa( 0 )

GetIni( 'ZEST1', 1 )  && pobranie dat takich jak w zestawieniu obr. i sald

IncDBES( 1 )
ON( 'ZEST1W' ); Przerwa( LastRec())
while !Eof(); IncDBES(); Przerwa(); DBSkip(); enddo
Przerwa( 0 )

ON( 'ZEST1W' )
a := AllTrim( OpcLastName ) + ' w okresie ' + DtoC( data1 ) + '-' + DtoC( data2 )
DBE_Tyt := PadR( a, Max( Len( a ), Len( DBE_Tyt )))   && tytuí taki jak opcja
PutIni()
ShowDBES( 1 )  && bez GETIni() na poczatku

Czek( 0 )
wy := 2

******************************************************************************
* Nr 69 - sprawdzanie np. 4* i 5*

procedure SprawdzKonta( a, sour )

local n, s1, s2, rr, aa, bb, r

aa := Odetnij( @a )
bb := Odetnij( @a )
rr := RecNo()
s1 := 0
s2 := 0

if sour = NIL; sour := 'BABA'; endif

ON( sour, 0 )        && 'BABA'
Przerwa( LastRec())
while !Eof()
      if Left( WINIEN, 1 ) == aa; s1 += KWOTA; endif
      if Left( WINIEN, 1 ) == bb; s2 += KWOTA; endif
      if Przerwa(); exit; endif
      DBSkip()
enddo
Przerwa( 0 )

if Abs( r := s1 - s2 ) > 0.001
   Syrena()
   aa += '*"(' + AllTrim( Transform( s1, '999,999,999.99' )) + ')'
   bb += '*"(' + AllTrim( Transform( s2, '999,999,999.99' )) + ')'
   if s1 > s2; Alarm( '"' + aa + ' > "' + bb + ' o ' + AllTrim( Transform(  r, '999,999,999.99' )))
   else      ; Alarm( '"' + aa + ' < "' + bb + ' o ' + AllTrim( Transform( -r, '999,999,999.99' )))
   endif
endif

ON( sour, 0 )
DBGoTo( rr )
wy := 2

******************************************************************************
* Nr 70 - Sprawdza saldo podanego konta

procedure SaldoKonta( a )

local w, m, rr, r, h, zos := .f., bb

h := Odetnij( @a )    && puste, byle nie liczba
rr := RecNo()
w := 0
m := 0

if Empty( a ) .and. FFile( cat_wzorow + 'baba_zos.str' )
   zos := .t.
   bb := Alias()
   ON( 'BABA_ZOS' )
   ON( 'BABA_ZOS',,,, .t. )
   Select( bb )
endif

DBSetOrder( 0 )
DBGoTop()
Przerwa( LastRec())
while !Eof()
      if !Empty( WINIEN ) .and. Left( WINIEN, Len( a )) == a; w += KWOTA; endif
      if !Empty( MA     ) .and. Left( MA    , Len( a )) == a; m += KWOTA; endif
      if zos
         if !Empty( WINIEN )
            if BABA_ZOS->( !DBSeek(( bb )->WINIEN ))
               BABA_ZOS->( DBAppend())
               BABA_ZOS->KONTO := ( bb )->WINIEN
            endif
            BABA_ZOS->WN += ( bb )->KWOTA
            BABA_ZOS->SWN := Max( BABA_ZOS->WN - BABA_ZOS->MA, 0 )
            BABA_ZOS->SMA := Max( BABA_ZOS->MA - BABA_ZOS->WN, 0 )
         endif

         if !Empty( WINIEN )
            if BABA_ZOS->( !DBSeek(( bb )->MA ))
               BABA_ZOS->( DBAppend())
               BABA_ZOS->KONTO := ( bb )->MA
            endif
            BABA_ZOS->MA += ( bb )->KWOTA
            BABA_ZOS->SWN := Max( BABA_ZOS->WN - BABA_ZOS->MA, 0 )
            BABA_ZOS->SMA := Max( BABA_ZOS->MA - BABA_ZOS->WN, 0 )
         endif
      endif
      if Przerwa(); exit; endif
      DBSkip()
enddo
Przerwa( 0 )

if ( r := w - m ) > 0; r := 'WINIEN(' + AllTrim( Transform(  r, '999,999,999.99' )) + ')'
else                 ; r := 'MA('     + AllTrim( Transform( -r, '999,999,999.99' )) + ')'
endif

w := 'WINIEN(' + AllTrim( Transform( w, '999,999,999.99' )) + ')'
m := 'MA(' + AllTrim( Transform( m, '999,999,999.99' )) + ')'

Alarm( h + ' : ' + w + ' - ' + m + ' = ' + r )

if zos
   ViewDBF( 'BABA_ZOS' )
   Select( bb )
endif

DBSetOrder( 1 )
DBGoTo( rr )
wy := 2

******************************************************************************
* Nr 71

procedure KontoDopisz( a )

local b := Odetnij( @a ), rr, ekran

Select( 'KNORDPOL' )
if !Empty( b )
   rr := At( '-', buff )
   rr := if( rr = 0 .or. rr < 2, 1, rr - 1 )
   DBSeek( Left( buff, rr ), .t. )
endif

if !Empty( b )
   rr := RecNo()
   ekran := SaveScreen()
   NewSysForm( 'KONTO_MAIN,Dane konta gí¢wnego', .t., .t. )
   DBGoTo( rr )
endif

NewSysDopisz( a,, { || KNORDPOL->KONTO := buff,;
                       KNORDPOL->TRESC := b })

if ekran # NIL; RestScreen( ,,,, ekran ); endif
Keyboard Chr( K_ENTER )
set cursor on



******************************************************************************
* Nr 78 : a - hasío komunikatu

procedure ZEST1S_Tworz( a, h )

local n, i, k, wp, ow, om, sw, sm, bw, bm, mw, mm, swt, smt, bi

if ( n := Get_U( 10, 10, a, '99', 1 )) = NIL
   return
endif

if n < 1; return; endif

if Alarm( if( h = NIL, 'Bilansowaç salda?', h ), tk ) = 1
   bi := 1
endif

Czek( 1 )
ON( 'KNORDPOL' )
ON( 'ZEST1S' )
ON( 'ZEST1S',,,, .t. )
ON( 'ZEST1' )

wp := ''           && konto poprzedniego przebiegu pëtli
Przerwa( LastRec())
store 0 to ow, om, sw, sm, bw, bm, mw, mm
while !Eof()

      if !( Left( KONTO, n ) == wp )
         store 0 to ow, om, sw, sm, bw, bm, mw, mm
      endif

      ow += OBROTYWN
      om += OBROTYMA
      sw += SALDOWN
      sm += SALDOMA
      bw += BO_WINIEN

      bm += BO_MA
      mw += OBROTYMW
      mm += OBROTYMM

      if bi # NIL
         swt := Max( sw - sm, 0 )
         smt := Max( sm - sw, 0 )
         sw := swt
         sm := smt
      endif


      if Left( KONTO, n ) == wp
         AppendRecord( 'ZEST1S', { wp,, ow, om, sw, sm, bw, bm, mw, mm }, 1 )  && kolejny
      else
         wp := Left( KONTO, n )
         KNORDPOL->( DBSeek( wp, .t. ))
         AppendRecord( 'ZEST1S', { wp, KNORDPOL->TRESC, ow, om, sw, sm, bw, bm, mw, mm })  && pierwszy
         ZEST1S->TRESCG := KNORDPOL->TRESCG
      endif
      if Przerwa(); exit; endif
      DBSkip()
enddo
Przerwa( 0 )

GetIni( 'ZEST1', 1 )  && pobranie dat takich jak w zestawieniu obr. i sald

IncDBES( 1 )
ON( 'ZEST1S' ); Przerwa( LastRec())
while !Eof(); IncDBES(); Przerwa(); DBSkip(); enddo
Przerwa( 0 )

ON( 'ZEST1S' )
a := AllS( n ) + ' ' + if( n = 1, 'znaku', 'znak¢w' )
a := 'Zestawienie syntetyczne (do ' + a + ') w okresie ' + DtoC( data1 ) + '-' + DtoC( data2 )
DBE_Tyt := PadR( a, Max( Len( a ), Len( DBE_Tyt )))   && tytuí taki jak opcja
PutIni()
ShowDBES( 1 )  && bez GETIni() na poczatku

ON( 'ZEST1S' )
Czek( 0 )
wy := 2

******************************************************************************
* k - konto
* s - szablon

function Szablon( k, ss )

local s, wy := .f.

s := ss
while !Empty( s )
      if Szablons( k, Odetnij( @s ))   && czy "k" speínia jakÜû maskë dodatniÜ
         wy := .t.
         exit
      endif
enddo

if wy         && tak, speínia

s := ss
while !Empty( s )
      if Szablons( k, Odetnij( @s ), 1 )  && czy "k" speínia jakÜû maskë ujemnÜ
         wy := .f.    && niestety speínia, wiëc konto nie do przyjëcia
         exit
      endif
enddo

endif

return wy

******************************************************************************
* k - konto
* s - szablon
* m = NIL => przetwarzamy tylko maski dodatnie
* m # NIL => przetwarzamy tylko maski ujemne

function Szablons( k, s, m )

local i, n, a1, a2

k := AllTrim( k )
s := AllTrim( s )

if m = NIL                      && majÜ byç maski dodatnie
   if Left( s, 1 ) == '-'       && a jest ujemna
      return .f.                && wiëc nie speínia
   endif
else                            && majÜ byç maski ujemne
   if !( Left( s, 1 ) == '-' )  && a jest dodatnia
      return .f.                && wiëc nie speínia
   endif
   s := SubStr( s, 2 )          && jest ujemna, ale dalej bez minusa
endif

if ( i := At( '*', s )) # 0           && odetnij po '*'
   s := Left( s, i - 1 )
   n := Len( s )
else
   n := Max( Len( s ), Len( k ))
endif

k := PadR( k, n )                  && wyr¢wnanie konta
s := PadR( s, n )                  && wyr¢wnanie maski

if (k==s); return .t.
else
  for i := 1 to n
    a1 := Left( k, 1 )
    a2 := Left( s, 1 )
    if a2 == '?' .and. a1 == ' '             && ¶le
       return .f.
    elseif !( a2 == '?' .or. a1 == a2 )      && ¶le
       return .f.
    else
       k := SubStr( k, 2 )
       s := SubStr( s, 2 )           && przytnij i dalej
    endif
  next
endif

return .t.

******************************************************************************
* Nr 79 : a - hasío komunikatu

procedure ZEST1WB_Tworz( a )


konto_sys := PadR( konto_sys, 250 )
if ( a := Get_U( 10, 16, a, '@KS28', konto_sys )) = NIL
   return
endif

if Empty( a ); return; endif

konto_sys := a
a := AllTrim( a )

Czek( 1 )
ON( 'ZEST1' ); Przerwa( LastRec())
ON( 'ZEST1WB' )
ON( 'ZEST1WB',,,, .t. )
KopiaRec( 'ZEST1', 'ZEST1WB',,, { || Szablon( KONTO, a )}, {|| Przerwa()})
Przerwa( 0 )

GetIni( 'ZEST1', 1 )  && pobranie dat takich jak w zestawieniu obr. i sald

IncDBES( 1 )
ON( 'ZEST1WB' ); Przerwa( LastRec())
while !Eof(); IncDBES(); Przerwa(); DBSkip(); enddo
Przerwa( 0 )

ON( 'ZEST1WB' )
a := 'Wybrane konta (maska "' + AllTrim( a ) + '") w okresie ' + DtoC( data1 ) + '-' + DtoC( data2 )
DBE_Tyt := PadR( a, Max( Len( a ), Len( DBE_Tyt )))   && tytuí taki jak opcja
PutIni()
ShowDBES( 1 )  && bez GETIni() na poczatku



ON( 'ZEST1WB' )

Czek( 0 )
wy := 2

******************************************************************************
* Nr 80 : a - parametry dla formularza okreûlania konta i okresu
*         b - tytuí bazowy dla tabeli wynikowej
*         c - baza, gdy synteza,      puste, gdy analityka

procedure ZEST2_Tworz( a, b, c )

local i, k, w, m, baza

if !NewSysForm( a ); return; endif

data1 := data_od
data2 := data_do

if Empty( c )
   baza := 'ZEST2'
   c := .f.
else
   baza := c
   c := .t.
endif

Czek( 1 )

ON( baza )
ON( baza,,,, .t. )
ON( 'KNORDPOL' )
ON( 'NORDPOL', 2 )
DBSeek( DtoS( data_od ), .t. )

Przerwa( LastRec())
*k := LastRec()
store 0 to i, w, m
while DATA <= data_do .and. !Eof()

*      i ++
*      @ 0, 0 say Transform( i/k * 100, '999 %' )

      if Szablon( WINIEN, konto_sys )
         if c; w += KWOTA
         else; AppendRecord( baza, { DOK, NR, DATA, LP, PZ, KWOTA, 0, MA, NAZ1, NAZ2, OPIS })
         endif
      endif

      if Szablon( MA, konto_sys )
         if c; m += KWOTA
         else; AppendRecord( baza, { DOK, NR, DATA, LP, PZ, 0, KWOTA, WINIEN, NAZ1, NAZ2, OPIS })
         endif
      endif

      if Przerwa(); exit; endif


      DBSkip()
enddo
Przerwa( 0 )

ON( 'KNORDPOL' )
DBSeek( StrTran( StrTran( AllTrim( konto_sys ), '*', '' ), '?', '' ), .t. )
DBE_Tyt := b + AllTrim( konto_sys ) + ' ( ' + AllTrim( KNORDPOL->TRESC ) + ' ) '

ON( baza )

if c               && tylko jeden sumaryczny
   ON( baza,,,, .t. )
   AppendRecord( baza, { ,,,,, w, m, })
endif

Czek( 0 )
wy := 2

******************************************************************************

function RdzenKontoSys( konto_sys )

local i

do case                                     && ustalenie rdzenia maski konta
   case 0 < ( i := At( ',', konto_sys )); i := ''
   case 0 < ( i := At( ':', konto_sys )); i := ''
   case 0 < ( i := At( '?', konto_sys )); i := Left( konto_sys, i - 1 )
   case 0 < ( i := At( '*', konto_sys )); i := Left( konto_sys, i - 1 )
otherwise
   i := AllTrim( konto_sys )
endcase

return i

******************************************************************************

procedure Zest22Miel( i, c, d, baza, konto_sys, w, m, wbo, mbo, mto, e )

local ko

if mto = NIL; mto := .f.; endif  && wype≥nianie pola "INNE" w analityce, czyli "MIASTO"

if e = NIL
	e := ''
else
	Zwolnij( 'NORDPOL' )
endif

ON( 'ZEST2S', 2 )
ON( e + 'NORDPOL', 3 )     && przetwarzanie czëûci WINIEN
DBSeek( i, .t. )       && ustaw na rdzeniu
Przerwa( LastRec())
while if( Empty( i ), .t., Left( WINIEN, Len( i )) == i ) .and. !Eof()  && wszystkie zgodne z rdzeniem

		if !zbo .and. Left( DOK, 2 ) == 'BO'; skip; loop; endif

      if DATA >= data_od .and.;
         DATA <= data_do .and.;
         Szablon( WINIEN, konto_sys ) .and.;
         Szablon( MA,     konto_prz )
         if c; w += KWOTA
         else
         ko := WINIEN
         if ZEST2S->( !DBSeek( ko ))
            AppendRecord( 'ZEST2S', { DOK, NR, DATA, LP, PZ, KWOTA, 0, MA, NAZ1, NAZ2, OPIS, WINIEN })
         else
            ZEST2S->OBROTYWN := ZEST2S->OBROTYWN + KWOTA
         endif
         AppendRecord( baza, { DOK, NR, DATA, LP, PZ, KWOTA, 0, MA, NAZ1, NAZ2, OPIS, WINIEN, NRZLEC })
         if mto .and. KNORDPOL->( DBSeek(( baza )->KONTO ))
            ( baza )->INNE := AllTrim( KNORDPOL->MIASTO )
            if !Empty(( baza )->INNE )
               ( baza )->INNE := AllTrim(( baza )->INNE ) + ', ' + AllTrim( KNORDPOL->ULICA )
            endif
         endif
         endif
      elseif d # NIL .and.;
         DATA < data_od .and.;
         Szablon( WINIEN, konto_sys ) .and.;
         Szablon( MA,     konto_prz )
         ko := WINIEN
         if ZEST2S->( !DBSeek( ko ))
            AppendRecord( 'ZEST2S', { DOK, NR, DATA, LP, PZ, KWOTA, 0, MA, NAZ1, NAZ2, OPIS, WINIEN })
         else
            ZEST2S->OBROTYWN := ZEST2S->OBROTYWN + KWOTA
         endif
         wbo += KWOTA
      endif

      if Przerwa(); exit; endif

      DBSkip()
enddo
Przerwa( 0 )

if e = NIL
	e := ''
else
	Zwolnij( 'NORDPOL' )
endif

ON( e + 'NORDPOL', 4 )     && przetwarzanie czëûci MA
DBSeek( i, .t. )       && ustaw na rdzeniu
Przerwa( LastRec())
while if( Empty( i ), .t., Left( MA, Len( i )) == i ) .and. !Eof()  && wszystkie zgodne z rdzeniem

		if !zbo .and. Left( DOK, 2 ) == 'BO'; skip; loop; endif

      if DATA >= data_od .and.;
         DATA <= data_do .and.;
         Szablon( MA, konto_sys ) .and.;
         Szablon( WINIEN, konto_prz )
         if c; m += KWOTA
         else
         ko := MA
         if ZEST2S->( !DBSeek( ko ))
            AppendRecord( 'ZEST2S', { DOK, NR, DATA, LP, PZ, 0, KWOTA, WINIEN, NAZ1, NAZ2, OPIS, MA })
         else
            ZEST2S->OBROTYMA := ZEST2S->OBROTYMA + KWOTA
         endif
         AppendRecord( baza, { DOK, NR, DATA, LP, PZ, 0, KWOTA, WINIEN, NAZ1, NAZ2, OPIS, MA, NRZLEC })
         if mto .and. KNORDPOL->( DBSeek(( baza )->KONTO ))
            ( baza )->INNE := AllTrim( KNORDPOL->MIASTO )
            if !Empty(( baza )->INNE )
               ( baza )->INNE := AllTrim(( baza )->INNE ) + ', ' + AllTrim( KNORDPOL->ULICA )
            endif
         endif
         endif
      elseif d # NIL .and.;
         DATA < data_od .and.;
         Szablon( MA, konto_sys ) .and.;
         Szablon( WINIEN, konto_prz )
         ko := MA
         if ZEST2S->( !DBSeek( ko ))
            AppendRecord( 'ZEST2S', { DOK, NR, DATA, LP, PZ, 0, KWOTA, WINIEN, NAZ1, NAZ2, OPIS, MA })
         else
            ZEST2S->OBROTYMA := ZEST2S->OBROTYMA + KWOTA
         endif
         mbo += KWOTA
      endif

      if Przerwa(); exit; endif

      DBSkip()
enddo
Przerwa( 0 )

if e = NIL
	e := ''
else
	Zwolnij( 'NORDPOL' )
endif

******************************************************************************

function RozwinKontoSys( i, ks )

local s

if !Empty( konto_pse );
   .or.;
   !Empty( konto_nip );
   .or.;
   !Empty( konto_naz )

   s := ''
   DBSeek( i, .t. )
   while Szablon( KONTO, ks ) .and. !Eof()
         do case
            case !Empty( konto_pse ) .and. !Szablon( Upper( PSEUDO ), Upper( konto_pse ))
            case !Empty( konto_nip ) .and. !Szablon( Upper( NIP )   , Upper( konto_nip ))
            case !Empty( konto_naz ) .and. !Szablon( Upper( NAZWA  ), Upper( konto_naz ))
         otherwise
            s += ',' + AllTrim( KONTO )
         endcase
         skip
   enddo

   if Left( s, 1 ) == ','; s := SubStr( s, 2 ); endif

   ks := s

endif

return ks

******************************************************************************
* Nr 80': a - parametry dla formularza okreûlania konta i okresu
*         b - tytuí bazowy dla tabeli wynikowej
*         c - baza, gdy synteza,      puste, gdy analityka
*         d - nazwa dokumentu do wprowadzenia "B.O."
*         eee - katalogi archiwÛw do zwiedzenia

procedure ZEST22Tworz( a, b, c, d, eee )

local i, i1, k, ks, kss, w, m, wbo, mbo, baza, ii := IndexOrd(), pa := DBE_Tyt
local mto, e, ee

private ok_bo := .t., zbo                     && z BO czy bez ?

if eee = NIL; eee := ''; endif

if a = NIL .or. Empty( a )
   konto_prz := '*'                      && konto przeciwstawne
   if Get_Okres( @data_od, @data_do ) = NIL; return; endif
else
   konto_sys := PadR( konto_sys, 250 )
   konto_prz := PadR( konto_prz, 250 )
   if !NewSysForm( a ); return; endif
endif

konto_prz := AllTrim( konto_prz )
data1 := data_od
data2 := data_do

if Empty( c )
   baza := 'ZEST2'
   c := .f.
else
   baza := c
   c := .t.
endif

Czek( 1 )

ON( baza )
ON( baza,,,, .t. )

mto := ( FieldPos( 'INNE' ) # 0 )

store 0 to w, m, wbo, mbo

zbo := ok_bo                  && zapamiÍtaj co napisa≥
ok_bo := .t.                  && z BO !!!

ON( 'ZEST2S' )
ON( 'ZEST2S', 2,,, .t. )
ON( 'KNORDPOL' )

kss := konto_sys                                   && "200*,201*,202*"
konto_sys := ''
while !Empty( ks := Odetnij( @kss ))               && "200*"
      i := RdzenKontoSys( ks )                     && "200"
      konto_sys += ',' + RozwinKontoSys( i, ks )   && ",200-1-1"
enddo

if Left( konto_sys, 1 ) == ','; konto_sys := SubStr( konto_sys, 2 ); endif

DBE_Tyt := b + AllTrim( konto_sys ) + ' '

kss := konto_sys                             && "200-1-1,201-2-2,202-3-3"
kop := konto_prz                             && "200-1-1,201-2-2,202-3-3"
while !Empty( ks := Odetnij( @kss ))
      i := RdzenKontoSys( ks )
      if i1 = NIL; i1 := i; endif
		ee := eee
		while !Empty( e := Odetnij( @ee ))
			if (konto_prz=='*')
				Zest22Miel( i, c, d, baza, ks, @w, @m, @wbo, @mbo, mto, e )
			else
				ks := kop
				i := RdzenKontoSys( ks )
				konto_sys:=kop
				konto_prz:='*'
				Zest22Miel( i, c, d, baza, ks, @w, @m, @wbo, @mbo, mto, e )
				ks := kss
				i := RdzenKontoSys( ks )
				konto_sys:=kss
				konto_prz:=kop
			endif
		enddo
      Zest22Miel( i, c, d, baza, ks, @w, @m, @wbo, @mbo, mto )
enddo

ON( 'KNORDPOL' )
DBSeek( i1, .t. )    && pierwszy rdze§
DBE_Tyt := DBE_Tyt + '( ' + AllTrim( KNORDPOL->TRESC ) + ' ) '

ON( baza, ii )

if c               && tylko jeden sumaryczny
   ON( baza,,,, .t. )
   AppendRecord( baza, { 'SY',, data_do,,, w, m, })
endif

ok_bo := zbo

if ok_bo .and. d # NIL     && dodatkowy rekord bilansu otwarcia analityki/syntetyki konta
   AppendRecord( baza, { d,, data_od - 1,,, wbo, mbo,,,AllS(wbo-mbo,'999,999,999.99') + ' = wynik', 'Bilans otwarcia', i1 })
endif

Czek( 0 )

if ok_dod_bo
   BoAdd( d, 1 )
   AktSyn()
endif

if ok_kon
   Kondens( '', 1 )
   AktSyn()
endif

DBGoTop()

IncDBES( 1 )
Przerwa( LastRec())
while !Eof(); IncDBES(); Przerwa(); DBSkip(); enddo
Przerwa( 0 )

DBE_Tyt := DBE_Tyt + 'w okresie ' + DtoC( data1 ) + '-' + DtoC( data2 ) + if( !ok_bo, ' (bez B.O.)', '' )
if !( konto_prz == '*' )
   DBE_Tyt += ' (' + 'mkp:"' + konto_prz + '")'
endif
DBE_Tyt := PadR( DBE_Tyt, Max( Len( pa ), Len( DBE_Tyt )))   && tytuí taki jak opcja
PutIni()
ShowDBES( 1 )  && bez GETIni() na poczatku

DBGoTop()
wy := 2

*konto_sys := PadR( konto_sys, 18 )

******************************************************************************
* Dodanie "B.O." dla kaßdego subkonta

procedure BoAdd( d, dzk )

local fatab, tab, ko, k, i, ii, maska, mto, iii := 3, wboo := 0, mboo := 0

mto := ( FieldPos( 'INNE' ) # 0 )

if dzk = NIL
   ii := Alarm( 'Obliczyç "B.O." dla kaßdego subkonta/zlecenia ?',;
           { 'Subkonta tu wystëpujÜce', 'Subkonta okreûlone maskÜ', 'Zlecenia', 'Zlecenia NUM' })
else
   ii := 2
endif

maska := SubStr( DBE_Tyt, 7 )    && Konto 5* (
maska := Left( maska, At( '(', maska ) - 1 )

if ii = 0; return; endif
if ii = 2
   if dzk = NIL
      maska := PadR( maska, 100 )
      if ( maska := Get_U( 10, 10, 'Potwierd¶ maskë:', '@S30', maska )) = NIL; return; endif
      maska := AllTrim( maska )
   endif
endif

DBSetOrder( 4 )            && eliminacja zbëdnego "B.O."
DBGoTop()
if Left( DOK, Len( d )) == d
	wboo := OBROTYWN
	mboo := OBROTYMA
	BDelete()
endif

tab := {}
ko := ''

fatab:={}

if ii = 1                  && wystëpujÜce subkonta

Przerwa( LastRec())
go top
while !Eof()
      if !( ko == KONTO )
         ko := KONTO
         Aadd( tab, ko )
      endif

      if Przerwa(); exit; endif

      skip
enddo
Przerwa( 0 )

elseif ii = 3                  && wystëpujÜce zlecenia

iii := 5
DBSetOrder( 5 )			//Upper(NRZLEC)+DtoS(DATA)+Upper(DOK)
Przerwa( LastRec())
go top
while !Eof()
      if !( ko == NRZLEC )
         ko := NRZLEC
         Aadd( tab, ko )
         Aadd( fatab, DataFaktur( NRZLEC ))
      endif

      if Przerwa(); exit; endif

      skip
enddo
Przerwa( 0 )

elseif ii = 4                  && wystëpujÜce zlecenia

iii := 6
DBSetOrder( 7 )			//Str(Val(NRZLEC),4)+DTOS(DATA)+DOK+STR(NR)+STR(LP)
Przerwa( LastRec())
go top
ko := -1
while !Eof()
      if !( ko = Val( NRZLEC ))
         ko := Val( NRZLEC )
         Aadd( tab, ko )
         Aadd( fatab, DataFaktur( NRZLEC ))
      endif

      if Przerwa(); exit; endif

      skip
enddo
Przerwa( 0 )

dt := Len( tab )
ON( 'NORDPOL', iii )           && przetwarzanie czëûci WINIEN
go top
Przerwa( LastRec())
while !Eof()
   jj := NRZLEC
   if !Empty(jj) .and. ((j := Val(jj))>0)
	ok:=(1=1)
	for k := 1 to dt
		if tab[ k ] == j
			ok := (1=2)
		endif
	next
	if ok
		Aadd( tab, j )
		Aadd( fatab, DataFaktur( AllS(j) ))
		dt := Len( tab )
	endif
   endif
   if Przerwa(); exit; endif
   skip
while jj==NRZLEC .and. !Eof()
   if Przerwa(); exit; endif
   skip
enddo
enddo
Przerwa( 0 )

elseif ii = 2                    && subkonta wedíug maski

ON( 'KNORDPOL' )
Przerwa( LastRec())
while !Eof()

      if Szablon( KONTO, maska )
         Aadd( tab, KONTO )
      endif

      if Przerwa(); exit; endif

      skip
enddo
Przerwa( 0 )

endif

for k := 1 to Len( tab )

wbo := 0
mbo := 0

i := tab[ k ]

if iii = 6
	i := Str( i, 10, 4 )
endif

ON( 'NORDPOL', iii )           && przetwarzanie czëûci WINIEN
DBSeek( i, .t. )               && ustaw na rdzeniu
Przerwa( LastRec())
while if( iii = 5, NRZLEC == i, if( iii = 6, Val( NRZLEC ) = Val( i ), WINIEN == i )) .and. DATA < data_od .and. !Eof()

	if iii >= 5
		if Szablon( WINIEN, maska )
			if !Empty(NRZLEC)
				j:=1
				dt := NIL
				while j < Len( tab )
					if if( iii = 5, tab[ j ] == NRZLEC, tab[ j ] == Val( NRZLEC ))
						dt := fatab[ j ]
						exit
					endif
					j++
				enddo
//				if dt # NIL .and. DATA < data1	&&Month( dt ) > Month( DATA ) .and. Year( dt ) = Year( DATA )
					wbo += KWOTA
//				endif
			endif
		endif
	else
		if Szablon( WINIEN, i ) .and.;
		   Szablon( MA,     konto_prz )
			wbo += KWOTA
		endif
	endif

      if Przerwa(); exit; endif

      DBSkip()
enddo
Przerwa( 0 )

if iii >= 5
	ON( 'NORDPOL', iii )     && przetwarzanie czëûci MA
else
	ON( 'NORDPOL', 4 )     && przetwarzanie czëûci MA
endif

DBSeek( i, .t. )       && ustaw na rdzeniu
Przerwa( LastRec())
while if( iii = 5, NRZLEC == i, if( iii = 6, Val( NRZLEC ) = Val( i ), MA == i )) .and. DATA < data_od .and. !Eof()  && wszystkie zgodne z rdzeniem

	if iii >= 5
		if Szablon( MA, maska )
			if !Empty(NRZLEC)
				j:=1
				dt := NIL
				while j < Len( tab )
					if if( iii = 5, tab[ j ] == NRZLEC, tab[ j ] == Val( NRZLEC ))
						dt := fatab[ j ]
						exit
					endif
					j++
				enddo
//				if dt # NIL .and. DATA < data1	&& Month( dt ) > Month( DATA ) .and. Year( dt ) = Year( DATA )
					mbo += KWOTA
//				endif
			endif
		endif
	else
	      if Szablon( MA, i ) .and.;
        	 Szablon( WINIEN, konto_prz )
        	 mbo += KWOTA
	      endif
	endif

      if Przerwa(); exit; endif

      DBSkip()
enddo
Przerwa( 0 )

if iii >= 5
	if ( wboo # 0 .or. mboo # 0 ) .and. ( wboo - mboo = 0 )	&& jeúli wynik poprzedniego okresu jest zerowy to bilansy zerowe
		wbo := 0
		mbo := 0
	endif
   if int(Val(i))==Val(i)
	AppendRecord( baza, { d,, data_od - 1,,, wbo, mbo,,,AllS(wbo-mbo,'999,999,999.99') + ' = wynik', 'Bilans otwarcia',, i })
   endif
else
	AppendRecord( baza, { d,, data_od - 1,,, wbo, mbo,,,AllS(wbo-mbo,'999,999,999.99') + ' = wynik', 'Bilans otwarcia', i })
endif

if mto .and. KNORDPOL->( DBSeek(( baza )->KONTO ))
   ( baza )->INNE := AllTrim( KNORDPOL->MIASTO )
   if !Empty(( baza )->INNE )
      ( baza )->INNE := AllTrim(( baza )->INNE ) + ', ' + AllTrim( KNORDPOL->ULICA )
   endif
endif

next

wy := 2
Select( baza )

if ii = 2                  && subkonta wedíug maski

Przerwa( LastRec())
DBSetOrder( 4 )            && eliminacja zbëdnego "B.O."
DBGoTop()
while !Eof()

      if Left( DOK, Len( d )) == d;
         .and.;
         OBROTYWN = 0;
         .and.;
         OBROTYMA = 0;
         .and.;
         NextInne( KONTO )

         BDelete()

      endif

      if Przerwa(); exit; endif


      skip

enddo
Przerwa( 0 )

endif

if ii >= 4

Przerwa( LastRec())
DBSetOrder( 4 )            && eliminacja zbëdnego "B.O."
DBGoTop()
while !Eof()

      if Left( DOK, 2 ) == 'BO';
         .and.;
         OBROTYWN = 0;
         .and.;
         OBROTYMA = 0

         BDelete()

      endif

      if Przerwa(); exit; endif

      skip

enddo
Przerwa( 0 )

endif

go top

******************************************************************************

function NextInne( ko )

local w, rr := RecNo()


skip
if Eof()
   w := .t.
else
   w := !( ko == KONTO )

endif

DBGoTo( rr )

return w

******************************************************************************
* Nr 81 : a - parametry dla formularza okreûlania typu i okresu
*         b - tytuí bazowy dla tabeli wynikowej

procedure ZEST3_Tworz( a, b )

if !NewSysForm( a ); return; endif

MemVar->data1 := data_od
MemVar->data2 := data_do

Czek( 1 )

ON( 'ZEST3' )
ON( 'ZEST3',,,, .t. )
ON( 'NORDPOL', 2 )
Przerwa( LastRec())

KopiaRec( 'NORDPOL', 'ZEST3',,,;
        { || NORDPOL->DATA >= data_od .and.;
             NORDPOL->DATA <= data_do .and.;
             NORDPOL->DOK == typ_sys }, {|| Przerwa()})
Przerwa( 0 )

IncDBES( 1 )
ON( 'ZEST3' ); Przerwa( LastRec())
while !Eof(); IncDBES(); Przerwa(); DBSkip(); enddo
Przerwa( 0 )

ON( 'ZEST3' )
a := 'Dokumenty "' + AllTrim( typ_sys ) + '" z okresu: ' + DtoC( MemVar->data1 ) + '-' + DtoC( MemVar->data2 )
DBE_Tyt := PadR( a, Max( Len( a ), Len( DBE_Tyt )))   && tytuí taki jak opcja
PutIni()
ShowDBES( 1 )  && bez GETIni() na poczatku

ON( 'ZEST3' )
Czek( 0 )
wy := 2


******************************************************************************
* Renumeracja pola "Nr"

procedure RenumNr()

local x, ii, rrr, bb, d, n

d := DOK
n := NR
if ( x := Get_U( 10, 10, 'O ile przesunÜç wartoûç "Nr" dokument¢w "' + AllTrim( d ) + '" o numerze >= ' + AllS( n ) + ' ? :', '999', 0 )) = NIL; return; endif

ii := IndexOrd()
rrr:= RecNo()
bb := Alias()

Czek( 1 )
Przerwa( LastRec())
DBSetOrder( 0 )
DBGoTop()
while !Eof()
      if DOK == d .and. NR >= n
         ( bb )->( Blokuj_R())
         ( bb )->NR := NR + x
         ( bb )->( OdBlokuj_R())
      endif
      DBSkip()
      if Przerwa(); exit; endif
enddo
Przerwa( 0 )
Czek( 0 )

DBSetOrder( ii )
DBGo( rrr )
wy := 2

******************************************************************************
* Renumeracja dokumentow w "NORDPOL", tworzenie lub zasklepianie luki "NR"
* RenumDK( 'Formularz,Podaj : do, nu, el, de', 'DOK+Str(NR)+Str(LP)' )

procedure RenumDK( a, b )

local rr, eo, bb, ii, rrr, i

private do, nu, el, de     && dokument, numer, "LP", delta

bb := Alias()
ii := IndexOrd()
rrr:= RecNo()

do := DOK
nu := NR
el := LP
de := 0

i := Alarm( 'Wybierz wariant renumeracji:', { ' renumeracja "LP" ', ' renumeracja "NR" ' })
if i = 0; return; endif
if i = 2; RenumNr(); return; endif

if !NewSysForm( a ); return; endif
if de = 0; return; endif

set filter to
CreateIndex( b )

Czek( 1 )

if de < 0                      && zasklepianie luki ( zmniejszanie NR )

DBSeek( do + Str( nu ) + Str( el ))
eo := .f.
Przerwa( LastRec() - RecNo())
while DOK == do .and. nu = NR .and. !eo
      DBSkip(); rr := RecNo(); eo := Eof(); DBSkip( -1 )    && we¶ nastëpny rekord
      ( baza )->( Blokuj_R())
      ( baza )->LP := LP + de
      ( baza )->( OdBlokuj_R())
      DBGo( rr )
      Przerwa()
enddo

Przerwa( 0 )

else                           && tworzenie luki ( zwiëkszanie NR )

DBSeek( do + Str( nu ) + '9999', .t. )     && ostatni
DBSkip( -1 )
eo := .f.
Przerwa( LastRec() - RecNo())
while DOK == do .and. NR = nu .and. LP >= el .and. !eo
      DBSkip( -1 ); rr := RecNo(); eo := Bof(); DBSkip( 1 )  && we¶ poprzedni rekord
      ( baza )->( Blokuj_R())
      ( baza )->LP := LP + de
      ( baza )->( OdBlokuj_R())
      DBGo( rr )
      Przerwa()
enddo
Przerwa( 0 )

endif

Czek( 0 )

Select( bb )
DBSetOrder( ii )
DBGo( rrr )
wy := 2

******************************************************************************
* kat - katalog traktowany zamiennikami

function Zamiennik( kat )

static ca
local a, b, c, line, zamie

if kat = NIL .or. Empty( kat ); return kat; endif

if '...' $ kat
   if ca = NIL; ca := 'C:'; endif
   kat := Get_U( 10 , 20 , 'Podaj katalog danych:' , '@S20' , PadR( ca, 40 ))
   if kat = NIL .or. Empty( kat ); return kat; endif
   kat := AllTrim( kat )
   ca := kat
endif


kat := Upper( kat )

zamie := Upper( ReadWzor( 'zamienik.txt' ))     && zmienniki katalogu
zamie := StrTran( zamie, ' ', '' )
zamie := StrTran( zamie, EOL, '' )

while !Empty( zamie )
    a := Odetnij( @zamie )              && co
    b := Odetnij( @zamie )              && na co
    kat := StrTran( kat, a, b )         && zamieniaç
enddo

return kat

******************************************************************************

function Kasa( c, dt )

return c + SubStr( DtoS( dt), 5, 2 ) + SubStr( DtoS( dt ), 3, 2 )

******************************************************************************

procedure AutoAuto( nr )

local i := 0, te, tr, sc := SaveScreen(), t1, t2, x := 0, a, bb := Alias()

private stop := .f.

t1 := Time()
SYS_MENU->( DBSeek( Str( nr, 2 )))
while !stop .and.;
      SYS_MENU->( !Eof() .and.;
                  KOD_MENU = nr .and.;
                  Left( P_SYSTEMU, 8 ) # 'AutoAuto' )
      a := SYS_MENU->P_SYSTEMU
		if ',i,' $ a
	      a := StrTran( a, ',i,', ',' + AllS( i++ ) + ',' )
		else
	      a := StrTran( a, ')', ',' + AllS( i++ ) + ')' )
		endif
      if a # NIL .and. !Empty( a )
         x += RunCommand( a )
      endif
      SYS_MENU->( DBSkip())
enddo

if x = 0
   a := Alias()
   if Left( a, 4 ) == 'BABA'     && kasuj zbëdny rekord informacyjny
      if ( a )->KWOTA = -999999.99
         ( a )->( BDelete())
      endif
   endif
endif

i += 2
t2 := Time()
if !stop
   Czek( 0 )
   @ i, 0 clear
   @ i, 0 say ''
   ? 'Start: ' + t1
   ? ' Stop: ' + t2
   ?
   ? 'Wciûnij klawisz ENTER...'

if AutoImpNot
   te := ''
   tr := StrTran( SaveScreen(), Chr( 7 ), '' )
   while !Empty( tr )
         te += Left( tr, 80 ) + EOL
         tr := SubStr( tr, 81 )
   enddo

   ON( 'NOTATKI' )
   if !Empty( osoba_upr )
      AppendRecord( , { Datee(),, 'Auto import (' + osoba_upr + ')', te })
   else
      AppendRecord( , { Datee(),, 'Auto import (' + if( osobne = NIL, nr_stacji, osobne ) + ')', te })
   endif
   Jest_baza( bb )
endif

   Tone( ton2, 1 )
   LastZero()
   Inkey( 0 )

endif
RestScreen( ,,,, sc )


******************************************************************************
* AutoDekret na podstawie danych z baz danych
* mode = 0 .or. NIL => normal
* mode > 0 => bez pytania o parametry
* dlagb => dla zainicjowania globalbuf
* bb - baza do prze≥πczenia na czas importu
* ss = save screen

function AutoDekret( a, mode, dlagb, bb, ss )

local buf, impre, ok, ob, po, za, r, a1, a2, h, brakbaza, sourbaza
local maxpole, sumpole, zz, zzl, zzp, zzz := {}, bp, rroryg := 1

static jestinfo := .t.

if bb # NIL
	bp := baza
	baza := bb
	bb := Alias()
endif

importIDLP := NIL

if mode # NIL .and. mode < 0     && wezwania do zapíaty
   r := NIL
   mode := 2
else
   r := mode
endif

globalbuf := PadR( if( dlagb = NIL, '', dlagb ), 99 )

a := ReadWzor( a )     && odczyt definicji dekretacji

private rrr, cc, nn := 1, kluczcz, lp_baza, lp := 0

Select( baza )
if Left( Alias(), 4 ) == 'BABA'     && kasuj zbëdny rekord informacyjny
   DBSetOrder( 0 )
endif

set filter to
DBGoBottom()
rrr := ( baza )->( RecNo())
lp_baza := LP                    && pole LP bazy lub zmienna LP
kluczcz := NIL

if mode = NIL .or. mode = 1
   jestinfo := .t.
   if !NewSysDopisz( Odetnij( @a ) + ',' + Odetnij( @a ),, { || ( baza )->LP++ })
      stop := .t.
      if Left( Alias(), 4 ) == 'BABA'     && kasuj zbëdny rekord informacyjny
         DBSetOrder( 1 ) && ßeby "Pozycja" wskakiwaío gdzie trzeba, a nie na ko§cu
      endif
		if bb # NIL
			baza := bp
			Jest_baza( bb )
		endif
      return 0
   endif
   rrr := ( baza )->( RecNo())
   lp_baza := ( baza )->LP
   Blokuj_R()
   ( baza )->LP --
   if Left( baza, 4 ) == 'BABA'     && kasuj zbëdny rekord informacyjny
      ( baza )->KWOTA := -999999.99
		if Left( a, 5 ) == 'LPRAC'		&& import list p≥ac pracownikÛw
			private mmID := {}, mmNR := {}, mmi
			ON( 'LPLAC', 3 )
			DBSeek( DtoS( data_od ), .t. )
			while ( DATA <= data_do ) .and. !Eof()
					Aadd( mmID, ID )
					Aadd( mmNR, AllTrim( NUMER ))
					skip
			enddo
			if Len( mmID ) > 1
				mmi := Alarm( 'Wybierz jednπ z list z podanego okresu;Esc=brak wyboru, czyli wszystkie listy:', mmNR, .t. )
				if mmi = 0
				else
					importIDLP := mmID[ mmi ]
				endif
			endif
			Jest_baza( baza )
		endif
   endif
else
   if Empty( Odetnij( @a ))			&& 1
      jestinfo := .f.
   endif
   Odetnij( @a )							&& 2
*   KopiujRec( baza, baza )
*   Blokuj_R()
*   if 'BABA' $ Upper( baza )
*      ( baza )->LP ++
*      ( baza )->PZ := 1
*   endif
endif

if r = NIL .or. ss # NIL; Czek( 1 ); endif
buf := Odetnij( @a )						&& 3
if '\' $ buf														&& ze ûcießkÜ
   cc := RAt( '\', buf )
   if 'Kasa(' $ buf												&& import kasy z "Handlu"
      kluczcz := RunCommand( SubStr( buf, cc + 1 ))
      buf := Zamiennik( Left( buf, cc - 1 ))
      RunProgram( 'copy,' + buf + '\' + kluczcz + '.db? ' + buf + '\kasa.db? >nul' )
      RunProgram( 'copy,' + buf + '\' + kluczcz + 'd.ntx '+ buf + '\kasa.ntx >nul' )
      brakbaza := Upper( buf + '\' + 'kasa.dbf' )
      if File( brakbaza )
         brakbaza := NIL
         ON( 'kasa',, buf )
      endif
   else
      a1 := SubStr( buf, cc + 1 )
      a2 := Zamiennik( Left( buf, cc - 1 ))
      brakbaza := Upper( a2 + '\' + a1 + '.dbf' )
      if ( 'ZEST1.DBF' $ brakbaza ) .or. File( brakbaza )
         brakbaza := NIL
         ON( a1,, a2 )
      endif
   endif
else
   brakbaza := Upper( buf + '.dbf' )
   if File( brakbaza )
      brakbaza := NIL
      if !Jest_baza( buf )
         ON( buf )              && otw¢rz bazë rejestru
      endif
   endif
endif

impre := 0              && importowanych rekord¢w licznik
sumpole := 0            && suma maksymalnych wartoûci dekretowanych p¢l

if brakbaza = NIL

Przerwa( LastRec())

ob := ''
mode := '0'
if IsDigit( a )        && jest jakaû mutacja definicji importu
   mode := Odetnij( @a )					&& 4
   do case
      case mode = '1'                  && wariant dla Sz.
           ob := Odetnij( @a )         && 5 obudowa pierwszego parametru ( '@' )
           po := Odetnij( @a )			&& 6 pole z bazy docelowej ( KWOTA:= )
				if !Empty( po ); po += ':='; endif
           za := Odetnij( @a )         && 7 zmiennik maíego "x"
           if !( Left( a, 2 ) == EOL ) && jest podany numer i klucz indeksu
              DBSetOrder( Val( Odetnij( @a )))	&& 8
              kluczcz := Odetnij( @a )   			&& 9 klucz 'seek'
              buf := &kluczcz 
              DBSeek( buf, .t. )
              if ss # NIL
                 rroryg := RecNo()
              endif
              kluczcz := StrTran( Odetnij( @a ), EOL, '' )   && 10 klucz 'while'
              if ('=x'$kluczcz)
                 kluczcz := StrTran( kluczcz, '=x', '=' + AllS( buf ))
              endif
           endif
   otherwise
      DBSetOrder( Val( mode ))
      DBGoTop()
   endcase
endif

if Left( a, 1 ) == '#' .or. Left( a, 3 ) == EOL + '#'    && import reszty pliku
   a := Odetnij( @a )         && ûcießka + plik
   a := StrTran( a, EOL, '' ) && pominiëcie EOL
   a := StrTran( a, "#", '' ) && pominiëcie "#"
   a := ReadWzor( a )         && odczyt definicji dekretacji
   while !( Left( a, 2 ) == EOL )
       buf := Odetnij( @a )   && wyprztykanie parametr¢w z "a"
   enddo
endif

buf := a               && zachowaj "a" w tej postaci
sourbaza := Alias()
while if( kluczcz = NIL, .t., &kluczcz ) .and. !Eof()
      a := buf
      if ( Left( baza, 4 ) == 'BABA' );      && niby "BABA"
         .and.;                              && ale
         !( baza == "BABA" )                 && np.: "BABA2"
         a := StrTran( a, 'BABA', baza )     && zmie§ w definicji
      endif      
      while !Empty( a )

            ok := .t.
            zzl := .f.
            zzp := .f.
            cc := Odetnij( @a )                && parametr
            cc := StrTran( cc, EOL, '' )

            if mode == '1'                     && wariant Sz.
               cc := StrTran( ob, '@', cc )    && obudowanie
            endif

            cc := StrTran( cc, ';', ',' )
            cc := StrTran( cc, Chr(10), '' )
            cc := &cc

            if cc = NIL .or. cc
               if mode == '1' .and. if( ob = NIL, .t., !( ob =='@' ))          && wariant Sz.
                  cc := Odetnij( @a )             && parametr ( K9 )
                  cc := AllTrim( StrTran( cc, ';', ',' ))
                  if Left( cc, 1 ) == '+'          && +1.
                     zzl := .t.
                     zz := Val( Odetnij( @cc, '.' ))  && 1
                     while zz > Len( zzz )
                           Aadd( zzz, NIL )
                     enddo
                  endif
                  if ok := ( cc == '0' .or. (( &cc ) # 0 ))
                     if Left( cc, 1 ) == '+' && jest znacznik "narastajπco"
                        cc := SubStr( cc, 2 )&& wytnij ten znacznik
                        cc := '+' + baza + '->' + po + cc   && i przepisz go z przodu
                     else
                        cc := baza + '->' + po + cc
                     endif
                  endif
               endif
            else
               ok := .f.
            endif

            if ok
               impre ++
               zzp := .f.
               if cc # NIL
                  if zzl                        && rekord do zapamiÍtania
                     if zzz[ zz ] = NIL
                        zzp := .t.              && pierwszy raz
                        KopiujRec( baza, baza ) 
                        zzz[ zz ] := ( baza )->( RecNo())
                     else
                        ( baza )->( DBGoTo( zzz[ zz ]))  && nastÍpny raz
                     endif
                  else
                     KopiujRec( baza, baza )
                  endif
               endif
               ( baza )->( Blokuj_R())
               if mode == '1' .and. if( ob = NIL, .t., !( ob =='@' ))         && wariant Sz.
                  cc := Mutuj( cc, zzp, zzl )
                  cc := ( &cc )                   && realizacja "a"
               endif
               while !Empty( cc := Odetnij( @a ))
                     if !zzl .or. zzp              && jest znacznik "nienarastajπco"
                        cc := Mutuj( cc, zzp, zzl )
                        cc := baza + '->' + cc
                        if mode == '1'                     && wariant Sz.
                           cc := StrTran( cc, 'x', za )    && zmiennik "x"
                        endif
                        cc := StrTran( cc, ';', ',' )
                        cc := StrTran( cc, Chr(10), '' )
                        cc := StrTran( cc, '(baza)', baza )
                        cc := ( &cc )                      && realizacja "a"
                     endif
               enddo
               if Left( baza, 4 ) == 'BABA'
            if ( baza )->( FieldPos( 'SOURCE_BA' )) # 0
               ( baza )->SOURCE_BA := sourbaza
               ( baza )->SOURCE_LP := if(( sourbaza )->( FieldPos( 'LP' )) # 0, ( sourbaza )->LP, 0 )
               ( baza )->SOURCE_DT := Date()
               ( baza )->SOURCE_CZ := Time()
               ( baza )->SOURCE_OS := numer_o
               ( baza )->SOURCE_UW := 'Okres: ' + DtoC( data_od ) + '-' + DtoC( data_do )
            endif
                  if maxpole = NIL
                     maxpole := ( baza )->KWOTA
                  else
                     if maxpole > 0
                        maxpole := Max( maxpole, ( baza )->KWOTA )
                     else
                        maxpole := Min( maxpole, ( baza )->KWOTA )
                     endif
                  endif
               endif
            else                                        && jeûli ¶le
               while !Empty( Odetnij( @a )); enddo      && wyprztykaj "a"
            endif               
      enddo
      if maxpole # NIL .and. Left( baza, 4 ) == 'BABA'
         sumpole += maxpole
         maxpole := NIL
      endif
      if Przerwa(); exit; endif
      ( baza )->( DBGoBottom())     && po skokach do "narastajπco" mÛg≥ staÊ gdzie indziej
      skip
enddo
Przerwa( 0 )

if ss # NIL
   DBGoTo(rroryg)
else
   use
endif

endif

Select( baza )

if jestinfo
   if r # NIL .and. impre = 0   && nie kasowaç rekordu inf. !!!
   else
      jestinfo := .f.
      DBGoTo( rrr )                       && kasowaç informacyjny
      if Left( Alias(), 4 ) == 'BABA'     && kasuj zbëdny rekord informacyjny
         if KWOTA = -999999.99; BDelete(); endif
         DBSetOrder( 1 ) && ßeby "Pozycja" wskakiwaío gdzie trzeba, a nie na ko§cu
      else
         BDelete()
      endif
   endif
endif

if Len( zzz ) > 0    && jak narastajπco, to nie wiadomo jaka suma
   Select( baza )
   DBGoTop()
   sumpole := 0
   while !Eof()
         sumpole += ( baza )->KWOTA
         skip
   enddo
endif

if ss # NIL    //wariant z importem dekretÛw pod dokumentem zakupu
   DBGoTop()
else
   DBGoBottom()
endif
wy := 2

if r = NIL .or. ss # NIL
   Czek( 0 )
   @ 0, 0 clear to 0, mc
   if brakbaza # NIL
      h := 'brak potrzebnej bazy danych: ' + brakbaza
   else

      h := AllS( impre ) + ' powstaíych pozycji'
      if sumpole # 0; h += ' (' + AllS( sumpole, '999,999,999,999.99' ) + ' zí)'; endif
   endif
   @ 2, 0 say PadR( h, mc )
else
   if r = 1
      cls
      Czek( 1 )
      @ 0, 0 say 'Okres: ' + DtoC( data_od ) + ' - ' + DtoC( data_do )
      @ 2, 0 say 'Iloûç i opis importowanych danych'
   endif
   mode := AllTrim( SYS_MENU->N_OPCJI )
   if Len( mode ) > 1
      if brakbaza # NIL
         @ r + 3, 0 say 'brak "' + brakbaza + '" : ' + mode
      else
         h := PadL( AllS( impre ), 5 ) + ' : ' + mode
         if sumpole # 0; h += ' (' + AllS( sumpole, '999,999,999,999.99' ) + ' zí)'; endif
         @ r + 3, 0 say h
      endif
   endif
endif

if Left( Alias(), 4 ) == 'BABA'     && kasuj zbëdny rekord informacyjny
   DBSetOrder( 1 ) && ßeby "Pozycja" wskakiwaío gdzie trzeba, a nie na ko§cu
endif

importIDLP := NIL

if bb # NIL
	baza := bp
	Jest_baza( bb )
endif

return impre

******************************************************************************

function Mutuj( cc, zzp, zzl )

local x

cc := AllTrim( cc )
cc := StrTran( cc, EOL, '' )
cc := StrTran( cc, Chr(10), '' )

if zzp                     && pierwszy raz
   if Left( cc, 1 ) == '+' && jest znacznik "narastajπco"
      cc := SubStr( cc, 2 )&& wytnij ten znacznik, øeby inicjowaÊ wartoúÊ, a nie zwiÍkszaÊ
   endif
   if Left( cc, 1 ) == '-' && jest znacznik "nienarastajπco"
      cc := SubStr( cc, 2 )&& wytnij ten znacznik, øeby inicjowaÊ wartoúÊ
   endif
endif

if zzl                     && narastajπco
   if Left( cc, 1 ) == '+' && jest znacznik "narastajπco"
      cc := SubStr( cc, 2 )&& wytnij ten znacznik, øeby inicjowaÊ wartoúÊ, a nie zwiÍkszaÊ
      x := Odetnij( cc, ':=' )
      cc := StrTran( cc, ':=', ':=' + x + '+' )       && BABA->KWOTA:=BABA->KWOTA+PRZYCHOD
   endif
endif

return cc

******************************************************************************
* Przetworzenie definicji typu "Wn()", "Ma()", "Su()"
* sur - tablica baz ¶r¢díowych
* surname - tablica ich nazw
* okres # NIL => pyta o zakres dat

procedure PrzWnMa( sur, surname, okres )

local bb := Alias(), a, i, d, w

if sur = NIL
   if okres = NIL
      if Alarm( 'Przetwarzaç dane ?', tk ) # 1; return; endif
   else
      if Get_Okres( @data1, @data2 ) = NIL; return; endif
   endif
else
   a := Alarm( 'Wybierz ¶r¢dío danych do przetwarzania:', surname )
   if a = 0; return; endif
   sur := sur[ a ]
endif

Czek( 1 )

globalbuf := if( sur = NIL, 'ZEST1', sur )

if okres = NIL
   GetIni( globalbuf, 1 )  && pobranie dat takich jak w zestawieniu obr. i sald
endif

ON( globalbuf )
ON( bb )
while !Eof()
      ( bb )->( Blokuj_R())
      for i := 1 to FCount()
         if 'DEFINICJA' $ Field( i )
            d := i
            w := i + 1
            if ( 'SU' $ Upper( buf := ( bb )->( FieldGet( d ))));   && sumy zerowane
               .or.;
               ( 'PO' $ Upper( buf := ( bb )->( FieldGet( d ))));   && sumy zerowane
               .or.;
               ( 'PR' $ Upper( buf := ( bb )->( FieldGet( d ))));   && sumy zerowane
               .or.;
               Empty( buf )
                  ( bb )->( FieldPut( w, 0 ))
            else
                  ( bb )->( FieldPut( w, ( globalbuf )->( &buf )))
            endif
         endif
      next
      DBSkip()
enddo

ON( bb ); DBGoBottom()
while !Bof()
      for i := 1 to FCount()
         if 'DEFINICJA' $ Field( i )
            d := i
            w := i + 1
            if ( 'SU' $ Upper( buf := ( bb )->( FieldGet( d ))))    && sumy obliczane
               ( bb )->( Blokuj_R())
               ( bb )->( FieldPut( w, ( bb )->( &buf ) ))
            endif
         endif
      next
      DBSkip( -1 )
enddo

ON( bb )
while !Eof()
      for i := 1 to FCount()
         if 'DEFINICJA' $ Field( i )
            d := i
            w := i + 1
            if ( 'PO' $ Upper( buf := ( bb )->( FieldGet( d ))))    && sumy obliczane
               ( bb )->( Blokuj_R())
               ( bb )->( FieldPut( w, ( bb )->( &buf ) ))
            endif
         endif
      next
      DBSkip()
enddo

ON( bb )
while !Eof()
      for i := 1 to FCount()
         if 'DEFINICJA' $ Field( i )
            d := i
            w := i + 1
            if ( 'PR' $ Upper( buf := ( bb )->( FieldGet( d ))))    && sumy obliczane
               ( bb )->( Blokuj_R())

               ( bb )->( FieldPut( w, ( bb )->( &buf ) ))
            endif
         endif
      next
      DBSkip()
enddo

if okres = NIL
   DBE_Tyt := Left( DBE_Tyt, At( ' na ', DBE_Tyt ) - 1 ) + ' na dzie§ ' + DtoC( data2 )
else
   DBE_Tyt := Left( DBE_Tyt, At( ' za ', DBE_Tyt ) - 1 ) + ' za okres ' + DtoC( data1 ) + '-' + DtoC( data2 )
endif
PutIni()

ON( bb )
Tone( ton2, 1 )
Czek( 0 )
wy := 2

******************************************************************************
* s - szablony kilku kont
* mode = NIL -> Saldo Wn
* mode = 1   -> Saldo Ma
* mode = 2   -> Obroty mies. Wn
* mode = 3   -> Obroty mies. Ma
* mode = 4   -> Obroty nar. Wn
* mode = 5   -> Obroty nar. Ma

function Wn( s, mode )

local k, kk, w, x, y, z, bb, bez, mn

bb := Alias()
if !( bb == globalbuf )
   ON( globalbuf )
endif

w := 0
while !Empty( s )
      mn := 1
      k := Odetnij( @s )                  && szablon konta
      bez := ( Left( k, 1 ) == '-' )      && maska kont wykluczonych
      if bez; k := SubStr( k, 2 ); mn := -1; endif
      z := Len( k )
      x := At( '*', k ); x := if( x = 0, z, x - 1 )
      y := At( '?', k ); y := if( y = 0, z, y - 1 )
      z := Min( x, y )       && iloûç znak¢w pewnych
      kk := Left( k, z )     && pierwsze znaki
      DBSeek( kk, .t. )
      Przerwa( LastRec())
      while Left( KONTO, z ) == kk .and. !Eof()
            if Szablon( KONTO, k )
               do case
                  case mode = NIL; w += SALDOWN * mn
                  case mode = 1;   w += SALDOMA * mn
                  case mode = 2;   w += OBROTYMW * mn
                  case mode = 3;   w += OBROTYMM * mn
                  case mode = 4;   w += OBROTYWN * mn
                  case mode = 5;   w += OBROTYMA * mn
               endcase
            endif
            if Przerwa(); exit; endif
            skip
      enddo
      Przerwa( 0 )
enddo

if !( bb == globalbuf )
   Select( bb )
endif

return w

******************************************************************************

function Ma( s ); return Wn( s, 1 )
function OMWn( s ); return Wn( s, 2 )
function OMMa( s ); return Wn( s, 3 )
function ONWn( s ); return Wn( s, 4 )
function ONMa( s ); return Wn( s, 5 )
function Wy( s ); return Wn( s ) - Ma( s )
function WyWn( s ); return Max( Wn( s ) - Ma( s ), 0 )
function WyMa( s ); return Max( Ma( s ) - Wn( s ), 0 )

******************************************************************************

function Su( s, literka )

local k, w, rr

if literka = NIL; literka := ''; endif

w := 0
rr := RecNo()
while !Empty( s )
      k := Odetnij( @s )     && szablon konta
      DBGoBottom()
      Przerwa( LastRec())
      while !Bof()
            if Szablon( LPPOZ, k )
               buf := 'WARTOSC' + literka
                 w += &buf
            endif
            if Przerwa(); exit; endif
            DBSkip( -1 )
      enddo
      Przerwa( 0 )
enddo
DBGo( rr )

return w

******************************************************************************
* Pozycje po≥oøone na prawo od bieøπcej
* Uøywane do wymuszenia liczenia na koÒcu (po Su i Po)

function PR( s, literka ); return Po( s, literka )

******************************************************************************

function Po( s, literka )

local k, w, rr, mn

if literka = NIL; literka := ''; endif

w := 0
rr := RecNo()
while !Empty( s )
      k := Odetnij( @s )     && szablon konta
      mn := 1
      if Left( k, 1 ) == "-"
         k := SubStr( k, 2 )
         mn := -1
      endif
      DBGoTop()
      Przerwa( LastRec())
      while !Eof()
            if Szablon( LPPOZ, k )
               buf := 'WARTOSC' + literka
                 w += mn * &buf
            endif
            if Przerwa(); exit; endif
            DBSkip()
      enddo
      Przerwa( 0 )
enddo
DBGo( rr )

return w


******************************************************************************
* Kondensacja pozycji analityki kont (parowanie)

procedure Kondens( a, dzk )

local r1, r2, i := 1, w1, w2, k1, k2, zk, od := 2, bb := Alias(), kk, de

if dzk = NIL
	od := Alarm( a, { ' NIE ', ' TAK ', ' TAK+rÍczne ' }, 1 )
   if od < 2; return; endif
endif

zk := ( FieldPos( 'KONTO' ) # 0 )      && z polem 'KONTO'

if zk
   if dzk = NIL
      if Alarm( 'Czy kwoty z rÛønych kont traktowaÊ jednakowo ?', nt, 1 ) = 2
         zk := .f.
      endif
   else
      zk := .t.      && rÛøne konta = rÛøne kwoty mimo, øe wartoúciowo sπ rÛwne
   endif
endif

if zk
   CreateIndex( 'KONTO+Str(Abs(OBROTYWN)+Abs(OBROTYMA))+DtoS(DATA)' )
else
   CreateIndex( 'Str(Abs(OBROTYWN)+Abs(OBROTYMA))+DtoS(DATA)' )
endif

Czek( 1 )
de := 0
while .t.
	Przerwa( LastRec())
	DBGoTop()
	while !Eof()
      if i = 1
         r1 := RecNo()
         w1 := OBROTYWN - OBROTYMA
         k1 := KONTO
      endif
      if i = 2
         r2 := RecNo()
         w2 := OBROTYWN - OBROTYMA
         k2 := KONTO
         if if( zk, k1 == k2, .t. ) .and. ( w1 + w2 = 0 )    && parowanie
            DBGoTo( r1 ); BDelete(); de++
            DBGoTo( r2 ); BDelete(); de++
            i := 0
         else
            r1 := r2      && przesuniëcie uwagi o 1 dalej
            w1 := w2
            k1 := k2
            i := 1
        endif
      endif
      if ( i = 1 ) .and. w1 = 0     && jak wynik = wn - ma = 0
         BDelete(); de++            && to sio
      else
         i++
      endif
      if Przerwa(); de := 0; exit; endif
      skip
	enddo
	Przerwa( 0 )
	if de = 0; exit; endif		&& nic nie skasowa≥ wiÍc nic tu po nim
	de := 0
enddo

if od = 3
	ON( 'ZEST2PAR' )
	Select( bb )
	de := 0
	while .t.
		Przerwa( LastRec())
		DBGoTop()
		while !Eof()
			kk := KONTO+DTOS(DATA)+DOK+STR(NR)+STR(LP)+STR(PZ)
			if ZEST2PAR->( DBSeek( kk ))
				BDelete(); de++
			endif
	      if Przerwa(); de := 0; exit; endif
	      skip
		enddo
		Przerwa( 0 )
		if de = 0; exit; endif		&& nic nie skasowa≥ wiÍc nic tu po nim
		de := 0
	enddo
endif

*ON( 'ZEST2S' )
*ON( 'ZEST2S', 2,,, .t. )	&& zap

ON( 'ZEST2',,,,, .t. )     && pack
AktSyn()

Czek( 0 )

if zk
   CreateIndex( 'KONTO+Str(Abs(OBROTYWN)+Abs(OBROTYMA))+DtoS(DATA)' )
else
   CreateIndex( 'Str(Abs(OBROTYWN)+Abs(OBROTYMA))+DtoS(DATA)' )
endif

DBGoTop()

Tone( ton2, 1 )

******************************************************************************
* Agregacja pozycji analityki kont (tr¢jkowanie)

procedure Agregac( a )

local r, w, klucz1, klucz2

if Alarm( a, nt ) # 2; return; endif

w := 1         && po raz pierwszy musi byç # 0, aby nie kasowaí od razu
klucz2 := ''

DBSetOrder( 3 )

Czek( 1 )
Przerwa( LastRec())
DBGoTop()
while !Eof()
   klucz1 := DOK + Str( NR ) + Str( LP )
   if klucz1 == klucz2
      w += OBROTYWN - OBROTYMA   && narastanie wartoûci salda
   else
      if Abs( w ) < 0.01         && saldo na grupie = 0, to kasowanie grupy
         DBGoTo( r )
         while ( klucz2 == DOK + Str( NR ) + Str( LP )) .and. !Eof()
               BDelete()
               skip
         enddo
      endif
      klucz2 := klucz1           && klucz grupy
      r := RecNo()               && rekord poczÜtkowy grupy
      w := OBROTYWN - OBROTYMA   && saldo pierwsze grupy
   endif
   if Przerwa(); exit; endif
   skip
enddo


* usuwanie ostatniej grupy

      if Abs( w ) < 0.01         && saldo na grupie = 0, to kasowanie grupy
         DBGoTo( r )
         while ( klucz2 == DOK + Str( NR ) + Str( LP )) .and. !Eof()
               BDelete()
               skip
         enddo
      endif

Przerwa( 0 )
Czek( 0 )

Czek( 1 )
ON( 'ZEST2',,,,, .t. )     && pack
DBSetOrder( 3 )
Czek( 0 )

DBGoTop()

Tone( ton2, 1 )

******************************************************************************

procedure FormDz( a, dt, musi )

if dt = NIL; dt := DATA; endif
if musi = NIL; musi := .f.; endif

if musi .or. haker .or. !OkresZamkniety( dt, 1 )
   NewSysForm( a )
else
   NewSysForm( a, .t. )         && bez kursora
endif

******************************************************************************

procedure UsunDz( a, dt, musi, b, c )

if dt = NIL; dt := DATA; endif
if musi = NIL; musi := .f.; endif

if musi .or. haker .or. !OkresZamkniety( dt )
   if a = NIL; BDelete()
   else; Kasuj( a, b, c )
   endif
endif

******************************************************************************
* mode = NIL - z alarmem
* mode # NIL - bez alarmu

function OkresZamkniety( dt, mode )

local bb := Alias(), wy

if pirat; return .f.; endif

ON( 'ZAOKRESY' )
DBSeek( DtoS( dt ), .t.)
*wy := (( DATA1 <= dt ) .and. ( dt <= DATA2 ))
wy := ( !Empty( dt ) .and. dt <= DATA2 )
if !Empty( bb ); Select( bb ); endif

if wy .and. mode = NIL; Alarm( 'Okres zamkniëty. Zmiany zabronione.'); endif

return wy

******************************************************************************

procedure GoANALIZAK()

if TypyKonSta .and. !Empty( TypyKonSpr ) .and. ( TypyKonSpi # 0 )
   ON('DOKUM')
   ON('FIRMY')
   ON('ANALIZAK')
   DokAnak('','FV,RU','Kontrahenci bez faktury')
   if ANALIZAK->( LastRec()) > 0
      if Alarm( 'Liczba kontrahent¢w dawno bez faktury: ' + AllS( ANALIZAK->( LastRec())),;
              { 'OK', 'Pokaß szczeg¢íy' }) = 2
         ViewDBF( 'ANALIZAK' )
      endif
   endif
endif

if TypyKonStc
   ON('DOKUM')
   ON('FIRMY')
   ON('ANALIZAC')
   DokAnak('','RWC,PWC','Kontrahenci bez dokumentu',1,TypyKonSpc)
   if ANALIZAC->( LastRec()) > 0
      if Alarm( 'Liczba kontrahent¢w dawno bez dokumentu RWC, PWC: ' + AllS( ANALIZAC->( LastRec())),;
              { 'OK', 'Pokaß szczeg¢íy' }) = 2
         ViewDBF( 'ANALIZAC' )
      endif
   endif
endif

******************************************************************************
* w # NIL => wszyscy, a nie tylko ci z jakimiû dotychczasowymi dokumentami
* n - iloûç dni limitu

procedure DokAnaK( a, b, h, w, n )

local tab, jest, alenie, x
private typy

n := if( n = NIL, TypyKonSpi, n )
b := if( b # NIL, b, '' )
typy := PadR( b, 50 )

GetIni(,,@tab)
if Len( tab ) > 0 .and. !Empty( tab[ 1 ])
   typy := PadR( tab[ 1 ], Len( typy ))
endif

data1 := Datee()

*if NewSysForm( a )
   Czek( 1 )
   DBZap('')
   typy := AllTrim( typy )
   MAGAZYNY->( DBSetOrder( 1 )) && Str(FIRMY->ID_F)
   DOKUM->( DBSetOrder( 4 ))    && Str(NABYWCA)+DtoS(DATAS)
   FIRMY->( DBGoTop())
   Przerwa( FIRMY->( LastRec()))
   while FIRMY->( !Eof())

         x=0
         MAGAZYNY->(DBSeek(Str(FIRMY->ID_F)))
         while MAGAZYNY->(FIRMY->ID_F==ID .and. !Eof())
               x+=MAGAZYNY->ILOSC
               MAGAZYNY->(DBSkip())
         enddo

         if (x<>0) .and. (( ','+AllTrim(FIRMY->TYP)+',') $ (','+TypyKonSpr+','))
            DOKUM->( DBSeek( Str( FIRMY->ID_F ) + '99999999', .t. ))
            DOKUM->( DBSkip( -1 ))
            jest := .f.
            mogl := .f.
            alenie := .t.
            while DOKUM->NABYWCA = FIRMY->ID_F .and. DOKUM->( !Bof())
                  jest := .t.
                  if (( ','+AllTrim(DOKUM->TYP)+',') $ (','+typy+','))
                     mogl := .t.
                     if data1 - DOKUM->DATAS >= n
                        alenie := .f.
                        DBAppend()
                        replace ID_F with DOKUM->NABYWCA
                        replace DATA with DOKUM->DATAS
                     endif
                     exit
                  endif
                  DOKUM->( DBSkip( -1 ))
            enddo

            if w # NIL        && przeglÜdamy wszystkich potencjalnych
               if jest        && jest choç jeden dowolny dokument na tego kontr
                  if !mogl    && brak tego typu co trzeba
                     if alenie   && ale nie dopisaí bo data wczesna
                        if FIRMY->ID_F # NRMG   && nie jest to magazyn gí¢wny
                           if FIRMY->ID_F # 0   && nie jest to magazyn zbiorczy
                              DBAppend()
                              replace ID_F with FIRMY->ID_F
                              replace DATA with CtoD( '' )
                           endif
                        endif
                     endif
                  endif
               endif
            endif
         endif
         FIRMY->( DBSkip())
         if Przerwa(); exit; endif
   enddo
   Przerwa( 0 )

   go top
   wy := 2
   Czek( 0 )

   h := h + ' na ' + AllS( n ) + ' dni przed ' + DtoC( data1 )
   h += ' dla dokument¢w: ' + typy
   DBE_Tyt := h + '|' + typy

   PutIni()
*   ShowDBES( 1 )  && bez GETIni() na poczatku
   DBE_Tyt := h

*endif

******************************************************************************
* Precz z TU
* konwersja stringu liczby w ludzkim formacie (1.123,00) na liczbë 1123.00

function UT( buf )
                     

buf := AllTrim( buf )
buf := StrTran( buf, '%', '' )          && 20,00% -> 20,00
if Left( buf, 1 ) == '*'                && taki sobie wyjÜtek od reguíy
   return 20
elseif Left( Right( buf, 3 ), 1 ) $ ',.'    && 1.123,00
   buf := StrTran( buf, ',', '' )           &&      *
   buf := StrTran( buf, '.', '' )
   return Val( buf ) * 0.01

else
   buf := StrTran( buf, ',', '' )           && 1.123
   buf := StrTran( buf, '.', '' )           &&   *
   return Val( buf )
endif

*******************************************************************************
* TysiÜce Uíamki
* konwersja stringu liczby w zapisie Clippera (1,123.00) na ludzki (1.123,00)
* s - string we
* zt - znak tysiëcy ( 'e' = '', czyli bez znaku separacji )
* zu - znak uíamka ( 'e' = '', czyli bez znaku separacji )
* bezzer - jeûli wartoûç zmiennej "zm" = 0, to zwr¢ç ciÜg pusty: ''
* zm
* do - dopeínienie do "do" znak¢w z lewej

function TU( s, zt, zu, bezzer, zm, do )

if zt = NIL .or. Empty( zt ); zt := '.'; endif
if zu = NIL .or. Empty( zu ); zu := ','; endif

bezzer := ( bezzer = NIL .or. Empty( bezzer ))    && co z zerami ???
if zm # NIL .and. zm = 0 .and. bezzer; return ''; endif

if zt = 'e'; zt := ''; endif
if zu = 'e'; zu := ''; endif

s := StrTran( s, ',', '~' )
s := StrTran( s, '.', zu )
s := StrTran( s, '~', zt )

if do # NIL
   s := AllTrim( s )
   if Len( s ) < do
      s := PadL( s, do )
   endif
endif


return s

******************************************************************************

procedure AktSyn

local bb := Alias(), ko

ON( 'ZEST2S', 2 )
while !Eof()
      ZEST2S->( Blokuj_R())
      ZEST2S->OBROTYWN := 0
      ZEST2S->OBROTYMA := 0
      ZEST2S->( OdBlokuj_R())
      skip
enddo

Select( bb )
go top
while !Eof()
      ko := KONTO
      if ZEST2S->( !DBSeek( ko ))
         AppendRecord( 'ZEST2S', { DOK, NR, DATA, LP, PZ, OBROTYWN, OBROTYMA, NAZ1, NAZ2, OPIS, ko })
      else
         ZEST2S->( Blokuj_R())
         ZEST2S->OBROTYWN := ZEST2S->OBROTYWN + OBROTYWN
         ZEST2S->OBROTYMA := ZEST2S->OBROTYMA + OBROTYMA
         ZEST2S->( OdBlokuj_R())
      endif
      skip
enddo

******************************************************************************

procedure ExportInfor( co )

local wz := ReadWzor( co ), a, b, c, p, pp
local r := RecNo(), i := 0, n := 0, mm := {}

wz := PadR( wz, 100 )
while .t.
   wz := Get_U( 10, 4, 'Plik "Inforu":', '@S55', wz )
   if wz = NIL; return; endif
   if File( wz ); exit; endif
enddo

wz := AllTrim( wz )
MemoWrit( cat_wzorow + co, wz )

co := wz
wz := MemoRead( co )

go top
while !Eof()
      a := At( '(', OPIS )
      b := At( ')', OPIS )
      if ( 1 < b - a ) .and. ( b - a < 6 )
         p := SubStr( OPIS, a + 1, b - a - 1 )
         a := At( p + '=', wz )
         if a > 0
            c := Left( wz, a - 1 )
            while SubStr( wz, a, 2 ) # EOL; a++; enddo
            b := SubStr( wz, a )
            wz := c + p + '=' + AllTrim( Konwert( StrTran( StrTran( TEKST, '.', '' ), '_', '-' ), maz, win )) + b
            i ++
            MemoWrit( co, wz )
         else
				pp := p
				while ( pp # 'p0' ) .and. (( a := At( pp + '=', wz )) = 0 )
						pp := 'p' + AllS( Val( SubStr( pp, 2 )) - 1 )
				enddo
				if pp == 'p0'	&& nie wysz≥o
	            n ++
   	         Aadd( mm, AllTrim( OPIS ))
				else
	            c := Left( wz, a - 1 )
   	         while SubStr( wz, a, 2 ) # EOL; a++; enddo
	            c := Left( wz, a - 1 )
      	      b := SubStr( wz, a )
         	   wz := c + EOL + p + '=' + AllTrim( Konwert( StrTran( StrTran( TEKST, '.', '' ), '_', '-' ), maz, win )) + b
            	i ++
	            MemoWrit( co, wz )
				endif
         endif
      endif
      skip
enddo

DBGoTo( r )

if n = 0
   Alarm( 'Wyeksportowano ' + AllS( i ) + ' pozycji;Teraz moøesz uruchomiÊ formularz "Inforu"',, 1 )
else
   Alarm( 'Wyeksportowano ' + AllS( i ) + ' pozycji;Nie uda≥o siÍ z wyeksportowaÊ ' + AllS( n ) + ' pozycji', mm, 1 )
endif

******************************************************************************

procedure UsunKonta()

local s := KONTO, k, ok, bb := Alias(), i, n

ON( 'NORDPOL' )
Select( bb )
s := PadR( s, 50 )
s := Get_U( 10, 10, 'Podaj szablon usuwanych kont:', '@S30', s )
if s = NIL; return; endif
s := AllTrim( s )
i := 0
n := 0
while !Eof()
      k := KONTO
      if Szablon( k, s )
         n ++
         NORDPOL->( DBSetOrder( 3 ))            && Wn
         ok := NORDPOL->( !DBSeek( k ))
         if ok
            NORDPOL->( DBSetOrder( 4 ))      && Ma
            ok := NORDPOL->( !DBSeek( k ))
         endif
         if ok
            BDelete()
            i ++
         endif
      endif
      skip
enddo

Alarm( 'UsuniÍto ' + AllS( i ) + ' kont z ' + AllS( n ) + ' moøliwych',,1)

go top
wy := 2

******************************************************************************

procedure AktRejTra( nrmenu, h )

local bb := baza, i

if Get_Okres( @data_od , @data_do ) = NIL; return; endif
DBZapp( 'REJ_TRA,REJ_TRS' )

Select( baza := 'REJ_TRS' )
RunMenu( nrmenu,, 1, 1, h, 1 )

ON( 'REJ_TRS' )
while !Eof()
		if REJ_TRA->( !DBSeek( REJ_TRS->NUMER ))
			AppendRecord( 'REJ_TRA', { NUMER, data_od, data_do })
		endif

		REJ_TRA->( Blokuj_R())

		REJ_TRA->BRUTTO += BRUTTO
		REJ_TRA->NETTO += NETTO

		if ZWROT == 'T'
			REJ_TRA->BRUTTOZ += BRUTTO
			REJ_TRA->NETTOZ += NETTO
		else
			if REJ_TRA->MBRUTTO <= BRUTTO
				REJ_TRA->MDATA := DATA
				REJ_TRA->MFAKTURA := FAKTURA
				REJ_TRA->MBRUTTO := BRUTTO
			endif
			if Empty( REJ_TRA->PDATA ) .or. ( DATA < REJ_TRA->PDATA )
				REJ_TRA->PDATA := DATA
				REJ_TRA->PFAKTURA := FAKTURA
				REJ_TRA->PBRUTTO := BRUTTO
			endif
			if Empty( REJ_TRA->ODATA ) .or. ( DATA >= REJ_TRA->ODATA )
				REJ_TRA->ODATA := DATA
				REJ_TRA->OFAKTURA := FAKTURA
				REJ_TRA->OBRUTTO := BRUTTO
			endif
		endif

		REJ_TRA->( OdBlokuj_R())

		skip
enddo

Select( baza := bb )

******************************************************************************

function SumaFaktur( s_nr )

local s := '', bb := Alias(), ii := IndexOrd(), rr := RecNo(), x := 0

s_nr := AllS( Val( s_nr ))

ON( 'REJ1SP' )
while !Eof()
	if data1 <= D3 .and. D3 <= data2					&& data1 <= D3 .and. 
		if ( s_nr <> '0' ) .and. ( s_nr == AllS( Val( PRZEDMIOT )))
			x += K11-K23
		endif
	endif
	skip
enddo

Select( bb )
DBSetOrder( ii )
DBGoTo( rr )

s := AllS( x )

return s

******************************************************************************

function DataFaktur( s_nr )

local dt := NIL, s := '', bb := Alias(), ii := IndexOrd(), rr := RecNo(), x := 0

s_nr := AllS( Val( s_nr ))

ON( 'REJ1SP' )
while !Eof()
	if D3 <= data2					&& data1 <= D3 .and. 
		if ( s_nr <> '0' ) .and. ( s_nr == AllS( Val( PRZEDMIOT )))
			dt := D3
		endif
	endif
	skip
enddo

Select( bb )
DBSetOrder( ii )
DBGoTo( rr )

return dt

******************************************************************************

function TerminFak( s_nr, k_br )

local bb := Alias(), wy, rr

s_nr := AllTrim( s_nr )
rr := At( ',', s_nr )
if rr > 0
	s_nr := Left( s_nr, rr - 1 )
endif

if wy = NIL
	ON( 'REJ1SP' ); DBSetOrder( 5 )
	if DBSeek( s_nr ) .and. K11=k_br
		wy := D4
	endif
endif

if wy = NIL
	ON( 'REJ2SP' ); DBSetOrder( 5 )
	if DBSeek( s_nr ) .and. K11=k_br
		wy := D4
	endif
endif

if wy = NIL
	ON( 'REJ_SP' ); DBSetOrder( 5 )
	if DBSeek( s_nr ) .and. K11=k_br
		wy := D4
	endif
endif

Select( bb )

return if( wy = NIL, Space(10), wy )

******************************************************************************
* PadR(GetPole(1,'wzorek+DtoS(tab[1])','NR_RAP','KASA_RAP'),10)

function KasaRapInit()

local wy, x, r, bb := Alias(), wzorek := 'kasa    ', tab := AClone( vp )

if !Jest_baza( 'KASA_RAP' )
	ON( 'KASA_RAP' )
endif

Select( bb )

if KASA_RAP->( DBSeek( Left( wzorek, 8 ) + DtoS( tab[ 1 ]) + DtoS( tab[ 2 ]), .t. ))
	wy := KASA_RAP->NR_RAP
	x := KASA_RAP->STAN_PO
	r := KASA_RAP->( RecNo())
	while KASA_RAP->( !Bof())
			KASA_RAP->( DBSkip( -1 ))
			if KASA_RAP->DATA_KO < tab[ 1 ]
				exit
			endif
	enddo
	if KASA_RAP->WZOR == wzorek .and. KASA_RAP->DATA_KO < tab[ 1 ] .and. KASA_RAP->STAN_KO # x
		Alarm( 'Stan poczatkowy z dnia ' + DtoC( tab[ 1 ]) + '=' + AllS( x ) + ';' +;
				 'Stan koncowy pop. dnia ' + DtoC( KASA_RAP->DATA_KO ) + '=' + AllS( KASA_RAP->STAN_KO ))
		x := KASA_RAP->STAN_KO
	endif
	KASA_RAP->( DBGoTo( r ))
	KASA_RAP->( AppendRecord( ,{ wzorek, tab[ 1 ], tab[ 2 ],, x }, 1 ))
else
	while KASA_RAP->( !Bof())
			KASA_RAP->( DBSkip( -1 ))
			if KASA_RAP->DATA_KO < tab[ 1 ]
				exit
			endif
	enddo
	if KASA_RAP->( Bof())
		if KASA_RAP->DATA_PO = tab[ 1 ]
			x := KASA_RAP->STAN_PO
		else
			x := 0		&& nie wiadomo jaki stan poczπtkowy
		endif
	else
		x := KASA_RAP->STAN_KO
	endif
	wy := KASA_RAP->NR_RAP + 1
	if !( KASA_RAP->WZOR == wzorek )
		x := 0
		wy := 1
		vp[ 3 ] := ''
	endif
	KASA_RAP->( AppendRecord( ,{ wzorek, tab[ 1 ], tab[ 2 ], wy, x }))
endif

vp[ 4 ] := x

return PadR( AllS( wy ), 10 )

*******************************************************************************
* KASA_RAP->(AppendRecord(,{wzorek,Val(tab[3]),tab[1],tab[4]},if(KASA_RAP->(Eof()),NIL,1)))

function KasaRapDone()

local wzorek := 'kasa    ', tab := AClone( vp ), stan

if tab[2]<tab[1]; return .f.; endif

stan := tab[4]

REJ_KA->(DBSetOrder(4))
REJ_KA->(DBSeek(DtoS(tab[1]),.t.))
while REJ_KA->(D3<=tab[2]) .and. REJ_KA->(!Eof())
	REJ_KA->(Blokuj_R())
	REJ_KA->NRK := AllTrim(tab[3])
	REJ_KA->(OdBlokuj_R())
	stan += REJ_KA->K10
	stan -= REJ_KA->K11
	REJ_KA->(DBSkip())
enddo

if KASA_RAP->( DBSeek( Left( wzorek, 8 ) + DtoS( tab[ 1 ]) + DtoS( tab[ 2 ])))
	KASA_RAP->( AppendRecord( ,{ wzorek, tab[ 1 ], tab[ 2 ], Val( tab[ 3 ]), tab[ 4 ], stan }, 1 ))
else
	KASA_RAP->( AppendRecord( ,{ wzorek, tab[ 1 ], tab[ 2 ], Val( tab[ 3 ]), tab[ 4 ], stan }))
endif

wy := 2

return .t.

*******************************************************************************

procedure Expo()

DBSetOrder(0)
go top
while !Eof()
	@ 0, 0 say ID
	if ID_T = 0; BDelete(); endif
	if ID=1341; BDelete(); endif
	skip
enddo

*******************************************************************************
* import z pliku "Faktury_2013_12_30listopad.xml" sekcji "faktury"...

function ImportInes(d)

local pp, p, i, x, mm := {}
local p1, p2, p3, p4
local bb := Alias(), ekran := SaveScreen()

Repl_XML := 'Repl_XML.exe'
if !File(Repl_XML)
   Alarm( 'Brak programu ' + Repl_XML + ' !!!' )
   OpuscSys(1)
endif

if d = NIL; d = ''; endif
d := PadR( d, 100 )
d := Get_U( 10, 10, 'Podaj katalog importowanych faktur:', '@S30', d )
if d = NIL; return .f.; endif
d := AllTrim( d )

p := Directory( d + '\*.xml' )
do case
case Len( p ) = 0; Alarm( 'Brak plik¢w XML w podanym katalogu',, 1 ); return .f.
case Len( p ) = 1
	p := p[ 1, 1 ]
case Len( p ) > 1
	for i := 1 to Len( p )
      a := p[ i ]
		Aadd( mm, a[ F_NAME ] + ', data: ' + DtoC(a[ F_DATE ]) + ', rozmiar: ' + Transform(a[ F_SIZE ]/1024,'999,999,999,999 kB'))
	next
	i := Alarm( 'Wybierz plik z danymi do importu:', mm )
	if i = 0; return .f.; endif
	p := Left(mm[ i ], 12)
endcase

p := d + '\' + p

Czek( 1 )

@ 0, 0 clear to 0, mc
@ 0, 0 say x := 'run copy ' + p + ' Dane.xml'
RunCommand( x, 1 )

@ 0, 0 clear to 0, mc
@ 0, 0 say x := 'run ' + Repl_XML
RunCommand( x, 1 )

fullImport=.t.
//if Alarm('Import pelny?', nt )=2
//	fullImport=.t.
//endif

if fullImport
	mm := {}
	Aadd( mm, { 'TEKST', 'C', 500, 0 })
	Dbcreate( 'LINIE.dbf', mm)
endif

	use LINIE new

if fullImport
	@ 0, 0 clear to 0, mc
	@ 0, 0 say "append from ( '" + p + "' ) SDF"
	append from ( 'Dane.txt' ) SDF
endif

@ 0, 0 clear to 0, mc
@ 0, 0 say x := 'run del Dane.xml'
RunCommand( x, 1 )
@ 0, 0 clear to 0, mc

objekt := ''
mm := {}
i := 0
go top
while !Eof()

   @ 0, 0 say AllS(RecNo()) + '/' + AllS(LastRec()) + '=' + AllS(100*RecNo()/LastRec(),'999%')

   ss := AllTrim(TEKST)
   ss := StrTran( ss, '&amp;', '&')

   s := '<ZAPIS co="'
   if (Left(ss, Len(s))==s)
      s := '<ZAPIS co="faktury"'
      if (Left(ss, Len(s))==s)
         objekt := 'faktura'
      else
         if (objekt == 'faktura' )
//             '/' + faktura_netto0 + ;
//             '/' + faktura_przedplata + ;
//             '/' + faktura_waluta + ;

//             '/' + faktura_datas + ;
//             '/' + faktura_sposob + ;
//             '/' + faktura_dni + ;
//             '/' + faktura_termin + ;
//             '/' + faktura_netto23 + ;
//             '/' + faktura_vat23 + ;
//             '/' + faktura_brutto + ;
//             '/' + faktura_wplacono + ;
//             '/' + faktura_koszt + ;
/*
            Aadd( mm, faktura_nr + ' z ' + faktura_dataw +;
             '/' + faktura_anulowana + ;
             '/' + faktura_nab_nip + ;
             '/' + faktura_nab_nazwa + ;
             '/' + faktura_nab_kodp + ;
             '/' + faktura_nab_miasto + ;
             '/' + faktura_nab_ulica + ;
             '';
            )
*/

			i++
            ( bb )->( DBAppend())
            ( bb )->LP := 0
            ( bb )->NUMER_FAK := faktura_nr
            ( bb )->D1 := CtoD(SubStr(faktura_dw,7,2)+'.'+SubStr(faktura_dw,5,2)+'.'+SubStr(faktura_dw,1,4))
            ( bb )->D2 := CtoD(SubStr(faktura_ds,7,2)+'.'+SubStr(faktura_ds,5,2)+'.'+SubStr(faktura_ds,1,4))
//            ( bb )->D4 := CtoD(SubStr(faktura_te,7,2)+'.'+SubStr(faktura_te,5,2)+'.'+SubStr(faktura_te,1,4))
            ( bb )->NIP := faktura_ni
            ( bb )->NAZWA := Konwert( faktura_na, win, maz )
            ( bb )->ADRES := Konwert( faktura_kp + ' ' + faktura_mi + ', ' + faktura_ul, win, maz ) 
            ( bb )->K8  := val(faktura_n2)
            ( bb )->K9  := val(faktura_v2)
//            ( bb )->K23 := val(faktura_v2)
            ( bb )->K7  := val(faktura_br)
			if (faktura_sp='Przelew')
				faktura_wp:='0'
			endif
            ( bb )->K16 := val(faktura_br)-val(faktura_wp)
            
         endif
         objekt := 'inne'
      endif
   endif
   
   if (objekt == 'faktura')
      s := '</NrR'; if (SubStr(ss, -Len(s))==s); faktura_nr := SubStr(ss, 0, Len(ss)-Len(s)); endif
      s := '</DWy'; if (SubStr(ss, -Len(s))==s); faktura_dw := SubStr(ss, 0, Len(ss)-Len(s)); endif
      s := '</DSp'; if (SubStr(ss, -Len(s))==s); faktura_ds := SubStr(ss, 0, Len(ss)-Len(s)); endif
      s := '</Fp';  if (SubStr(ss, -Len(s))==s); faktura_sp := SubStr(ss, 0, Len(ss)-Len(s)); endif
      s := '</Dni'; if (SubStr(ss, -Len(s))==s); faktura_dn := SubStr(ss, 0, Len(ss)-Len(s)); endif
      s := '</Tpl'; if (SubStr(ss, -Len(s))==s); faktura_te := SubStr(ss, 0, Len(ss)-Len(s)); endif
//    s := '</N0';  if (SubStr(ss, -Len(s))==s); faktura_n0 := SubStr(ss, 0, Len(ss)-Len(s)); endif
      s := '</N2';  if (SubStr(ss, -Len(s))==s); faktura_n2 := SubStr(ss, 0, Len(ss)-Len(s)); endif
      s := '</V2';  if (SubStr(ss, -Len(s))==s); faktura_v2 := SubStr(ss, 0, Len(ss)-Len(s)); endif
      s := '</Wart';if (SubStr(ss, -Len(s))==s); faktura_br := SubStr(ss, 0, Len(ss)-Len(s)); endif
      s := '</Zap'; if (SubStr(ss, -Len(s))==s); faktura_wp := SubStr(ss, 0, Len(ss)-Len(s)); endif
//    s := '</Przedp';if (SubStr(ss,-Len(s))==s);faktura_pr := SubStr(ss, 0, Len(ss)-Len(s)); endif
      s := '</Koszt';if (SubStr(ss, -Len(s))==s);faktura_ko := SubStr(ss, 0, Len(ss)-Len(s)); endif
//    s := '</Wal'; if (SubStr(ss, -Len(s))==s); faktura_wa := SubStr(ss, 0, Len(ss)-Len(s)); endif
      s := '</NIP'; if (SubStr(ss, -Len(s))==s); faktura_ni := SubStr(ss, 0, Len(ss)-Len(s)); endif
      s := '</Nazw';if (SubStr(ss, -Len(s))==s); faktura_na := SubStr(ss, 0, Len(ss)-Len(s)); endif
      s := '</Kodp'; if (SubStr(ss, -Len(s))==s);faktura_kp := SubStr(ss, 0, Len(ss)-Len(s)); endif
      s := '</Mias'; if (SubStr(ss, -Len(s))==s);faktura_mi := SubStr(ss, 0, Len(ss)-Len(s)); endif
      s := '</Ulic'; if (SubStr(ss, -Len(s))==s);faktura_ul := SubStr(ss, 0, Len(ss)-Len(s)); endif
      s := '</Anul'; if (SubStr(ss, -Len(s))==s);faktura_an := SubStr(ss, 0, Len(ss)-Len(s)); endif
   endif

	skip
enddo
use
DBCommitAll()

x := 'run del LINIE.DBF'
RunCommand( x, 1 )

x := 'run del Dane.txt'
RunCommand( x, 1 )

Czek( 0 )
RestScreen(,,,, ekran )
Select( bb )

Alarm( 'Pozycji: '+ AllS( i ))
//Alarm( 'Znalezione dokumenty : '+ AllS( Len( mm )), mm )
ImportIneU()

return .t.

*******************************************************************************
* import z pliku "Zakupy_01_12_2013-28_01_2014.xml" sekcji "zakupy", "spec", "klienci", "towary"

function ImportInez(d)

local pp, p, i, x, mm := {}
local p1, p2, p3, p4
local bb := Alias(), ekran := SaveScreen()

Repl_XML := 'Repl_XML.exe'
if !File(Repl_XML)
   Alarm( 'Brak programu ' + Repl_XML + ' !!!' )
   OpuscSys(1)
endif

if d = NIL; d = ''; endif
d := PadR( d, 100 )
d := Get_U( 10, 10, 'Podaj katalog importowanych zakup¢w:', '@S30', d )
if d = NIL; return .f.; endif
d := AllTrim( d )

p := Directory( d + '\*.xml' )
do case
case Len( p ) = 0; Alarm( 'Brak plik¢w XML w podanym katalogu',, 1 ); return .f.
case Len( p ) = 1
	p := p[ 1, 1 ]
case Len( p ) > 1
	for i := 1 to Len( p )
      a := p[ i ]
		Aadd( mm, a[ F_NAME ] + ', data: ' + DtoC(a[ F_DATE ]) + ', rozmiar: ' + Transform(a[ F_SIZE ]/1024,'999,999,999,999 kB'))
	next
	i := Alarm( 'Wybierz plik z danymi do importu:', mm )
	if i = 0; return .f.; endif
	p := Left(mm[ i ], 12)
endcase

p := d + '\' + p

Czek( 1 )

@ 0, 0 clear to 0, mc
@ 0, 0 say x := 'run copy ' + p + ' Dane.xml'
RunCommand( x, 1 )

@ 0, 0 clear to 0, mc
@ 0, 0 say x := 'run ' + Repl_XML
RunCommand( x, 1 )

mm := {}
Aadd( mm, { 'TEKST', 'C', 500, 0 })
Dbcreate( 'LINIE.dbf', mm)
use LINIE new

@ 0, 0 clear to 0, mc
@ 0, 0 say "append from ( '" + p + "' ) SDF"
append from ( 'Dane.txt' ) SDF

@ 0, 0 clear to 0, mc
@ 0, 0 say x := 'run del Dane.xml'
RunCommand( x, 1 )
@ 0, 0 clear to 0, mc

objekt := ''
mm := {}
i := 0
go top
while !Eof()

   @ 0, 0 say AllS(RecNo()) + '/' + AllS(LastRec()) + '=' + AllS(100*RecNo()/LastRec(),'999%')

   ss := AllTrim(TEKST)
   ss := StrTran( ss, '&amp;', '&')

   s := '<ZAPIS co="'
   if (Left(ss, Len(s))==s)
      s := '<ZAPIS co="zakupy"'
      if (Left(ss, Len(s))==s)
         objekt := 'faktura'
      else
         if (objekt == 'faktura' )
			i++
            ( bb )->( DBAppend())
            ( bb )->LP := 0
            ( bb )->NUMER_FAK := faktura_nr
            ( bb )->D1 := CtoD(SubStr(faktura_dw,7,2)+'.'+SubStr(faktura_dw,5,2)+'.'+SubStr(faktura_dw,1,4))
//            ( bb )->D2 := CtoD(SubStr(faktura_ds,7,2)+'.'+SubStr(faktura_ds,5,2)+'.'+SubStr(faktura_ds,1,4))
            ( bb )->D2 := CtoD(SubStr(faktura_dw,7,2)+'.'+SubStr(faktura_dw,5,2)+'.'+SubStr(faktura_dw,1,4))
//            ( bb )->D4 := CtoD(SubStr(faktura_te,7,2)+'.'+SubStr(faktura_te,5,2)+'.'+SubStr(faktura_te,1,4))
            ( bb )->NIP := faktura_ni
            ( bb )->NAZWA := Konwert( faktura_na, win, maz )
            ( bb )->ADRES := Konwert( faktura_kp + ' ' + faktura_mi + ', ' + faktura_ul, win, maz ) 
            ( bb )->K8  := val(faktura_n2)
            ( bb )->K11 := val(faktura_v2)
            ( bb )->K22 := val(faktura_n0)
            ( bb )->K24 := val(faktura_v2)
            ( bb )->K7  := val(faktura_br)
            ( bb )->K27 := val(faktura_wp)
            ( bb )->K28 := ( bb )->K7-( bb )->K27
            
         endif
         objekt := 'inne'
      endif
   endif
   
   if (objekt == 'faktura')
      s := '</Fak'; if (SubStr(ss, -Len(s))==s); faktura_nr := SubStr(ss, 0, Len(ss)-Len(s)); endif
      s := '</DWy'; if (SubStr(ss, -Len(s))==s); faktura_dw := SubStr(ss, 0, Len(ss)-Len(s)); endif
      s := '</Dfa'; if (SubStr(ss, -Len(s))==s); faktura_ds := SubStr(ss, 0, Len(ss)-Len(s)); endif
      s := '</Fp';  if (SubStr(ss, -Len(s))==s); faktura_sp := SubStr(ss, 0, Len(ss)-Len(s)); endif
      s := '</Dni'; if (SubStr(ss, -Len(s))==s); faktura_dn := SubStr(ss, 0, Len(ss)-Len(s)); endif
      s := '</Tpl'; if (SubStr(ss, -Len(s))==s); faktura_te := SubStr(ss, 0, Len(ss)-Len(s)); endif
      s := '</N0';  if (SubStr(ss, -Len(s))==s); faktura_n0 := SubStr(ss, 0, Len(ss)-Len(s)); endif
      s := '</N2';  if (SubStr(ss, -Len(s))==s); faktura_n2 := SubStr(ss, 0, Len(ss)-Len(s)); endif
      s := '</V2';  if (SubStr(ss, -Len(s))==s); faktura_v2 := SubStr(ss, 0, Len(ss)-Len(s)); endif
      s := '</Wart';if (SubStr(ss, -Len(s))==s); faktura_br := SubStr(ss, 0, Len(ss)-Len(s)); endif
      s := '</Zap'; if (SubStr(ss, -Len(s))==s); faktura_wp := SubStr(ss, 0, Len(ss)-Len(s)); endif
//    s := '</Przedp';if (SubStr(ss,-Len(s))==s);faktura_pr := SubStr(ss, 0, Len(ss)-Len(s)); endif
      s := '</Koszt';if (SubStr(ss, -Len(s))==s);faktura_ko := SubStr(ss, 0, Len(ss)-Len(s)); endif
//    s := '</Wal'; if (SubStr(ss, -Len(s))==s); faktura_wa := SubStr(ss, 0, Len(ss)-Len(s)); endif
      s := '</NIP'; if (SubStr(ss, -Len(s))==s); faktura_ni := SubStr(ss, 0, Len(ss)-Len(s)); endif
      s := '</Nazw';if (SubStr(ss, -Len(s))==s); faktura_na := SubStr(ss, 0, Len(ss)-Len(s)); endif
      s := '</Kodp'; if (SubStr(ss, -Len(s))==s);faktura_kp := SubStr(ss, 0, Len(ss)-Len(s)); endif
      s := '</Mias'; if (SubStr(ss, -Len(s))==s);faktura_mi := SubStr(ss, 0, Len(ss)-Len(s)); endif
      s := '</Ulic'; if (SubStr(ss, -Len(s))==s);faktura_ul := SubStr(ss, 0, Len(ss)-Len(s)); endif
      s := '</Anul'; if (SubStr(ss, -Len(s))==s);faktura_an := SubStr(ss, 0, Len(ss)-Len(s)); endif
   endif

	skip
enddo
use
DBCommitAll()

x := 'run del LINIE.DBF'
RunCommand( x, 1 )

x := 'run del Dane.txt'
RunCommand( x, 1 )

Czek( 0 )
RestScreen(,,,, ekran )
Select( bb )

Alarm( 'Pozycji: '+ AllS( i ))
//Alarm( 'Znalezione dokumenty : '+ AllS( Len( mm )), mm )
ImportIneU()

return .t.

*******************************************************************************
* import z pliku "Klienci_2014_01_27.xml" sekcji "faktury"...

function ImportIneK(d)

local pp, p, i, x, mm := {}
local p1, p2, p3, p4
local bb := Alias(), ekran := SaveScreen()

Repl_XML := 'Repl_XML.exe'
if !File(Repl_XML)
   Alarm( 'Brak programu ' + Repl_XML + ' !!!' )
   OpuscSys(1)
endif

if d = NIL; d = ''; endif
d := PadR( d, 100 )
d := Get_U( 10, 10, 'Podaj katalog importowanych danych:', '@S30', d )
if d = NIL; return .f.; endif
d := AllTrim( d )

p := Directory( d + '\*.xml' )
do case
case Len( p ) = 0; Alarm( 'Brak plik¢w XML w podanym katalogu',, 1 ); return .f.
case Len( p ) = 1
	p := p[ 1, 1 ]
case Len( p ) > 1
	for i := 1 to Len( p )
      a := p[ i ]
		Aadd( mm, a[ F_NAME ] + ', data: ' + DtoC(a[ F_DATE ]) + ', rozmiar: ' + Transform(a[ F_SIZE ]/1024,'999,999,999,999 kB'))
	next
	i := Alarm( 'Wybierz plik z danymi do importu:', mm )
	if i = 0; return .f.; endif
	p := Left(mm[ i ], 12)
endcase

p := d + '\' + p

Czek( 1 )

@ 0, 0 clear to 0, mc
@ 0, 0 say x := 'run copy ' + p + ' Dane.xml'
RunCommand( x, 1 )

@ 0, 0 clear to 0, mc
@ 0, 0 say x := 'run ' + Repl_XML
RunCommand( x, 1 )

mm := {}
Aadd( mm, { 'TEKST', 'C', 500, 0 })
Dbcreate( 'LINIE.dbf', mm)
use LINIE new

@ 0, 0 clear to 0, mc
@ 0, 0 say "append from ( '" + p + "' ) SDF"
append from ( 'Dane.txt' ) SDF

@ 0, 0 clear to 0, mc
@ 0, 0 say x := 'run del Dane.xml'
RunCommand( x, 1 )
@ 0, 0 clear to 0, mc

objekt := ''
mm := {}
n := 0
i := 0

( bb )->(DBSetOrder(5))	//Str(NUMER)
( bb )->(DBGoBottom())
lastNr=( bb )->NUMER

( bb )->(CreateIndex( 'PSEUDO+NIP+NAZWA' ))

go top
while !Eof()

	@ 0, 0 say AllS(RecNo()) + '/' + AllS(LastRec()) + '=' + AllS(100*RecNo()/LastRec(),'999%')

	ss := AllTrim(TEKST)
	ss := StrTran( ss, '&amp;', '&')

	s := '</Alias'; if (SubStr(ss, -Len(s))==s); klient_pse := SubStr(ss, 0, Len(ss)-Len(s)); endif
	s := '</Nazw' ; if (SubStr(ss, -Len(s))==s); klient_naz := SubStr(ss, 0, Len(ss)-Len(s)); endif
	s := '</Ulic' ; if (SubStr(ss, -Len(s))==s); klient_uli := SubStr(ss, 0, Len(ss)-Len(s)); endif
	s := '</kodP';  if (SubStr(ss, -Len(s))==s); klient_kod := SubStr(ss, 0, Len(ss)-Len(s)); endif
	s := '</Mias';  if (SubStr(ss, -Len(s))==s); klient_mia := SubStr(ss, 0, Len(ss)-Len(s)); endif
	s := '</NIP';   if (SubStr(ss, -Len(s))==s); klient_NIP := SubStr(ss, 0, Len(ss)-Len(s)); endif

	s := '</ZAPIS'
	if (Left(ss, Len(s))==s)
		i++
		
		ps := PadR(Konwert( klient_pse, win, maz ),10)
		ni := PadR(Konwert( klient_nip, win, maz ),15)
		na := PadR(Konwert( klient_naz, win, maz ),120)

		if (!( bb )->(DBSeek( ps+ni+na )))
			n++
			lastNr++
			
			( bb )->( DBAppend())
			( bb )->KONTO := '201-D12-' + AllS(lastNr)
			( bb )->TRESC := na
			( bb )->NAZWA := na
			( bb )->ULICA := Konwert( klient_uli, win, maz )
			( bb )->KOD_POCZT := klient_kod
			( bb )->MIASTO := Konwert( klient_mia, win, maz )
			( bb )->NIP := ni
			( bb )->NUMER := lastNr
			( bb )->PSEUDO := ps
		else
		endif
		
	endif

	skip
enddo
use
DBCommitAll()

x := 'run del LINIE.DBF'
RunCommand( x, 1 )

x := 'run del Dane.txt'
RunCommand( x, 1 )

Czek( 0 )
RestScreen(,,,, ekran )

Alarm( 'Pozycji nowych/wszystkich: ' + AllS( n ) + "/" + AllS( i ))

(bb)->(DBClearIndex())
won:=.t.

return .t.

*******************************************************************************

function ImportIneU()

local bb := Alias()

if (Alarm('Aktualizacja Numer i Pseudo kontrahent¢w wedíug kartoteki kontrahent¢w?',nt)<>2)
	return .f.
endif

Czek(1)

kk:='KNORDPOL'
ON(kk,3)	//NIP

Select(bb)
go top
all:=0
yok:=0
nok:=0
while !Eof()
	if ((((bb)->NRKONT=0) .or. (Empty((bb)->PSKONT))) .and. (!Empty((bb)->NIP)))
		all++
		ok:=.f.
		(kk)->(DBSeek((bb)->NIP))
		while ((kk)->NIP=(bb)->NIP) .and. (kk)->(!Eof()) .and. !ok
			ps:=(kk)->PSEUDO
			nr:=(kk)->NUMER
			na:=AllTrim((bb)->NAZWA)
			if na=Left(AllTrim((kk)->NAZWA),Len(na))
				ok:=.t.
			endif
*			(kk)->(DBSkip())
*			if ((bb)->NIP==(kk)->NIP)
*				nok++
*				ok:=.f.
*			endif
			(kk)->(DBSkip())
		enddo
		if (ok)
			yok++
			(bb)->(Blokuj_R())
			(bb)->PSKONT:=ps
			(bb)->NRKONT:=nr
			(bb)->(OdBlokuj_R())
		endif
	endif
	skip
enddo
Czek(0)

*Alarm('Na ' + AllS(all) + ' pozycji zmieniono ' + AllS(yok) + ', niezmieniono ' + AllS(nok) + ', pominiëto ' + AllS(all-yok-nok))
Alarm('Na ' + AllS(all) + ' pozycji zmieniono ' + AllS(yok) + ', pominiëto ' + AllS(all-yok-nok))

return .t.

*******************************************************************************
