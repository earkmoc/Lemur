#include 'Inkey.ch' 
#include 'Box.ch'

****************    Procedury    ekranowe    *********************************

procedure Menu( tab , op , has , row , col , inne )

* tab - tablica hasel
* op  - opcja wejsciowa
* haslo - napis nad tabela
* row - wiersz
* col - kolumna
* inne - np. odmienny rodzaj wyswietlenia tabeli

private aktiv_menu := .t. && aktivate menu
private clr_h := .t.      && clear space of haslo
private clr_s := .t.      && clear screen before and behind procedure
private rdoubl := .t.     && podw¢jna ramka
private tlo := .f.        && czarne tlo dla menu
private mazac := .f.        && czarny mazac na prawo od ramki
private poziomo := .f.    && poziome menu promptow
private m_skrot := .f.      && skr¢cona wersja menu
private fast := .f.       && szybka wersja menu
private boki := .f.       && czy moßna chodziç na boki
private bez_tytulu := .f. && nie uzupuíniaç tytuíu z podanej tablicy
private haslo := has
private kk := 0

if inne = NIL
   cls
   Esc()
   Choice()
else
   if 't' $ inne ; tlo := .t. ; endif
   if 'h' $ inne .or. tlo ; clr_h := .f. ; endif
   if 'c' $ inne .or. tlo ; clr_s := .f. ; else ; cls ; endif
   if 'm' $ inne ; aktiv_menu := .f. ; endif
   if 'p' $ inne ; rdoubl := .f. ; endif
   if 'r' $ inne ; mazac := .t. ; endif
   if 'z' $ inne ; poziomo := .t. ; endif
   if 's' $ inne ; m_skrot := .t. ; endif
   if 'f' $ inne ; fast := .t. ; endif
   if 'b' $ inne ; boki := .t. ; endif
   if 'y' $ inne ; bez_tytulu := .t. ; endif
   if '1' $ inne ; Nap_haslo( 'F1' , ' - POMOC ' , 25 ) ; endif
   if '2' $ inne ; Nap_haslo( 'N' , ' - Nowy ' , 46 ) ; endif
   if !( 'e' $ inne ) ; Esc() ; endif
   if !( 'w' $ inne ) ; Choice() ; endif
endif

if !bez_tytulu ; Tytul( 0 ) ; endif

private max_d := 0 , tabl := {} , m_prompt := .f. , poz_menu := {} , tabw:= {}

Aeval( tab , { |a| max_d := Max( max_d , Len( a ) ) } )
Aeval( tab , { |a| Aadd( poz_menu , ' ' + a + ' ' ) } )
Aeval( tab , { |a| Aadd( tabw , if( a = '-' , .f. , .t. ) ) ,;
                   Aadd( tabl , if( a = '-' , Replicate( 'ƒ' , max_d + 2 ),;
                                ' ' + PadR( a, max_d ) + ' ' ) ) } )
max_d += 2                                  //Konwert(a,maz,lat,.t.) 

private max_l , min_l
min_l := if( haslo = NIL , 4 , 7 )       && mozliwe max rozmiary menu
max_l := if( m_skrot , mr - 7 , mr - 3 )

if row = NIL                             && centrowanie wiersza
   row := min_l + ( max_l - min_l ) / 2  && srodkowa linia dozwolonego ekranu
   row -= Len( tab ) / 2                 && wiersz pierwszej linii menu
endif

row := if( row > max_l , max_l , row )   && narzucenie karbow
row := if( row < min_l , min_l , row )

private max_i := Len( tab )             && max ilosc wierszy menu
max_i := if( row + max_i > max_l , max_l - row , max_i )

private nrh := 0

if col = NIL                             && centrowanie kolumny
   col := ( mc - max_d ) / 2
   nrh := 1
else ; nrh := 2
endif

col := if( col < 1 , 1 , col )           && narzucenie karbow
col := if( col >= mc , mc - 1 , col )

Zaciemnij( row , col )
MHaslo( nrh , row , col )

if mazac ; @ row - 1 , col + max_d clear to row + max_i , mc ; endif

if !poziomo
   if rdoubl ; @ row - 1 , col - 1 to row + max_i , col + max_d double
   else      ; @ row - 1 , col - 1 to row + max_i , col + max_d
   endif
endif

do case
case poziomo      && wymuszone prompt'y

     private ile_zn := 0 , przerwa := 0

     AEval( poz_menu , { |a| ile_zn += Len( a ) } )
     przerwa := ( mc - ile_zn ) / ( Len( poz_menu ) + 1 )
     @ row , 0 say ''
     AEval( poz_menu , { |a| PP( a , row , przerwa ) } )
     Menu to op

case fast ;  Pal( row , col , tabl )

otherwise

   if !aktiv_menu ; Keyboard Chr( K_ESC) ; endif

   private kolory := SetColor()
   private std := SubStr( kolory, 1 , At( ',', kolory ) - 1 )  && standard
   SetColor( ',,,,' + std )   && poziome kreski tak jak ramki

	SetKey( K_DOWN, NIL )
	SetKey( K_UP, NIL )

   while .t.
         op := Achoice( row , col , row + max_i - 1 , col + max_d - 1 , tabl , tabw ,, op )
         kk := LastKey()
         if kk = K_LEFT .or. kk = K_RIGHT .or. kk = K_UP .or. kk = K_DOWN
            if !boki ; loop ; endif
         endif
         exit
   enddo

   SetColor( STC )

endcase

kk := LastKey()

if boki
   do case
   case kk = K_LEFT  ; Keyboard Chr( K_LEFT )  + Chr( K_ENTER ) ; return NIL
   case kk = K_RIGHT ; Keyboard Chr( K_RIGHT ) + Chr( K_ENTER ) ; return NIL
   endcase
endif

if inne = NIL .or. clr_s ;  @ 3 , 0 clear ; endif
if kk = K_ESC .or. op = 0 ; return NIL ; endif

if !bez_tytulu
   hasla[ 3 ] := AllTrim( tabl[ op ] )
   Tytul( 1 )
endif

return op

******************************************************************************
* Szybkie wyswietlenie menu

procedure Pal( x , y , tab )

local i := 1 , j , a , w

for i := 1 to Len( tab )
    w := tab[ i ]
    if '~' $ w
       SetColor( jasny )
       @ x + i - 1 , y say StrTran( w , '~' , ' ' )
       SetColor( STC )
    else
       @ x + i - 1 , y say w
    endif
next

******************************************************************************

procedure ZP( a , col )

if aktiv_menu ;  @ a[ 1 ] , col prompt a[ 2 ]
else ;           @ a[ 1 ] , col say a[ 2 ]
endif

******************************************************************************

procedure PP( a , row , p )

?? Space( p )
@ row , col() prompt a

******************************************************************************
* Wyswietla : hasla[ 1 ] i hasla[ 2 ]
*       lub : hasla[ 2 ] i hasla[ 3 ]   zaleznie od parametru 'i'

procedure Tytul( i )

@ 1 , 0 say PadL( na_Firma, 80 )
@ 1 , 1 say na_Naglo

SetColor( 'I,,,,' )

do case
case Len( hasla[ 1 + i ] ) = 0 ; @ 2,0 say PadC( hasla[ 2 + i ], 80 )
case Len( hasla[ 2 + i ] ) = 0 ; @ 2,0 say PadC( hasla[ 1 + i ], 80 )
otherwise
   @ 2 , 0 say PadL( hasla[ 2 + i ], 80 )
   @ 2 , 1 say hasla[ 1 + i ]
endcase

SetColor( STC )

******************************************************************************
* Robi czarne tío dla menu

procedure Zaciemnij( row , col )

local dh, x

if !tlo ; return
endif

if haslo # NIL
   x := At( ';', haslo )
   if x > 0
      dh := Max( x - 1, Len( haslo ) - x - 1 )
   else
      dh := Len( haslo )
   endif
   dh := Max( dh, max_d )
   dh := ( dh - max_d ) / 2
   @ row - 4, col - 4 - dh clear to row + max_i + 1 , col + max_d + 2 + dh
   @ row - 5, col - 5 - dh       to row + max_i + 2 , col + max_d + 3 + dh
else
   @ row - 2 , col - 4 clear to row + max_i + 2 , col + max_d + 2
   @ row - 3 , col - 5       to row + max_i + 3 , col + max_d + 3
endif

******************************************************************************
* Wypisuje hasío nad ramkÜ menu

procedure MHaslo( mode , row , col )

local h1, h2, x

if haslo = NIL ; return
endif

if clr_h ; @ row - 3 , 1 clear to row , mc - 1
endif

x := At( ';', haslo )
if x > 0
   h1 := Left( haslo, x - 1 )
   h2 := SubStr( haslo, x + 1 )
   if mode = 1 ; @ row - 3 , ( mc - Len( h1 ) ) / 2 say h1
                 @ row - 2 , ( mc - Len( h2 ) ) / 2 say h2
   else        ; @ row - 3 , col say h1
                 @ row - 2 , col say h2
   endif
else
   if mode = 1 ; @ row - 3 , ( mc - Len( haslo ) ) / 2 say haslo
   else        ; @ row - 3 , col say haslo
   endif
endif

*******************************************************************************
* Menu poziome
* tab - tablica hasel
* op - opcja wejûciowa
* row - wiersz Menu
* wcho - automatyczne wchodzenie gíëbiej ?

procedure Menu_Poz( tab , op , row , wcho )

op := if( op = NIL , 1 , op )
row := if( row = NIL , 4 , row )
wcho := if( wcho = NIL , .f. , wcho )

private kk := LastKey()

Tytul( 0 )

if !wcho
   LastZero()
   if kk = K_LEFT .or. kk = K_RIGHT ; Keyboard Chr( kk ) ; endif
endif

private poz_menu := {} , max_d := 0

Aeval( tab , { |a| Aadd( poz_menu , ' ' + a + ' ' ) } )
Aeval( poz_menu , { |a| max_d := Max( max_d , Len( a ) ) } )

private ile_zn := 0 , przerwa := 0

AEval( poz_menu , { |a| ile_zn += Len( a ) } )
przerwa := ( mc - ile_zn ) / ( Len( poz_menu ) + 1 )
@ row , 0 say ''
AEval( poz_menu , { |a| PP( a , row , przerwa ) } )
Menu to op

kk := LastKey()

if wcho
   do case
   case kk = K_LEFT  ; Keyboard Chr( K_LEFT )  + Chr( K_ENTER ) ; return NIL
   case kk = K_RIGHT ; Keyboard Chr( K_RIGHT ) + Chr( K_ENTER ) ; return NIL
   endcase
endif

if kk = K_ESC .or. op = 0 ; return NIL ; endif

hasla[ 3 ] := AllTrim( poz_menu[ op ] )

Tytul( 1 )

return op

******************************************************************************

procedure Slupek( a , b )
static procent
private d := 60        && dlugosc slupka
private n := 0
private k1 , k2
private h := ' Zaawansowanie procesu '

k1 := ( mc - d ) / 2
k2 := k1 + d

if a = 1
   @ 14 , k1 - 2 clear to 21 , k2 + 2
   @ 14 , k1 - 2 to 21 , k2 + 2 double
   set color to n/w,w
     @ 14 , ( k1 + k2 - Len( h ) ) / 2 say h
   SetColor( STC )
   @ 16 , k1 say Str( a ) + ' :' + Str( b )
   @ 18 , k1 say Replicate( Chr( 176 ) , d )
   procent := 0
else
   @ 16 , k1 say Str( a )
   n := Round( d * ( a / b ) , 0 )             && zmienna z zakresu 0..d
   if procent < n                              && nastapila zmiana wartosci
      procent := n
      setcolor('w+')
         @ 18 , k1 say Replicate( Chr( 178 ) , n )   && slupek zaawansowania
      setcolor('w')
   endif
end

*******************************************************************************
* m - Nr miesiÜca

FUNCTION Nazwa_M( m )

private nm := {  'STYCZE•', 'LUTY', 'MARZEC', 'KWIECIE•',;
                 'MAJ', 'CZERWIEC', 'LIPIEC', 'SIERPIE•',;
                 'WRZESIE•', 'PA DZIERNIK',;
                 'LISTOPAD', 'GRUDZIE•' }
return nm[ m ]      

******************************************************************************
* d - data

FUNCTION Dzien_Tyg( d )

private ndt := { 'Niedziela', 'Poniedziaíek', 'Wtorek', 'òroda', 'Czwartek', 'PiÜtek', 'Sobota' }, n
n := DOW( d )
return if( n = 0, '', ndt[ n ] )

******************************************************************************
* mode = NIL - nic
* mode = 1   - wyczyûç duße Esc i Enter
* mode = 2   - skr¢ç linië

procedure Czek( x, mode )

static fragment

local kol, r1, r2, c1, c2

*r1 := 10
*r2 := 16
*c1 := 27
*c2 := 53

r1 := mr
r2 := mr
c1 := 0
c2 := mc

if mode # NIL
   do case
   case mode = 1
      r1 := mr - 2
*   case mode = 2
*      c1 := 1 +16
*      c2 := mc-16
   endcase
endif

if x = 0
   RestScreen( r1, c1, r2, c2, fragment )
else
   fragment := SaveScreen( r1, c1, r2, c2 )
   @ r1, c1 clear to r2, c2
   CSay( r2, c1, c2, 'Przetwarzanie danych w toku', '+' + miga )
endif

******************************************************************************

function Lastzero( nr )

clear typeahead

if nr = NIL
   Keyboard Chr( 0 )          && robimy : Lastkey() = 0
   nr := Inkey()
else
   Keyboard Chr( nr )
endif

return .f.

*******************************************************************************
* h1 - podûwietlone
* h2 - normalne
* mode - ( 'L','C','R') - miejsce w linii ( mr ) + 'b' - bez ramki

function Nap_haslo( h1 , h2 , mode, x )

local dl := Len( h1 + h2 ) - 2 , p := 1

if x = NIL
   if ValType( mode ) = 'C'
      do case
      case 'L' $ mode ; x := 2                    && left
      case 'C' $ mode ; x := ( mc - dl ) / 2      && center
      case 'R' $ mode ; x := mc - dl - 2          && right
      endcase
   else
      x := mode
      mode := ''
   endif
endif

if !( 'b' $ mode )
   @ mr - 2 , x - 2 to mr , x + dl + 2 double
else
   p := 0              && bez ramki
   if x = 2 ; x-- ; endif
endif

SetColor( jasny )
   @ mr - p , x say h1
SetColor( STC )
?? h2

******************************************************************************

FUNCTION PgDn( b )

Nap_haslo( 'Page Down' , Konwert(' - caíkowita akceptacja',maz,lat,.t.) , 'R' + if( b = NIL, '', 'b' ))

******************************************************************************

FUNCTION Esc( b, s )

b := 1
Nap_haslo( 'ESC' , Konwert(' - WYJòCIE',maz,lat,.t.) , if( s = NIL, 'L', s ) + if( b = NIL, '', 'b' ))

******************************************************************************

FUNCTION Choice( b )

b := 1
Nap_haslo( 'ENTER' , Konwert(' - WYB£R',maz,lat,.t.) , 'R' + if( b = NIL, '', 'b' ) )

******************************************************************************

procedure F1( b, r )

Nap_haslo( 'F1' , ' - POMOC ' , if( r = NIL, 'R', r ) + if( b = NIL, '', 'b' ))

******************************************************************************
    
function TN ( r , c , hh )

h := if( hh = NIL , 'Na pewno  ??? (t/n)' , hh  )
h := ' ' + h + ' '
   
@ r-2 , c-3 clear to r+2 , c + Len( h ) + 2
@ r-1 , c-1 to r+1 , c + Len( h ) double
@ r,c say h
odp := Chr( Inkey( 0 ) )
return if( odp $ 'tT' + Chr( 13 ) , .t. , .f. )

*************************************************************************
* Funkcja ulepszajÜca Alert
* kwm - konwert windows mazowia

function Alarm( h , tab, kwm )

if h = NIL; return 0; endif
if Empty( h ); return 0; endif
if tab = NIL; tab := Ent; endif

h := Konwert(h,maz,lat,.t.)
if kwm # NIL; h := Konwert( h, win, maz, 1 ); endif

private tb := {} , wy , len := 0

if kwm # NIL; AEval( tab , { |a| len += Len( a ) , Aadd( tb , Konwert( a, win, maz, 1 ))})
else; AEval( tab , { |a| len += Len( a ) , Aadd( tb , Konwert(a,maz,lat,.t.) )})
endif

if ton2<>0
   Tone( ton2 , 1 )
endif

if Len( tb ) <= 4 .and. len < 50
   wy := Alert( h , tb )
else
   private ekran := SaveScreen()
*   @ mr - 2 , 0 clear
   @ mr, 0 clear
   wy := Menu( tb , 1 , h ,,, 'cty' )
   wy := if( wy = NIL , 0 , wy )
   RestScreen( ,,,, ekran )
endif

return wy

*************************************************************************
* Ulepszenie standardowego 'read'
* enter - powoduje zwracanie ".t." jeûli nie byío zmian i wyjdzieno enterami

function Read( enter )

set cursor on
read
if UpDated(); wy := 2; endif
set cursor off

if enter # nil
   return LastKey() # K_ESC
else
   return !( LastKey() = K_ESC .or. !UpDated()) .or. ( LastKey() = K_PGDN )
endif

*************************************************************************
* Get ußytkownika
* x , y - wiersz i kolumna operacji
* h - komunikat przed pobranÜ wartoûciÜ
* d - 'picture' bufora
* n - numer podpowiadany
* wm = winmaz - konwert h

function Get_u( x , y , h , d , n, wm )

local ekran := SaveScreen() , dl, od, oe

od := SetKey( K_CTRL_INS,  { || ToClip()})
oe := SetKey( K_ALT_INS,   { || FromClip()})

private buf := n

h := ' ' + Konwert(h,maz,lat,.t.)

if wm # NIL
	h := Konwert( h, win, maz )
endif

if d = NIL
   dl := 0
elseif Left( d, 2 ) == '@S'
   dl := Val( SubStr( d, 3 ))
elseif Left( d, 3 ) == '@KS'
   dl := Val( SubStr( d, 4 ))
else
   dl := Len( d )
endif

dl := Len( h ) + 1 + dl

@ x - 2 , y - 3 clear to x + 2 , y + 3 + dl
@ x - 1 , y - 1 to       x + 1 , y + 1 + dl

if d = NIL; @ x , y say h get buf
else;       @ x , y say h get buf picture d
endif

Read()

SetKey( K_CTRL_INS,   od )
SetKey( K_ALT_INS,    oe )

RestScreen( ,,,, ekran )

return if( LastKey() = K_ESC , NIL , buf )

*******************************************************************************
* ustala z ußytkownikiem dzie§ ( datë ), o kt¢ry chodzi

function U_dzien( dzien , h )

private k

dzien := if( dzien = NIL , Datee() , dzien )
h := if( h = NIL , 'Czy chodzi o dzie§ : ' , h )

while .t.
      k := Alarm( h + DtoC( dzien ) , tk )
      do case
      case k = 0 ; dzien := NIL
      case k = 1 ; exit
      case k = 2 ; dzien := Get_U( 10 , 20 , 'Podaj datë :' , '99.99.99' , dzien )
      endcase
      if dzien = NIL ; exit ; endif
enddo

return dzien

*******************************************************************************
* ustala z ußytkownikiem miesiÜc, o kt¢ry chodzi

function U_miesiac( mies , h )

private k

mies := if( mies = NIL , Month( Datee() ) , mies )
h := if( h = NIL , 'Czy chodzi o' , h )

while .t.
      k := Alarm( h + ' ' + Nazwa_M( mies ) + ' ?' , tk )
      do case
      case k = 0 ; mies := NIL
      case k = 1 ; exit
      case k = 2 ; mies := Get_U( 10 , 20 , 'Podaj numer miesiÜca :' , '99' , mies )
      endcase
      if mies = NIL ; exit ; endif
enddo

return mies

*******************************************************************************
* ustala z ußytkownikiem rok, o kt¢ry chodzi

function U_rok( rok , h )

private k

rok := if( rok = NIL , Year( Datee() ) , rok )
h := if( h = NIL , 'Czy chodzi o' , h )

while .t.
      k := Alarm( h + ' ' + Str( rok , 4 ) + ' ?' , tk )
      do case
      case k = 0 ; rok := NIL
      case k = 1 ; exit
      case k = 2 ; rok := Get_U( 10 , 20 , 'Podaj wíaûciwy rok :' , '9999' , rok )
      endcase
      if rok = NIL ; exit ; endif
enddo

return rok

*******************************************************************************
* Centrowanie wsp¢írzëdnych w podanym oknie
* x,y   - lewy  g¢rny r¢g okna gí¢wnego   ( przez zmiennÜ ! )
* xx,yy - prawy dolny r¢g okna gí¢wnego   ( przez zmiennÜ ! )
* n - iloûç wierszy
* d - max díugoûç wiersza
* komentarz pomocniczy : Centra( @x , @y , @xx , @yy , n , d )

procedure Centra( x , y , xx , yy , n , d )

x += ( ( xx - x ) - n ) / 2   && centra wiersza
y += ( ( yy - y ) - d ) / 2   && centra kolumny
xx := x + n
yy := y + d

*******************************************************************************
* Procedura do wywietlania centralnie hasía w jednoliniowym oknie
* x - wiersz napisu
* y , yy - kolumny graniczne
* haslo - napis do wywietlenia
* color - 'n/w' dla 'set color to'
* czy - czy czyûciç linië wyûwietlania

function Csay( x, y, yy, haslo, color, czy )

if x = NIL; x := Row(); endif
if y = NIL; y := Col(); endif
if yy= NIL; yy:= y; endif
if haslo = NIL; haslo := ''; endif
if color # NIL; SetColor( color ); endif

haslo := Konwert(haslo,maz,lat,.t.)
if czy = NIL
   haslo := ' ' + SubStr( haslo, 1, yy - y - 2 ) + '  '
   y += ( yy - y - Len( haslo ) ) / 2
   @ x, y say haslo
else
   @ x, y say PadC( haslo, yy - y )
endif

SetColor( STC )

return haslo

*******************************************************************************
* Wycina od prawej zera po kropce z ía§cucha znak¢w uzyskanego z 'Transform'
* s - np.: '123.500'

function Zera_won( s )

if !( '.' $ s ) ; return s ; endif      && nie ma co ciÜç

private c , d := ''

while .t.
      c := Right( s , 1 )
      do case
      case c == '0' ; s := SubStr( s , 1 , Len( s ) - 1 ) ; d += ' '
      case c == '.' ; s := SubStr( s , 1 , Len( s ) - 1 ) ; s += ' ' + d ; exit
      otherwise ; s += d ; exit
      endcase
enddo

return s

*******************************************************************************

function Get_Okres( d1 , d2 , haslo , margines )

local ekran, r, rr, c, cc, ccc, cccc

if d1 = NIL; d1 := data1; endif
if d2 = NIL; d2 := data2; endif

margines := if( margines = NIL , 2 , margines )
private x := 3 , y := 0 , xx := mr , yy := mc , m := Space( margines )
private h := m + if( haslo = NIL , 'Podaj o jaki okres czasu chodzi :' , haslo ) + m

ccc := Len( h )
cccc := 13
if ValType( d1 ) == 'C'
   cccc := Len( d1 ) + 5
   ccc := Max( cccc, ccc )
endif

Centra( @x , @y , @xx , @yy , 5 , ccc )

r := x - 1
rr := xx + 1
c := y - 1
cc := yy + 1
ekran := SaveScreen( r, c, rr, cc )

@ x , y clear to xx , yy
RRamka( { x , xx } , { y , yy } )
CSay( x + 1 , y , yy , h , jasny )

x := x + 3
xx := x
Centra( @x , @y , @xx , @yy , 1 , cccc )

@ x + 1 , y say 'Od :' get d1
@ x + 2 , y say 'Do :' get d2
Read()

RestScreen( r, c, rr, cc, ekran )

if LastKey() = K_ESC
   return NIL                && poraßka
elseif ValType( d1 ) == "D"
   data1 := d1
   data2 := d2
   return 1                  && sukces
else
   globalbuf4 := d1
   globalbuf5 := d2
   return 1                  && sukces
endif

*******************************************************************************

procedure RRamka( rr , cc , s )

if s = NIL ; @ rr[ 1 ] - 1 , cc[ 1 ] - 1 to rr[ 2 ] + 1 , cc[ 2 ] + 1 double
else       ; @ rr[ 1 ] - 1 , cc[ 1 ] - 1 to rr[ 2 ] + 1 , cc[ 2 ] + 1
endif

******************************************************************************
* Uaktywnienie serii p¢l, pobranie wartoûci i wpisanie ich do bazy
* wymaga : kolumny, naglowki, szablon i opcjonalnie 'validy'
* p , k - pole poczÜtkowe i ko§cowe
* haslo - hasío w tytule ramki
* def_pos - defaultowa wiersz
* szer - wymuszanie szerokoûci tabeli
* bez # NIL => bez replace do kolumn

function U_Get_Read( p , k , haslo, def_pos, szer, bez )

local warunek := { || O_Warunku()}, indeks, max_n := 0, max_d := 0, i

p := if( p = NIL, 1, p )
k := if( k = NIL, Len( kolumny ), k )
haslo := if( haslo = NIL, '', ' ' + haslo + ' ' )
if def_pos = NIL; def_pos := 1; endif

private tab[ k - p + 1 ], byl_clr_get := .f., pos := def_pos

for i := p to k
    max_n := Max( Len( naglowki[ i ] ), max_n )
    max_d := Max( Len( szablon[ i ] ) + max_n, max_d )
next

if szer # NIL; max_d := szer
else         ; max_d += 10
endif

private x := 3 , y := 0 , xx := mr , yy := mc
Centra( @x , @y , @xx , @yy , k - p + 2 + 2 , max_d )
@ x , y clear to xx , yy
RRamka( { x , xx } , { y , yy } )
CSay( x - 1 , y , yy , haslo , jasny )

while .t.

   for i := p to k
       indeks := 1 + i - p
       tab[ indeks ] := &( kolumny[ i ] )
       haslo := PadR( StrTran( naglowki[ i ] , ';' , ' ' ) , max_n + 1 ) + ':'
       if '->' $ kolumny[ i ]
           @ x + indeks , y + 2 say haslo + ' ' + Transform( tab[ indeks ] , szablon[ i ] )
       else
           if Czy_Valid( indeks )
              @ x + indeks , y + 2 say haslo get tab[ indeks ];
              picture szablon[ i ] valid Eval( warunek )
           else
              @ x + indeks , y + 2 say haslo get tab[ indeks ];
              picture szablon[ i ]
           endif
       endif
   next
   
   i ++

   @ x + i++ - p + 1 , y + 2 say 'klawisz'
   SetColor( jasny ); ?? ' F1'; SetColor( STC ); ??' - pomoc'

   @ mr - 2, 0 clear
   Esc()
   PgDn()

   Keyboard Replicate( Chr( K_DOWN ), pos - 1 )

   Read()

   if byl_clr_get        && gdy byliûmy w help'ie i byío 'clear gets'
      byl_clr_get := .f.
      loop               && odnawiamy "get'y"
   endif

   exit

enddo

if LastKey() # K_ESC
   for i := p to k
       if !( '->' $ kolumny[ i ] )
          if !( '(' $ kolumny[ i ] )
				if bez = NIL
					replace &( kolumny[ i ]) with tab[ 1 + i - p ]
				else
					kolumny[ i ] := tab[ 1 + i - p ]
				endif
          endif
       endif
   next
	return .t.
endif

return .f.

******************************************************************************
* Obsluga tablicy 'validy' z zadaniami

function O_Warunku

local a := ReadVar(), lval, nval := 'validy'
local nr := Val( SubStr( a, 5 ))

if Type( nval ) # 'U'
   lval := Len( validy )
   if lval > 0 .and. nr > 0 .and. lval >= nr
      if validy[ nr ] # NIL
         Eval( validy[ nr ], tab[ nr ] )
      endif
   endif
endif

return .t.

******************************************************************************
* Ma sprawdzaç czy w og¢le zakíadaç 'valid'

function Czy_Valid( nr )

local nval := 'validy', lval

if Type( nval ) # 'U'
   lval := Len( validy )
   if lval > 0 .and. nr > 0 .and. lval >= nr
      if validy[ nr ] # NIL
         return .t.
      endif
   endif
endif

return .f.

******************************************************************************
* i = vp[5]
* tab_i = { 0, 1, 2, 3 }
* tab_o = { 'brak wpíywu', 'przych¢d', 'rozch¢d', 'ustawianie wartoûci' }

procedure PrintTab( i, tab_i, tab_o, dwa, dx )

local mx, k

mx := 0
AEval( tab_o, { |a| mx := Max( Len( a ), mx )})
for k := 1 to Len( tab_o ); tab_o[ k ] := PadR( tab_o[ k ], mx ); next

if ( i := AScan( tab_i, i )) = 0 && jak nie ma "i" w "tab_i"
   i := Len( tab_o )             && to pokaß ostatni element z "tab_o"
endif

Print( tab_o[ i ], dwa, dx )

******************************************************************************
* Procedura ußywana w Eval'ach, bo nie daje sië zrobiç zwykíego '?'
* a = tekst
* dwa # NIL => ??
* dx = odstëp od Row, Col

function Print( a, dwa, dx )

local x, y, t

if dx = NIL; dx := 0; endif

if Left( a, 1 ) == '#'
	a := ReadWzor( SubStr( a, 2 ))
	while !Empty( x := Val( Odetnij( @a )))
			y := Val( Odetnij( @a ))
			t := Odetnij( @a )
			@ x, y say RunCommand( t )
	enddo
else
	if dwa # NIL; ?? Space( dx ) + a
	else        ; ?  Space( dx ) + a
	endif
endif

return .t.

******************************************************************************

function Deszyfr( szyfr, klucz )

if klucz = NIL; return szyfr; endif
if klucz = 0; return szyfr; endif

private wynik := '' , i

for i := 1 to Len( szyfr )
    wynik += Chr( Asc( SubStr( szyfr , i , 1 )) - klucz )
next

return wynik

******************************************************************************
* Obsluga reakcji na F1
*   tekst - tekst do edycji
*   haslo - wyûwietlane gdy # NIL
*   plik_def - defaultowy szablon wypeínienia danymi
*   mode = NIL - 2 napisy pod ramkÜ
*   mode # NIL - 1 napis

function Read_text( tekst, haslo, plik_def, mode )

local dx := 7, dy := Memo_col
local x := Min( row() + 2 , mr - dx - 1 ) , y := ( mc - dy ) / 2
local xx := x + dx , yy := y + dy , l
local ekran := SaveScreen()

if tekst = NIL ; tekst := '' ; endif
if haslo = NIL ; haslo := '' ; endif

l := Len( haslo ) + 2

if mode = NIL
   @ rr[ 2 ] + 2, 0 clear     && wycofanie instrukcji u doíu ekranu
else
   @ mr - 2, 0 clear
endif

@ x, y clear to xx, yy
RRamka( { x, xx }, { y, yy } )
CSay( x - 1, y, yy, AllTrim( haslo ), invers )

if mode # NIL
   xx ++      && nißej napis 'Ctrl-W'
   dx ++      && ni¶ej koniec MemoEdit
endif

@ xx - 2 , y - 1 say '«'    && dodatkowe wyjaûnienia dla ußytkownika
@ xx - 2 , yy + 1 say '∂'
@ xx - 2 , y to xx - 2 , yy
SetColor( jasny )
@ xx - 1 , y say ' Ctrl-W'
SetColor( STC )

if mode = NIL         && dla dopisania przy wystawianiu faktury pomijamy 'Esc'
   ?? ' - wyjûcie z zapisem'
   SetColor( jasny )
   @ xx , y say ' Esc'
   SetColor( STC )
   ?? ' - wyjûcie bez zapisu'
else
   ?? ' - wyjûcie po wpisaniu caíej informacji'
endif

set cursor on
if Empty( tekst ) .and. plik_def # NIL
   if !File( cat_wzorow + plik_def )
      Alarm( 'Brak wzoru ' + plik_def, Ent )
   else
      tekst := MemoRead( cat_wzorow + plik_def )
   endif
endif
tekst := MemoEdit( tekst, x, y, x + dx - 3, yy )
set cursor off

RestScreen( ,,,, ekran )
LastZero()

return tekst

******************************************************************************

function ShowEkran( nazwa, r, c, h, lm )

local i, l, wzor, plik := cat_wzorow + nazwa + '.txt'
local ll := 0, li := ''

h := if( h = NIL, '' , h )

if !File( plik )
   Alarm( 'Brak wzoru ' + plik + ' !!!', Ent )
   return .f.
endif

wzor := MemoRead( plik )
l := MLCount( wzor )
if l > 2
   r := Val( MemoLine( wzor,, 1 ))
   c := Val( MemoLine( wzor,, 2 ))
   if c = 0 
      Keyboard Chr( K_ESC )
      MemoEdit( wzor, r, c, r + l - 2, mc, .f.,, mc + 1,, 3 )
      CSay( r - 2, 0, mc, h, jasny )
   else
      lm := if( lm # NIL, lm, 2 )
      for i := 1 to l - 2
          li := Space( lm ) + RTrim( MemoLine( wzor,, i + 2 )) + Space( lm )
          ll := Len( li )
          @ r + i - 1, c - lm say li
      next
      if !Empty( h )
         SetColor( jasny )
            @ r - 2, c - lm say PadC( h, ll )
         SetColor( STC )
         @ r - 1, c - lm say Space( ll )
         @ r - 3, c - lm say Space( ll )
         @ r - 4, c - lm - 1 to r + i - 1, c - lm + ll
      endif
   endif
else
   Alarm( 'BíÜd odczytu wzoru formularza : "' + nazwa + '" !!!', Ent )
   return .f.
endif

return .t.

*******************************************************************************
* Tytuí tabeli w dw¢ch liniach
* s - díuga linia
* l - max díugoûç linii
* d - delta odstëpu drugiej linii
* k - kropki dopeínienia

function Dwielinie( s, l, d, k )

local n, ss, nn, kk

d := if( d = NIL, 0, d )
s := AllTrim( s )
n := RAt( ' ', Left( s, l ))

if k = NIL
   if Len( s ) > 2 * l
		ss := s
      s := PadR( Left( s, n ), l ) + EOL
		nn := n
		n := RAt( ' ', Left( ss, n + 1 + l ))
		s += Space( d ) + PadR( SubStr( ss, nn + 1, n - nn ), l ) + EOL
		s += Space( d ) + SubStr( ss, n + 1 )
   elseif Len( s ) >  l
      s := PadR( Left( s, n ), l ) + EOL + Space( d ) + SubStr( s, n + 1 )
	else
      s := PadR( s, l )
   endif
else
   kk := Replicate( k, 50 )
   if Len( s ) > l
      s := PadR( Left( s, n ), l ) + EOL + Space( d ) + Dwielinie( SubStr( s, n + 1 ), l, d, k ) && PadR( SubStr( s, n + 1 ) + kk, l )
   else
      s := PadR( s + kk, l )
   endif
endif

return s

*******************************************************************************
* dziel 2 linie

function D2L( s, l )

return SlownieZlGr( , l,, s )

*******************************************************************************
* x - kwota
* l - granica dzielenia
* mode - typ dla "s≥ownie"
* s # NIL => nie ZlGr, tylko "s"

function SlownieZlGr( x, l, mode, s )

local w, n

w := if( s # NIL, s, ZlGr( x, if( mode = NIL, 2, mode )))
w := PadR( w, 200 )
n := RAt( ' ', Left( w, l ))

return PadR( Left( w, n ), l ) + SubStr( w, n + 1 )

*******************************************************************************
* mode = NIL, x zí. y/100
* mode = 1  , x zí.[y/100]
* mode = 2  , x zí. y gr.
* mode = 3  , x zí.[y gr.]
* mode = 4  , x zí. gr. "j.w."

function ZlGr( x, mode )

local y, z

y := ''
z := ''

do case
   case mode = NIL                         ; y := ' ' + AllS( 100 * ( x - Int( x )), '99' ); z := '/100'
   case mode = 1 .and. !( x - Int( x ) = 0); y := ' ' + AllS( 100 * ( x - Int( x )), '99' ); z := '/100'
   case mode = 2                           ; y := ' ' + Slownie( 100 * ( x - Int( x )))    ; z := ' gr.'
   case mode = 3 .and. !( x - Int( x ) = 0); y := ' ' + Slownie( 100 * ( x - Int( x )))    ; z := ' gr.'
   case mode = 4                           ; y := ' gr.'; z := ' j.w.'
endcase

return Slownie( Int( x )) + ' zí.' + y + z

*******************************************************************************
* od 0 do 999,999,999,999,999
* czesc = 1 lub 2 dotyczy do i po przecinku

Function Slownie( w , znak, czesc )

w := Grosz( w )
if w = 0.00 ; return 'zero' ; endif

if czesc = NIL; czesc := 1; endif
if czesc = 1 .and. Int( w ) = 0; return 'zero '; endif
if czesc = 2 .and. Round( w - Int( w ), 2 ) = 0; return 'zero '; endif

private j := { 'jeden' , 'dwa' , 'trzy' , 'cztery' , 'piëç' , 'szeûç' , 'siedem' , 'osiem' , 'dziewiëç' }
private n := { 'jedenaûcie' , 'dwanaûcie' , 'trzynaûcie' , 'czternaûcie' , 'piëtnaûcie' , 'szesnaûcie' , 'siedemnaûcie' , 'osiemnaûcie' , 'dziewiëtnaûcie' }
private d := { 'dziesiëç' , 'dwadzieûcia' , 'trzydzieûci' , 'czterdzieûci' , 'piëçdziesiÜt' , 'szeûçdziesiÜt' , 'siedemdziesiÜt' , 'osiemdziesiÜt' , 'dziewiëçdziesiÜt' }
private s := { 'sto' , 'dwieûcie' , 'trzysta' , 'czterysta' , 'piëçset' , 'szeûçset' , 'siedemset' , 'osiemset' , 'dziewiëçset' }

private t  := { 'tysiÜc' , 'tysiÜce' , 'tysiëcy' }
private ml := { 'milion' , 'miliony' , 'milion¢w' }
private md := { 'miliard' , 'miliardy' , 'miliard¢w' }
private bl := { 'bilion' , 'biliony' , 'bilion¢w' }

private rzedy := { bl , md , ml , t , NIL }
private trojki[ Len( rzedy ) ]
trojki := AFill( trojki , '' )

private liczba, k, i, trojka

if czesc = 1
   liczba := AllTrim( Left( Transform( w , '999999999999999.999' ), 15 ))
else
   liczba := Right( Transform( w - Int( w ), '99.99' ), 2 )
endif

k := Len( liczba ) / 3              && iloûç tr¢jek
k := if( k > Int( k ) , Int( k ) + 1 , Int( k ) )
k := if( k > Len( trojki ) , Len( trojki ) , k )      && max tr¢jek

for i := 1 to k
    trojki[ Len( trojki ) + 1 - i ] := Right( liczba , 3 )
    liczba := SubStr( liczba , 1 , Len( liczba ) - 3 )
next

liczba := ''
for i := 1 to Len( trojki ) ; liczba += Dekoduj( rzedy[ i ] , trojki[ i ] ) ; next

*if w > 11               &&  usuniëcie jedynki na poczÜtku okreûlenia síownego
*   if At( j[ 1 ] + ' ' , liczba ) = 1
*      liczba := SubStr( liczba , Len( j[ 1 ] ) + 2 )
*   endif
*endif

if znak # NIL
   if w < 0 ; liczba := 'minus ' + liczba
   else     ; liczba := 'plus ' + liczba
   endif
endif

return AllTrim( liczba )

*******************************************************************************

Function Dekoduj( tab , kod )

if Len( kod ) = 0 ; return '' ; endif

private c1 , c2 , c3 , wynik := ''

c3 := Val( Right( kod , 1 ) ) ; kod := SubStr( kod , 1 , Len( kod ) - 1 )
c2 := Val( Right( kod , 1 ) ) ; kod := SubStr( kod , 1 , Len( kod ) - 1 )
c1 := Val( Right( kod , 1 ) )

wynik += if( c1 = 0 , '' , s[ c1 ] + ' ' )  && setki

do case
case c2 = 0
case c2 = 1 ; wynik += if( c3 = 0 , d[ c2 ] , n[ c3 ] ) + ' ' && nastki
otherwise   ; wynik += d[ c2 ] + ' '                          && dzesiÜtki
endcase

wynik += if( c3 = 0 .or. c2 = 1 , '' , j[ c3 ] + ' ' )  && jednoûci

if c1 + c2 + c3 # 0       && dopisek o rzëdzie wielkoûci
   c3 := Str( c3 , 1 )
   do case
   case tab = NIL
   case Str( c2 , 1 ) = '1' ; wynik += tab[ 3 ] + ' '    && nastki
   case c3 = '1' ; wynik += if( c1 + c2 = 0 , tab[ 1 ] , tab[ 3 ] ) + ' '
   case c3 $ '234' ; wynik += tab[ 2 ] + ' '
   otherwise ; wynik += tab[ 3 ] + ' '
   endcase
endif

return wynik

*******************************************************************************

procedure CosZEkranem

private o, me := 'ekran.txt'

o := Alert( 'Co robiç ?', { 'Plik na ekran', 'Ekran do pliku' })

do case
case o = 0; return
case o = 1; return
case o = 2; EkranToPlik( ,,,,, .t. )
endcase

Inkey( 0 )

return

#include 'common.ch'
******************************************************************************
* Zapisanie fragmentu ekranu do wybranego pliku

function EkranToPlik( a, b, c, d, plik, klawisze )

local ekran

default a to 0,;
        b to 0,;
        c to mr,;
        d to mc,;
        plik to me,;
        klawisze to .f.

if klawisze
   MoveCursor( @a, @b ); Tone( 200, 1 )
   MoveCursor( @c, @d ); Tone( 100, 1 )
endif

ekran := Prostokat( a, b, c, d ) + SaveScreen( a, b, c, d )

return MemoWrit( plik, ekran )

******************************************************************************
* Odczytanie fragmentu ekranu z wybranego pliku

function PlikToEkran( plik )

local a, b, c, d, p := MemoRead( cat_ekranow + plik )

a := Val( SubStr( p, 1, 2 ))
b := Val( SubStr( p, 3, 2 ))
c := Val( SubStr( p, 5, 2 ))
d := Val( SubStr( p, 7, 2 ))

p := SubStr( p, 9 )
p := Konwert(p,maz,lat,.t.)
return RestScreen( a, b, c, d, p )

******************************************************************************

procedure MoveCursor( a, b )

local end := .f., k := SetCursor( 3 )

while !end
      @ a, b say ''
      z := Inkey( 0 )
      do case
      case z = K_RIGHT; if( b < mc, b++, )
      case z = K_LEFT ; if( b > 0, b--, )
      case z = K_UP   ; if( a > 0, a--, )
      case z = K_DOWN ; if( a < mr, a++, )
      case z = K_ESC  ; end := .t.
      case z = K_ENTER; end := .t.
      endcase
enddo
SetCursor( k )

******************************************************************************

procedure Prostokat( a, b, c, d )
return Str( a, 2 ) + Str( a, 2 ) + Str( a, 2 ) + Str( a, 2 )

******************************************************************************
* Konwersja miëdzy standardami polskich znak¢w (maz, lat, win)
* s - zmieniany string
* zy - z jakiego standardu (lat)
* na - na jaki standard (maz)

function Konwert( s, zy, na, musi, html )

local i, n, z, s0
local cpi10 := '12'

if musi = NIL
	if !konwertON .or. ( zy = NIL .and. szy = NIL .and. na = NIL .and. sna = NIL )
		return s
	endif
endif

if ValType( s ) # 'C'
	return s
endif

if zy = NIL
   if szy # NIL
      zy := szy
   endif
endif

if na = NIL
   if sna # NIL
      na := sna
   endif
endif

s0 := ''
for i := 1 to Len( s )
    z := SubStr( s, i, 1 )         && znak z ciÜgu
    n := At( z, zy )               && czy jest z "lat"
    if n > 0                       && TAK
       z := SubStr( na, n, 1 )     && pobierz odpowiednik "z" z "maz"
    else
       if html # NIL
          if z = ' '; z := '&nbsp;'; endif
          if z = Chr(13); z := '<br>' + Chr(13); endif
          if z = Chr(27)
             i++
             z := SubStr( s, i, 1 )         && znak z ciÜgu
             z2:= SubStr( s, i + 1, 1 )     && znak z ciÜgu
             if z + z2 = '@' + Chr(15); i++; z:=''; endif
             if z = '@'; z := '<font style="font-size:' + cpi10 + '">'; endif
             if z + z2 = 'W1'; i++; z := '<b><font style="font-size:20">'; endif
             if z + z2 = 'W0'; i++; z := '</font></b>'; endif
             if z = 'G'; z := '<b>'; endif
             if z = 'H'; z := '</b>'; endif
             if z = 'M'; z := ''; endif
             if z = 'P'; z := ''; endif
          endif
          if z = Chr(18); z := '<font style="font-size:17">'; endif
          if z = Chr(15); z := '<font style="font-size:' + cpi10 + '">'; endif
          if z = Chr(12); z := '<div style="height:1px"></div><div style="page-break-after: always; height:1px"></div>'; endif
       endif
    endif
    s0 += z                        && doíÜcz do ciÜgu wynikowego
next


return s0

******************************************************************************
* Symulacja naciûniëcia sekwencji klawiszy
* s = string normalny
* s2= string przy wyjûciu PgUp

procedure PressKey( s, s2 )

if LastKey() = K_ESC; return; endif
if LastKey() = K_PGUP; s := s2; endif           && druga moßliwoûç

s := StrTran( s, 'ESC' , Chr( K_ESC ))          && prosty interpreter
s := StrTran( s, 'ENTER' , Chr( K_ENTER ))
s := StrTran( s, 'TAB' , Chr( K_TAB ))
s := StrTran( s, 'F1' , Chr( K_F1 ))
s := StrTran( s, 'g¢ra' , Chr( K_UP ))
s := StrTran( s, 'd¢í'  , Chr( K_DOWN ))
s := StrTran( s, 'prawo', Chr( K_RIGHT ))
s := StrTran( s, 'lewo' , Chr( K_LEFT ))

Keyboard s

******************************************************************************
