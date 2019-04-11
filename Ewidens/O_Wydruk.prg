******************************************************************************
* Otwarcie pliku text dla rozkazow : ? ?? 

procedure mOpen( plik, mus, bezerase )

if fast_druk .and. mus = NIL .and. Jest_Drukarka( ' i skierowanie wydruku do pliku.' )
   prn2file := .f.   && wydruk na drukark‘, a nie do pliku
else
   prn2file := .t.   && wydruk do pliku, a nie na drukark‘
   if bezerase = NIL
      erase ( plik )
   endif
   set printer to ( plik )
endif
set device to printer
set printer on
set console off
*?? '@'            && reset printer

******************************************************************************
* Zamkniecie pliku po utworzeniu

procedure mClose

set printer to
set device to screen
set printer off
set console on

******************************************************************************
* Wypisuje czas utworzenia wydruku

procedure Czas( l )

?? 'Czas : ' + Time() + PadL( 'Data : ' + DtoC( Datee() ) , l - 15 )

******************************************************************************
* Double Width

procedure DW( mode )

?? 'W' + Str( mode , 1 )

*******************************************************************************
* Double Height

procedure DH( mode )

?? 'w' + Str( mode , 1 )

*******************************************************************************
* Emphasised - wyt’uszczone ( szersze )

procedure EM( mode )

?? '' + if( mode = 1 , 'E' , 'F' )

*******************************************************************************
* Enhanced - Double strike

procedure EH( mode )

?? '' + if( mode = 1 , 'G' , 'H' )

*******************************************************************************
* NLQ mode on/off

procedure NLQ( mode )

?? 'x' + Chr( mode )

*******************************************************************************
* CPI - Cal per Inch

procedure CPI( z , na )

do case
case z = 10 .and. na = 12 ; ?? 'M'
case z = 10 .and. na = 17 ; ?? Chr( 15 )
case z = 10 .and. na = 20 ; CPI( 10 , 12 ) ; ?? '' + Chr( 15 )
case z = 20 .and. na = 10 ; CPI( 20 , 12 ) ; CPI( 12 , 10 )
case z = 17 .and. na = 10 ; ?? Chr( 18 )
case z = 12 .and. na = 10 ; ?? 'P'
case z = 20 .and. na = 12 ; CPI( 17 , 10 )
endcase

*******************************************************************************
* Wydruk Standardowy ogl†danych w DBEdit'cie danych
*
* file_name - nazwa pliku do przechowywania wydruku
* title - tytu’ wydruku
* tab_sum - tablica kolumn do sumowania
* mxc - max column to print
* dx - odst‘p mi‘dzy kolumnami
* war - blok okrežlaj†cy warunek uwzgl‘dniania rekord¢w
* post_akcja - blok wykonywany po wyžwietleniu ka§dej linii cia’a wydruku
* tab_zer - tablica kolumn z obcinaniem zer

procedure Wydr_Standard( file_name , title , tab_sum , mxc , dx , war , post_akcja , tab_zer )

tab_sum := if( tab_sum = NIL , {} , tab_sum )
war := if( war = NIL , { || .t. } , war )
mxc := if( mxc = NIL , Len( szablon ) , mxc )
dx := if( dx = NIL , 1 , dx )
post_akcja := if( post_akcja = NIL , { || .t. } , post_akcja )

private plik := cat_wydr + file_name , l := Len( title )

Czek( 1 )
mOpen( plik )
Czas( wop )
?
?
DH( 1 )
if l <= wop10/2 ; DW( 1 ) ; ? PadC( title , wop/2 ) ; DW( 0 )
else                      ; ? PadC( title , wop )
endif
DH( 0 )
?

private i , k , linia , cp , suma[ Len( tab_sum ) ] , ile , zero

suma := AFill( suma , 0 )

linia := ''
for i := 1 to mxc
    linia += PadC( naglowki[ i ] , Len( StrTran( szablon[ i ] , '@Z ' , '' ) ) + dx )
next

l := Len( linia )
do case
case l <= wop10 ; l := wop10 ; cp := 10
case l <= wop12 ; l := wop12 ; cp := 12
case l <= wop17 ; l := wop17 ; cp := 17
endcase

CPI( 10 , cp )
? linia
? Replicate( 'Ä' , l )

go top
while !Eof()

      if !Eval( war ) ; skip ; loop ; endif

      zero := .t.
      for i := 1 to Len( tab_sum )
          k := Abs( tab_sum[ i ] )
          ile := &( kolumny[ k ] )
          if ile # 0.0
             suma[ i ] += ile
             zero := .f.
          endif
      next

      if Len( tab_sum ) # 0
         if zero ; skip ; loop ; endif
      endif

      ?
      for i := 1 to mxc
          if tab_zer = NIL ; k := AScan( tab_sum , -i )
          else             ; k := AScan( tab_zer , i )
          endif
          if k = 0 ; ?? Transform( &( kolumny[ i ] ) , szablon[ i ] ) + Space( dx )
          else     ; ?? Zera_won( Transform( &( kolumny[ i ] ) , szablon[ i ] ) ) + Space( dx )
          endif
      next

      Eval( post_akcja )

      skip
enddo

if Len( tab_sum ) # 0
   ? Replicate( 'Ä' , l )

   linia := ''
   for i := 1 to mxc                 && podsumowanie
       k := AScan( tab_sum , i )
       if k = 0
          k := AScan( tab_sum , -i )
          if k = 0 ; linia += Space( Len( StrTran( szablon[ i ] , '@Z ' , '' ) ) + dx )
          else     ; linia += Zera_won( Transform( suma[ k ] , szablon[ i ] ) ) + Space( dx )
          endif
       else     ; linia += Transform( suma[ k ] , szablon[ i ] ) + Space( dx )
       endif
   next

   title := 'Razem : '
   l := Len( linia ) - Len( LTrim( linia ) )         && ile wolnego z lewej
   if l >= Len( title )
      linia := PadL( title , l ) + LTrim( linia )    && dopisanie 'Razem : '
   endif

   ? linia

endif

CPI( cp , 10 )
eject

mClose()
Druk( plik , 1 )    && druk natychmiastowy
Czek( 0 )

******************************************************************************
* Zwraca nag’¢wek wydruku z wzoru
*   korzysta: bufor_wzoru

function Naglowek_wydruku

private wynik, n1, n2

szablon_wzoru := NIL

n1 := At( '{', bufor_wzoru )
n2 := At( '<', bufor_wzoru )

do case
case n1 = 0 .and. n2 = 0 ; Utnij( @bufor_wzoru, @wynik,,,)
case n1 = 0 .and. n2 # 0 ; Utnij( @bufor_wzoru, @wynik,,'<', -1 )
case n1 # 0 .and. n2 = 0 ; Utnij( @bufor_wzoru, @wynik,,'{', -1 )
case n1 < n2 ; Utnij( @bufor_wzoru, @wynik,,'{', -1 )
case n1 > n2 ; Utnij( @bufor_wzoru, @wynik,,'<', -1 )
endcase

n1 := At( EOL, wynik )
n2 := RAt(EOL, wynik )

if n2 # 0 .and. Len( wynik ) - n2 < 3
   wynik := Left( wynik, n2 - 1 )
endif

if n1 # 0 .and. n1 < 3
   wynik := SubStr( wynik, n1 + 2 )
endif

return wynik

*******************************************************************************
* Zwraca lini‘ wydruku wg wzoru z bufora_wydruku
* tab - tablica wartožci do wyžwietlenia
* sep - separator

function Linia_wydruku( tab, sep, bz )

local sw, wy, se

if sep = NIL; sep := ' '; endif

private wynik, n1, n2, raz := .f., i

if szablon_wzoru = NIL

    szablon_wzoru := {}

    n1 := At( '{', bufor_wzoru )
    n2 := At( '<', bufor_wzoru )

    do case
    case n1 = 0 .and. n2 = 0 ; return ''
    case n1 = 0 .and. n2 # 0 ; Utnij( @bufor_wzoru, @wynik,'<','>'); raz := .t.
    case n1 # 0 .and. n2 = 0 ; Utnij( @bufor_wzoru, @wynik,'{','}'); raz := .f.
    case n1 < n2 ; Utnij( @bufor_wzoru, @wynik,'{','}'); raz := .f.
    case n1 > n2 ; Utnij( @bufor_wzoru, @wynik,'<','>'); raz := .t.
    endcase

    n1 := 2
    while Len( wynik ) > 1
      i := At( '|', wynik ); if i = 0 ; i := 999; endif
      n2 := Min( i, 999 )
      i := At( '>', wynik ); if i = 0 ; i := 999; endif
      n2 := Min( i, n2 )
      i := At( '}', wynik ); if i = 0 ; i := 999; endif
      n2 := Min( i, n2 )
      Aadd( szablon_wzoru, SubStr( wynik, n1, n2 - n1 ))
      wynik := SubStr( wynik, n2 + 1 )
      n1 := 1
    enddo

endif

n1 := 1
wynik := ''

if min_szablon
  n2 := Min( Len( tab ), Len( szablon_wzoru ))
else
  n2 := Len( tab )
endif

for i := n1 to n2
    se := sep
 if tab[ i ] # NIL
    if Len( szablon_wzoru ) = 0
       sw := ''
    elseif i > Len( szablon_wzoru )
       sw := szablon_wzoru[ Len( szablon_wzoru )]
    else
       sw := StrTran( szablon_wzoru[ i ], ' ' + EOL, EOL )
    endif
    if '?' $ sw
       wy := Gwiazdki({ |a,b| Zera_won( Transform( a, b ))}, tab[ i ], StrTran( sw, '?', '.' ))
    else
       if Empty( sw )
          wy := ''
          se := ''
       elseif tab[ i ] # NIL
          if bz # NIL .and. Left( sw, 1 ) == '9'  && ValType( tab[ i ]) == 'N'
             wy := Gwiazdki({ |a,b| Transform( a, b )}, tab[ i ], '@Z ' + sw )
          else
             wy := Gwiazdki({ |a,b| Transform( a, b )}, tab[ i ], sw )
          endif
       endif
    endif
    wynik += se + wy
 endif
next

szablon_wzoru := if( raz, NIL, szablon_wzoru )

if sep == ',' .and. Left( wynik, 1 ) == sep; wynik := SubStr( wynik, 2 ); endif

return wynik

******************************************************************************
* Transformuj & Gwiazdki
* x - liczba
* s - szablon

function TSG( x, s )

local pie := .t., wy, i := 0

while i < 10                              && ale g¢ra 10 razy
      wy := Transform( x, s )
      if !( '*' $ wy ); exit; endif
      if !( '9' $ s ); exit; endif
      s := StrTran( s, '9', '99',, 1 )    && potem zwi‘kszaj ilož "9" o 1
      s := StrTran( s, ',', '',, 1 )      && usuwaj†c przecinki
      i ++
enddo

return wy

*******************************************************************************
*        wy := Gwiazdki({ |a,b| Zera_won( Transform( a, b ))}, tab[ i ], sw )

function Gwiazdki( blok, a, b )

local pie := .t., wy, i := 0

while i < 10                              && ale g¢ra 10 razy
      wy := Eval( blok, a, b )
      if !( '*' $ wy ); exit; endif
      if !( '9' $ b ); exit; endif
      b := StrTran( b, '9', '99',, 1 )    && potem zwi‘kszaj ilož "9" o 1
      b := StrTran( b, ',', '',, 1 )      && usuwaj†c przecinki
      i ++
enddo

return wy

*******************************************************************************
* 2 pierwsze przez zmienn† !!!
*   dlugi - ’a¤cuch ci‘ty
*   kawalek - na wynik ci‘cia
*   od - od znaku lub NIL - od pocz†tku
*   do - do znaku lub NIL - do ko¤ca
*   dx - korekta ci‘cia

procedure Utnij( dlugi, kawalek, od, do, dx )

dx := if( dx = NIL, 0, dx )

private n1 := if( od = NIL,   1, At( od, dlugi ) - dx )
private n2 := if( do = NIL, NIL, At( do, dlugi ) + dx )

if n2 # NIL
   n2 := if( n2 < 1, NIL, n2 )
endif

if n2 = NIL
   kawalek := SubStr( dlugi, n1 )
   dlugi := ''
else
   kawalek := SubStr( dlugi, n1, n2 - n1 + 1 )
   dlugi := SubStr( dlugi, n2 + 1 )
endif

*******************************************************************************

procedure Ew_Print( w, h, dalej )

if w = NIL .or. w
   if dalej = NIL .or. !dalej
      ?  h
   else
      ?? h
   endif
endif

*******************************************************************************

procedure ZerujTab( tab )
local i
for i := 1 to Len( tab ); tab[ i ] := 0; next

*******************************************************************************

procedure IncTab( tab, dane, warunek, tab_add )

local i, j, k
private buf

if warunek = NIL; warunek := .f.; endif

if tab_add # NIL

    j := Len( tab_add )
    k := Len( tab )

for i := 1 to j
    if warunek; tab[ k - i + 1 ] := tab_add[ j - i + 1 ]
    else;       tab[ k - i + 1 ] += tab_add[ j - i + 1 ]
    endif
next

else

for i := 1 to Len( dane )
    buf := dane[ i ]
    if warunek; tab[ i ] := &buf
    else;       tab[ i ] += &buf
    endif
next

endif

*******************************************************************************
* Wydruk nag’¢wka wydruku

function Gora( dane, zapam, kzy, kna, psta )

static bw, bs
local i, x, bb, sb, tekst := '', pie := .t.

if zapam # NIL         && zapami‘tanie
   bw := bufor_wzoru
   bs := szablon_wzoru
else
   bb := bufor_wzoru
   sb := szablon_wzoru
   bufor_wzoru := bw     && odtworzenie
   szablon_wzoru := bs   && odtworzenie
endif
                                         && druk bazy
for i := 1 to Len( dane )
    if dane[ i ] == 'firma'
       if kzy # NIL .or. kna # NIL
          x := EOL + Konwert( ReadWzor( cat_main + '\' + 'max.txt', 11 ), kzy, kna )
       else
          x := EOL + ReadWzor( cat_main + '\' + 'max.txt', 11 )
       endif
    else
       if kzy # NIL .or. kna # NIL
          x := Naglowek_wydruku() + Konwert( Linia_wydruku({ &( dane[ i ])}), kzy, kna )
       else
          x := Naglowek_wydruku() + Linia_wydruku({ &( dane[ i ])})
       endif
    endif
    if psta # NIL .and. i < psta; x := ''; endif
    tekst += x
    if ( KryteriaS = 1 ) .and. ( 'FIRMA' $ Upper( dane[ i ])) .and. pie
       pie := .f.
       tekst += EOL + EOL + Konwert( 'Kryteria uwzgl‘dniania danych:', kzy, kna )
       tekst += EOL + Konwert( Kryteriau, kzy, kna ) + EOL
    endif
next

if zapam = NIL
   bufor_wzoru := bb      && powr¢t do aktualnego
   szablon_wzoru := sb    && powr¢t do aktualnego
endif

return tekst

*******************************************************************************
* form # NIL - wydruk rekordu danych w formie formularza
* pole - pole bazy
* pole2- pole subbazy
* kzy - konwersja zy
* kna - konwersja na
* pro1,2,3 - procedura init, operation, done
* 14. bz - bez zer, czyli dodaje automatem '@Z ' do maski
* 15. bt - bez tytu’u i nag’¢wka poza pierwsz† stron†
* 16. plko - plik ko¤cz†cy wydruk
* 17. psta - pole startowe w wydruku w formie paska wyp’aty
* 18. drnr = Druk_Nr przy dwóch egzemplarzach

procedure WydrukM( wzor, baza, subbaza, pole, ind, form, tyt, pole2, kzy, kna, pro1, pro2, pro3, bz, bt, plko, psta )

Wydruk( wzor, baza, subbaza, pole, ind, form, tyt, pole2, kzy, kna, pro1, pro2, pro3, bz, bt, plko, psta, 0 )
Wydruk( wzor, baza, subbaza, pole, ind, form, tyt, pole2, kzy, kna, pro1, pro2, pro3, bz, bt, plko, psta, 1 )

*******************************************************************************

procedure Wydruk( wzor, baza, subbaza, pole, ind, form, tyt, pole2, kzy, kna, pro1, pro2, pro3, bz, bt, plko, psta, drnr )

local dane_bazy, dane_subbazy, sumy, dane_ko, line, i, typ_wyd, pods, ekran, ind_makr
local ile_linii, dane_ss, dane_pp, gora, buf_o, sza_o, se, skok, ko_tab, bazbaza

if konwertON .or. File( cat_wzorow + 'zy_maz.txt' ); kzy := if( szy = NIL, maz, szy ); endif
if konwertON .or. File( cat_wzorow + 'na_lat.txt' ); kna := if( sna = NIL, lat, sna ); endif

if drnr # NIL
	Druk_Nr := drnr
endif

dane_subbazy := {}
dane_bazy := {}
dane_ko := {}
dane_ss := {}
dane_pp := {}
sumy := {}
skok := .f.
strony := PadR( strony, 80 )

private buf, bufs, buff, strona, lp, koniec := .f., poledaty, war_prze, war_pop
private war, rr, r0, r1, r2, drukstr, inds_makr

private buc1 := Space( 100 )         && bufor 'Character'
private bun1 := 0                    && bufor 'Numeric'

if baza = NIL; baza := Alias(); endif
if wzor = NIL; wzor := baza + '.wyd'; endif

rr := ( baza )->( RecNo())

if !FFile( cat_wzorow + wzor )
   if Alarm( 'Brak pliku konfiguracyjnego wydruku !!! ( ' + wzor + ' )',;
           { 'Wyjž', 'Utworzy' }) = 2
      Opis( cat_wzorow + wzor, '' )
   else; return .f.
   endif
endif

private szablon_wzoru := NIL
private bufor_wzoru := ReadWzor( wzor )

if Empty( bufor_wzoru ); return; endif

KryteriaAsk()

if kzy # NIL .or. kna # NIL
   bufor_wzoru := Konwert( bufor_wzoru, kzy, kna )
endif

line := Naglowek_wydruku() + Linia_wydruku({''})

if ( typ_wyd := if( IsDigit( line ), Val( Odetnij( @line, '|' )), 0 )) > 0

   ile_linii := Val( Odetnij( @line, '|' ))           && ilož linii strony
   se := Odetnij( @line, '|' )                    && separator kolumn
   if se == ''; se := "|"; endif              && brak nawet spacji oznacza "|"
   poledaty := Odetnij( @line, '|' )       && pole zakres¢w dat
   war_prze := Odetnij( @line, '|' )    && warunek przeskoku stron
   war := Odetnij( @line, '|' )      && warunek uwzgl‘dniania rekord¢w
   if ( Len( se ) > 1 ) .and. ( Left( se, 1 ) # '&' )
      if !NewSysForm( se ); return; endif
      se := ' '
   else
		if ( Left( se, 1 ) == '&' )
			se := RunCommand( SubStr( se, 2 ))
		endif
      if !Empty( poledaty )
         if poledaty == Upper( poledaty )    && du§ymi literami, to 2 daty
            if !NewSysForm( 'ZAKR_DA,' + if( tyt = NIL, 'Podaj zakres dat', tyt )); return; endif
         else                                && a jak nie, to 4 daty
            if !NewSysForm( 'ZAKR_DAT,' + if( tyt = NIL, 'Podaj zakres dat', tyt )); return; endif
         endif
      else
         strony := ''
      endif
   endif

   if poledaty == Upper( poledaty )    && du§ymi literami, to r¢wne zakresy
      memvar->data3 := memvar->data1
      memvar->data4 := memvar->data2
   endif

   if Empty( poledaty ); poledaty := 'memvar->data2'; endif

else
   strony := ''
endif

if form = NIL .or. form # 0
	if ( drnr = NIL ) .or. ( drnr = 0 )
	   Czek( 1 )
	endif
endif

while !Empty( line )                   && baza
      i := Odetnij( @line, '|' )
		i := StrTran( i, EOL, '' )
*      if Left( i, 2 ) == EOL; i := SubStr( i, 3 ); endif
      Aadd( dane_bazy, i )
enddo

line := Naglowek_wydruku() + Linia_wydruku({''})     && subbaza
while !Empty( line )
      i := Odetnij( @line, '|' )
		i := StrTran( i, EOL, '' )
*      if Left( i, 2 ) == EOL; i := SubStr( i, 3 ); endif
      Aadd( dane_subbazy, i )
enddo

line := Naglowek_wydruku() + Linia_wydruku({''})  && sumy narastaj†ce
while !Empty( line )
      i := Odetnij( @line, '|' )
		i := StrTran( i, EOL, '' )
*      if Left( i, 2 ) == EOL; i := SubStr( i, 3 ); endif
      Aadd( sumy, i )
enddo

do case
   case typ_wyd = 0    && normalny
   case typ_wyd > 0    && z žr¢dsumami i stronami
        line := Naglowek_wydruku() + Linia_wydruku({''})  && suma strony
        while !Empty( line )
              i := Odetnij( @line, '|' )
				i := StrTran( i, EOL, '' )
*              if Left( i, 2 ) == EOL; i := SubStr( i, 3 ); endif
              Aadd( dane_ss, i )
        enddo
        line := Naglowek_wydruku() + Linia_wydruku({''})  && pop strona
        while !Empty( line )
              i := Odetnij( @line, '|' )
				i := StrTran( i, EOL, '' )
*              if Left( i, 2 ) == EOL; i := SubStr( i, 3 ); endif
              Aadd( dane_pp, i )
        enddo
endcase

line := Naglowek_wydruku() + Linia_wydruku({''})

if ( ko_tab := IsDigit( line ))   && koniec tabularyczny
   line := SubStr( line, 2 )      && pomi¤ znacznik
endif

while !Empty( line )              && dane ko¤cz†ce
      i := Odetnij( @line, '|' )
      if Left( i, 2 ) == EOL; i := SubStr( i, 3 ); endif
      Aadd( dane_ko, i )
enddo

private tab := AClone( dane_subbazy )
private tab_sum := AClone( sumy )
private tab_aa := AClone( dane_ss )
private tab_ss := AClone( dane_ss )
private tab_pp := AClone( dane_pp )
private tab_pb := AClone( dane_pp )

ZerujTab( @tab_sum )
ZerujTab( @tab_aa )
ZerujTab( @tab_ss )
ZerujTab( @tab_pp )
ZerujTab( @tab_pb )

( baza )->( Gora( dane_bazy, 1 )) && drukuj g¢r‘ wydruku z zapami‘taniem szablonu

do case
   case form # NIL
   case subbaza = NIL
        ON( baza )
        if ind # NIL; DBSetOrder( ind ); endif
        DBGoTop()
otherwise
   ON( subbaza, ind )
   buf := pole
   bufs:= if( pole2 = NIL, pole, pole2 )
   DBSeek(( baza )->( &buf ))
endcase

memvar->lp := 0
memvar->lps := 0
memvar->lpa := 0
strona := 1
Linia_wydruku({''})        && ze§ryj szablon ( na wszelki wypadek )
buf_o := bufor_wzoru       && oryginalny bufor
sza_o := szablon_wzoru     && oryginalny szablon

if form = NIL .or. form # 0
	if ( drnr = NIL ) .or. ( drnr = 0 )
	   mOpen( cat_wydr + wzor )
	endif
endif

pods := .f.
bazbaza := Alias()
Przerwa( LastRec(), 1 )
while if( subbaza # NIL .and. form = NIL, ( baza )->( &buf ) = &bufs, .t. ) .and.;
      if( typ_wyd > 0, ( &poledaty ) <= memvar->data2, .t. ) .and.;
      if( typ_wyd > 0, ( &poledaty ) <= memvar->data4, .t. ) .and. ( baza )->( !Eof())

      if Przerwa(,1); ?;? '... przerwanie klawiszem Esc ...'; ?; exit; endif

      if typ_wyd > 0          && zakres przetwarzania danych
         if ( !Empty( war ) .and. !( &war )) .or.;
            (( &poledaty ) < memvar->data1 ) .or.;
            !KryteriaOK()
            skip
            war_pop := &( war_prze )
            loop
         endif
      endif

      memvar->lp ++
      memvar->lps ++

      IncTab( @tab, dane_subbazy, .t. )   && dane linii

if typ_wyd = 2

   memvar->lpa := 0
   war_pop := &( war_prze )

while if( subbaza # NIL .and. form = NIL, ( baza )->( &buf ) = &bufs, .t. ) .and.;
      if( typ_wyd > 0, ( &poledaty ) <= memvar->data2, .t. ) .and.;
      if( typ_wyd > 0, ( &poledaty ) <= memvar->data4, .t. ) .and.;
        ( war_pop = &( war_prze )) .and. !Eof()

      if typ_wyd > 0          && zakres przetwarzania danych
         if !Empty( war ) .and. !( &war ) .or.;
            ( &poledaty ) < memvar->data1 .or.;
            !KryteriaOK()
            skip
            loop
         endif
      endif

      if form = NIL; IncTab( @tab_sum, sumy ); endif     && total

      IncTab( @tab_ss, dane_ss, memvar->lpa = 0 .and. memvar->lps = 1 ) && strona
      IncTab( @tab_pp, dane_pp, memvar->lpa = 0 .and. memvar->lp = 1 )  && popstr
      IncTab( @tab_aa, dane_ss, memvar->lpa = 0 )                       && razem

      memvar->lpa ++

      skok := .t.

      DBSkip()

enddo

      IncTab( @tab,, .t., @tab_aa )   && dane linii uzupe’nione o "tab_aa"

else

      if form = NIL; IncTab( @tab_sum, sumy, memvar->lp = 1 ); endif

      if typ_wyd > 0
         IncTab( @tab_ss, dane_ss, memvar->lps = 1 )
         IncTab( @tab_pp, dane_pp, memvar->lp = 1 )
         if ( &poledaty ) < memvar->data3
            tab_pb := AClone( tab_pp )    && przesuni‘cie o 1 stron‘
            memvar->lps --
            skip
            loop
         endif
      endif

endif

if typ_wyd = 1
      IncTab( @tab_aa, dane_ss )   && sumowanie drukowanych danych (np. mies.)
endif

if drukstr := DrukStr( strona, strony )

   if psta # NIL;
      .or. (;
      memvar->lps = 1;                 && zawsze przed pierwsz† pozycj†
      .and.;
      if( bt = NIL, .t., strona = 1 )) && lub tylko na pierwszej stronie
      ?? ( baza )->( Gora( dane_bazy,, kzy, kna, psta )) && drukuj g¢r‘ wydruku
   endif

   if Len( tab ) > 0

      if inds_makr # NIL            && obliczenia tu§ przed wydrukiem linii
         ind_makr := inds_makr
         while !Empty( ind_makr )
               i := Val( Odetnij( @ind_makr ))
               tab[ i ] := &( dane_subbazy[ i ])
         enddo
      endif

      if kzy # NIL .or. kna # NIL
         ? Konwert( Linia_wydruku( tab, se, bz ), kzy, kna )
      else
         ? Linia_wydruku( tab, se, bz )
      endif
   endif

endif

      pods := .f.                      && nie podsumowana linia

      if form # NIL; exit; endif

      if typ_wyd > 0
         if war_pop = NIL              && za pierwszym razem
            war_pop := &( war_prze )   && zainicjuj wartož przeskoku
         endif
      endif

      if !skok
            DBSkip()
            skok := .f.
      endif

      while !Empty( war ) .and. !( &war ) .and. !Eof()
            war_pop := &( war_prze )   && zainicjuj wartož przeskoku
            DBSkip()
      enddo

      if typ_wyd > 0

         koniec := !( if( subbaza # NIL .and. form = NIL, ( baza )->( &buf ) = &bufs, .t. ) .and.;
                      if( typ_wyd > 0, ( &poledaty ) <= memvar->data2, .t. ) .and.;
                      if( typ_wyd > 0, ( &poledaty ) <= memvar->data4, .t. ) .and. !Eof())

       if koniec .or. memvar->lps = ile_linii .or. if( typ_wyd # 2, ( war_pop # &( war_prze )), .f. )
          pods := .t.
          war_pop := &( war_prze )
if drukstr
          ?  Naglowek_wydruku() + Linia_wydruku({''})           && krecha
          ?? Naglowek_wydruku() + Linia_wydruku( tab_ss, se, bz )
          ?? Naglowek_wydruku() + Linia_wydruku( tab_pb, se, bz )
          if bt = NIL
             ?? Naglowek_wydruku() + Linia_wydruku( tab_sum, se, bz )
          else
             Ew_Print( koniec, Naglowek_wydruku() + Linia_wydruku( tab_sum, se, bz ), .t. )
          endif
endif
          Select( baza )
if drukstr
          for i := 1 to Len( dane_ko )
              if kzy # NIL .or. kna # NIL
                 Ew_Print( bt = NIL .or. ( bt # NIL .and. koniec ), Naglowek_wydruku() + Konwert( Linia_wydruku({ &( dane_ko[ i ])}), kzy, kna ), .t. )
              else
                 Ew_Print( bt = NIL .or. ( bt # NIL .and. koniec ), Naglowek_wydruku() + Linia_wydruku({ &( dane_ko[ i ])}), .t. )
              endif
          next
endif
          memvar->lps := 0
          strona ++
          ZerujTab( @tab_ss )
          tab_pb := AClone( tab_pp )    && przesuni‘cie o 1 stron‘
          bufor_wzoru := buf_o
          szablon_wzoru := sza_o
       endif
      endif
      if KoniecStr( strona, strony ); exit; endif
      Select( bazbaza )
enddo
Przerwa( 0, 1 )

Select( baza )

if memvar->lp = 0
   ?? ( baza )->( Gora( dane_bazy,, kzy, kna, psta )) && drukuj g¢r‘ wydruku
endif

if typ_wyd = 0
   if Len( sumy ) > 0
      ? Naglowek_wydruku() + Linia_wydruku( tab_sum )
   endif
   if ko_tab
      for i := 1 to Len( dane_ko ); dane_ko[ i ] := &( dane_ko[ i ]); next
          if kzy # NIL .or. kna # NIL
             ?? Naglowek_wydruku() + Konwert( Linia_wydruku( dane_ko ), kzy, kna ) && druk ko¤ca
          else
             ?? Naglowek_wydruku() + Linia_wydruku( dane_ko ) && druk ko¤ca
          endif
   else
      for i := 1 to Len( dane_ko )        && druk ko¤ca
          if kzy # NIL .or. kna # NIL
             ?? Naglowek_wydruku() + Konwert( Linia_wydruku({ &( dane_ko[ i ])}), kzy, kna ) && druk ko¤ca
          else
             ?? Naglowek_wydruku() + Linia_wydruku({ &( dane_ko[ i ])}) && druk ko¤ca
          endif
      next
   endif
elseif !pods                && nie by’o podsumowa¤
    koniec := .t.
          ?  Naglowek_wydruku() + Linia_wydruku({''})           && krecha
          ?? Naglowek_wydruku() + Linia_wydruku( tab_ss, se )
          ?? Naglowek_wydruku() + Linia_wydruku( tab_pb, se )
          ?? Naglowek_wydruku() + Linia_wydruku( tab_sum, se )

          Select( baza )
          for i := 1 to Len( dane_ko )
              if kzy # NIL .or. kna # NIL
                 ?? Naglowek_wydruku() + Konwert( Linia_wydruku({ &( dane_ko[ i ])}), kzy, kna ) && druk ko¤ca
              else
                 ?? Naglowek_wydruku() + Linia_wydruku({ &( dane_ko[ i ])}) && druk ko¤ca
              endif
          next
endif

if plko # NIL
   ?? MemoRead( cat_wzorow + plko )
endif

DBGo( rr )

if form = NIL .or. form # 0
	if ( drnr = NIL ) .or. ( drnr = 1 )
	   mClose()
   	Czek( 0 )
	   ekran := SaveScreen()
   	@ mr, 0 clear to mr, mc
	   Druk( cat_wydr + wzor, 1 )    && druk natychmiastowy
   	ekran := RestScreen( ,,,, ekran )
	endif
else
   Print( EJE, 1 )               && eject
endif

*******************************************************************************
* form # NIL - wydruk rekordu danych w formie formularza
* pole - pole bazy
* pole2- pole subbazy
* kzy - konwersja zy
* kna - konwersja na

procedure WydrukSub( wzor, baza, subbaza, pole, ind, form, tyt, pole2, kzy, kna )

local dane_bazy, dane_subbazy, sumy, dane_ko, line, i, typ_wyd, pods
local ile_linii, dane_ss, dane_pp, gora, buf_o, sza_o, se, skok, ko_tab

if File( cat_wzorow + 'zy_maz.txt' ); kzy := if( szy = NIL, maz, szy ); endif
if File( cat_wzorow + 'na_lat.txt' ); kna := if( sna = NIL, lat, sna ); endif

dane_subbazy := {}
dane_bazy := {}
dane_ko := {}
dane_ss := {}
dane_pp := {}
sumy := {}
skok := .f.
strony := PadR( strony, 80 )

private buf, bufs, buff, strona, lp, koniec := .f., poledaty, war_prze, war_pop
private war, rr, r0, r1, r2, drukstr

if baza = NIL; baza := Alias(); endif
if wzor = NIL; wzor := baza + '.wyd'; endif

rr := ( baza )->( RecNo())

if !File( cat_wzorow + wzor )
   return .f.
endif

private szablon_wzoru := NIL
private bufor_wzoru := ReadWzor( wzor )

if Empty( bufor_wzoru ); return; endif

if kzy # NIL .or. kna # NIL
   bufor_wzoru := Konwert( bufor_wzoru, kzy, kna )
endif

line := Naglowek_wydruku() + Linia_wydruku({''})

if ( typ_wyd := if( IsDigit( line ), Val( Odetnij( @line, '|' )), 0 )) > 0

   ile_linii := Val( Odetnij( @line, '|' ))           && ilož linii strony
   se := Odetnij( @line, '|' )                    && separator kolumn
   if se == ''; se := "|"; endif          && brak nawet spacji oznacza "|"
   poledaty := Odetnij( @line, '|' )       && pole zakres¢w dat
   war_prze := Odetnij( @line, '|' )    && warunek przeskoku stron
   war := Odetnij( @line, '|' )    && warunek uwzgl‘dniania rekord¢w

else
   strony := ''
endif

while !Empty( line )                   && baza
      i := Odetnij( @line, '|' )
      if Left( i, 2 ) == EOL; i := SubStr( i, 3 ); endif
      Aadd( dane_bazy, i )
enddo

line := Naglowek_wydruku() + Linia_wydruku({''})
while !Empty( line ); Aadd( dane_subbazy, Odetnij( @line, '|' )); enddo && subbaza

line := Naglowek_wydruku() + Linia_wydruku({''})  && sumy narastaj†ce
while !Empty( line )
      i := Odetnij( @line, '|' )
      if Left( i, 2 ) == EOL; i := SubStr( i, 3 ); endif
      Aadd( sumy, i )
enddo

do case
   case typ_wyd = 0    && normalny
   case typ_wyd > 0    && z žr¢dsumami i stronami
        line := Naglowek_wydruku() + Linia_wydruku({''})  && suma strony
        while !Empty( line ); Aadd( dane_ss, Odetnij( @line, '|' )); enddo
        line := Naglowek_wydruku() + Linia_wydruku({''})  && pop strona
        while !Empty( line ); Aadd( dane_pp, Odetnij( @line, '|' )); enddo
endcase

line := Naglowek_wydruku() + Linia_wydruku({''})

if ( ko_tab := IsDigit( line ))   && koniec tabularyczny
   line := SubStr( line, 2 )      && pomi¤ znacznik
endif

while !Empty( line )              && dane ko¤cz†ce
      i := Odetnij( @line, '|' )
      if Left( i, 2 ) == EOL; i := SubStr( i, 3 ); endif
      Aadd( dane_ko, i )
enddo

private tab := AClone( dane_subbazy )
private tab_sum := AClone( sumy )
private tab_aa := AClone( dane_ss )
private tab_ss := AClone( dane_ss )
private tab_pp := AClone( dane_pp )
private tab_pb := AClone( dane_pp )

ZerujTab( @tab_sum )
ZerujTab( @tab_aa )
ZerujTab( @tab_ss )
ZerujTab( @tab_pp )
ZerujTab( @tab_pb )

( baza )->( Gora( dane_bazy, 1 )) && drukuj g¢r‘ wydruku z zapami‘taniem szablonu

do case
   case form # NIL
   case subbaza = NIL
        ON( baza )
        if ind # NIL; DBSetOrder( ind ); endif
        DBGoTop()
otherwise
   ON( subbaza, ind )
   buf := pole
   bufs:= if( pole2 = NIL, pole, pole2 )
   DBSeek(( baza )->( &buf ))
endcase

lp := 0
lps := 0
lpa := 0
strona := 1
Linia_wydruku({''})        && ze§ryj szablon ( na wszelki wypadek )
buf_o := bufor_wzoru       && oryginalny bufor
sza_o := szablon_wzoru     && oryginalny szablon

pods := .f.
Przerwa( LastRec(), 1 )
while if( subbaza # NIL .and. form = NIL, ( baza )->( &buf ) = &bufs, .t. ) .and.;
      if( typ_wyd > 0, ( &poledaty ) <= memvar->data2, .t. ) .and.;
      if( typ_wyd > 0, ( &poledaty ) <= memvar->data4, .t. ) .and. ( baza )->( !Eof())

      if Przerwa(,1); ?;? '... przerwanie klawiszem Esc ...'; ?; exit; endif

      if typ_wyd > 0          && zakres przetwarzania danych
         if !Empty( war ) .and. !( &war ) .or.;
            ( &poledaty ) < memvar->data1
            skip
            war_pop := &( war_prze )
            loop
         endif
      endif

      lp ++
      lps ++

      IncTab( @tab, dane_subbazy, .t. )   && dane linii

if typ_wyd = 2

   lpa := 0
   war_pop := &( war_prze )

while if( subbaza # NIL .and. form = NIL, ( baza )->( &buf ) = &bufs, .t. ) .and.;
      if( typ_wyd > 0, ( &poledaty ) <= memvar->data2, .t. ) .and.;
      if( typ_wyd > 0, ( &poledaty ) <= memvar->data4, .t. ) .and.;
        ( war_pop = &( war_prze )) .and. !Eof()

      if typ_wyd > 0          && zakres przetwarzania danych
         if !Empty( war ) .and. !( &war ) .or.;
            ( &poledaty ) < memvar->data1
            skip
            loop
         endif
      endif

      if form = NIL; IncTab( @tab_sum, sumy ); endif    && total narastaj†co

      IncTab( @tab_ss, dane_ss, lpa = 0 .and. lps = 1 ) && strona narastaj†co
      IncTab( @tab_pp, dane_pp, lpa = 0 .and. lp = 1 )  && pop.str.narastaj†co
      IncTab( @tab_aa, dane_ss, lpa = 0 )               && razem narastaj†co

      lpa ++

      skok := .t.

      DBSkip()

enddo

      IncTab( @tab,, .t., @tab_aa )   && dane linii uzupe’nione o "tab_aa"

else

      if form = NIL; IncTab( @tab_sum, sumy, lp = 1 ); endif

      if typ_wyd > 0
         IncTab( @tab_ss, dane_ss, lps = 1 )
         IncTab( @tab_pp, dane_pp, lp = 1 )
         if ( &poledaty ) < memvar->data3
            tab_pb := AClone( tab_pp )    && przesuni‘cie o 1 stron‘
            lps --
            skip
            loop
         endif
      endif

endif

if drukstr := DrukStr( strona, strony )

   if lps = 1                             && zawsze przed pierwsz† pozycj†
      ?? ( baza )->( Gora( dane_bazy,, kzy, kna ))   && drukuj g¢r‘ wydruku
   endif

   if Len( tab ) > 0
      if kzy # NIL .or. kna # NIL
         ? Konwert( Linia_wydruku( tab, se ), kzy, kna )
      else
         ? Linia_wydruku( tab, se )
      endif
   endif

endif

      pods := .f.                      && nie podsumowana linia

      if form # NIL; exit; endif

      if typ_wyd > 0
         if war_pop = NIL              && za pierwszym razem
            war_pop := &( war_prze )   && zainicjuj wartož przeskoku
         endif
      endif

      if !skok
            DBSkip()
            skok := .f.
      endif

      while !Empty( war ) .and. !( &war ) .and. !Eof()
            war_pop := &( war_prze )   && zainicjuj wartož przeskoku
            DBSkip()
      enddo

      if typ_wyd > 0

         koniec := !( if( subbaza # NIL .and. form = NIL, ( baza )->( &buf ) = &bufs, .t. ) .and.;
                      if( typ_wyd > 0, ( &poledaty ) <= memvar->data2, .t. ) .and.;
                      if( typ_wyd > 0, ( &poledaty ) <= memvar->data4, .t. ) .and. !Eof())

       if koniec .or. lps = ile_linii .or. if( typ_wyd # 2, ( war_pop # &( war_prze )), .f. )
          pods := .t.
          war_pop := &( war_prze )
if drukstr
          ?  Naglowek_wydruku() + Linia_wydruku({''})           && krecha
          ?? Naglowek_wydruku() + Linia_wydruku( tab_ss, se )
          ?? Naglowek_wydruku() + Linia_wydruku( tab_pb, se )
          ?? Naglowek_wydruku() + Linia_wydruku( tab_sum, se )
endif
          Select( baza )
if drukstr
          for i := 1 to Len( dane_ko )
              if kzy # NIL .or. kna # NIL
                 ?? Naglowek_wydruku() + Konwert( Linia_wydruku({ &( dane_ko[ i ])}), kzy, kna ) && druk ko¤ca
              else
                 ?? Naglowek_wydruku() + Linia_wydruku({ &( dane_ko[ i ])}) && druk ko¤ca
              endif
          next
endif
          lps := 0
          strona ++
          ZerujTab( @tab_ss )
          tab_pb := AClone( tab_pp )    && przesuni‘cie o 1 stron‘
          bufor_wzoru := buf_o
          szablon_wzoru := sza_o
       endif
      endif
      if KoniecStr( strona, strony ); exit; endif
enddo
Przerwa( 0, 1 )

Select( baza )

if typ_wyd = 0
   if Len( sumy ) > 0
      ? Naglowek_wydruku() + Linia_wydruku( tab_sum )
   endif
   if ko_tab
      for i := 1 to Len( dane_ko ); dane_ko[ i ] := &( dane_ko[ i ]); next
          if kzy # NIL .or. kna # NIL
             ?? Naglowek_wydruku() + Konwert( Linia_wydruku( dane_ko ), kzy, kna ) && druk ko¤ca
          else
             ?? Naglowek_wydruku() + Linia_wydruku( dane_ko ) && druk ko¤ca
          endif
   else
      for i := 1 to Len( dane_ko )        && druk ko¤ca
          if kzy # NIL .or. kna # NIL
             ?? Naglowek_wydruku() + Konwert( Linia_wydruku({ &( dane_ko[ i ])}), kzy, kna ) && druk ko¤ca
          else
             ?? Naglowek_wydruku() + Linia_wydruku({ &( dane_ko[ i ])}) && druk ko¤ca
          endif
      next
   endif
elseif !pods                && nie by’o podsumowa¤
    koniec := .t.
          ?  Naglowek_wydruku() + Linia_wydruku({''})           && krecha
          ?? Naglowek_wydruku() + Linia_wydruku( tab_ss, se )
          ?? Naglowek_wydruku() + Linia_wydruku( tab_pb, se )
          ?? Naglowek_wydruku() + Linia_wydruku( tab_sum, se )

          Select( baza )
          for i := 1 to Len( dane_ko )
              if kzy # NIL .or. kna # NIL
                 ?? Naglowek_wydruku() + Konwert( Linia_wydruku({ &( dane_ko[ i ])}), kzy, kna ) && druk ko¤ca
              else
                 ?? Naglowek_wydruku() + Linia_wydruku({ &( dane_ko[ i ])}) && druk ko¤ca
              endif
          next
endif

DBGo( rr )

*******************************************************************************
* czy strona nale§y do podanej listy stron

function DrukStr( s, st )

local wy, a, b, c

st := AllTrim( st )

if Empty( st ); return .t.; endif

wy := .f.
while !Empty( c := Odetnij( @st ))
      if '-' $ c
         a := SubStr( c, 1, ( wy := At( '-', c )) - 1 )
         b := SubStr( c, wy + 1 )
         a := if( Empty( a ), 1, Val( a ))
         b := if( Empty( b ), 9999999, Val( b ))
         if a <= s .and. s <= b; wy := .t.; exit
         else; wy := .f.
         endif
      else
         if s = Val( c ); wy := .t.; exit; endif
      endif
enddo

return wy

*******************************************************************************
* Czy ju§ jest strona spoza zakresu drukowania i trzeba ko¤czy ???

function KoniecStr( s, st )

local a, b, c, d

st := AllTrim( st )

if Empty( st ); return .f.; endif

d := 0
while !Empty( c := Odetnij( @st ))
      if '-' $ c
         a := SubStr( c, 1, ( wy := At( '-', c )) - 1 )
         b := SubStr( c, wy + 1 )
         a := if( Empty( a ), 1, Val( a ))
         b := if( Empty( b ), 9999999, Val( b ))
         d := Max( d, b )
      else
         d := Max( d, Val( c ))
      endif
enddo

return s > d     && strona jest dalsza ni§ maksymalny g¢rny zakres

*******************************************************************************
* InccTab('tabs',KWOTA) po uprzednim "Aadd( tabs, 0 )"
function InccTab( zmienna, wartosc )
&zmienna += wartosc
return wartosc
*******************************************************************************

procedure Ustaw( zmienna, wartosc, mode )

if mode = NIL
   &zmienna := wartosc
else
   private buf
   zmienna := {}
   while !Empty( wartosc )
         buf := Odetnij( @wartosc, '|' )
         if Left( buf, 2 ) == EOL; buf := SubStr( buf, 3 ); endif
         if mode = 1
            if Left( buf, 1 ) == '&'              && np.: &ACaad(...
               RunCommand( SubStr( buf, 2 ),, 1 ) && bez zmiany "%"->","
            else
               Aadd( zmienna, buf )
            endif
         else
            if EOL $ buf; buf := StrTran( buf, EOL, '' ); endif
            RunCommand( buf )
         endif
   enddo
endif

*******************************************************************************
* subdruk - teraz leci fragment wi‘kszej ca’ožci rozpocz‘tej wczežniej
* wydruk - žcie§ka i plik wynikowy
* bp = NIL => jeden dokument
* bp (L)   => seria dokumentów (nie pyta tylko drukuje z przerobieniem)
* preludium-> funkcja wykonywana przed ca³¹ reszt¹ po otwarciu pliku do druku

procedure Drukuj( wzor, subdruk, wydruk, bp, preludium )

local ttab, linia, i, znak, ok

private proc_2poziom, baza_2poziom, procc2poziom, bz
private proc_3poziom, baza_3poziom, procc3poziom, drukuj_3poziom
private drukuj_while, drukuj_for, lp, tab, tabs, druk_on := .t.

if wzor = NIL; wzor := Alias(); endif

if bp = NIL
	bp := 1
elseif bp
	bp := NIL
else
	bp := 1
endif

private szablon_wzoru := NIL
private bufor_wzoru := ReadWzor( wzor + if( '.' $ wzor, '', '.wyd' ))
if Empty( bufor_wzoru ); return; endif

tabs := {}
if wydruk = NIL
   wydruk := cat_wydr + wzor + '.txt'
endif
if subdruk = NIL
   KryteriaAsk()
   Czek( 1 )
   mOpen( wydruk )
	if preludium # NIL
		RunCommand( preludium )
		? EOL
	endif
   ?? RunCommand( WydInit,,, 1 )
endif
while !Empty( bufor_wzoru )
      znak := NIL
      drukuj_for := NIL
      drukuj_while := NIL
      drukuj_3poziom := NIL
      baza_3poziom := NIL
      baza_2poziom := NIL
      proc_3poziom := NIL
      proc_2poziom := NIL
      procc3poziom := NIL
      procc2poziom := NIL
      linia := Naglowek_wydruku() + Linia_wydruku({''})
      znak := Left( linia, 1 )
      do case
         case znak == "+"
              linia := SubStr( linia, 2 )
              Ustaw( @tab, @linia, 1 )                      && ustawienia
              ttab := {}
              for i := 1 to Len( tab )
                  Aadd( ttab, RunCommand( tab[ i ]))
              next
              if druk_on
                 ?? Konwert( Naglowek_wydruku() + Linia_wydruku( ttab,, bz ))
              endif
         case znak == "#" .or. znak == "@"
              linia := SubStr( linia, 2 )
              Ustaw( @tab, @linia, 2 )                      && ustawienia
              if drukuj_3poziom # NIL
                 linia := Naglowek_wydruku() + Linia_wydruku({''})
                 Ustaw( @tab, @linia, 1 )                      && zmienne
                 MemVar->lp := 0
                 Linia_wydruku({''})                           && wypsztykanie
                 while RunCommand( drukuj_3poziom ) .and. !Eof()
                    RunCommand( procc2poziomu )
*                    if MemVar->lp > 1
                       if druk_on
                          ?
                       endif
*                    endif
                    Jest_baza( baza_3poziom )
                    while RunCommand( drukuj_while ) .and. !Eof()
                          ok := .f.
                          if drukuj_for = NIL .or. RunCommand( drukuj_for )
                             MemVar->lp++
                             ttab := {}
                             for i := 1 to Len( tab )
                                 Aadd( ttab, RunCommand( tab[ i ]))
                             next
                             ok := .t.
                          endif
                          RunCommand( procc3poziomu )
                          if ok
                             if druk_on
                                ?? Konwert( Linia_wydruku( ttab,, bz ))
                             endif
                          endif
                          RunCommand( proc_3poziomu )
                          skip
                    enddo
                    Jest_baza( baza_2poziom )
                    RunCommand( proc_2poziomu )
                    skip
                 enddo
              else
              if drukuj_while # NIL
                 linia := Naglowek_wydruku() + Linia_wydruku({''})
                 Ustaw( @tab, @linia, 1 )                      && zmienne
                 MemVar->lp := 0
                 Linia_wydruku({''})                           && wypsztykanie
                 while RunCommand( drukuj_while ) .and. !Eof()
                       if drukuj_for = NIL .or. RunCommand( drukuj_for )
                          if !KryteriaOK()
                             skip
                             loop
                          endif
                          MemVar->lp++
                          ttab := {}
                          for i := 1 to Len( tab )
                              Aadd( ttab, RunCommand( tab[ i ]))
                          next
                          if druk_on
                             if znak == "@"
                                if MemVar->lp > 1; ?; endif
                                ?? Konwert( Linia_wydruku( ttab, ',', bz ))
                             else
                                ? Konwert( Linia_wydruku( ttab,, bz ))
                             endif
                          endif
                       endif
                       skip
                 enddo
              endif
              endif
         otherwise
              Ustaw( @tab, @linia, 1 )                      && zmienne
              for i := 1 to Len( tab )
                  if druk_on
                     ?? Konwert( Naglowek_wydruku() + Linia_wydruku({ RunCommand( tab[ i ])},, bz ))
                  endif
              next
      endcase
enddo

if subdruk = NIL
   mClose()
   Czek( 0 )
   DRUK_Nr := 0
   if ( NIL # Druk( wydruk, bp )) && pierwszy wydruk poszed’
      DRUK_Nr ++
      while PROP_KOPIA .and. ( NIL # Druk( wydruk, bp )); enddo
   endif
endif

*******************************************************************************
* k - klucz wyzwalacza
* m - maska
* t - tabela formu³ po œrednikach
* s - iloœæ spacji wiod¹cych przed kresk¹ podsumy
* p - przed lini¹ zamiast znaków '-'(mo¿e byæ EOL lub coœ innego)
* ko - koniec linii domyœlnie = EOL
* ze - zerowanie MemVar->lp

procedure PodSuma( k, m, t, s, p, ko, ze )

static maska, tab, kp, x

local wy := NIL, i

if s = NIL; s := 0; endif

if m # NIL
	m := StrTran( m, ';', '|' )
	m := StrTran( m, '.(', '<' )
	m := StrTran( m, ').', '>' )
	maska := m
	tab := {}
	kp := k
	x := 0
endif

if t # NIL
	if kp # k
		kp := k
		if druk_on .and. ( x > 1 )
			private szablon_wzoru := NIL
			private bufor_wzoru := maska
			wy := Konwert( Naglowek_wydruku() + Linia_wydruku( tab ))
			if p = NIL
				wy := Space( s ) + PadR( '',Len( wy ) - 1 - s, '-' ) + EOL + wy
			else
				wy := p + wy
			endif
			if ko = NIL
				wy += EOL
			else
				wy += ko
			endif
			if ze # NIL
				MemVar->LP := 1
			endif
		endif
		for i := 1 to Len( tab ); tab[ i ] := 0; next
		x := 0
	endif
	i := 0
	while !Empty( t )
		i ++
		while i > Len( tab ); Aadd( tab, 0 ); enddo
		tab[ i ] := tab[ i ] + RunCommand( Odetnij( @t, ';' ))
	enddo
	x ++
endif

return if( wy = NIL, '', wy )

*******************************************************************************
* k - klucz wyzwalacza
* m - maska
* t - tabela formu³ po œrednikach
* s - iloœæ spacji wiod¹cych przed kresk¹ podsumy

procedure PodSuma1( k, m, t, s, p )

static maska, tab, kp, x

local wy := NIL, i

if s = NIL; s := 0; endif

if m # NIL
	m := StrTran( m, ';', '|' )
	m := StrTran( m, '.(', '<' )
	m := StrTran( m, ').', '>' )
	maska := m
	tab := {}
	kp := k
	x := 0
endif

if t # NIL
	if kp # k
		kp := k
		if druk_on .and. ( x > 1 )
			private szablon_wzoru := NIL
			private bufor_wzoru := maska
			wy := Konwert( Naglowek_wydruku() + Linia_wydruku( tab ))
if p = NIL
			wy := Space( s ) + PadR( '',Len( wy ) - 1 - s, '-' ) + EOL + wy + EOL
else
			wy := p + wy + EOL
endif
		endif
		for i := 1 to Len( tab ); tab[ i ] := 0; next
		x := 0
	endif
	i := 0
	while !Empty( t )
		i ++
		while i > Len( tab ); Aadd( tab, 0 ); enddo
		tab[ i ] := tab[ i ] + RunCommand( Odetnij( @t, ';' ))
	enddo
	x ++
endif

return wy

*******************************************************************************
* k - klucz wyzwalacza
* m - maska
* t - tabela formu³ po œrednikach
* s - iloœæ spacji wiod¹cych przed kresk¹ podsumy

procedure PodSuma2( k, m, t, s, p )

static maska, tab, kp, x

local wy := NIL, i

if s = NIL; s := 0; endif

if m # NIL
	m := StrTran( m, ';', '|' )
	m := StrTran( m, '.(', '<' )
	m := StrTran( m, ').', '>' )
	maska := m
	tab := {}
	kp := k
	x := 0
endif

if t # NIL
	if kp # k
		kp := k
		if druk_on .and. ( x > 1 )
			private szablon_wzoru := NIL
			private bufor_wzoru := maska
			wy := Konwert( Naglowek_wydruku() + Linia_wydruku( tab ))
if p = NIL
			wy := Space( s ) + PadR( '',Len( wy ) - 1 - s, '-' ) + EOL + wy + EOL
else
			wy := p + wy + EOL
endif
		endif
		for i := 1 to Len( tab ); tab[ i ] := 0; next
		x := 0
	endif
	i := 0
	while !Empty( t )
		i ++
		while i > Len( tab ); Aadd( tab, 0 ); enddo
		tab[ i ] := tab[ i ] + RunCommand( Odetnij( @t, ';' ))
	enddo
	x ++
endif

return wy

*******************************************************************************
