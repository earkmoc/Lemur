******************************************************************************
****************************   ò R O D K I   T R W A ú E   *******************
******************************************************************************
* Agregacja historii ûrodka ( sÜsiadujÜce amortyzacje sÜ zbijane w jednÜ)

procedure AgrHiSRTR()

local st, wa, wi, wu, rr, rb, m, r, swa, swu

go top
swa := 0
swu := 0
while !Eof()

      swa += ZMWI - WAAM
      swu += ZMWU + WAAM
      Blokuj_R()
      replace WIBZ with swa
      replace WUBZ with swu
      OdBlokuj_R()

      if st = NIL .or. st # STOPAB
      else
         if m = Month( DATA );
            .and.;
            r = Year( DATA );
            .and.;
            st = STOPAB;
            .and.;
            wa # 0;
            .and.;
            WAAM # 0   && do agregacji

            rb := RecNo()
            Blokuj_R()
            replace WAAM with WAAM + wa
*            replace WIBZ with WIBZ + wi
*            replace WUBZ with WUBZ + wu
            OdBlokuj_R()
            DBGoTo( rr ); BDelete()    && poprzedni sio
            DBGoTo( rb )               && sumaryczny ok
         endif
      endif

      rr := RecNo()     && poprzednie wartoûci:
      st := STOPAB      && stopa
      wa := WAAM        && amortyzacja
      wi := WIBZ        && wartoûç ûrodka
      wu := WUBZ        && wartoûç umorzenia
      r := Year( DATA )
      m := Month( DATA )
      skip
enddo

******************************************************************************
* Import historii zmian innych ûrodk¢w trwaíych (skíadnik¢w zestawu)
* h - síowo-klucz oznaczajÜce skíadniki zestaw¢w

procedure ImpSRTR( h )

local ni, rr := SRODKITR->( RecNo()), i, nri := AllTrim( SRODKITR->NRINW )

private bb := Alias(), ids, idb := SRODKITR->LP

h := if( h = NIL, 'Skíadnik', '' )

if Alarm( 'Importowaç historie zmian innych ûrodk¢w trwaíych ?;Tworzyç historië zestawu na podstawie skíadnik¢w ?', nt ) # 2; return; endif

zap     && czyszczenie historii

i := 0

while .t.

i ++

ni := Get_U( 10, 3, 'Podaj numer inwentarzowy importowanego skíadnika ' + AllS( i ) + ' :', "@S10", Space( 10 ))
if ni = NIL; exit; endif

ON( 'SRODKITR' )
while !Eof()
      if NRINW == ni
         ids := LP                                    && identyfikator ûrodka
         if Left( NAZWASR, Len( h )) # h              && nie oznaczony
            Blokuj_R()                                && oznacz
            replace NAZWASR with h + ' Nr inw. ' + nri + ': ' + NAZWASR
            OdBlokuj_R()
         endif
         ON( 'SRODKIHI' )
         DBSeek( Str( ids ))
         KopiaRec(, bb, { || LPP = ids },,, { || ( bb )->LPP := idb, .f. })
         zmiana := .t.
         exit
      endif
      skip
enddo
enddo

ON( 'SRODKITR' )     && po w.w. "exit" moße nie byç w tej bazie
DBGoTo( rr )

Select( bb )

if zmiana      && agregacja zapis¢w
   AgrHiSRTR()
endif

******************************************************************************

procedure STImport( x )

local i, r, bb := Alias()

x := Get_U( 10, 10, 'Podaj importowanÜ bazë:', '@S30', PadR( x, 100 ))
if x = NIL; return; endif

use ( x ) new alias IMPORT
r := {}
for i := 1 to FCount(); Aadd( r, FieldGet( i )); next
while !Eof()
      for i := 1 to FCount(); r[ i ] := FieldGet( i ); next
      r[ 2 ] := AllS( r[ 2 ])
      AppendRecord( 'SRODKITR', r )
      skip
enddo

Zwolnij( 'IMPORT' )
Select( bb )

******************************************************************************
* Kwota miesiëcznych odpis¢w

function ST_KMO()

local x, wy, i

wy := 0

for i := 14 to 25
    x := SRODKITR->( FieldGet( i ))
    if x # 0
       if wy = NIL
          wy := x
       else
          if wy = x           && jest to co byío poprzednio
             return x
          else                && jest inne
             wy := x          && zapamiëtaj
          endif
       endif
    endif
next

return wy

******************************************************************************
* dt - data sprzedaßy
* mode = 1 => wi
* mode = 2 => um

function STGetAM( dt, mode )

local wy := 0, bb := Alias()

ON( 'SRODKIHI' )        && druga data podanego miesiÜca i roku
DBSeek( Str( SRODKITR->LP ) + DtoS( PDPMR( Month( dt ), Year( dt )) + 1 ), .t. )
*DBSeek( Str( SRODKITR->LP ) + DtoS( PDNM( dt )), .t. )
skip -1             && ostatni zapis pierwszego dnia podanego miesiÜca i roku
if SRODKITR->LP = LPP
   if mode = 1; wy := WIBZ + WUBZ
   else; wy := WUBZ
   endif
endif

Select( bb )

return -wy

******************************************************************************
* bez dopisywania # NIL => poprawianie

procedure STDopisz( x, bez )

local bb := Alias(), xx, zdop

private baza

zdop := ( bez = NIL )

if zdop

   ON( 'SRODKITR' )
   DBAppend()
   SRODKITR->LP:=GetLast(1,1)+1
   SRODKITR->DATA:=Datee()
   SRODKITR->NRP := 1
   SRODKITR->ILOSCP := 1
   SRODKITR->ILOSCS := 1

   ON( 'SRODKIOT' ); baza := Alias()
   DBAppend()
   (baza)->DATA:=Datee()
   (baza)->PKDATA:=Datee()
   (baza)->PKZADATA:=Datee()
   (baza)->LPP:=SRODKITR->LP

else

   ON( 'SRODKIOT' ); baza := Alias()
   if DBSeek( SRODKITR->LP )
      Blokuj_R()
   else
      DBAppend()
      (baza)->DATA:=Datee()
      (baza)->PKDATA:=Datee()
      (baza)->PKZADATA:=Datee()
      (baza)->LPP:=SRODKITR->LP
   endif

endif

SRODKITR->( Blokuj_R())

if !NewSysForm('SRODKIOT1,Dane dokumentu OT (Str Nr 1)'); STUsun( bb, bez ); return; endif

SRODKIOT->( Blokuj_R())
SRODKIOT->PKKWOTA := ( baza )->( if( WARTSZACUN < 0.01, KOSZTYRAZE, WARTSZACUN ))

if SRODKIOT->PKKWOTA < 0.01
   SRODKIOT->WARTSZACUN := SRODKITR->( WIBO + WIZW )
   SRODKIOT->PKKWOTA := ( baza )->( if( WARTSZACUN < 0.01, KOSZTYRAZE, WARTSZACUN ))
endif

if Empty( PKSUK ); SRODKIOT->PKSUK := SRODKITR->SYMBOLGR; endif
if Empty( PKNI  ); SRODKIOT->PKNI  := AllTrim( SRODKITR->NRINW ); endif
if Empty( PKSK  ); SRODKIOT->PKSK  := SRODKITR->UWAGI; endif

if !NewSysForm('SRODKIOT2,Dane dokumentu OT (Str Nr 2)'); STUsun( bb, bez ); return; endif

SRODKITR->( Blokuj_R())
SRODKITR->CENA := ( baza )->( if( WARTSZACUN < 0.01, KOSZTYRAZE, WARTSZACUN ))

if SRODKITR->ILOSCP < 0.01
   SRODKITR->ILOSCP := 1
   SRODKITR->ILOSCS := 1
endif

SRODKITR->WARTOSCP := Grosz( SRODKITR->( CENA * ILOSCP ))
SRODKITR->WARTOSCS := Grosz( SRODKITR->( CENA * ILOSCS ))
SRODKITR->UWAGI := SRODKIOT->PKSK
if Empty( SRODKITR->NRINW )
   SRODKITR->NRINW := AllTrim( SRODKIOT->PKNI )
endif
SRODKITR->SYMBOLGR := SRODKIOT->PKSUK

Select( 'SRODKITR' ); baza := Alias()
if !NewSysForm('KS_INW,Ksiëga inwentarzowa,,,,,,,5'); STUsun( bb, bez ); return; endif

SRODKITR->( Blokuj_R())
if Year( DATA ) = Year( Datee())  && przyjëcie do ußytkowania
   SRODKITR->WIZW := WARTOSCP
   SRODKITR->WIBZ := WARTOSCP
else
   xx := if( SRODKITR->UMBO < 0.01, WARTOSCP, SRODKITR->UMBO )
   xx := Get_U( 10, 5, 'Podaj wartoûç dotychczasowego umorzenia:', '999,999,999.99', xx )
   if xx = NIL; STUsun( bb, bez ); return; endif
   SRODKITR->WIBO := WARTOSCP    && kontynuacja umarzania
   SRODKITR->WIBZ := WARTOSCP
   SRODKITR->UMBO := xx
   SRODKITR->UMBZ := xx
endif

*if zdop
   GenHistory( 1, 1 )            && historia zmian jednego ûrodka
*endif

GenHistory(  , 1 )            && historia amortyzacji jednego ûrodka

NewSysForm( 'SRODKITR,Amortyzacja', .t. )

if !NewSysForm('PLANAMOR,Plan amortyzacji'); STUsun( bb, bez ); return; endif

******************************************************************************

procedure STUsun( bb, bez )

if bb = NIL; bb := Alias(); endif

if bez = NIL
   SkasujRec("SRODKIOT","1","SRODKITR->LP","SRODKITR->LP==LPP")
   SkasujRec("SRODKIHI","1","Str(SRODKITR->LP)","SRODKITR->LP==LPP")
   SkasujRec("SRODKIZM","1","SRODKITR->LP","SRODKITR->LP==LPP")
endif

Jest_baza( bb )

******************************************************************************
* w - wartoûç ûrodka
* u - wartoûç umorzenia: bo + zw - zm
* s - stopa
* d - data zakupu
* p - pozycja pierwszego miesiÜca do wypeínienia (indeks do tablicy wynik¢w)
* h - hasío komunikatu
* dt- data do okreûlenia kt¢ry rok obecnie liczymy

function Umorzenie( w, u, s, d, p, h, dt )

local umm, umr, ump, ok := .t., i, n, k, x

if dt = NIL; dt := Datee(); endif

if h # NIL
   ok := ( LastKey() = 13 )
   if ok .and. ( Alarm( h, tk ) # 1 ); ok := .f.; endif
endif

r := Year( d )                             && rok zakupu
umr := Grosz(  w * s * 0.01 )              && umorzenie roczne teoretycznie
umm := Grosz(( w * s * 0.01 ) / 12 )       && umorzenie miesiëczne teoretycznie

d := if( r < Year( dt ), 0, Month( d ))

if r = Year( dt ) .and. d = 12            && przyjëcie w grudniu tego roku
   umr := 0                               && umarzanie dopiero od przyszíego
   umm := 0
endif

*k := 12 - d                                && iloûç miesiëcy umarzania

ump := umr - d * umm                       && umorzenie roczne do wypykania
umw := 0                                   && umorzenie roczne wypykane

if u = 0
   x := 1
else
   x := Month( dt )              && to juß kolejny miesiÜc
   umw := ( x - d - 1 ) * umm    && czëûç rocznego jest juß wypykana
   ump -= umw                    && wiëc do wypykania w roku jest mniej
endif

for i := x - 1 to 11
    do case
       case i = 11; n := ump               && reszta
       case i < d; n := 0
       otherwise; n := umm
    endcase
    if umw + n > w           && przekroczenie wartoûci ûrodka
       n := w - umw
    endif
*    if umw + n + u > w      && przekroczenie wartoûci ûrodka
*       n := w - u - umw
*    endif
    umw += n
    if ok
       vp[ p + i ] := n
    endif
    ump -= n
next

return umw

******************************************************************************
* MiesiÜc dla Umorzenia

function MonthU( d, d1 )

if d1 = NIL; d1 := Datee(); endif

if Year( d ) < Year( d1 )           && ûrodek nie z tego roku
   return 0
else
   return Month( d )
endif

******************************************************************************
* mode = NIL - pytanie o wariant
* mode = 1 - test + alarm
* mode = 2 - test + pytanie o zmianë
* mode = 3 - test + zmiany bez pytania
* n - numer pola w bazie od kt¢rego zaczynajÜ sië "WMUA<i>"
* k - numer pola w formu od kt¢rego zaczynajÜ sië "WMUA<i>"

procedure TestAm( mode, n, k )

local x, r, rr := RecNo()

if mode = NIL
   mode := Alarm( 'Wybierz wariant postëpowania w razie;wykrycia odchyle§ podczas testu amortyzacji:',;
                { 'Tylko alarm',;
                  'Pytanie o poprawkë',;
                  'Poprawki bez pytania' })
   if mode = 0; return; endif
endif

private vp[ 30 ]

Czek( 1 )
go top
while !Eof()
   if ( 0.009 < Abs( r := ( UMWUR - ( x := Umorzenie( WIBZ, UMBO + UMZW - UMZM, STAWKA, DATA, k )))))
      do case
      case mode = 1; Alarm( '(LP=' + AllS( LP ) + ') Wartoûç rocznego umorzenia:; odchylenie o ' + AllS( r ))
      case mode = 2 .or. mode = 3
           if mode = 3 .or. ( Alarm( '(LP=' + AllS( LP ) + ') Wartoûç rocznego umorzenia:;poprawiç odchylenie o ' + AllS( r ) + ' ?', nt ) = 2 )
              ( baza )->( Blokuj_R())
              ( baza )->UMWUR := x
              ( baza )->UMBZ := UMBO + UMZW - UMZM + UMWUR
              for i := n to n + 11
                  FieldPut( i, vp[ k + ( i - n )])
              next
           endif
      endcase
   endif
   skip
enddo
Czek( 0 )
DBGoTo( rr )

******************************************************************************
* odpp= NIL - pyta co przeliczaç
* odpp# NIL - nie pyta i wtedy: 1 - jeden ûrodek, 2 - wszystkie
* bez - bez pyta§ o rok

procedure STOblicz( odpp, bez )

local bb := Alias(), rr := RecNo(), h, bh, nadt
local mc, rok, rokp := Year( Datee()), dt, wi, wis, um, ump, am, i, x, ph

*h := if( mode = NIL, 'amortyzacji', 'zmian wartoûci' )

if bez = NIL
   if NIL = ( rokp := Get_U( 10, 10, 'Przeliczyç dane na rok:', '9999', rokp ))
	   if NIL = ( nadt := Get_U( 10, 10, 'Przeliczyç dane na dzien:', '@S10', Date() )); return; endif
	endif
endif

odp := odpp
if odp = NIL
	if nadt = NIL
	   odp := Alarm( 'Przeliczyç na rok ' + AllS( rokp ) + ':',;
               { 'Wszystkie ûrodki', 'Tylko bießÜcy ûrodek' })
	else
		rokp := Year( nadt )
	   odp := Alarm( 'Przeliczyç na dzien ' + DtoC( nadt ) + ':',;
               { 'Wszystkie ûrodki', 'Tylko bießÜcy ûrodek' })
	endif
  	if odp = 0; return; endif
endif

data1 := ODPMR( 12, 1992 ) + 1
data2 := if( nadt # NIL, nadt, ODPMR( 12, rokp ))

bh := 'SRODKIHI'
ON( bh )
Select( bb )
if odp = 1; go top; endif
while !Eof()

      SRODKITR->( Blokuj_R())
      for i := 4 to 12; SRODKITR->( FieldPut( i, 0 )); next
      for i :=14 to 25; SRODKITR->( FieldPut( i, 0 )); next

      rok := rokp
      dt := ODPMR( 12, rok - 1 ) + 1      && 19990101 -> 20000101
      ( bh )->( DBSeek( Str(( bb )->LP ) + DtoS( dt ), .t. ))
      ph := ( bh )->( RecNo())            && poczÜtek drÜßenia historii

      ( bh )->( DBSkip( -1 ))             && 19981231, 19991231
      if (( bh )->LPP = ( bb )->LP ) .and. ( Year(( bh )->DATA ) # rok )
         SRODKITR->WIBO := ( bh )->( WIBZ + WUBZ )
         SRODKITR->UMBO := ( bh )->WUBZ
      endif

      ( bh )->( DBGoTo( ph ))
      while ( bh )->LPP = ( bb )->LP .and. ( bh )->( !Eof())

				if nadt # NIL .and. ( bh )->DATA > nadt
					( bh )->( DBSkip())
					loop
				endif

            if Year(( bh )->DATA ) = rok + 1
               if ( am := ( bh )->WAAM ) < 0.01    && zmiany wi, wu, st
                  if ( Day(( bh )->DATA ) = 1 ) .and.;
                     ( Month(( bh )->DATA ) = 1 )  
                     if ( bh )->ZMWI < 0.01
                        SRODKITR->WIZM += -( bh )->ZMWI
                     else
                        SRODKITR->WIZW += ( bh )->ZMWI
                     endif
                     if ( bh )->ZMWU < 0.01
                        SRODKITR->UMZM += -( bh )->ZMWU
                     else
                        SRODKITR->UMZW += ( bh )->ZMWU
                     endif
                  endif
               endif
            endif

            if Year(( bh )->DATA ) = rok
               if ( am := ( bh )->WAAM ) > 0.009           && amortyzacje
                  i := Month(( bh )->DATA )
                  SRODKITR->( FieldPut( i + 13, FieldGet( i + 13 ) + am ))
                  SRODKITR->UMWUR += am
					endif
*               else                                        && zmiany wi, wu, st
                     if ( bh )->ZMWI < 0.01
                        SRODKITR->WIZM += -( bh )->ZMWI    && + ( bh )->ZMWU
                     else
                        SRODKITR->WIZW += ( bh )->ZMWI     && - ( bh )->ZMWU
                     endif
                     if ( bh )->ZMWU < 0.01
                        SRODKITR->UMZM += -( bh )->ZMWU
                     else
                        SRODKITR->UMZW += ( bh )->ZMWU
                     endif
*               endif
            endif

            ( bh )->( DBSkip())
      enddo

      SRODKITR->WIBZ := SRODKITR->( WIBO + WIZW - WIZM )
*      SRODKITR->UMBZ := SRODKITR->( UMBO + UMZW - UMZM + UMWUR )
      SRODKITR->UMBZ := SRODKITR->( UMBO + UMWUR )

      if odp = 2; exit; endif
      SRODKITR->( OdBlokuj_R())
      skip
enddo

Select( bb )
DBGoTo( rr )

******************************************************************************
* mode = NIL - historia amortyzacji
* mode # NIL - historia zmian
* odpp # NIL - nie pyta tylko liczy i oblicza wartoûci formularza

procedure GenHistory( mode, odpp )

local bb := Alias(), rr := RecNo(), h, bh, dt0, rokd, stp, cosjest, bhlp
local mc, rok, rokp := Year( Datee()), dt, wi, wis, um, ump, am, i, x, ph

h := if( mode = NIL, 'amortyzacji', 'zmian wartoûci' )
bh:= if( mode = NIL, 'SRODKIHI', 'SRODKIZM' )

odp := odpp
if odp = NIL
   odp := Alarm( 'Generowaç historie ' + h + '?',;
               { 'Tylko bießÜcy ûrodek', 'Wszystkie ûrodki' })
   if odp = 0; return; endif
endif

rokd := rokp
if mode # NIL .and. odpp = NIL
   rokd := Get_U( 10, 10, 'Obecne dane sÜ za rok:', '9999', rokd )
endif

ON( 'SRODKIZM' )
ON( bh )
if odp = 2; ON( bh,,,, .t. ); endif   && zap
if odp = 1; ON( bh,,,,, .t.); endif   && pack
Select( bb )
if odp = 2; go top; endif
while !Eof()

      bhlp := 1

      ( bh )->( DBSeek( Str(( bb )->LP )))       && usuniëcie hist. bießÜc. ûr.
      while ( bh )->LPP = ( bb )->LP .and. ( bh )->( !Eof())
            ( bh )->( BDelete())
            ( bh )->( DBSkip())
      enddo

if mode = NIL                                 && amortyzacja

      rok := Year( SRODKITR->DATA )           && rok startowy

      SRODKIZM->( DBSeek( Str(( bb )->LP )))  && przepisanie historii zmian
      SRODKITR->( Blokuj_R())
      SRODKITR->DATA := SRODKIZM->DATA
      stp := SRODKIZM->ZMSTOPY                && poczÜtkowa stopa umarzania
      st := stp
      while SRODKIZM->LPP = ( bb )->LP .and. SRODKIZM->( !Eof())
            if Year( SRODKIZM->DATA ) = rokp  && ostatnia stopa liczonego roku
               st := SRODKIZM->ZMSTOPY        && poczÜtkowa stopa umarzania
            endif
            if st = 0.00 .and. stp = 0.00     && najwyra´niej 100% w koszty
*					if SRODKIZM->( ZMWI = ZMWU )
*   	            ( bh )->( AppendRecord(, SRODKIZM->({( bb )->LP, DATA, ZMWU, ZMWI, ZMWU,,, Str( ZMSTOPY, 6, 2 )})))
*					else
	               ( bh )->( AppendRecord(, SRODKIZM->({( bb )->LP, DATA, 0, ZMWI, ZMWU,,, Str( ZMSTOPY, 6, 2 )})))
*					endif
            else
*               if bhlp = 1         && new
                  ( bh )->( AppendRecord(, SRODKIZM->({( bb )->LP, DATA, 0, ZMWI, ZMWU,,, Str( ZMSTOPY, 6, 2 )})))
*               else
*                  ( bh )->( AppendRecord(, SRODKIZM->({( bb )->LP, PDNM( DATA ), 0, ZMWI, ZMWU,,, Str( ZMSTOPY, 6, 2 )})))
*               endif
               bhlp ++
            endif
            SRODKIZM->( DBSkip())
      enddo

      ( bh )->( DBSeek( Str(( bb )->LP )))      && obliczenie wi, um
      ph := ( bh )->( RecNo())                  && poczÜtek drÜßenia historii

      SRODKITR->STAWKA := st
      SRODKITR->( OdBlokuj_R())

      wi := 0
      um := 0
      wis := 0
      ump := 0

      mc := if( Year( DATA ) = rok, Month( DATA ) + 1, 1 )
      if mc = 13
         mc := 1
         rok ++
      endif

      if stp = 0.00        && 100% w koszty w miesi•cu przyj©cia
         mc --
         if mc < 1
            mc := 12
            rok --
         endif
      endif

      rok --               && zaraz bëdzie inkrementowany na bießÜcy

wis := 0                   && inicjowanie BO wartoûci inwentarzowej
while .t.

      x := .f.             && na razie nic sië nie zadziaío
      rok ++               && nastëpne lata symulacja teoretyczna

      for i := mc to 12

         dt := PDPMR( i, rok )            && new
*         dt := ODPMR( i, rok )
*         @ 0, 0 say rok + i * 0.01

         cosjest := .f.
         ( bh )->( DBGoTo( ph ))
         while ( bh )->LPP = ( bb )->LP .and. ( bh )->( !Eof())
            if (( bh )->WAAM = 0.00 )
               if (( bh )->DATA < dt ) .or. stp = 0.00
                  st := ( bh )->( if( Empty( ZMSTOPY ), st, Val( ZMSTOPY )))
                  wi += ( bh )->WIBZ - ( bh )->WUBZ      && dalej sÜ inkrementy
                  um += ( bh )->WUBZ
                  wis := if((( bh )->DATA < dt ), wi + um, wis )   && new
                  ( bh )->( Blokuj_R())
                  ( bh )->ZMWI := ( bh )->WIBZ
                  ( bh )->ZMWU := ( bh )->WUBZ
                  ( bh )->WIBZ := wi            && zmiana inkrement -> wartoûç
                  ( bh )->WUBZ := um
                  ( bh )->STOPAB:=st
                  ( bh )->WUBZ := um
						if st = 0.00 .and. ( bh )->( ZMWI = ZMWU )
	                  ( bh )->WAAM := ( bh )->ZMWI
						endif
*                  wis := ( bh )->( WIBZ + WUBZ )
                  ump := um
               else
                  cosjest := .t.
               endif
            endif
            ( bh )->( DBSkip())
         enddo

*         am := UmorzMies( WIBZ, STAWKA, ump, i, rok )    && kwota amortyzacji

         if stp = 0.00     && 100% w koszty
            am := wi
         else
            am := UmorzMies( wis, st, ump, i, rok )    && kwota amortyzacji
            if wis > 0.009 .and. ump > 0.009 .and. am < 0.01
               am := wi                                && jednak coû trzeba
            endif
         endif

         if am > 0.009
            if am > wi; am := wi; endif
            SRODKIHI->( AppendRecord(, {( bb )->LP, dt, am, wi - am, um + am,,,, st }))
            ph := ( bh )->( RecNo())        && poczÜtek drÜßenia historii
            wi -= am
            um += am
            x := .t.       && coû sië zadziaío w tym roku
         endif

*         if odpp # NIL .and. rok = rokp
*            SRODKITR->( FieldPut( i + 13, am ))
*            SRODKITR->UMWUR += am
*         endif

         if ( wi < 0.01 )        && juß by sko§czyí
            if cosjest           && ale coû jeszcze jest
               ( bh )->( DBGoTo( ph ))
               while ( bh )->LPP = ( bb )->LP .and. ( bh )->( !Eof())
                     if (( bh )->WAAM = 0.00 )
                        if (( bh )->DATA < dt )
                        else
                           ph := ( bh )->( RecNo())       && poczÜtek drÜßenia historii
                           i := Month(( bh )->DATA )      && next zwiëkszy o 1
                           rok := Year(( bh )->DATA )
                           exit
                        endif
                     endif
                     ( bh )->( DBSkip())
               enddo
            else
               exit
            endif
         endif

*         if wi < 0.01; exit; endif

      next

      if odpp # NIL .and. rok = rokp
         STOblicz( 1, 1 )
      endif

*      if odpp # NIL .and. rok = rokp
*         SRODKITR->WIBZ := SRODKITR->( WIBO + WIZW - WIZM )
*         SRODKITR->UMBZ := SRODKITR->( UMBO + UMZW - UMZM + UMWUR )
*      endif

      if !cosjest .and. ( wi < 0.01 .or. !x ); exit; endif

      mc := 1              && nowy rok od miesiÜca Nr 1

enddo

else

      rok := rokd

      if rok = NIL                          && dane za rok zakupu, wiëc r¢ßne
         rok := Year( SRODKITR->DATA )
      endif

      h := if( STAWKA = 0.00, 'Wyposaßenie: ', '' )

      if WIBO > 0.009 .or. UMBO > 0.009
         h += 'Wprowadzenie do ewidencji'
         if odpp # NIL
            SRODKIZM->( AppendRecord(, ( bb )->({ LP, DATA, WIBO, UMBO, h, STAWKA })))
         else
            SRODKIZM->( AppendRecord(, ( bb )->({ LP, ODPMR( 12, rok - 1 ), WIBO, UMBO, h, STAWKA })))
         endif
      endif

      if WIZW > 0.009 .or. UMZW > 0.009
         h += if( WIBO < 0.01, 'Przyjëcie do ußytkowania', 'Modernizacja' )
         SRODKIZM->( AppendRecord(, ( bb )->({ LP, DATA, WIZW, UMZW, h, STAWKA })))
      elseif WIZM > 0.009 .or. UMZM > 0.009
         h += if( WIBZ < 0.01, 'Zaprzestanie ußytkowania', 'Deprecjacja' )
         x := -1                          && wartoûç startowa
         dt := ODPMR( 12, rok - 1 )
         for i := 1 to 12                 && badamy bießÜcy rok
            am := &( 'WMUA' + AllS( i ))
            if am < x                     && zmniejszenie amortyzacji
               dt := ODPMR( i - 1, rok )
            endif
            x := am
         next
         SRODKIZM->( AppendRecord(, ( bb )->({ LP, dt, -WIZM, -UMZM, h, STAWKA })))
      endif

endif

      SRODKITR->( OdBlokuj_R())
      if odp = 1; ON( bh,,,,, .t. ); exit; endif  && pack
      skip
enddo

Select( bb )
DBGoTo( rr )

******************************************************************************

function UmorzMies( wi, st, um, i, rok )

static am[ 12 ]

local n

*if i = 1
   for n := 1 to Len( am ); am[ n ] := 0; next
   private vp[ 12 ]
   set epoch to 1990
   Umorzenie( wi, um, st, DATA, 1,, ODPMR( i, rok ))
   for n := 1 to Len( vp ); am[ n ] := vp[ n ]; next
   set epoch to 1930
*endif

return Grosz( am[ i ])

******************************************************************************
