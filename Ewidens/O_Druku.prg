******************************************************************************
*                 O B S L U G A   D R U K A R K I
******************************************************************************
* Nr 68
* m # NIL => pyta o druk i obejrzenie
* x = NIL => przerabia wed≥ug wskazaÒ w nawiasach, np.: [111]

function Druk( plik, m, x )

local drukarka := File( drukarkaPA + 'drukarka.exe' )
local plik_ini, tekst_ini

if !prn2file; return; endif

mClose()    && dla pewnoûci

if !File( plik ) ; Alarm( 'Nie ma zbioru do wydruku !!!' , Ent ) ; return NIL ; endif

if x = NIL
   x := Przerob( plik, m )
   do case
   case x = NIL; return NIL   && przerobií, ale nie wydrukowaí
   case x = .t.; return 1     && przerobií i wydrukowaí
   endcase
   x := NIL          && nie przerobií, wiëc symulacja, ße nie miaí przerabiaç
endif

private opc := { 'Drukowaç' , 'Obejrzeç przed drukowaniem' }
private odp := 0 , has

if m # NIL
   while .t.

         LastZero()
         if x = NIL; has := 'Przygotuj drukarkë i wí¢ß odpowiedni papier'
         else
            if stronyON .and. !Empty( strony )
               has := 'Przygotuj drukarkë i papier do druku stron: ' + AllTrim( strony )
            else
               has := 'Przygotuj drukarkë i papier do druku ' + AllS( x ) + ' stron' + if( x = 1, 'y', '' )
            endif
         endif

*         if m = 1 ; has := 'Wí¢ß pojedynczÜ kartkë papieru do drukarki !!!'
*         else     ; has := 'Przygotuj drukarkë i wí¢ß odpowiedni papier !!!'
*         endif

         odp := Alarm( has , opc )

         do case
         case odp = 0; strony := Space( 80 ); return NIL
         case odp = 1; strony := Space( 80 ); exit
         case odp = 2; Opis( plik , 1 )
         endcase
   enddo
endif

private m_plik := plik

if drukarka .and. drukarkaON

   tekst_ini := ''
   plik_ini := FileIni( plik )                  && namierzanie special ini
   if Empty( plik_ini )                         && brak special ini
      plik_ini := 'wydruk.ini'                  && wiëc standard ini
   endif

   m_plik := cat_wzorow + plik_ini
   if File( m_plik )
      tekst_ini := MemoRead( m_plik )           && stara zawartoûç ini
      RunCommand( 'run copy ' + m_plik + ' ' + drukarkaWY + 'wydruk.ini >nul' )
   endif

   m_plik := plik
   RunCommand( 'run copy ' + m_plik + ' ' + drukarkaWY + 'wydruk.txt >nul' )

if File( drukarkaST + 'start.exe' )
   RunCommand( 'run ' + drukarkaST + 'start.exe /w ' + drukarkaPA + 'drukarka.exe' )
else
   RunCommand( 'run ' + drukarkaPA + 'drukarka.exe' )
endif

   if !Empty( tekst_ini )
      if !( tekst_ini == MemoRead( drukarkaWY + 'wydruk.ini' )) && zmiana
         m_plik := plik_ini
         plik_ini := FileIni( plik, 1 )
         if m_plik == plik_ini        && plik og¢lny i szczeg¢lny sÜ takie same
            m_plik := cat_wzorow + m_plik
            RunCommand( 'run copy ' + drukarkaWY + 'wydruk.ini ' + m_plik + ' >nul' )
*           run copy c:\arrakis\wydruki\wydruk.ini &m_plik >nul  && nowa zawartoûç ini
         else                         && plik og¢lny i szczeg¢lny sÜ r¢ßne
            plik := Alarm( 'Wybierz plik do zapisu nowych ustawie§ wydruku:',;
                         { 'szczeg¢lny: ' + plik_ini, 'og¢lny: ' + m_plik })
            if plik > 0
               if plik = 1; m_plik := plik_ini; endif
               m_plik := cat_wzorow + m_plik
               RunCommand( 'run copy ' + drukarkaWY + 'wydruk.ini ' + m_plik + ' >nul' )
*              run copy c:\arrakis\wydruki\wydruk.ini &m_plik >nul  && nowa zawartoûç ini
            endif
         endif
      endif
   endif

   set cursor on
   set cursor off

   return 1             && success !!!
endif

if !Jest_Drukarka() ; return NIL ; endif

*if m # NIL                 && wymuszone drukowanie natychmiastowe
   set console off
   set printer on

   while .t.
         begin sequence
               run copy &m_plik prn:>nul  && wydruk pliku
         recover                          && i tak g¢wno nie dziaía !!!!!
               if Alarm( 'BíÜd przy drukowaniu !!!',;
                       { 'Powt¢rzyç operacjë' , 'Przestaç' } ) = 1
                  Alarm( 'WyíÜcz i wíÜcz drukarkë !!! Przygotuj odpowiedni papier !!!' , Ent )
                  loop
               endif
         end
         exit
   enddo

   set printer off
   set console on
   return 1             && success !!!
*endif

private oo, g1 := '', g2 := '', gest := {}

Typ_drukarki()

g1 := Rodzaj_pisma()
if Przerwa()             && sprawdzamy Esc
   return NIL
endif

if typ_drukarki = 'SEIKO'
   g2 := Rodzaj_gestosci()
   if Przerwa()             && sprawdzamy Esc
      return NIL
   endif
endif

@ 3 , 0 clear
@ 11 , 3 to 13 , 44 + Len( plik )
@ 12 , 5 say 'Drukuje sië zbi¢r ' + plik

set console off
set printer on

?? chr( 27 ) + '@'                      && inicjowanie drukarki
?? chr( 27 ) + chr( 116 ) + chr( 0 )    && tryb sterowania standardowy
?? Chr( 27 ) + 'U0'        && Bidirectional printing

?? g1       && kroj pisma
?? g2       && gestosc pisma

?? chr( 27 ) + 't1'        && IBM character set

type ( plik ) to printer                && wydruk pliku

?? chr( 27 ) + '@'                      && reinicjowanie drukarki

set printer off
set console on

return 1

******************************************************************************

function Rodzaj_pisma

local rodz := {} , oo := 3

Aadd( rodz , 'Elite         - normalny' )
Aadd( rodz , 'Proportional  - proporcjonalny' )
Aadd( rodz , 'Condensed     - zagëszczony' )
Aadd( rodz , 'Emphasized    - pogrubiony' )
Aadd( rodz , 'Double Strike - dwukrotnie pisany' )
Aadd( rodz , 'Double width  - podw¢jnej szerokoûci' )
Aadd( rodz , 'Italic        - pochylony' )
Aadd( rodz , 'Underline     - podkreûlony' )

oo := Menu( rodz , 3 , 'Podaj rodzaj pisma :' )

return if( oo = NIL , '' , Chr( 27 ) + Chr( 33 ) + Chr( 2 ** ( oo - 1 ) ) )

*******************************************************************************

function Rodzaj_gestosci

local gest := {} , oo := 1

Aadd( gest , 'Bardziej gësty' )
Aadd( gest , 'Mniej gësty' )

if ( oo := Menu( gest , oo , 'Podaj gëstoûç wydruku :' )) = NIL
   return ''
endif

return if( oo = 1, chr( 27 ) + chr( 77 ) , chr( 27 ) + chr( 80 ) )

******************************************************************************

procedure Typ_drukarki

public typ_drukarki := Space( 40 )
private ekran

if File( 'drukarka.mem' )
   Restore from drukarka Additive
   return
endif

ekran := savescreen()
cls
@ 10, 5 say 'Podaj nazwë drukarki :' get typ_drukarki picture '@K'
Read()
restscreen( ,,,, ekran )

do case
case 'STAR' $ Upper( typ_drukarki )  ; typ_drukarki := 'STAR'
case 'SEIKO' $ Upper( typ_drukarki ) ; typ_drukarki := 'SEIKO'
endcase

Save All Like typ_dr* to drukarka

****************************************************************************
* h - hasío

FUNCTION Jest_Drukarka( h )

local ekran

if h = NIL; h := ''; endif

set device to screen

while !IsPrinter()
   ekran := SaveScreen()
   @ 0,0 clear
   CSay( 10, 0, mc, 'WíÜcz drukarkë i ' + Enter )
   CSay( 12, 0, mc, 'Esc - rezygnacja z drukowania' + h )
   wait ''
   if Lastkey()=27
      RestScreen( ,,,, ekran )
      return .f.
   endif
   RestScreen( ,,,, ekran )
enddo

return .t.

**************************************************************************

procedure FillStr( str, strP, strS, strK, maxCialo, dotad_wydr, r1, r2 )

local i, s, x, n, nn, c, cc

ON( 'DRUK_STR',,,, .t. )
ON( 'DRUK_PRE' )
i := 1
n := 0
c := 0
cc := 0
while !Eof()
		if RecNo() >= r1; exit; endif
		skip
enddo
while !Eof()
      s := if( i = 1, Str( str, 3 ), '' )
      x := TRESC
      if ( strP .and. !( SubStr( TYP, 1, 1 ) == ' ' )) .or.;
         ( strS .and. !( SubStr( TYP, 2, 1 ) == ' ' )) .or.;
         ( strK .and. !( SubStr( TYP, 3, 1 ) == ' ' ))

         ok := .t.
         do case
         case !( '2' $ TYP ); n ++  && nie ciaío
         case maxCialo = NIL        && badamy granice ciaía
            c ++
            ok := ( c > dotad_wydr )
            if ok; cc ++; endif
         case maxCialo # NIL        && mamy juß granice ciaía
            c ++
            ok := (( c > dotad_wydr ) .and. ( c - dotad_wydr <= maxCialo ))
            if ok; cc ++; endif
         endcase

         if ok
            if nn = NIL .and. '3' $ TYP    && zaraz bëdzie downstopka
               nn := DRUK_STR->LINIA       && zapamiëtaj linië przed downstopkÜ
            endif
            AppendRecord( 'DRUK_STR', { Str((( str - 1 ) * WydDlugosc ) + i++, 9 ), s, x })
         endif

      endif
		if RecNo() >= r2; exit; endif
      skip
enddo

if maxCialo # NIL
   if nn = NIL                 && brak downstopki
      nn := DRUK_STR->LINIA    && robimy odstëp po ostatniej linii
   endif
   Select( 'DRUK_STR' )
   x := WydDlugosc - LastRec()      && taki dußy
   for i := 1 to x
       AppendRecord( 'DRUK_STR', { Left( nn, 9 ) + Chr( 47 + i ), '', '' })
   next
endif

return cc && if( maxCialo = NIL, c, cc )    && iloûç linii ciaía teoria, praktyka

**************************************************************************

procedure Przerob( plik, m )

local bb := Alias(), i, dane, x, s, n1, n2, str, strP, strS, strK, n, ipcdw, r, t, j
local drukstr, frag, fragON, cosbylo := .f., segment, segmenty := {}, r1, r2

if !WydLamany; return .f.; endif

if !File( plik ); return .f.; endif

dane := MemoRead( plik )
n1 := At( '[', dane )
n2 := At( ']', dane )
if n1 = 0 .or. n2 = 0; return .f.; endif      && brak kod¢w status¢w

Czek( 1 )

ON( 'DRUK_PRE',,,, .t. )
s := ''
t := .f.
j := .f.
for i := 1 to MLCount( dane, dl_memo )
    x := MemoLine( dane, dl_memo, i )
    n1 := At( '[', x )
    n2 := At( ']', x )
    if n1 # 0 .and. n2 # 0
       s := SubStr( x, n1 + 1, n2 - n1 - 1 )          && status
       x := Left( x, n1 - 1 ) + SubStr( x, n2 + 1 )   && linia bez statusu
    endif
    AppendRecord(, { Str( i, 9 ), s, x })
	if '3' $ s
		t := .t.
		if Empty( x )									&& trÛjkowy jest pusty
			r := RecNo()
		endif
	endif
	if '1' $ s											&& a potem znÛw jedynkowy
		if t												&& po trÛjkowym
			t := .f.										&& znÛw gotÛw na nastÍpnπ takπ sytuacjÍ
			if r = ( RecNo() - 1 )
				Aadd( segmenty, RecNo() - 2 )			&& nowy segment
			else
				Aadd( segmenty, RecNo() - 1 )			&& nowy segment
			endif
		endif
		if r # NIL										&& by≥ trÛjkowy pusty
			DBGoTo( r )									&& to skasuj tamten trÛjkowy
			BDelete()
			r := NIL										&& znÛw gotÛw na nastÍpnπ takπ akcjÍ
		endif
	endif
next

ON( 'DRUK_POS',,,, .t. )

r2 := 0
segment := 0
while segment <= Len( segmenty )

if segment > 0
	DRUK_POS->TRESC := RTrim( DRUK_POS->TRESC ) + EJE	&& koniec segmentu = EJECT
endif

r1 := r2 + 1
if ( Len( segmenty ) >= ( segment + 1 ))
	r2 := segmenty[ segment + 1 ]				&& poúredni segment
else
	r2 := DRUK_PRE->( LastRec())				&& ostatni segment
endif

i := 0                                     && dotÜd nic nie wydrukowano
str := 1

while .t.

strP := ( str = 1 )
strK := .t.                                   && moße to ostatnia strona?
strS := !strP .and. !strK
ipcdw := FillStr( str, strP, strS, strK,, i, r1, r2 ) && iloûç pozycji ciaía do wydruku
if ( DRUK_STR->( LastRec()) > WydDlugosc )
   strK := .f.                                && jednak nie ostatnia strona
   strS := !strP .and. !strK
   ipcdw := FillStr( str, strP, strS, strK,, i, r1, r2 ) && pozycji ciaía do wydruku
endif

n := DRUK_STR->( LastRec()) - ipcdw      && iloûç pozycji nieciaía

i += FillStr( str, strP, strS, strK, WydDlugosc - n, i, r1, r2 )

KopiaRec( 'DRUK_STR', 'DRUK_POS',, .t. )

if strK; exit; endif

str ++

enddo

segment ++
enddo

*strK := ( ipcw >= ipcdw )  && iloûç pozycji ciaía wydrukowana jest >=

Zwolnij( 'DRUK_STR' )
Zwolnij( 'DRUK_PRE' )

if stronyON .and. str > 1
   Czek( 0 )
   strony := PadR( '1-'+ AllS( str ), 80 )
   if NIL = ( strony := Get_U( 17, 10, 'Strony do wydruku:', '@KS30', strony ))
      strony := Space( 80 )
      return .f.
   endif
   Czek( 1 )
endif

mOpen( plik, .t. )
Select( 'DRUK_POS' )
DBSetOrder( 0 )
DBGoTop()

private strona := 1, h1, h2, cs, csp, cs1, cs2, cnrs1, cnrs2
h1 := Konwert( 'Przeniesienie na stronë' )
h2 := 'Przeniesienie ze strony'
drukstr := DrukStr( strona, strony )
fragON := !Empty( strony )             && moßliwoûç fragmentarycznego druku
while !Eof()
      if Empty( TYP )
         if drukstr
            ?? EOL
         endif
      else
         strona := Val( TYP )
         cs := AllS( strona )
         csp:= AllS( strona - 1 )
         cnrs1 := 'Strona Nr ' + csp + '. '
         cnrs2 := 'Strona Nr ' + cs + '. '
         cs1 := ' Nr ' + cs
         cs2 := ' Nr ' + csp
         if !fragON
            ?? RunCommand( if( strona = 1, WydInit, WydPost ),,, 1 )
         else
            frag := RunCommand( if( strona = 1, WydInit, WydPost ),,, 1 )
            if DrukStr( strona - 1, strony )
               ?? Left( frag, At( EJE, frag ))
            endif
            if drukstr := DrukStr( strona, strony )
               frag := SubStr( frag, At( EJE, frag ) + 1 )
               if !cosbylo
                  cosbylo := .t.
                  if Left( frag, 2 ) == EOL; frag := SubStr( frag, 3 ); endif
               endif
               ?? frag
            endif
         endif
      endif
      if drukstr
			if segment <= 1
	         ?? StrTran( RTrim( TRESC ), EJE, '' )
			else
	         ?? RTrim( TRESC )
			endif
      endif
*      if KoniecStr( strona, strony ); exit; endif
      skip
enddo
if DrukStr( strona, strony )
   ?? RunCommand( WydDone )
endif
mClose()
Zwolnij( 'DRUK_POS' )
Czek( 0 )

x := Druk( plik, m, strona )
if x # NIL; x := .t.; endif

Jest_baza( bb )

return x

**************************************************************************
* Szuka podobnego '.ini' z dokíadnoûciÜ do trzech znak¢w z lewej
* bez obcinania i sprawdzania

function FileIni( plik, bez )

local i, pli

if 0 # ( i := RAt( '\', plik ))
   plik := SubStr( plik, i + 1 )
endif

if 0 # ( i := RAt( ':', plik ))
   plik := SubStr( plik, i + 1 )
endif

if 0 # ( i := At( '.', plik ))
   plik := Left( plik, i - 1 )
endif

if bez # NIL
   return plik + '.ini'
endif

i := Len( plik )
while i >= 2
      pli := cat_wzorow + Left( plik, i ) + '.ini'
      if File( pli )
         return Left( plik, i ) + '.ini'
      endif
      i--
enddo

return ''

**************************************************************************
