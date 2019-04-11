*******************************************************************************
**********************************  STEMKO  ***********************************
*******************************************************************************
#include 'inkey.ch'

*******************************************************************************
* Kompensaty dostawcow
* mode:
* 1 - zero
* 2 - inc
* 3 - show

procedure Kompens( mode )

static tab_ko, tab_wa, zera_tez
local i, bb := Alias()

do case
   case mode = NIL .or. mode = 1
        tab_ko := {}
        tab_wa := {}
        Get_Okres( @data_od, @data_do )
        zera_tez := Alarm( 'Czy zerowe kwoty zakup¢w dostawc¢w teß?', nt ) = 2
   case mode = 2
        if 0 = ( i := AScan( tab_ko, DOSTAWCA ))
           Aadd( tab_ko, DOSTAWCA )
        endif
   case mode = 3
        tab_ko := ASort( tab_ko )
        KompTab( @tab_ko, @tab_wa )
        for i := 1 to Len( tab_ko )
            if zera_tez .or. ( Len( tab_wa ) > 0 .and. tab_wa[ i ] # 0 )
               ? tab_ko[ i ], if( Len( tab_wa ) > 0, tab_wa[ i ], 0 )
            endif
        next
endcase

Select( bb )

*******************************************************************************

function KompTab( tab_ko, tab_wa )

local i, wa

ON( 'K_ARCH' )
while !Eof()

   if data_od > K_ARCH->DATA2 .or. data_do < K_ARCH->DATA1
      DBSkip()
      loop
   endif

   ON( 'MEGAWN', 2, K_ARCH->KATALOG )

   for i := 1 to Len( tab_ko )
       wa := 0
       DBSeek( Str( tab_ko[ i ]))
       while ODBIORCA = tab_ko[ i ] .and. !Eof()
             if data_od <= DATA_FAKT .and. DATA_FAKT <= data_do
                wa += OGOLEM
             endif
             skip
       enddo
       Aadd( tab_wa, wa )
   next

   Zwolnij( 'MEGAWN' )

   ON( 'MEGAZN',, K_ARCH->KATALOG )

   for i := 1 to Len( tab_ko )
       wa := 0
       DBSeek( Str( tab_ko[ i ]))
       while ODBIORCA = tab_ko[ i ] .and. !Eof()
             if data_od <= DATA_NOTY .and. DATA_NOTY <= data_do
                wa += ROZNICA
             endif
            skip
       enddo
       tab_wa[ i ] += wa
   next

   Zwolnij( 'MEGAZN' )

   Select( 'K_ARCH' )
   DBSkip()

enddo

Zwolnij( 'K_ARCH' )

*******************************************************************************

function Znak_MAG( sy, ce, do )

return if( RAP_KM->( DBSeek( sy + str( do ) + str( ce ))), '*', ' ' )

*******************************************************************************
* 90

procedure Zaznacz_MAG()

if Znak_MAG( INDEKS, CENA_ZAKUP, DOSTAWCA ) == '*'; RAP_KM->( BDelete())
else; KopiujRec( 'MEGAKM', 'RAP_KM',,, 57 )
endif

Keyboard Chr( K_DOWN )

*******************************************************************************
* 92

procedure SeriaZnakow( a )

local bb, ii, rr, baza, indeks, pole
private buf, zakres1, zakres2

bb := Alias()

baza := Odetnij( @a )
indeks := Val( Odetnij( @a ))
pole := Odetnij( @a )
buf := pole

Select( baza )
zakres1 := &buf
zakres2 := &buf

if !NewSysForm( a ); return; endif

Czek( 1 )

ii := 1
rr := 1
if Jest_baza( baza )
   ii := IndexOrd()
   rr := RecNo()
endif

ON( baza, indeks )

if ValType( zakres1 ) == 'N'
   buf := Str( zakres1 )
   DBSeek( buf, .t. )
   buf := 'zakres1<=' + pole + '.and.zakres2>=' + pole
else
   if pole == 'NAZWA'
      zakres1 := Upper( AllTrim( zakres1 ))
      zakres2 := Upper( AllTrim( zakres2 ))
      buf := zakres1
      DBSeek( buf, .t. )
      buf := 'zakres1<=Left(Upper(AllTrim(' + pole + ')),Len(zakres1)).and.' +;
             'zakres2>=Left(Upper(AllTrim(' + pole + ')),Len(zakres2))'
   else
      zakres1 := Upper( zakres1 )
      zakres2 := Upper( zakres2 )
      buf := zakres1
      DBSeek( buf, .t. )
      buf := 'zakres1<=Upper(' + pole + ').and.' +;
             'zakres2>=Upper(' + pole + ')'
   endif
endif

Przerwa( LastRec())
while &buf .and. !Eof()
      if !Znak_MAG( MEGAKM->INDEKS, MEGAKM->CENA_ZAKUP, MEGAKM->DOSTAWCA ) == '*'
         KopiujRec( 'MEGAKM', 'RAP_KM',,, 57 )
      endif
      DBSkip()
      if Przerwa(); exit; endif
enddo
Przerwa( 0 )

DBSetOrder( ii )
DBGoTo( rr )
wy := 2

Czek( 0 )
Select( bb )

*******************************************************************************

procedure ChangeHaslo()

local h, h2

if Empty( GetEnv( 'AREK' ))

SetColor( 'w/n,n/n' )
h := Get_U( 10, 10, 'Podaj dotychczasowe hasío :', Sz_X( 10 ), Space( 10 ))
SetColor( STC )

if h = NIL .or. h # Deszyfr( HASLO, 7 ); return; endif    && zíe hasío

endif

SetColor( 'w/n,n/n' )
if ( h := Get_U( 10, 10, 'Podaj nowe hasío :', Sz_X( 10 ), Space( 10 ))) = NIL; return; endif
SetColor( STC )

SetColor( 'w/n,n/n' )
if ( h2 := Get_U( 10, 10, 'Powt¢rz nowe hasío :', Sz_X( 10 ), Space( 10 ))) = NIL; return; endif
SetColor( STC )

if h # h2; return; endif

DOSTEP->( Blokuj_R())
DOSTEP->HASLO := Deszyfr( h, -7 )
DOSTEP->( OdBlokuj_R())

Alarm( 'Od teraz obowiÜzuje nowe hasío ...' )

*******************************************************************************
* Nr 94, tytuí, baza, pole daty

procedure Import( a )

local line, tyt, baza, sy, ce, do, ii, kk, k, i

if Get_okres( @data_od, @data_do ) = NIL; return; endif

line := SaveScreen( mr, 0, mr, mc )

Czek( 1 )

tyt := Odetnij( @a )
baza := Odetnij( @a )
private pole := Odetnij( @a )

ON( 'RAP_KM' )
ON( 'MEGAKM' )
ON( 'K_ARCH' )
while !Eof()

if data_od > K_ARCH->DATA2 .or. data_do < K_ARCH->DATA1
   DBSkip()
   loop
endif

@ mr, 0 say PadC( tyt + ' ( ' + AllTrim( K_ARCH->UWAGI ) + ' )', mc - 1 )
ON( baza,, K_ARCH->KATALOG )
Przerwa( LastRec())
DBGoBottom()
i := 0
kk := LastRec()
k := '/' + AllS( kk, '999,999' ) + ' = '
while !Bof()
      i++
      @ 0, 0 say AllS( i, '999,999' ) + k + AllS( 100*i/kk, '999%' ) + Space( 10 )
      sy := INDEKS
      ce := CENA_ZAKUP
      do := DOSTAWCA
      if ( data_od <= &( pole )) .and.;
         ( data_do >= &( pole ))
         if RAP_KM->( DBSeek(sy))
            RAP_KM->( Blokuj_R())
            RAP_KM->S0 += ( baza )->ILOSC
            RAP_KM->S0N += 1
         else
            if MEGAKM->( DBSeek(sy+Str(do)+Str(ce)))
               KopiujRec( 'MEGAKM', 'RAP_KM',,, 57 )
               RAP_KM->( Blokuj_R())
               RAP_KM->S0 := ( baza )->ILOSC
               RAP_KM->S0N := 1
            endif
         endif
      endif
      Select( baza )
      DBSkip( -1 )
      if ( data_od > &( pole )); exit; endif
      if Przerwa(); return; endif
enddo
Zwolnij( baza )

Select( 'K_ARCH' )
DBSkip()
if Przerwa(); return; endif
enddo
Przerwa( 0 )

Zwolnij( 'MEGAKM' )
Zwolnij( 'K_ARCH' )

Select( 'RAP_KM' )
DBSetOrder( 1 )
go top
rn := RecNo()
wy := 2

@ 0, 0
RestScreen( mr, 0, mr, mc, line )

*******************************************************************************
* 95

*procedure Browser( a )

*local oBrowse, oColumn

*ON( a )

*ON( 'TBROWSE' ); DBSeek( a )

*oBrowse := TBrowseDB( nTop, nLeft, nBottom, nRight )

*oBrowse:cargo     := cargo
*oBrowse:colorSpec := colorSpec
*oBrowse:rowPos    := rowPos
*oBrowse:colPos    := colPos
*oBrowse:colSep    := '≥'
*oBrowse:footSep   := 'Õ'
*oBrowse:headSep   := 'Õ'

*Zwolnij( 'TBROWSE' )

*ON( 'TBCOLUMN' ); DBSeek( a )

*while AllTrim( NAZWA ) == a .and. !Eof()

*      oColumn := TBColumnNew( heading, FieldWBlock( AllTrim( block ), Select( a )))

*      oColumn:cargo := cargo
*      oColumn:colSep := colSep
*      oColumn:headSep := headSep
*      oColumn:footSep := footSep
*      oColumn:defColor := defColor
*      oColumn:footing := footing
*      oColumn:heading := heading
*      oColumn:width := width

*      oBrowse:addColumn( oColumn )

*      DBSkip()

*enddo

*Zwolnij( 'TBCOLUMN' )

*ON( a )

*while .t.
*      oBrowse:ForceStable()
*      if oBrowse:hitTop .or. oBrowse:hitBottom
*         LastZero()
*         Tone( 125, 0 )
*      endif
*      nKey := Inkey( 0 )
*      do case
*      case nKey = K_ESC       ; exit
*      case nKey = K_DOWN      ; oBrowse:down()
*      case nKey = K_PGDN      ; oBrowse:pageDown()
*      case nKey = K_CTRL_PGDN ; oBrowse:goBottom()
*      case nKey = K_UP        ; oBrowse:up()
*      case nKey = K_PGUP      ; oBrowse:pageUp()
*      case nKey = K_CTRL_PGUP ; oBrowse:goTop()
*      case nKey = K_RIGHT     ; oBrowse:right()
*      case nKey = K_LEFT      ; oBrowse:left()
*      case nKey = K_HOME      ; oBrowse:home()
*      case nKey = K_END       ; oBrowse:end()
*      case nKey = K_CTRL_LEFT ; oBrowse:panLeft()
*      case nKey = K_CTRL_RIGHT; oBrowse:panRight()
*      case nKey = K_CTRL_HOME ; oBrowse:panHome()
*      case nKey = K_CTRL_END  ; oBrowse:panEnd()
*      otherwise
*           LastZero()
*           Tone( 125, 0 )
*      endcase
*enddo

*******************************************************************************
* Nr 96
* "MEGAKO->OPIS, NAZWA"

procedure Opis_Rekordu( a )

local ekran := SaveScreen(), buf

private pole, tytul, baza

pole := Odetnij( @a )
tytul:= Odetnij( @a )
baza := Odetnij( @a )

if Empty( baza ); Blokuj_R()
else; ( baza )->( Blokuj_R())
endif

buf := &pole
if Edit( @buf, &tytul )
	&pole := buf
endif

if Empty( baza ); OdBlokuj_R()
else; ( baza )->( OdBlokuj_R())
endif

SetCursor( 0 )

RestScreen( ,,,, ekran )

*******************************************************************************
* 91

procedure ObliczRKM( a )

local sy, ce, do, nr, i, n, rr := RecNo(), st, line, dt, il
local i0, n0, i1, i2, i3, in, n1, n2, n3, nn, lpbi, lpko
local zamczy := .f., zamtak := .f., mcy, datap

if Get_okres( @data_od, @data_do ) = NIL; return; endif

datap := Datee()
*datap := Get_U( 10, 10, 'Podaj datë od kt¢rej liczyç wstecz: ', 'XXXXXXXXXX', Datee())
*if datap = NIL; return; endif

zamtak := Alarm( 'Uwzglëdniaç zam¢wienia w sprzedaßy ?', tk )
if zamtak = 0; return; endif
zamtak := ( zamtak = 1 )

line := SaveScreen( mr, 0, mr, mc )

Czek( 1 )

ON( "MEGAKM" )
ON( "CHCIELI" )

ON( 'RAP?OBR' )
ON( 'RAP?OBR',,,, .t. )

Select( 'RAP_KM' )
go top
Przerwa( LastRec())
while !Eof()

      in := INDEKS
      dt := DATA_BO

      MEGAKM->( DBSeek( in ))
      while MEGAKM->INDEKS == in .and. MEGAKM->( !Eof())
            dt := if( dt < MEGAKM->DATA_BO, MEGAKM->DATA_BO, dt )
            MEGAKM->( DBSkip())
      enddo

      il := 0
      CHCIELI->( DBSeek( in ))
      while CHCIELI->INDEKS == in .and. CHCIELI->( !Eof())
            if dt < CHCIELI->DATA
               il += CHCIELI->ILOSCB
               CHCIELI->( AppendRecord( 'RAP_OBR', { ODBIORCA, INDEKS, ILOSC, ILOSCB, DATA, CZAS, OSOBA }))
            endif
            CHCIELI->( DBSkip())
      enddo

      Blokuj_R()

      RAP_KM->DATA_BO := dt
      RAP_KM->PRZECENA := il

      RAP_KM->ZR := 0       && PZ
      RAP_KM->ZRN:= 0
      RAP_KM->Z0 := 0       && PZ 0
      RAP_KM->Z0N:= 0
      RAP_KM->Z1 := 0       && PZ 1
      RAP_KM->Z1N:= 0
      RAP_KM->Z2 := 0       && PZ 2
      RAP_KM->Z2N:= 0
      RAP_KM->Z3 := 0       && PZ 3
      RAP_KM->Z3N:= 0
      RAP_KM->Z4 := 0       && PZ 4
      RAP_KM->Z4N:= 0
      RAP_KM->Z5 := 0       && PZ 5
      RAP_KM->Z5N:= 0
      RAP_KM->Z6 := 0       && PZ 6
      RAP_KM->Z6N:= 0
      RAP_KM->ZW := 0       && PZ wczeûniej
      RAP_KM->ZWN:= 0
      RAP_KM->SR := 0       && SP
      RAP_KM->SRN:= 0
      RAP_KM->WSR:= 0
      RAP_KM->S0 := 0       && SP 0
      RAP_KM->S0N:= 0
      RAP_KM->WS0:= 0
      RAP_KM->S1 := 0       && SP 1
      RAP_KM->S1N:= 0
      RAP_KM->WS1:= 0
      RAP_KM->S2 := 0       && SP 2
      RAP_KM->S2N:= 0
      RAP_KM->WS2:= 0
      RAP_KM->S3 := 0       && SP 3
      RAP_KM->S3N:= 0
      RAP_KM->WS3:= 0
      RAP_KM->S4 := 0       && SP 4
      RAP_KM->S4N:= 0
      RAP_KM->WS4:= 0
      RAP_KM->S5 := 0       && SP 5
      RAP_KM->S5N:= 0
      RAP_KM->WS5:= 0
      RAP_KM->S6 := 0       && SP 6
      RAP_KM->S6N:= 0
      RAP_KM->WS6:= 0
      RAP_KM->SW := 0       && SP wczeûniej
      RAP_KM->SWN:= 0
      RAP_KM->WSW:= 0
      if Przerwa(); return; endif
      DBSkip()
enddo
Przerwa( 0 )

ON( 'K_ARCH' )

go bottom
lpko := K_ARCH->LP
go top

while !Eof()

if data_od > K_ARCH->DATA2 .or. data_do < K_ARCH->DATA1
   DBSkip()
   loop
endif

@ mr, 0 say PadC( 'Wprowadzanie zakup¢w' + ' ( ' + AllTrim( K_ARCH->UWAGI ) + ' )', mc - 1 )
ON( 'MEGAPW', 4, K_ARCH->KATALOG )
Select( 'RAP_KM' )
Przerwa( LastRec())
go top
lpbi := K_ARCH->LP
while !Eof()
      store 0 to i0, n0, i, n, i1, i2, i3, i4, i5, i6, in, n1, n2, n3, n4, n5, n6, nn
      sy := INDEKS
      ce := CENA_ZAKUP
      do := DOSTAWCA
*if lpbi = lpko    && 'bießÜce' $ K_ARCH->UWAGI
*      if IL_BO # 0; AppendRecord( 'RAP_OBR', { sy, ' ', '"B.O."', DATA_BO, do, IL_BO,, ce }); endif
*      if  ZN_M # 0; AppendRecord( 'RAP_OBR', { sy, '0', 'Reklamacje', DATA_BO, do,-ZN_M,, ce }); endif
*      if    S2 # 0; AppendRecord( 'RAP_OBR', { sy, '0', 'R¢ßnica inw.', DATA_BO, do, S2,, ce }); endif
*      if !Empty( DATA_TRAN ) .and.;
*                 DATA_TRAN >= data_od .and.;
*                 DATA_TRAN <= data_do
*         AppendRecord( 'RAP_OBR', { sy, '6', 'Inwentaryzacja', DATA_TRAN, do, ZN_M2,, ce })
*      endif
*endif
      Select( 'MEGAPW' )
      DBSeek( sy )            && + Str(ce) + Str(do))
      while sy == INDEKS .and. !Eof()
            if DATA_DOST >= data_od .and. DATA_DOST <= data_do
               n ++
               i += ILOSC
               mcy := Mcy_temu( DATA_DOST, datap )
               do case
               case mcy = 0  && lpko = lpbi   && Month( DATA_DOST ) = Month( Datee())
                  n0 ++
                  i0 += ILOSC
               case mcy = 1  && lpbi = lpko - 1  && Month( DATA_DOST ) = Month( Datee()) - 1
                  n1 ++
                  i1 += ILOSC
               case mcy = 2  && lpbi = lpko - 2  && Month( DATA_DOST ) = Month( Datee()) - 2
                  n2 ++
                  i2 += ILOSC
               case mcy = 3  && lpbi = lpko - 3  && Month( DATA_DOST ) = Month( Datee()) - 3
                  n3 ++
                  i3 += ILOSC
               case mcy = 4  && lpbi = lpko - 4  && Month( DATA_DOST ) = Month( Datee()) - 4
                  n4 ++
                  i4 += ILOSC
               case mcy = 5  && lpbi = lpko - 5  && Month( DATA_DOST ) = Month( Datee()) - 5
                  n5 ++
                  i5 += ILOSC
               case mcy = 6  && lpbi = lpko - 6  && Month( DATA_DOST ) = Month( Datee()) - 6
                  n6 ++
                  i6 += ILOSC
               case mcy > 6  && lpbi < lpko - 6  && Month( DATA_DOST ) < Month( Datee()) - 6
                  nn ++
                  in += ILOSC
               endcase
*               AppendRecord( 'RAP_OBR', { sy, '1', '"PZ" ' + NR_PZ, DATA_DOST, do, ILOSC,, CENA_ZAKUP })
            endif
            DBSkip()
            if Przerwa(); return; endif
      enddo
      Select( 'RAP_KM' )
      Blokuj_R()
      RAP_KM->ZR += i      && PZ
      RAP_KM->ZRN+= n
      RAP_KM->Z0 += i0     && PZ 0
      RAP_KM->Z0N+= n0
      RAP_KM->Z1 += i1     && PZ 1
      RAP_KM->Z1N+= n1
      RAP_KM->Z2 += i2     && PZ 2
      RAP_KM->Z2N+= n2
      RAP_KM->Z3 += i3     && PZ 3
      RAP_KM->Z3N+= n3
      RAP_KM->Z4 += i4     && PZ 4
      RAP_KM->Z4N+= n4
      RAP_KM->Z5 += i5     && PZ 5
      RAP_KM->Z5N+= n5
      RAP_KM->Z6 += i6     && PZ 6
      RAP_KM->Z6N+= n6
      RAP_KM->ZW += in     && PZ wczeûniej
      RAP_KM->ZWN+= nn
      DBSkip()
      if Przerwa(); return; endif
enddo
Przerwa( 0 )
Zwolnij( 'MEGAPW' )

@ mr, 0 say PadC( 'Wprowadzanie korekt zakup¢w' + ' ( ' + AllTrim( K_ARCH->UWAGI ) + ' )', mc - 1 )
ON( 'MEGATN',, K_ARCH->KATALOG )
ON( 'MEGATW',, K_ARCH->KATALOG )
Select( 'RAP_KM' )
Przerwa( LastRec())
go top
while !Eof()
      store 0 to i0, n0, i, n, i1, i2, i3, i4, i5, i6, in, n1, n2, n3, n4, n5, n6, nn
      sy := INDEKS
      ce := CENA_ZAKUP
      do := DOSTAWCA
      Select( 'MEGATW' ); DBSetOrder( 2 )
      DBSeek( sy )            && + Str(ce) + Str(do))
      while sy == INDEKS1 .and. !Eof()
            nr := NR_NPZ
            MEGATN->( DBSeek( nr ))
            if MEGATN->DATA_NOTY >= data_od .and. MEGATN->DATA_NOTY <= data_do
               n ++
               i -= ILOSC1
               mcy := Mcy_temu( MEGATN->DATA_NOTY, datap )
               do case
               case mcy = 0  && lpbi = lpko      && Month( MEGATN->DATA_NOTY ) = Month( Datee())
                  n0 ++
                  i0 -= ILOSC1
               case mcy = 1  && lpbi = lpko - 1  && Month( MEGATN->DATA_NOTY ) = Month( Datee()) - 1
                  n1 ++
                  i1 -= ILOSC1
               case mcy = 2  && lpbi = lpko - 2  && Month( MEGATN->DATA_NOTY ) = Month( Datee()) - 2
                  n2 ++
                  i2 -= ILOSC1
               case mcy = 3  && lpbi = lpko - 3  && Month( MEGATN->DATA_NOTY ) = Month( Datee()) - 3
                  n3 ++
                  i3 -= ILOSC1
               case mcy = 4  && lpbi = lpko - 4  && Month( MEGATN->DATA_NOTY ) = Month( Datee()) - 4
                  n4 ++
                  i4 -= ILOSC1
               case mcy = 5  && lpbi = lpko - 5  && Month( MEGATN->DATA_NOTY ) = Month( Datee()) - 5
                  n5 ++
                  i5 -= ILOSC1
               case mcy = 6  && lpbi = lpko - 6  && Month( MEGATN->DATA_NOTY ) = Month( Datee()) - 6
                  n6 ++
                  i6 -= ILOSC1
               case mcy > 6  && lpbi < lpko - 6  && Month( MEGATN->DATA_NOTY ) < Month( Datee()) - 6
                  nn ++
                  in -= ILOSC1
               endcase
*               AppendRecord( 'RAP_OBR', { sy, '2', '"KPZ" ' + NR_NPZ, MEGATN->DATA_NOTY, do, -ILOSC1,, CENA1 })
            endif
            DBSkip()
            if Przerwa(); return; endif
      enddo
      Select( 'MEGATW' ); DBSetOrder( 3 )
      DBSeek( sy )            && + Str(ce) + Str(do))
      while sy == INDEKS2 .and. !Eof()
            nr := NR_NPZ
            MEGATN->( DBSeek( nr ))
            if MEGATN->DATA_NOTY >= data_od .and. MEGATN->DATA_NOTY <= data_do
               n ++
               i += ILOSC2
               mcy := Mcy_temu( MEGATN->DATA_NOTY, datap )  && lpbi = lpko      && Month( MEGATN->DATA_NOTY ) = Month( Datee())
               do case
               case mcy = 0  && lpbi = lpko      && Month( MEGATN->DATA_NOTY ) = Month( Datee())
                  n0 ++
                  i0 += ILOSC2
               case mcy = 1  && lpbi = lpko - 1  && Month( MEGATN->DATA_NOTY ) = Month( Datee()) - 1
                  n1 ++
                  i1 += ILOSC2
               case mcy = 2  && lpbi = lpko - 2  && Month( MEGATN->DATA_NOTY ) = Month( Datee()) - 2
                  n2 ++
                  i2 += ILOSC2
               case mcy = 3  && lpbi = lpko - 3  && Month( MEGATN->DATA_NOTY ) = Month( Datee()) - 3
                  n3 ++
                  i3 += ILOSC2
               case mcy = 4  && lpbi = lpko - 4  && Month( MEGATN->DATA_NOTY ) = Month( Datee()) - 4
                  n4 ++
                  i4 += ILOSC2
               case mcy = 5  && lpbi = lpko - 5  && Month( MEGATN->DATA_NOTY ) = Month( Datee()) - 5
                  n5 ++
                  i5 += ILOSC2
               case mcy = 6  && lpbi = lpko - 6  && Month( MEGATN->DATA_NOTY ) = Month( Datee()) - 6
                  n6 ++
                  i6 += ILOSC2
               case mcy > 6  && lpbi < lpko - 6  && Month( MEGATN->DATA_NOTY ) < Month( Datee()) - 6
                  nn ++
                  in += ILOSC2
               endcase
*               AppendRecord( 'RAP_OBR', { sy, '2', '"KPZ" ' + NR_NPZ, MEGATN->DATA_NOTY, do, +ILOSC2,, CENA2 })
            endif
            DBSkip()
            if Przerwa(); return; endif
      enddo
      Select( 'RAP_KM' )
      Blokuj_R()
      RAP_KM->ZR += i      && PZ
      RAP_KM->ZRN+= n
      RAP_KM->Z0 += i0     && PZ 0
      RAP_KM->Z0N+= n0
      RAP_KM->Z1 += i1     && PZ 1
      RAP_KM->Z1N+= n1
      RAP_KM->Z2 += i2     && PZ 2
      RAP_KM->Z2N+= n2
      RAP_KM->Z3 += i3     && PZ 3
      RAP_KM->Z3N+= n3
      RAP_KM->Z4 += i4     && PZ 4
      RAP_KM->Z4N+= n4
      RAP_KM->Z5 += i5     && PZ 5
      RAP_KM->Z5N+= n5
      RAP_KM->Z6 += i6     && PZ 6
      RAP_KM->Z6N+= n6
      RAP_KM->ZW += in     && PZ wczeûniej
      RAP_KM->ZWN+= nn
      DBSkip()
      if Przerwa(); return; endif
enddo
Przerwa( 0 )
Zwolnij( 'MEGATN' )
Zwolnij( 'MEGATW' )

@ mr, 0 say PadC( 'Wprowadzanie dokument¢w "WZ"' + ' ( ' + AllTrim( K_ARCH->UWAGI ) + ' )', mc - 1 )
ON( 'MEGAWW', 4, K_ARCH->KATALOG )
Select( 'RAP_KM' )
Przerwa( LastRec())
go top
while !Eof()
      store 0 to i0, n0, i, n, i1, i2, i3, i4, i5, i6, in, n1, n2, n3, n4, n5, n6, nn
      store 0 to w0, w1, w2, w3, w4, w5, w6, ww, wn, w
      sy := INDEKS
      ce := CENA_ZAKUP
      do := DOSTAWCA
      Select( 'MEGAWW' )
      DBSeek( sy )            && + Str(ce) + Str(do))
      while sy == INDEKS .and. !Eof()

				if FLAGA == '*'; skip; loop; endif	&& úciúle magazynowe sio

            dt := DATA_FAKT
            zamczy := !IsDigit( NR_WZ )      && zam¢wienie nie ma cyfry z lewej
            if zamczy; dt := Datee(); endif   && jak zam¢wienie to data bießÜca

            if data_od <= dt .and. dt <= data_do;
               .and.;
               if( zamtak, .t., !zamczy )

               n ++
               i += ILOSC
					w := Upust( Grosz( ILOSC * CENA ), UPUST )
					wn += w
               mcy := Mcy_temu( dt, datap )
               do case
               case mcy = 0  && lpbi = lpko      && Month( dt ) = Month( Datee())
                  n0 ++
                  i0 += ILOSC
						w0 += w
               case mcy = 1  && lpbi = lpko - 1  && Month( dt ) = Month( Datee()) - 1
                  n1 ++
                  i1 += ILOSC
						w1 += w
               case mcy = 2  && lpbi = lpko - 2  && Month( dt ) = Month( Datee()) - 2
                  n2 ++
                  i2 += ILOSC
						w2 += w
               case mcy = 3  && lpbi = lpko - 3  && Month( dt ) = Month( Datee()) - 3
                  n3 ++
                  i3 += ILOSC
						w3 += w
               case mcy = 4  && lpbi = lpko - 4  && Month( dt ) = Month( Datee()) - 4
                  n4 ++
                  i4 += ILOSC
						w4 += w
               case mcy = 5  && lpbi = lpko - 5  && Month( dt ) = Month( Datee()) - 5
                  n5 ++
                  i5 += ILOSC
						w5 += w
               case mcy = 6  && lpbi = lpko - 6  && Month( dt ) = Month( Datee()) - 6
                  n6 ++
                  i6 += ILOSC
						w6 += w
               case mcy > 6  && lpbi < lpko - 6  && Month( dt ) < Month( Datee()) - 6
                  nn ++
                  in += ILOSC
						ww += w
               endcase
*               AppendRecord( 'RAP_OBR', { sy, '5', '"WZ" ' + NR_WZ, dt, ODBIORCA, -ILOSC,, CENA })
            endif
            DBSkip()
            if Przerwa(); return; endif
      enddo
      Select( 'RAP_KM' )
      Blokuj_R()
      RAP_KM->SR += i      && SP
      RAP_KM->SRN+= n
      RAP_KM->WSR+= wn
      RAP_KM->S0 += i0     && SP 0
      RAP_KM->S0N+= n0
      RAP_KM->WS0+= w0
      RAP_KM->S1 += i1     && SP 1
      RAP_KM->S1N+= n1
      RAP_KM->WS1+= w1
      RAP_KM->S2 += i2     && SP 2
      RAP_KM->S2N+= n2
      RAP_KM->WS2+= w2
      RAP_KM->S3 += i3     && SP 3
      RAP_KM->S3N+= n3
      RAP_KM->WS3+= w3
      RAP_KM->S4 += i4     && SP 4
      RAP_KM->S4N+= n4
      RAP_KM->WS4+= w4
      RAP_KM->S5 += i5     && SP 5
      RAP_KM->S5N+= n5
      RAP_KM->WS5+= w5
      RAP_KM->S6 += i6     && SP 6
      RAP_KM->S6N+= n6
      RAP_KM->WS6+= w6
      RAP_KM->SW += in     && SP wczeûniej
      RAP_KM->SWN+= nn
      RAP_KM->WSW+= ww
      DBSkip()
      if Przerwa(); return; endif
enddo
Przerwa( 0 )
Zwolnij( 'MEGAWW' )

@ mr, 0 say PadC( 'Wprowadzanie korekt sprzedaßy' + ' ( ' + AllTrim( K_ARCH->UWAGI ) + ' )', mc - 1 )
ON( 'MEGAZN',, K_ARCH->KATALOG )
ON( 'MEGAZW',, K_ARCH->KATALOG )
Select( 'RAP_KM' )
Przerwa( LastRec())
go top
while !Eof()
      store 0 to i0, n0, i, n, i1, i2, i3, i4, i5, i6, in, n1, n2, n3, n4, n5, n6, nn
      store 0 to w0, w1, w2, w3, w4, w5, w6, ww, wn, w
      sy := INDEKS
      ce := CENA_ZAKUP
      do := DOSTAWCA
      Select( 'MEGAZW' ); DBSetOrder( 2 )
      DBSeek( sy )            && + Str(ce) + Str(do))
      while sy == INDEKS1 .and. !Eof()
            nr := NR_NFK
            MEGAZN->( DBSeek( nr ))
            if MEGAZN->DATA_NOTY >= data_od .and. MEGAZN->DATA_NOTY <= data_do
               n ++
               i -= ILOSC1
					w := Grosz( ILOSC1 * CENA )
					wn -= w
               mcy := Mcy_temu( MEGAZN->DATA_NOTY, datap )
               do case
               case mcy = 0  && lpbi = lpko      && Month( MEGAZN->DATA_NOTY ) = Month( Datee())
                  n0 ++
                  i0 -= ILOSC1
                  w0 -= w
               case mcy = 1  && lpbi = lpko - 1  && Month( MEGAZN->DATA_NOTY ) = Month( Datee()) - 1
                  n1 ++
                  i1 -= ILOSC1
                  w1 -= w
               case mcy = 2  && lpbi = lpko - 2  && Month( MEGAZN->DATA_NOTY ) = Month( Datee()) - 2
                  n2 ++
                  i2 -= ILOSC1
                  w2 -= w
               case mcy = 3  && lpbi = lpko - 3  && Month( MEGAZN->DATA_NOTY ) = Month( Datee()) - 3
                  n3 ++
                  i3 -= ILOSC1
                  w3 -= w
               case mcy = 4  && lpbi = lpko - 4  && Month( MEGAZN->DATA_NOTY ) = Month( Datee()) - 4
                  n4 ++
                  i4 -= ILOSC1
                  w4 -= w
               case mcy = 5  && lpbi = lpko - 5  && Month( MEGAZN->DATA_NOTY ) = Month( Datee()) - 5
                  n5 ++
                  i5 -= ILOSC1
                  w5 -= w
               case mcy = 6  && lpbi = lpko - 6  && Month( MEGAZN->DATA_NOTY ) = Month( Datee()) - 6
                  n6 ++
                  i6 -= ILOSC1
                  w6 -= w
               case mcy > 6  && lpbi < lpko - 6  && Month( MEGAZN->DATA_NOTY ) < Month( Datee()) - 6
                  nn ++
                  in -= ILOSC1
                  ww -= w
               endcase
*               AppendRecord( 'RAP_OBR', { sy, '4', '"KFK" ' + NR_NFK, MEGAZN->DATA_NOTY, ODBIORCA, +ILOSC1,, CENA1 })
            endif
            DBSkip()
            if Przerwa(); return; endif
      enddo
      Select( 'MEGAZW' ); DBSetOrder( 3 )
      DBSeek( sy )            && + Str(ce) + Str(do))
      while sy == INDEKS2 .and. !Eof()
            nr := NR_NFK
            MEGAZN->( DBSeek( nr ))
            if MEGAZN->DATA_NOTY >= data_od .and. MEGAZN->DATA_NOTY <= data_do
               n ++
               i += ILOSC2
					w := Grosz( ILOSC2 * CENA )
					wn += w
               mcy := Mcy_temu( MEGAZN->DATA_NOTY, datap )
               do case
               case mcy = 0 && lpbi = lpko      && Month( MEGAZN->DATA_NOTY ) = Month( Datee())
                  n0 ++
                  i0 += ILOSC2
                  w0 += w
               case mcy = 1 && lpbi = lpko - 1  && Month( MEGAZN->DATA_NOTY ) = Month( Datee()) - 1
                  n1 ++
                  i1 += ILOSC2
                  w1 += w
               case mcy = 2 && lpbi = lpko - 2  && Month( MEGAZN->DATA_NOTY ) = Month( Datee()) - 2
                  n2 ++
                  i2 += ILOSC2
                  w2 += w
               case mcy = 3 && lpbi = lpko - 3  && Month( MEGAZN->DATA_NOTY ) = Month( Datee()) - 3
                  n3 ++
                  i3 += ILOSC2
                  w3 += w
               case mcy = 4 && lpbi = lpko - 4  && Month( MEGAZN->DATA_NOTY ) = Month( Datee()) - 4
                  n4 ++
                  i4 += ILOSC2
                  w4 += w
               case mcy = 5 && lpbi = lpko - 5  && Month( MEGAZN->DATA_NOTY ) = Month( Datee()) - 5
                  n5 ++
                  i5 += ILOSC2
                  w5 += w
               case mcy = 6 && lpbi = lpko - 6  && Month( MEGAZN->DATA_NOTY ) = Month( Datee()) - 6
                  n6 ++
                  i6 += ILOSC2
                  w6 += w
               case mcy > 6 && lpbi < lpko - 6  && Month( MEGAZN->DATA_NOTY ) < Month( Datee()) - 6
                  nn ++
                  in += ILOSC2
                  ww += w
               endcase
*               AppendRecord( 'RAP_OBR', { sy, '4', '"KFK" ' + NR_NFK, MEGAZN->DATA_NOTY, ODBIORCA, -ILOSC2,, CENA2 })
            endif
            DBSkip()
            if Przerwa(); return; endif
      enddo
      Select( 'RAP_KM' )
      Blokuj_R()
      RAP_KM->SR += i      && SP
      RAP_KM->SRN+= n
      RAP_KM->WSR+= wn
      RAP_KM->S0 += i0     && SP 0
      RAP_KM->S0N+= n0
      RAP_KM->WS0+= w0
      RAP_KM->S1 += i1     && SP 1
      RAP_KM->S1N+= n1
      RAP_KM->WS1+= w1
      RAP_KM->S2 += i2     && SP 2
      RAP_KM->S2N+= n2
      RAP_KM->WS2+= w2
      RAP_KM->S3 += i3     && SP 3
      RAP_KM->S3N+= n3
      RAP_KM->WS3+= w3
      RAP_KM->S4 += i4     && SP 4
      RAP_KM->S4N+= n4
      RAP_KM->WS4+= w4
      RAP_KM->S5 += i5     && SP 5
      RAP_KM->S5N+= n5
      RAP_KM->WS5+= w5
      RAP_KM->S6 += i6     && SP 6
      RAP_KM->S6N+= n6
      RAP_KM->WS6+= w6
      RAP_KM->SW += in     && SP wczeûniej
      RAP_KM->SWN+= nn
      RAP_KM->WSW+= ww
      DBSkip()
      if Przerwa(); return; endif
enddo
Zwolnij( 'MEGAZN' )
Zwolnij( 'MEGAZW' )

ON( 'KOR_SSDK',, K_ARCH->KATALOG )
Select( 'RAP_KM' )
Przerwa( LastRec())
go top
while !Eof()
      store 0 to i0, n0, i, n, i1, i2, i3, i4, i5, i6, in, n1, n2, n3, n4, n5, n6, nn
      store 0 to w0, w1, w2, w3, w4, w5, w6, ww, wn, w
      sy := INDEKS
      ce := CENA_ZAKUP
      do := DOSTAWCA
      Select( 'KOR_SSDK' ); DBSetOrder( 2 ); DBSeek( sy )
      while sy == INDEKS .and. !Eof()
				if FLAGA == '*'; skip; loop; endif	&& úciúle magazynowe sio
            if DATA_FAKT >= data_od .and. DATA_FAKT <= data_do .and. BYLO_MABYC == 'B'
               n ++
               i -= ILOSC
					w := Upust( Grosz( ILOSC * CENA ), UPUST )
					wn -= w
               mcy := Mcy_temu( DATA_FAKT, datap )
               do case
               case mcy = 0  && lpbi = lpko      && Month( DATA_FAKT ) = Month( Datee())
                  n0 ++
                  i0 -= ILOSC
                  w0 -= w
               case mcy = 1  && lpbi = lpko - 1  && Month( DATA_FAKT ) = Month( Datee()) - 1
                  n1 ++
                  i1 -= ILOSC
                  w1 -= w
               case mcy = 2  && lpbi = lpko - 2  && Month( DATA_FAKT ) = Month( Datee()) - 2
                  n2 ++
                  i2 -= ILOSC
                  w2 -= w
               case mcy = 3  && lpbi = lpko - 3  && Month( DATA_FAKT ) = Month( Datee()) - 3
                  n3 ++
                  i3 -= ILOSC
                  w3 -= w
               case mcy = 4  && lpbi = lpko - 4  && Month( DATA_FAKT ) = Month( Datee()) - 4
                  n4 ++
                  i4 -= ILOSC
                  w4 -= w
               case mcy = 5  && lpbi = lpko - 5  && Month( DATA_FAKT ) = Month( Datee()) - 5
                  n5 ++
                  i5 -= ILOSC
                  w5 -= w
               case mcy = 6  && lpbi = lpko - 6  && Month( DATA_FAKT ) = Month( Datee()) - 6
                  n6 ++
                  i6 -= ILOSC
                  w6 -= w
               case mcy > 6  && lpbi < lpko - 6  && Month( DATA_FAKT ) < Month( Datee()) - 6
                  nn ++
                  in -= ILOSC
                  ww -= w
               endcase
*               AppendRecord( 'RAP_OBR', { sy, '4', '"KFK" ' + NR_NFK, DATA_FAKT, ODBIORCA, +ILOSC,, CENA1 })
            endif
            DBSkip()
            if Przerwa(); return; endif
      enddo
      Select( 'KOR_SSDK' ); DBSetOrder( 2 ); DBSeek( sy )
      while sy == INDEKS .and. !Eof()
				if FLAGA == '*'; skip; loop; endif	&& úciúle magazynowe sio
            if DATA_FAKT >= data_od .and. DATA_FAKT <= data_do .and. BYLO_MABYC == 'M'
*              n ++
               i += ILOSC
					w := Upust( Grosz( ILOSC * CENA ), UPUST )
					wn += w
               mcy := Mcy_temu( DATA_FAKT, datap )
               do case
               case mcy = 0 && lpbi = lpko      && Month( DATA_FAKT ) = Month( Datee())
*                 n0 ++
                  i0 += ILOSC
						w0 += w
               case mcy = 1 && lpbi = lpko - 1  && Month( DATA_FAKT ) = Month( Datee()) - 1
*                 n1 ++
                  i1 += ILOSC
						w1 += w
               case mcy = 2 && lpbi = lpko - 2  && Month( DATA_FAKT ) = Month( Datee()) - 2
*                 n2 ++
                  i2 += ILOSC
						w2 += w
               case mcy = 3 && lpbi = lpko - 3  && Month( DATA_FAKT ) = Month( Datee()) - 3
*                 n3 ++
                  i3 += ILOSC
						w3 += w
               case mcy = 4 && lpbi = lpko - 4  && Month( DATA_FAKT ) = Month( Datee()) - 4
*                 n4 ++
                  i4 += ILOSC
						w4 += w
               case mcy = 5 && lpbi = lpko - 5  && Month( DATA_FAKT ) = Month( Datee()) - 5
*                 n5 ++
                  i5 += ILOSC
						w5 += w
               case mcy = 6 && lpbi = lpko - 6  && Month( DATA_FAKT ) = Month( Datee()) - 6
*                 n6 ++
                  i6 += ILOSC
						w6 += w
               case mcy > 6 && lpbi < lpko - 6  && Month( DATA_FAKT ) < Month( Datee()) - 6
*                 nn ++
                  in += ILOSC
						ww += w
               endcase
*               AppendRecord( 'RAP_OBR', { sy, '4', '"KFK" ' + NR_NFK, DATA_FAKT, ODBIORCA, -ILOSC,, CENA2 })
            endif
            DBSkip()
            if Przerwa(); return; endif
      enddo
      Select( 'RAP_KM' )
      Blokuj_R()
      RAP_KM->SR += i      && SP
      RAP_KM->SRN+= n
      RAP_KM->WSR+= wn
      RAP_KM->S0 += i0     && SP 0
      RAP_KM->S0N+= n0
      RAP_KM->WS0+= w0
      RAP_KM->S1 += i1     && SP 1
      RAP_KM->S1N+= n1
      RAP_KM->WS1+= w1
      RAP_KM->S2 += i2     && SP 2
      RAP_KM->S2N+= n2
      RAP_KM->WS2+= w2
      RAP_KM->S3 += i3     && SP 3
      RAP_KM->S3N+= n3
      RAP_KM->WS3+= w3
      RAP_KM->S4 += i4     && SP 4
      RAP_KM->S4N+= n4
      RAP_KM->WS4+= w4
      RAP_KM->S5 += i5     && SP 5
      RAP_KM->S5N+= n5
      RAP_KM->WS5+= w5
      RAP_KM->S6 += i6     && SP 6
      RAP_KM->S6N+= n6
      RAP_KM->WS6+= w6
      RAP_KM->SW += in     && SP wczeûniej
      RAP_KM->SWN+= nn
      RAP_KM->WSW+= ww
      DBSkip()
      if Przerwa(); return; endif
enddo
Zwolnij( 'KOR_SSDK' )

Select( 'K_ARCH' )
DBSkip()
if Przerwa(); return; endif
enddo
Przerwa( 0 )
Zwolnij( 'K_ARCH' )

*n := ''
*st := 0
*ON( 'RAP?OBR' )
*while !Eof()
*      if n # INDEKS
*         if RAP_KM->( DBSeek( n ))       && wpisanie stanu w/g obrotow
*            RAP_KM->( Blokuj_R())
*            RAP_KM->IL_BO := st          && do bazy matki
*         endif
*         n := INDEKS
*         st := 0
*      endif
*      if TYP # '3'
*         st += ILOSC
*         Blokuj_R()
*         RAP_OBR->STAN := st
*      endif
*      if TYP == '6' .or. TYP == ' '
*         st := ILOSC
*         Blokuj_R()
*         RAP_OBR->STAN := st
*      endif
*      DBSkip()
*enddo

*Select( 'RAP_KM' )
*if DBSeek( n )       && wpisanie stanu w/g obrotow
*   Blokuj_R()
*   RAP_KM->IL_BO := st          && do bazy matki
*endif

Select( 'RAP_KM' )
DBGoTo( rr )
Czek( 0 )
wy := 2

RestScreen( mr, 0, mr, mc, line )

*******************************************************************************
* a - SPRZEDAWCA, NABYWCA, "0" - BANK
* mode = NIL .or. 1 => 1
* else              =>-1

procedure WpiszFaktoring( a, mode, key )

private buf

if mode = NIL; mode := 1; endif

while !Empty( a )
      buf := Odetnij( @a )
      buf := if( '0' $ buf, ( &buf ), DOKUMENT->( &buf ))
      if KONTRAHE->( DBSeek( buf ))
         KONTRAHE->( Blokuj_R())
         KONTRAHE->DATA_O := DOKUMENT->DATA
         KONTRAHE->LIMIT_S -= DOKUMENT->WARTOSC * mode
      endif
enddo

if key # NIL; LastZero( key ); endif

*******************************************************************************
* a - SPRZEDAWCA, NABYWCA, "0" - BANK
* kw - kwota

procedure WpiszSpla( a, kw, key )

private buf

while !Empty( a )
      buf := Odetnij( @a )
      buf := if( '0' $ buf, ( &buf ), DOKUMENT->( &buf ))
      if KONTRAHE->( DBSeek( buf ))
         KONTRAHE->( Blokuj_R())
         KONTRAHE->DATA_O := DOKUMENT->DATA
         KONTRAHE->LIMIT_S += kw
      endif
enddo

if key # NIL; LastZero( key ); endif

*******************************************************************************
* a - baza, indeks, pole, wartoûç, { sprawdzany1, sprawdzany2, sprawdzany3 ...}

function Limit( baza, indeks, pole, wartosc, tab_spr )

local i, wy := .t.
private buf, buff, bufff

( baza )->( DBSetOrder( indeks ))
for i := 1 to Len( tab_spr )
    buf := &( tab_spr[ i ])
    buf := AllTrim( buf )
    if !( baza )->( DBSeek( buf ))
       Alarm( 'Brak danych o kontrahencie Nr "' + buf + '"' )
    else
       buff := pole
       buff := ( baza )->( &buff )
       if buff < wartosc
          bufff := wartosc - buff
          Alarm( 'Wolny limit kontrahenta "' + buf + '" wynosi ' + AllS( buff, '999,999,999.99 zí' ),;
               { 'Przekroczenie limitu o ' + AllS( bufff, '999,999,999.99 zí' )})
          wy := .f.
       endif
    endif
next

return wy

*******************************************************************************

function Dni( d1, d2, dn )

if dn = 360
   d1 := if( Day( d1 ) > 30, 30, Day( d1 )) + Month( d1 ) * 30 + ( Year( d1 ) - 1996 ) * 360
   d2 := if( Day( d2 ) > 30, 30, Day( d2 )) + Month( d2 ) * 30 + ( Year( d2 ) - 1996 ) * 360
endif

return if( d1 > d2, 0, d2 - d1 + 1 )

*******************************************************************************
* dt - data
* dm - delta month - przeskok miesiëcy
* mo = NIL - jeden wczeûniej, # NIL - pierwszy nastëpny

function LastDOM( dt, dm, mo )

local m, y

mo := if( mo = NIL, 1, mo )
y := Year( dt ) - 1900
m := Month( dt ) + dm
if m > 12
   m := m - 12
   y += 1
endif
m := StrTran( Str( m, 2 ), ' ', '0' )
y := StrTran( Str( y, 2 ), ' ', '0' )

return if( dm = 0, dt, CtoD( '01.' + m + '.' + y ) - mo )

*******************************************************************************
* st - stopa
* kw - kwota
* dn - dni bankowych ( 360 )
* d1 - dnie§ pierwszy
* d2 - dzie§ ostatni
* mo = NIL - kwota za caíy okres
* mo = 1, 2 ... - kwota za poszczeg¢lne miesiÜce

function Odsetki( st, kw, dn, d1, d2, mo )

local wy := 0

if st = NIL
	Odsetek()
	return
endif

if mo = NIL
   wy := st * kw / dn * Dni( d1, d2, dn ) * 0.01
else
   wy := LastDOM( d1, mo )
   d1 := LastDOM( d1, mo - 1, 0 )
   d2 := Min( d2, wy )
   wy := st * kw / dn * Dni( d1, d2, dn ) * 0.01
endif

return wy

*******************************************************************************

function Odsetki_Nr( d1, d2 )

d1 := Month( d1 )
d2 := Month( d2 )
d1 := d2 - d1 + 1

return if( d1 < 1 .or. d1 > 6, 0, &( 'ODSETKI_' + Str( d1, 1 )))

*******************************************************************************
function R( n ); return Round( n, 2 )
*******************************************************************************
function CVAT( n, mode )
if n == NIL
   return '   '
else
   if  DzienVAT0()
      if n =  5; n :=  0; endif
   endif
   return if( n < 0, 'zw.', Str( n, 2 ) + '%' )
endif
*******************************************************************************
function NVAT( n, mode )
   if  DzienVAT0()
      if n =  5; n :=  0; endif
   endif
return if( n < 0, 0, n )
*******************************************************************************
function DSeek( baza, i, k )
( baza )->( DBSetOrder( i ))
i := ( baza )->( DBSeek( k ))
return i
*******************************************************************************

procedure MEGAKMAppend( baza, bezgrup )

if File( baza ) .and. Alarm( 'Importowaç dane z magazynu ?', tk ) = 1

if bezgrup = NIL
   bezgrup := '0,050,01'
endif

bezgrup := ',' + bezgrup + ','

Czek( 1 )
private buf := baza
ON( Alias(),,,, .t. )
append from &buf for;
   !Empty( FLAGA );
   .and. ;
   !Empty( NAZWA ) ;
   .and. ;
   IsDigit( INDEKS ) ;
   .and. ;
   !Empty( GR ) ;
   .and. ;
   !( ',' + AllTrim( GR ) + ',' $ bezgrup )

buf := DtoC( Datee())
buf := Deszyfr( buf, 7 )
MemoWrit( cat_wzorow + 'olin.txt', buf )
Czek( 0 )

Konwersja()

DBSetOrder( 0 )
Czek( 1 )
go top
while !Eof()
		replace NAZWA with Konwert( NAZWA,,, 1 )
		replace PRODUCENT with Konwert( PRODUCENT,,, 1 )
		replace UWAGI with Konwert( UWAGI,,, 1 )
		skip
enddo
Czek( 0 )
DBSetOrder( 1 )
go top

endif

*******************************************************************************

procedure Konwersja

local i := Alarm( 'Konwersja Mazovia -> Windows ?', { 'kody Excela', 'kody Windows' })

do case
case i = 0
	konwertON := .f.
case i = 1
	konwertON := .t.
	szy := maz
	sna := lat
case i = 2
	konwertON := .t.
	szy := maz
	sna := win
endcase

*******************************************************************************
* baza - baza znacznik¢w
* wartosc - klucz w bazie znacznik¢w
* pole - zwracane pole z bazy znacznik¢w
* bez # NIL ( np. '999,999.999' ) - jeûli sÜ zera po przecinku to bez nich

function Znacznik( baza, wartosc, pole, bez )

( baza )->( DBSeek( wartosc ))
pole := ( baza )->( &pole )
if bez # NIL; pole := StrTran( Transform( pole, bez ), '.000', '    ' ); endif

return pole

*******************************************************************************
*73|G|Generuj zam¢w.|Zamowienie( 'WYB_RANE', 'RAP_KM', 'ZAMAW', 'ZAMAWSPE' )|
* baza1 - baza znacznikow
* baza2 - baza danych
* baza3 - baza dokumentow
* baza4 - baza specyfikacji
* test  - tylko informacja o wartoûci

procedure Zamowienie( baza1, baza2, baza3, baza4, test )

local rek := RecNo(), ind := IndexOrd(), llp := 0, in

private wn, wb, kolor, kolory := {}, jest

Fill_tab( @kolory, 'kolory.txt' )

if test = NIL
   if Alarm( 'Generowaç dokument zam¢wienia ?', tk ) # 1; return; endif
endif

Czek( 1 )

if test = NIL

   ON( baza3 )
   DBGoBottom()
   DBCAppend( { || ( baza3 )->LP := LP + 1 })
   ( baza3 )->DATA := Datee()
   ( baza3 )->CZAS := Time()
   ( baza3 )->OPIS := ""

   llp := ( baza3 )->LP

endif

wn := 0
wb := 0

ON( baza4 )
ON( baza2 )
*ON( baza2, 2 )

if test = NIL
   ( baza3 )->DOST := ( baza2 )->DOSTAWCA
endif

ON( 'MEGAKO' ); DBSeek(Str(( baza2 )->DOSTAWCA))
*ON( 'MEGAKO' )

ON( baza1 ); ON( baza1,,,,, .t. )   && pack
while !Eof()
      in := INDEKS
      jest := .f.
      for i := 1 to Len( kolory )
      kolor := Alias() + '->KOLOR' + AllS( i )
      kolor := &kolor
      if kolor # 0
         jest := .t.
         if ( baza2 )->( DBSeek( in ))
if test = NIL
            ( baza4 )->( DBAppend())
            ( baza4 )->LP := llp
            ( baza4 )->INDEKS := ( baza2 )->INDEKS
            ( baza4 )->ILOSC  := kolor
            ( baza4 )->CENA   := ( baza2 )->( FieldGet( 9 ))
            ( baza4 )->NAZWA  := AllTrim( kolory[ i ]) + ':' + ( baza2 )->NAZWA
            ( baza4 )->UWAGI  := ( baza2 )->UWAGI
endif
            wn += kolor * ( baza2 )->( FieldGet( 9 ))
            wb += kolor * Brutto(( baza2 )->( FieldGet( 9 )), ( baza2 )->VAT )
         endif
      endif
      next
      if !jest .and. ILOSC # 0
         if ( baza2 )->( DBSeek( in ))
if test = NIL
            ( baza4 )->( DBAppend())
            ( baza4 )->LP := llp
            ( baza4 )->INDEKS := ( baza2 )->INDEKS
            ( baza4 )->ILOSC  := ILOSC 
            ( baza4 )->CENA   := ( baza2 )->( FieldGet( 9 ))
            ( baza4 )->NAZWA  := ( baza2 )->NAZWA
            ( baza4 )->UWAGI  := ( baza2 )->UWAGI
endif
            wn += ILOSC * ( baza2 )->( FieldGet( 9 ))
            wb += ILOSC * Brutto(( baza2 )->( FieldGet( 9 )), ( baza2 )->VAT )
         endif
      endif
      skip
enddo

Czek( 0 )

if test # NIL

   NewSysForm( test )    && formularz informacji o wartoûci zam¢wienia

else

if wn = 0
   Alarm( 'Nie generujë zam¢wie§ zerowych !!!',;
        { '°aden towar nie ma okreûlonej iloûci zamawianej' })
   ( baza3 )->( BDelete())
   ON( baza1,,,, .t. )   && zap
else
   ( baza3 )->WARTOSCN := wn
   ( baza3 )->WARTOSCB := wb
   ON( baza1,,,, .t. )   && zap
   if Alarm( 'Wygenerowaíem zam¢wienie Nr ' + AllS( llp ),;
           { 'Drukowaç', 'Nie drukowaç = Esc' }) = 1
      Select( baza3 )
      Wydruk( ,, baza4, 'LP', 1 )
   endif
endif

endif

Zwolnij( baza3 )
Zwolnij( baza4 )
Select( baza2 )
DBSetOrder( ind )
DBGoTo( rek )
wy := 2

*******************************************************************************

procedure WWybr( h1, h2 )

local rr := RAP_KM->( RecNo()), kolory := {}, ok, sk

if WYB_RANE->(DBSeek(RAP_KM->INDEKS))
   ok := WYB_RANE->(NewSysForm(h1))
else
   ok := WYB_RANE->(NewSysDopisz(h2))
endif

if ok
   private kolor
   Fill_tab( @kolory, 'kolory.txt' )
   for i := 1 to Len( kolory )
       kolor := 'WYB_RANE->KOLOR' + AllS( i )
       kolor := &kolor
       if kolor # 0
          if sk = NIL
             sk := 0
          endif
          sk += kolor
       endif
   next
   if sk # NIL
      WYB_RANE->( Blokuj_R())
      WYB_RANE->ILOSC := sk
      WYB_RANE->( OdBlokuj_R())
   endif
endif

RAP_KM->( DBGo( rr ))
Keyboard Chr( K_DOWN )

*******************************************************************************
* Wpisuje netto w poszczeg¢lnych stakach VAT do tablicy 's' przez zmiennÜ

procedure WpiszStawki( s )

s[ 1 ] += K10 + K14      && 22%, towary, koszty
s[ 2 ] += K21 + K23      && 17%, towary, koszty
s[ 3 ] += K27 + K29      && 12%, towary, koszty
s[ 4 ] += K12 + K16      &&  7%, towary, koszty
s[ 5 ] += K18            &&  0%, towary, koszty
s[ 6 ] += K19            && zw., towary, koszty

*******************************************************************************

function ASum( s )

local i, w := 0
for i := 1 to Len( s ); w += s[ i ]; next
return w

*******************************************************************************

function ISN( s )

local i := 1, w := 0

while i <= Len( s ) .and. w = 0   && obliczanie indeksu tablicy 's' z wartoûciÜ
      if s[ i ] # 0
         w := i
      endif
      i++
enddo

return if( w = 0, Len( s ), w )

*******************************************************************************
*73|G|Generuj rachunki|GRach( 'REJ_OB', 1, 'KNORDPOL', 5, 'TOWARY', 'GRACH.txt' )|

procedure GRach( baza1, indeks1, baza2, indeks2, baza3, tab_txt )

local bb := Alias(), rek := RecNo(), ind := IndexOrd(), llp := 0, rere, tab
local ekran := SaveScreen()

if Get_Okres( data1, data2, 'Podaj zakres dat dokument¢w obciÜßeniowych.' ) = NIL; return; endif

tab := {}
Fill_Tab( @tab, tab_txt )

Czek( 1 )

private t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11

DBGoBottom()
t1 := Val(( bb )->NUMER) + 1
t2 := SubStr(( bb )->NUMER, At( '/', ( bb )->NUMER ))
t2 := PadR( if( Empty( t2 ), '/KW/97', t2 ), 30 )
t3 := PadR( 'V   Grupa koszt¢w rozliczana w/g kol. 8.', 120 )
t10:= PadR( 'VI  Grupa koszt¢w rozliczana w/g kol. 9.', 120 )
t4 := 'T'                       && czy umieszczaç w fakturach pozycje grupy III
t5 := 'N'                       && drukowaç rachunki w trakcie generowania
t6 := 'T'                       && zapisywaç rachunki o wartoûci 0
t7 := Datee()                    && data generowanych faktur
t8 := 3                         && iloûç dni zwíoki od daty sprzedaßy
t9 := PadR( tab[ 8 ], 30 )      && spos¢b zapíaty
t11:= PadR( '', 120 )           && lista kontrahent¢w do generowania

private s1, s2, s3, s4, s5, s6, v6, tv

tv := { 22, 17, 12, 7, 0, -1 }  && 22, 17, 12, 7, 0, zw.
s1 := { 0, 0, 0, 0, 0, 0 }
s2 := AClone( s1 )
s3 := AClone( s1 )
s4 := AClone( s1 )
s5 := AClone( s1 )

s6 := 0
v6 := 0

*s6 := AClone( s1 )

ON( baza1, indeks1 )     && REJ_OB  , LP
while !Eof()
      if data1 <= D3 .and. D3 <= data2
         do case
            case Left( K25, 3 ) == 'I  '; WpiszStawki( @s1 )
            case Left( K25, 3 ) == 'II '; WpiszStawki( @s2 )
            case Left( K25, 3 ) == 'III'; WpiszStawki( @s3 )
            case Left( K25, 3 ) == 'IV '; WpiszStawki( @s4 )
            case Left( K25, 3 ) == 'V  '; WpiszStawki( @s5 )
         endcase
      endif
      skip
enddo
Zwolnij( baza1 )

ON( baza3 )              && TOWARY
ON( baza2, indeks2 )     && KNORDPOL, Str(NUMER)

private k1, k2, k3, k4, k5
private is1, is2, is3, is4, is5, is6

is1 := ISN( s1 )
is2 := ISN( s2 )
is3 := ISN( s3 )
is4 := ISN( s4 )
is5 := ISN( s5 )
*is6 := ISN( s6 )

k1 := 1.33
k2 := 1.15
k3 := s3[ is3 ]
k4 := Grosz( k3 * 0.1 )
k5 := 0

if !NewSysForm( 'WMKWOTY,' + 'Podaj parametry generowania.' )
   Select( bb )
   RestScreen( ,,,, ekran )
   return
endif

if k5 = 0 .and. Upper( t4 ) = 'T'      && liczyç grupë III
   k5 := k3
   go top
   while !Eof()                               && obliczanie "k5"
      if !Empty( LOKALE1 + LOKALE2 );
         .and.;
         ( baza2 )->ZUZYCIE # 0
         k5 -= Grosz( k1 * ( baza2 )->ZUZYCIE )
         k5 -= Grosz( k2 * ( baza2 )->ZUZYCIE )
         k5 -= Grosz( k4 * ( baza2 )->( if( PROCENT5 <> 0, PROCENT5, if( PROCENT3 <> 0, PROCENT3, PROCENT1 ))) * 0.01 )
      endif
      skip
   enddo
   if !NewSysForm( 'WMKWOTY,' + 'Potwierd¶ parametry generowania.' )
      Select( bb )
      RestScreen( ,,,, ekran )
      return
   endif
endif

go top
while !Eof()

   if !Empty( LOKALE1 + LOKALE2 );
      .and.;
      ( Empty( t11 );
        .or.;
        ( ',' + AllTrim( Str( NUMER )) + ',' ) $ ( ',' + AllTrim( t11 ) + ',' ))

      rere := 1
      if s6 # 0 .and. ASum( s5 ) = 0
         rere := 0    && jeszcze nic nie dopisaí do specyfikacji
         if PROCENT7 # 0 .and. !Empty( t10 )
            rere := 1
         endif
      endif

      if rere # 0

         Select( bb )       && REJ_SP
         DBSetOrder( 1 )    && LP
         DBGoBottom(); llp := ( bb )->LP + 1
         DBAppend(); ( bb )->LP := llp

         ( bb )->NUMER:= AllS( t1++ ) + t2
         ( bb )->D1   := t7
         ( bb )->D2   := t7
         ( bb )->D3   := t7
         ( bb )->D4   := t7 + t8
         ( bb )->K24  := t9
         ( bb )->NRKONT:= ( baza2 )->NUMER
         ( bb )->NIP  := ( baza2 )->NIP
         ( bb )->NAZWA:= ( baza2 )->NAZWA
         ( bb )->ADRES:= ( baza2 )->( KOD_POCZT + ' ' + AllTrim( MIASTO ) + ', ' + ULICA )

      endif

      Select( baza3 )

      if s6 # 0 .and. ASum( s5 ) = 0

         rere := 0    && jeszcze nic nie dopisaí do specyfikacji

         if ( baza2 )->PROCENT7 # 0 .and. !Empty( t10 )

            DBAppend()
            rere := RecNo()
            ( baza3 )->LPP := llp
            ( baza3 )->NAZWA := t10
            ( baza3 )->JM := ' % '
            ( baza3 )->ILOSC := ( baza2 )->PROCENT7 * 0.01
            ( baza3 )->CENA_PUP := s6
            ( baza3 )->VAT := v6

         endif

      else



         DBAppend()
         rere := RecNo()
         ( baza3 )->LPP := llp
         ( baza3 )->NAZWA := tab[ 1 ] + ' ' + AllTrim(( baza2 )->LOKALE1 )
         ( baza3 )->JM := ' % '
         ( baza3 )->ILOSC := ( baza2 )->PROCENT1 * 0.01
         ( baza3 )->CENA_PUP := s1[ is1 ]
         ( baza3 )->VAT := tv[ is1 ]

     for i := is1 + 1 to Len( s1 )
      if s1[ i ] # 0 .and. ( baza2 )->PROCENT1 # 0
         DBAppend()
         ( baza3 )->LPP := llp
         ( baza3 )->NAZWA := tab[ 1 ] + ' ' + AllTrim(( baza2 )->LOKALE1 )
         ( baza3 )->JM := ' % '
         ( baza3 )->ILOSC := ( baza2 )->PROCENT1 * 0.01
         ( baza3 )->CENA_PUP := s1[ i ]
         ( baza3 )->VAT := tv[ i ]
      endif
     next



         DBAppend()
         ( baza3 )->LPP := llp
         ( baza3 )->NAZWA := tab[ 2 ] + ' ' + AllTrim(( baza2 )->LOKALE2 )
         ( baza3 )->JM := ' % '
         ( baza3 )->ILOSC := ( baza2 )->PROCENT2 * 0.01
         ( baza3 )->CENA_PUP := s2[ is2 ]
         ( baza3 )->VAT := tv[ is2 ]

     for i := is2 + 1 to Len( s2 )
      if s2[ i ] # 0 .and. ( baza2 )->PROCENT2 # 0
         DBAppend()
         ( baza3 )->LPP := llp
         ( baza3 )->NAZWA := tab[ 2 ] + ' ' + AllTrim(( baza2 )->LOKALE2 )
         ( baza3 )->JM := ' % '
         ( baza3 )->ILOSC := ( baza2 )->PROCENT2 * 0.01
         ( baza3 )->CENA_PUP := s2[ i ]
         ( baza3 )->VAT := tv[ i ]
      endif
     next

**********************

         if Upper( t4 ) = 'T'      && liczyç grupë III

            if ( baza2 )->ZUZYCIE = 0


               DBAppend()
               ( baza3 )->LPP := llp
               ( baza3 )->NAZWA := tab[ 5 ]
               ( baza3 )->JM := ' % '
               ( baza3 )->ILOSC := ( baza2 )->PROCENT1 * 0.01
               ( baza3 )->CENA_PUP := k5
               ( baza3 )->VAT := tv[ is3 ]

            else

               DBAppend()
               ( baza3 )->LPP := llp
               ( baza3 )->NAZWA := tab[ 3 ]
               ( baza3 )->CENA_PUP := k1
               ( baza3 )->JM := ' m3'
               ( baza3 )->ILOSC := ( baza2 )->ZUZYCIE
               ( baza3 )->VAT := tv[ is3 ]

               DBAppend()
               ( baza3 )->LPP := llp
               ( baza3 )->NAZWA := tab[ 4 ]
               ( baza3 )->CENA_PUP := k2
               ( baza3 )->JM := ' m3'
               ( baza3 )->ILOSC := ( baza2 )->ZUZYCIE
               ( baza3 )->VAT := tv[ is3 ]

               DBAppend()
               ( baza3 )->LPP := llp
               ( baza3 )->NAZWA := tab[ 5 ]
               ( baza3 )->CENA_PUP := k4
               ( baza3 )->JM := ' % '
               ( baza3 )->ILOSC := ( baza2 )->( if( PROCENT5 <> 0, PROCENT5, if( PROCENT3 <> 0, PROCENT3, PROCENT1 ))) * 0.01
               ( baza3 )->VAT := tv[ is3 ]

               if ( baza2 )->PROCENT3 # 0
 
                  DBAppend()
                  ( baza3 )->LPP := llp
                  ( baza3 )->NAZWA := tab[ 5 ]
                  ( baza3 )->CENA_PUP := k5
                  ( baza3 )->JM := ' % '
                  ( baza3 )->ILOSC := ( baza2 )->PROCENT3 * 0.01
                  ( baza3 )->VAT := tv[ is3 ]

               endif

            endif

         endif

**********************

         DBAppend()
         ( baza3 )->LPP := llp
         ( baza3 )->NAZWA := tab[ 7 ]
         ( baza3 )->JM := ' % '
         ( baza3 )->ILOSC := ( baza2 )->PROCENT4 * 0.01
         ( baza3 )->CENA_PUP := s4[ is4 ]
         ( baza3 )->VAT := tv[ is4 ]

     for i := is4 + 1 to Len( s4 )
       if s4[ i ] # 0 .and. ( baza2 )->PROCENT4 # 0
         DBAppend()
         ( baza3 )->LPP := llp
         ( baza3 )->NAZWA := tab[ 7 ]
         ( baza3 )->JM := ' % '
         ( baza3 )->ILOSC := ( baza2 )->PROCENT4 * 0.01
         ( baza3 )->CENA_PUP := s4[ i ]
         ( baza3 )->VAT := tv[ i ]
       endif
     next

         if ASum( s5 ) # 0

            DBAppend()
            ( baza3 )->LPP := llp
            ( baza3 )->NAZWA := t3
            ( baza3 )->JM := ' % '
            ( baza3 )->ILOSC := ( baza2 )->PROCENT6 * 0.01
            ( baza3 )->CENA_PUP := s5[ is5 ]
            ( baza3 )->VAT := tv[ is5 ]

     for i := is5 + 1 to Len( s5 )
         if s5[ i ] # 0 .and. ( baza2 )->PROCENT6 # 0
            DBAppend()
            ( baza3 )->LPP := llp
            ( baza3 )->NAZWA := t3
            ( baza3 )->JM := ' % '
            ( baza3 )->ILOSC := ( baza2 )->PROCENT6 * 0.01
            ( baza3 )->CENA_PUP := s5[ i ]
            ( baza3 )->VAT := tv[ i ]
         endif
     next
         endif

         if s6 # 0

            DBAppend()
            ( baza3 )->LPP := llp
            ( baza3 )->NAZWA := t10
            ( baza3 )->JM := ' % '
            ( baza3 )->ILOSC := ( baza2 )->PROCENT7 * 0.01
            ( baza3 )->CENA_PUP := s6
            ( baza3 )->VAT := v6

         endif

      endif

     if rere # 0

       ( baza3 )->( OblFKRS( ,, rere ))

       if Upper( t6 ) = 'T'
          if Upper( t5 ) = 'T'
             Wydruk( 'rachunek.wyd', bb, baza3, 'LP', 1,,, 'LPP' )
          endif
       elseif ( bb )->K11 = 0
              ( bb )->( SkasujRec( 'TOWARY', '1', bb + '->LP', bb + '->LP == LPP' ))
              ( bb )->( BDelete())
       endif

     endif

     Select( baza2 )

   endif

   skip

enddo

Zwolnij( baza3 )
Zwolnij( baza2 )
Select( bb )
DBSetOrder( ind )
DBGoTo( rek )
Czek( 0 )
RestScreen( ,,,, ekran )
wy := 2

*******************************************************************************

procedure Obl_OB()

local bb := Alias()

if Get_Okres( data1, data2, 'Podaj zakres dat dokument¢w obciÜßeniowych.' ) = NIL; return; endif

Czek( 1 )

ON( bb,,,, .t. )    && zap

ON( 'REJ_ZA', 4 )
DBSeek( DtoS( data1 ), .t. )
while D3 <= data2 .and. !Eof()
      KopiujRec( 'REJ_ZA', 'REJ_OB' )
      skip
enddo
Zwolnij( 'REJ_ZA' )

ON( 'REJ_SP', 4 )
DBSeek( DtoS( data1 ), .t. )
while D3 <= data2 .and. !Eof()
      if Left( K24, 1 ) == 'I'
      AppendRecord( 'REJ_OB',;
{;
LP,;
NUMER,;
D1,;
D2,;
D3,;
D4,;
PRZEDMIOT,;
NIP,;
NAZWA,;
ADRES,;
-K11,;
0,;
0,;
0,;
0,;
-K12,;
-K13,;
-K14,;
-K15,;
-K16 - K17,;
-K22,;
-K23,;
0,;
0,;
-K25,;
-K26,;
'I',;
-K21,;
NRKONT,;
PSKONT,;
0,;
0,;
-K27,;
-K28,;
0 })
      endif
      skip
enddo
Zwolnij( 'REJ_SP' )

Select( bb )
Czek( 0 )
wy := 2
go top

*******************************************************************************

procedure Opis_Poz( a, i )

local sc := SaveScreen(), buf

Blokuj_R()
if Empty(( baza )->OPISY )
   ( baza )->OPISY := ''
   RunCommand( i )
endif

buf := ( baza )->OPISY
if Edit( @buf, a )
	( baza )->OPISY := buf
endif
OdBlokuj_R()
RestScreen( ,,,, sc )
SetCursor( 0 )

*******************************************************************************

procedure KPR_Opis_Init()

local i

for i := 7 to 20
    if FieldGet( i ) # 0
       ( baza )->OPISY += Str( FieldGet( i )) + ':' + EOL
    endif
next

*******************************************************************************

procedure Akt_WNCZ_WW( kat )

local bb := Alias(), nr, wn, in, cz

ON( 'MEGANU',, Zamiennik( 'handel' ))
ON( 'MEGAKM',, Zamiennik( 'handel' ))
ON( 'MEGAWW',, Zamiennik( kat ))

Select( bb )
go top
Przerwa( LastRec())
while !Eof()
      nr := NR_WZ
      wn := 0
      Select( 'MEGAWW' ); DBSeek( nr )
      while nr == NR_WZ .and. !Eof()
            in := INDEKS
            if !MEGAKM->( DBSeek( in ))
               if !MEGANU->( DBSeek( in ))
                  Alarm( 'Brak indeksu ' + in )
                  cz := 0
               else
                  cz := MEGANU->WART_BO
               endif
            else
               cz := MEGAKM->WART_BO
            endif
            wn += Grosz( ILOSC * cz )
            skip
      enddo
      Select( bb )
      Blokuj_R()
      replace WRT_ZAKUPN with wn
      OdBlokuj_R()
      if Przerwa(); exit; endif
      skip
enddo
Przerwa( 0 )

*******************************************************************************

procedure Akt_WNCZ_KS( kat )

local bb := Alias(), nr, wn, in, cz

ON( 'MEGANU',, Zamiennik( 'handel' ))
ON( 'MEGAKM',, Zamiennik( 'handel' ))
ON( 'KOR_SSDK',, Zamiennik( kat ))

Select( bb )
go top
Przerwa( LastRec())
while !Eof()
      nr := NUMER
      wn := 0
      Select( 'KOR_SSDK' ); DBSeek( nr )
      while nr == NUMER_DKS .and. !Eof()
            in := INDEKS
            if !MEGAKM->( DBSeek( in ))
               if !MEGANU->( DBSeek( in ))
                  Alarm( 'Brak indeksu ' + in )
                  cz := 0
               else
                  cz := MEGANU->WART_BO
               endif
            else
               cz := MEGAKM->WART_BO
            endif
            wn += if( BYLO_MABYC == "B", -1, 1 ) * Grosz( ILOSC * cz )
            skip
      enddo
      Select( bb )
      Blokuj_R()
      replace WNCZ with wn
      OdBlokuj_R()
      if Przerwa(); exit; endif
      skip
enddo
Przerwa( 0 )

*******************************************************************************
* dana data jest sprzed x m-cy

function Mcy_temu( dt, datap )

local d

if datap = NIL; datap := Datee(); endif

d := Year( datap ) * 12 + Month( datap )

dt := Year( dt ) * 12 + Month( dt )

return d - dt

*******************************************************************************
