******************************************************************************
*                 O B S L U G A   D R U K A R K I
******************************************************************************
* Nr 68
* m # NIL => pyta o druk i obejrzenie
* x = NIL => przerabia wed�ug wskaza� w nawiasach, np.: [111]

function Druk( plik, m, x )

local drukarka := File( drukarkaPA + 'drukarka.exe' )
local plik_ini, tekst_ini
local doIE:=.f.
local doPDF:=.f.

if !prn2file; return; endif

mClose()    && dla pewno�ci

if !File( plik ) ; Alarm( 'Nie ma zbioru do wydruku !!!' , Ent ) ; return NIL ; endif

if x = NIL
   x := Przerob( plik, m )
   do case
   case x = NIL; return NIL   && przerobi�, ale nie wydrukowa�
   case x = .t.; return 1     && przerobi� i wydrukowa�
   endcase
   x := NIL          && nie przerobi�, wi�c symulacja, �e nie mia� przerabia�
endif

if File(StrTran(plik,'.wyd','.ht'))
   doIE:=.t.
   if File('\Arrakis\Wydruki\DrukPDF.bat') .and. File('\Arrakis\Wydruki\PDF.exe')
      doPDF:=.t.
      private opc := { 'Drukowa�' , 'Obejrze� przed drukiem', 'Druk do PDF', 'Druk przez IE' }
   else
      private opc := { 'Drukowa�' , 'Obejrze� przed drukowaniem', 'Druk przez IE' }
   endif
else
   if File('\Arrakis\Wydruki\DrukPDF.bat') .and. File('\Arrakis\Wydruki\PDF.exe')
      doPDF:=.t.
      private opc := { 'Drukowa�' , 'Obejrze� przed drukiem', 'Druk do PDF' }
   else
      private opc := { 'Drukowa�' , 'Obejrze� przed drukowaniem' }
   endif
endif

private odp := 0 , has

if m # NIL
   while .t.

         LastZero()
         if x = NIL; has := 'Przygotuj drukark� i w��� odpowiedni papier'
         else
            if stronyON .and. !Empty( strony )
               has := 'Przygotuj drukark� i papier do druku stron: ' + AllTrim( strony )
            else
               has := 'Przygotuj drukark� i papier do druku ' + AllS( x ) + ' stron' + if( x = 1, 'y', '' )
            endif
         endif

*         if m = 1 ; has := 'W��� pojedyncz� kartk� papieru do drukarki !!!'
*         else     ; has := 'Przygotuj drukark� i w��� odpowiedni papier !!!'
*         endif

         odp := Alarm( Konwert(has,maz,lat,.t.) , opc )

         do case
         case odp = 0; strony := Space( 80 ); return NIL
         case odp = 1; strony := Space( 80 ); exit
         case odp = 2; Opis( plik , 1 )
         case odp = 3 .and. doPDF
               m_plik := plik
               RunCommand( 'run copy ' + m_plik + ' \Arrakis\Wydruki\wydruk.txt >nul' )
               Przetworz( plik )
               RunCommand( 'run copy ' + m_plik + ' \Arrakis\Wydruki\wydruk.htm >nul' )
               RunCommand( 'run \Arrakis\Wydruki\DrukPDF.bat' )
               return NIL
         case (odp = 3 .and. !doPDF) .or. odp=4
               ExportIE(StrTran(plik,'.wyd','.ht'))
               RunCommand('run iexplore.exe file:///C:/wydruk.htm')   //+StrTran(plik,'.wyd','.htm'))
         endcase
   enddo
endif

private m_plik := plik

if drukarka .and. drukarkaON

   tekst_ini := ''
   plik_ini := FileIni( plik )                  && namierzanie special ini
   if Empty( plik_ini )                         && brak special ini
      plik_ini := 'wydruk.ini'                  && wi�c standard ini
   endif

   m_plik := cat_wzorow + plik_ini
   if File( m_plik )
      tekst_ini := MemoRead( m_plik )           && stara zawarto�� ini
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
         if m_plik == plik_ini        && plik og�lny i szczeg�lny s� takie same
            m_plik := cat_wzorow + m_plik
            RunCommand( 'run copy ' + drukarkaWY + 'wydruk.ini ' + m_plik + ' >nul' )
*           run copy c:\arrakis\wydruki\wydruk.ini &m_plik >nul  && nowa zawarto�� ini
         else                         && plik og�lny i szczeg�lny s� r��ne
            plik := Alarm( 'Wybierz plik do zapisu nowych ustawie� wydruku:',;
                         { 'szczeg�lny: ' + plik_ini, 'og�lny: ' + m_plik })
            if plik > 0
               if plik = 1; m_plik := plik_ini; endif
               m_plik := cat_wzorow + m_plik
               RunCommand( 'run copy ' + drukarkaWY + 'wydruk.ini ' + m_plik + ' >nul' )
*              run copy c:\arrakis\wydruki\wydruk.ini &m_plik >nul  && nowa zawarto�� ini
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
         recover                          && i tak g�wno nie dzia�a !!!!!
               if Alarm( 'B��d przy drukowaniu !!!',;
                       { 'Powt�rzy� operacj�' , 'Przesta�' } ) = 1
                  Alarm( 'Wy��cz i w��cz drukark� !!! Przygotuj odpowiedni papier !!!' , Ent )
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
@ 12 , 5 say 'Drukuje si� zbi�r ' + plik

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
Aadd( rodz , 'Condensed     - zag�szczony' )
Aadd( rodz , 'Emphasized    - pogrubiony' )
Aadd( rodz , 'Double Strike - dwukrotnie pisany' )
Aadd( rodz , 'Double width  - podw�jnej szeroko�ci' )
Aadd( rodz , 'Italic        - pochylony' )
Aadd( rodz , 'Underline     - podkre�lony' )

oo := Menu( rodz , 3 , 'Podaj rodzaj pisma :' )

return if( oo = NIL , '' , Chr( 27 ) + Chr( 33 ) + Chr( 2 ** ( oo - 1 ) ) )

*******************************************************************************

function Rodzaj_gestosci

local gest := {} , oo := 1

Aadd( gest , 'Bardziej g�sty' )
Aadd( gest , 'Mniej g�sty' )

if ( oo := Menu( gest , oo , 'Podaj g�sto�� wydruku :' )) = NIL
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
@ 10, 5 say 'Podaj nazw� drukarki :' get typ_drukarki picture '@K'
Read()
restscreen( ,,,, ekran )

do case
case 'STAR' $ Upper( typ_drukarki )  ; typ_drukarki := 'STAR'
case 'SEIKO' $ Upper( typ_drukarki ) ; typ_drukarki := 'SEIKO'
endcase

Save All Like typ_dr* to drukarka

****************************************************************************
* h - has�o

FUNCTION Jest_Drukarka( h )

local ekran

if h = NIL; h := ''; endif

set device to screen

while !IsPrinter()
   ekran := SaveScreen()
   @ 0,0 clear
   CSay( 10, 0, mc, 'W��cz drukark� i ' + Enter )
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
         case !( '2' $ TYP ); n ++  && nie cia�o
         case maxCialo = NIL        && badamy granice cia�a
            c ++
            ok := ( c > dotad_wydr )
            if ok; cc ++; endif
         case maxCialo # NIL        && mamy ju� granice cia�a
            c ++
            ok := (( c > dotad_wydr ) .and. ( c - dotad_wydr <= maxCialo ))
            if ok; cc ++; endif
         endcase

         if ok
            if nn = NIL .and. '3' $ TYP    && zaraz b�dzie downstopka
               nn := DRUK_STR->LINIA       && zapami�taj lini� przed downstopk�
            endif
            AppendRecord( 'DRUK_STR', { Str((( str - 1 ) * WydDlugosc ) + i++, 9 ), s, x })
         endif

      endif
		if RecNo() >= r2; exit; endif
      skip
enddo

if maxCialo # NIL
   if nn = NIL                 && brak downstopki
      nn := DRUK_STR->LINIA    && robimy odst�p po ostatniej linii
   endif
   Select( 'DRUK_STR' )
   x := WydDlugosc - LastRec()      && taki du�y
   for i := 1 to x
       AppendRecord( 'DRUK_STR', { Left( nn, 9 ) + Chr( 47 + i ), '', '' })
   next
endif

return cc && if( maxCialo = NIL, c, cc )    && ilo�� linii cia�a teoria, praktyka

**************************************************************************

procedure Przerob( plik, m )

local bb := Alias(), i, dane, x, s, n1, n2, str, strP, strS, strK, n, ipcdw, r, t, j
local drukstr, frag, fragON, cosbylo := .f., segment, segmenty := {}, r1, r2

if !WydLamany; return .f.; endif

if !File( plik ); return .f.; endif

dane := MemoRead( plik )
n1 := At( '[', dane )
n2 := At( ']', dane )
if n1 = 0 .or. n2 = 0; return .f.; endif      && brak kod�w status�w

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
		if Empty( x )									&& tr�jkowy jest pusty
			r := RecNo()
		endif
	endif
	if '1' $ s											&& a potem zn�w jedynkowy
		if t												&& po tr�jkowym
			t := .f.										&& zn�w got�w na nast�pn� tak� sytuacj�
			if r = ( RecNo() - 1 )
				Aadd( segmenty, RecNo() - 2 )			&& nowy segment
			else
				Aadd( segmenty, RecNo() - 1 )			&& nowy segment
			endif
		endif
		if r # NIL										&& by� tr�jkowy pusty
			DBGoTo( r )									&& to skasuj tamten tr�jkowy
			BDelete()
			r := NIL										&& zn�w got�w na nast�pn� tak� akcj�
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
	r2 := segmenty[ segment + 1 ]				&& po�redni segment
else
	r2 := DRUK_PRE->( LastRec())				&& ostatni segment
endif

i := 0                                     && dot�d nic nie wydrukowano
str := 1

while .t.

strP := ( str = 1 )
strK := .t.                                   && mo�e to ostatnia strona?
strS := !strP .and. !strK
ipcdw := FillStr( str, strP, strS, strK,, i, r1, r2 ) && ilo�� pozycji cia�a do wydruku
if ( DRUK_STR->( LastRec()) > WydDlugosc )
   strK := .f.                                && jednak nie ostatnia strona
   strS := !strP .and. !strK
   ipcdw := FillStr( str, strP, strS, strK,, i, r1, r2 ) && pozycji cia�a do wydruku
endif

n := DRUK_STR->( LastRec()) - ipcdw      && ilo�� pozycji niecia�a

i += FillStr( str, strP, strS, strK, WydDlugosc - n, i, r1, r2 )

KopiaRec( 'DRUK_STR', 'DRUK_POS',, .t. )

if strK; exit; endif

str ++

enddo

segment ++
enddo

*strK := ( ipcw >= ipcdw )  && ilo�� pozycji cia�a wydrukowana jest >=

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
h1 := Konwert( 'Przeniesienie na stron�' )
h2 := 'Przeniesienie ze strony'
drukstr := DrukStr( strona, strony )
fragON := !Empty( strony )             && mo�liwo�� fragmentarycznego druku
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
* Szuka podobnego '.ini' z dok�adno�ci� do trzech znak�w z lewej
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

procedure Przetworz( plik )

local dane, mm := {} 
local cpi10 := '12'
local xx, bb := Alias()

if !File( 'LINIE.DBF' )
	Aadd( mm, { 'TEKST', 'C', 99999999, 0 })
	Dbcreate( 'LINIE.dbf', mm)
endif

use LINIE exclusive new
zap
append from ( plik ) SDF

go top

x := 1
xx := LastRec()

while !Eof()

	dane := RTrim( TEKST )

   if x = xx
      if right(dane,1) = Chr(12)
         dane := SubStr( dane, 1, Len( dane ) - 2 )
      endif
      if right(dane,1) = Chr(26)
         dane := SubStr( dane, 1, Len( dane ) - 1 )
      endif
   endif

   if x++ = 1
   	replace TEKST with '<font style="font-family:Courier New; font-size:' + cpi10 + '">' + Konwert( dane, maz, win, 1, 1 ) + '<br>'
   else
   	replace TEKST with Konwert( dane, maz, win, 1, 1 ) + if( x <> xx, '<br>', '' )
   endif

	skip

enddo

copy to ( plik ) delimited with blank

use

Jest_baza( bb )
Jest_baza( baza )

**************************************************************************

procedure Zlecenie( plik )

local pliks:=plik+'.ht'
local plikd:=plik+'.htm'

if File( pliks )
   tekst := MemoRead( pliks )
   tekst := StrTran(tekst,'name="MIASTO" value=""','name="MIASTO" value="��d�,"')
   tekst := StrTran(tekst,'name="DATA" value="2012-10-06"','name="DATA" value="'+DtoC(DATA)+'"')
   tekst := StrTran(tekst,'name="MARKA" value="SKODA"','name="MARKA" value="'+MARKA+'"')
   tekst := StrTran(tekst,'name="REJESTRAC" value="LWO 4935"','name="REJESTRAC" value="'+REJESTRAC+'"')
   tekst := StrTran(tekst,'name="NADWOZIE" value="1234567890"','name="NADWOZIE" value="'+NADWOZIE+'"')

   if(!Empty(WSPOLWLASC))
      Blokuj_R()
      replace WLASCICIEL with ''
      OdBlokuj_R()
   endif
   
   tekst := StrTran(tekst,'name="WLASCICIEL" value="1"','name="WLASCICIEL" value="'+ if(Empty(WLASCICIEL),'0"','1" checked '))
   tekst := StrTran(tekst,'name="WSPOLWLASC" value="1"','name="WSPOLWLASC" value="'+ if(Empty(WSPOLWLASC),'0"','1" checked '))

   tekst := StrTran(tekst,'name="OPIS1" value="opis1"','name="OPIS1" value="'+OPIS1+'"')
   tekst := StrTran(tekst,'name="OPIS2" value="opis2"','name="OPIS2" value="'+OPIS2+'"')
   tekst := StrTran(tekst,'name="OPIS3" value="opis3"','name="OPIS3" value="'+OPIS3+'"')

   if(!Empty(ZGADZAM))
      Blokuj_R()
      replace NIEZGADZAM with ''
      OdBlokuj_R()
   endif
   tekst := StrTran(tekst,'name="NIEZGADZAM" value="1"','name="NIEZGADZAM" value="'+ if(Empty(NIEZGADZAM),'0"','1" checked '))
   tekst := StrTran(tekst,'name="ZGADZAM" value="1"','name="ZGADZAM" value="'+ if(Empty(ZGADZAM),'0"','1" checked '))

   if(ZALICZKA==0)
      Blokuj_R()
      replace WPLACAM with ''
      replace NIEWPLACAM with 'X'
      OdBlokuj_R()
   else
      Blokuj_R()
      replace WPLACAM with 'X'
      replace NIEWPLACAM with ''
      OdBlokuj_R()
   endif
   tekst := StrTran(tekst,'name="NIEWPLACAM" value="1"','name="NIEWPLACAM" value="'+ if(Empty(NIEWPLACAM),'0"','1" checked '))
   tekst := StrTran(tekst,'name="WPLACAM" value="1"','name="WPLACAM" value="'+ if(Empty(WPLACAM),'0"','1" checked '))
   tekst := StrTran(tekst,'name="ZALICZKA" value="1500"','name="ZALICZKA" value="'+AllS(ZALICZKA)+'"')

   tekst := StrTran(tekst,'name="NAZWISKO" value="Arkadiusz Moch"','name="NAZWISKO" value="'+NAZWISKO+'"')
   tekst := StrTran(tekst,'name="NIP" value="727-121-72-29"','name="NIP" value="'+NIP+'"')
   tekst := StrTran(tekst,'name="PESEL" value="67083005096"','name="PESEL" value="'+PESEL+'"')
   tekst := StrTran(tekst,'name="TELEFON" value="660-736-575"','name="TELEFON" value="'+TELEFON+'"')
   tekst := StrTran(tekst,'name="DATAPRZYJ" value="2012-10-06"','name="DATAPRZYJ" value="'+DtoC(if(Empty(DATAPRZYJ),DATA,DATAPRZYJ))+'"')
   tekst := StrTran(tekst,'name="LAKIER" value="123"','name="LAKIER" value="'+LAKIER+'"')
   tekst := StrTran(tekst,'name="UWAGI1" value="uwagi1"','name="UWAGI1" value="'+UWAGI1+'"')
   tekst := StrTran(tekst,'name="UWAGI2" value="uwagi2"','name="UWAGI2" value="'+UWAGI2+'"')
   tekst := StrTran(tekst,'name="UWAGI3" value="uwagi3"','name="UWAGI3" value="'+UWAGI3+'"')
   MemoWrit( plikd, Konwert( tekst, maz, win ))
endif

**************************************************************************

procedure ExportIE( plik )

local pliks:=plik
local plikh:=StrTran(plik,'.ht','.h')
local plikd:='c:\wydruk.htm' //StrTran(plik,'.ht','.htm')
local poleb:=''
local polezl:=''
local polegr:=''
local poleul:=''
local polelp:=0
local poleRazemPrzych:=0
local poleRazemRozch:=0
local poleIleKP:=0
local poleIleKW:=0
local poleNRK:=''
local poleRecNo:=RecNo()

local seria:=(StrTran(plik,'REJ_','')<>plik) .and. File(plikh)
local z:=maz
local na:=win

if File( pliks )

   tekst := MemoRead( pliks )
   tekst := StrTran(tekst,'name="OSOBA_UPR">','name="OSOBA_UPR" >'+Konwert(osoba_upr, z, na ))

   if seria
      inclu := MemoRead( plikh )
      DBSetOrder(4)
      DBSeek(DtoS(data1),.t.)
      tekst := StrTran(tekst,'name="NRK">','name="NRK" >'+NRK)
      tekst := StrTran(tekst,'name="NADZIEN">','name="NADZIEN" >'+DtoC(data2))
      tekst := StrTran(tekst,'name="ODDNIA">','name="ODDNIA" >'+AllS(Day(data1)))
      tekst := StrTran(tekst,'name="DODNIA">','name="DODNIA" >'+AllS(Day(data2)))
      tekst := StrTran(tekst,'name="MIESIACA">','name="MIESIACA" >'+Konwert(Nazwa_M(Month(data2)), z, na ))
      tekst := StrTran(tekst,'name="ROKU">','name="ROKU" >'+AllS(Year(data2)))
   else
      poleNRK:=NRK
      DBSetOrder(4)
      DBGoTop()
      ok:=.t.
      while ok .and. !Eof()
         if (poleNRK=NRK)
            polelp++
         else
            polelp:=0
         endif
         if (poleRecNo=RecNo())
            ok:=.f.
         else
            DBSkip()
         endif
      enddo
   endif

   ok:=.t.
   while ok

      if seria
         tekstBuf:=tekst
         tekst := inclu
         polelp++
         poleRazemPrzych+=K10
         poleRazemRozch+=K11
         if K10>0
            poleIleKP++
         endif
         if K11>0
            poleIleKW++
         endif
      endif

      tekst := StrTran(tekst,'name="POLELP">','name="POLELP" >'+AllS(polelp))

      for i := 1 to FCount()
          polezl:=''
          polegr:=''
          poleul:=''
          if (ValType(FieldGet(i))=='C'); poleb := AllTrim(FieldGet(i)); endif
          if (ValType(FieldGet(i))=='D'); poleb := DtoC(FieldGet(i)); endif
          if (ValType(FieldGet(i))=='N') 
            poleb := AllS(FieldGet(i))
            if seria .and. poleb='0.00'
               poleb='&nbsp;'
            endif
            polezl := Slownie(FieldGet(i),,1)
            polegr := Slownie(FieldGet(i),,2)
            poleul := AllS( 100 * ( FieldGet(i) - Int(FieldGet(i))), '99' ) + '/100'
          endif
          poleb:=Konwert( poleb, z, na )
          polezl:=Konwert( polezl, z, na )
          polegr:=Konwert( polegr, z, na )
          tekst := StrTran(tekst,'name="'+FieldName(i)+'" value=""','name="'+FieldName(i)+'" value="'+poleb+'"')
          tekst := StrTran(tekst,'name="'+FieldName(i)+'">','name="'+FieldName(i)+'" >'+poleb)
          tekst := StrTran(tekst,'name="'+FieldName(i)+'" mode="SLOWNIEZL">','name="'+FieldName(i)+'" >'+polezl)
          tekst := StrTran(tekst,'name="'+FieldName(i)+'" mode="SLOWNIEGR">','name="'+FieldName(i)+'" >'+polegr)
          tekst := StrTran(tekst,'name="'+FieldName(i)+'" mode="SLOWNIEUL">','name="'+FieldName(i)+'" >'+poleul)
      next                                                                
   
      if seria
         if len(tekstBuf)+len(tekst)>65535
            ok:=.f.
            tekst := tekstBuf
         else
            tekst := StrTran(tekstBuf,'#include',tekst+'#include')
         endif
         DBSkip()
         if (D3>data2) .or. Eof()
            ok:=.f.
         endif
      else
         ok:=.f.
      endif

   enddo

   if seria
      tekst := StrTran(tekst,'name="RAZEMPRZYCH">','name="RAZEMPRZYCH" >'+AllS(poleRazemPrzych))
      tekst := StrTran(tekst,'name="RAZEMROZCH">','name="RAZEMROZCH" >'+AllS(poleRazemRozch))
      tekst := StrTran(tekst,'name="STANPOPRZ">','name="STANPOPRZ" >'+AllS(bun1))
      tekst := StrTran(tekst,'name="ILEKP">','name="ILEKP" >'+AllS(poleIleKP))
      tekst := StrTran(tekst,'name="ILEKW">','name="ILEKW" >'+AllS(poleIleKW))
      tekst := StrTran(tekst,'name="STANOBECNY">','name="STANOBECNY" >'+AllS(bun1+poleRazemPrzych-poleRazemRozch))
      tekst := StrTran(tekst,'name="TOTALPRZYCH">','name="TOTALPRZYCH" >'+AllS(bun1+poleRazemPrzych))
      tekst := StrTran(tekst,'name="TOTALROZCH">','name="TOTALROZCH" >'+AllS(poleRazemRozch+bun1+poleRazemPrzych-poleRazemRozch))
      tekst := StrTran(tekst,'#include','')
   endif
   
   MemoWrit( plikd, tekst)

endif

**************************************************************************
