#include 'directry.ch'
#include 'inkey.ch'

*******************************************************************************
****************************  System baz danych  ******************************
*******************************************************************************
* F1 i "Z" przy przelewach
* MakeZnaki('REJ_ZAZ','vp[27]',63,'vp[29]','vp[30]',;
* 'AllTrim(NUMER)+"="+AllS(K9-K26,"999,999,999.99")+", "','K9-K26')
* ba - baza znakÛw
* p1 - pole wynikowe dla sumy narastajπco operacji ope2
* lp2 - d≥ugoúÊ pola wynikowego
* p2 - pole wynikowe dla ciπgu opisujπcego (faktura=wartoúÊ;)
* p3 - pole wynikowe dla ciπgu opisujπcego (faktura=wartoúÊ;)
* ope1 - operacja generujπca napis
* ope2 - operacja generujπca kwotÍ dla narastajπco

function MakeZnaki( ba, p1, lp2, p2, p3, ope1, ope2 )

local w, ww, s, bb := Alias(), r := 0

globalbuf1 := ''		&& init napis (faktury analitycznie)
globalbuf2 := 0		&& init kwota narastajπco dla pola p1

Select( ba )
DBSetOrder( 0 )
go top
while !Eof()
		Select( bb )
		DBGoTo( r := (( ba )->( FieldGet( 1 ))))
		w := RunCommand( ope2 )             && "do zaplaty" za biezacy dokument
		ww := w
		if ( &p1 > 0 ) .and. ( globalbuf2 + w > &p1 )		&& przekroczono kwotÍ inicjujπcπ
			w := &p1 - globalbuf2   && o ile za malo za wybrane dokumenty ?
			s := AllTrim( RunCommand( StrTran( ope1, ope2, AllS( w ))))
			Alarm( 'NaleønoúÊ za dokument wynosi ' + AllS( ww, '999,999,999.99' ) + ',;ale wp≥ata za dokument bÍdzie niøsza, tj.;dokument Nr ' + s,, 1 )
         globalbuf2+= w
			globalbuf1+= s
		else
         globalbuf2+= w
			globalbuf1+= RunCommand( ope1 )
		endif
		Select( ba )
      skip
enddo

Select( bb )

if ( &p1 > 0 ) .and. ( Abs( globalbuf2 - &p1 ) > 0.009 )		&& cos zostalo
		DBGoTo( r )                         && czyli jest nadplata
		w := &p1 - globalbuf2   && o ile za duzo za wybrane dokumenty ?
		s := AllTrim( RunCommand( StrTran( ope1, ope2, AllS( w ))))
		Alarm( 'Nadplata za dokument o ' + AllS( w, '999,999,999.99' ) + ',;dodatkowa wp≥ata za dokument, tj.;dokument Nr ' + s,, 1 )
    globalbuf2+= w
  	globalbuf1+= s
endif

if globalbuf2 # 0
   &p1 := globalbuf2    && zapisz ile narastajaco za wybrane faktury wyszlo
endif

if !Empty( globalbuf1 )
   globalbuf1 := SlownieZlGr(,lp2,, globalbuf1 )	&& podzia≥ napisu na spacji do pola p2
   &p2 := PadR( globalbuf1, lp2 )
	if p3 # NIL .and. !Empty( p3 )
	   &p3 := PadR( SubStr( globalbuf1, lp2 + 1 ), lp2 )	&& reszta do pola p3
	endif
endif

*******************************************************************************
* Nr 36. Kasowanie indeks¢w
* mode = NIL - reindeksacja, a potem pakowanie
* mode # NIL - tylko pakowanie

procedure Odswiez( aa, mode )

local tylko_pa, odp_re, odp_pa, ekran, pliki, i, n, h, a, h1, h2
local b1, b2, r1, r2

private p1

h1 := 'Odtworzyç indeksy BAZY DANYCH (reindeksowaç) ?'
h2 := 'Czy fizycznie usunÜç skasowane;rekordy z BAZ DANYCH (pakowaç ) ?'

tylko_pa := ( mode # NIL )

if !tylko_pa
   odp_re := ( Alarm( h1, nt ) = 2 )
   if !odp_re; return; endif
   odp_pa := ( Alarm( h2, nt ) = 2 )
else
   odp_pa := ( Alarm( h2, nt ) = 2 )
   if !odp_pa; return; endif
endif

ekran := SaveScreen()

if .t.
   b1 := 'T_OSOBY'; if Jest_baza( b1 ); r1 := RecNo(); endif
   b2 := 'STANOWIS'; if Jest_baza( b2 ); r2 := RecNo(); endif
endif

Pozamykaj( 1 )  && wszystko

if !tylko_pa
   Czek( 1 )
   a := aa
   if a # NIL .and. !Empty( a )
      n := 4
      while !Empty( a )
            p1 := Odetnij( @a ) + '*.ntx'
            @ Min( mr, n++ ), 0 say ''; ? p1
            run del &p1
      enddo
   else
      RunCommand( 'run del *.ntx', 1 )
      RunCommand( 'run del ' + cat_system + '*.ntx', 1 )
      RunCommand( 'run del ROBOCZY\*.ntx', 1 )
*     RunCommand( 'run del ROBOCZY\*.db?', 1 )
      if siec .and. sieciowo .and. osobne # NIL
         RunCommand( 'run del ' + osobne + '\*.ntx', 1 )
*        RunCommand( 'run del ' + osobne + '\*.db?', 1 )
      endif
   endif
   Czek( 0 )
endif

if odp_pa

RestScreen( ,,,, ekran )

Czek( 1 )
@ 5, 0 say ''

a := aa
if a # NIL .and. !Empty( a )
   n := 4
   while !Empty( a )
         p1 := Odetnij( @a ) + '*.dbf'
         pliki := Directory( p1 )
         for i := 1 to Len( pliki )
             p1 := pliki[ i, F_NAME ]
             @ Min( mr, n++ ), 0 say ''; ? p1
             if Upper( Right( p1, 4 )) == '.DBF'
                p1 := Left( p1, Len( p1 ) - 4 )
             endif
             if !tylko_pa        && brak indeks¢w
                use ( p1 ) new exclusive
                if !NetErr()
                   pack
                   use
                endif
             else                && indeksy chyba sÜ, bo nie byío reindeksacji
                Czek( 0 )
                ON( p1 )         && sprawdzenie, czy sÜ indeksy
                Czek( 1 )
                ON( p1,,,,, .t. )&& pakowanie
                Zwolnij( p1 )
             endif
         next
   enddo
else
     pliki := Directory( '*.dbf' )
     for i := 1 to Len( pliki )
         p1 := pliki[ i, F_NAME ]
         if '~' $ p1
            ? p1
         else
            use ( p1 ) new exclusive
            if !NetErr()
               pack
               use
            endif
         endif
     next
     pliki := Directory( cat_system + '*.dbf' )
     for i := 1 to Len( pliki )
         p1 := cat_system + pliki[ i, F_NAME ]
         if '~' $ p1
            ? p1
         else
            use ( p1 ) new exclusive
            if !NetErr()
               pack
               use
            endif
         endif
     next
endif

Czek( 0 )

endif

a := aa
if !tylko_pa .and.;              && brak indeks¢w
   ( a # NIL .and. !Empty( a ))  && wyliczone bazy danych

   RestScreen( ,,,, ekran )

   Czek( 1 )
   @ 5, 0 say ''

   n := 4
   while !Empty( a )
         p1 := Odetnij( @a ) + '*.dbf'
         pliki := Directory( p1 )
         for i := 1 to Len( pliki )
             p1 := pliki[ i, F_NAME ]
             @ Min( mr, n++ ), 0 say ''; ? p1
             if Upper( Right( p1, 4 )) == '.DBF'
                p1 := Left( p1, Len( p1 ) - 4 )
             endif
   Czek( 0 )
             ON( p1 )         && reindeksacja po pakowaniu bez indeks¢w
   Czek( 1 )
             Zwolnij( p1 )
         next
   enddo
   Czek( 0 )
else
   ON( SysForm ); use
   ON( SysBaz ); use
   ON( SysMenu )
endif

if .t.
   if r1 # NIL; ON( b1 ); DBGoTo( r1 ); endif
   if r2 # NIL; ON( b2 ); DBGoTo( r2 ); endif
endif

Alarm( 'Operacja zako§czona' )
RestScreen( ,,,, ekran )

***************************************************************************
* poziom2 = drugi poziom zagíëbienia SUB'a
* initf    - funkcja inicjujÜca tabelë

procedure SubBase( a, NoClose, PressKey, NrFunDod, poziom2, initf, donef )

local xx := rr[ 1 ] + 2, yy := rr[ 2 ] + 1, ekran := SaveScreen()
local x, bb := Alias()

if Pusta(); return; endif

( bb )->( Blokuj_R())

x := 1

if Right( AllTrim( a ), 1 ) == ','
   x++
   xx++
endif

if poziom2 = NIL
   poziom2 := 0
elseif poziom2 # 0
   xx := xx - poziom2
   Scroll( 3, 0, rr[ 1 ] + x, mc, poziom2 ) && przewiniëcie nagí¢wk¢w
endif

if r > xx
   Scroll( xx , 0 , r , mc , r - xx )           && przewiniëcie faktury
endif
Scroll( xx + 1 , 0 , yy , mc , yy - xx - 1 )    && linii ko§czÜcej

ViewDBF( a, NoClose, PressKey, NrFunDod, initf, donef )
RestScreen( ,,,, ekran )
Lastzero()
( bb )->( OdBlokuj_R())

******************************************************************************
* parametry :         przykíady :
*  1. baza             1. SAMOCHODY
*  2. wz¢r             2. SAMOCHODY - nieobowiÜzkowe ( domyûlnie j.w. )
*  3. katalog          3. ROBOCZY   - nieobowiÜzkowe ( domyûlnie bießÜcy )
*  4. indeks           4. 2         - nieobowiÜzkowe ( domyûlnie 1 )
*  5. seek klucz       5. KONW->NUMER - musi byç razem z ( 3. )
*  6. while klucz      6. KONW->NUMER == NUMER - musi ( j.w. )
*  7. baza partner     7. ASOR_WYB
*  8. relacja z partnerem
*  9. indeks2          9. 2         - nieobowiÜzkowe ( domyûlnie 1 )
* 10. seek klucz2     10. KONW->NUMER - musi byç razem z ( 3. )
* 11. while klucz2    11. KONW->NUMER == NUMER - musi ( j.w. )
* 12. must No Close   12. !Empty() => 1
* 13. DBE_Filtr
* 14. Warunek FOR dla odsiania wyniku WHILE z parametru 6.
*
* NoClose  - nie zamykaç po ußyciu ?
* PressKey - ciÜg znak¢w do zaíadowania do bufora klawiatury
* nrdop    - numer funkcji systemu odpowiedzialny za dopisywanie
* initf    - funkcja inicjujÜca tabelë
* donef    - funkcja ko§czÜca tabelë
* noRest   - nie r¢b RestScreen

procedure ViewDBF( parametry, NoClose, PressKey, nrdop, initf, donef, noRest )

local ekran, bb, ree, ii, katalog
local indeks, seek_klucz, while_klucz, for_klucz
local indek2, seek_kluc2, while_k2
local baza_oryg, baza_partner, oryg_TI := TAK_INVERS

private rela_partner, rerere

if NoClose = NIL; NoClose := .f.; endif    && domyûlnie "zamykaj"

private ll, lll, rr, cc, kolumny, naglowki, szablon, validy := {}
private blok, bl_il_poz, bl_napis, bl_pozycja, zmiana := .f.

parametry := if( '(baza)' $ parametry, StrTran( parametry, '(baza)', baza ), parametry )

private baza     := Odetnij( @parametry )
private DBE_wzor := Odetnij( @parametry )

katalog     := Odetnij( @parametry )

*if Left( katalog, 1 ) == Upper( Left( katalog, 1 ))   && gdy duße litery
   katalog := Zamiennik( katalog )                    && patrz w zamienniki
*endif

indeks      := Odetnij( @parametry )
seek_klucz  := StrTran( Odetnij( @parametry ), ';', ',' )
while_klucz := StrTran( Odetnij( @parametry ), ';', ',' )
baza_partner:= Odetnij( @parametry )
rela_partner:= Odetnij( @parametry )
indek2      := Odetnij( @parametry )
seek_kluc2  := Odetnij( @parametry )
while_k2    := Odetnij( @parametry )
if !Empty( Odetnij( @parametry )); NoClose := .t.; endif

baza_oryg   := baza   && potem baza moße sië zmieniç, np. na 'ROB'

private DBE_ADD
if nrdop # NIL
   if ValType( nrdop ) == "C"
      DBE_ADD := nrdop
   else
      DBE_ADD := SysFunction[ nrdop ]
   endif
endif
private DBE_Tyt := ''
private Kryteria := ''
private Kryteriau:= ''
private KryteriaS:= 0
private DBE_Function := {}
private DBE_Tab_Fun := {}
private DBE_Filtr := Odetnij( @parametry )

for_klucz := Odetnij( @parametry )
if Empty( for_klucz )
	for_klucz := NIL
else
	for_klucz := StrTran( for_klucz, '!', ',' )
endif

bb := Alias()
ree := RecNo()
ii := IndexOrd()

if !Empty( baza_partner )
   baza_partner := Zamiennik( baza_partner )
   ON( baza_partner )
endif

ekran := SaveScreen()

Setup_DBEdit( DBE_wzor, katalog, indeks, seek_klucz, while_klucz, indek2, seek_kluc2, while_k2, for_klucz, PressKey )
if initf # NIL; RunCommand( initf ); endif

if '?' $ baza_oryg
   baza := StrTran( baza_oryg, '?', '_' )
endif

if '?' $ baza_partner
   baza_partner := StrTran( baza_partner, '?', '_' )
endif

Select( baza )

if !Empty( rela_partner )
   set relation to &rela_partner into ( baza_partner )
endif

DbEdit( rr[1], cc[1], rr[2], cc[2], kolumny, 'Obsluga', szablon, naglowki, Chr( 196 ) + Chr( 194 ) + Chr( 196 ))

if ( 'BUF' $ Upper( katalog ) .or. 'ROB' $ Upper( katalog )) .and.;
   !Empty( katalog ) .and. zmiana
          &&.and. ( Alarm( 'NastÜpiía zmiana w danych !!!',;
          &&             { 'Aktualizowaç', 'Zignorowaç zmiany' }) = 1 )
   SkasujRec( Matka( baza_oryg ), indeks, seek_klucz, while_klucz )
   KopiaRec( baza, Matka( baza_oryg ),, .t. )
   Zwolnij( baza )
   baza := baza_oryg
endif

if NoClose .or.;
   baza = bb .or.;
   baza = SysMenu
else
   Zwolnij( baza )
endif

if noRest = NIL
   RestScreen( ,,,, ekran )
endif

TAK_INVERS := oryg_TI
Select( bb )
if donef # NIL
   RunCommand( donef )
   if rerere # NIL; ree := rerere; endif
endif
DBSetOrder( ii )
DBGo( ree )

******************************************************************************

function Init_SysBazy

public SysBaz := 'sys_baz'

*******************************************************************************

procedure SysBaz_Struktura

local naz := PadR( SysBaz, 7, '_' )

Aadd( pola, { 'DBF_NAME', 'C',  8, 0 })   && Nazwa bazy danych
Aadd( pola, { 'DBF_LP',   'N',  2, 0 })   && Liczba porzÜdkowa
Aadd( pola, { 'DBF_FIELD','C', 10, 0 })   && Nazwa pola rekordu bazy danych
Aadd( pola, { 'DBF_TYPE', 'C',  1, 0 })   && Typ pola
Aadd( pola, { 'DBF_LEN',  'N',  3, 0 })   && Iloûç znak¢w pola
Aadd( pola, { 'DBF_DEC',  'N',  1, 0 })   && Iloûç miejsc po przecinku
Aadd( pola, { 'DBF_OPIS', 'C', 99, 0 })   && Opis pola

Aadd( klucze , 'Upper(DBF_NAME)+STR(DBF_LP)' )
Aadd( klucze , 'Upper(DBF_FIELD)' )

Aadd( indeksy , naz + '1' )
Aadd( indeksy , naz + '2' )

*******************************************************************************

function SysBaz_UB( indeks, cat, ali )

UruchomBaze( SysBaz, { || SysBaz_Struktura()}, @indeks, @cat, @ali )

*******************************************************************************
* PrzeglÜdanie danych

procedure SysBaz_P( parametry )

private blok, bl_il_poz, bl_napis
private DBE_wzor := Odetnij( @parametry )
private DBE_Filter := ''
private DBE_ADD
private DBE_Tyt := ''
private DBE_Function := {}
private DBE_Tab_Fun := {;
        { |a| SysBazKasuj( a )},;
        { |a,b,c,d,e| MySeek( a, { b, c }, { d, e })},;
        { |a,b,c,d| Indeks({ a, b }, { c, d })},;
        { || won := .t. },;
        { |a, b, c| SysBazForm( a, b, .f. )},;
        { |a, b, c| DBE_Dopisz( 5, a, b, c, { || SysBazFillForm()})},;
        { |a| SysBaz_W( a )},;
        { || AutoBazFill( SysBaz + ',0,1,2,3,4', .t. )},;
        { || RenBaz()},;
        { || WywalSysBaz()},;
        { |a| KopiaBazy( a )}}

Przeglad({ || baza := SysBaz, Setup_DBEdit( DBE_wzor )})

******************************************************************************

procedure SysBazKasuj( a )

if Kasuj( a )
   DBSkip( 1 )
   SysBazRozsun( -1, 1 )
endif

******************************************************************************

procedure SysBazFillForm

if !full_dostep; return; endif

SysBazRozsun()
( SysBaz )->( Blokuj_R())
( SysBaz )->DBF_LP ++
( SysBaz )->DBF_OPIS := ''

******************************************************************************
* delta - skok przenumerowania
* wlacznie

procedure SysBazRozsun( delta, wlacznie )

local rr, kk := DBF_NAME, ll := DBF_LP, nr

if delta = NIL; delta := 1; endif

rr := RecNo()   && pozycja na kt¢rej stoisz

DBSetOrder( 1 )
DBSeek( Upper( kk ) + '99', .t. )
DBSkip( -1 )
while kk == DBF_NAME .and. !Bof()
      DBSkip(-1 ); nr := RecNo()
      DBSkip( 1 )
      if rr # RecNo()
         if DBF_LP < 90
            ( SysBaz )->( Blokuj_R())
            ( SysBaz )->DBF_LP += delta
            ( SysBaz )->( OdBlokuj_R())
         endif
      else
         if wlacznie # NIL
            if DBF_LP < 90
               ( SysBaz )->( Blokuj_R())
               ( SysBaz )->DBF_LP += delta
               ( SysBaz )->( OdBlokuj_R())
            endif
         endif
         exit
      endif
      DBGoTo( nr )
enddo

wy := 2
DBGo( rr )

******************************************************************************

procedure WywalSysBaz

local dbn := DBF_NAME

if Alarm( 'UsunÜç definicjë bazy ' + AllTrim( dbn ) + ' ?', nt ) = 2
   go top
   while !Eof()
         if DBF_NAME == dbn; BDelete(); endif
         skip
   enddo
   wy := 2
endif

******************************************************************************

procedure RenBaz

local bb := DBF_NAME, lp := DBF_LP, rr := RecNo(), i := 0

while DBF_NAME == bb .and. DBF_LP < 90 .and. !Eof()
      i++
      skip
enddo
skip -1
while DBF_NAME == bb .and. RecNo() # rr .and. !Bof()
      i --
      ( SysBaz )->( Blokuj_R())
      ( SysBaz )->DBF_LP := lp + i
      skip -1
enddo
wy := 2

******************************************************************************
* a - ía§cuch zawierajÜcy parametry oddzielone przecinkami

function Odetnij( a, se )

local b, c, x

if se = NIL; se := ','; endif    && separator domyûlny
x := Len( se )

if ( c := At( se,  a )) = 0      && pusty lub 1 parametr bez odgraniczenia
   b := RTrim( a )
   a := ''
   return b
else
   b := Left( a, c - 1 )
   a := SubStr( a, c + x )
   return b
endif

******************************************************************************
* Pobierz "pole" i wstaw do aktualnej zmiennej

procedure GetPut( a, pole )

private b := ReadVar()
private bb := Odetnij( a )   && bez wiewi¢ry nie zabiera !!!
private bbb := pole

ViewDBF( a, .t. )

if LastKey() # K_ESC
   &b := ( bb )->( &bbb )
   Keyboard Chr( K_DOWN )
endif

******************************************************************************
* Kasuje grupë rekord¢w

procedure SkasujRec( baza, indeks, seek_klucz, while_klucz )

local bb := Alias()

private seek_k := seek_klucz
private while_k := while_klucz

if !Jest_baza( baza ); ON( baza ); endif
DBSetOrder( Val( indeks ))
seek_k := &seek_k
DBSeek( seek_k )
while &while_k .and. !Eof()
      BDelete()
      skip
enddo

Select( bb )

******************************************************************************
* Kopia serii rekord¢w z "sour" do "dest" zgodnie z podanym warunkiem
* 1. sour = "REJ_ZA, REJ_ZS, REJ_KZA, REJ_KZS"
* 8. n - iloûç p¢l do skopiowania
* 9. ca - katalogi do odwiedzenia poza bieøπcym
*10. re - rejestr otwierany dodatkowo w dodatkowych podkatalogach

procedure KopiaSerii( sour, dest, windex, wseek, warwhile, warfor, blok, n, ca, re )

local a, bb := Alias(), c := '', psour := sour

if ca = NIL; ca := ''; endif
if re = NIL; re := 'REJ_SP'; endif

while .t.

while !Empty( a := Odetnij( @sour ))
		if !Empty( c ); Zwolnij( a ); endif
      ON( c + a, windex )
      DBSeek( &wseek )
      KopiaRec( a, dest, warwhile,, warfor, blok, n )
		if !Empty( c ); Zwolnij( a ); endif
enddo

c := Odetnij( @ca )
if Empty( c ); exit; endif
sour := re + ',' + psour		&& dodatkowy rejestr, ktÛry dotπd by≥ bieøπcym
c := c + '\'

enddo

Select( bb )

******************************************************************************
* Kopia grupy rekord¢w z "sour" do "dest" zgodnie z podanym warunkiem

procedure KopiaRec( sour, dest, warwhile, na_top, warfor, blok, n )

local rr := 1

if sour = NIL; sour := Alias(); endif

Select( sour )

if na_top # NIL .and. na_top
   go top
endif

Przerwa( LastRec(),,1)
if warwhile = NIL
   while !Eof()
         KopiujRec( sour, dest,, warfor, n )
         if blok # NIL
            if Eval( blok ); exit; endif
         endif
         skip
         Przerwa(,,1)         && bez Esc
   enddo
elseif ValType( warwhile ) == 'B'
   while Eval( warwhile ) .and. !Eof()
         KopiujRec( sour, dest,, warfor, n )
         if ValType( blok ) == 'B'
            if Eval( blok ); exit; endif
         else
            if RunCommand( blok ); exit; endif
         endif
         skip
         Przerwa(,,1)         && bez Esc
   enddo
else
   private wwhile := if( warwhile = NIL, '.t.', warwhile )
   while &wwhile .and. !Eof()
			rr := ( sour )->( RecNo())
         KopiujRec( sour, dest,, warfor, n )
         if blok # NIL
            if ValType( blok ) == 'B'
               if Eval( blok ); exit; endif
            else
               if RunCommand( blok ); exit; endif
            endif
         endif
			( sour )->( DBGoTo( rr ))		&& na wypadek gdy sour==dest
         skip
         Przerwa(,,1)         && bez Esc
   enddo
endif
Przerwa( 0,, 1 )

*******************************************************************************
* Kopia pojedynczego rekordu z ewentualnym dopisaniem do basy "dest"
* kop = NIL .or. kop = .t. => kopia z dopisywaniem

procedure KopiujRec( sour, dest, kop, warfor, minfc )

local fc := Min(( sour )->( FCount()), ( dest )->( FCount()))     && iloûç p¢l
local rekord[ fc ], i

if minfc # NIL
   fc := Min( fc, minfc )
endif

if warfor # NIL
   if ValType( warfor ) == 'B'
      if !Eval( warfor ); return; endif
   elseif !Empty( warfor )
      if !( &warfor ); return; endif
   endif
endif

for i := 1 to fc
    rekord[ i ] := ( sour )->( FieldGet( i ))
next

if kop = NIL .or. kop
   ( dest )->( DBAdd())
endif

for i := 1 to fc
    ( dest )->( FieldPut( i, rekord[ i ]))
next

*******************************************************************************

procedure AutoBazFill( a, z_SysBaz )

local nr, baza, dane, rekord, numery, nazwy, nazwa, bazy, i, k, bb, ii, rr, mm

if z_SysBaz = NIL; z_SysBaz := .f.; endif

private destBase := Odetnij( @a ), delta := Val( Odetnij( @a ))

nazwy := {}
numery := {}
while !Empty( a )
      Aadd( numery, Val( Odetnij( @a )))
enddo

bb := Alias()
rr := RecNo()
ii := IndexOrd()
bazy := Directory( '*.dbf' )

AEval( bazy, { |a| Aadd( nazwy, a[ F_NAME ])}); nazwy := ASort( nazwy )
if ( nr := Alarm( 'Wybierz plik bazy danych', nazwy )) = 0; return; endif
baza := nazwy[ nr ]
use ( baza ) alias 'ROB' new
baza := SubStr( baza, 1, Len( baza ) - 4 )
nazwa := Get_U( 10, 10, 'Podaj nazwë :', Replicate( 'X', 10 ), PadR( baza, 10 ))
if nazwa = NIL; return; endif
dane := DBStruct()
use

if !z_SysBaz
   AppendRecord( destBase, { nazwa, 0, '', '', '', 3, 1 })
   AppendRecord( destBase, { nazwa, 1, '', '', '',21,78 })
endif

if destBase == 'sys_form' .and. Alarm( 'Pobraç dane z SysBaz?', tk ) = 1

   i := 1
   nazwa := Upper( PadR( nazwa, 8 ))
   ON( SysBaz )
   DBSeek( nazwa )
   while nazwa == DBF_NAME .and. !Eof()
         AppendRecord( destBase, { nazwa, i + delta, AllTrim(( SysBaz )->DBF_OPIS ) + ':', ( SysBaz )->DBF_FIELD })
         i ++
         skip
   enddo

else

for i := 1 to Len( dane )
    rekord := {}
    Aadd( rekord, nazwa )
    Aadd( rekord, i + delta )
    for k := 1 to Len( numery )
        mm := dane[ i, numery[ k ]]
        if k = 1 .and. !z_SysBaz
           mm := Left( mm, 1 ) + Lower( SubStr( mm, 2 ))
           mm += ' :'
        endif
        Aadd( rekord, mm )
    next
    AppendRecord( destBase, rekord )
next

endif

Select( bb )
DBSetOrder( ii )
wy := 2
DBGo( rr )

******************************************************************************
* baza - destination base
* record - array with data to append
* bez_dod = NIL -> append, #NIL -> don't ( dziaía jak "CopyRecord" )

procedure AppendRecord( baza, record, bez_dod )

local i

if baza = NIL; baza := Alias(); endif

if bez_dod = NIL; ( baza )->( DBAdd())
else            ; ( baza )->( Blokuj_R())
endif

for i := 1 to Len( record )
    if record[ i ] # NIL
       ( baza )->( FieldPut( i, record[ i ]))
    endif
next

******************************************************************************
* Put Num to Record

procedure PN2R( nDelta, sWartosci )

i := nDelta
while !Empty( sWartosci )
      ( baza )->( FieldPut( i, Val( Odetnij( @sWartosci ))))
      i++
enddo

******************************************************************************

procedure SysBaz_W( wzor )

local n := DBF_NAME, re := RecNo(), wa
wa := Alarm( 'Wariant:', { 'Old', 'New', 'All' })
if wa = 1
   wzor := 'sysbaz_w.txt'
   W_DBEdit( wzor,,, { || DBF_NAME == n })
elseif wa = 3
   wzor := 'sysbaz_w.txt'
   W_DBEdit( wzor )
else
   Drukuj()
endif
go re

******************************************************************************

procedure SysBazForm( wzor, tyt, cz )

private TabValid := {}
private TabHelp := { ,, { || ShowIndexes( 3 )},,,, { || ReadIndex( 3, 7 )}}
return Formularz( wzor, tyt, cz )

******************************************************************************
* n - numer pola docelowego dla wyniku procedury

procedure ShowIndexes( n )

local nazwy := {}, pliki, nr

pliki := Directory( '*.ntx' )

AEval( pliki, { |a| Aadd( nazwy, a[ F_NAME ])}); nazwy := ASort( nazwy )
if ( nr := Alarm( 'Wybierz plik indeksu :', nazwy )) = 0; return; endif
private nn := 'pole' + AllTrim( Str( n ))
&nn := Left( nazwy[ nr ], 8 )

******************************************************************************
* n1 - numer pola zawierajÜcego nazwë pliku indeksowego
* n2 - numer pola docelowego dla wyniku procedury

procedure ReadIndex( n1, n2 ) 

local plik, ekran

private nn1 := 'pole' + AllTrim( Str( n1 ))
private nn2 := 'pole' + AllTrim( Str( n2 ))

plik := MemoRead( AllTrim( &nn1 ) + '.ntx' )
if !Empty( plik )
   &nn2 := SubStr( plik, 23, 99 )
endif

******************************************************************************
* procedura sprawdza czy podana baza istnieje w kt¢rymû z obszar¢w roboczych

function Jest_baza( baza )

if Select( baza ) # 0           && jeûli ta baza jest, to sië ustaw na niÜ
   select ( baza )
   return .t.
else
   return .f.
endif

****************************************************************************

procedure Zwolnij( baza, musi )

if Jest_baza( baza )
   set filter to
   if  ( musi # NIL ) .or. !BazaNZ( baza )
       use
   endif
endif

****************************************************************************
* Baza nie zamykana ?

function BazaNZ( baza )

return if( Empty( BazyNieZam ), .f.,;
         (( ',' + Upper( baza ) + ',' ) $ ( ',' + Upper( BazyNieZam ) + ',' )))

****************************************************************************

procedure Pozamykaj( wszystko )

local i, a

Czek( 1 )
for i := 1 to 20
    Select( i )
    a := Alias()
    if   wszystko = NIL .and.;
       ( a == Upper( SysMenu ) .or.;
         a == Upper( SysBaz ) .or.;
         BazaNZ( a ))
       set filter to
    else
       use
    endif
next
if BazyZapDys; DBCommitAll(); endif
Czek( 0 )

****************************************************************************
* Nr 63
* "ILE#0,Iloûç r¢zna od zera'
* mode # NIL - wymuû nadanie nowego filtra mimo ße teraz jest jakiû
* offf # NIL - wymuû zgaszenie filtra

procedure DBEFiltr( a, mode, se, offf )

if offf = NIL .and. ( Empty( DBE_Filtr ) .or. mode # NIL )
   DBE_Filtr := Odetnij( @a, se )
   DBE_Tyt := AllTrim( DBE_Tyt ) + a
   set filter to &DBE_Filtr
else
   DBE_Filtr := Odetnij( @a, se )
   DBE_Filtr := ''
   DBE_Tyt := Left( DBE_Tyt, Len( DBE_Tyt ) - Len( a )) + Space( Len( a ))
   set filter to
endif

DBSkip( -1 )
if !Bof(); DBSkip(); endif
wy := 2

******************************************************************************

function Struktura( baza )

local i := 0, bb := Alias(), k, buf

if ( k := At( '?', baza )) # 0
   baza := StrTran( baza, '?', '_' )
endif

buf := cat_wzorow + baza + '.str'
if FFile( @buf )
   buf := MemoRead( buf )
   Ustaw(, buf, 2 )
else
SysBaz_UB()
if !DBSeek( Upper( baza ))
   Alarm( 'Brak danych o bazie ' + baza + ' !!!', Ent )
endif
while RTrim( Upper( DBF_NAME )) == Upper( baza ) .and. !Eof()
      if DBF_LP < 90
         Aadd( pola, { DBF_FIELD, DBF_TYPE, DBF_LEN, DBF_DEC })
      elseif !Empty( DBF_FIELD )
         i ++
         buf := AllTrim( DBF_FIELD )
         if k # 0
            buf := Left( buf, k - 1 ) + nr_stacji + SubStr( buf, k + 1 )
         endif
         Aadd( indeksy, buf )
         Aadd( klucze, AllTrim( StrTran( DBF_OPIS, Chr( 0 ), '' )))
      endif
      skip
enddo
endif

if k # 0
   baza := Left( baza, k - 1 ) + nr_stacji + SubStr( baza, k + 1 )
endif

if !Empty( bb ); Select( bb ); endif

return .t.

****************************************************************************
* Nr 83. WyíÜcz bießÜcÜ bazë i przejd¶ do "baza"

procedure OFF( a )

use
Select( a )

****************************************************************************
* z # NIL - z indeksami

procedure ONN( a, z )

while !Empty( a )
      if z = NIL
         ON( Odetnij( @a ), -99 )   && bez indeks¢w
      else
         ON( Odetnij( @a ))         && z indeksami
      endif
enddo

****************************************************************************

function WOsobnych( baza, wcreate )
return osobne # NIL;
      .and.;
    ( Upper( Left( baza, 4 )) $ 'ZEST, BILA, BABA' + if( wcreate = NIL, '', ', ANAL' );
      .or.;
      Upper( Left( baza, 5 )) == 'RACHW' )

****************************************************************************

function CatOsobny( cat )

   if cat = NIL
      cat := osobne
   else
      cat := AllTrim( cat )
      if !Empty( cat )
         if Right( cat, 1 ) == '\'
            cat := Left( cat, Len( cat ) - 1 )
         endif
      endif
      cat := cat + '\' + osobne
   endif

return cat

****************************************************************************
* ON Pack/Zap = pakuj, zwolnij, ON

function ONP( baza, indeks, cat, ali, m_zap, m_pack, catt )

ON( baza, indeks, cat, ali, m_zap, m_pack, catt )
Zwolnij( baza )
ON( baza, indeks, cat, ali,,, catt )

****************************************************************************

function ON( baza, indeks, cat, ali, m_zap, m_pack, catt )

if siec .and. sieciowo
   if (( Upper( Left( baza, 6 )) == 'ANALIZ' );
			.or.;
			( Upper( Left( baza, 8 )) == 'TOWARYBU' );
			.or.;
			( Upper( Left( baza, 8 )) == 'TOWARYUB' );
			.or.;
			( Upper( Left( baza, 6 )) == 'LPLACZ' );
			.or.;
			( Upper( Left( baza, 6 )) == 'LPRACZ' ));
		 .and. ( cat # 'BUFOR' )
      cat := 'ROBOCZY'
   endif
   if cat # NIL .and. "ROBOCZY" $ Upper( cat )
      cat := Upper( cat )
      cat := cat_baza + StrTran( cat, 'ROBOCZY', osobne )
   endif
endif

if baza == SysBaz
   return SysBaz_UB( @indeks, @cat, @ali )
elseif WOsobnych( baza )
   cat := CatOsobny( cat )
   return UruchomBaze( @baza, { || Struktura( @baza )}, @indeks, @cat, @ali, @m_zap, @m_pack )
else
   if m_zap # NIL .and. m_zap
      UruchomBaze( @baza, { || Struktura( @baza )}, @indeks, @cat, @ali,, @m_pack, @catt )
   endif
   return UruchomBaze( @baza, { || Struktura( @baza )}, @indeks, @cat, @ali, @m_zap, @m_pack, @catt )
endif

****************************************************************************

procedure Sprawdz35( cat, plik )

local pliki := Directory( cat + plik )

for i := 1 to Len( pliki )
	if pliki[ i, F_SIZE ] = 35
		RunCommand( 'run del ' + cat + pliki[ i, F_NAME ])
	endif
next

****************************************************************************
* Uruchomienie bazy
*   baza - nazwa bazy
*   struktura - blok kodu wypeíniajÜcy 'pola', 'indeksy' i 'klucze'
*   indeks - nr indeksu startowego
*   cat - czy otworzyç bazë z katalogu "cat_arch" ???
*   zapuj - otwarcie bazy dla wykonania "zap"
*   pakuj - otwarcie bazy dla wykonania "pack"
*   pseudo - otwarcie z aliasem "pseudo"
*   catt - katalog inny niß archiwum

function UruchomBaze( baza, struktura, indeks, cat, pseudo, zapuj, pakuj, catt )

local in_place := ( zapuj # NIL .or. pakuj # NIL )   && "use" bez "new"
local odp, x, y, z, h, dt

private pola := {} , indeksy := {}, klucze := {}, i

if zapuj = NIL; zapuj := .f.; endif
if pakuj = NIL; pakuj := .f.; endif
if '\' $ baza
   odp := RAT( '\', baza )
   cat := Left( baza, odp - 1 )
   baza := SubStr( baza, odp + 1 )
endif

if baza = SysBaz .or. ( pseudo = NIL .and. baza = SysForm ) .or. ( baza = SysMenu .and. catt = NIL ); cat := cat_system
elseif cat = NIL .or. Empty( cat ); cat := ''
else
   cat := AllTrim( cat )
   if Right( cat, 1 ) <> '\'
      cat += '\'
   endif
endif

if pseudo = NIL .or. Empty( pseudo )
   pseudo := StrTran( baza, '?', '_' )
endif

if ziarko .and. ( 'BABA' $ baza ) .and. !haker
   if Day( Datee()) > 25
      dt := Datee() - 31
   else
      dt := Datee() - 62
   endif
   while !OkresZamkniety( dt, 1 )
      Alarm( 'Zamknij okres sprawozdawczy ( ' + SubStr( DtoC( dt ), 4 ) + ' ) !!!' )
      ViewDBF( 'ZAOKRESY' )
   enddo
endif

if indeks # NIL
 if indeks < 0 .and. indeks # -99        && wymuszone indeksowanie

   indeks := -indeks
   odp := 1

   Eval( struktura )

   close indexes
   for i := 1 to Len( indeksy )
       RunProgram( 'del,' + indeksy[ i ] + '.ntx' )
   next

 endif
endif

if !Jest_baza( pseudo );               && nie ma bazy o takim pseudo
   .or.;
   ( in_place .and. siec );            && ponowne otwarcie w tym samym miejscu
   .or.;
   ( baza == pseudo .and. odp # NIL )  && otwarcie w podkatalogu

   Eval( struktura )
	Sprawdz35( cat, baza + '.dbf' )
   if !File( cat + baza + '.dbf' )     && brak bazy
      if Katalog( cat )
         Dbcreate( cat + baza, pola )  && utworzenie
      else
         Alarm( 'Niepowodzenie utworzenia "' + cat + baza + '" !!!' )
         OpuscSys(1)
      endif
   endif

if .f.                         && !siec
   if in_place
      USE
      USE ( cat + baza ) ALIAS ( pseudo ) && uruchomienie w pamiëci
   else
      USE ( cat + baza ) ALIAS ( pseudo ) NEW
   endif
else
   probuj := .t.
   while probuj
         if zapuj .or. pakuj .or. !siec
            if in_place
               USE
               USE ( cat + baza ) ALIAS ( pseudo ) EXCLUSIVE
            else
               USE ( cat + baza ) ALIAS ( pseudo ) EXCLUSIVE NEW
            endif
         else
            if in_place
               USE
               USE ( cat + baza ) ALIAS ( pseudo ) SHARED
            else
               USE ( cat + baza ) ALIAS ( pseudo ) SHARED NEW
            endif
         endif
         if !NetErr()
            probuj := .f.
         else
          if ( zapuj .or. pakuj ) .and. Right( AllTrim( baza ),1 ) == "Z"
             zapuj := .f.     && gdy baza zaznacze§ to czasem rezygnuj
             pakuj := .f.     && bo ußytkownicy kolidujÜ, a mogÜ iûç dalej
          else
            h := Alias()
            @ 3, 0 say ''
            for i := 1 to 20
                Select( i )
                ? AllS( i ) + ', ' +  Alias() + Space( 20 )
            next
            Jest_baza( h )

            h := 'Niepowodzenie otwarcia bazy danych;'
            if zapuj .or. pakuj .or. !siec
               if in_place
                  h += 'USE ( ' + cat + baza + ' );ALIAS ( ' + pseudo + ' ) EXCLUSIVE'
               else
                  h += 'USE ( ' + cat + baza + ' );ALIAS ( ' + pseudo + ' ) EXCLUSIVE NEW'
               endif
            else
               if in_place
                  h += 'USE ( ' + cat + baza + ' );ALIAS ( ' + pseudo + ' ) SHARED'
               else
                  h += 'USE ( ' + cat + baza + ' );ALIAS ( ' + pseudo + ' ) SHARED NEW'
               endif
            endif
            if Left( Upper( baza ), 3 ) == 'SYS';
               .or.;
               Left( Upper( baza ), 3 ) == 'STA';
               .or.;
               Left( Upper( baza ), 3 ) == 'T_O'
               h += ';Prawdopodobnie program juß raz jest uruchomiony.;PrzeíÜcz sië na niego myszkÜ lub klawiszami Alt+TAB'
               Alarm( h )
               OpuscSys()
*               if FFile( cat_wzorow + 't_osoby.str' )
*                  Login( 0 )
*               else
*                  OpuscSys()
*               endif
            else
               if Alarm( h, { 'Ponowiç pr¢bë', 'Wyjûç z programu' }) # 1
                  if FFile( cat_wzorow + 't_osoby.str' )
                     Login( 0 )
                  else
                     OpuscSys()
                  endif
               endif
            endif
          endif
         endif
   enddo
   probuj := .t.
   while probuj .and. serwer     && serwer blokuje, inne nie ...
         && zablokowanie bazy dla innych jako "tylko do czytania"
         if Flock() .and. !NetErr()
            probuj := .f.
         else
            odp := Alarm( 'Niepowodzenie zablokowania bazy "' + baza + '" !!!',;
                        { 'Rezygnacja z wyíÜcznoûci', 'Ponowiç pr¢bë zablokowania', 'Wyjûç' })
            do case
            case odp = 1; exit
            case odp = 3; cls; quit
            endcase
         endif
   enddo
endif

Sprawdz_baza( baza, pola, klucze, indeksy, cat )

#IFDEF DEMO
   Demo_end()
#ENDIF

private i

if indeks # -99

   for i := 1 to Len( klucze )
       if ZlyNTX( cat + indeksy[ i ] + '.ntx' )
          Czek( 1 )
          @ 0, 0 clear to 0, mc
          if ( 0 # ( y := At( ';', x := klucze[ i ])))
             @ 0, 0 say 'Tworzenie indeksu "' + cat + indeksy[ i ] + '" : ' + klucze[ i ]
             z := SubStr( x, y + 1 )
             x := Left( x, y - 1 )
             index on &( x ) to ( cat + indeksy[ i ] ) for &( z )
          else
             if jestiexe .and. !( '->' $ x )
                use
                x := 'run i.exe ' + StrTran( cat + baza, ' ', '' ) + ' ' + StrTran( x, ' ', '' ) + ' ' + StrTran( cat + indeksy[ i ], ' ', '' )
                x := StrTran( x, '"', '~' )
                RunCommand( x, 1 )
                @ 0, 0 clear to 0, mc
                if !ZlyNTX( cat + indeksy[ i ] + '.ntx' )
                   Czek( 0 )
                   UruchomBaze( baza, struktura, indeks, cat, pseudo, zapuj, pakuj, catt )
                   return
                else
                   USE ( cat + baza ) ALIAS ( pseudo ) NEW EXCLUSIVE
                   x := klucze[ i ]
                   @ 0, 0 say 'Tworzenie indeksu "' + cat + indeksy[ i ] + '" : ' + x
                   index on &( x ) to ( cat + indeksy[ i ] )
                endif
*                Czek( 1 )
             else
                @ 0, 0 say 'Tworzenie indeksu "' + cat + indeksy[ i ] + '" : ' + klucze[ i ]
                index on &( x ) to ( cat + indeksy[ i ] )
             endif
          endif
          @ 0, 0 clear to 0, mc
          Czek( 0 )
       endif
   next

   Select( pseudo )
   close indexes
	for i := 1 to Len( indeksy )
   	DBSetIndex( cat + indeksy[ i ])   && uruchomienie indeks¢w
	next
*   Aeval( indeksy , { |a| DBSetIndex( cat + a ) } )   && uruchomienie indeks¢w
endif   
endif

if indeks # -99
   DBSetOrder( if( indeks = NIL, 1, indeks ))
endif

if zapuj; zap; endif
if pakuj; pack; endif
go top

return Len( indeksy )

******************************************************************************
* PrzeglÜdanie bazy
*   init, done - bloki kodu

procedure Przeglad( init, done )

local ekran := SaveScreen()

private ll, lll, rr, cc, kolumny, naglowki, szablon, validy := {}, baza

Eval( init )

DbEdit( rr[ 1 ] , cc[ 1 ] , rr[ 2 ] , cc[ 2 ] ,;
        kolumny,;
        'Obsluga' ,;
        szablon ,;
        naglowki, Chr( 196 ) + Chr( 194 ) + Chr( 196 ))

if done # NIL ; Eval( done ) ; endif

RestScreen( ,,,, ekran )

******************************************************************************

procedure Demo_end( must )

   if LastRec() > 100
      Alarm( 'Wersja demonstracyjna pozwala na MAúE BAZY DANYCH !!!',;
           { 'Peína wersja systemu : dzwo§ na numer 88-44-22 w úodzi', Enter })
   endif

   if LastRec() > 120 .or. must # NIL
      cls
      ?
      ?
      ?
      ? '******************************************************************************'
      ?
      ? 'Rozmiar bazy danych przekroczyí wielkoûç krytycznÜ dla wersji demonstracyjnej.'
      ?
      ? 'W sprawie peínej wersji systemu proszë dzwoniç na numer : 87-34-64 w úodzi.'
      ?
      ? '******************************************************************************'
      ?
      ?
      Inkey( 0 )
      quit
   endif

******************************************************************************

procedure Sprawdz_baza( baza, dbw, klucze, indeksy, cat )

local dbs, i, k, jest, s

if !TEST_MUS .and. !TEST_STR; return; endif
if Len( dbw ) = 0; return; endif

dbs := DBStruct()
jest := .f.

for i := 1 to Len( dbs ); dbs[ i, 1 ] := PadR( Upper( dbs[ i, 1 ]), 15 ); next
for i := 1 to Len( dbw ); dbw[ i, 1 ] := PadR( Upper( dbw[ i, 1 ]), 15 ); next

i := 1
k := Max( Len( dbs ), Len( dbw ))
while i <= k
      if i > Len( dbs ) .or.;
         i > Len( dbw ) .or.;
         !( dbs[ i, 1 ] == dbw[ i, 1 ]) .or.;
         dbs[ i, 2 ] # dbw[ i, 2 ] .or.;
         dbs[ i, 3 ] # dbw[ i, 3 ] .or.;
         dbs[ i, 4 ] # dbw[ i, 4 ]
         jest := .t.
         exit
      endif
      i ++
enddo

if !TEST_MUS .and. !jest; return; endif

private plik := 'rap_baz.txt'

Czek( 1 )
mOpen( cat_wydr + plik )
SetPRC( 0 , 0 )

private szablon_wzoru := NIL
private bufor_wzoru := ReadWzor( plik )

i := 1
k := Max( Len( dbs ), Len( dbw ))
?  Naglowek_wydruku() + Linia_wydruku({ baza })
?  Naglowek_wydruku() + Linia_wydruku({''})
while i <= k
      if i > Len( dbs ) .or.;
         i > Len( dbw ) .or.;
         !( dbs[ i, 1 ] == dbw[ i, 1 ]) .or.;
         dbs[ i, 2 ] # dbw[ i, 2 ] .or.;
         dbs[ i, 3 ] # dbw[ i, 3 ] .or.;
         dbs[ i, 4 ] # dbw[ i, 4 ]
         if i <= Len( dbs )
            ? Linia_wydruku( dbs[ i ])
         else
            ?
         endif
         if i <= Len( dbw )
            ?? Space( 48 ) + Linia_wydruku( dbw[ i ] )
         endif
      endif
      i ++
enddo

mClose()
Czek( 0 )

s := SaveScreen()

Edit( MemoRead( cat_wydr + plik),,,0,,,, 1 )

if TEST_MUS .or. ( Alarm( 'Zmiana struktury tabeli "'+ cat + baza +'" ?', tk ) = 1 )

   RestScreen( ,,,, s )

   Czek( 1 )

   s := SaveScreen()
   @ 0, 6 say ''

   use
   private sour := cat + baza + '.db?'

   if File( 'kopia.bat' )
      run kopia.bat &sour
   else
      run echo off                  && zamiast "kopia.bat"
      run if not exist bufor\nul md bufor>nul
      run copy &sour bufor>nul  && kopia oryginaíu do bufora
      run del &sour >nul
   endif

   Dbcreate( cat + baza, pola )    && utworzenie pustej na dysku

   for i := 1 to Len( indeksy )
       sour := cat + AllTrim( indeksy[ i ]) + '.ntx'  && skasowanie indeks¢w
       run del &sour
   next

   use ( cat + baza ) new

   private x, y
   for i := 1 to Len( klucze )
       if ZlyNTX( cat + indeksy[ i ] + '.ntx' )
          j := AllTrim( klucze[ i ])
          @ 0, 0 clear to 0, mc
          if ( 0 # ( y := At( ';', x := klucze[ i ])))
             @ 0, 0 say 'Tworzenie indeksu "' + cat + indeksy[ i ] + '" : ' + j
             z := SubStr( x, y + 1 )
             x := Left( x, y - 1 )
             index on &( x ) to ( cat + indeksy[ i ] ) for &( z )
          else
             if jestiexe .and. !( '->' $ x )
                x := 'run i.exe ' + StrTran( cat + baza, ' ', '' ) + ' ' + StrTran( x, ' ', '' ) + ' ' + StrTran( cat + indeksy[ i ], ' ', '' )
                x := StrTran( x, '"', '~' )
                use
                RunCommand( x, 1 )
                @ 0, 0 clear to 0, mc
                use ( cat + baza ) new
                if !File( StrTran( cat + indeksy[ i ], ' ', '' ) + '.ntx' )
                   @ 0, 0 say 'Tworzenie indeksu "' + cat + indeksy[ i ] + '" : ' + j
                   index on &( x ) to ( cat + indeksy[ i ] )
                endif
             else
                @ 0, 0 say 'Tworzenie indeksu "' + cat + indeksy[ i ] + '" : ' + j
                index on &( x ) to ( cat + indeksy[ i ] )
             endif
          endif
*          index on &j to ( cat + indeksy[ i ])   && indeksowanie bazy
          @ 0, 0 clear to 0, mc
       endif
   next

   close indexes
   Aeval( indeksy , { |a| DBSetIndex( cat + a )})   && uruchomienie indeks¢w

   append from ( 'bufor\' + baza ) all

   RestScreen( ,,,, s )
   Czek( 0 )

   return

endif

******************************************************************************
* Nr 56. Wpisuje podane pole do aktualnego GET'a i wychodzi z DBEdit'a

procedure Set_GET( a )

private bu := ReadVar(), pole := Odetnij( @a )

if !Empty( bu )
   &bu := RunCommand( pole )
   Keyboard Chr( Val( a ))
endif
wy := 0

******************************************************************************
* Sumuje serië "vp"

procedure Sum_vp( a )

local i, wy := 0
private pole

while !Empty( a )
    pole := 'vp['+Odetnij(@a)+']'
    wy += &pole
enddo

return wy

******************************************************************************

* Nr 57. Wpisuje podane pola do podanych GET'¢w i wychodzi z DBEdit'a

procedure Set_GETY( a )

local nr, i, ile

private pole := 'vp'

if Type( pole ) == 'U'; return; endif

if Odetnij( @a ) = 'plik'     && aby tylko nie zamienií na liczbë
      ile := Odetnij( @a )    && ile ma skoczyç w dal
      a := ReadWzor( Odetnij( @a ))
else; ile := Odetnij( @a )    && ile ma skoczyç w dal
endif

i := 0
while !Empty( a )            && pary wpis¢w : pole z "source" i numer GET'a
      pole := StrTran( Odetnij( @a ), ';', ',' )
      pole := StrTran( pole, EOL, '' )
      nr := Val( Odetnij( @a ))
      if nr > 0 .and. nr <= Len( vp )
         i ++
         pole := RunCommand( pole )
         if pole # NIL
            vp[ nr ] := pole
         endif
      endif
enddo

ile := if( Empty( ile ), i, Val( ile ))

if ile > 0
	Keyboard Replicate( Chr( K_DOWN ), ile )
else
	Keyboard Replicate( Chr( K_DOWN ), -ile ) + Chr( K_RIGHT ) + Chr( K_LEFT )
endif

set filter to   && wy≥πcza filtr np. na towary o stanie rÛønym od zera
wy := 0
 
******************************************************************************
* sprawdza czy moße i dopiero pack
* a - hasío, baza, akcja ("Obl...()")

procedure DBPackk( a )

local aa := a, h, b, bb, odp, byla

bb := Alias()
h := Odetnij( @aa )
b := Odetnij( @aa )
r := Odetnij( @aa )

byla := Jest_baza( b )

if byla
   use                        && zamkniëcie w dotychczasowym trybie
   use ( b ) EXCLUSIVE        && pr¢ba otwarcia EXCLUSIVE
else
   use ( b ) EXCLUSIVE new    && pr¢ba otwarcia EXCLUSIVE
endif

odp := !NetErr()              && udana lub nie

if odp                        && da radë exclusive
   Zwolnij( b )               && niech nie bëdzie w trybie exclusive
   ON( b )                    && niech bëdzie w normalnym trybie
   DBPack( a )                && pakuj
endif

Zwolnij( b )                  && niech nie bëdzie w trybie exclusive

if byla
   ON( b )                    && niech zn¢w bëdzie w normalnym trybie
endif

Jest_baza( bb )

******************************************************************************
* a - hasío, baza, akcja ("Obl...()")

procedure DBPack( a )

DBZap( a, 1 )

******************************************************************************
* a - baza1, baza2, ...

procedure DBZapp( a )

while !Empty( a )
      DBZap( ',' + Odetnij( @a ))
enddo

******************************************************************************
* a = pytanie czy ?, baza1, baza2, ...
* mode => if mode = NIL; zap; else; pack; endif

procedure DBZap( a, mode )         && Nr 19

local h, b, bb, odp

if a = NIL; a := ''; endif

odp := .t.
bb := Alias()
h := Odetnij( @a )
b := Odetnij( @a )
r := Odetnij( @a )

if !Empty( h )
   odp := ( Alarm( h, nt ) = 2 )
endif

if odp
   if Empty( b ) .and. siec = .f.
      if mode = NIL; zap
      else; pack
      endif
   else
      if Empty( b ); b := Alias(); endif
   *   ON( b )
      if mode = NIL; ON( b,,,, .t. )       && zap
      else; ON( b,,,,, .t. )               && pack
      endif
   endif
   wy := 2
   zmiana := .t.
endif

RunCommand( r )

Select( bb )

return odp

******************************************************************************
* Nr 61
* <baza,indeks,wyraßenie,komunikat poraßki,numer menu, kom. sukcesu, selfbaza >

function CzyJest( a )

local bbb, bb, ttt, tt, rrr, rr, ii, ww, mm, se

private buf := ReadVar(), buff

private buf_sys := &buf

bbb := Alias()                 && baza matka

bb   := Odetnij( @a )          && baza cel
ii   := Val( Odetnij( @a ))    && indeks
buff := Odetnij( @a )          && wyraßenie szukane z wplecionym "buf_sys"
tt   := Odetnij( @a )          && tytuí menu
mm   := Val( Odetnij( @a ))    && numer menu
ttt  := Odetnij( @a )          && komunikat poraßki gdy znalazí
se   := Odetnij( @a )          && selfbaza - sprawdzanie na sobie samej

buff := RunCommand( buff )

if Empty( se )
   rr := -1
else
   Select( se )
   rr := RecNo()
endif

ON( bb, ii )
if Empty( ttt )                        && bez komunikatu poraßki
   if !( ww := DBSeek( buff ))
      if mm = 0; Alarm( tt )
      else
         Syrena()
         RunMenu( mm,, 0, 1, tt )
      endif
      ww := .f.
   endif
elseif !Empty( buff )
   ww := .t.
   set filter to
   if DBSeek( buff )
      if rr = RecNo()
         ww := .t.    && nic sië nie staío, bo to jest rekord na kt¢rym stoimy
      elseif mm = 0; Alarm( ttt )
         ww := .f.
      else
         Syrena()
         RunMenu( mm,, 0, 1, ttt )
         ww := .f.
      endif
   endif
   set filter to &DBE_Filtr
endif

DBGo( rr )
Select( bbb )

return ww

******************************************************************************
* <baza,indeks,wyraßenie,reakcja>
* emptywon - jak szukamy pustaka, to sukces bez pracy

function GdyBrak( a, emptywon )

local bbb, bb, ttt, tt, rrr, rr, ii, ww, mm, se

private buf := ReadVar(), buff

private buf_sys := &buf

bbb := Alias()                 && baza matka

bb   := Odetnij( @a )          && baza cel
ii   := Val( Odetnij( @a ))    && indeks
buff := Odetnij( @a )          && wyraßenie szukane z wplecionym "buf_sys"
tt   := Odetnij( @a )          && reakcja gdy nie ma

buff := RunCommand( buff )
if emptywon .and. Empty( buff ); return .t.; endif

globalbuf := buff

ww := .t.
ON( bb, ii )
if !( ww := DBSeek( buff ))
   RunCommand( tt )
endif

Select( bbb )

return ww

******************************************************************************
* wyrazenie = 'K9=buf_sys'
* komunikat = 'AllS(LP)+" "+AllTrim(NUMER)+" z dnia "+DtoC(D3)+"="+AllS(K9)'

function JestTakie( wyrazenie, komunikat )

local bb, rr, ii, mm := {}
local rrr, iii

*if LastKey() # 13; return; endif

Czek( 1 )

private buf := ReadVar(), buff
private buf_sys := &buf

bb := Alias()
rr := RecNo()
ii := IndexOrd()

Select( baza )
rrr := RecNo()
iii := IndexOrd()

DBSetOrder( 0 )
DBSkip( -1 )

ww := .t.
while !Bof()
		if RunCommand( wyrazenie )
			Aadd( mm, RunCommand( komunikat ))
		endif
		DBSkip( -1 )
enddo

DBGoTo( rrr )
DBSetOrder( iii )

Select( bb )
DBGoTo( rr )
DBSetOrder( ii )

Czek( 0 )

if Len( mm ) > 0
*	while .t.
		Alarm( 'Podobne dokumenty wczeúniej:', mm, 1 )
*		if LastKey() = 27; exit; endif
*	enddo
endif

return ww

******************************************************************************
* Nr 99 : <baza,indeks,seek,warunek,komunikat,pole>

function GetValue( a )

local bbb, bb, ii, ss, ww, kk, pole, ccaa, line

private buff

bbb := Alias()               && baza matka

if !( ',' $ a ); a := StrTran( a, ';', ',' ); endif

bb := Odetnij( @a )          && baza cel
ii := Val( Odetnij( @a ))    && indeks
buff := Odetnij( @a )        && wyraßenie szukane
ww := Odetnij( @a )          && warunek do speínienia
kk := Odetnij( @a )          && komunikat w razie klëski
pole := Odetnij( @a )        && ewentualnie zwracane pole wyniku
ccaa := Odetnij( @a )        && ewentualny katalog dla bazy ¶r¢díowej
line := Val( Odetnij( @a ))  && ewentualna linia odczytywanego pola memo
ss := RunCommand( buff )

ccaa := Zamiennik( ccaa )

ON( bb, ii, ccaa )
DBSeek( ss )

if !Empty( ww )
   ss := RunCommand( ww )
   if !ss
      Alarm( RunCommand( kk ))
   endif
endif

if !Empty( pole )
   ss := RunCommand( pole )
endif

if line # 0
   ss := MemoLine( ss, dl_memo, line )
endif

Select( bbb )

return ss

******************************************************************************
* Zmiania standard znak¢w w polu "nr" w caíej bazie

procedure ZmianaZnakow( a )       && 88

local nr := Val( Odetnij( @a )), rr := RecNo()

if Alarm( 'Zmiana standardu znak¢w z Lat(852) na Mazovië ?', tk ) # 1; return; endif

while !Eof()
      FieldPut( nr, Konwert( FieldGet( nr )))
      DBSkip()
enddo

DBGo( rr )

******************************************************************************

procedure Blokuj_R( buf )

if !siec; return; endif
if buf = NIL; buf := 1; endif

while .t.
      if if( Empty( Alias()), ( baza )->( RLock()), RLock())
         exit
      else
         if buf # NIL          && za pierwszym razem
            Inkey( buf )
            buf := NIL
         else                  && za kolejnym razem
            buf := Alarm( 'Ktoû blokuje dane !!! Nazwa bazy : "' + Alias() + '".',;
                        { 'Pr¢bowaç dalej', 'Wyjûç z systemu' })
            if buf = 2; OpuscSys(1)
            else; buf := 1     && zn¢w pierwszy raz
            endif
         endif
      endif
enddo

******************************************************************************

procedure Odblokuj_R( buf )

if !siec; return; endif
if Eof(); return; endif
if buf = NIL; buf := 1; endif

while .t.
      DBUnLock()
      if !NetErr()
         exit
      else
         if buf # NIL          && za pierwszym razem
            Inkey( buf )
            buf := NIL
         else                  && za kolejnym razem
            buf := Alarm( 'Nie udaje sië odblokowaç danych !!! Nazwa bazy : "' + Alias() + '".',;
                        { 'Pr¢bowaç dalej', 'Wyjûç z systemu' })
            if buf = 2; OpuscSys(1)
            else; buf := 1     && zn¢w pierwszy raz
            endif
         endif
      endif
enddo

******************************************************************************
* Blokuj i kasuj

procedure BDelete()

Blokuj_R()
DBDelete()

******************************************************************************
* Dodaj rekord

function DBAdd()

local i := 0

DBAppend()
while NetErr() .and. i < 10   && w razie niepowodzenia kolejne pr¢by dodania
      i ++
      Inkey( 1 )
      DBAppend()
enddo

if i >= 10
   Alarm( 'Niepowodzenie dodania rekordu do bazy ' + Alias() + ' !!!' )
   return .f.
endif

return .t.

******************************************************************************

function Katalog( dest )

local gdzie_byl := ''
do case
case dest = NIL   ; return .f.
case Empty( dest ); return .t.
endcase

dest := Upper( AllTrim( dest ))

if Right( dest, 1 ) == '\'                 && C:\DOS\
   dest := Left( dest, Len( dest ) - 1 )   && C:\DOS
endif

private dr_dest := ''
if ':' $ dest
   dr_dest := Left( dest, 2 )
   dest := SubStr( dest, 3 )      && z "C:\DOS" na "\DOS"
endif

private tam   := Upper( dest )
private tutaj := '\' + CurDir()

@ 10, 0 say ''
set console off
if !Empty( dr_main ) .and. !Empty( dr_dest ) .and. !( dr_dest == dr_main )
   run &dr_dest > nul
   run cd &tam > nul
   gdzie_byl := '\' + CurDir()
   run &dr_main > nul
   run cd &tutaj > nul
else
   run cd &tam > nul
   gdzie_byl := '\' + CurDir()
   run cd &tutaj > nul
endif
set console on

return Right( gdzie_byl, Len( tam  )) == tam

*******************************************************************************
* Nr 89
* a - klucz
* kat - katalog dla zamiennika
* mode # NIL - dziaíanie w ROB bez mieszania w "SYSBAZ" i opiekÜ nad indeksami

procedure CreateIndex( a, kat, mode, de )

local x
private klucz, bb := Alias(), rr := RecNo(), plik

if !Empty( a )
   klucz := a
else
   klucz := Get_U( 10, 10, 'Podaj klucz sortowania :', Sz_X(30), Space(30))
   if klucz = NIL; return; endif
endif

Czek( 1 )

if mode = NIL
   Select( baza )
   close indexes
endif

@ 0, 0 say ''

if mode = NIL; plik := Left( 'x' + Alias(), 8 ) + '.ntx'
else         ; plik := Left( 'y' + Alias(), 8 ) + '.ntx'
endif

if siec .and. sieciowo
   plik := cat_baza + 'ROBOCZY' + nr_stacji + '\' + plik
endif

run del &plik

@ 0, 0 clear to 0, mc

if mode = NIL .and.;
	kat = NIL .and.;
	jestiexe .and.;
	!( '->' $ klucz ) .and.;
	!( 'Grosz' $ klucz ) .and.;
	!( 'DtoA' $ klucz ) .and.;
	( bb <> "ROB" )

   x := 'run i.exe ' + StrTran( if( WOsobnych( bb, 1 ), CatOsobny( kat ) + '\', '' ) + bb, ' ', '' ) + ' ' + StrTran( klucz, ' ', '' ) + ' ' + StrTran( plik, ' ', '' )
   x := StrTran( x, '"', '~' )
   ON( SysBaz )              && niech "SysBaz" sië pojawi i nie bru¶dzi potem
   Zwolnij( bb, 1 )
   RunCommand( x, 1 )
   @ 0, 0 clear to 0, mc
   if !File( StrTran( plik, ' ', '' ) + '.ntx' )
      ON( bb )
      @ 0, 0 say 'Tworzenie indeksu "' + plik + '" : ' + klucz
		if de = NIL
	      index on &klucz to &plik
		else
	      index on &klucz to &plik DESCENDING
		endif
   endif
else
   @ 0, 0 say 'Tworzenie indeksu "' + plik + '" : ' + klucz
	if de = NIL
	   index on &klucz to &plik
	else
	   index on &klucz to &plik DESCENDING
	endif
endif

if mode = NIL
   Zwolnij( bb, 1 )
   klucz := ON( bb,, Zamiennik( kat ))
   if klucz = 16
      Alarm( 'OsiÜniëta zostaía maksymalna moßliwa iloûç;plik¢w indeksowych do jednej bazy danych.;Dane bëdÜ teraz posortowane, ale nie zmieniaj ich !!!;Dopisywanie, poprawianie i usuwanie sÜ zabronione !!!')
      close indexes
      DBSetIndex( plik )        && uruchomienie dodatkowego indeksu "temp"
      DBSetOrder( 1 )           && przejûcie na ten dodatkowy indeks
   else
      DBSetIndex( plik )        && uruchomienie dodatkowego indeksu "temp"
      DBSetOrder( klucz + 1 )   && przejûcie na ten dodatkowy indeks
   endif
endif

DBCommitAll()

@ 0, 0 clear to 0, mc

Czek( 0 )
Select( bb )
DBGo( rr )
wy := 2

*******************************************************************************

* 11

procedure KopiaBazy()

local bb := DBF_NAME, newname

if !full_dostep; return; endif

newname := bb
newname := Get_U( 10, 10, 'Podaj nowÜ nazwë :', Replicate( 'X', Len( newname )), newname )
if newname = NIL .or. newname = bb; return; endif

copy to ROBOCZY\ROB while bb == DBF_NAME
use ROBOCZY\ROB new
while !Eof()
      Blokuj_R()
      replace DBF_NAME with newname
      skip
enddo
go top

KopiaRec( 'ROB', SysBaz )
Zwolnij( 'ROB' )

Select( SysBaz )
wy := 2

*****************************************************************************
*  1. 'D3', 'DtoS(D3)+Str(NRK)+NUMER': klucz indeksowania
*  2. 'LP': pole do renumeracji
*  3. 'Data': haslo - do komunikatu
*  4. mode # NIL - dziaíanie w ROB bez mieszania w "SYSBAZ" i opiekÜ nad indeksami
*  5. b1 - baza zapíat
*  6. b2 - baza specyfikacji
*  7. musi - 
*  8. b3 - baza linkÛw = 'LINKI'
*  9. k3 - klucz 3, np.: Alias()='REJ_PZ'
* 10. p3 - pole 3 do renumeracji, np.: 'SOURCE_LP'=2
* 11. wa - warunek OK, a resztÍ pomija

procedure Renum( klucz, pole, haslo, mode, b1, b2, musi, b3, k3, p3, wa )

local i := 0, rr := ( baza )->( RecNo()), bb := Alias(), h, dt, plp, fi

if haslo = NIL; haslo := klucz; endif
h := 'Renumerowaç "' + pole + '" w/g "' + haslo + '"?'

if musi = NIL .and. !haker
   ON( 'ZAOKRESY' )
   if !Eof()
      DBGoBottom()
      dt := DATA2 + 1
   endif
   if dt # NIL
      h := 'Renumeracja moßliwa od daty ' + DtoC( dt ) + ';' +;
           'z powodu zamkniëtych okres¢w sprawozdawczych;' + h
   endif
endif

Select( bb )

if Alarm( h, nt ) # 2; return; endif

private buf

filtr := DBFilter()
CreateIndex( klucz,, mode )
if !Empty( filtr )
   set filter to &filtr
endif

if dt = NIL
   i := 0
   DBGoTop()
else
   buf := baza + '->' + pole    && ustalenie ostatniego zamkniëtego LP
   DBSeek( if( 'DtoS' == Left( klucz, 4 ), DtoS( dt ), dt ), .t. )
   DBSkip( -1 )
   if Bof()
      i := 0
   else
      i := &buf
   endif
   DBSeek( dt, .t. )
endif

if Eof()
   ( baza )->( DBGoTo( rr ))
   Alarm( 'Brak pozycji moßliwych do przenumerowania' )
   return
endif

if dt = NIL
	i := Get_U( 15, 25, 'Podaj pierwsze LP', '@Z 99999999', i + 1 )
	if i = NIL; return; endif
	i := i - 1
else
	i := Get_U( 15, 25, 'Podaj pierwsze LP z dnia ' + DtoC( dt ), '@Z 99999999', i + 1 )
	if i = NIL; return; endif
	i := i - 1
endif

if b1 # NIL
   ON( b1, 0 )
   @ 0, 0 say 'Przenumerowanie bazy "' + b1 + '"'
   Przerwa( LastRec())
   while !Eof()
      if FieldGet( 1 ) > i   && uwzglëdniamy tylko pozycje spoza zamk. okres¢w
         Blokuj_R()
         ( b1 )->( FieldPut( 1, -FieldGet( 1 )))
         OdBlokuj_R()
      endif
         if Przerwa(); exit; endif
         skip
   enddo
   Przerwa( 0 )
   @ 0, 0 say Space( mc + 1 )
endif

if b2 # NIL
   ON( b2, 0 )
   @ 0, 0 say 'Przenumerowanie bazy "' + b2 + '"'
   Przerwa( LastRec())
   while !Eof()
      if FieldGet( 1 ) > i   && uwzglëdniamy tylko pozycje spoza zamk. okres¢w
         Blokuj_R()
         ( b2 )->( FieldPut( 1, -FieldGet( 1 )))
         OdBlokuj_R()
      endif
         if Przerwa(); exit; endif
         skip
   enddo
   Przerwa( 0 )
   @ 0, 0 say Space( mc + 1 )
endif

if b3 # NIL
	k3 := PadR( k3, 8 )		&& Alias()
   ON( b3, 0 )
   @ 0, 0 say 'Przenumerowanie bazy "' + b3 + '"'
   Przerwa( LastRec())
   while !Eof()
      if ( FieldGet( 1 ) == k3 ) .and. ( FieldGet( p3 ) > i )   && uwzglëdniamy tylko pozycje spoza zamk. okres¢w
         Blokuj_R()
         ( b3 )->( FieldPut( p3, -FieldGet( p3 )))
         OdBlokuj_R()
      endif
         if Przerwa(); exit; endif
         skip
   enddo
   Przerwa( 0 )
   @ 0, 0 say Space( mc + 1 )
endif

Select( bb )
Przerwa( LastRec())
while !Eof()
	if ( wa = NIL ) .or. (( wa # NIL ) .and. &wa )
      i ++
      buf := baza + '->' + pole       && np.: REJ_SP->LP
      plp := &buf                     && poprzednie LP, np.: 10
      ( baza )->( Blokuj_R())
      &buf := i                       && nowe LP
      ( baza )->( OdBlokuj_R())
      if b1 # NIL
         ON( b1 )
         while DBSeek( -plp ) .and. !Eof()
               Blokuj_R()
               FieldPut( 1, i )
               OdBlokuj_R()
         enddo
      endif
      if b2 # NIL
         ON( b2 )
         while DBSeek( -plp ) .and. !Eof()
               Blokuj_R()
               FieldPut( 1, i )
               OdBlokuj_R()
         enddo
      endif
      if b3 # NIL
         ON( b3 )
         while DBSeek( k3 + Str( -plp, 10 )) .and. !Eof()
               Blokuj_R()
               FieldPut( p3, i )
               OdBlokuj_R()
         enddo
      endif
	endif
   if Przerwa(); exit; endif
   Select( bb )
   DBSkip()
enddo
Przerwa( 0 )

( baza )->( DBGoTo( rr ))

*ON( baza, -1,,,, .t. )

******************************************************************************
* Poprzedni Nr konta rozliczeniowego
* baza  = 'KNORDPOL'
* xpole = 'KONTO'
* xlen  = díugoûç sekwencji aktywowania, np. 4 => "210-"
* sak = sekwencja aktywowania

procedure PopKonto( baza, xpole, xlen, sak )

local x, y, z, q, l, rr, ii

if baza = NIL
   baza := Alias()
endif

private bu, pole := baza + '->' + xpole

if sak = NIL
   bu := ReadVar()

   x := &bu                         && np.: 210-
   l := Len( x )
else
   bu := pole
   x := sak
   l := Len( &pole )
endif

x := AllTrim( x )

if !( len( x ) = xlen .and. Right( x, 1 ) == '-' ); return; endif

rr := ( baza )->( RecNo())
ii := ( baza )->( IndexOrd())

( baza )->( DBSetOrder( 0 ))
( baza )->( DBGoBottom())
while ( baza )->( !Bof())
      y := &pole
      if Left( y, Len( x )) == x
         q := Val( SubStr( y, Len( x ) + 1 )) + 1
         z := x + Right( '00000' + AllS( q, '9999999999' ), 5 )
         exit
      endif
      ( baza )->( DBSkip( -1 ))
enddo

( baza )->( DBSetOrder( ii ))
( baza )->( DBGoTo( rr ))

if z # NIL
   &bu := PadR( z, l )
endif

return q

******************************************************************************
* Pierwszy wolny Nr konta rozliczeniowego
* baza  = 'KNORDPOL'
* xpole = 'KONTO'
* xlen  = díugoûç sekwencji aktywowania, np. 6 => "200/1-"
* sak = sekwencja aktywowania

procedure WolneKonto( baza, xpole, xlen, sak )

local x, y, z, q, l, rr, ii, bb := Alias()

if baza = NIL
   baza := Alias()
endif

private bu, pole := baza + '->' + xpole

if sak = NIL
   bu := ReadVar()

   x := &bu                         && np.: 210-
   l := Len( x )
else
   bu := pole
   x := sak
   l := Len( &pole )
endif

x := AllTrim( x )

if !( len( x ) = xlen .and. Right( x, 1 ) == '-' ); return; endif

rr := ( baza )->( RecNo())
ii := ( baza )->( IndexOrd())

( baza )->( DBSetOrder( 1 ))

Select( baza )
set filter to

z := x
q := 0
while ( baza )->( DBSeek( z ))
      z := x + Right( '00000' + AllS( ++q, '9999999999' ), 5 )
enddo

( baza )->( DBSetOrder( ii ))
( baza )->( DBGoTo( rr ))

if z # NIL
   &bu := PadR( z, l )
endif

Select( bb )

return q

******************************************************************************
* Poprzednie pole, np.: PopPole( 'REJ_KA', 'NUMER', 0, 0, '/' )
* baza, np.: REJ_KA
* xpole, np.: NUMER od REJ_KA->NUMER
* bez = pierwszy znak drugiego cz≥onu powodujπcy pomijanie pozycji

procedure PopPole( baza, xpole, spac, wdol, bez )

local x, y, z, l, rr := ( baza )->( RecNo())

private bu := ReadVar(), pole := baza + '->' + xpole

spac := if( spac = NIL, 1, spac )
wdol := if( wdol = NIL, 1, wdol )
x := &bu                         && np.: KP
l := Len( x )
x := AllTrim( x )
( baza )->( DBSkip( -1 ))
while ( baza )->( !Bof())
      y := &pole
      if Left( y, Len( x )) == x
      if bez = NIL
            z := x + Space( spac ) + AllS( Val( SubStr( y, Len( x ) + 1 )) + 1, '9999999999' )
           exit
      else
         if SubStr( y, Len( x ) + 2, 1 ) # bez
               z := x + Space( spac ) + AllS( Val( SubStr( y, Len( x ) + 1 )) + 1, '9999999999' )
                 exit
         endif
      endif
      endif
      ( baza )->( DBSkip( -1 ))
enddo

if z # NIL
   &bu := PadR( z, l )
endif

( baza )->( DBGoTo( rr ))

Keyboard Replicate( Chr( K_DOWN ), wdol )

******************************************************************************
* Ostatni rekord

function PopRec( pole, in )

local ii := IndexOrd(), ww, rr

if in = NIL; in := 1; endif
rr := RecNo()
DBSetOrder( in )
DBGoBottom()
ww := &pole
DBGo( rr )

DBSetOrder( ii )

return ww

*******************************************************************************
* Przedostatni rekord

function PopRe( pole, in )

local ii := IndexOrd(), ww, rr

if in = NIL; in := 1; endif
rr := RecNo()
DBSetOrder( in )
DBGoBottom()
DBSkip( -1 )
ww := &pole
DBGo( rr )
DBSetOrder( ii )

return ww

*******************************************************************************
* h - hasío dla zakresu dat
* d - iloûç dni wakacji
* i1 - indeks dat + numer¢w
* i2 - indeks dat + numer dowodu ksiëgowego
* pole1 - pole dat
* pole2 - pole numer¢w

procedure RenumLP( h, d, i1, i2, pole1, pole2 )

local k, rr, ii, bb

if Get_Okres( @data1, @data2, h ) = NIL
   return
endif

*if data1 < Datee() - d
*   Alarm( 'Nie wolno renumerowaç pozycji starszych niß ' + AllS( d ) + ' dni !!!' )
*   return
*endif

bb := Alias()
rr := RecNo()
ii := IndexOrd()
DBSetOrder( i1 )
DBSeek( DtoS( data1 ), .t. )
if Eof()
   Alarm( 'Brak danych w podanym zakresie dat !!!', Ent )
   DBSetOrder( ii )
   DBGo( rr )
   return
endif

DBSkip( -1 )
k := if( Bof(), 0, &pole2 )      && pierwszy numer tego dnia

DBSetOrder( i2 )
DBSeek( DtoS( data1 ), .t. ); rr := RecNo()
while ( bb )->( &pole1 ) <= data2 .and. !Eof()
      k ++
      Blokuj_R()
      &pole2 := k
      DBSkip()
enddo

DBGo( rr )
DBSetOrder( ii )

wy := 2

*****************************************************************************

function GetPoleS( i, klucz, nazwa_pola, bbaza, wdol, mode, mode2, warval, wwhile, baza2 )

GetPole( i, klucz, nazwa_pola, bbaza,,, 1,,, 'STAROCIE\'+bbaza )

*****************************************************************************
* mode = NIL -> DBSeek()
* mode # NIL -> DBSeek( xjhcbf, .t )
* mode2= NIL -> ( baza )->
* mode2# NIL -> (bbaza )->
* warval - warunek dla "wynikvalid"
* wwhile - warunek sumowania "nazwa_pola", np. "ILOSC"
* baza2 - jeûli nie znalazí tu to ma szukaç analogicznie w baza2
* GetPole( 1, 'Str(1,10)+Str(ID_T)', 'ILOSC', 'MAGAZYNY',,,,,'Str(ID)+Str(ID_T)==Str(1,10)+Str((baza)->ID_T)')

function GetPole( i, klucz, nazwa_pola, bbaza, wdol, mode, mode2, warval, wwhile, baza2 )

local ok, rrr, iii, bbb := Alias()
private a := klucz, b := nazwa_pola, bb, ii, rr, bazaza := baza

if i # NIL
	if i < 0
		if ( baza )->( &a ) = FieldGet( 1 )
			return &b
		endif
		i := -i
	endif
endif

if mode2# NIL; bazaza := Alias(); endif

if bbaza # NIL
   if !Jest_baza( bbaza ); ON( bbaza ); endif
endif

if i # NIL .and. i < 0          && pamiëtaj pozycjë
   i := Abs( i )
   rrr := RecNo()
   iii := IndexOrd()
endif

if i # NIL; DBSetOrder( i ); endif

if mode = NIL; ok := DBSeek(( bazaza )->( &a ))
else         ; ok := DBSeek(( bazaza )->( &a ), .t. )
endif

if bbaza # NIL .and. baza2 # NIL .and. !ok
   ON( baza2,,, 'D'+bbaza )
   if i # NIL; DBSetOrder( i ); endif
   if mode = NIL; ok := DBSeek(( bazaza )->( &a ))
   else         ; ok := DBSeek(( bazaza )->( &a ), .t. )
   endif
endif

i := &b

if wwhile # NIL
   rr := RecNo()
   skip
   while &wwhile .and. !Eof()
         i += &b
         skip
   enddo
   DBGo( rr )
endif

if rrr # NIL             && pamiëtaj pozycjë
   DBSetOrder( iii )
   DBGo( rrr )
endif

if bbaza # NIL
	if !Jest_baza( bazaza )
		Jest_baza( bbb )
	endif
endif

if wdol # NIL
	if wdol > 0
		Keyboard Replicate( Chr( K_DOWN ), wdol )
	else
		Keyboard Replicate( Chr( K_DOWN ), -wdol ) + Chr( K_RIGHT ) + Chr( K_LEFT )
	endif
endif

if warval # NIL
   warval := '{|a|' + warval + '}'
   warval := &warval
   wynikvalid := Eval( warval, i )
endif

return i

*******************************************************************************

function DBGo( rr )
if 0 < rr .and. rr <= LastRec(); DBGoTo( rr ); return .t.; endif
return .f.

*******************************************************************************
* Zíy gdy go nie ma lub jest za maíy, czyli uszkodzony (niedoko§czony).

function ZlyNTX( k )

local p := Directory( k )

do case

   case Len( p ) = 0                && zíy bo nie ma
   case p[ 1, F_SIZE ] <= 1024      && zíy bo za maíy
        private buf := k
        run del &buf                && skasuj zíego
otherwise; return .f.               && dobry
endcase

return .t.                          && zíy

******************************************************************************
* bb - baza do kt¢rej idÜ zapisy ( tylko jedno pole )
* ww - wartoûç pola, kt¢re jest notowane
* zz - znak jaki ma zwracaç jak by co

* p1, p2 - pola notowane na kolejnych polach bazy znacznik¢w

function Mark( bb, ww, zz, p1, p2 )

if ( bb )->( DBSeek( ww ))
   if zz # NIL
      return if( zz == 'lp', ( bb )->( RecNo()), zz )
   else
      ( bb )->( BDelete())
      Keyboard Chr( K_DOWN )
   endif
else
   if zz # NIL
      return if( zz == 'lp', 0, ' ' )
   else
      ( bb )->( DBAppend())
      if p1 = NIL; ( bb )->( FieldPut( 1, ww )); endif
      if p1 # NIL; ( bb )->( FieldPut( 1, p1 )); endif
      if p2 # NIL; ( bb )->( FieldPut( 2, p2 )); endif
      Keyboard Chr( K_DOWN )
   endif
endif

*******************************************************************************

procedure InsertRecord( a, kopia )

local r := RecNo(), k := 1, r0, r1, r2, k2 := .f.

skip
if Eof()
   k := Alarm( 'Gdzie umieûciç nowy rekord?', { 'Przed bießÜcym', 'Za bießÜcym' })
endif

DBGoTo( r )

if k = 0; return .f.; endif
kopia := ( kopia # NIL )
if kopia
   r2 := {}; for i := 1 to FCount(); Aadd( r2, FieldGet( i )); next
   k2 := ( 1 = Alarm( 'Gdzie umieûciç nowy rekord?', { 'Na kon`cu', 'przed bießÜcym' }))
   if k2
      k := 2
      DBGoBottom()
      r := RecNo()
   endif
endif

DBAdd()
r0 := {}; for i := 1 to FCount(); Aadd( r0, FieldGet( i )); next
while .t.
      skip -1
         if k = 2 .and. r = RecNo()
            skip 1
            exit
         endif
         r1 := {}; for i := 1 to FCount(); Aadd( r1, FieldGet( i )); next
      skip 1
         Blokuj_R(); for i := 1 to FCount(); FieldPut( i, r1[ i ]); next
      skip -1
         if k = 1 .and. r = RecNo(); exit; endif
enddo
Blokuj_R()
if kopia
   for i := 1 to FCount(); FieldPut( i, r2[ i ]); next
else
   for i := 1 to FCount(); FieldPut( i, r0[ i ]); next
endif

if !NewSysForm( a )
   Bdelete()
endif

wy := 2

*******************************************************************************
*T|Transfer|Transfer('STAROCIE','TOWARY','TOWARYZ','ID')|

procedure Transfer( katalog, bazacel, znaki, pole, ind )

local bb := Alias(), ii := IndexOrd(), i := 0

Select( znaki ); DBGoTop()
while !Eof(); i ++; skip; enddo

Select( bb )
if Alarm( 'Wykonaç transfer ' + AllS( i ) + ' pozycji ?', nt ) # 2; return; endif

( bb )->( DBSetOrder( if( ind = NIL, 1, ind )))
ON( bazacel,, katalog, 'CEL' )

Select( znaki ); DBGoTop()
while !Eof()
      if ( bb )->( DBSeek(( znaki )->( FieldGet( 1 ))))
         KopiujRec( bb, 'CEL' )
         ( bb )->( BDelete())
      endif
      skip
enddo

ON( znaki,,,, .t. )
Select( bb ); DBSetOrder( ii ); DBGoTop()
wy := 2

*******************************************************************************
* 20.01.2000 -> 20.01.00

function DtoA( d )
local x := DtoC( d )
local y := Right( x, 2 )
return Left( x, 6 ) + y

*******************************************************************************
* vpole - pole formularza
* bpole - pole bazy

procedure DziwnaData( vpole, bpole )

local wy := .t., h, odp

do case
case TestDaty = 0       && nic
case TestDaty = 1       && rok i miesiÜc
     if vpole = bpole .or.;
        Left( DtoS( vpole ), 6 ) == Left( DtoS( Datee()), 6 )
     else
        wy := .f.
     endif
case TestDaty = 2       && rok
     if vpole = bpole .or.;
        Left( DtoS( vpole ), 4 ) == Left( DtoS( Datee()), 4 )
     else
        wy := .f.
     endif
endcase

if !wy
   do case
   case TestDaty = 1       && rok i miesiÜc
        h := 'Rok lub miesiÜc podanej daty jest inny niß daty bießÜcej'
   case TestDaty = 2       && rok
        h := 'Rok podanej daty jest inny niß daty bießÜcej'
   endcase
   odp := Alarm( 'Dziwna data ... sprawd¶ ...',;
               { ' OK ', 'Powiedz wiëcej', 'Informacje szczeg¢íowe' })
   if odp = 2
      Alarm( h )
   endif
   if odp = 3
      OPIS( cat_wzorow + 'datatest.txt',, 'Informacje szczeg¢íowe' )
   endif
endif

return .t.

*******************************************************************************
* Wykonanie bloku tekstowego

function RunCBlok( cb )

return Eval( &cb )

*******************************************************************************
* Nr 73. Wykonanie funkcji systemu, Clipper'a lub DOS
* s: "if s # NIL; s := SaveScreen(); endif"
* bez # NIL -> bez zamiany "%"->"," "~"->"%" 
* stri # NIL => w "a" jest string i jeûli jest pusty, to zwr¢ç pusty
* par = parametry przekazywane do Evala

function RunCommand( a, s, bez, stri, par )

if a = NIL .or. Empty( a )
   if stri # NIL
      return ''
   else
      return .f.
   endif
else

   if s # NIL; s := SaveScreen(); endif

   private b := AllTrim( a )

	if Left( b, 1 ) == '#'
		b := ReadWzor( SubStr( b, 2 ))
      b := StrTran( b, EOL, '' )
		while !( Empty( a := Odetnij( @b, '|' )))
				RunCommand( a, s, bez, stri, par )
		enddo
		return .t.
	endif

   if Upper( Left( b, 6 )) == 'DBEVAL'

      b := SubStr( b, 7 )
      b := StrTran( b, '(;;', '{||' )
      b := StrTran( b, ';;)', '}' )
      b := StrTran( b, ';', ',' )
      b := StrTran( b, '%', ',' )
      b := StrTran( b, '^', ';' )
      b := if( '(baza)' $ b, StrTran( b, '(baza)', baza ), b )
      if ( 'MARK' $ Upper( b )) .or. ( Alarm( b, nt ) = 2 )
         b := &b
         a := DBEval( b )
      endif
   elseif Upper( Left( b, 4 )) == 'RUN '
      @ 5, 0 say ''
      b := SubStr( b, 5 )
      run &b
      set cursor on
      set cursor off
   else
      b := StrTran( b, ';', ',' )
if bez = NIL
      b := StrTran( b, '%', ',' )
      b := StrTran( b, '~', '%' )
endif
      b := StrTran( b, '^', ';' )
      b := if( '(baza)' $ b, StrTran( b, '(baza)', baza ), b )
      b := '{|par|' + b + '}'
      b := &b
      a := Eval( b, par )
   endif

   if SUPERSAVE
      DBCommitAll()
   endif

   if s # NIL; RestScreen( ,,,, s ); endif

   return a

endif

******************************************************************************
* modyfikacja oryginalnej funkcji "DBEval({ || StrTran( ..."

procedure DBEST( sPole, co, na )

local rr := RecNo(), bb := Alias(), ii := IndexOrd()

Czek(1)
DBSetOrder( 0 )
DBEval({|| StrTrann( sPole, co, na )})
Select( bb )
DBSetOrder( ii )
DBGoTo( rr )
wy := 2
Czek(0)

******************************************************************************
* modyfikacja oryginalnej funkcji "DBEval({ || BDelete( ..."

procedure DBEBD( sPole, wa )

local rr := RecNo(), bb := Alias(), ii := IndexOrd()

Czek(1)
DBSetOrder( 0 )
go top
while !Eof()
      if &sPole = wa
         BDelete()
      endif

      skip
enddo
Select( bb )
DBSetOrder( ii )
DBGoTo( rr )
wy := 2
Czek(0)

******************************************************************************
* modyfikacja oryginalnej funkcji

procedure StrTrann( sPole, co, na )

local wa

wa := &sPole

if ValType(co)='C'
   wa := StrTran( wa, co, na )
else
   wa := if( wa==co, na, wa )
endif

Blokuj_R()
replace &sPole with wa

******************************************************************************

procedure apendfrom( x )

local cBuffer := SPACE( 81 )
local nHandle := FOPEN( x )

while .t.
       IF FERROR() != 0
          Alarm("File open error: " + AllS( FERROR()))
          exit
       ELSE
          IF FREAD(nHandle, @cBuffer, 81 ) = 81
             DBAppend()
             replace POLE with SubStr( cBuffer, 2 )
          else
             Alarm( "Error reading " + x )
             exit
          ENDIF
       ENDIF
enddo

FCLOSE(nHandle)

*****************************************************************************
* bezpytan - bez weryfikacji katalogu
* bezzamykania - nie wykonuj "Pozamykaj"

procedure CatSwich( x, bezpytan, bezzamykania )

static popcatmain
local ekran := SaveScreen(), odp

private cat, buf

if bezpytan=NIL .and. bezzamykania=NIL .and. x # NIL
	CatSwich()
endif

if bezzamykania = NIL
   Pozamykaj( 1 )
endif

if popcatmain = NIL
   popcatmain := cat_main
endif

if x = NIL
   cat_main := popcatmain
   @ 0, 0 say Space( mc )
   run cd &cat_main
   FillParams()
   return .t.
endif

cat := ReadWzor( x )

while .t.
   if bezpytan = NIL
      cat := PadR( cat, 50 )
      if NIL = ( cat := Get_U( 18, 20, 'Podaj katalog:', '@KS30', cat )); return .f.; endif
      cat := AllTrim( cat )
   endif
   while .t.
      run cd &cat
      RestScreen(,,,, ekran )
      if Upper( Right( CurDir(), Len( cat ))) == Upper( cat )  && przeíÜczyí
         MemoWrit( cat_wzorow + x, cat )
         @ 0, 0 say 'Katalog: ' + cat
         cat_main := '\' + CurDir()
         FillParams()
         return .t.
      else
         odp := Alarm( 'Katalog "' + cat + '" nie istnieje',;
                     { 'Utworzyç katalog', 'Zmiana nazwy katalogu' })
         do case
         case odp = 0; return .f.
         case odp = 1
              CatMake( cat )
              CatMake( cat + '\ROBOCZY' )
              CatMake( cat + '\BUFOR' )
              RestScreen(,,,, ekran )
         case odp = 2; exit
         endcase
      endif
   enddo
enddo

return .t.

*****************************************************************************

procedure CatMake( k )

local cu := CurDir()

if k = NIL .or. Empty( k ); return .f.; endif

RunCommand( 'run cd ' + k )
if cu == CurDir()
   RunCommand( 'run mkdir ' + k )
endif
RunCommand( 'run cd \' + cu )

return .t.

*****************************************************************************

function Freshest( d, roz )

local pliki, mm := {}, x

if roz = NIL; roz := '*.*'; endif
pliki := Directory( d + '\' + roz )

AEval( pliki, { |a| Aadd( mm, DtoS( a[ F_DATE ]) + a[ F_TIME ] + a[ F_NAME ])})
mm := ASort( mm )

return if(( x := Len( mm )) > 0, d + '\' + SubStr( mm[ x ], 17 ), '' )

******************************************************************************
* dwa - oba warunki

function Pusta( dwa )

if ( dwa = NIL .and. Eof() .and. Bof()) .or. ( dwa # NIL .and. Bof())
   Alarm( 'Baza danych jest pusta !!!' )
   return .t.
endif

return .f.

******************************************************************************

procedure Zapisz_baze( tab )

local i

for i := 1 to FCount()
    tab[ i ] := FieldGet( i )
*    if mode # NIL
*       tab[ 1 ] := Left( tab[ 1 ], mode )
*    endif
next

*****************************************************************************

procedure Wpisz_do_bazy( tab )

local i

Blokuj_R()
for i := 1 to FCount()
    FieldPut( i, tab[ i ])
next
Odblokuj_R()

*****************************************************************************
* mode = NIL - bez scalania
* mode = 0 - max ( ID_T, cena, rabat, cenabezrabatu )
* mode = 1 - max ( nazwa, cena, rabat, cenabezrabatu )
* mode = 2 - med ( nazwa, cena )
* mode = 3 - min ( nazwa )
* mode = 4 - min ( ID_T )

procedure Scal_ROB( mode )

local rek[ FCount()], rrr, rr, il, w_buforze := .f., warunek


do case
case mode = NIL; return
case mode = 0; warunek := { || rek[ 2 ] = ID_T .and. rek[ 3 ] = CENA .and.;
                               rek[ 5 ] = RABAT .and. rek[ 6 ] = CENABEZR }
case mode = 1; warunek := { || rek[ 7 ] = NAZWA .and. rek[ 3 ] = CENA .and.;
                               rek[ 5 ] = RABAT .and. rek[ 6 ] = CENABEZR }
case mode = 2; warunek := { || rek[ 7 ] = NAZWA .and. rek[ 3 ] = CENA }
case mode = 3; warunek := { || rek[ 7 ] = NAZWA }
case mode = 4; warunek := { || rek[ 2 ] = ID_T }
endcase

go top
il := 0
Zapisz_baze( @rek, mode )
rr := RecNo()
skip
while !Eof()
      if Eval( warunek )
			if mode = 4							&& jesteúmy w ROB o takiej strukturze, øe ILOSC jest 3
				if ( rek[ 3 ] + ILOSC ) # 0
		   	      rek[ 4 ] := ( rek[ 4 ] * rek[ 3 ] + CENA_Z * ILOSC ) / ( rek[ 3 ] + ILOSC )
				endif
   	      rek[ 3 ] += ILOSC
			else
	         rek[ 4 ] += ILOSC
			endif
         w_buforze := .t.
         BDelete()
      else
         rrr := RecNo()
         go rr                        && cofnij do bazy
         Wpisz_do_bazy( rek )
         go rrr                       && wr¢ç
         w_buforze := .f.
         Zapisz_baze( @rek, mode )
         rr := RecNo()
      endif
      skip                && dalej
enddo

if w_buforze
   go rr
   Wpisz_do_bazy( rek )
endif

go top

******************************************************************************

procedure Znacz( pole )

local bb := Alias(), s, z := Chr( 219 )

if Eof(); return; endif

pole := bb + '->' + pole
Blokuj_R()
s := &pole
if Left( s, 1 ) == z
   &pole := SubStr( s, 3 )
else
   &pole := z + z + s
endif
OdBlokuj_R()

PressKey( 'd¢í' )

******************************************************************************

procedure Znacz2( pole, dest )

local bb := Alias(), s, z := Chr( 219 ), rr

if Eof(); return; endif

if Alarm( 'PrzenieúÊ zaznaczone pozycje do "Parowanych rÍcznie" ?', nt, 1 ) # 2; return; endif

pole := bb + '->' + pole

ON( dest )

Select( bb )
DBGoTop()
while !Eof()
	s := &pole
	if Left( s, 1 ) == z
		if rr = NIL; rr := RecNo(); endif
		AppendRecord( dest, { DOK, NR, DATA, LP, PZ, KONTO, OBROTYWN, OBROTYMA })
		BDelete()
	endif
	skip
enddo
DBGo( rr )
DBSkip( -1 )

******************************************************************************

procedure AktWzory()

local a, n, x, i, pliki

if Alarm( 'Aktualizowaç informacje ?', nt ) # 2; return; endif

DBSetOrder( 1 )
pliki := Directory( cat_wzorow + '*.*' )
x := Len( pliki )

set filter to
go top
Przerwa( LastRec())
while !Eof()
      AppendRecord(, {,, 0, CtoD(''), '' }, 1 )
      Przerwa()
      skip
enddo
Przerwa( 0 )

Przerwa( x )
for i := 1 to x
    a := pliki[ i ]
    n := a[ F_NAME ]
    if ( '{' $ n ) .or. ( '~' $ n )
    else
       if !DBSeek( n )
          AppendRecord(, {, a[ F_NAME ], a[ F_SIZE ], a[ F_DATE ], a[ F_TIME ]})
       else
          AppendRecord(, {,, a[ F_SIZE ], a[ F_DATE ], a[ F_TIME ]}, 1 )
       endif
    endif
    Przerwa()
next
Przerwa( 0 )

******************************************************************************

procedure Przebudowa()

local bazy, nr, nazwy := {}, bb := Alias()

bazy := Directory( '*.dbf' )
AEval( bazy, { |a| Aadd( nazwy, a[ F_NAME ])}); nazwy := ASort( nazwy )
if ( nr := Alarm( 'Wybierz plik bazy danych do przebudowy', nazwy )) = 0; return; endif
baza := Upper( nazwy[ nr ])
baza := StrTran( baza, '.DBF','' )
TEST_MUS := .t.
Zwolnij( baza )
ON( baza )
Zwolnij( baza )
Select( bb )
Alarm( 'Baza "' + baza + '" przebudowana' )
TEST_MUS := .f.

******************************************************************************
* Repla('(baza)->DATAM:=Date()')  ->   Repla('NOTATKI->DATAM:=Date()')

function Repla( s )
*NOTATKI->            DATAM:=Date()
*NOTATKI->(Blokuj_R(),DATAM:=Date(),OdBlokuj_R())
s := StrTran( s, '->', '->(Blokuj_R(),' ) + ',OdBlokuj_R())'
return RunCommand( s )

******************************************************************************
* w globalbuf jest poprzednie LP
* w FieldGet( 1 ) jest obecne LP
* s = 'SPLATYE,TOWARYE'

procedure CopySPE( s )

local olp := globalbuf, nlp := FieldGet( 1 ), bb := Alias(), b

if !wynik; return; endif		&& nie potwierdzi≥ formularza

while !Empty( b := Odetnij( @s ))	&& weü nazwÍ bazy specyfikacji
		ON( b )
		DBSeek( olp )
*		KopiaRec( sour, dest, warwhile, na_top, warfor, blok, n )
		KopiaRec( b, b, b + '->(FieldGet( 1 )=' + Alls( olp ) + ')',,, b + '->(FieldPut(1,' + AllS( nlp ) + ')),.f.' )
		Zwolnij( b )
enddo

Select( bb )

******************************************************************************

function Wrzuc( tab, tabb, typ, ile )

local i, jest := .f.

for i := 1 to Len( tab )
	if tab[ i ] == typ
		jest := .t.
		exit
	endif
next

if !jest
	Aadd( tab, typ )
	Aadd( tabb, 0 )
	i := Len( tab )
endif

tabb[ i ] += ile

******************************************************************************
