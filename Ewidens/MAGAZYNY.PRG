******************************************************************************
********************      Procedury  MAGAZYNY    *****************************
******************************************************************************
#include 'Inkey.ch'

******************************************************************************
* Aktualizacja wszystkich ISBN'Ûw w TOWARK

procedure AktISBNs()

local idk, isb, idt

if (Alarm('Aktualizacja wszystkich ISBN ?', tk ) # 1); return; endif

ON('TOWARKS')

Select('TOWARK')
DBSetOrder(1)
go top
while !Eof()
   
   isb:=''
   idt:=0
   idk:=ID
   
   TOWARKS->( DBSeek( Str(idk,10)))
   while TOWARKS->(ID_K==idk .and. !Eof())
      if !Empty(TOWARKS->ISBN)
         isb := TOWARKS->ISBN
      endif 
      TOWARKS->(DBSkip())
   enddo
   
   TOWARK->( DBSetOrder(1))
   if TOWARK->( DBSeek( idk ))
      idt := TOWARK->ID_T
      TOWARK->(Blokuj_R())
      TOWARK->ISBN := isb
      TOWARK->(OdBlokuj_R())
   endif
   
   TOWARY->( DBSetOrder(1))
   if TOWARY->( DBSeek( idt ))
      TOWARY->(Blokuj_R())
      TOWARY->ISBN := isb
      TOWARY->(OdBlokuj_R())
   endif
   
   DBSkip()
enddo

******************************************************************************

procedure AktISBN()

local idk:=ID_K, isb:='', idt := 0

go top
while !Eof()
   if !Empty( ISBN )
      isb := ISBN
   endif 
   DBSkip()
enddo

TOWARK->( DBSetOrder(1))
if TOWARK->( DBSeek( idk ))
   idt := TOWARK->ID_T
   TOWARK->(Blokuj_R())
   TOWARK->ISBN := isb
   TOWARK->(OdBlokuj_R())
endif

TOWARY->( DBSetOrder(1))
if TOWARY->( DBSeek( idt ))
   TOWARY->(Blokuj_R())
   TOWARY->ISBN := isb
   TOWARY->(OdBlokuj_R())
endif

******************************************************************************

function NettoX(x)

local n := 1, v3 := ( DOKUM->( Field( 35 )) == 'NETTO3' )

if NETTO23 # 0
   if n==x; return NETTO23; else; n++; endif
endif
if NETTO22 # 0
   if n==x; return NETTO22; else; n++; endif 
endif
if NETTO8  # 0
   if n==x; return NETTO8 ; else; n++; endif 
endif
if NETTO7  # 0
   if n==x; return NETTO7 ; else; n++; endif 
endif
if NETTO5  # 0
   if n==x; return NETTO5 ; else; n++; endif 
endif
if v3 .and. NETTO3  # 0
   if n==x; return NETTO3 ; else; n++; endif 
endif
if NETTO0  # 0
   if n==x; return NETTO0 ; else; n++; endif 
endif
if NETTOZW # 0
   if n==x; return NETTOZW; else; n++; endif 
endif

return 0

******************************************************************************

function Netto1(); return NettoX(1)
function Netto2(); return NettoX(2)
function Netto3(); return NettoX(3)
function Netto4(); return NettoX(4)
function Netto5(); return NettoX(5)
function Netto6(); return NettoX(6)
function Netto7(); return NettoX(7)

******************************************************************************

function VatX(x)

local n := 1, v3 := ( DOKUM->( Field( 35 )) == 'NETTO3' )

if NETTO23 # 0
   if n==x; return VAT23; else; n++; endif 
endif
if NETTO22 # 0
   if n==x; return VAT22; else; n++; endif 
endif
if NETTO8  # 0
   if n==x; return VAT8 ; else; n++; endif 
endif
if NETTO7  # 0
   if n==x; return VAT7 ; else; n++; endif 
endif
if NETTO5  # 0
   if n==x; return VAT5 ; else; n++; endif 
endif
if v3 .and. NETTO3  # 0
   if n==x; return VAT3 ; else; n++; endif 
endif
if NETTO0  # 0
   if n==x; return    0 ; else; n++; endif 
endif
if NETTOZW # 0
   if n==x; return    0 ; else; n++; endif 
endif

return 0

******************************************************************************

function VAT1(); return VATX(1)
function VAT2(); return VATX(2)
function VAT3(); return VATX(3)
function VAT4(); return VATX(4)
function VAT5(); return VATX(5)
function VAT6(); return VATX(6)
function VAT7(); return VATX(7)

******************************************************************************

function CVatX(x)

local n := 1, v3 := ( DOKUM->( Field( 35 )) == 'NETTO3' )

if NETTO23 # 0
   if n==x; return 23; else; n++; endif 
endif
if NETTO22 # 0
   if n==x; return 22; else; n++; endif 
endif
if NETTO8  # 0
   if n==x; return  8; else; n++; endif 
endif
if NETTO7  # 0
   if n==x; return  7; else; n++; endif 
endif
if NETTO5  # 0
   if n==x; return  5; else; n++; endif 
endif
if v3 .and. NETTO3  # 0
   if n==x; return  3; else; n++; endif 
endif
if NETTO0  # 0
   if n==x; return  0; else; n++; endif 
endif
if NETTOZW # 0
   if n==x; return -1; else; n++; endif 
endif

return NIL

******************************************************************************

function CVAT1(); return CVAT(CVATX(1))
function CVAT2(); return CVAT(CVATX(2))
function CVAT3(); return CVAT(CVATX(3))
function CVAT4(); return CVAT(CVATX(4))
function CVAT5(); return CVAT(CVATX(5))
function CVAT6(); return CVAT(CVATX(6))
function CVAT7(); return CVAT(CVATX(7))

******************************************************************************

procedure NumerySio(b,c)

local t := '', d := '', n := 0, rr := 0, ii := 0, jest := .f., i := 0, s := ''

if (b # NIL) .and. (c # NIL) .and. (left(b,15)=='DOKTYPY->(DokIn') .and. (left(c,15)=='SkasujRec("SPEC')	//usuwanie dokumentu

rr := DOKUM->( RecNo())
ii := DOKUM->( IndexOrd())
t := AllTrim( DOKUM->TYP )
in := AllTrim( DOKUM->INDEKS )
d := DOKUM->NUMERFD
n := DOKUM->NABYWCA

if (left(t,1)=='F' .or. left(t,2)=='RU')	//faktura lub rachunek
	DOKUM->( DBSetOrder( 4 ))	//Str(NABYWCA)+DtoS(DATAS)
	DOKUM->( DBSeek( Str( n, 10 )))
	while ( DOKUM->NABYWCA = n ) .and. DOKUM->( !Eof())
		DOKUM->( NumerSio( t, in ))
		DOKUM->( DBSkip())
	enddo
	DOKUM->( DBSetOrder( ii ))
	DOKUM->( DBGoTo( rr ))
endif

endif

******************************************************************************
* FVK 15/K/2008 do FV 315/2007, FJK 8/JK/2008

procedure NumerSio( t, in )

local s := AllTrim( NUMERFD )

if s==''; return; endif

s := StrTran( s, t + ' ' + in, '' )
s := StrTran( s, '      ', ' ' )
s := StrTran( s, '     ', ' ' )
s := StrTran( s, '    ', ' ' )
s := StrTran( s, '   ', ' ' )
s := StrTran( s, '  ', ' ' )
s := StrTran( s, ',,', ',' )
s := StrTran( s, ',,', ',' )
s := StrTran( s, ',,', ',' )

if !( s == AllTrim( NUMERFD ))
	Blokuj_R()
	replace NUMERFD with s
	OdBlokuj_R()
endif

******************************************************************************
* x = symbol do weryfikacji
* n = do ilu znakÛw dope≥niaÊ
*                     3   6   9
function Zmieniaj( x, le, pr, n )					&& x := '1GR123456'

local p, m, g, xx
local s := Left( x, le )								&& s := '1GR'
local a := Right( SubStr( x, le + 1 ), pr )		&& a := '123456'

x := s + a
s := SubStr( x, 1, Len( x ) - 1 )
a := Asc( Right( x, 1 ))

if n = NIL; n := 9; endif

g := -1	&& najpierw zwiÍksz literkÍ o 1
p := 1
m := -1
xx := PadR( x, n )
while MEGAKM->( DBSeek( xx ))
		if g = p
			g := m--
		else
			g := p++
		endif
		x := s + Chr( a + g )
		xx := PadR( x, n )
enddo

return x

******************************************************************************

procedure TestDok()

local ile := 1, wa, ne, h

if ( ile := Get_U( 10, 10, 'Podaj ile dokument¢w testowaç:', '@K 999999', ile )) = NIL; return; endif

LastZero()
SPEC->( DBSetOrder( 1 ))
while !Eof()
		wa := 0
		SPEC->( DBSeek( DOKUM->ID ))
		while SPEC->( ID_D = DOKUM->ID .and. !Eof())
			wa += SPEC->( Grosz( ILOSC * CENA ))
			SPEC->( DBSkip())
		enddo
		ne := DOKUM->( NETTO23 + NETTO8 + NETTO5 + NETTO22 + NETTO7 + NETTO0 + NETTOZW )
		h := 'Dokument ' + DOKUM->( AllTrim( TYP ) + ' ' + AllTrim( INDEKS ) + ' z dnia ' + DtoC( DATAW ))
		@ 0, 0 say h
		if Abs( wa - ne ) > 0.009
			if Alarm( h +;
						'; netto dokumentu = ' + AllS( ne ) + ' # netto towarÛw = ' + AllS( wa ) + ' o ' + AllS( ne - wa ),;
						{ 'Dalej=Enter', 'Stop = Esc' }, 1 ) # 1
				return
			endif
		endif
		skip
		ile --
		if ile = 0; exit; endif
		if Inkey() = 27; exit; endif
enddo

******************************************************************************

function RabatZero( s )

local r, wy := .f.

if s = NIL; s := 'SPEC->ID_T'; endif
r := TOWARY->( GetPole( 1, s, 'RABAT','TOWARY',,,1,,,'STAROCIE\TOWARY'))
if !Empty( r ) .and. Val( r ) = 0
   wy := .t.
endif

return wy

******************************************************************************
* Funkcja badajÜca specyfikacj' dokumentu podstawowego

function SaRabatyZero()

local bb := Alias(), wy := .f.

ON( 'TOWARY' )
ON( 'SPEC' )
DBSeek( DOKUM->ID )
while DOKUM->ID = ID_D .and. !Eof()
      if ( wy := RabatZero()); exit; endif
      skip
enddo
Select( bb )

return wy

******************************************************************************

function Statusy( s, x )

local r, wy := .f.

if s = NIL; s := 'SPEC->ID_T'; endif
r := TOWARY->( GetPole( 1, s, 'STATUS','TOWARY',,,1,,,'STAROCIE\TOWARY'))
if r = x
   wy := .t.
endif

return wy

******************************************************************************
* Funkcja badajÜca specyfikacj' dokumentu podstawowego

function SaStatusy( x )

local bb := Alias(), wy := .f.

ON( 'TOWARY' )
ON( 'SPEC' )
DBSeek( DOKUM->ID )
while DOKUM->ID = ID_D .and. !Eof()
      if ( wy := Statusy(,x)); exit; endif
      skip
enddo
Select( bb )

return wy

******************************************************************************

function p13o( od, do, ko )

local i := 0, h

if od = NIL           && wywo'anie z F10

   if Get_Okres( @data_od , @data_do ) = NIL; return; endif

   if Alarm( 'Czy operowaç tylko na dokumentach bießÜcego;kontrahenta "' +;
              AllTrim( FIRMY->( GetPole( 1, 'DOKUM->NABYWCA', 'INDEKS' ))) + '" ?', tk ) = 1
      ko := NABYWCA
      h := 'Otwarto x dokument¢w'
   endif

else

   data_od := od
   data_do := do

endif

Czek( 1 )
set filter to                       && otwieranie od ko§ca
DBSetOrder( 3 )
DBSeek( DtoS( data_do + 1 ), .t. ); DBSkip( -1 )
while DATAS >= data_od .and. !Bof()
      if BLOKADA == " " .and. if( ko = NIL, .t., NABYWCA = ko )
         DokClose(,1)               && otwarcie
         i ++
      endif
      skip -1
enddo
Czek( 0 )

if h # NIL
   Alarm( StrTran( h, 'x', AllS( i )))
endif

wy := 2

return i

******************************************************************************

procedure p13z( od, do, ko )

local i := 0, h

if od = NIL           && wywo'anie z F10

   if Get_Okres( @data_od , @data_do ) = NIL; return; endif

   if Alarm( 'Czy operowaç tylko na dokumentach bießÜcego;kontrahenta "' +;
              AllTrim( FIRMY->( GetPole( 1, 'DOKUM->NABYWCA', 'INDEKS' ))) + '" ?', tk ) = 1
      ko := NABYWCA
      h := 'Zamkniëto x dokument¢w'
   endif

else

   data_od := od
   data_do := do

endif

Czek( 1 )
i := 0
set filter to                       && otwieranie od ko§ca
DBSetOrder( 3 )
DBSeek( DtoS( data_od ), .t. )      && zamykanie od poczÜtku
while DATAS <= data_do .and. !Eof()
      if BLOKADA == "O" .and. if( ko = NIL, .t., NABYWCA = ko )
         DokClose()                 && zamkni'cie
         i++
      endif
      skip 1
enddo
Czek( 0 )

if h # NIL
   Alarm( StrTran( h, 'x', AllS( i )))
endif

wy := 2

return i

******************************************************************************

procedure p13()

local i := 0, ko

if Alias() # 'DOKUM'; Alarm( 'Wejd¶ do tabeli dokument¢w' ); endif
if Get_Okres( @data_od , @data_do ) = NIL; return; endif
if Alarm( 'Czy operowaç tylko na dokumentach bießÜcego;kontrahenta "' +;
           AllTrim( FIRMY->( GetPole( 1, 'DOKUM->NABYWCA', 'INDEKS' ))) + '" ?', tk ) = 1
   ko := NABYWCA
endif

i := p13o( data_od, data_do, ko )
if Alarm( 'Otwarto ' + AllS( i ) + ' dokument¢w. ZamknÜç je ?', tk ) # 1; return; endif
if ko # NIL
   globalbuf := ko
   if Alarm( 'Czy przed zamkniëciem usunÜç WSZYSTKIE stany analityczne;kontrahenta "' + AllTrim( FIRMY->( GetPole( 1, 'globalbuf', 'INDEKS' ))) + '"?', nt ) = 2
      MAGAZYNY->( DBEBD( 'ID', ko ))
   endif
endif
i := p13z( data_od, data_do, ko )
Alarm( 'Zamkniëto ' + AllS( i ) + ' dokument¢w ')
wy := 2

******************************************************************************

function SaDuble()

local wy, bb := Alias(), d, t, c

wy := .f.
d := DOKUM->ID
ON( 'SPEC', 3 )
DBSeek( Str( d ))
t := 0
while ID_D = d .and. !Eof()
      if t = ID_T .and. c = CENA   && dubel
         wy := .t.
         exit
      else
         t := ID_T
         c := CENA
      endif
      skip
enddo

Select( bb )

return wy

******************************************************************************
******************************************************************************

function RETSATo( od, do, ko )

local i := 0, h

h := 'Otwarto x dokument¢w'

Czek( 1 )
set filter to                       && otwieranie od ko§ca
DBSetOrder( 0 )
DBGoBottom()
while !Bof()
      if BLOKADA == " " .and. if( ko = NIL, .t., NABYWCA = ko )
         DokClose(,1)               && otwarcie
         i ++
      endif
      skip -1
enddo
Czek( 0 )

if h # NIL
   Alarm( StrTran( h, 'x', AllS( i )))
endif

wy := 2

return i

******************************************************************************

procedure RETSATz( od, do, ko )

local i := 0, h

h := 'Zamkniëto x dokument¢w'

Czek( 1 )
i := 0
set filter to                       && otwieranie od ko§ca
DBSetOrder( 0 )
DBGoTop()
while !Eof()
      if BLOKADA == "O" .and. if( ko = NIL, .t., NABYWCA = ko )
         DokClose()                 && zamkni'cie
         i++
      endif
      skip 1
enddo
Czek( 0 )

if h # NIL
   Alarm( StrTran( h, 'x', AllS( i )))
endif

wy := 2

return i

******************************************************************************

procedure RETSAT()

local i := 0, ko

if Alias() # 'DOKUM'; Alarm( 'Wejd¶ do tabeli dokument¢w' ); endif

RETSATo()
Select( 'MAGAZYNY' ); DBZap()
AktMZ()
Select( 'DOKUM' )
RETSATz()
wy := 2

******************************************************************************
******************************************************************************

procedure Naleznosc( mn, x, n )

if !Empty( FIRMY->( GetPole( 1, x, 'INDEKS' )))
   FIRMY->( Blokuj_R())
   if n = 1
      do case
      case DOKTYPY->FIRMA_MG = 1; FIRMY->NALEZNOSCI += mn * DOKUM->WARTOSC
      case DOKTYPY->FIRMA_MG = 2; FIRMY->NALEZNOSCI -= mn * DOKUM->WARTOSC
      endcase
      do case
      case DOKTYPY->FIRMA_WG = 1; FIRMY->ZADLUZENIE += mn * DOKUM->WARTOSC
      case DOKTYPY->FIRMA_WG = 2; FIRMY->ZADLUZENIE -= mn * DOKUM->WARTOSC
      endcase
      do case
      case DOKTYPY->FIRMA_OG = 1; FIRMY->OBROTY += mn * DOKUM->WARTOSC
      case DOKTYPY->FIRMA_OG = 2; FIRMY->OBROTY -= mn * DOKUM->WARTOSC
      endcase
   else
      do case
      case DOKTYPY->FIRMA_MP = 1; FIRMY->NALEZNOSCI += mn * DOKUM->WARTOSC
      case DOKTYPY->FIRMA_MP = 2; FIRMY->NALEZNOSCI -= mn * DOKUM->WARTOSC
      endcase
      do case
      case DOKTYPY->FIRMA_WP = 1; FIRMY->ZADLUZENIE += mn * DOKUM->WARTOSC
      case DOKTYPY->FIRMA_WP = 2; FIRMY->ZADLUZENIE -= mn * DOKUM->WARTOSC
      endcase
      do case
      case DOKTYPY->FIRMA_OP = 1; FIRMY->OBROTY += mn * DOKUM->WARTOSC
      case DOKTYPY->FIRMA_OP = 2; FIRMY->OBROTY -= mn * DOKUM->WARTOSC
      endcase
   endif
   FIRMY->( OdBlokuj_R())
endif
   
******************************************************************************
* mode = NIL - zablokuj
* mode # NIL - odblokuj
* doknazal= "FVK"
* doknanal= "FV "
* typ = NIL => normal
* typ = 0 => stoi na firmie + zerowanie danych firmy
* typ = 1 => stoi na firmie + normal, ale bez ciπg≥ego blokowania

procedure Naleznosci( mode, typ )

local mn := if( mode = NIL, 1, -1 )

if !oknaleznos; return; endif

private firma_mp := NIL

if typ # NIL
	if typ = 0
		FIRMY->KOREKTY := 0
		FIRMY->NALEZNOSCI := 0
		return
	endif
else
	if DOKTYPY->( FIRMA_MP ) # NIL          && w DOKTYPY sÜ pola FIRMA_MP,WP,OP
	   Naleznosc( mn, 'DOKUM->MAGAZYN', 1 ) && MY
	   if DOKUM->MAGAZYN # 0                && bez podw¢jnego przetwarzania MZ !
	      Naleznosc( mn, '0', 1 )           && FIRMA
	   endif
	   Naleznosc( mn, 'DOKUM->NABYWCA', 2 ) && ONI
	   return
	endif
	if Empty( FIRMY->( GetPole( 1, 'DOKUM->NABYWCA', 'INDEKS' )))
		return
	endif
endif

if !Empty( doknazal ) .and. ( DOKUM->TYP $ doknazal ) .and. ( DOKUM->( WPLACONO # WARTOSC ))
	if typ = NIL; FIRMY->( Blokuj_R()); endif
   FIRMY->KOREKTY += mn * DOKUM->( WPLACONO - WARTOSC )  && np.: 0 - ( -1000 )
   if typ = NIL; FIRMY->( OdBlokuj_R()); endif
endif

if !Empty( doknanal ) .and. ( DOKUM->TYP $ doknanal ) .and. ( DOKUM->( WPLACONO # WARTOSC ))
	if typ = NIL; FIRMY->( Blokuj_R()); endif
   FIRMY->NALEZNOSCI += mn * DOKUM->( WARTOSC - WPLACONO )  && np.: 1000 - 0
   if typ = NIL; FIRMY->( OdBlokuj_R()); endif
endif

******************************************************************************
* zapisz przy kontrahencie úwieøe dane o naleønoúciach
* i wpisz ewentualnie wp≥atÍ z pola vp[ 4 ] do DOKSPL

procedure SetNaleznosci( idf )

local bb := Alias(), ii := IndexOrd(), rr := RecNo(), wa, x
local iii := IndexOrd(), rrr := RecNo(), idd

if !oknaleznos; return; endif

idf := NABYWCA
idd := ID

rrr := DOKUM->( RecNo())
iii := DOKUM->( IndexOrd())

if Empty( GetPole( 1, AllS(idf), 'INDEKS', 'FIRMY' )); return; endif	&& ustawia siÍ na firmie
FIRMY->( Blokuj_R())
Naleznosci(,0)

wa := vp[ 4 ]
if wa # NIL .and. wa # 0
	ON( 'DOKSPL' )	&& Str(ID_F)+Str(ID_D)+Str(ID)
	DBSeek( Str( idf, 10 ) + Str( idd, 10 ) + Str( 99999, 10 ), .t. )
	DBSkip( -1 )
	x := 0
	if idf = ID_F .and. idd = ID_D
		x := ID
	endif
	AppendRecord(, { idf, x + 1, idd, vp[ 5 ], wa, vp[ 6 ]})
endif

Select( 'DOKUM' )
set filter to
DBSetOrder( 4 )	&& 'Str(NABYWCA)+DtoS(DATAS)')
DBSeek( Str( idf, 10 ))
while idf = DOKUM->NABYWCA .and. !Eof()
		Naleznosci(,1)
		skip
enddo
DBEFiltr( DBE_Filtr, 1 )
DBSetOrder( iii )
DBGoTo( rrr )

FIRMY->( OdBlokuj_R())

Jest_baza( bb )
DBSetOrder( ii )
DBGoTo( rr )

******************************************************************************
* Ustawienie stanu rozlicze§ "from sub to main base"

procedure DokumSetRoz( iddo, wa )

local bb := Alias(), ok := .t.

if iddo = NIL; iddo := ( bb )->ID; endif
if wa = NIL; wa := ( bb )->WPLACONO; endif

DOKUM->(DBSetOrder( 1 ))
if DOKUM->( DBSeek( iddo ))
	if DOKUM->WPLACONO > wa
		if Alarm( '   Dotychczas za dokument wp≥acono: ' + AllS( DOKUM->WPLACONO ) + ';' +;
					 'Czy teraz zapisaÊ kwotÍ mniejszπ ?: ' + AllS( wa ), nt, 1 ) # 2
			ok := .f.
		endif
	endif
	if ok
	   DOKUM->( Blokuj_R())
   	DOKUM->WPLACONO := wa
	   DOKUM->( OdBlokuj_R())
		private vp := { 0, 0, 0, 0 }	&& wygaszenie pÛl formularza przed "SetNaleznosci()"
		DOKUM->( SetNaleznosci())
	endif
endif

zmiana := .f.  && niech nie kombinuje z DOKUM jako subbazÜ

******************************************************************************
* Generowanie sp≥at w terminie

procedure GenDOKSPL()

local idf, idd, x, bb := Alias()

if Alarm( 'GenerowaÊ sp≥aty w terminie dla;wszystkich zap≥aconych dokumentÛw w tabeli ?', nt, 1 ) # 2; return; endif

Czek( 1 )
Przerwa( LastRec())
go top
while !Eof()
		wa := DOKUM->( GetPole( 1, 'ID_D', 'WPLACONO' )) - WPLATY
		idf := ID_F
		idd := ID_D
		if wa # NIL .and. wa # 0
			ON( 'DOKSPL' )	&& Str(ID_F)+Str(ID_D)+Str(ID)
			DBSeek( Str( idf, 10 ) + Str( idd, 10 ) + Str( 99999, 10 ), .t. )
			DBSkip( -1 )
			x := 0
			if idf = ID_F .and. idd = ID_D
				x := ID
			endif
			AppendRecord(, { idf, x + 1, idd, DOKUM->DATAT, wa, 'automat z ' + DtoC( Date())})
			Select( bb )
		endif
		if Przerwa(); exit; endif
		skip
enddo
Przerwa( 0 )
Czek( 0 )

Alarm( 'Teraz zrÛb aktualizacjÍ',, 1 )

******************************************************************************
* Drukuj alfabetycznie
* skr - skrÛcona specyfikacja, tj. bez takich samych
* niealf - wy≥πcza alfabetycznoúÊ

procedure DrukujA( wzor, subdruk, wydruk, skr, niealf )

local bb := Alias(), rr := RecNo(), ii := IndexOrd(), s

ON( 'SPECSCAL', 4, 'ROBOCZY', 'ROB' )
ON( 'SPECSCAL', 4, 'ROBOCZY', 'ROB', .t. )

SPEC->( DBSeek( DOKUM->ID ))
KopiaRec( 'SPEC', 'ROB', 'DOKUM->ID=ID_D',,, { || ROB->NAZWA := TOWARY->( GetPole( 1, 'ROB->ID_T','NAZWA')), .f. })

wzor := if( '.' $ wzor, wzor, wzor + '.wyd' )
s := ReadWzor( wzor )
s := StrTran( s, 'SPEC', 'ROB' )

if skr # NIL
Select( 'ROB' )
for i := 1 to LastRec()/2
	DBGo( i )
	rec := {}
	for n := 1 to FCount(); Aadd( rec, FieldGet( n )); next
	DBGo( i + LastRec()/2 )
	ok := .t.
	for n := 1 to FCount()
		if if( n = 4, -rec[ n ], rec[ n ]) # FieldGet( n )
			ok := .f.
			exit
		endif
	next
	if ok
		DBGo( i ); BDelete()
		DBGo( i + LastRec()/2 ); BDelete()
	endif
next
s := StrTran( s, 'Byío:', 'Byío: (tylko korygowane pozycje)' )
s := StrTran( s, 'Powinno byç:', 'Powinno byç: (tylko korygowane pozycje)' )
endif

if niealf = NIL
	s := StrTran( s, 'DBSetOrder(1)', 'DBSetOrder(4)' )   && alfabetycznie
endif
s := StrTran( s, 'DBSeek(DOKUM->ID)', 'DBGoTop()' )   && bez "seek"
wzor := if( '.' $ wzor, StrTran( wzor, 'wyd', 'xxx' ), wzor + '.xxx' )
MemoWrit( cat_wzorow + wzor, s )

Select( bb )
Drukuj( wzor, subdruk, cat_wydr + Left( wzor, Len( wzor ) - 4 ) + '.txt' )
Zwolnij( 'ROB' )

Select( bb )
DBGoTo( rr )
DBSetOrder( ii )

******************************************************************************
* Wydruk specyfikacji zaznaczonych dokument¢w
* sca - wariant scalania ROB (1=max, 2=med, 3=min)
* wzor - wydruku ROB

procedure DokumDrukM( bz, sca, wzor )

local bb := Alias(), rr := RecNo(), ii := IndexOrd(), iii, rrr
local i := 0, bp := .f., wy, sp := stronyOn

if Druk_Nr = 2		&& Orygina≥ i kopia
	stronyOn := .f.
	wy := DOKTYPY->(AllTrim(GetPole(1,'DOKUM->TYP','WZORWYDR')))
	Druk_Nr:=0
	DOKUM->(Drukuj( wy,,,,'Drukuj( "'+wy+'",1),Druk_Nr:=1' ))
	return
endif

if Jest_baza( 'DOKUM' )
	iii := IndexOrd()
	rrr := RecNo()
endif

if wzor = NIL

ON( 'DOKUM' )
ON( bz, 0 )
while !Eof(); i ++; skip; enddo

if i <= 0
   ON( bz )  && ustawia indeks znakÛw dla tabeli dokumentÛw
   Select( bb )
   DBGoTo( rr )
   DBSetOrder( ii )
   return
else
   bp := Alarm( 'IloúÊ zaznaczonych dokumentÛw : ' + AllS( i ) + ';DrukowaÊ je bez pytaÒ po kaødym ?', tk, 1 )
   if bp = NIL
      ON( bz )  && ustawia indeks znakÛw dla tabeli dokumentÛw
      Select( bb )
      DBGoTo( rr )
      DBSetOrder( ii )
      return
   endif
   bp := ( bp = 1 )
	if bp
		stronyOn := .f.
	endif
endif

go top
while !Eof()
      if DOKUM->( DBSeek(( bz )->POLE ))
      DOKUM->(Drukuj(DOKTYPY->(AllTrim(GetPole(1,'DOKUM->TYP','WZORWYDR'))),,, bp ))
      Select( bz )
      endif
      skip
enddo

ON( bz )  && ustawia indeks znakÛw dla tabeli dokumentÛw

else

ON( 'SPEC' )
ON( 'SPECSCAL', 4, 'ROBOCZY', 'ROB' )
ON( 'SPECSCAL', 4, 'ROBOCZY', 'ROB', .t. )
ON( 'DOKUM' )
ON( bz )
while !Eof()
      if DOKUM->( DBSeek(( bz )->POLE ))
         if SPEC->( DBSeek( DOKUM->ID ))
            KopiaRec( 'SPEC', 'ROB', 'DOKUM->ID=ID_D',,, { || ROB->NAZWA := TOWARY->( GetPole( 1, 'ROB->ID_T','NAZWA')), .f. })
         endif
         Select( bz )
      endif
      skip
enddo

ROB->( Scal_ROB( sca ))
ROB->( Drukuj( wzor ))
Zwolnij( 'ROB' )

endif

wy := 2
Select( bb )
DBGoTo( rr )
DBSetOrder( ii )

if bp
	stronyOn := sp
endif

if iii # NIL
	DOKUM->( DBSetOrder( iii ))
	DOKUM->( DBGoTo( rrr ))
endif

******************************************************************************
* Wydruk zaznaczonych dokument¢w

procedure DrukM( bz, wz )

local bb := Alias(), rr := RecNo(), ii := IndexOrd()
local i := 0, bp := .f., wy, sp := stronyOn

ON( bz, 0 )
while !Eof(); i ++; skip; enddo

if i <= 0
   ON( bz )  && ustawia indeks znakÛw dla tabeli dokumentÛw
   Select( bb )
   DBGoTo( rr )
   DBSetOrder( ii )
   return
else
   bp := Alarm( 'IloúÊ zaznaczonych dokumentÛw : ' + AllS( i ) + ';DrukowaÊ je bez pytaÒ po kaødym ?', tk, 1 )
   if bp = NIL
      ON( bz )  && ustawia indeks znakÛw dla tabeli dokumentÛw
      Select( bb )
      DBGoTo( rr )
      DBSetOrder( ii )
      return
   endif
   bp := ( bp = 1 )
	if bp
		stronyOn := .f.
	endif
endif

go top
while !Eof()
      if ( bb )->( DBSeek(( bz )->POLE ))
	      ( bb )->(Drukuj( wz,,, bp ))
   	   Select( bz )
      endif
      skip
enddo

ON( bz )  && ustawia indeks znakÛw dla tabeli dokumentÛw

wy := 2
Select( bb )
DBGoTo( rr )
DBSetOrder( ii )

if bp
	stronyOn := sp
endif

******************************************************************************
* Wybieranie z menu nazw dokument¢w okreûlonych symbolami w "x" po przecinkach
* Jeûli zwraca .t., to w DOKTYPY jest ustawiony wybrany dokument

function Wybieranie( x )

local ok, mm

if !( ',' $ x )                        && tylko jeden
   return DOKTYPY->( DBSeek( x ))      && ok jeûli tylko taki jest
endif

Select( 'DOKTYPY' )
DBGoTop()
mm := {}
while !Eof()
      if Inn( DOKTYPY->TYP, x, 1 )
         Aadd( mm, DOKTYPY->TYP + ': ' + RTrim( DOKTYPY->NAZWA ))
      endif
      skip
enddo
ok := Alarm( 'Wybierz generowany dokument: ', mm )
if ok = 0
   Select( 'DOKUM' )
   return NIL
else
  ok := DOKTYPY->( DBSeek( Left( mm[ ok ], 3 )))
endif

return ok

******************************************************************************
* Nowe generowanie na podstawie p¢l GENERUJ_Wn, GENERUJ_Dn

procedure Generuj( war, dok, b, w )

local ok

if Empty( dok ); return 0; endif
if !Empty( war ) .and. !RunCommand( war ); return 0; endif
if ( NIL = ( ok := Wybieranie( dok ))); return 0; endif
if ok
	return Generowanie(, b, w )
endif

return 0

******************************************************************************
* a - parametry formularza dla Generuj 1
* b # NIL => drugie (r'czne ) generowanie (np.: stoimy na zam¢wieniu)
* bg - bez generowania pe'nej kasy, a tylko na r¢ßnic'

function GenerujWZ( a, b, bg )

local ok, d1g, d2g, d1p, d2p, przeci, il

private fiskalny := ' ', kasowy := ' ', generowane := ' '
private generuj_d1 := ' ', rozlicz := ' '

DOKTYPY->( DBSeek( DOKUM->TYP ))
d1g := DOKTYPY->MAGAZYNG
d1p := DOKTYPY->MAGAZYNP

if ( DOKTYPY->( FISKALNY )== 'T' ); GenerujFisk(); endif

if !Empty( DOKTYPY->( GENERUJ_D1 ))
	il := 0
   private generuj_g1 := ' ', generuj_g2 := ' ', generuj_g3 := ' ', generuj_g4 := ' '
   il += DOKTYPY->( Generuj( GENERUJ_W1, GENERUJ_D1, b, GENERUJ_G1 )); DOKTYPY->( DBSeek( DOKUM->TYP ))
   il += DOKTYPY->( Generuj( GENERUJ_W2, GENERUJ_D2, b, GENERUJ_G2 )); DOKTYPY->( DBSeek( DOKUM->TYP ))
   il += DOKTYPY->( Generuj( GENERUJ_W3, GENERUJ_D3, b, GENERUJ_G3 )); DOKTYPY->( DBSeek( DOKUM->TYP ))
   il += DOKTYPY->( Generuj( GENERUJ_W4, GENERUJ_D4, b, GENERUJ_G4 )); DOKTYPY->( DBSeek( DOKUM->TYP ))
   return ( il > 0 )
endif

if ( b = NIL ) .and.;
   ( bg = NIL) .and.;
   ( DOKTYPY->( KASOWY ) == 'T' )
   GenerujKASA( DOKUM->WPLACONO )
endif

if !DokGeneruj; return .f.; endif

if b # NIL .and. !Empty( DOKTYPY->( GENEROWANE ))
   if ( NIL = ( ok := Wybieranie( DOKTYPY->( GENEROWANE )))); return .f.; endif
else
   ok := !Empty( DOKTYPY->TYP_F ) .and. DOKTYPY->( DBSeek( DOKTYPY->TYP_F ))
endif

if ok
   d2g := DOKTYPY->MAGAZYNG
   d2p := DOKTYPY->MAGAZYNP
   przeci := ( d1g + d2g = 3 ) .or. ( d1p + d2p = 3 )
   Generowanie( a, b,, przeci )  
endif

DOKTYPY->( DBSeek( DOKUM->TYP ))

return .t.

******************************************************************************

procedure GenerujFisk()

local i, f

if !File( 'f.exe' ); return; endif

   if Left( DOKUM->UWAGI, 4 ) == 'FISK'
      Alarm('Ten dokument juß byí drukowany na drukarce fiskalnej.')
   elseif Alarm( 'Drukowaç dokument na drukarce fiskalnej ?', nt ) = 2
      i := 1
      ON( 'TOWARY' ); set filter to
      ON( 'TOW_FIS', 0,,, .t. )
      ON( 'SPEC' )
      DBSeek( DOKUM->ID )
      while SPEC->ID_D = DOKUM->ID .and. !Eof()
            TOW_FIS->( DBAppend())
            TOW_FIS->LPP := i++
            TOW_FIS->INDEKS := TOWARY->( GetPole( 1, 'SPEC->ID_T', 'INDEKS' ))
            TOW_FIS->INDEKS := ''
            TOW_FIS->ILOSC := SPEC->ILOSC
            TOW_FIS->VAT := TOWARY->VAT
            TOW_FIS->NAZWA := TOWARY->NAZWA_FIS
            TOW_FIS->JM := TOWARY->JM
            TOW_FIS->CENA_PUP := SPEC->CENA
            TOW_FIS->BRUTTO := Grosz( SPEC->CENA * SPEC->ILOSC )
            TOW_FIS->SWWKU := TOWARY->SWW
            skip
      enddo
      Zwolnij( 'TOW_FIS' )
      DBCommitAll()
      RunProgram('f.exe,tow_fis.dbf ' + StrTran( DOKUM->WYSTAWIL, ' ', '_' ))
      f := 'fisk_' + Left( StrTran( DOKUM->WYSTAWIL, ' ', '_' ), 3 ) + '.txt'
      if File( f )
         RunProgram( 'del,' + f )
      else
         ON( 'TOW_FIS', 0 )
         DOKUM->( Blokuj_R())
         DOKUM->UWAGI := 'FISK: ' + AllS( TOW_FIS->LPP ) + ' ' + DOKUM->UWAGI
         DOKUM->( OdBlokuj_R())
         Zwolnij( 'TOW_FIS' )
      endif
      Select( 'DOKUM' )
   endif

******************************************************************************

procedure GenerujKASA( wa )

local x

if wa = 0; return; endif
if !File( 'rej_ka.dbf' ); return; endif

   ON( 'FIRMY' ); DBSeek( DOKUM->NABYWCA )
   ON( 'REJ_KA' )
   DBAppend()
   REJ_KA->LP:=GetLast(1,1)+1
   REJ_KA->NUMER:='KP'
   REJ_KA->NRK:=''
   REJ_KA->OTWARTY:=' '
   REJ_KA->D1:=Datee()
   REJ_KA->D2:=Datee()
   REJ_KA->D3:=Datee()
   REJ_KA->D4:=Datee()
   REJ_KA->NRKONT := FIRMY->ID_F
   REJ_KA->PSKONT := FIRMY->INDEKS
   REJ_KA->NIP    := FIRMY->NIP
   REJ_KA->NAZWA  := FIRMY->NAZWA1
   REJ_KA->ADRES  := FIRMY->( if(Empty(x:=KOD),'',x+' ')+AllTrim(MIASTO)+if(Empty(x:=ADRES),'', ', '+x)+Space(100) )
   REJ_KA->PRZEDMIOT  := DOKUM->( AllTrim( TYP ) + ' ' + AllTrim( INDEKS ) + if( Left( UWAGI, 4 ) == 'FISK', ' (' + AllTrim( UWAGI ) + ')', '' ))
   REJ_KA->K10    := wa
   REJ_KA->K11    := 0
   private pbaza := baza
   baza := 'REJ_KA'
   if NewSysForm( 'REJ_KA,Wygenerowany dokument kasowy,,,,,,,10')
      Wydruk(if(REJ_KA->K10#0,'KP.wyd','KW.wyd'),'REJ_KA',,,,1)
   else
      BDelete()
   endif
   baza := pbaza
   Select( 'DOKUM' )

******************************************************************************
* Uzupe'nienia dokument¢w kontrahenta o dokumenty typu rachunki, rozl., umowy
* x - numer kontrahenta

procedure KontrUzup( x, a1, a2, a3 )

local bb := Alias()

if a1 = NIL; a1 := 'aro'; endif
if a2 = NIL; a2 := 'ara'; endif
if a3 = NIL; a3 := 'umz'; endif

if ( x = NIL )
   if Get_Okres( @data_od, @data_do ) = NIL; return .f.; endif
	zap
	ON( 'FIRMY' )
endif

if !Empty( a1 )

ON( 'AUTORRO' )
while !Eof()
      if ( x = NIL )
			FIRMY->( GetPole( 1, 'AUTORRO->ID_A', 'INDEKS' ))
		endif
      if ( x = NIL ) .or. ( ID_A = x )
	      if ( x = NIL ) .and. !(( data_od <= DATA_W ) .and. ( DATA_W <= data_do ))
				skip
				loop
			endif
         ( bb )->( DBAppend())
         ( bb )->TYP := a1
         ( bb )->INDEKS := AllTrim( INDEKS ) + ', ' + AllS( ILOSC_S )
         ( bb )->NABYWCA := FIRMY->ID_F
         ( bb )->INDEKS_F := FIRMY->INDEKS
         ( bb )->DATAW := DATA_W
         ( bb )->DATAS := DATA_W
      endif
      skip
enddo

Zwolnij( 'AUTORRO' )

endif

if !Empty( a2 )

ON( 'AUTORZY' )

while !Eof()
      if ( x = NIL )
			FIRMY->( GetPole( 1, 'AUTORZY->ID_A', 'INDEKS' ))
		endif
      if ( x = NIL ) .or. ( ID_A = x )
	      if ( x = NIL ) .and. !(( data_od <= DATA_W ) .and. ( DATA_W <= data_do ))
				skip
				loop
			endif
         ( bb )->( DBAppend())
         ( bb )->TYP     := a2
         ( bb )->INDEKS  := AllS( CENA ) + '*' + AllTrim(Zera_won( AllS( ILOSC ))) + '=' + AllS( WARTOSC )
         ( bb )->NABYWCA := FIRMY->ID_F
         ( bb )->INDEKS_F:= FIRMY->INDEKS
         ( bb )->DATAW   := DATA_W
         ( bb )->DATAS   := DATA_W
         ( bb )->NETTO22 := WARTOSCB   && wart brutto
         ( bb )->NETTO7  := PROCENTK   && proc koszt uz przy
         ( bb )->NETTO0  := WARTOSCK   && wart koszt uz przy
         ( bb )->NETTOZW := WARTOSCD   && wart doch
         ( bb )->VAT22   := PROCENTP   && proc pod doch
         ( bb )->VAT7    := WARTOSCP   && wartosc podatku doch
         ( bb )->WPLACONO:= WARTOSCW
         ( bb )->WARTOSC := WARTOSCW
      endif
      skip
enddo
Zwolnij( 'AUTORZY' )

endif

if !Empty( a3 )

ON( 'UMOWYZLE' )
while !Eof()
      if ( x = NIL )
			FIRMY->( GetPole( 1, 'UMOWYZLE->ID_A', 'INDEKS' ))
		endif
      if ( x = NIL ) .or. ( ID_A = x )
	      if ( x = NIL ) .and. !(( data_od <= DATA_W ) .and. ( DATA_W <= data_do ))
				skip
				loop
			endif
         ( bb )->( DBAppend())
         ( bb )->TYP     := a3
         ( bb )->INDEKS  := TRESC1
         ( bb )->INDEKS_F:= FIRMY->INDEKS
         ( bb )->NABYWCA := FIRMY->ID_F
         ( bb )->DATAW   := DATA_W
         ( bb )->DATAS   := DATA_W
         ( bb )->NETTO22 := WARTOSCB   && wart brutto
         ( bb )->NETTO7  := PROCENTK   && proc koszt uz przy
         ( bb )->NETTO0  := WARTOSCK   && wart koszt uz przy
         ( bb )->NETTOZW := WARTOSCD   && wart doch
         ( bb )->VAT22   := PROCENTP   && proc pod doch
         ( bb )->VAT7    := WARTOSCP   && wartosc podatku doch
         ( bb )->WPLACONO:= WARTOSCW
         ( bb )->WARTOSC := WARTOSCW
      endif
      skip
enddo
Zwolnij( 'UMOWYZLE' )

endif

Select( bb )
go top

******************************************************************************
* Generowanie dokumentu "ZZ" zamykajÜcego zam¢wienie - r¢wnowaßÜcego ruchy
* towar¢w na zero
*
* td - typ dokumentu

procedure ZamowGenZZ( td )

local a, b, mg, mp, bb := Alias()

if td = NIL; td := "ZZ "; endif

ON( 'DOKUM', 9 )  && Aadd(klucze,'NUMERFD+DtoS(DATAS)+TYP+Str(NABYWCA)')
DBSeek( 'ZAM ' + ZAMOW->INDEKS )
while DOKUM->( NUMERFD = 'ZAM ' + ZAMOW->INDEKS .and. !Eof())

      a := FIRMY->( GetPole( 1, 'DOKUM->MAGAZYN', 'TYP' ))
      mg:= DOKTYPY->( GetPole( 1, 'DOKUM->TYP', 'MAGAZYNG' ))

      b := FIRMY->( GetPole( 1, 'DOKUM->NABYWCA', 'TYP' ))
      mp:= DOKTYPY->( GetPole( 1, 'DOKUM->TYP', 'MAGAZYNP' ))

      if a $ 'pP'; ZamCzesz( DOKUM->MAGAZYN, mg, td ); endif
      if b $ 'pP'; ZamCzesz( DOKUM->NABYWCA, mp, td ); endif

      DOKUM->( DBSkip())
enddo

ON( 'DOKUM', 9 )  && Aadd(klucze,'NUMERFD+DtoS(DATAS)+TYP+Str(NABYWCA)')
DBSeek( 'ZAM ' + ZAMOW->INDEKS )
while DOKUM->( NUMERFD = 'ZAM ' + ZAMOW->INDEKS .and. !Eof())
      if BLOKADA == 'O'; DokClose(); endif
      skip
enddo

Select( bb )

******************************************************************************
* Powpisuj odwrotnÜ praktyk'
*
* ma - magazyn, a raczej kontrahent-produkcja
* ko - kod kierunku operacji
* indeks Nr 9 = Aadd(klucze,'NUMERFD+DtoS(DATAS)+TYP+Str(NABYWCA)')

procedure ZamCzesz( ma, ko, td )

local m := 0, rr

local      wgi, s1i, s2i, s3i, s4i, s5i
local      wg, s1, s2, s3, s4, s5
store 0 to wg, s1, s2, s3, s4, s5

if DOKUM->BLOKADA # ' '; return; endif    && otwarty dokument nie bierz
if DOKUM->TYP == td; return; endif    && "ZZ" nie bierz

if ko = 3 .or. ko = 0; return; endif

if ko = 1; m :=  1; endif
if ko = 2; m := -1; endif

ON( 'SPEC', 1 )   && Aadd(klucze,'ID_D')
SPEC->( DBSeek( DOKUM->ID ))
while SPEC->( ID_D = DOKUM->ID .and. !Eof())
      do case
      case AllTrim( TOWARY->( GetPole( 1, 'SPEC->ID_T', 'INDEKS' ))) == AllTrim( ZAMOW->WGINDP )
         wgi:= SPEC->ID_T
         wg += SPEC->ILOSC * m
      case AllTrim( TOWARY->( GetPole( 1, 'SPEC->ID_T', 'INDEKS' ))) == AllTrim( ZAMOW->S1INDP )
         s1i:= SPEC->ID_T
         s1 += SPEC->ILOSC * m
      case AllTrim( TOWARY->( GetPole( 1, 'SPEC->ID_T', 'INDEKS' ))) == AllTrim( ZAMOW->S2INDP )

         s2i:= SPEC->ID_T
         s2 += SPEC->ILOSC * m
      case AllTrim( TOWARY->( GetPole( 1, 'SPEC->ID_T', 'INDEKS' ))) == AllTrim( ZAMOW->S3INDP )
         s3i:= SPEC->ID_T
         s3 += SPEC->ILOSC * m
      case AllTrim( TOWARY->( GetPole( 1, 'SPEC->ID_T', 'INDEKS' ))) == AllTrim( ZAMOW->S4INDP )
         s4i:= SPEC->ID_T
         s4 += SPEC->ILOSC * m
      case AllTrim( TOWARY->( GetPole( 1, 'SPEC->ID_T', 'INDEKS' ))) == AllTrim( ZAMOW->S5INDP )
         s5i:= SPEC->ID_T
         s5 += SPEC->ILOSC * m
      endcase
      SPEC->( DBSkip())
enddo

rr := DOKUM->( RecNo())
if !DOKUM->( DBSeek( PadR( 'ZAM ' + ZAMOW->INDEKS, 30 ) + DtoS( Datee()) + td + Str( ma )))
   AppendRecord( "DOKUM", { GetLast( 1, 1 ) + 1,"O", td, DOKTYPY->( DokMaska( td )), ma,, Datee(), Datee(), Datee(), Datee(), PadR("przelew/got¢wka",20),, 'ZAM ' + ZAMOW->INDEKS })
   DOKTYPY->( DokIncNr( DOKUM->TYP ))
endif

ON( 'SPEC', 3 )   && Aadd(klucze,'Str(ID_D)+Str(ID_T)')
ZamSpeZZ( wgi, wg )
ZamSpeZZ( s1i, s1 )
ZamSpeZZ( s2i, s2 )
ZamSpeZZ( s3i, s3 )
ZamSpeZZ( s4i, s4 )
ZamSpeZZ( s5i, s5 )

DOKUM->( DBGoTo( rr ))

******************************************************************************

procedure ZamSpeZZ( wgi, wg )

if wgi # NIL .and. wg # 0
   SPEC->( DBGoTop())
   if !SPEC->( DBSeek( Str( DOKUM->ID ) + Str( wgi )))
      AppendRecord( "SPEC", { DOKUM->ID, wgi })
   endif
   SPEC->ILOSC += wg
endif

******************************************************************************

procedure ZamowZamk()

local od, bb := Alias(), ok := .t.

if STATUS == ' '; Alarm( 'Zam¢wienie zamkniëte' ); return; endif

                  && czy wszystkie dokumenty sπ zamkniÍte ?

ON( 'DOKUM', 9 )  && Aadd(klucze,'NUMERFD+DtoS(DATAS)+TYP+Str(NABYWCA)')
DBSeek( 'ZAM ' + ZAMOW->INDEKS )
while DOKUM->( NUMERFD = 'ZAM ' + ZAMOW->INDEKS .and. !Eof())
      if BLOKADA # ' '; ok := .f.; exit; endif
      skip
enddo

Select( bb )

do case

   case STATUS == 'O' .and. ok
        od := Alarm( 'Czy tylko zablokowaç,;czy caíkiem zamknÜç zam¢wienie ?',;
                   { 'Blokada', 'Zamkniëcie' })
        do case
           case od = 0
           case od = 1; ZAMOW->STATUS:='.'
           case od = 2; ZAMOW->STATUS:=' '; ZamowGenZZ()
        endcase
   case STATUS == '.' .and. ok
        if Alarm( 'Caíkiem zamknÜç zam¢wienie ?', nt ) = 2
           ZAMOW->STATUS:=' '; ZamowGenZZ()
        endif
   case STATUS == 'O' .and. !ok
        if 2 = Alarm( 'Nie wszystkie dokumenty sÜ zamkniëte;czy zablokowaç zam¢wienie ?', nt )
           ZAMOW->STATUS:='.'
        endif
   case STATUS == '.' .and. !ok
        if 2 = Alarm( 'Nie wszystkie dokumenty sÜ zamkniëte',;
                    { 'Nie zamykaç', 'ZamknÜç wszystko' })

           ON( 'DOKUM', 9 )  && Aadd(klucze,'NUMERFD+DtoS(DATAS)+TYP+Str(NABYWCA)')
           DBSeek( 'ZAM ' + ZAMOW->INDEKS )
           while DOKUM->( NUMERFD = 'ZAM ' + ZAMOW->INDEKS .and. !Eof())
                 if BLOKADA == 'O'; DokClose(); endif
                 skip
           enddo
           Select( bb ); ZAMOW->STATUS:=' '; ZamowGenZZ()
        endif
endcase

******************************************************************************
* Wype'nianie specyfikacji nowego dokumentu wed'ug zam¢wienia

procedure ZamowFull()

local i

if 0 # ( i := TOWARY->( GetPole( 2, 'Upper(ZAMOW->WGINDP)', 'ID' )))
   ROB->( DBAppend())
   ROB->ID_D := DOKUM->ID
   ROB->ID_T := i
   ROB->ILOSC := ZAMOW->( WGILOSCT - WGILOSCP )
endif

if 0 # ( i := TOWARY->( GetPole( 2, 'Upper(ZAMOW->S1INDP)', 'ID' )))
   ROB->( DBAppend())
   ROB->ID_D := DOKUM->ID
   ROB->ID_T := i
   ROB->ILOSC := ZAMOW->( S1ILOSCT - S1ILOSCP )
endif

if 0 # ( i := TOWARY->( GetPole( 2, 'Upper(ZAMOW->S2INDP)', 'ID' )))
   ROB->( DBAppend())
   ROB->ID_D := DOKUM->ID
   ROB->ID_T := i
   ROB->ILOSC := ZAMOW->( S2ILOSCT - S2ILOSCP )
endif

if 0 # ( i := TOWARY->( GetPole( 2, 'Upper(ZAMOW->S3INDP)', 'ID' )))
   ROB->( DBAppend())

   ROB->ID_D := DOKUM->ID
   ROB->ID_T := i
   ROB->ILOSC := ZAMOW->( S3ILOSCT - S3ILOSCP )
endif



if 0 # ( i := TOWARY->( GetPole( 2, 'Upper(ZAMOW->S4INDP)', 'ID' )))
   ROB->( DBAppend())
   ROB->ID_D := DOKUM->ID
   ROB->ID_T := i


   ROB->ILOSC := ZAMOW->( S4ILOSCT - S4ILOSCP )
endif


if 0 # ( i := TOWARY->( GetPole( 2, 'Upper(ZAMOW->S5INDP)', 'ID' )))
   ROB->( DBAppend())
   ROB->ID_D := DOKUM->ID
   ROB->ID_T := i
   ROB->ILOSC := ZAMOW->( S5ILOSCT - S5ILOSCP )
endif

wy := 2
ROB->( DBGoTop())
PressKey("F")

******************************************************************************
* jesteûmy w DOKUM z filtrem na "do dokumentu", np.: ZAM 1/2000

procedure ZamObl()




local a, b, mg, mp, bb := Alias()

ZAMOW->WGILOSCP := 0
ZAMOW->S1ILOSCP := 0
ZAMOW->S2ILOSCP := 0
ZAMOW->S3ILOSCP := 0
ZAMOW->S4ILOSCP := 0
ZAMOW->S5ILOSCP := 0

ZAMOW->WGPROCENT:= 0
ZAMOW->S1PROCENT:= 0
ZAMOW->S2PROCENT:= 0
ZAMOW->S3PROCENT:= 0
ZAMOW->S4PROCENT:= 0
ZAMOW->S5PROCENT:= 0

ON( 'SPEC' )


Select( bb )
DBSetOrder( 9 )               && NUMERFD + ...
DBSeek( 'ZAM ' + AllTrim( ZAMOW->INDEKS ))
while ( AllTrim( NUMERFD ) = 'ZAM ' + AllTrim( ZAMOW->INDEKS )) .and. !Eof()

      if ( BLOKADA # 'O' ) .and.;
         ( TYP # 'ZZ ' )

         a := FIRMY->( GetPole( 1, 'DOKUM->MAGAZYN', 'TYP' ))
         mg:= DOKTYPY->( GetPole( 1, 'DOKUM->TYP', 'MAGAZYNG' ))

         b := FIRMY->( GetPole( 1, 'DOKUM->NABYWCA', 'TYP' ))
         mp:= DOKTYPY->( GetPole( 1, 'DOKUM->TYP', 'MAGAZYNP' ))

         if a == 'P'; ZamPrakt( mg ); endif
         if b == 'P'; ZamPrakt( mp ); endif

      endif

      skip

enddo

******************************************************************************
* Powpisuj praktyk' i procenty

procedure ZamPrakt( mg )

local m := 0

if mg = 3 .or. mg = 0; return; endif

if mg = 1; m :=  1; endif
if mg = 2; m := -1; endif

SPEC->( DBSeek( DOKUM->ID ))
while SPEC->( ID_D = DOKUM->ID .and. !Eof())
      do case

      case AllTrim( TOWARY->( GetPole( 1, 'SPEC->ID_T', 'INDEKS' ))) == AllTrim( ZAMOW->WGINDP )
         ZAMOW->WGILOSCP += SPEC->ILOSC * m * -1  && spodziewamy si' rozchod¢w
         if ZAMOW->WGILOSCT # 0
            ZAMOW->WGPROCENT:= 100 * ZAMOW->WGILOSCP / ZAMOW->WGILOSCT
         endif
      case AllTrim( TOWARY->( GetPole( 1, 'SPEC->ID_T', 'INDEKS' ))) == AllTrim( ZAMOW->S1INDP )
         ZAMOW->S1ILOSCP += SPEC->ILOSC * m
         if ZAMOW->S1ILOSCT # 0
            ZAMOW->S1PROCENT:= 100 * ZAMOW->S1ILOSCP / ZAMOW->S1ILOSCT
         endif
      case AllTrim( TOWARY->( GetPole( 1, 'SPEC->ID_T', 'INDEKS' ))) == AllTrim( ZAMOW->S2INDP )
         ZAMOW->S2ILOSCP += SPEC->ILOSC * m






         if ZAMOW->S2ILOSCT # 0
            ZAMOW->S2PROCENT:= 100 * ZAMOW->S2ILOSCP / ZAMOW->S2ILOSCT
         endif
      case AllTrim( TOWARY->( GetPole( 1, 'SPEC->ID_T', 'INDEKS' ))) == AllTrim( ZAMOW->S3INDP )
         ZAMOW->S3ILOSCP += SPEC->ILOSC * m
         if ZAMOW->S3ILOSCT # 0
            ZAMOW->S3PROCENT:= 100 * ZAMOW->S3ILOSCP / ZAMOW->S3ILOSCT
         endif
      case AllTrim( TOWARY->( GetPole( 1, 'SPEC->ID_T', 'INDEKS' ))) == AllTrim( ZAMOW->S4INDP )
         ZAMOW->S4ILOSCP += SPEC->ILOSC * m
         if ZAMOW->S4ILOSCT # 0
            ZAMOW->S4PROCENT:= 100 * ZAMOW->S4ILOSCP / ZAMOW->S4ILOSCT
         endif
      case AllTrim( TOWARY->( GetPole( 1, 'SPEC->ID_T', 'INDEKS' ))) == AllTrim( ZAMOW->S5INDP )
         ZAMOW->S5ILOSCP += SPEC->ILOSC * m
         if ZAMOW->S5ILOSCT # 0
            ZAMOW->S5PROCENT:= 100 * ZAMOW->S5ILOSCP / ZAMOW->S5ILOSCT
         endif
      endcase
      SPEC->( DBSkip())
enddo

******************************************************************************

procedure DodajPD()

local s, l, n, x, i, h

n := WGILOSCT / 7.5
x := DATAT - DATAW - 1

if x = 0
   h := AllS( x ) + ' d¢b pracy na ' + 'bardzo dußej liczbie stanowisk'
else

*   h := AllS( x ) + ' d¢b pracy na ' + AllS( n / x ) + ' stanowiskach'

   i := Round( n / x, 2 ) + 0.49       && 2->2.49, 2.01->2.5
   i := Round( i, 0 )                  && 2.49->2, 2.5->3

   x := Round( n / i, 2 )
   h := AllS( x ) + ' d¢b pracy na ' + AllS( i ) + ' stanowiskach,' + EOL
   h += DtoC( DATAW ) + ' - ' + DtoC( DATAW + 1 ) + ' - przygotowania' + EOL

   i := Round( x, 2 ) + 0.49           && 2->2.49, 2.01->2.5
   i := Round( i, 0 )                  && 2.49->2, 2.5->3
   x := DATAW + 1 + i
   h += DtoC( DATAW + 1 ) + ' - ' + DtoC( x ) + ' - praca uko§czona na ' + AllS( DATAT - x ) + ' dni przed terminem (' + DtoC( DATAT ) + ')'
endif

s := AllS( n ) + ' punktod¢b, lub 1 doba przygotowa§ i ' + h + EOL

l := Len( s )

if !( Left( ZAMOW->OPIS, l ) == s )
   ZAMOW->OPIS := s + ZAMOW->OPIS
endif

******************************************************************************

procedure TowaryPrze()

local r1, r2, r3, r4, r5, od, bb := Alias(), rr := RecNo()

if Alarm( 'Podane rabaty dla wszystkich towar¢w ?', nt ) # 2; return; endif

od := Alarm( 'Przepisaç "cenë sprzedaßy 1";na miejsce "ceny hurtowej" ?', nt )

r1 := RABAT_S
r2 := RABAT_S2
r3 := RABAT_S3
r4 := RABAT_S4
r5 := RABAT_S5

go top
while !Eof()

      if od = 2
         ( bb )->CENA_SH := ( bb )->CENA_S
      endif

      ( bb )->RABAT_S := r1
      ( bb )->RABAT_S2:= r2
      ( bb )->RABAT_S3:= r3
      ( bb )->RABAT_S4:= r4
      ( bb )->RABAT_S5:= r5

      ( bb )->CENA_S  := Grosz( CENA_SH * ( 100 - RABAT_S  ) * 0.01 )
      ( bb )->CENA_S2 := Grosz( CENA_SH * ( 100 - RABAT_S2 ) * 0.01 )
      ( bb )->CENA_S3 := Grosz( CENA_SH * ( 100 - RABAT_S3 ) * 0.01 )
      ( bb )->CENA_S4 := Grosz( CENA_SH * ( 100 - RABAT_S4 ) * 0.01 )

      ( bb )->CENA_S5 := Grosz( CENA_SH * ( 100 - RABAT_S5 ) * 0.01 )

      skip
enddo
DBGoTo( rr )

******************************************************************************

procedure AutorRoY()

local bb := Alias(), rr := RecNo(), ii := IndexOrd(), rrr
private a1, a2, a3, a4, a5, a6

a1 := ID_T
a2 := ID_A
a3 := TOWARK->(GetPole(2,'a1','DATA_ZU'))
a4 := TOWARK->DATA_OR
a5 := TOWARK->DATA_1
a6 := TOWARK->DATA_2
a7 := TOWARK->PROW_KWOTA
a8 := ILOSC_S
a9 := Grosz( a7 * a8 )

ON( 'AUTORZY', 0 ); DBGoBottom(); rrr := RecNo()
if NewSysDopisz('AUTORZY,Nowa pozycja,,,73,AutorzySet(),,,17',,,'AppendRecord("AUTORZY",{GetLast(1,1)+1,a2,a1,a7,a8,a9,a5,a6,Datee(),a3,a4,,50,,,20},1)')
   if Alarm( 'Drukowaç rachunki ?', nt ) = 2
      DBSetOrder( 0 )
      DBGoTo( rrr )
      DBSkip()
      while !Eof()
            Drukuj()

            DBSkip()
      enddo
   endif
endif

Select( bb ); DBSetOrder( ii ); DBGoTo( rr )

******************************************************************************
* Aktualizacja cen zakupu w analityce towarÛw

procedure AktCZ( h )

local ii, psiec, bb := Alias(), t, m, c, i, r1, r2, jeden, ktory

if Alarm( h, nt ) # 2; return; endif

ktory := ID
jeden := Alarm( 'Podmagazyn numer ' + AllS( ktory ) + ' ?', nt )
if jeden = 0; return; endif
jeden := ( jeden  = 2 )


ii := IndexOrd()

TOWARY->( DBSetOrder( 1 ))

ON( 'DOKUM', 4 )     && Str(NABYWCA)+DtoS(DATAS)
ON( 'SPEC', 3 )      && Str(ID_D)+Str(ID_T)+Str(CENA)

psiec := siec
siec := .f.

Zwolnij( 'MAGAZYNY' )
ON( 'MAGAZYNY', 0 )
Przerwa( LastRec())
while !Eof()
   if jeden .and. ( ktory # ID ); skip; loop; endif
   t := ID_T
   m := ID
   c := CENA_Z
   ok := .f.
   DOKUM->( DBSeek( Str( MAGAZYNY->ID + 1 ), .t. ))
   DOKUM->( DBSkip( -1 ))
   while ( m = DOKUM->NABYWCA ) .and. DOKUM->( !Bof())
      if Inn( DOKUM->TYP, 'PW ,INW' )
         if SPEC->( DBSeek( Str( DOKUM->ID ) + Str( MAGAZYNY->ID_T )))
            c := SPEC->CENA
            ok := .t.
            exit
         endif
      endif
      DOKUM->( DBSkip( -1 ))
   enddo
   if ok
      MAGAZYNY->CENA_Z := c
   else
      TOWARY->( DBSeek( MAGAZYNY->ID_T ))
      MAGAZYNY->CENA_Z := TOWARY->CENA_S
   endif
   skip
   Przerwa()
enddo
Przerwa( 0 )

ON( 'MAGAZYNY', 2 )     && Str(ID_T)+Str(ID)+Str(CENA_Z)
Przerwa( LastRec())
t := ID_T
m := ID
c := CENA_Z
i := ILOSC
r1 := RecNo()
skip
while !Eof()
   if jeden .and. ( ktory # ID ); skip; loop; endif
   if t = ID_T .and. m = ID .and. c = CENA_Z
      r2 := RecNo()
      ? 'T=' + AllS( t ) + '/M=' + AllS( m ) + '/C=' + AllS( c )
      MAGAZYNY->ILOSC := MAGAZYNY->ILOSC + i
      DBGoTo( r1 )
      BDelete()
      DBGoTo( r2 )
   endif
   t := ID_T
   m := ID
   c := CENA_Z
   i := ILOSC
   r1 := RecNo()
   skip
   Przerwa()
enddo
Przerwa( 0 )

siec := psiec

Zwolnij( 'MAGAZYNY' )
ON( 'MAGAZYNY', ii )
Select( bb )

******************************************************************************

procedure AktMZ( h )

local rr, ii, idt, cz, rrb, si
local s0, s1, wcz, cbuf, minCZ, maxCZ, firCZ, lasCZ, minDATA, maxDATA

if h # NIL
   if Alarm( h, nt ) # 2; return; endif
endif

rr := RecNo()
ii := IndexOrd()

ON( 'MAGAZYNY', 3 )    && Aadd(klucze,'Str(ID_T)+Str(CENA_Z)+Str(ID)')
while !Eof()
      idt := ID_T
      cz := CENA_Z
      si := 0
      while ID_T = idt .and. cz = CENA_Z .and. !Eof()
            if ID # 0
               si += ILOSC

            endif
            skip
      enddo

      rrb := RecNo()

      if DBSeek( Str( idt, 10 ) + Str( cz, 12, 2 ) + Str( 0, 10 ))
         MAGAZYNY->( Blokuj_R())
      else
         DBAppend()
         MAGAZYNY->ID_T := idt
         MAGAZYNY->ID := 0
         MAGAZYNY->CENA_Z := cz
      endif
      MAGAZYNY->ILOSC := si
      MAGAZYNY->( OdBlokuj_R())
      DBGoTo( rrb )
enddo

MAGAZYNY->( DBSetOrder( 2 ))     && Str(ID_T)+Str(ID)+Str(CENA_Z)
ON( 'TOWARY' )
while !Eof()
      s0 := 0
      s1 := 0
      smg := 0
      wcz:= 0
      minCZ := NIL
      maxCZ := NIL
      firCZ := 0
      lasCZ := 0
      minDATA := NIL
      maxDATA := NIL
      MAGAZYNY->( DBSeek( Str( TOWARY->ID )))
      while MAGAZYNY->ID_T = TOWARY->ID .and. MAGAZYNY->( !Eof())
            if MAGAZYNY->ID = 0
               if MAGAZYNY->CENA_Z # 0.00
                  if minCZ = NIL .or. minCZ > MAGAZYNY->CENA_Z
                     minCZ := MAGAZYNY->CENA_Z   && tani
                  endif
                  if maxCZ = NIL .or. maxCZ < MAGAZYNY->CENA_Z
                     maxCZ := MAGAZYNY->CENA_Z   && drogi
                  endif
                  if minDATA = NIL .or. minDATA > MAGAZYNY->DATA_Z
                     minDATA := MAGAZYNY->DATA_Z   && first
                     firCZ := MAGAZYNY->CENA_Z
                  endif
                  if maxDATA = NIL .or. maxDATA < MAGAZYNY->DATA_Z
                     maxDATA := MAGAZYNY->DATA_Z   && last
                     lasCZ := MAGAZYNY->CENA_Z
                  endif

               endif
               s0 += MAGAZYNY->ILOSC
               wcz += MAGAZYNY->( Grosz( ILOSC * CENA_Z ))
            else
               s1 += MAGAZYNY->ILOSC
               if (MAGAZYNY->ID == NRMG )
                  smg += MAGAZYNY->ILOSC
               endif
            endif
            MAGAZYNY->( DBSkip())
      enddo
      if .t.               && TOWARY->( DBSeek( SPEC->ID_T ))
         TOWARY->( Blokuj_R())
         TOWARY->STAN := s0
         TOWARY->STAN_MG := smg
*         if TowOstMini .and. ( TOWARY->STAN < TOWARY->STAN_MIN )
*            Alarm( '"' + AllTrim( TOWARY->NAZWA ) + '";stan ponißej minimum o ' + AllS( TOWARY->STAN_MIN - TOWARY->STAN ))
*         endif
         if TowZmiCenW
         if wcz = 0.00 .or. s0 = 0.000
            do case
               case MagStanMin = 1; cbuf := firCZ && gdzie
               case MagStanMin = 2; cbuf := lasCZ && by
               case MagStanMin = 3; cbuf := minCZ && go
               case MagStanMin = 4; cbuf := maxCZ && tu
            endcase
            TOWARY->CENA_Z := if( cbuf = NIL, 0, cbuf )
         else
            TOWARY->CENA_Z := if( s0 = 0, 0, Grosz( wcz / s0 ))
         endif
         endif
      endif
      TOWARY->( OdBlokuj_R())
      TOWARY->( DBSkip())
enddo

ON( 'MAGAZYNY' )
DBGoTo( rr )
DBSetOrder( ii )
wy := 2

******************************************************************************

procedure UGBT( a, x, podanytyp )

if podanytyp # NIL
   globalbuf := podanytyp
   return
endif

if DokTypWyb
   globalbuf := DOKUM->TYP
   if x = NIL; x := 1; endif
*   if a = NIL; a := 'DOKTYPY,doktypyd.txt,,1,"' + globalbuf + '"'; endif
   if a = NIL; a := 'DOKTYPY,doktypyd.txt'; endif
   ViewDBF( a, .t. )
   globalbuf := DOKTYPY->TYP
else
   if !Empty( TYP ); globalbuf := TYP; endif
endif

******************************************************************************

procedure DIN( x )

local rr, ii, bb, kk, nn, ww, mm := {}, lastdok

DOKTYPY->(DokIncNr(DOKUM->TYP))

if (left(DOKUM->TYP,2)=='FV' .or. left(DOKUM->TYP,2)=='RW');   //TYP in ('FV','RW')
   .and. DOKUM->WARTOSC=0
   bb := Alias()
   rr := DOKUM->(RecNo())
   ii := DOKUM->(IndexOrd())
   kk := DOKUM->NABYWCA
   nn := 0
   ww := 0

   Czek(1)
   Select ('DOKUM')
   DBSetOrder(4)               // Str(NABYWCA,10)+...
   DBSeek( Str(kk,10))
   while NABYWCA==kk .and. !Eof()
         if left(TYP,2)=='FV'
            if RecNo()<>rr
               lastdok := DOKUM->DATAW
            endif
            if WARTOSC-WPLACONO <>0
               Aadd( mm, TYP + ' ' + INDEKS + ' z dnia ' + DtoA(DATAW) + ': pozostaje ' + Transform(WARTOSC-WPLACONO, '999,999,999.99 zí'))
               ww += WARTOSC-WPLACONO
               nn ++ 
            endif
         endif
         DBSkip()
   enddo
   Czek(0)
   
   Select(bb)
   DOKUM->(DBSetOrder(ii))
   DOKUM->(DBGoTo(rr))
   
   if nn > 0
      Alarm('Brak píatnoûci za ' + AllS(nn) + ' faktur razem na kwotë: ' + AllS(ww,'999,999,999.99 zí'), mm )
   endif
   
   if lastdok <> NIL .and. (Date() - lastdok > 50)
      Alarm('Ostatnia faktura dawniej niz 50 dni temu, bo w dniu: ' + DtoC( lastdok ))
   endif
endif

LastZnak := x

******************************************************************************
* bez = bez niuansÛw

function TGP( x, y, z, bez )

local r := Row(), c := Col(), bb := Alias(), xx, rr, ii, rrr, iii, typj

if bez # NIL
   ViewDBF( z, .t. )
elseif &x < 1
   if TowPodmag .and.;
      Inn( DOKUM->TYP, DokPodmag, 1 ) .and.;
      Inn( DOKUM->TYP_F, TypyKonMAG )
//	Alarm('aaa')
      if TowUstawRe = 0               && pierwsze wejûcie do specyfikacji
         ON( 'TOWARYBU',,,, .t. )
         ON( 'TOWARY' )
         ON( 'MAGAZYNY' )

			DOKTYPY->( DBSeek( DOKUM->TYP ))
			if DOKTYPY->MAGAZYNP = 2
	         xx := DOKUM->NABYWCA
			else
	         xx := DOKUM->MAGAZYN
			endif
         rr := DOKUM->( RecNo())
         ii := DOKUM->( IndexOrd())
         rrr := SPEC->( RecNo())
         iii := SPEC->( IndexOrd())

         SPEC->( DBSetOrder( 3 ))    && Str( ID_D ) + Str( ID_T ) + Str( cena )

         DOKUM->( DBSetOrder( 4 ))         && Str( nabywca ) + DtoS( datas )

         DOKUM->( DBSeek( Str( xx + 1, 10 ), .t. ))   && za ostatnim
         DOKUM->( DBSkip( -1 ))                       && ostatni
         if rr = DOKUM->( RecNo())                    && bießÜcy
            DOKUM->( DBSkip( -1 ))                    && poprzedni
         endif
         if xx # DOKUM->NABYWCA                       && obcy
            DOKUM->( DBGoTo( rr ))
            DOKUM->( DBSetOrder( ii ))
         endif

         MAGAZYNY->( DBSeek( Str( xx, 10 )))
         while MAGAZYNY->ID = xx .and. MAGAZYNY->( !Eof())
               if MAGAZYNY->ILOSC<>0 .and. TOWARY->( DBSeek( MAGAZYNY->ID_T ))
                  KopiujRec( 'TOWARY', 'TOWARYBU' )
                  SPEC->( DBSeek( Str( DOKUM->ID, 10 ) + Str( MAGAZYNY->ID_T, 10 ) + Str( MAGAZYNY->CENA_Z )))
                  TOWARYBU->CENA_S := MAGAZYNY->CENA_Z
                  TOWARYBU->STAN_MIN := SPEC->ILOSC
               endif
               MAGAZYNY->( DBSkip())
         enddo

         DOKUM->( DBGoTo( rr ))
         DOKUM->( DBSetOrder( ii ))
         SPEC->( DBGoTo( rrr ))
         SPEC->( DBSetOrder( iii ))

*                  KopiaRec( 'TOWARY', 'TOWARYBU',, .t.,;
*                   { || MAGAZYNY->( DBSeek( Str( DOKUM->NABYWCA ) + Str( TOWARY->ID )))},;
*                   { || if( MAGAZYNY->( !Eof()), TOWARYBU->CENA_S := MAGAZYNY->CENA_Z,), .f. })
*              endif
         Select( 'TOWARYBU' ); DBSetOrder( 4 ); DBGoTop(); TowUstawRe := RecNo()
         Select( bb )
      endif
      z := StrTran( z, 'towaryh', 'towarybu' )
      z := StrTran( z, 'TOWARY', 'TOWARYBU' )

   elseif TowPodmag .and.;
          Inn( DOKUM->TYP, DokNorOst, 1 ) .and.;
          DOKUM->TYP_F $ TypyKonMAG

      if TowUstawRe = 0               && pierwsze wejûcie do specyfikacji

         ON( 'TOWARYUB',,,, .t. )
         ON( 'TOWARY' )
         ON( 'MAGAZYNY' )

			typj := DOKUM->TYP
			DOKTYPY->( DBSeek( DOKUM->TYP ))
			if DOKTYPY->MAGAZYNG = 1
	         xx := DOKUM->NABYWCA
			else
	         xx := DOKUM->NABYWCA
//	         xx := DOKUM->MAGAZYN
			endif
         rr  := DOKUM->( RecNo())

         ii  := DOKUM->( IndexOrd())
         rrr := SPEC->( RecNo())
         iii := SPEC->( IndexOrd())

         SPEC->( DBSetOrder( 3 ))    && Str( ID_D ) + Str( ID_T ) + Str( cena )
         DOKUM->( DBSetFilterTo())
         DOKUM->( DBSetOrder( 4 ))         && Str( nabywca ) + DtoS( datas )
         DOKUM->( DBSeek( Str( xx + 1, 10 ), .t. ))   && za ostatnim
         DOKUM->( DBSkip( -1 ))                       && ostatni dok.
   while DOKUM->(( NABYWCA = xx ) .and. !Bof())
			if DOKUM->TYP $ doknanal
				if ( 'J' $ typj ) .and. ( 'J' $ DOKUM->TYP ); exit; endif
				if !( 'J' $ typj ) .and. !( 'J' $ DOKUM->TYP ); exit; endif
			endif
         DOKUM->( DBSkip( -1 ))                       && ostatnia faktura
   enddo
         if rr = DOKUM->( RecNo())                    && bießÜcy
            DOKUM->( DBSkip( -1 ))                    && poprzedni
         endif
         if xx # DOKUM->NABYWCA                       && obcy
            DOKUM->( DBGoTo( rr ))
            DOKUM->( DBSetOrder( ii ))
         endif

         TOWARY->( DBGoTop())
         while TOWARY->( !Eof())
               if SPEC->( DBSeek( Str( DOKUM->ID, 10 ) + Str( TOWARY->ID, 10 )))
                  KopiujRec( 'TOWARY', 'TOWARYUB' )
                  TOWARYUB->STAN_MIN := SPEC->ILOSC
               endif
               TOWARY->( DBSkip())
         enddo

         DOKUM->( DBGoTo( rr ))
         DOKUM->( DBSetOrder( ii ))
         SPEC->( DBGoTo( rrr ))
         SPEC->( DBSetOrder( iii ))

         Select( 'TOWARY' ); DBSetOrder( 4 ); DBGoTop(); TowUstawRe := RecNo()
         Select( bb )
      endif
      z := StrTran( z, 'towaryh', 'towaryub' )
   else
      if TowUstawRe = 0
         Select( 'TOWARY' ); DBSetOrder( 4 ); DBGoTop(); TowUstawRe := RecNo()
         Select( bb )
      endif
   endif
   ViewDBF( z, .t. )
elseif y # NIL
   &y := TOWARY->( GetPole( 1, x, 'INDEKS' ))
endif

if y = NIL
   @ r, c say ''
   Show_Nazwa('TOWARY,55,NAZWA,1',0)
endif

return .t.

******************************************************************************

function FGP( x, y, a, b )

local r := Row(), c := Col()

if a = NIL; a := 'FIRMY,firmyh.txt,,1,vp[4]'; endif


if &x = -1

   ViewDBF( a,.t.)
elseif y # NIL
   &y := Firmy->( GetPole( 1, x, 'INDEKS' ))

endif


if b # NIL
   @ r, c say ''
   Show_Nazwa( b, 0 )
endif

return .t.

******************************************************************************

procedure AutorzySet()

if TOWARK->( GetPole( 2, 'AUTORZY->ID_T', 'ID_A1' )) = 0; return; endif
if TOWARK->ID_A2 # 0 .or. TOWARK->ID_A3 # 0 .or. TOWARK->ID_A4 # 0
   if Alarm( 'Czy generowaç rachunki;dla pozostaíych autor¢w?', tk ) = 1
      if TOWARK->ID_A2 # 0
         KopiujRec( Alias(), Alias())
         replace ID with ID + 1
         replace ID_A with TOWARK->ID_A2
      endif
      if TOWARK->ID_A3 # 0
         KopiujRec( Alias(), Alias())
         replace ID with ID + 1
         replace ID_A with TOWARK->ID_A3

      endif
      if TOWARK->ID_A4 # 0
         KopiujRec( Alias(), Alias())
         replace ID with ID + 1
         replace ID_A with TOWARK->ID_A4
      endif
   endif
endif

******************************************************************************

procedure AutorRoSet()

if TOWARK->( GetPole( 2, 'AUTORRO->ID_T', 'ID_A1' )) = 0; return; endif

TOWARK->( Blokuj_R())
TOWARK->DATA_OR  := AUTORRO->DATA_W
TOWARK->DATA_1   := AUTORRO->DATA_1
TOWARK->DATA_2   := AUTORRO->DATA_2
TOWARK->ILOSC_RD := AUTORRO->ILOSC_T
TOWARK->( OdBlokuj_R())

if TOWARK->ID_A2 # 0 .or. TOWARK->ID_A3 # 0 .or. TOWARK->ID_A4 # 0
   if Alarm( 'Czy generowaç rozliczenia;dla pozostaíych autor¢w?', tk ) = 1
      if TOWARK->ID_A2 # 0
         KopiujRec( Alias(), Alias())
         replace ID with ID + 1
         replace ID_A with TOWARK->ID_A2
         replace INDEKS with GetThis( "INDEKS", "ID_T", ID_T, "ID_A", ID_A )
      endif
      if TOWARK->ID_A3 # 0
         KopiujRec( Alias(), Alias())
         replace ID with ID + 1
         replace ID_A with TOWARK->ID_A3
         replace INDEKS with GetThis( "INDEKS", "ID_T", ID_T, "ID_A", ID_A )
      endif
      if TOWARK->ID_A4 # 0
         KopiujRec( Alias(), Alias())
         replace ID with ID + 1

         replace ID_A with TOWARK->ID_A4
         replace INDEKS with GetThis( "INDEKS", "ID_T", ID_T, "ID_A", ID_A )
      endif
   endif
endif

******************************************************************************

function Nakladli( t, d1, d2 )

local x, i := 0

x := TOWARK->( GetPole( 2, t, 'ID' ))
TOWARKS->( DBSeek( Str( x )))
while TOWARKS->ID_K = x .and. TOWARKS->( !Eof())
      if d1 <= TOWARKS->DATA .and. TOWARKS->DATA <= d2

         i += TOWARKS->NAKLAD
      endif
      TOWARKS->( DBSkip())
enddo

return i

******************************************************************************
* Test daty wygaûni'cia umowy

procedure TestDATA_WU( t, d )

local x, dd

dd:= TOWARK->( GetPole( 2, t, 'DATA_WU' ))
x := ( dd - d )
if x < TowOstWU
   Alarm('Umowa z autorem wygasa ' + DtoC( dd ) + ' (za ' + AllS( x ) + ' dni).')
endif

return .t.

******************************************************************************

function DataRW()

return if( DataRW_0 = NIL, 1,;
           DOKUM->( if( TYP == "RW " .and. DATAS <= DataRW_0, 0, 1 )))

******************************************************************************

procedure DokAna8( a, b, c, h, hh )

DokAna7( a, b, c, h, hh, .t. )

******************************************************************************

procedure DokAna7( a, b, c, h, hh, zcenami )

local tab, it, pr, ro, wa
local mn1, mn2, mnod, mnbu
private typyp, typyr, zmroli := "T", nrp := 0, inp := Space(15), cenyza := "T"

if zcenami = NIL; zcenami :=.f.; endif

b := if( b # NIL, b, '' )
typyp := PadR( b, 50 )

c := if( c # NIL, c, '' )
typyr := PadR( c, 50 )

GetIni(,,@tab)

if Len( tab ) > 0 .and. !Empty( tab[ 1 ])
   typyp := PadR( tab[ 1 ], Len( typyp ))
endif

if Len( tab ) > 1 .and. !Empty( tab[ 2 ])
   typyr := PadR( tab[ 2 ], Len( typyr ))
endif

if Len( tab ) > 2 .and. !Empty( tab[ 3 ])
   zmroli := tab[ 3 ]

endif

if Len( tab ) > 3 .and. !Empty( tab[ 4 ])
   nrp := Val( tab[ 4 ])
endif


if zcenami

if Len( tab ) > 4 .and. !Empty( tab[ 5 ])

   cenyza := tab[ 5 ]
endif
endif

if Ana_Daty_B; data2 := Datee(); endif

if NewSysForm( a )
   Czek( 1 )
   DBZap('')
   typyp := AllTrim( typyp )
   typyr := AllTrim( typyr )

   MAGAZYNY->( DBSetOrder( 1 ))

*if Empty( inp )
*   MAGAZYNY->( DBGoTop())
*else
   MAGAZYNY->( DBSeek( Str( nrp, 10 )))
*endif

mnod := .f.    && domyûlnie "mnoßnik odwrotnie" = NIE
*while if( Empty( inp ), .t., MAGAZYNY->ID = nrp ) .and. MAGAZYNY->( !Eof())
while MAGAZYNY->ID = nrp .and. MAGAZYNY->( !Eof())

   TOWARY->( DBSetOrder( 1 ))   && ID
   SPEC->( DBSetOrder( 3 ))     && Str( dokument ) + Str( towar )
   DOKUM->( DBSetOrder( 3 ))    && DtoS( DATAS ) + INDEKS
*   DOKUM->( DBSeek( DtoS( data1 ), .t. ))
   DOKUM->( DBGoTop())
   Przerwa( DOKUM->( LastRec()))

   it := MAGAZYNY->ID_T

	if DBSeek( it ); MAGAZYNY->( DBSkip()); loop; endif

   DBAppend()
  	replace ID_T with it

   while DOKUM->DATAS <= data2 .and. !( DOKUM->( Eof()))
         if Empty( inp )
            nrp := -0.1
            mnod := .f.    && domyûlnie "mnoßnik odwrotnie" = NIE
         elseif MZzalezny .and. nrp = 0
         elseif MZzalezny
               if ( nrp # DOKUM->MAGAZYN ) .and. ( nrp # DOKUM->NABYWCA )
                  DOKUM->( DBSkip())
                  loop
               endif
               mnod := ( nrp = DOKUM->NABYWCA )    && odwrotna rola dokumentu
         else
            if nrp # DOKUM->MAGAZYN
               DOKUM->( DBSkip())
               loop
            endif
         endif
         mn1 := 0
         mn2 := 0
         if (( ','+AllTrim(DOKUM->TYP)+',') $ (','+typyp+','))
            mn1 := 1
         endif
         if (( ','+AllTrim(DOKUM->TYP)+',') $ (','+typyr+','))
            mn2 := 1
         endif
         if mnod           && odwyrtka
            mnbu := mn1
            mn1 := mn2
            mn2 := mnbu
         endif
         if mn1 # 0 .or. mn2 # 0
            SPEC->( DBSeek( Str( DOKUM->ID ) + Str( it, 10 )))
            while Str( DOKUM->ID ) + Str( it, 10 ) == SPEC->( Str( ID_D ) + Str( ID_T, 10 ));
                  .and.;
                  !( SPEC->( Eof()))

*                  DBAppend()
*                  replace ID_D with DOKUM->ID

                  wa := SPEC->ILOSC * DataRW()

                  if zcenami
                     if cenyza == "T"
                        TOWARY->( DBSeek( it ))
                        wa := Grosz( wa * TOWARY->CENA_Z )
                     else
                        wa := Grosz( wa * SPEC->CENA )
                     endif
                  endif

                  if zmroli == "T" .and. SPEC->ILOSC < 0
                     pr := wa * mn2 * -1
                     ro := wa * mn1 * -1
                  else
                     pr := wa * mn1
                     ro := wa * mn2
                  endif

                  if DOKUM->DATAS < data1
                     replace BO       with BO + pr - ro
                  else
                     replace PRZYCHOD with PRZYCHOD + pr
                     replace ROZCHOD  with ROZCHOD  + ro
                  endif
                  replace BZ          with BO + PRZYCHOD - ROZCHOD
                  SPEC->( DBSkip())
            enddo
         endif
         DOKUM->( DBSkip())
         if Przerwa(); exit; endif
   enddo
   Przerwa( 0 )

   MAGAZYNY->( DBSkip())

enddo

   go top
   IncDBES( 1 )
   while !Eof()
         IncDBES()
         skip
   enddo

   go top
   wy := 2

   Czek( 0 )

   h := h + ' "' + AllTrim( FIRMY->( GetPole( 1, 'nrp', 'NAZWA1' ))) + '" w okresie ' + DtoC( data1 ) + '-' + DtoC( data2 )
*   h += 'Indeks towaru: ' + TOWARY->( GetPole( 1, 'it', 'INDEKS' ) + 'EOL'
*   h += '        nazwa: ' + TOWARY->( GetPole( 1, 'it', 'NAZWA' ) + 'EOL'
*   h += 'dokumenty przychodowe: ' + typyp
*   h += ', dokumenty rozchodowe: ' + typyr
*   h += if( zmroli == "T", hh, '' )

if zcenami
   h += ' (ceny ' + if( cenyza == "T", 'zakupu', 'transakcji' ) + ')'

endif

   DBE_Tyt := h + '|' + typyp + '|' + typyr + '|' + zmroli+ '|' + AllS( nrp )

if zcenami
   DBE_Tyt += '|' + cenyza
endif



   PutIni()
   ShowDBES( 1 )  && bez GETIni() na poczatku
   DBE_Tyt := h

endif

******************************************************************************

procedure ImportFIRMY( h )

local n


if Alarm( h, nt ) # 2; return; endif

Czek( 1 )
ON( 'KNORDPOL' )
while !Eof()
   if !Empty( NAZWA )
      n := AllTrim( NAZWA )
      FIRMY->( DBAdd())
      FIRMY->ID_F := FIRMY->( GetLast(1,1)+1 )
      FIRMY->TYP := if( SubStr( KONTO, 3, 1 ) $ '2,4,6,8', 'D', 'O' )
      FIRMY->INDEKS := AllTrim( PSEUDO )
      FIRMY->NAZWA1 := SubStr( n, 1, 50 )
      FIRMY->NAZWA2 := SubStr( n, 51, 50 )
      FIRMY->NAZWA3 := SubStr( n, 101, 50 )
   if Empty( FIRMY->NAZWA3 )
      FIRMY->NAZWA3 := AllTrim( BRANZA )

   else
      FIRMY->NAZWA3 := AllTrim( NAZWA3 ) + if( !Empty( BRANZA ), ', ' + AllTrim( BRANZA ), '' )
   endif
      FIRMY->KOD := AllTrim( KOD_POCZT )
      FIRMY->MIASTO := AllTrim( MIASTO )
      FIRMY->ULICA := AllTrim( ULICA )
      FIRMY->TELEFON := AllTrim( SKR_POCZT )
      FIRMY->OSOBA := ''
      FIRMY->NIP := AllTrim( NIP )
      FIRMY->REGON := ''
      FIRMY->BANK := AllTrim( BANK )
      FIRMY->RACH := AllTrim( RACH )
      FIRMY->NUMER := NUMER
      FIRMY->KONTO := AllTrim( KONTO )
   endif
   skip
enddo
Czek( 0 )

Select( 'FIRMY' )
wy := 2
go top

******************************************************************************

procedure DokumZlicz( rc, blok )

local rr, bb, ii

if ROB->( Eof() .or. Bof()); return; endif

ROB->CENA:=Grosz(((100-RABAT)*0.01)*CENABEZR)

bb := Alias()
ii := IndexOrd()
rr := RecNo()

DokumLicz( "ROB->ID_T", "VAT" )

if rc # NIL
   @ Val( Left( rc, 2 )), Val( right( rc, 2 )) say Transform( DOKUM->(NETTO23+NETTO8+NETTO5+NETTO22+NETTO7+NETTO0+NETTOZW), '999,999.99' ) + '   ' + Transform( DOKUM->WARTOSC, '999,999.99' )
endif

won := .f.

RunCommand( blok )

Select( bb )
DBGoTo( rr )
DBSetOrder( ii )

******************************************************************************

procedure ShowMasy( rc )

local maska := '999,999?999', masy := 0, rr

if rc = NIL; rc := PadR( AllS( Row()), 2 ) + PadR( AllS( Col()),2 ); endif

Select( 'ROB' )
rr := RecNo()
go top
while !Eof()
		masy += ILOSC * TOWARY->( GetPole( 1, 'ID_T', 'MASA' ))
		skip
enddo
DBGoTo( rr )

masy := Round( masy, 3 )

if rc # NIL
   @ Val( Left( rc, 2 )), Val( right( rc, 2 )) say ' (masa=' + AllS( masy, maska ) + ')' 
endif

******************************************************************************

procedure ShowNab( rc )

if rc = NIL; rc := PadR( AllS( Row()), 2 ) + PadR( AllS( Col()),2 ); endif

if rc # NIL
   @ Val( Left( rc, 2 )), Val( right( rc, 2 )) say PadR(DOKUM->NAZWA1,60) 
endif

******************************************************************************

procedure DokumRabaty( rc )

local wa, rr, x

wa := Alarm( 'Wybierz wariant nadania rabat¢w:',;
           { 'Rabat dla iloûci nieujemnych',;
         'Rabat dla rabat¢w zerowych',;
         'Rabat dla rabat¢w niezerowych',;
         'Zmiana rabatu o ...',;
         'Zmiana iloûci na przeciwnÜ' })
if wa = 0; return; endif

if wa # 5      && zmiany rabatÛw a nie iloúci
   x := 0
   x := Get_U( 10, 10, 'Podaj wysokoûç rabatu:', '999.99%', x )
   if x = NIL; return; endif
endif

rr := RecNo()
go top
while !Eof()
   if ILOSC >= 0
      do case
      case wa = 1
            replace RABAT with x
            replace CENA with Grosz(((100-RABAT)*0.01)*CENABEZR)
      case wa = 2
            if RABAT = 0
            replace RABAT with x
            replace CENA with Grosz(((100-RABAT)*0.01)*CENABEZR)
            endif
      case wa = 3
            if RABAT # 0
            replace RABAT with x
            replace CENA with Grosz(((100-RABAT)*0.01)*CENABEZR)
            endif
      case wa = 4
            replace RABAT with RABAT + x
            replace CENA with Grosz(((100-RABAT)*0.01)*CENABEZR)
      endcase
   endif
   if wa = 5
       replace ILOSC with -ILOSC
   endif
   skip
enddo
zmiana := .t.
DBGoTo( rr )
DokumZlicz( rc )
wy := 2

******************************************************************************
* Korygowanie dokumentu
* a = 'DOKUM,Nowa pozycja,,,73,DOKTYPY->(DokIncNr(DOKUM->TYP)),,,5'

procedure DokKoryg( a )


local rr := DOKUM->( RecNo()), dd, do, wa
private dknr, dkdt, dkdd

dknr := DOKUM->INDEKS
dkdt := DOKUM->DATAS

Ustaw("globalbuf", Left( TYP, 2 ) + 'K' )
DOKUM->( DBSetOrder( 3 ))
set filter to

NewSysDopisz( a, 1,, 'AppendRecord("DOKUM",{GetLast(1,1)+1,"O",globalbuf,"",,,Datee(),Datee(),dkdt,Datee(),PadR("przelew/got¢wka",20),0,dknr,PadR("zwrot towaru",50)},1)')

if LastKey() # 27
   wa := 0
   do := DOKUM->ID                  && nowy
	dknr := DOKUM->INDEKS
	dkdt := DOKUM->DATAS
   ON( 'SPEC', 1, 'ROBOCZY', 'ROB' )   && baza docelowa o pseudo rob
   ON( 'SPEC', 1, 'ROBOCZY', 'ROB', .t. ) && ZAP rob w katalogu 'cat'
   DOKUM->( DBSetOrder( 3 ))
   DOKUM->( DBGoTo( rr ))           && stary
	DOKUM->( Blokuj_R())
	DOKUM->NUMERFD := dknr
	DOKUM->DATAO := dkdt
	DOKUM->( OdBlokuj_R())
   SPEC->( DBSeek( DOKUM->ID ))
   KopiaRec( 'SPEC', 'ROB', {|| SPEC->ID_D = DOKUM->ID },,, {|| ROB->ID_D := do, ROB->ILOSC := -SPEC->ILOSC, wa += Grosz( ROB->CENA * ROB->ILOSC ), .f. })
   dd := ROB->( RecNo())
   SPEC->( DBSeek( DOKUM->ID ))
   KopiaRec( 'SPEC', 'ROB', {|| SPEC->ID_D = DOKUM->ID },,, {|| ROB->ID_D := do, wa += Grosz( ROB->CENA * ROB->ILOSC ), .f. })
   dkdd := dd
   DOKUM->( DBSetOrder( 1 ))
   DOKUM->( DBSeek( do ))           && nowy
   rr := DOKUM->( RecNo())
   ViewDBF( 'ROB,spec_kor.txt,ROBOCZY', .t., "F",, 'if( LastRec() > dkdd, DBGoTo( dkdd + 1 ), DBGoTop())')
   ROB->( DBGoTop())
   KopiaRec( 'ROB', 'SPEC' )
   wy := 2
   zmiana := .t.
endif


Select( 'DOKUM' )
DBSetOrder( 3 )

DBGoTo( rr )
   
******************************************************************************

procedure DokFirOut( a )

local bb, rr, r1, tak_eof, il, to

bb := Alias()
rr := RecNo()

private znr := 0, nanr := 0

if NewSysForm( a )

   if znr = nanr
      Alarm( 'Nie ma sensu.' )
      return
   endif
   ON( 'DOKUM', 4 )   && Str( NABYWCA) + data ...
   DBSeek( Str( znr, 10 ))
   tak_eof := .f.
   while NABYWCA = znr .and. !Eof() .and. !tak_eof
         skip
         tak_eof := Eof()

         r1 := RecNo()
         skip -1
      if TYP == "INW"
      else
         DokClose(,1)
         DOKUM->NABYWCA := nanr
         DokClose()
      endif
         DBGoTo( r1 )
   enddo
   ON( 'MAGAZYNY', 1 )   && Str(ID)+Str(ID_T)
   DBSeek( Str( znr, 10 ))
   tak_eof := .f.
   while ID = znr .and. !Eof() .and. !tak_eof
         skip
         tak_eof := Eof()
         r1 := RecNo()
         skip -1
         il := ILOSC
         to := ID_T
         MAGAZYNY->ILOSC := 0
         if !DBSeek(Str(nanr)+Str(to))
            MAGAZYNY->( AppendRecord( , { nanr, to, il }))
         else
            MAGAZYNY->ILOSC := MAGAZYNY->ILOSC + il
         endif
         if !tak_eof; DBGoTo( r1 ); endif

   enddo

endif


Select( bb )
DBGoTo( rr )
wy := 2

******************************************************************************

procedure SpeTowOut( a )

local bb, rr, r1, r2, tak_eof, il, to

bb := Alias()
rr := RecNo()

private znr := ID, nanr := ID

if NewSysForm( a )

   if znr = nanr
      Alarm( 'Nie ma sensu.' )
      return
   endif
   ON( 'MAGAZYNY' )
   ON( 'DOKTYPY' )
   ON( 'DOKUM', 1 )   && ID
   ON( 'SPEC', 2 )   && ID_T
   DBSeek( znr )
   tak_eof := .f.
   while ID_T = znr .and. !Eof() .and. !tak_eof
         r2 := RecNo()
         skip
         tak_eof := Eof()
         r1 := RecNo()
         skip -1
         Select( 'DOKUM'); DBSetOrder( 1 )
         DBSeek( SPEC->ID_D )
      if TYP == "INW"
      else
         DokClose(,1)
         SPEC->( DBGoTo( r2 ))
         SPEC->ID_T := nanr
         DokClose()
      endif
         Select( 'SPEC'); DBSetOrder( 2 )
         if !tak_eof; DBGoTo( r1 ); endif
   enddo
   ON( 'MAGAZYNY', 2 )   && Str(ID_T)+Str(ID)
   DBSeek( Str( znr, 10 ))
   tak_eof := .f.
   while ID_T = znr .and. !Eof() .and. !tak_eof
         skip
         tak_eof := Eof()
         r1 := RecNo()
         skip -1
         il := ILOSC
         to := ID
         MAGAZYNY->ILOSC := 0
         if !DBSeek(Str(nanr)+Str(to))
            MAGAZYNY->( AppendRecord( , { to, nanr, il }))
         else
            MAGAZYNY->ILOSC := MAGAZYNY->ILOSC + il
         endif
         if !tak_eof; DBGoTo( r1 ); endif
   enddo
endif

Select( bb )
DBGoTo( rr )
wy := 2

******************************************************************************

procedure DokReSpec()

if Alarm( 'Restrukturyzowaç dokumenty?', nt ) # 2; return; endif


ON( 'FIRMY' )
ON( 'DOKUM' )

Czek( 1 )
Przerwa( LastRec())
while !Eof()
      FIRMY->( DBSeek( DOKUM->NABYWCA ))
*      DOKUM->KOD := FIRMY->KOD
*      DOKUM->MIASTO := FIRMY->MIASTO
*      DOKUM->ADRES := FIRMY->ADRES

*      DOKUM->NIP := FIRMY->NIP

      DOKUM->INDEKS_F := FIRMY->INDEKS
      DOKUM->TYP_F := FIRMY->TYP
      DOKUM->NAZWA1 := FIRMY->NAZWA1
      DOKUM->NAZWA2 := FIRMY->NAZWA2
      DOKUM->NAZWA3 := FIRMY->NAZWA3
      if Przerwa(); exit; endif
      skip
enddo
Zwolnij( 'DOKUM' )
Zwolnij( 'FIRMY' )
Przerwa( 0 )
Czek( 0 )


return  && ********** end **************

if Alarm( 'Restrukturyzowaç specyfikacje dokument¢w?', nt ) # 2; return; endif

ON( 'SPEC' )
Czek( 1 )
Przerwa( LastRec())
while !Eof()
      SPEC->CENABEZR := SPEC->CENA
      if Przerwa(); exit; endif
      skip
enddo
Zwolnij( 'SPEC' )
Przerwa( 0 )
Czek( 0 )

******************************************************************************

function Check( wartosc, wbazie, wgindeksu, wformularzu, wid1, pole1, wid2, pole2, wid3, pole3, wid4, pole4 )

local bb := Alias(), rr := Recno(), wy := .t.

Select( wbazie )
ii := IndexOrd()
DBSetOrder( wgindeksu )
if " " $ wartosc            && imi' i nazwisko
   if !DBSeek( wartosc )
      DBAppend()
      replace LP with GetLast(1,1)+1
      replace &pole2 with vp[ wid2 ]     && NAZWA with "Moch Arkadiusz"
      if !NewSysForm( wformularzu + ',Weryfikacja danych')
         BDelete()
         wy := .f.
      endif
   endif
else                        && skr¢t
   DBSeek( wartosc, .t. )
endif

if wy
   if wid1 # NIL; vp[ wid1 ] := &pole1; endif
   if wid2 # NIL; vp[ wid2 ] := &pole2; endif
   if wid3 # NIL; vp[ wid3 ] := &pole3; endif
   if wid4 # NIL; vp[ wid4 ] := &pole4; endif
endif

DBSetOrder( ii )

Select( bb )

*DBGoTo( rr )


return wy

******************************************************************************
* Oblicza wartoûci dokumentu z ROB lub SPEC
* DokumLicz( 'SPEC->ID_T', 'VAT',, 1, idd )
* wydobycie VATu: p := TOWARY->( GetPole( 1, a, b ))
* a = 'ID_T'
* b = 'VAT'
* c - "zmiana"
* d # NIL => bez "won"
* idd = identyfikator dokumentu przy liczeniu ze SPEC a nie ROB

procedure DokumLicz( a, b, c, d, idd )

local p, w, v3
private export := ' ', brutto := ' '

DOKTYPY->( DBSeek( DOKUM->TYP ))

v3 := ( DOKUM->( Field( 35 )) == 'NETTO3' )

DOKUM->( Blokuj_R())

DOKUM->NETTO23 := 0
DOKUM->NETTO22 := 0
DOKUM->NETTO8  := 0
DOKUM->NETTO7  := 0
DOKUM->NETTO5  := 0

if v3; DOKUM->NETTO3  := 0; endif

DOKUM->NETTO0  := 0
DOKUM->NETTOZW := 0

DOKUM->VAT23 := 0
DOKUM->VAT22 := 0
DOKUM->VAT8 := 0
DOKUM->VAT7 := 0
DOKUM->VAT5 := 0

if v3; DOKUM->VAT3 := 0; endif

if ObAuDoWCZ .and. !RozneCenyZ
   DOKUM->NETTOCZ := 0
endif

if idd = NIL
   go top
else
   DBSeek( idd )        && SPEC->( DBSeek ...
endif

while if( idd = NIL, .t., ID_D = idd ) .and. !Eof()
   if ILOSC < 0
      if DOKTYPY->( EXPORT ) == 'T'
         p := 0
      else
         p := TOWARY->( GetPole(1,a,b,'TOWARY',,,1,,,'STAROCIE\TOWARY'))
      endif

      w := Grosz( CENA * ILOSC )

      if ObAuDoWCZ .and. !RozneCenyZ
         DOKUM->NETTOCZ += Grosz( TOWARY->CENA_Z * ILOSC )
      endif

      if Year(DOKUM->DATAS)<2011  .or. (Year(DOKUM->DATAO)<2011 .and. right(DOKUM->TYP,1)=='K')
         if p = 23; p := 22; endif
         if p =  8; p :=  7; endif
         if p =  5; p :=  0; endif
      endif
      
      if  DzienVAT0()
         if p =  5; p :=  0; endif
      endif
      
      do case
         case p = 23; DOKUM->NETTO23 += w
         case p = 22; DOKUM->NETTO22 += w
         case p = 8 ; DOKUM->NETTO8  += w
         case p = 7 ; DOKUM->NETTO7  += w
         case p = 5 ; DOKUM->NETTO5  += w
         case p = 3 .and. v3; DOKUM->NETTO3  += w
         case p = 0 ; DOKUM->NETTO0  += w
         otherwise  ; DOKUM->NETTOZW += w
      endcase
   endif
   skip
enddo

if idd = NIL
   go top
else
   DBSeek( idd )        && SPEC->( DBSeek ...
endif

while if( idd = NIL, .t., ID_D = idd ) .and. !Eof()
   if ILOSC > 0
      if DOKTYPY->( EXPORT ) == 'T'
         p := 0
      else
         p := TOWARY->( GetPole(1,a,b,'TOWARY',,,1,,,'STAROCIE\TOWARY'))
      endif

      w := Grosz( CENA * ILOSC )

      if ObAuDoWCZ .and. !RozneCenyZ
         DOKUM->NETTOCZ += Grosz( TOWARY->CENA_Z * ILOSC )
      endif

      if Year(DOKUM->DATAS)<2011  .or. (Year(DOKUM->DATAO)<2011 .and. right(DOKUM->TYP,1)=='K')
         if p = 23; p := 22; endif
         if p =  8; p :=  7; endif
         if p =  5; p :=  0; endif
      endif
      
      if  DzienVAT0()
         if p =  5; p :=  0; endif
      endif
      
      do case
         case p = 23; DOKUM->NETTO23 += w
         case p = 22; DOKUM->NETTO22 += w
         case p = 8 ; DOKUM->NETTO8  += w
         case p = 7 ; DOKUM->NETTO7  += w
         case p = 5 ; DOKUM->NETTO5  += w
         case p = 3 .and. v3; DOKUM->NETTO3  += w
         case p = 0 ; DOKUM->NETTO0  += w
         otherwise  ; DOKUM->NETTOZW += w
      endcase
   endif
   skip
enddo

if DOKTYPY->( BRUTTO ) == 'T'    && w polach netto jest brutto, pola vat = 0

if v3
   DOKUM->WARTOSC := DOKUM->( NETTO23 + NETTO8 + NETTO5 + NETTO22 + NETTO7 + NETTO3 + NETTO0 + NETTOZW + VAT23 + VAT8 + VAT5 + VAT22 + VAT7 + VAT3 )
   DOKUM->VAT3 := Grosz( DOKUM->NETTO3 * 0.03 / 1.03)
else
   DOKUM->WARTOSC := DOKUM->( NETTO23 + NETTO8 + NETTO5 + NETTO22 + NETTO7 +      0 + NETTO0 + NETTOZW + VAT23 + VAT8 + VAT5 + VAT22 + VAT7 +    0 )
endif

DOKUM->VAT23 := Grosz( DOKUM->NETTO23 * 0.23 / 1.23 )    && VAT w stu
DOKUM->VAT22 := Grosz( DOKUM->NETTO22 * 0.22 / 1.22 )    && VAT w stu
DOKUM->VAT8  := Grosz( DOKUM->NETTO8  * 0.08 / 1.08 )
DOKUM->VAT7  := Grosz( DOKUM->NETTO7  * 0.07 / 1.07 )
DOKUM->VAT5  := Grosz( DOKUM->NETTO5  * 0.05 / 1.05 )

DOKUM->NETTO23 -= DOKUM->VAT23                           && prawdziwe netto
DOKUM->NETTO22 -= DOKUM->VAT22                           && prawdziwe netto
DOKUM->NETTO8  -= DOKUM->VAT8 
DOKUM->NETTO7  -= DOKUM->VAT7 
DOKUM->NETTO5  -= DOKUM->VAT5 

if v3; DOKUM->NETTO3  -= DOKUM->VAT3 ; endif

else

DOKUM->VAT23 := Grosz( DOKUM->NETTO23 * 0.23 )
DOKUM->VAT22 := Grosz( DOKUM->NETTO22 * 0.22 )
DOKUM->VAT8  := Grosz( DOKUM->NETTO8  * 0.08 )
DOKUM->VAT7  := Grosz( DOKUM->NETTO7  * 0.07 )
DOKUM->VAT5  := Grosz( DOKUM->NETTO5  * 0.05 )

if v3
   DOKUM->VAT3 := Grosz( DOKUM->NETTO3 * 0.03 )
   DOKUM->WARTOSC := DOKUM->( NETTO23 + NETTO8 + NETTO5 + NETTO22 + NETTO7 + NETTO3 + NETTO0 + NETTOZW + VAT23 + VAT8 + VAT5 + VAT22 + VAT7 + VAT3 )
else
   DOKUM->WARTOSC := DOKUM->( NETTO23 + NETTO8 + NETTO5 + NETTO22 + NETTO7 +      0 + NETTO0 + NETTOZW + VAT23 + VAT8 + VAT5 + VAT22 + VAT7 +    0 )
endif

endif

DOKUM->( OdBlokuj_R())

if c # NIL; zmiana := c; endif
if d = NIL; won := .t.; endif

******************************************************************************
* Testuje wartoûci dokumentÛw

procedure DokumTestuj()

local sc := SaveScreen(), ok

if NIL = Get_Okres( @data1, @data2 ); return; endif

cls
DBSetOrder( 3 )
DBSeek( DtoS( data1 ), .t. )
while DATAS <= data2 .and. !Eof()
		ok := DokumTest()
//		if !ok
//			if Inkey( 3 ) = 27; exit; endif
//		endif
		if Inkey() = 27; exit; endif
		skip
enddo

? Enter
Inkey( 0 )
RestScreen( ,,,, sc )

******************************************************************************
* Testuje wartoûci dokumentu z SPEC

function DokumTest()

local p, w, v3, a, b, bb := Alias(), ok := .t., s, n
local netto23, netto8, netto5, netto22, netto7, netto3, netto0, nettozw, vat23, vat8, vat5, vat22, vat7, vat3, nettocz, wartosc
private export := ' ', brutto := ' '

a := 'SPEC->ID_T'
b := 'VAT'
idd := DOKUM->ID
DOKTYPY->( DBSeek( DOKUM->TYP ))

v3 := ( DOKUM->( Field( 35 )) == 'NETTO3' )

NETTO23 := 0
NETTO22 := 0
NETTO8  := 0
NETTO7  := 0
NETTO5  := 0

if v3; NETTO3  := 0; endif

NETTO0  := 0
NETTOZW := 0

VAT23 := 0
VAT22 := 0
VAT8 := 0
VAT7 := 0
VAT5 := 0

if v3; VAT3 := 0; endif

if ObAuDoWCZ .and. !RozneCenyZ
   NETTOCZ := 0
endif

n := 0
ON( 'SPEC' )
DBSeek( idd )
while ID_D = idd .and. !Eof()
   if ILOSC < 0
      n++
      if DOKTYPY->( EXPORT ) == 'T'
         p := 0
      else
         p := TOWARY->( GetPole(1,a,b,'TOWARY',,,1,,,'STAROCIE\TOWARY'))
      endif

      w := Grosz( CENA * ILOSC )

      if ObAuDoWCZ .and. !RozneCenyZ
         NETTOCZ += Grosz( TOWARY->CENA_Z * ILOSC )
      endif

      if Year(DOKUM->DATAS)<2011  .or. (Year(DOKUM->DATAO)<2011 .and. right(DOKUM->TYP,1)=='K')
         if p = 23; p := 22; endif
         if p =  8; p :=  7; endif
         if p =  5; p :=  0; endif
      endif

      if  DzienVAT0()
         if p =  5; p :=  0; endif
      endif
      
      do case
         case p = 23; NETTO23 += w
         case p = 22; NETTO22 += w
         case p = 8 ; NETTO8  += w
         case p = 7 ; NETTO7  += w
         case p = 5 ; NETTO5  += w
         case p = 3 .and. v3; NETTO3  += w
         case p = 0 ; NETTO0  += w
         otherwise  ; NETTOZW += w
      endcase
   endif
   skip
enddo

DBSeek( idd )
while ID_D = idd .and. !Eof()
   if ILOSC >= 0; n++; endif
   if ILOSC > 0
      if DOKTYPY->( EXPORT ) == 'T'
         p := 0
      else
         p := TOWARY->( GetPole(1,a,b,'TOWARY',,,1,,,'STAROCIE\TOWARY'))
      endif

      w := Grosz( CENA * ILOSC )

      if ObAuDoWCZ .and. !RozneCenyZ
         NETTOCZ += Grosz( TOWARY->CENA_Z * ILOSC )
      endif

      if Year(DOKUM->DATAS)<2011  .or. (Year(DOKUM->DATAO)<2011 .and. right(DOKUM->TYP,1)=='K')
         if p = 23; p := 22; endif
         if p =  8; p :=  7; endif
         if p =  5; p :=  0; endif
      endif

      if  DzienVAT0()
         if p =  5; p :=  0; endif
      endif
      
      do case
         case p = 23; NETTO23 += w
         case p = 22; NETTO22 += w
         case p = 8 ; NETTO8  += w
         case p = 7 ; NETTO7  += w
         case p = 5 ; NETTO5  += w
         case p = 3 .and. v3; NETTO3  += w
         case p = 0 ; NETTO0  += w
         otherwise  ; NETTOZW += w
      endcase
   endif
   skip
enddo

if DOKTYPY->( BRUTTO ) == 'T'    && w polach netto jest brutto, pola vat = 0

if v3
   WARTOSC := NETTO23 + NETTO8 + NETTO5 + NETTO22 + NETTO7 + NETTO3 + NETTO0 + NETTOZW + VAT23 + VAT8 + VAT5 + VAT22 + VAT7 + VAT3
   VAT3 := Grosz( NETTO3 * 0.03 / 1.03)
else
   WARTOSC := NETTO23 + NETTO8 + NETTO5 + NETTO22 + NETTO7 +      0 + NETTO0 + NETTOZW + VAT23 + VAT8 + VAT5 + VAT22 + VAT7 +    0
endif

VAT23 := Grosz( NETTO23 * 0.23 / 1.23 )    && VAT w stu
VAT22 := Grosz( NETTO22 * 0.22 / 1.22 )    && VAT w stu
VAT8  := Grosz( NETTO8  * 0.08 / 1.08 )
VAT7  := Grosz( NETTO7  * 0.07 / 1.07 )
VAT5  := Grosz( NETTO5  * 0.05 / 1.05 )

NETTO23 -= VAT23                           && prawdziwe netto
NETTO22 -= VAT22                           && prawdziwe netto
NETTO8  -= VAT8 
NETTO7  -= VAT7 
NETTO5  -= VAT5 

if v3; NETTO3  -= VAT3 ; endif

else

VAT23 := Grosz( NETTO23 * 0.23 )
VAT22 := Grosz( NETTO22 * 0.22 )
VAT8  := Grosz( NETTO8  * 0.08 )
VAT7  := Grosz( NETTO7  * 0.07 )
VAT5  := Grosz( NETTO5  * 0.05 )

if v3
   VAT3 := Grosz( NETTO3 * 0.03 )
   WARTOSC := NETTO23 + NETTO8 + NETTO5 + NETTO22 + NETTO7 + NETTO3 + NETTO0 + NETTOZW + VAT23 + VAT8 + VAT5 + VAT22 + VAT7 + VAT3
else
   WARTOSC := NETTO23 + NETTO8 + NETTO5 + NETTO22 + NETTO7 +      0 + NETTO0 + NETTOZW + VAT23 + VAT8 + VAT5 + VAT22 + VAT7 +    0
endif

endif

Select( bb )

a := DOKUM->WARTOSC
b := wartosc
if Abs( a - b ) > 0.009 .or. n > 300
	if n > 300
		? TYP, INDEKS, DATAS, 'n=' + AllS(n), INDEKS_F, a-b
	else
		? TYP, INDEKS, DATAS, 'ERROR', INDEKS_F, a-b
	endif
//	Alarm( 'WartoúÊ brutto dokumentu = ' + AllS( a ) + ';, a pozycji = ' + AllS( b ) + ';, rÛønica = ' + AllS( a - b ),,1 )
	ok := .f.
endif

return ok

******************************************************************************
* vp[ k ] := RunCommand( a + if( x, b, c ))

function ZamowGetNab( a, b, c, k )

local x, y, i, zmk, incydent

x := LastKey() = K_ENTER
y := LastKey() = K_DOWN
if x .or. y
   vp[ k     ] := RunCommand( a + if( x, b, c ))
   vp[ k + 1 ] := FIRMY->ID_F
endif

return .t.


******************************************************************************
* h = NIL => h = "INCYDENT"
* k = nr pola DOKUM->NABYWCA
* 

function DokumGetNab( a, b, c, k, u, h )

local x, y, i, zmk, incydent

if h = NIL; h := "INCYDENT"; endif

x := ( LastKey() = K_ENTER ) .or. ( LastKey() = K_PGDN ) .or. ( LastKey() = K_PGUP )
y := ( LastKey() = K_DOWN )
if x .or. y
   incydent := ( Upper( Left( vp[ k + 1 ], 8 )) == h )
   if x
      vp[ k + 1 ] := RunCommand( a + if( x .and. !incydent, b, c ))
      zmk := (( vp[ k ] # FIRMY->ID_F ) .or. ( vp[ k ] # DOKUM->NABYWCA ))
      vp[ k     ] := FIRMY->ID_F
   else
      zmk := (( vp[ k ] # FIRMY->ID_F ) .or. ( vp[ k ] # DOKUM->NABYWCA ))
      vp[ k     ] := FIRMY->ID_F
   endif
   if !incydent
      vp[ k + 2 ] := FIRMY->NAZWA1
      vp[ k + 3 ] := FIRMY->NAZWA2
      vp[ k + 4 ] := FIRMY->NAZWA3
      i := 5
      if TypyKonZmi
         if zmk
            vp[ k + i ] := FIRMY->TYP

         endif
         i++
      endif
      vp[ k + i++ ] := FIRMY->KOD
      vp[ k + i++ ] := FIRMY->MIASTO
      vp[ k + i++ ] := if( u = NIL, FIRMY->ADRES, &u )
      vp[ k + i++ ] := FIRMY->NIP
   endif
endif

return .t.

******************************************************************************
* mode = 0 - MZ
* mode = 1 - MG
* mode = 2 - MP

function IloscMG( mode )

local bb := Alias()

if Jest_baza( 'TOWARYBU' )
   Jest_baza( bb )
   if RozneCenyZ
      do case
      case mode = 0; return MAGAZYNY->(GetPole(2,Str(TOWARYBU->ID)+'"         0"+Str(TOWARYBU->CENA_S)','ILOSC',,,,,,'ID=0.and.ID_T=TOWARYBU->ID.and.CENA_Z=TOWARYBU->CENA_S'))
      case mode = 1; return MAGAZYNY->(GetPole(2,'Str(TOWARYBU->ID)+Str(DOKUM->MAGAZYN)+Str(TOWARYBU->CENA_S)','ILOSC',,,,,,'ID=DOKUM->MAGAZYN.and.ID_T=TOWARYBU->ID.and.CENA_Z=TOWARYBU->CENA_S'))
      case mode = 2; return MAGAZYNY->(GetPole(2,'Str(TOWARYBU->ID)+Str(DOKUM->NABYWCA)+Str(TOWARYBU->CENA_S)','ILOSC',,,,,,'ID=DOKUM->NABYWCA.and.ID_T=TOWARYBU->ID.and.CENA_Z=TOWARYBU->CENA_S'))
      endcase
   else
      do case
      case mode = 0; return MAGAZYNY->(GetPole(1,'"         0"+Str(TOWARYBU->ID)','ILOSC',,,,,,'ID=0.and.ID_T=TOWARYBU->ID'))
      case mode = 1; return MAGAZYNY->(GetPole(1,'Str(DOKUM->MAGAZYN)+Str(TOWARYBU->ID)','ILOSC',,,,,,'ID=DOKUM->MAGAZYN.and.ID_T=TOWARYBU->ID'))
      case mode = 2; return MAGAZYNY->(GetPole(1,'Str(DOKUM->NABYWCA)+Str(TOWARYBU->ID)','ILOSC',,,,,,'ID=DOKUM->NABYWCA.and.ID_T=TOWARYBU->ID'))
      endcase
   endif
else
   Jest_baza( bb )
   do case
   case mode = 0; return MAGAZYNY->(GetPole(1,'"         0"+Str(TOWARY->ID)','ILOSC',,,,,,'ID=0.and.ID_T=TOWARY->ID'))
   case mode = 1; return MAGAZYNY->(GetPole(1,'Str(DOKUM->MAGAZYN)+Str(TOWARY->ID)','ILOSC',,,,,,'ID=DOKUM->MAGAZYN.and.ID_T=TOWARY->ID'))
   case mode = 2; return MAGAZYNY->(GetPole(1,'Str(DOKUM->NABYWCA)+Str(TOWARY->ID)','ILOSC',,,,,,'ID=DOKUM->NABYWCA.and.ID_T=TOWARY->ID'))
   endcase
endif

******************************************************************************
* mode = NIL, id, in, na, mg, mp, ce, il
* mode # NIL, id, in, na, ce
* musi nanieúÊ cenÍ sprzedaøy wed≥ug cennika, a nie z rÍki

function DokumGetTow( a, mode, nn, musi )

local x := if( baza == 'ROB', ( baza )->ID_T, vp[ 1 ]), cs, zmid := .f.

local y := vp[ 2 ], bb := Alias()
private export := ' ', brutto := ' '

if nn = NIL; nn := 6; endif

vp[2] := RunCommand( a )
zmid := !Empty( vp[ 1 ]) .and. ( vp[ 1 ] # TOWARY->ID )
vp[1] := TOWARY->ID
vp[3] := TOWARY->NAZWA

cs := GetCS( bb )

if mode = NIL
   if NRMG = 0 .and. !produkcja      && Mistral
      vp[4] := IloscMG( 0 )
      vp[5] := if( MZzalezny, IloscMG( 1 ), IloscMG( 2 ))
   else              && MG i MP
      vp[4] := IloscMG( 1 )
      vp[5] := IloscMG( 2 )
   endif
   if !( x = vp[ 1 ]) .or. !( y == vp[ 2 ]) .or. ( musi # NIL )
		if zmid .or. ( vp[nn] < 0.01 )
	      if TypyKonZmi
   	      vp[nn] := TOWARY->( if( DOKUM->TYP_F $ TypyKonCZ, CENA_Z, cs ))
      	else
	         if DOKTYPY->TYP # DOKUM->TYP; DOKTYPY->( DBSeek( DOKUM->TYP )); endif
   	      vp[nn] := TOWARY->( if( DOKTYPY->TYP_F $ TypyKonCZ, CENA_Z, cs ))
      	endif
		endif
   endif
else
   if !( x = vp[ 1 ]) .or. !( y == vp[ 2 ])
      if TypyKonZmi
         vp[4] := TOWARY->( if( DOKUM->TYP_F $ TypyKonCZ, CENA_Z, cs ))
      else
         if DOKTYPY->TYP # DOKUM->TYP; DOKTYPY->( DBSeek( DOKUM->TYP )); endif
         vp[4] := TOWARY->( if( DOKTYPY->TYP_F $ TypyKonCZ, CENA_Z, cs ))
      endif
   endif
endif


return .t.

******************************************************************************

function GetCS( bb )

local cs := 0
private export := ' ', brutto := ' ', cb

DOKTYPY->( DBSeek( DOKUM->TYP ))
if DOKTYPY->( BRUTTO ) == 'T'
*if DokBruNet .and. DOKTYPY->BRUTTO = "T"
   cb := 'CENA_B' + if(TowUstawCE <=1, '', AllS(TowUstawCE ))
	if Jest_baza( 'TOWARYBU' )
		if TOWARYBU->( FieldPos( 'CENABS' )) # 0
			cs := TOWARYBU->CENABS
		elseif TOWARYBU->( FieldPos( cb )) # 0
	         cs := 'TOWARYBU->' + cb
	         cs := &cs
		else
			cs := TOWARYBU->( Brutto( CENA_S, VAT ))
		endif
	else
      if TowUstawCE <=1
			if TOWARY->( FieldPos( 'CENABS' )) # 0
				cs := TOWARY->CENABS
			elseif TOWARY->( FieldPos( cb )) # 0
	         cs := 'TOWARY->' + cb
	         cs := &cs
			else
				cs := TOWARY->( Brutto( CENA_S, VAT ))
			endif
      else
         cs := 'CENABS' + AllS( TowUstawCe )
			if TOWARY->( FieldPos( cs )) # 0
	         cs := 'TOWARY->' + cs
	         cs := &cs
			elseif TOWARY->( FieldPos( cb )) # 0
	         cs := 'TOWARY->' + cb
	         cs := &cs
			else
	         cs := 'CENA_S' + AllS( TowUstawCe )
	         cs := 'TOWARY->( Brutto( ' + cs + ', VAT ))'
	         cs := &cs
			endif
      endif
   endif
else
   if Jest_baza( 'TOWARYBU' )
      cs := TOWARYBU->CENA_S
   else
      if  DzienVAT0();
         .and. (TOWARY->VAT==5)
         if TowUstawCE <=1
            cs := TOWARY->CENA_B
         else
            cs := 'TOWARY->CENA_B' + AllS( TowUstawCe )
            cs := &cs
         endif
      else
         if TowUstawCE <=1
            cs := TOWARY->CENA_S
         else
            cs := 'TOWARY->CENA_S' + AllS( TowUstawCe )
            cs := &cs
         endif
      endif
   endif
endif

Jest_baza( bb )

return cs

******************************************************************************
* mode = NIL - pyta
* mode # NIL - nie pyta tylko importuje stan syntetyczny magazynu (INW)
* znaki - baza zaznacze§ dokument¢w

procedure DokumImport( mode, znaki )

local bb := Alias(), rr := DOKUM->( RecNo()), dd := 0, od, wa := 0, ok, i
local do, dkdd, roz, ma, st

private rozlicz := ' '

do := DOKUM->ID
dkdd := DOKUM->TYP
roz := ( DOKTYPY->( ROZLICZ ) == 'T' )     && rozliczeniowy

if mode # NIL

   so := Alarm( 'Wybierz ürÛd≥o importu :', { 'Podmagazyn', 'Magazyn g≥Ûwny', 'Magazyn zbiorczy' }, 1 )
	if so = NIL .or. so = 0; return; endif

   st := Alarm( 'Wybierz styl importu :',;
					 {  'Tylko obecny stan (z plusem)',;
						 'Tylko obecny stan (z minusem)',;
						 'Tylko obecny stan (zera)',;
						 'By≥o (z minusem) / Ma byÊ ( z plusem )',;
						 'By≥o (z minusem) / Ma byÊ ( zera )' }, 1 )

   od := Alarm( 'Zerowe stany teß importowaç ?', nt )

if so = 1 .or. so = 2
	ma := if( so = 1, DOKUM->NABYWCA, NRMG )
	ON( 'MAGAZYNY' )
	DBSeek( Str( ma, 10 ))
	while MAGAZYNY->ID = ma .and. !Eof()
      if od = 2 .or. STAN # 0.000
         ROB->( DBAppend())
         ROB->ID_D := do
         ROB->ID_T := MAGAZYNY->ID_T
         ROB->CENA := MAGAZYNY->CENA_Z
         ROB->CENABEZR := MAGAZYNY->CENA_Z
         ROB->ILOSC := MAGAZYNY->ILOSC
			if st = 2; ROB->ILOSC := -ROB->ILOSC; endif
			if st = 3; ROB->ILOSC := 0; endif
			if st = 4; ROB->ILOSC := -ROB->ILOSC; endif
			if st = 5; ROB->ILOSC := -ROB->ILOSC; endif
         wa += Grosz( ROB->CENA * ROB->ILOSC )
      endif
		skip
	enddo
if st >= 4
	DBSeek( Str( ma, 10 ))
	while MAGAZYNY->ID = ma .and. !Eof()
      if od = 2 .or. STAN # 0.000
         ROB->( DBAppend())
         ROB->ID_D := do
         ROB->ID_T := MAGAZYNY->ID_T
         ROB->CENA := MAGAZYNY->CENA_Z
         ROB->CENABEZR := MAGAZYNY->CENA_Z
         ROB->ILOSC := MAGAZYNY->ILOSC
			if st = 5; ROB->ILOSC := 0; endif
         wa += Grosz( ROB->CENA * ROB->ILOSC )
      endif
		skip
	enddo
endif

else
   ON( 'TOWARY' )
   while !Eof()
      if od = 2 .or. STAN # 0.000
         ROB->( DBAppend())
         ROB->ID_D := do

         ROB->ID_T := TOWARY->ID
         ROB->CENA := TOWARY->CENA_Z
         ROB->CENABEZR := TOWARY->CENA_Z
         ROB->ILOSC := if( ze, 0, TOWARY->STAN )
         wa += Grosz( ROB->CENA * ROB->ILOSC )
      endif
      skip
   enddo
endif

   Select( bb )
   wy := 2
   zmiana := .t.

   DOKUM->( DBGoTo( rr ))
   DOKUM->( Blokuj_R())
   DOKUM->WARTOSC := DOKUM->WARTOSC + wa

   return

endif

od := Alarm( 'Wybierz wariant importu:',;
           { 'To samo', '"Byío / Ma byç"', 'Rezygnacja=Esc'})

if od = 0 .or. od = 3; return; endif

ViewDBF( 'DOKUM,dokumimp.txt,,3', .t. )

if znaki = NIL
   ok := ( LastKey() # 27 )
else
   i := 0
   wa := 0
   ON( 'DOKUM', 1 )
   ON( znaki )
   while !Eof()
         if DOKUM->( DBSeek(( znaki )->POLE ))
            wa += DOKUM->WARTOSC
            if roz
               wa += DOKUM->WPLACONO
            endif
            i ++
         endif
         skip
   enddo

   if i > 0
      ok := ( Alarm( AllS( i ) + ' zaznaczonych dokument¢w na kwotë ' + AllS( wa ) +;
                   ';Importowaç dane z tych dokument¢w ?', nt ) = 2 )
   else
      ok := .f.
   endif
endif

if ok
   wa := 0
   if znaki = NIL
      if roz       && wpisanie zwiÜzku KP( id, typ), FV( id, typ), wa
         Zwiazek( do, dkdd, DOKUM->ID, DOKUM->TYP, DOKUM->( WARTOSC - WPLACONO ), 'ROB' )
      else
         GoKoSpe( od, @wa, @dd, do )
      endif
      Select( bb ); if LastRec() > dd; DBGoTo( dd + 1 ); endif
   else
      ON( znaki )
      while !Eof()
            if DOKUM->( DBSeek(( znaki )->POLE ))
               if roz       && wpisanie zwiÜzku KP( id, typ), FV( id, typ), wa
                  Zwiazek( do, dkdd, DOKUM->ID, DOKUM->TYP, DOKUM->( WARTOSC - WPLACONO ), 'ROB' )
               else
                  GoKoSpe( od, @wa, @dd, do )
               endif
            endif
            Select( znaki )
            skip
      enddo
      Select( bb )
      if !roz
         CreateIndex( 'Str(ID_T)+Str(CENA)+Str(RABAT)+Str(CENABEZR)',, 1 )
         Scal_ROB( 0 )
         DBSetOrder( 0 )
      endif
      DBGoTop()
   endif
   wy := 2
   zmiana := .t.
endif

DOKUM->( DBGoTo( rr ))
DOKUM->( Blokuj_R())
DOKUM->WARTOSC := DOKUM->WARTOSC + wa

******************************************************************************
* Go kopia specyfikacji

procedure GoKoSpe( od, wa, dd, do )

if od = 2
   SPEC->( DBSeek( DOKUM->ID ))
   KopiaRec( 'SPEC', 'ROB', {|| SPEC->ID_D = DOKUM->ID },,, {|| ROB->ID_D := do, ROB->ILOSC := -SPEC->ILOSC, wa += Grosz( ROB->CENA * ROB->ILOSC ), .f. })
   dd := ROB->( RecNo())
endif

SPEC->( DBSeek( DOKUM->ID ))
KopiaRec( 'SPEC', 'ROB', {|| SPEC->ID_D = DOKUM->ID },,, {|| ROB->ID_D := do, wa += Grosz( ROB->CENA * ROB->ILOSC ), .f. })

******************************************************************************


procedure RejSpeImport( baza_dok, baza_tow, baza_dok_bie )

local bb := Alias(), rr := ( baza_dok_bie )->( RecNo())
local dd := 0, do, od, wa := 0, k_29, k_30

od := Alarm( 'Wybierz wariant importu:',;
           { '"Byío / Ma byç"', 'To samo', 'Rezygnacja=Esc'})

if od = 0 .or. od = 3; return; endif

do := ( baza_dok_bie )->LP

ON( baza_dok )
ViewDBF( baza_dok + ',rejspeim.txt,,3', .t.,,,, 'rerere := RecNo()')

if LastKey() # 27
   k_29 := ( baza_dok )->NUMER

   k_30 := ( baza_dok )->D3
   ON( baza_tow )
   if od = 1

      ( baza_tow )->( DBSeek(( baza_dok )->LP ))
      KopiaRec( baza_tow, 'ROB', {|| ( baza_tow )->LPP = ( baza_dok )->LP },,, {|| ROB->LPP := do, ROB->ILOSC := -( baza_tow )->ILOSC, .f. })
      dd := ROB->( RecNo())
   endif
   ( baza_tow )->( DBSeek( ( baza_dok )->LP ))
   KopiaRec( baza_tow, 'ROB', {|| ( baza_tow )->LPP = ( baza_dok )->LP },,, {|| ROB->LPP := do, .f. })
   Select( bb )
   if LastRec() > dd
      DBGoTo( dd + 1 )
   endif
   wy := 2
   zmiana := .t.
endif

( baza_dok_bie )->( DBGoTo( rr ))
( baza_dok_bie )->( Blokuj_R())
( baza_dok_bie )->K29 := k_29
( baza_dok_bie )->K30 := k_30

******************************************************************************
* z_firm - uruchamiane z bazy firm jako podglÜd dokument¢w kontrahenta

procedure DokAna6( a, b, h, z_firm )

local tab
private typy, nrp := 0, inp := Space(15)

b := if( b # NIL, b, '' )
typy := PadR( b, 50 )

GetIni(,,@tab)
if Len( tab ) > 0 .and. !Empty( tab[ 1 ])
   typy := PadR( tab[ 1 ], Len( typy ))
endif

if z_firm # NIL
   nrp := globalbuf
   inp := globalbuf1
   data1 := CtoD('')
else
   if Len( tab ) > 1 .and. !Empty( tab[ 2 ])
      nrp := Val( tab[ 2 ])
   endif
endif

if Ana_Daty_B; data2 := Datee(); endif

if z_firm # NIL .or. NewSysForm( a )
   Czek( 1 )
   DBZap('')
   typy := AllTrim( typy )
   DOKUM->( DBSetOrder( 3 ))    && DtoS( DATAS ) + INDEKS
   DOKUM->( DBSeek( DtoS( data1 ), .t. ))
   Przerwa( DOKUM->( LastRec()))
   while DOKUM->DATAS <= data2 .and. !( DOKUM->( Eof()))

         if DOKUM->BLOKADA == 'O'; DOKUM->( DBSkip()); loop; endif

         if Empty( inp )
            nrp := -0.1
         else
            if nrp # DOKUM->NABYWCA
               DOKUM->( DBSkip())
               loop
            endif
         endif
         if (( ','+AllTrim(DOKUM->TYP)+',') $ (','+typy+','))
            DBAppend()
            replace ID_D with DOKUM->ID
         endif
         DOKUM->( DBSkip())

         if Przerwa(); exit; endif

   enddo
   Przerwa( 0 )

   go top
   IncDBES( 1 )
   while !Eof()
         IncDBES()

         skip
   enddo

   go top
   wy := 2
   Czek( 0 )

   h := h + ' w okresie ' + DtoC( data1 ) + '-' + DtoC( data2 )
   h += ' dla dokument¢w: ' + typy
   h += if( Empty( inp ), '', ' (firma: ' + AllTrim( inp ) + ' (' + AllS( nrp ) + '))' )
   DBE_Tyt := h + '|' + typy + '|' + AllS( nrp )

   PutIni()
   ShowDBES( 1 )  && bez GETIni() na poczatku
   DBE_Tyt := h

endif

******************************************************************************
* z_firm - uruchamiane z bazy firm jako podglÜd dokument¢w kontrahenta

procedure DokAnaR( a, b, h, z_firm )

local tab, bb := Alias(), drobno
private typy, nrp := 0, inp := Space(15)

b := if( b # NIL, b, '' )
typy := PadR( b, 50 )

GetIni(,,@tab)
if Len( tab ) > 0 .and. !Empty( tab[ 1 ])
   typy := PadR( tab[ 1 ], Len( typy ))
endif

if z_firm # NIL
   nrp := globalbuf
   inp := globalbuf1
   data1 := CtoD('')
else
   if Len( tab ) > 1 .and. !Empty( tab[ 2 ])
      nrp := Val( tab[ 2 ])
   endif
endif

if Ana_Daty_B; data2 := Datee(); endif

if z_firm # NIL .or. NewSysForm( a )
	drobno := .f.
	if z_firm = NIL
		drobno := ( Alarm( 'Czy wykazywaÊ kaødπ wp≥atÍ w osobnym wierszu ?', tk, 1 ) = 1 )
	endif
   Czek( 1 )
	ON( 'DOKSPL' )
	Jest_baza( bb )
   DBZap('')
   typy := AllTrim( typy )
   DOKUM->( DBSetOrder( 3 ))    && DtoS( DATAS ) + INDEKS
   DOKUM->( DBSeek( DtoS( data1 ), .t. ))
   Przerwa( DOKUM->( LastRec()))
   while DOKUM->DATAS <= data2 .and. !( DOKUM->( Eof()))

         if DOKUM->BLOKADA == 'O'; DOKUM->( DBSkip()); loop; endif

         if Empty( inp )
            nrp := -0.1
         else
            if nrp # DOKUM->NABYWCA
               DOKUM->( DBSkip())
               loop
            endif
         endif
         if (( ','+AllTrim(DOKUM->TYP)+',') $ (','+typy+','))
            DBAppend()
            replace ID_D with DOKUM->ID
            replace ID_F with DOKUM->NABYWCA

				Select( 'DOKSPL' )
				DBSeek( Str(( bb )->ID_F ) + Str(( bb )->ID_D ))
				while ID_D = ( bb )->ID_D .and. !Eof()
						if drobno .and. (( bb )->ILE > 0 )
							KopiujRec( bb, bb )
							( bb )->WPLATY := 0
						endif
						( bb )->UWAGIOW := UWAGI
						( bb )->WPLATY += KWOTA
						( bb )->ILE += 1
						if drobno
							( bb )->DATAOW := DATAW
						else
							( bb )->DATAOW := Max(( bb )->DATAOW, DATAW )
						endif
						DBSkip()
				enddo
				Select( bb )
         endif
         DOKUM->( DBSkip())

         if Przerwa(); exit; endif

   enddo
   Przerwa( 0 )

   go top
   IncDBES( 1 )
   while !Eof()
         IncDBES()
         skip
   enddo

   go top
   wy := 2
   Czek( 0 )

   h := h + ' w okresie ' + DtoC( data1 ) + '-' + DtoC( data2 )
   h += ' dla dokument¢w: ' + typy
   h += if( Empty( inp ), '', ' (firma: ' + AllTrim( inp ) + ' (' + AllS( nrp ) + '))' )
   DBE_Tyt := h + '|' + typy + '|' + AllS( nrp )

   PutIni()
*   ShowDBES( 1 )  && bez GETIni() na poczatku
   DBE_Tyt := h
	Kryteria := '(("' + DtoS( data3 ) + '"<=DtoS(DATAOW)).and.(DtoS(DATAOW)<="' + DtoS( data4 ) + '"))'
	KryteriaU:= '"Data wpíaty" z okresu: ' + DtoC( data3 ) + ' - ' + DtoC( data4 )

endif

******************************************************************************
* z_firm - uruchamiane z bazy firm jako podglÜd dokument¢w kontrahenta

procedure DokAnaRK( a, b, h, z_firm )

local tab, bb := Alias()
private typy, nrp := 0, inp := Space(15)

b := if( b # NIL, b, '' )
typy := PadR( b, 50 )

GetIni(,,@tab)
if Len( tab ) > 0 .and. !Empty( tab[ 1 ])
   typy := PadR( tab[ 1 ], Len( typy ))
endif

if z_firm # NIL
   nrp := globalbuf
   inp := globalbuf1
   data1 := CtoD('')
else
   if Len( tab ) > 1 .and. !Empty( tab[ 2 ])
      nrp := Val( tab[ 2 ])
   endif
endif

if Ana_Daty_B; data2 := Datee(); endif

if z_firm # NIL .or. NewSysForm( a )
   Czek( 1 )
   DBZap('')
   ON( 'DOKUM' )
	ON( 'DOKSPL' )
   typy := AllTrim( typy )
   Przerwa( DOKUM->( LastRec()))
   while !Eof()
			if !( data1 <= DATAW .and. DATAW <= data2 )
	         if Przerwa(); exit; endif
				DBSkip()
				loop
			endif
			DOKUM->( DBSeek( DOKSPL->ID_D ))
         if Empty( inp ); nrp := -0.1
         else
				if nrp # DOKUM->NABYWCA
		         if Przerwa(); exit; endif
               DBSkip()
               loop
            endif
         endif
         if !Empty( typy ) .and. !(( ','+AllTrim(DOKUM->TYP)+',') $ (','+typy+','))
	         if Przerwa(); exit; endif
            DBSkip()
            loop
         endif

         AppendRecord( bb, { 0, '', DATAW, DATAW, DATAW, DATAW,;
DOKUM->TYP + AllTrim( DOKUM->INDEKS ),;
DOKUM->NIP,;
AllTrim( DOKUM->NAZWA1 ) + AllTrim( DOKUM->NAZWA2 ) + AllTrim( DOKUM->NAZWA3 ),;
DOKUM->KOD + ' ' + AllTrim( DOKUM->MIASTO ) + ', ul. ' + AllTrim( DOKUM->ADRES ),;
if( KWOTA > 0, KWOTA, 0 ), if( KWOTA < 0, -KWOTA, 0 ), UWAGI, DOKUM->NABYWCA, DOKUM->INDEKS_F })

         DBSkip()

         if Przerwa(); exit; endif

   enddo
   Przerwa( 0 )

	Select( bb )
   go top
   IncDBES( 1 )
   while !Eof()
         IncDBES()
         skip
   enddo

   go top
   wy := 2
   Czek( 0 )

   h := h + ' w okresie ' + DtoC( data1 ) + '-' + DtoC( data2 )
   h += ' dla dokument¢w: ' + typy
   h += if( Empty( inp ), '', ' (firma: ' + AllTrim( inp ) + ' (' + AllS( nrp ) + '))' )
   DBE_Tyt := h + '|' + typy + '|' + AllS( nrp )

   PutIni()
   ShowDBES( 1 )  && bez GETIni() na poczatku
   DBE_Tyt := h

endif

******************************************************************************

procedure DokAna5( a, b, h )

local tab
private typy

b := if( b # NIL, b, '' )
typy := PadR( b, 50 )

GetIni(,,@tab)
if Len( tab ) > 0 .and. !Empty( tab[ 1 ])
   typy := PadR( tab[ 1 ], Len( typy ))
endif

if Ana_Daty_B; data2 := Datee(); endif

if NewSysForm( a )
   Czek( 1 )
   DBZap('')
   typy := AllTrim( typy )
   DOKUM->( DBSetOrder( 3 ))    && DtoS( DATAS ) + INDEKS
   DOKUM->( DBSeek( DtoS( data1 ), .t. ))
   Przerwa( DOKUM->( LastRec()))
   while DOKUM->DATAS <= data2 .and. !( DOKUM->( Eof()))
         if DOKUM->BLOKADA == 'O'; DOKUM->( DBSkip()); loop; endif
         if (( ','+AllTrim(DOKUM->TYP)+',') $ (','+typy+','))
            if !DBSeek( DOKUM->NABYWCA )
               DBAppend()
            endif
            replace ID_F with DOKUM->NABYWCA
if DataRW() = 1
            replace WARTOSC with WARTOSC + DOKUM->WARTOSC
            replace NETTO with NETTO + DOKUM->(WARTOSC - VAT23 - VAT8 - VAT5 - VAT22 - VAT7 )
endif
         endif
         DOKUM->( DBSkip())
         if Przerwa(); exit; endif
   enddo
   Przerwa( 0 )

   go top
   IncDBES( 1 )
   while !Eof()
         IncDBES()

         skip
   enddo

   go top
   wy := 2
   Czek( 0 )

   h := h + ' w okresie ' + DtoC( data1 ) + '-' + DtoC( data2 )
   h += ' dla dokument¢w: ' + typy

   DBE_Tyt := h + '|' + typy

   PutIni()

   ShowDBES( 1 )  && bez GETIni() na poczatku
   DBE_Tyt := h

endif

******************************************************************************

procedure DokAna4( a, b, h, hh, ti1, to1, ti2, to2, idt )

local tab, wp, il, idf, idd, bb, ww, wt, ok, g, z, zn, p1, p2, sc, ek, deska, wza, wna, d1, d2, d3, d4
private debug1 := .f., debug2 := .f., dwaetapy := .f.
private typy, srednio := "T", nrp := 0, inp := Space(15)
private typynakin1, typynakou1, typynakin2, typynakou2, stat := '*'

b := if( b # NIL, b, '' )
ti1 := if( ti1 # NIL, ti1, '' )
to1 := if( to1 # NIL, to1, '' )
ti2 := if( ti2 # NIL, ti2, '' )
to2 := if( to2 # NIL, to2, '' )

typy := PadR( b, 50 )

typynakin1:= PadR( ti1, 50 )
typynakou1:= PadR( to1, 50 )

typynakin2:= PadR( ti2, 50 )
typynakou2:= PadR( to2, 50 )

GetIni(,,@tab)

if Len( tab ) > 0 .and. !Empty( tab[ 1 ])
   typy := PadR( tab[ 1 ], Len( typy ))
endif

if Len( tab ) > 1 .and. !Empty( tab[ 2 ])
   srednio := tab[ 2 ]
endif

if Len( tab ) > 2 .and. !Empty( tab[ 3 ])
   nrp := Val( tab[ 3 ])
endif

if Len( tab ) > 3 .and. !Empty( tab[ 4 ])
   typynakin1 := PadR( tab[ 4 ], Len( typy ))
endif

if Len( tab ) > 4 .and. !Empty( tab[ 5 ])
   typynakou1 := PadR( tab[ 5 ], Len( typy ))
endif

if Len( tab ) > 5 .and. !Empty( tab[ 6 ])
   typynakin2 := PadR( tab[ 6 ], Len( typy ))
endif

if Len( tab ) > 6 .and. !Empty( tab[ 7 ])
   typynakou2 := PadR( tab[ 7 ], Len( typy ))
endif

if Len( tab ) > 7
   stat := tab[ 8 ]
endif

if Ana_Daty_B; data2 := Datee(); endif

ek := .f.			&& nie sia≥o na ekranie

if '4a,' $ a
   inp := ''
   nrp := -0.1
   data3 := CtoD('01.01.1000')
   data4 := CtoD('01.01.3000')
endif

if NewSysForm( a )

	sc := SaveScreen()

	cls

   Czek( 1 )
	@ 0, 0 say ''	//ustaw kursor dla siania na ekranie
   DBZap('')

   typy := AllTrim( typy )
   typynakin1 := AllTrim( typynakin1 )
   typynakou1 := AllTrim( typynakou1 )
   typynakin2 := AllTrim( typynakin2 )
   typynakou2 := AllTrim( typynakou2 )
   stat := Upper( stat )

if dwaetapy
   d1 := data1	//30.10.2007	wiÍkszy (dokumenty)
   d2 := data2	//31.01.2008
   d3 := data3	//01.01.2008	mniejszy (zap≥aty)
   d4 := data4	//31.01.2008
endif

if debug1 .or. debug2
	mOpen(cat_wydr+'DokAna4.txt')
	?? Datee(), Time()
	?
	? 'Okres 1: ', d1, d2
	? 'Okres 2: ', d3, d4
	?
endif

*********************************************** Etap 1:  okres przed mniejszym, tj. 30.10.2007 - 31.12.2007
//SPRZWZAPL, ZAPLACONE 	(zap≥aty)
//ILOSC, ZAPLNARAST	(dokumenty)

if dwaetapy
   data2 := data3 - 1
   data3 := data1
   data4 := data2
endif

if debug1 .or. debug2
	?
	? 'Etap 1: '
	? 'Okres 1: ', data1, data2
	? 'Okres 2: ', data3, data4
	?
endif

   DOKUM->( DBSetOrder( 3 ))    && DtoS( DATAS ) + INDEKS
   SPEC->( DBSetOrder( 1 ))     && dokument
   DOKUM->( DBSeek( DtoS( data1 ), .t. ))
*   Przerwa( DOKUM->( LastRec()))
   while DOKUM->DATAS <= data2 .and. !( DOKUM->( Eof()))
         if DOKUM->BLOKADA == 'O'; DOKUM->( DBSkip()); loop; endif
         if Empty( inp )
            nrp := -0.1
         else
            if nrp # DOKUM->NABYWCA
               DOKUM->( DBSkip())
               loop
            endif
         endif
*	if DOKUM->ID=19378; Alarm('OK'); endif
	wp := 0
	ww := 0
	wt := 0
         if (( ','+AllTrim(DOKUM->TYP)+',') $ (','+typy+','))
				if ( FieldPos( 'ZAPLACONE' ) > 0 )
					bb := Alias()
					idf := DOKUM->NABYWCA
					idd := DOKUM->ID
					ON( 'DOKSPL' )	&& Str(ID_F)+Str(ID_D)+Str(ID)
					DBSeek( Str( idf, 10 ) + Str( idd, 10 ))
					while ( idf = ID_F ) .and. ( idd = ID_D ) .and. !Eof()
							if Between( DATAW, data1, data2 ) //okres dokumentÛw: 30.10.2007 - 31.01.2008
								ww += KWOTA		  //zap≥aty w okresie dokumentÛw
							endif
							if Between( DATAW, data3, data4 ) //okres zap≥at: 01.01.2008 - 31.01.2008
								wp += KWOTA		  //zap≥aty w okresie zap≥at
if debug1; ? DOKUM->ID, DOKUM->TYP, DOKUM->DATAS, DATAW, KWOTA, wp; endif
							endif
							wt += KWOTA
							skip
					enddo
					if Abs( DOKUM->WPLACONO - wt ) > 0.009
						? AllTrim( DOKUM->TYP + DOKUM->INDEKS ) + ' z dnia ' + DtoC(DOKUM->DATAW) + ' wpíacono # zapíaty;' + Transform( DOKUM->WPLACONO, '999,999.99' ) + ' # ' + Transform( wt, '999,999.99' )
						ek := .t.			&& sia≥o na ekranie
					endif
					Select( bb )
				endif
	deska := 0
	SPEC->( DBSeek( DOKUM->ID ))
	while SPEC->ID_D = DOKUM->ID .and. SPEC->( !Eof())
		if srednio == "T"
			if !DBSeek( Str( SPEC->ID_T ))
				DBAppend()
			endif
		else
			if !DBSeek( Str( SPEC->ID_T ) + Str( SPEC->CENA ))
				DBAppend()
			endif
		endif
		deska := RecNo()
		replace ID_T with SPEC->ID_T
		if DataRW() = 1
			replace WARTOSC with WARTOSC + Grosz( SPEC->CENA * SPEC->ILOSC )
			replace ILOSC with ILOSC + SPEC->ILOSC
			if ILOSC # 0
				replace CENA with Grosz( WARTOSC / ILOSC )
			endif
		endif
					if ( FieldPos( 'ZAPLACONE' ) > 0 )
						wwvat:=TOWARY->(GetPole(1,'SPEC->ID_T','VAT','TOWARY',,,1,,,'STAROCIE\TOWARY'))
						if SPEC->ILOSC > 0.000		&& faktura
							il := Min( Int( Grosz( wp / Brutto( SPEC->CENA, wwvat))), SPEC->ILOSC )
						else								&& korekta
							il := Max( Int( Grosz( wp / Brutto( SPEC->CENA, wwvat))), SPEC->ILOSC )
						endif
						wza := Brutto( Grosz( SPEC->CENA * il ), wwvat )
						wp -= wza		&& 100 -= 105
						if .f. .and. wp < 0		&& -5
							wza += wp	&& 105 += -5  => 100
							wp := 0
						endif
						replace ZAPLACONE with ZAPLACONE + il
						replace ZAPLATYW with ZAPLATYW + wza
if debug1 .and. ((wza<>0) .or. (wp<>0)); ? 'wza=', wza, 'wp=', wp; endif
if debug2 .and. ID_T=156; ? ILOSC, CENA, WARTOSC, ', a zap≥aty:', il, SPEC->CENA, wza, ', W = ', ZAPLACONE, ZAPLATYW; endif
						if .f. .and. ZAPLATYW < 0
							wp := -ZAPLATYW
if debug1 .and. ((wza<>0) .or. (wp<>0)); ? 'wza=', wza, 'wp=', wp,' <-- minusy'; endif
if debug2 .and. ID_T=156; ? ILOSC, CENA, WARTOSC, ', a minusy:', il, SPEC->CENA, wza, wp; endif
							replace ZAPLATYW with 0
						endif						
if idt # NIL .and. idt = ID_T
	? 'Z ' + DOKUM->TYP, DOKUM->INDEKS, SPEC->ILOSC, il, ZAPLACONE
endif
					endif
					if ( FieldPos( 'ZAPLNARAST' ) > 0 )
						wwvat:=TOWARY->(GetPole(1,'SPEC->ID_T','VAT','TOWARY',,,1,,,'STAROCIE\TOWARY'))
						if SPEC->ILOSC > 0.000		&& faktura
							il := Min( Int( Grosz( ww / Brutto( SPEC->CENA, wwvat))), SPEC->ILOSC )
						else								&& korekta
							il := Max( Int( Grosz( ww / Brutto( SPEC->CENA, wwvat))), SPEC->ILOSC )
						endif
						wza := Brutto( Grosz( SPEC->CENA * il ), wwvat )
						ww -= wza
						if .f. .and. ww < 0		&& -5
if debug2 .and. ID_T=156; ? ILOSC, CENA, WARTOSC, ', a minusy:', il, SPEC->CENA, wza, ww; endif
							wza += ww	&& 105 += -5  => 100
							ww := 0
						endif
						replace ZAPLNARAST with ZAPLNARAST + il
						replace ZAPLATYN with ZAPLATYN + wza
if debug2 .and. ID_T=156; ? ILOSC, CENA, WARTOSC, ', a zap≥aty:', il, SPEC->CENA, wza, ', N = ', ZAPLNARAST, ZAPLATYN; endif
						if .f. .and. ZAPLATYN < 0
							ww := -ZAPLATYN
							replace ZAPLATYN with 0
						endif						
if idt # NIL .and. idt = ID_T
	? 'N ' + DOKUM->TYP, DOKUM->INDEKS, SPEC->ILOSC, il, ZAPLNARAST
endif
					endif
					if ( FieldPos( 'SPRZWZAPL' ) > 0 ) .and. Between( DOKUM->DATAS, data3, data4 )
						replace SPRZWZAPL with SPRZWZAPL + SPEC->ILOSC
if debug2 .and. ID_T=156; ? ILOSC, CENA, WARTOSC, ', a potem :', il, SPEC->CENA, wza, ', S = ', SPRZWZAPL; endif
					endif
               SPEC->( DBSkip())
            enddo

	if (deska>0 .and. (( Grosz( ww )<> 0 ).or. ( Grosz( wp ) <> 0 )))
if debug1; ? 'Deska: ', wp, ww; endif
		DBGoTo( deska )
		replace ZAPLATYW with ZAPLATYW + wp
		replace ZAPLATYN with ZAPLATYN + ww
	endif

         endif

         DOKUM->( DBSkip())

*if idt = NIL
*         if Przerwa(); exit; endif
*endif
   enddo

*   Przerwa( 0 )

if dwaetapy

*********************************************** Etap 2:  okres wiÍkszy, tj. okres dokumentÛw: 30.10.2007 - 31.01.2008
//SPRZWZAPL, ZAPLACONE, ZAPLATYW  	(zap≥aty)	<--- teraz tego nie zamazywaÊ !!!
//ILOSC, ZAPLNARAST, ZAPLATYN		(dokumenty)	<--- a to wyczyúciÊ

   go top
   Przerwa( LastRec())
   while !Eof()
        if Przerwa(); exit; endif
	Blokuj_R()
	replace ILOSC with 0, ZAPLNARAST with 0, WARTOSC with 0, ZAPLATYN with 0, CENA with 0
	OdBlokuj_R()
	skip
   enddo
   Przerwa( 0 )

   data1 := d1
   data2 := d2
   data3 := d1
   data4 := d2

if debug1 .or. debug2
	?
	? 'Etap 2: '
	? 'Okres 1: ', data1, data2
	? 'Okres 2: ', data3, data4
	?
endif

   DOKUM->( DBSetOrder( 3 ))    && DtoS( DATAS ) + INDEKS
   SPEC->( DBSetOrder( 1 ))     && dokument
   DOKUM->( DBSeek( DtoS( data1 ), .t. ))
*   Przerwa( DOKUM->( LastRec()))
   while DOKUM->DATAS <= data2 .and. !( DOKUM->( Eof()))
         if DOKUM->BLOKADA == 'O'; DOKUM->( DBSkip()); loop; endif
         if Empty( inp )
            nrp := -0.1
         else
            if nrp # DOKUM->NABYWCA
               DOKUM->( DBSkip())
               loop
            endif
         endif
	wp := 0												&& DOKUM->WPLACONO
	ww := 0
	wt := 0
         if (( ','+AllTrim(DOKUM->TYP)+',') $ (','+typy+','))
				if ( FieldPos( 'ZAPLACONE' ) > 0 )
					bb := Alias()
					idf := DOKUM->NABYWCA
					idd := DOKUM->ID
					ON( 'DOKSPL' )	&& Str(ID_F)+Str(ID_D)+Str(ID)
					DBSeek( Str( idf, 10 ) + Str( idd, 10 ))
					while ( idf = ID_F ) .and. ( idd = ID_D ) .and. !Eof()
							if Between( DATAW, data1, data2 ) //okres dokumentÛw: 30.10.2007 - 31.01.2008
								ww += KWOTA		  //zap≥aty w okresie dokumentÛw
							endif
							if Between( DATAW, data3, data4 ) //okres zap≥at: 01.01.2008 - 31.01.2008
								wp += KWOTA		  //zap≥aty w okresie zap≥at
if debug1; ? DOKUM->ID, DOKUM->TYP, DOKUM->DATAS, DATAW, KWOTA, wp; endif
							endif
							wt += KWOTA
							skip
					enddo
					if Abs( DOKUM->WPLACONO - wt ) > 0.009
						? AllTrim( DOKUM->TYP + DOKUM->INDEKS ) + ' z dnia ' + DtoC(DOKUM->DATAW) + ' wpíacono # zapíaty;' + Transform( DOKUM->WPLACONO, '999,999.99' ) + ' # ' + Transform( wt, '999,999.99' )
						ek := .t.			&& sia≥o na ekranie
					endif
					Select( bb )
				endif
	deska := 0
	SPEC->( DBSeek( DOKUM->ID ))
	while SPEC->ID_D = DOKUM->ID .and. SPEC->( !Eof())
		if srednio == "T"
			if !DBSeek( Str( SPEC->ID_T ))
				DBAppend()
			endif
		else
			if !DBSeek( Str( SPEC->ID_T ) + Str( SPEC->CENA ))
				DBAppend()
			endif
		endif
		deska := RecNo()
		replace ID_T with SPEC->ID_T
		if DataRW() = 1
			replace WARTOSC with WARTOSC + Grosz( SPEC->CENA * SPEC->ILOSC )
			replace ILOSC with ILOSC + SPEC->ILOSC
			if ILOSC # 0
				replace CENA with Grosz( WARTOSC / ILOSC )
			endif
		endif
					if ( FieldPos( 'ZAPLACONE' ) > 0 )
						wwvat:=TOWARY->(GetPole(1,'SPEC->ID_T','VAT','TOWARY',,,1,,,'STAROCIE\TOWARY'))
						if SPEC->ILOSC > 0.000		&& faktura
							il := Min( Int( Grosz( wp / Brutto( SPEC->CENA, wwvat))), SPEC->ILOSC )
						else				&& korekta
							il := Max( Int( Grosz( wp / Brutto( SPEC->CENA, wwvat))), SPEC->ILOSC )
						endif
						wza := Brutto( Grosz( SPEC->CENA * il ), wwvat )
						wp -= wza		&& 100 -= 105
						if wp < 0		&& -5
							wza += wp	&& 105 += -5  => 100
							wp := 0
						endif
//						replace ZAPLACONE with ZAPLACONE + il
//						replace ZAPLATYW with ZAPLATYW + wza
//						if ZAPLATYW < 0
//							wp := 0
//							wp := -ZAPLATYW
//							replace ZAPLATYW with 0
//						endif						
if idt # NIL .and. idt = ID_T
	? 'Z ' + DOKUM->TYP, DOKUM->INDEKS, SPEC->ILOSC, il, ZAPLACONE
endif
					endif
					if ( FieldPos( 'ZAPLNARAST' ) > 0 )
						wwvat:=TOWARY->(GetPole(1,'SPEC->ID_T','VAT','TOWARY',,,1,,,'STAROCIE\TOWARY'))
						if SPEC->ILOSC > 0.000		&& faktura
							il := Min( Int( Grosz( ww / Brutto( SPEC->CENA, wwvat))), SPEC->ILOSC )
						else								&& korekta
							il := Max( Int( Grosz( ww / Brutto( SPEC->CENA, wwvat))), SPEC->ILOSC )
						endif
						wza := Brutto( Grosz( SPEC->CENA * il ), wwvat )
						ww -= wza
						if ww < 0		&& -5
if debug2 .and. ID_T=156; ? ILOSC, CENA, WARTOSC, ', a minusy:', il, SPEC->CENA, wza, ww; endif
							wza += ww	&& 105 += -5  => 100
							ww := 0
						endif
						replace ZAPLNARAST with ZAPLNARAST + il
						replace ZAPLATYN with ZAPLATYN + wza
if debug2 .and. ID_T=156; ? ILOSC, CENA, WARTOSC, ', a zap≥aty:', il, SPEC->CENA, wza, ', N = ', ZAPLNARAST, ZAPLATYN; endif
						if ZAPLATYN < 0
							ww := -ZAPLATYN
if debug2 .and. ID_T=156; ? ILOSC, CENA, WARTOSC, ', a minusy !!!:', il, SPEC->CENA, wza, ww; endif
							replace ZAPLATYN with 0
						endif						
if idt # NIL .and. idt = ID_T
	? 'N ' + DOKUM->TYP, DOKUM->INDEKS, SPEC->ILOSC, il, ZAPLNARAST
endif
					endif
//					if ( FieldPos( 'SPRZWZAPL' ) > 0 ) .and. Between( DOKUM->DATAS, data3, data4 )
//						replace SPRZWZAPL with SPRZWZAPL + SPEC->ILOSC
//					endif
               SPEC->( DBSkip())
            enddo

	if (deska>0 .and. (ww#0.00 .or. wp#0.00))
		DBGoTo( deska )
if debug1; ? 'Deska: ', wp, ww; endif
//		replace ZAPLATYW with ZAPLATYW + wp
		replace ZAPLATYN with ZAPLATYN + ww
	endif

         endif

         DOKUM->( DBSkip())

*if idt = NIL
*         if Przerwa(); exit; endif
*endif
   enddo

*   Przerwa( 0 )

endif

*********************************************** Teraz jako rÛønica **************************************

if debug1 .or. debug2
	mClose()
	Druk(cat_wydr+'DokAna4.txt',1)
endif

if ek
	?
	? 'Wydruk=klawisz PrintScreen (PrnScr)           Enter=bez wydruku'
	Inkey( 0 )
endif

   DOKUM->( DBSetOrder( 3 ))    && DtoS( DATAS ) + INDEKS
   SPEC->( DBSetOrder( 1 ))     && dokument
   DOKUM->( DBSeek( DtoS( data1 ), .t. ))
   Przerwa( DOKUM->( LastRec()))
   while DOKUM->DATAS <= data2 .and. !( DOKUM->( Eof()))
         if DOKUM->BLOKADA == 'O'; DOKUM->( DBSkip()); loop; endif
         if Empty( inp )
            nrp := -0.1
         else
            if nrp # DOKUM->NABYWCA
               DOKUM->( DBSkip())
               loop
            endif
         endif

         if (( ','+AllTrim(DOKUM->TYP)+',') $ (','+typynakin1+','));
				.and.;
				( FieldPos( 'NAKLADLIC1' ) > 0 )

            SPEC->( DBSeek( DOKUM->ID ))
            while SPEC->ID_D = DOKUM->ID .and. SPEC->( !Eof())
					ok := .f.
               if srednio == "T"
                  ok := DBSeek( Str( SPEC->ID_T ))
               else
                  ok := DBSeek( Str( SPEC->ID_T ) + Str( SPEC->CENA ))
               endif
					if ok
						replace NAKLADLIC1 with NAKLADLIC1 + SPEC->ILOSC
					endif
               SPEC->( DBSkip())
            enddo
			endif

         if (( ','+AllTrim(DOKUM->TYP)+',') $ (','+typynakou1+','));
				.and.;
				( FieldPos( 'NAKLADLIC1' ) > 0 )

            SPEC->( DBSeek( DOKUM->ID ))
            while SPEC->ID_D = DOKUM->ID .and. SPEC->( !Eof())
					ok := .f.
               if srednio == "T"
                  ok := DBSeek( Str( SPEC->ID_T ))
               else
                  ok := DBSeek( Str( SPEC->ID_T ) + Str( SPEC->CENA ))
               endif
					if ok
						replace NAKLADLIC1 with NAKLADLIC1 - SPEC->ILOSC
					endif
               SPEC->( DBSkip())
            enddo
			endif

         if (( ','+AllTrim(DOKUM->TYP)+',') $ (','+typynakin2+','));
				.and.;
				( FieldPos( 'NAKLADLIC2' ) > 0 )

            SPEC->( DBSeek( DOKUM->ID ))
            while SPEC->ID_D = DOKUM->ID .and. SPEC->( !Eof())
					ok := .f.
               if srednio == "T"
                  ok := DBSeek( Str( SPEC->ID_T ))
               else
                  ok := DBSeek( Str( SPEC->ID_T ) + Str( SPEC->CENA ))
               endif
					if ok
						replace NAKLADLIC2 with NAKLADLIC2 + SPEC->ILOSC
					endif
               SPEC->( DBSkip())
            enddo
			endif

         if (( ','+AllTrim(DOKUM->TYP)+',') $ (','+typynakou2+','));
				.and.;
				( FieldPos( 'NAKLADLIC2' ) > 0 )

            SPEC->( DBSeek( DOKUM->ID ))
            while SPEC->ID_D = DOKUM->ID .and. SPEC->( !Eof())
					ok := .f.
               if srednio == "T"
                  ok := DBSeek( Str( SPEC->ID_T ))
               else
                  ok := DBSeek( Str( SPEC->ID_T ) + Str( SPEC->CENA ))
               endif
					if ok
						replace NAKLADLIC2 with NAKLADLIC2 - SPEC->ILOSC
					endif
               SPEC->( DBSkip())
            enddo
			endif

         DOKUM->( DBSkip())

         if Przerwa(); exit; endif
   enddo

   Przerwa( 0 )

   go top
   IncDBES( 1 )
   while !Eof()
			if ( FieldPos( 'NAKLAD' ) > 0 )
				il := 0
				ON( 'TOWARK',2)
				if DBSeek(( bb )->ID_T )
					ON( 'TOWARKS' )
					DBSeek( Str( TOWARK->ID ))
					while TOWARK->ID = ID_K .and. !Eof()
							il += NAKLAD
							skip
					enddo
				endif

				Select( bb )

				Blokuj_R()

*********************************************** Teraz jako rÛønica **************************************

if dwaetapy
				replace SPRZWZAPL with ILOSC - SPRZWZAPL, ZAPLACONE with ZAPLNARAST - ZAPLACONE, ZAPLATYW with ZAPLATYN - ZAPLATYW
endif
				z := ZAPLACONE
				zn := ZAPLNARAST
				baza := bb
				p1 := TOWARY->( GetPole( -1, 'ID_T', 'PROWIZJA', 'TOWARY',,,,,,'STAROCIE\TOWARY'))
				p2 := TOWARY->( GetPole( -1, 'ID_T', 'PROWIZJA2', 'TOWARY',,,,,,'STAROCIE\TOWARY'))
				g := TOWARY->( GetPole( -1, 'ID_T', 'ILOSC_DP2', 'TOWARY',,,,,,'STAROCIE\TOWARY'))

				replace STAWKA_1 with p1
				replace STAWKA_2 with p2

				do case
				case zn <= g
						replace ILOSC_1 with z
						replace ILOSC_2 with 0
				case zn - z > g
						replace ILOSC_1 with 0
						replace ILOSC_2 with z
				otherwise
						replace ILOSC_1 with g - ( zn - z )
						replace ILOSC_2 with zn - g
				endcase

				replace PROWIZJA1 with ILOSC_1 * p1
				replace PROWIZJA2 with ILOSC_2 * p2
				replace NAKLAD with il
				replace NAKLADLICZ with NAKLADLIC1 + NAKLADLIC2
				OdBlokuj_R()
			endif
		x := ''
		s := TOWARY->( GetPole( -1, 'ID_T', 'STATUS', 'TOWARY',,,,,,'STAROCIE\TOWARY'))
		if stat<>'*'
			if s<>stat; x:='sio'; endif
		endif
		if x == 'sio'; BDelete()
		else; IncDBES(); endif
         skip
   enddo

if dwaetapy
   data1 := d1
   data2 := d2
   data3 := d3
   data4 := d4
endif

   go top
   wy := 2
   Czek( 0 )
   h := h + ' w okresie ' + DtoC( data1 ) + ' - ' + DtoC( data2 )
   h += ' dla dokument¢w: ' + typy
   h += if( Empty( inp ), '', ' (firma: ' + AllTrim( inp ) + ' (' + AllS( nrp ) + '))' )
   h += if( srednio == "T", hh, '' )
	if ( FieldPos( 'ZAPLACONE' ) > 0 )
	   h += ' dla zapíat z okresu: ' + DtoC( data3 ) + ' - ' + DtoC( data4 )
	endif
   DBE_Tyt := h + '|' + typy + '|' + srednio + '|' + AllS( nrp ) + '|' + typynakin1 + '|' + typynakou1 + '|' + typynakin2 + '|' + typynakou2 + '|' + stat + '|'

   PutIni()
   ShowDBES( 1 )  && bez GETIni() na poczatku
   DBE_Tyt := h
   RestScreen(,,,,sc)
endif

******************************************************************************

procedure DokAna9( a, b, c, h, hh )

DokAna3( a, b, c, h, hh, .t. )

******************************************************************************

procedure DokAna3( a, b, c, h, hh, zcenami )

local tab, pr, ro, wa
local mn1, mn2, mnod, mnbu, zeruj
private it := 0, typyp, typyr, zmroli := "T", nrp := 0, inp := Space(15), cenyza := "T"

if zcenami = NIL; zcenami :=.f.; endif

b := if( b # NIL, b, '' )
typyp := PadR( b, 50 )

c := if( c # NIL, c, '' )
typyr := PadR( c, 50 )

GetIni(,,@tab)

if Len( tab ) > 0 .and. !Empty( tab[ 1 ])
   typyp := PadR( tab[ 1 ], Len( typyp ))
endif

if Len( tab ) > 1 .and. !Empty( tab[ 2 ])
   typyr := PadR( tab[ 2 ], Len( typyr ))
endif

if Len( tab ) > 2 .and. !Empty( tab[ 3 ])
   zmroli := tab[ 3 ]
endif

if Len( tab ) > 3 .and. !Empty( tab[ 4 ])
   it := Val( tab[ 4 ])
endif

if Len( tab ) > 4 .and. !Empty( tab[ 5 ])
   nrp := Val( tab[ 5 ])
endif

if zcenami
if Len( tab ) > 5 .and. !Empty( tab[ 6 ])
   cenyza := tab[ 6 ]
endif
endif

if Ana_Daty_B; data2 := Datee(); endif

mnod := .f.    && domyûlnie "mnoßnik odwrotnie" = NIE
if NewSysForm( a )

   Czek( 1 )
   DBZap('')

   typyp := StrTran( typyp, ' ', '' )
   typyr := StrTran( typyr, ' ', '' )

   TOWARY->( DBSetOrder( 1 ))   && ID
   TOWARY->( DBSeek( it ))

   DOKUM->( DBSetOrder( 3 ))    && DtoS( DATAS ) + INDEKS
   SPEC->( DBSetOrder( 3 ))     && Str( dokument ) + Str( towar )

   DOKUM->( DBSeek( DtoS( data1 ), .t. ))
   Przerwa( DOKUM->( LastRec()))
   while DOKUM->DATAS <= data2 .and. !( DOKUM->( Eof()))
         if DOKUM->BLOKADA == 'O'
            DOKUM->( DBSkip())
            loop
         endif
         if Empty( inp )
            nrp := -0.1
            mnod := .f.    && domyûlnie "mnoßnik odwrotnie" = NIE
         else
            if MZzalezny
               if ( nrp # DOKUM->MAGAZYN ) .and. ( nrp # DOKUM->NABYWCA )
                  DOKUM->( DBSkip())
                  loop
               endif
               if NRMG = 0
                  mnod := ( nrp = DOKUM->NABYWCA )  && odwrotna rola dokumentu
               endif
            else
               if ( nrp # DOKUM->NABYWCA )
                  DOKUM->( DBSkip())
                  loop
               endif
            endif
         endif
         mn1 := 0
         mn2 := 0
         if (( ','+AllTrim(DOKUM->TYP)+',') $ (','+typyp+','))
            mn1 := 1
         endif
         if (( ','+AllTrim(DOKUM->TYP)+',') $ (','+typyr+','))
            mn2 := 1
         endif
         if mnod           && odwyrtka
            mnbu := mn1
            mn1 := mn2
            mn2 := mnbu
         endif
         if mn1 # 0 .or. mn2 # 0
            SPEC->( DBSeek( Str( DOKUM->ID ) + Str( it, 10 )))
            while Str( DOKUM->ID ) + Str( it, 10 ) == SPEC->( Str( ID_D ) + Str( ID_T, 10 ));
                  .and.;
                  !( SPEC->( Eof()))

                  DBAppend()
                  replace ID_D with DOKUM->ID
                  wa := SPEC->ILOSC * DataRW()
                  if zcenami
                     if cenyza == "T"
                        wa := Grosz( wa * TOWARY->CENA_Z )
                     else
                        wa := Grosz( wa * SPEC->CENA )
                     endif
                  endif


                  if zmroli == "T" .and. SPEC->ILOSC < 0
                     pr := wa * mn2 * -1
                     ro := wa * mn1 * -1
                  else

                     pr := wa * mn1
                     ro := wa * mn2
                  endif

                  replace PRZYCHOD with pr
                  replace ROZCHOD  with ro

                  if NRMG # 0
                     replace ILOSC_DOK with SPEC->ILOSC
                     replace CENA_DOK with SPEC->CENA
                     zeruj := .f.
                     do case
							case nrp < 0; zeruj := .f.
                     case nrp = 0; zeruj := ( DOKUM->TYP_F $ TypyKonMAG ) .and. !( Left( DOKUM->TYP, 2 ) == 'IN' )
                     case nrp = NRMG; zeruj := .f.
                     otherwise; zeruj := !( DOKUM->TYP_F $ TypyKonMAG )
                     endcase
                     if zeruj
                        replace PRZYCHOD with 0
                        replace ROZCHOD  with 0
                     endif
                  endif

                  SPEC->( DBSkip())
            enddo
         endif
         DOKUM->( DBSkip())
         if Przerwa(); exit; endif
   enddo
   Przerwa( 0 )

   DokKond2()

   go top
   IncDBES( 1 )
   while !Eof()
         IncDBES()
         skip
   enddo

   go top
   wy := 2
   Czek( 0 )

   h := h + ' "' + TOWARY->( GetPole( 1, 'it', 'INDEKS' )) + '/' + AllTrim( TOWARY->( GetPole( 1, 'it', 'NAZWA' ))) + '" w okresie ' + DtoC( data1 ) + '-' + DtoC( data2 )
*   h += 'Indeks towaru: ' + TOWARY->( GetPole( 1, 'it', 'INDEKS' ) + 'EOL'
*   h += '        nazwa: ' + TOWARY->( GetPole( 1, 'it', 'NAZWA' ) + 'EOL'
*   h += 'dokumenty przychodowe: ' + typyp
*   h += ', dokumenty rozchodowe: ' + typyr
*   h += if( zmroli == "T", hh, '' )

if zcenami
   h += ' (ceny ' + if( cenyza == "T", 'zakupu', 'transakcji' ) + ')'
endif

   DBE_Tyt := h + '|' + typyp + '|' + typyr + '|' + zmroli+ '|' + AllS( it ) + '|' + AllS( nrp )

if zcenami
   DBE_Tyt += '|' + cenyza
endif

   PutIni()
   ShowDBES( 1 )  && bez GETIni() na poczatku
   DBE_Tyt := h

endif

******************************************************************************

procedure DokAna2( a, b, h )

local tab, rr
local sil, il, il1, il2, il3, il4, il5, il6, koko
private it := 0, typy, czymz := "N", tylkoP := "T"

*if !File( 'analiza2.ntx' ); Alarm( 'Brak indeksu!' ); return; endif

b := if( b # NIL, b, '' )
typy := PadR( b, 50 )

GetIni(,,@tab)


if Len( tab ) > 0 .and. !Empty( tab[ 1 ])
   typy := PadR( tab[ 1 ], Len( typy ))
endif

if Len( tab ) > 1 .and. !Empty( tab[ 2 ])
   it := Val( tab[ 2 ])
endif


if Len( tab ) > 2 .and. !Empty( tab[ 3 ])
   czymz := tab[ 3 ]
endif

if Len( tab ) > 3 .and. !Empty( tab[ 4 ])
   tylkoP := tab[ 4 ]
endif

if Ana_Daty_B; data2 := Datee(); endif

if !NewSysForm( a ); return; endif

Czek( 1 )
DBZap('')
typy := AllTrim( typy )
tylkoP := ( tylkoP == "T" )
if MZzalezny
   DOKUM->( DBSetOrder( 8 ))    && Str( magazyn ) + DtoS( DATAS )
else
   DOKUM->( DBSetOrder( 4 ))    && Str( nabywca ) + DtoS( DATAS )
endif
SPEC->( DBSetOrder( 3 ))     && Str( dokument ) + Str( towar )

MAGAZYNY->( DBSetOrder( 2 )) && Str( ID_T ) + Str( ID ) + Str( CENA_Z )
MAGAZYNY->( DBSeek( Str( it, 10 )))
Przerwa( MAGAZYNY->( LastRec()))
while it = MAGAZYNY->ID_T .and. MAGAZYNY->( !Eof())

      ko := MAGAZYNY->ID
      if !( czymz == "T" ) .and. ko = 0; MAGAZYNY->( DBSkip()); loop; endif

      sil := 0
      while ko = MAGAZYNY->ID .and. it = MAGAZYNY->ID_T .and. MAGAZYNY->( !Eof())
            sil += MAGAZYNY->ILOSC
            rr := MAGAZYNY->( RecNo())
            if Przerwa(); return; endif
            MAGAZYNY->( DBSkip())
      enddo

      if sil # 0
         DBAppend()
         replace ID_F with ko
         if FirmaMAG( ID_F, 1 )
            replace STAN with sil
         endif
      endif

enddo
Przerwa( 0 )

*koko := { || DOKUM->( if( MZzalezny, MAGAZYN, NABYWCA ))}

store 0 to il, il1, il2, il3, il4, il5, il6

DOKUM->( DBSetOrder( 3 ))     && DtoS(DATAS)+TYP+INDEKS
DOKUM->( DBSeek( DtoS( data1 ), .t. ))
while DOKUM->( !Eof())

      if data1 <= DOKUM->DATAS;
         .and.;
         DOKUM->BLOKADA == ' ';
         .and.;
         DOKUM->DATAS <= data1 + 220;     && 220 = ( 6 + 1 ) * 30 + 10
         .and.;
         (( ','+AllTrim(DOKUM->TYP)+',') $ (','+typy+','));
         .and.;
         if( tylkoP, FirmaMAG( DOKUM->NABYWCA ), .t. )

         if !DBSeek( DOKUM->NABYWCA )
            DBAppend()
            replace ID_F with DOKUM->NABYWCA
         endif


         if DataRW() = 1

            SPEC->( DBSeek( Str( DOKUM->ID ) + Str( it, 10 )))

            while DOKUM->ID = SPEC->ID_D .and.;
                  it = SPEC->ID_T .and.;
                  SPEC->( !Eof())

                  do case
                  case IleMcy( data1, DOKUM->DATAS ) = 1
                       il1 += SPEC->ILOSC
                       il  += SPEC->ILOSC
*                       if !tylkoP
                          replace SPRZEDAZ  with SPRZEDAZ  + SPEC->ILOSC
                          replace SPRZEDAZ1 with SPRZEDAZ1 + SPEC->ILOSC
*                       endif
                  case IleMcy( data1, DOKUM->DATAS ) = 2
                       il2 += SPEC->ILOSC
                       il  += SPEC->ILOSC
*                       if !tylkoP
                          replace SPRZEDAZ  with SPRZEDAZ  + SPEC->ILOSC
                          replace SPRZEDAZ2 with SPRZEDAZ2 + SPEC->ILOSC
*                       endif
                  case IleMcy( data1, DOKUM->DATAS ) = 3

                       il3 += SPEC->ILOSC
                       il  += SPEC->ILOSC
*                       if !tylkoP
                          replace SPRZEDAZ  with SPRZEDAZ  + SPEC->ILOSC
                          replace SPRZEDAZ3 with SPRZEDAZ3 + SPEC->ILOSC
*                       endif
                  case IleMcy( data1, DOKUM->DATAS ) = 4
                       il4 += SPEC->ILOSC
                       il  += SPEC->ILOSC
*                       if !tylkoP
                          replace SPRZEDAZ  with SPRZEDAZ  + SPEC->ILOSC
                          replace SPRZEDAZ4 with SPRZEDAZ4 + SPEC->ILOSC
*                       endif
                  case IleMcy( data1, DOKUM->DATAS ) = 5
                       il5 += SPEC->ILOSC
                       il  += SPEC->ILOSC
*                       if !tylkoP
                          replace SPRZEDAZ  with SPRZEDAZ  + SPEC->ILOSC
                          replace SPRZEDAZ5 with SPRZEDAZ5 + SPEC->ILOSC
*                       endif
                  case IleMcy( data1, DOKUM->DATAS ) = 6
                       il6 += SPEC->ILOSC
                       il  += SPEC->ILOSC
*                       if !tylkoP
                          replace SPRZEDAZ  with SPRZEDAZ  + SPEC->ILOSC
                          replace SPRZEDAZ6 with SPRZEDAZ6 + SPEC->ILOSC
*                       endif
                  endcase
                  SPEC->( DBSkip())
            enddo
         endif
      endif
      DOKUM->( DBSkip())
enddo

*         if !( !( czymz == "T" ) .and. ko = 0 )
*            DBSeek( ko )                           && MAGAZYNY->ID
*            replace SPRZEDAZ  with il
*            replace SPRZEDAZ1 with il1
*            replace SPRZEDAZ2 with il2
*            replace SPRZEDAZ3 with il3
*            replace SPRZEDAZ4 with il4

*            replace SPRZEDAZ5 with il5
*            replace SPRZEDAZ6 with il6
*         endif
*         MAGAZYNY->( DBSkip())
*         if Przerwa(); exit; endif
*   enddo
*   Przerwa( 0 )

go top
IncDBES( 1 )
while !Eof()
      if SPRZEDAZ = 0 .and. STAN = 0
         BDelete()
      else
         IncDBES()
      endif
      skip
enddo


go top
wy := 2
Czek( 0 )

h := h + ' "' + AllTrim( TOWARY->( GetPole( 1, 'it', 'NAZWA' ))) + '" od daty dostawy ' + DtoC( data1 )
*   h += 'Indeks towaru: ' + TOWARY->( GetPole( 1, 'it', 'INDEKS' ) + 'EOL'
*   h += '        nazwa: ' + TOWARY->( GetPole( 1, 'it', 'NAZWA' ) + 'EOL'
*   h += 'dokumenty przychodowe: ' + typyp
*   h += ', dokumenty rozchodowe: ' + typyr
*   h += if( zmroli == "T", hh, '' )

DBE_Tyt := h + '|' + typy + '|' + AllS( it ) + '|' + czymz + '|' + if( tylkoP, "T", "N" )


PutIni()

ShowDBES( 1 )  && bez GETIni() na poczatku
DBE_Tyt := h

******************************************************************************

procedure DokAnaPz( h )

local hh, od, bb := Alias(), rr := RecNo(), odp, oodp, ip, il, up

if h = NIL
   od := 2
else
   if ( od := Alarm( h, { 'Tylko bießÜca pozycja', 'Wszystkie pozycje' })) = 0; return; endif
endif

up := .f.	&& usunπÊ pozycje ?
ip := 0
il := 0
if od = 1
   MAGAZYNY->( DBSetOrder( 1 ))  && Str(ID)+Str(ID_T)+DtoS(DATA_Z)
   MAGAZYNY->( DBSeek( Str(( bb )->ID_F ) + Str(( bb )->ID_T )))
   while MAGAZYNY->( ID = ( bb )->ID_F .and. ID_T = ( bb )->ID_T .and. !Eof())
		if MAGAZYNY->ILOSC = 0
	      MAGAZYNY->( BDelete())
		else
			ip ++
			il += MAGAZYNY->ILOSC
		endif
      MAGAZYNY->( DBSkip())
   enddo
	if ip > 1
		up := .t.
		if Alarm( 'Jest ' + AllS( ip ) + ' takich pozycji ≥πcznie na ' + AllS( il ) + ';' +;
					'zastπpiÊ je bieøπcπ pozycjπ ?', tk, 1 ) # 2
			return
		endif
	endif
	if up
	   MAGAZYNY->( DBSetOrder( 1 ))  && Str(ID)+Str(ID_T)+DtoS(DATA_Z)
   	MAGAZYNY->( DBSeek( Str(( bb )->ID_F ) + Str(( bb )->ID_T )))
	   while MAGAZYNY->( ID = ( bb )->ID_F .and. ID_T = ( bb )->ID_T .and. !Eof())
   	   MAGAZYNY->( BDelete())
	      MAGAZYNY->( DBSkip())
   	enddo
	endif
	up := .t.
endif

if od = 2
   oodp := 3   && TAAAK
   MAGAZYNY->( DBSetOrder( 1 ))  && Str(ID)+Str(ID_T)+DtoS(DATA_Z)
   MAGAZYNY->( DBSeek( Str(( bb )->ID_F )))
   while MAGAZYNY->( ID = ( bb )->ID_F .and. !Eof())
      MAGAZYNY->( BDelete())
      MAGAZYNY->( DBSkip())
   enddo    
   DBSetOrder( 0 )
   DBGoTop()
endif

MAGAZYNY->( DBSetOrder( 2 ))     && Str(ID_T)+Str(ID)+Str(CENA_Z)
while !Eof()
*   if ( bb )->ID_F = NRMG; skip; loop; endif
   if MAGAZYNY->( DBSeek( Str(( bb )->ID_T, 10 ) + Str(( bb )->ID_F, 10 ) + Str(( bb )->CENA_Z )))
      MAGAZYNY->( Blokuj_R())
      MAGAZYNY->ILOSC := ( bb )->STAN
      MAGAZYNY->( OdBlokuj_R())
	   ( bb )->( Blokuj_R())
   	( bb )->STANJEST := ( bb )->STAN
	   ( bb )->( OdBlokuj_R())
   elseif up
		if MAGAZYNY->( !DBSeek( Str(( bb )->ID_T, 10 ) + Str(( bb )->ID_F, 10 )))
         MAGAZYNY->( DBAdd())
         MAGAZYNY->ID    := ( bb )->ID_F
         MAGAZYNY->ID_T  := ( bb )->ID_T
         MAGAZYNY->CENA_Z:= ( bb )->CENA_Z
         MAGAZYNY->DATA_Z:= Datee()
		endif
      MAGAZYNY->( Blokuj_R())
  	   MAGAZYNY->ILOSC := ( bb )->STAN
     	MAGAZYNY->( OdBlokuj_R())
	   ( bb )->( Blokuj_R())
  		( bb )->STANJEST := ( bb )->STAN
		( bb )->( OdBlokuj_R())
   elseif ( bb )->STAN # 0
      hh := TOWARY->( AllTrim( GetPole( 1, 'ID_T' , 'INDEKS' )) + ' ' + AllTrim( NAZWA ))
	   if oodp # NIL
   	   odp := oodp
	   else
   	   odp := Alarm( hh + ';Nie znaleziono w magazynach;tego towaru. Dopisaç go?', { ' NIE ', 'NIEEE', ' TAK ', 'TAAAK' })
      	if odp = 2
	         odp := 1
   	      oodp := 1
      	endif
	      if odp = 4
   	      odp := 3
      	   oodp := 3
	      endif
   	endif
      if odp = 3
         MAGAZYNY->( DBAdd())
         MAGAZYNY->ID    := ( bb )->ID_F
         MAGAZYNY->ID_T  := ( bb )->ID_T
         MAGAZYNY->CENA_Z:= ( bb )->CENA_Z
         MAGAZYNY->DATA_Z:= Datee()
         MAGAZYNY->ILOSC := ( bb )->STAN
	      ( bb )->( Blokuj_R())
   	   ( bb )->STANJEST := ( bb )->STAN
      	( bb  )->( OdBlokuj_R())
      endif
   endif
   if od = 1; exit; endif
   skip
enddo

DBGo( rr )
wy := 2

******************************************************************************

procedure DokAnaP( h )

local hh, od, bb := Alias(), rr := RecNo()

if RozneCenyZ; DokAnaPz( h ); return; endif

if ( od := Alarm( h, { 'Tylko bießÜca pozycja', 'Wszystkie pozycje' })) = 0; return; endif

MAGAZYNY->( DBSetOrder( 1 ))        && Str(ID)+Str(ID_T)

if od = 2; DBGoTop(); endif
while !Eof()
   if MAGAZYNY->( DBSeek( Str(( bb )->ID_F, 10 ) + Str(( bb )->ID_T, 10 )))
      MAGAZYNY->( Blokuj_R())
      MAGAZYNY->ILOSC := ( bb )->STAN
   else
      hh := TOWARY->(AllTrim( GetPole(1,'ID_T','INDEKS')) + ' ' + AllTrim( NAZWA ))
      if Alarm( hh + ';Nie znaleziono w magazynach;tego towaru. Dopisaç go?', nt ) = 2
         MAGAZYNY->( DBAdd())
         MAGAZYNY->ID    := ( bb )->ID_F
         MAGAZYNY->ID_T  := ( bb )->ID_T
         MAGAZYNY->ILOSC := ( bb )->STAN
      endif
   endif
   if od = 1; exit; endif
   skip
enddo

DBGo( rr )
wy := 2

******************************************************************************

procedure DokAnaz( a, b, h, hh, dd )

local tab, xx, x, did, idtw, cztw, j := 0, r := 0, sc, nat, automat, bb := Alias()
local il, d1, d2, i, rr, MZMG, idt, ok, zm, rrr
private nrp := 0, inp := Space(15)

b := if( b # NIL, b, '' )

GetIni(,,@tab)

if Len( tab ) > 0 .and. !Empty( tab[ 1 ])
   nrp := Val( tab[ 1 ])
endif

if Len( tab ) > 1 .and. !Empty( tab[ 2 ])
   data2 := CtoD( tab[ 2 ])
endif

if Len( tab ) > 2 .and. !Empty( tab[ 3 ])
   data1 := CtoD( tab[ 3 ])
endif

if Ana_Daty_B; data2 := Datee(); endif

if NewSysForm( a )

   automat := ( nrp < 0 )

	if automat
		automat := .f.
		if Alarm( 'UsunπÊ ca≥π analitykÍ obrotÛw towarÛw i kontrahentÛw ?', nt, 1 ) = 2
			if Alarm( 'NA PEWNO USUN•∆ CA£• ANALITYK  ?', nt, 1 ) = 2
				Zwolnij( 'MAGAZYNY' )
				i := 0
				while .t.
						i ++
						if !File( 'KOPIA' + AllS( i ) + '\MAGAZYNY.DBF' )
							exit
						endif
				enddo
				RunCommand( 'run md KOPIA' + AllS( i ), 1 )
				RunCommand( 'run copy magazyn*.* KOPIA' + AllS( i ), 1 )
				if File( 'KOPIA' + AllS( i ) + '\magazyny.dbf' )
					Alarm( 'Kopia bezpieczeÒstwa analityki jest w podkatalogu KOPIA' + AllS( i ),, 1 )
					automat := .t.
				else
					Alarm( 'Nie uda≥o siÍ wykonaÊ kopii bezpieczeÒstwa',, 1 )
				endif
			endif
		endif
	endif

   if automat
      ON( 'MAGAZYNY',,,, .t. )
      nrp := 0
   endif

while .t.

   if automat
      FIRMY->( DBGoTop())
      nrp ++
      while !FirmaMAG( nrp, 1 ) .and. nrp < 100000; nrp ++; enddo
      FIRMY->( DBSetOrder( 1 ))
      if FIRMY->( DBSeek( nrp ))
         @ 0, 0 say FIRMY->( AllS( ID_F ) + ' ' + TYP + ' ' + AllTrim( INDEKS ) + ' ' + AllTrim( NAZWA1 ))
      else
         FIRMY->( DBGoBottom())
         if nrp > FIRMY->ID_F
            exit

         endif
      endif
   endif

   Select( bb )

   if wysdok = 'T'
      rrr := RecNo()
      idtw := ID_T
      cztw := CENA_Z
   endif

   Czek( 1 )

if wysdok = 'N'
else
*  sc := SaveScreen()
*  cls
   nat := AllTrim( TOWARY->( GetPole( 1, 'ID_T', 'INDEKS' ))) + ' ' + AllTrim( TOWARY->( GetPole( 1, 'ID_T', 'NAZWA' )))
*  @ 0, 0 say nat + '. Czekaj.'
endif

   ceny := Upper( ceny )

   ON( bb,,,, .t. )

   ON( 'MAGAZYNY' )
   if nrp >= 0; DBSeek( Str( nrp, 10 )); endif
   while if( nrp >= 0, ID = nrp, .t. ) .and. !Eof()
         if ( baza )->( !DBSeek( Str( MAGAZYNY->ID_T ) + Str( MAGAZYNY->ID ) + if( ceny == 'N', '', Str( MAGAZYNY->CENA_Z ))))
            ( baza )->( DBAppend())
            ( baza )->ID_T := MAGAZYNY->ID_T
            ( baza )->ID_F := nrp
            ( baza )->CENA_Z := MAGAZYNY->CENA_Z
         endif
         if Przerwa(); exit; endif
         DBSkip()
   enddo
   Przerwa( 0 )
   Jest_baza( bb )

   SPEC->( DBSetOrder( 1 ))     && ID_D

   MZMG := ( nrp < 0 .or. nrp = 0 .or. nrp = NRMG )

   DOKUM->( DBSetOrder( 14 ))    && DtoS(DATAS)
   DOKUM->( DBSeek( DtoS( data1 - 1 ), .t. ))  && -1 dla INW

if wysdok = 'N'
   Przerwa( DOKUM->( LastRec()))
else
	private tab1p := {}, tab1z := {}, tab1m := {}
	private tab2p := {}, tab2z := {}, tab2m := {}
	mOpen(cat_wydr+'obroty.txt')
	?? Datee(), Time(), 'Magazyn Nr', nrp
	?
	? nat
	?
endif

   while DOKUM->( !Eof())
	   if if( DOKUM->TYP == 'INW', data1 - 1 <= DOKUM->DATAS .and. DOKUM->DATAS <= data2,;
   	                            data1     <= DOKUM->DATAS .and. DOKUM->DATAS <= data2 )
         if DOKUM->BLOKADA == ' ';
         .and.;
         if( DOKUM->TYP == 'INW', nrp = DOKUM->NABYWCA,;
            if( nrp = NRMG, DOKUM->MAGAZYN = NRMG,;
               if( nrp = 0, .t., (( FirmaMAG() .and. nrp = DOKUM->NABYWCA ) .or. ( nrp = DOKUM->MAGAZYN )))));
         .and.;
         DOKTYPY->( DBSeek( DOKUM->TYP ))

			if DOKUM->TYP == 'INW' .and. inwent = 'N'
			   DOKUM->( DBSkip())
			   loop
			endif

         did := DOKUM->ID                && analityka w.c.s.
			if ceny == 'T' .and. !( DOKUM->TYP == 'INW' )
				did:=-did
	         if SPEC->( !DBSeek( did ))
					did:=-did
					SPEC->( DBSeek( did ))
				endif
			else
				SPEC->( DBSeek( did ))
			endif

         while SPEC->( ID_D = did .and. !Eof())

					cz := SPEC->CENA
					if DOKUM->TYP == 'INW'
//      		      cz := TOWARY->( GetPole( 1, 'SPEC->ID_T', 'CENA_Z' ))
					endif

               if ( baza )->( !DBSeek( Str( SPEC->ID_T ) + Str( nrp, 10 ) + if( ceny == 'N', '', Str( cz ))))
                  ( baza )->( DBAppend())
                  ( baza )->ID_T := SPEC->ID_T
                  ( baza )->ID_F := nrp
                  ( baza )->CENA_Z := cz
               endif
               ( baza )->DATAP := Min( DOKUM->DATAS, ( baza )->DATAP )
               ( baza )->DATAK := Max( DOKUM->DATAS, ( baza )->DATAK )
               mn := 0
		         if MZMG .and. ( DOKUM->NABYWCA # nrp ) .and. !( DOKUM->TYP == "INW" )
      		      if nrp = 0              && DOKUM->MAGAZYN # 0 .and. 
            		   if FirmaMAG() .and.;
		                  ( DOKTYPY->MAGAZYNG = 1 .and. DOKTYPY->MAGAZYNP = 2 ) .or.;
      		            ( DOKTYPY->MAGAZYNG = 2 .and. DOKTYPY->MAGAZYNP = 1 ) .or.;
            		      ( DOKTYPY->MAGAZYNG = 0 .and. DOKTYPY->MAGAZYNP = 0 )
		                  mn := 0
      		         else
            		      do case
		                  case DOKTYPY->MAGAZYNG = 1; mn := 1
      		            case DOKTYPY->MAGAZYNG = 2; mn :=-1
            		      case DOKTYPY->MAGAZYNG = 3; mn := 3
		                  endcase
      		         endif
		         	else
		               do case
		               case DOKTYPY->MAGAZYNG = 1; mn := 1
      		         case DOKTYPY->MAGAZYNG = 2; mn :=-1
		               case DOKTYPY->MAGAZYNG = 3; mn := 3
		               endcase
		            endif
		         else
      		      do case
            		case DOKTYPY->MAGAZYNP = 1; mn := 1
	               case DOKTYPY->MAGAZYNP = 2; mn :=-1
   	            case DOKTYPY->MAGAZYNP = 3; mn := 3
      	         endcase
		         endif
		         if mn = 3
						if wysdok = 'T' .and. idtw = SPEC->ID_T &&.and. if(ceny=='T',cztw=CENA_Z,.t.)
*						   @ r++, 0 say ''
*							j++
*							if j = 23
*								j := 0
*								? 'Wydruk = PrintScreen lub Dalej=ENTER'
*								Inkey(0)
*							   @ r, 0 say ''
*								r++
*							endif
							? DOKUM->TYP + ' ' + Left( DOKUM->INDEKS, 10 ) + ' ' + DtoC( DOKUM->DATAS ), '+', Tra( SPEC->ILOSC - ( baza )->STAN, '999,999,999?999' )
						   if ceny = 'T'
						      ?? ' / ' + Str( cz ) + ' / '
						   endif
						   ?? '==' + Tra( SPEC->ILOSC, '999,999,999?999' ), 'nowy stan' + ' ' + DOKUM->TYP_F + ' ' + DOKUM->INDEKS_F
							Wrzuc( @tab1p, @tab2p, DOKUM->TYP, SPEC->ILOSC - ( baza )->STAN )
						endif
		            ( baza )->STAN := SPEC->ILOSC
      		      ( baza )->ILEDOK   := ( baza )->ILEDOK + 1

if NRMG<>1	//Literatura, wiÍc stan na jednej z cen, a reszta zerowana

		            rr := ( baza )->( RecNo())
      		      ( baza )->( DBSeek( Str( SPEC->ID_T )))
		            while ( baza )->( ID_T = SPEC->ID_T .and. !Eof())
   		   	         if ( baza )->( RecNo()) # rr
									if ceny == 'T'
*										if SPEC->CENA = ( baza )->CENA_Z
			         		         ( baza )->STAN := 0
*										endif
									else
	         			         ( baza )->STAN := 0
									endif
	            		   endif
               		( baza )->( DBSkip())
		            enddo
endif
		         else
						if !MZMG .and. ( nrp = DOKUM->MAGAZYN ); mn := -mn; endif
	               ( baza )->STAN := ( baza )->STAN + SPEC->ILOSC * mn
   	            ( baza )->ILEDOK := ( baza )->ILEDOK   + 1
						if wysdok = 'T' .and. idtw = SPEC->ID_T .and. if(ceny=='T',cztw=CENA_Z,.t.)
*						   @ r++, 0 say ''
*							j++
*							if j = 23
*								j := 0
*								? 'Wydruk = PrintScreen lub Dalej=ENTER'
*								Inkey(0)
*								r++
*							   @ r, 0 say ''
*							endif
						   if mn = 0
								Wrzuc( @tab1z, @tab2z, DOKUM->TYP, SPEC->ILOSC )
						      ? DOKUM->TYP + ' ' + Left( DOKUM->INDEKS, 10 ) + ' ' + DtoC( DOKUM->DATAS ), if( mn = 0, ' ', '-' ), Tra( SPEC->ILOSC, '999,999,999?999' ), '='
						   else
								if mn = 1
									Wrzuc( @tab1p, @tab2p, DOKUM->TYP, SPEC->ILOSC )
								else
									Wrzuc( @tab1m, @tab2m, DOKUM->TYP, SPEC->ILOSC )
								endif
						      ? DOKUM->TYP + ' ' + Left( DOKUM->INDEKS, 10 ) + ' ' + DtoC( DOKUM->DATAS ), if( mn = 1, '+', '-' ), Tra( SPEC->ILOSC, '999,999,999?999' ), '='
						   endif
						   if ceny = 'T'
						      ?? ' / ' + Str( cz ) + ' / '
						   endif
						   ?? Tra(( baza )->STAN, '999,999,999?999' ) + ' ' + DOKUM->TYP_F + ' ' + DOKUM->INDEKS_F
						endif
		         endif

		         SPEC->( DBSkip())

            enddo
         endif
	   endif

	   DOKUM->( DBSkip())

	   if wysdok = 'N'
   	   if Przerwa(); exit; endif
	   endif

	enddo

if wysdok = 'T'
	?
	xx := 0
	for i := 1 to Len( tab1p ); xx += tab2p[ i ]; ? tab1p[ i ], '+', tab2p[ i ], xx; next
	for i := 1 to Len( tab1z );                   ? tab1z[ i ], ' ', tab2z[ i ], xx; next
	for i := 1 to Len( tab1m ); xx -= tab2m[ i ]; ? tab1m[ i ], '-', tab2m[ i ], xx; next
	mClose()
	Czek( 0 )
*	Druk(cat_wydr+'obroty.txt',1)
   RestScreen( ,,,, sc )
else
   Przerwa( 0 )
endif

if stany == 'T'            && MZMG        && usuwanie minusÛw
   Select( baza )
   Przerwa( LastRec())
   go top
   while !Eof()
   ok := .f.
   zm := .f.
   idt := ID_T
   if ( mn := ( baza )->STAN ) < 0
      mn := -mn
      rr := ( baza )->( RecNo())
      ( baza )->STAN := 0
      ( baza )->( DBSeek( Str( idt, 10 )))
      while mn > 0 .and. ( baza )->( ID_T = idt .and. !Eof())
         if ( baza )->STAN > 0
            ( baza )->STAN := ( baza )->STAN - mn
            if ( mn := ( baza )->STAN ) < 0
               mn := -mn
               ( baza )->STAN := 0
            else
               zm := .t.         && coú siÍ zmieni≥o
               mn := 0
               exit
            endif
         endif
         ( baza )->( DBSkip())
      enddo
      if mn > 0

         ok := .t.            && nie uda≥o siÍ wiÍc omiÒ
         ( baza )->( DBGoTo( rr ))
         ( baza )->STAN := ( baza )->STAN - mn
      endif
   endif
   if ok                   && omijanie
      ( baza )->( DBSeek( Str( idt, 10 )))
      while ( baza )->( ID_T = idt .and. !Eof())
         ( baza )->( DBSkip())
      enddo
   else
      ( baza )->( DBSkip())
   endif
   if zm && jeszcze raz, bo by≥a zmiana
      ( baza )->( DBSeek( Str( idt, 10 )))
   endif
   if Przerwa(); exit; endif
   enddo
   Przerwa( 0 )
endif             && MZMG        && usuwanie minusÛw

* To b≥πd ze wzglÍdu na poprawianie stanÛw wed≥ug tej analizy
*
*   MAGAZYNY->( DBSetOrder( 1 ))        && Str(ID)+Str(ID_T)
*   Select( baza ); DBGoTop()
*   Przerwa( LastRec())
*   while !Eof()
*         if ( baza )->STAN = 0 .and. ( baza )->ILEDOK = 0
*            ( baza )->( BDelete())
*         endif
*         if Przerwa(); exit; endif
*         DBSkip()
*   enddo
*   Przerwa( 0 )
*   DBPack('')

   go top
   IncDBES( 1 )
   Przerwa( LastRec())
   MAGAZYNY->( DBSetOrder( 2 ))        && Str(ID_T)+Str(ID)
   while !Eof()
      if ( nieuzy = 'N' ) .and.;
         Empty( TOWARY->( GetPole( 1, 'ID_T', 'INDEKS' )))
         BDelete()
      else
*         MAGAZYNY->( DBSeek( if( nrp = -0.1, Str(( baza )->ID_T ) + PadL("0",10), Str(( baza )->ID_T ) + Str( nrp, 10 ))))
*         ( baza )->STAN := MAGAZYNY->ILOSC
*         ( baza )->SREDNIO := ( baza )->SPRZEDAZ / IleMcy(( baza )->DATAP, ( baza )->DATAK )
         if ceny = 'N'
            ( baza )->STANJEST := GetPole(2,'Str(ANALIZAS->ID_T)+Str(ANALIZAS->ID_F)','ILOSC', 'MAGAZYNY',,,,,'Str(ID)+Str(ID_T)==Str(ANALIZAS->ID_F)+Str(ANALIZAS->ID_T)')
            ( baza )->CENA_Z := TOWARY->( GetPole( 1, 'ID_T', 'CENA_Z' ))
            ( baza )->CENA_Z := Upust(TOWARY->CENA_S, FIRMY->RABAT)
         else
            ( baza )->STANJEST := MAGAZYNY->(GetPole(2,'Str(ID_T,10)+Str(ID_F,10)+Str(CENA_Z,12,2)','ILOSC'))
         endif
         IncDBES()
      endif
         if Przerwa(); exit; endif
         skip
   enddo
   Przerwa( 0 )

   go top
   wy := 2
   Czek( 0 )

   if !automat
      exit
   else
      DokAnaPz()
   endif

enddo

if wysdok = 'T'
	Druk(cat_wydr+'obroty.txt',1)
endif

if automat
   AktMZ()
endif

Select( bb )

if rrr # NIL .and. LastRec() >= rrr; DBGoTo( rrr ); endif
if hh = NIL; hh := 'wedíug dokument¢w z okresu '; endif
if dd = NIL; dd := 0; endif

if nrp = -0.1
   h := h + ' "nieokreûlony" ' + hh + DtoC( data2 + dd ) + '-' + DtoC( data1 + dd )
else
   h := h + ' "' + AllTrim( FIRMY->( GetPole( 1, 'nrp', 'NAZWA1' ))) + '" ' + hh + DtoC( data1 + dd ) + '-' + DtoC( data2 + dd )
endif

*   h += 'Indeks towaru: ' + FIRMY->( GetPole( 1, 'nrp', 'INDEKS' ) + 'EOL'
*   h += '        nazwa: ' + FIRMY->( GetPole( 1, 'nrp', 'NAZWA' ) + 'EOL'
*   h += 'dokumenty przychodowe: ' + typyp
*   h += ', dokumenty rozchodowe: ' + typyr
*   h += if( zmroli == "T", hh, '' )
   DBE_Tyt := h + '|' + AllS( nrp ) + '|' + DtoC( data2 ) + '|' + DtoC( data1 )

   PutIni()
   ShowDBES( 1 )  && bez GETIni() na poczatku
   DBE_Tyt := h

endif

******************************************************************************

procedure DokAnas( a, b, h, hh, dd )

local tab, x, bb
local il, d1, d2, i

private nrp := 0, inp := Space(15)
private ceny := 'N', stany := 'N', nieuzy := 'N', inwent := 'T', wysdok := 'N'

if RozneCenyZ; DokAnaz( a, b, h, hh, dd ); return; endif

b := if( b # NIL, b, '' )

GetIni(,,@tab)

if Len( tab ) > 0 .and. !Empty( tab[ 1 ])
   nrp := Val( tab[ 1 ])
endif

if Len( tab ) > 1 .and. !Empty( tab[ 2 ])
   data2 := CtoD( tab[ 2 ])
endif

if Ana_Daty_B; data2 := Datee(); endif

if NewSysForm( a )

   Czek( 1 )


   DBSetOrder( 1 )

   DBZap('')

   if Empty( inp ) .or. nrp < 0; nrp := 0; endif

   bb := Alias()
   ON( 'TOWARY' )
   while !Eof()
         ( baza )->( DBAppend())
         ( baza )->ID_T := TOWARY->ID
         ( baza )->ID_F := nrp
         if Przerwa(); exit; endif
         DBSkip()
   enddo
   Przerwa( 0 )
   Jest_baza( bb )

   SPEC->( DBSetOrder( 1 ))     && ID_D

*   DOKUM->( DBSetOrder( 0 ))    && wszystko z powodu braku chronologii
*   DOKUM->( DBGoTop())

   if nrp = 0
      DOKUM->( DBSetOrder( 3 ))    && DtoS(DATAS)+TYP+INDEKS

      DOKUM->( DBGoTop())
   else
      DOKUM->( DBSetOrder( 4 ))    && Str(NABYWCA)+DtoS(DATAS)
      DOKUM->( DBSeek( Str( nrp, 10 )))


   endif
   Przerwa( DOKUM->( LastRec()))
*   while DOKUM->( !Eof())
   while DOKUM->DATAS <= data2 .and. if( nrp = 0, .t., DOKUM->NABYWCA = nrp ) .and. DOKUM->( !Eof())
         if DOKTYPY->( DBSeek( DOKUM->TYP ))
            SPEC->( DBSeek( DOKUM->ID ))
            while SPEC->( ID_D = DOKUM->ID .and. !Eof())

               if ( baza )->( DBSeek( SPEC->ID_T ))
*                  ( baza )->( DBAppend())
*                  ( baza )->ID_T := SPEC->ID_T
*                  ( baza )->DATAP := DOKUM->DATAS
*                  ( baza )->DATAK := DOKUM->DATAS
*               endif
               ( baza )->DATAP := Min( DOKUM->DATAS, ( baza )->DATAP )
               ( baza )->DATAK := Max( DOKUM->DATAS, ( baza )->DATAK )
               if DataRW() = 1
                  mn := 0
                  if nrp = 0 .and. DOKUM->NABYWCA # 0
                     do case
                        case DOKTYPY->MAGAZYNG = 1; mn := 1
                        case DOKTYPY->MAGAZYNG = 2; mn :=-1
                        case DOKTYPY->MAGAZYNG = 3; mn := 3
                     endcase
                  elseif FirmaMAG( nrp )
                     do case
                        case DOKTYPY->MAGAZYNP = 1; mn := 1
                        case DOKTYPY->MAGAZYNP = 2; mn :=-1
                        case DOKTYPY->MAGAZYNP = 3; mn := 3
                     endcase
                  endif
                  ( baza )->STAN     := if( mn = 3, SPEC->ILOSC, ( baza )->STAN + SPEC->ILOSC * mn )
                  ( baza )->ILEDOK   := ( baza )->ILEDOK   + 1
               endif
               endif
               SPEC->( DBSkip())
            enddo
         endif
         DOKUM->( DBSkip())
         if Przerwa(); exit; endif
   enddo
   Przerwa( 0 )

   MAGAZYNY->( DBSetOrder( 1 ))        && Str(ID)+Str(ID_T)
   Select( baza ); DBGoTop()

   Przerwa( LastRec())
   while !Eof()
         if ( baza )->STAN = 0;
            .and.;
            ( baza )->ILEDOK = 0;
            .and.;
            !MAGAZYNY->( DBSeek( Str( nrp, 10 ) + Str(( baza )->ID_T, 10 )))
            
            ( baza )->( BDelete())

         endif
         if Przerwa(); exit; endif
         DBSkip()
   enddo
   Przerwa( 0 )

   DBPack('')
   go top
   IncDBES( 1 )
   Przerwa( LastRec())
   MAGAZYNY->( DBSetOrder( 2 ))        && Str(ID_T)+Str(ID)
   while !Eof()
*         MAGAZYNY->( DBSeek( if( nrp = -0.1, Str(( baza )->ID_T ) + PadL("0",10), Str(( baza )->ID_T ) + Str( nrp, 10 ))))
*         ( baza )->STAN := MAGAZYNY->ILOSC
*         ( baza )->SREDNIO := ( baza )->SPRZEDAZ / IleMcy(( baza )->DATAP, ( baza )->DATAK )
         IncDBES()
         if Przerwa(); exit; endif
         skip
   enddo
   Przerwa( 0 )

   go top
   wy := 2
   Czek( 0 )

if hh = NIL; hh := 'po obrotach dnia '; endif
if dd = NIL; dd := 0; endif

if nrp = -0.1
   h := h + ' "nieokreûlony" ' + hh + DtoC( data2 + dd )

else
   h := h + ' "' + AllTrim( FIRMY->( GetPole( 1, 'nrp', 'NAZWA1' ))) + '" ' + hh + DtoC( data2 + dd )
endif

*   h += 'Indeks towaru: ' + FIRMY->( GetPole( 1, 'nrp', 'INDEKS' ) + 'EOL'
*   h += '        nazwa: ' + FIRMY->( GetPole( 1, 'nrp', 'NAZWA' ) + 'EOL'
*   h += 'dokumenty przychodowe: ' + typyp
*   h += ', dokumenty rozchodowe: ' + typyr

*   h += if( zmroli == "T", hh, '' )
   DBE_Tyt := h + '|' + AllS( nrp ) + '|' + DtoC( data2 )

   PutIni()
   ShowDBES( 1 )  && bez GETIni() na poczatku
   DBE_Tyt := h

endif

******************************************************************************

procedure DokAnaa( a, b, h )

local tab, x, r
local il, d1, d2, i
private nrp := 0, inp := Space(15), typy, ciasno := "T"

b := if( b # NIL, b, '' )
typy := PadR( b, 50 )

GetIni(,,@tab)

if Len( tab ) > 0 .and. !Empty( tab[ 1 ])
   typy := PadR( tab[ 1 ], Len( typy ))
endif

if Len( tab ) > 1 .and. !Empty( tab[ 2 ])
   nrp := Val( tab[ 2 ])
endif

if Len( tab ) > 2 .and. !Empty( tab[ 3 ])
   ciasno := tab[ 3 ]
endif

if Ana_Daty_B; data2 := Datee(); endif

if NewSysForm( a )
   Czek( 1 )
   DBZap('')
   typy := AllTrim( typy )
   SPEC->( DBSetOrder( 1 ))     && ID_D
   if Empty( inp )
      nrp := -0.1
      DOKUM->( DBSetOrder( 3 ))    && DtoS(DATAS)+TYP+INDEKS
      DOKUM->( DBSeek( DtoS( data1 )))
   else
      DOKUM->( DBSetOrder( 4 ))    && Str(NABYWCA)+DtoS(DATAS)
      DOKUM->( DBSeek( Str( nrp, 10 )))
   endif
   Przerwa( DOKUM->( LastRec()))
   while DOKUM->DATAS <= data2 .and. if( nrp = -0.1, .t., DOKUM->NABYWCA = nrp ) .and. DOKUM->( !Eof())
         if data1 <= DOKUM->DATAS .and. DOKUM->DATAS<= data2 .and.;
                  DOKUM->BLOKADA == ' ' .and.;
                  (( ','+AllTrim(DOKUM->TYP)+',') $ (','+typy+','))
            SPEC->( DBSeek( DOKUM->ID ))
            while SPEC->( ID_D = DOKUM->ID .and. !Eof())
               if ( baza )->( !DBSeek( SPEC->ID_T ))
                  ( baza )->( DBAppend())
                  ( baza )->ID_T := SPEC->ID_T
                  if ciasno == 'T'

                     ( baza )->DATAP := DOKUM->DATAS
                     ( baza )->DATAK := DOKUM->DATAS
                  else
                     ( baza )->DATAP := data1
                     ( baza )->DATAK := data2
                  endif
               endif
               if ciasno == 'T'
                  ( baza )->DATAP := Min( DOKUM->DATAS, ( baza )->DATAP )
                  ( baza )->DATAK := Max( DOKUM->DATAS, ( baza )->DATAK )
               endif
               if DataRW() = 1
                  ( baza )->SPRZEDAZ := ( baza )->SPRZEDAZ + SPEC->ILOSC
                  ( baza )->ILEDOK   := ( baza )->ILEDOK   + 1
               endif
               SPEC->( DBSkip())
            enddo
         endif
         DOKUM->( DBSkip())
         if Przerwa(); exit; endif
   enddo
   Przerwa( 0 )

   MAGAZYNY->( DBSetOrder( 1 ))        && Str(ID)+Str(ID_T)
   MAGAZYNY->( DBSeek( if( nrp = -0.1, Str( 0, 10 ), Str( nrp, 10 ))))
   MAGAZYNY->( Przerwa( LastRec()))
   while MAGAZYNY->( if( nrp = -0.1, .t., ID = nrp ) .and. !Eof())
         if !DBSeek( MAGAZYNY->ID_T )
            ( baza )->( DBAppend())
            ( baza )->ID_T := MAGAZYNY->ID_T
         endif
         if Przerwa(); exit; endif
         MAGAZYNY->( DBSkip())
   enddo
   Przerwa( 0 )

   go top
   IncDBES( 1 )
   Przerwa( LastRec())
   MAGAZYNY->( DBSetOrder( 2 ))        && Str(ID_T)+Str(ID)
   while !Eof()
         il := 0
         if MAGAZYNY->( DBSeek( if( nrp < 0, Str(( baza )->ID_T ) + Str( 0, 10 ), Str(( baza )->ID_T ) + Str( nrp, 10 ))))
            x := MAGAZYNY->ID
            while MAGAZYNY->(( baza )->ID_T = ID_T .and. x = ID .and. !Eof())
                  il += MAGAZYNY->ILOSC
                  MAGAZYNY->( DBSkip())
            enddo
         endif
         ( baza )->STAN := il
         ( baza )->SREDNIO := ( baza )->SPRZEDAZ / IleMcy(( baza )->DATAP, ( baza )->DATAK )
      r := MAGAZYNY->( RecNo())
         IncDBES()
      MAGAZYNY->( DBSetOrder( 2 ))
      MAGAZYNY->( DBGoTo( r ))
         if Przerwa(); exit; endif
         skip
   enddo
   Przerwa( 0 )

   go top
   wy := 2
   Czek( 0 )

if nrp = -0.1
   h := h + ' "nieokreûlony" w okresie ' + DtoC( data1 ) + '-' + DtoC( data2 )
else
   h := h + ' "' + AllTrim( FIRMY->( GetPole( 1, 'nrp', 'NAZWA1' ))) + '" w okresie ' + DtoC( data1 ) + '-' + DtoC( data2 )
endif
*   h += 'Indeks towaru: ' + FIRMY->( GetPole( 1, 'nrp', 'INDEKS' ) + 'EOL'
*   h += '        nazwa: ' + FIRMY->( GetPole( 1, 'nrp', 'NAZWA' ) + 'EOL'
*   h += 'dokumenty przychodowe: ' + typyp
*   h += ', dokumenty rozchodowe: ' + typyr
*   h += if( zmroli == "T", hh, '' )
   DBE_Tyt := h + '|' + typy + '|' + AllS( nrp ) + '|' + ciasno 


   PutIni()
   ShowDBES( 1 )  && bez GETIni() na poczatku
   DBE_Tyt := h

endif

******************************************************************************

procedure DokAna111( t, d1, d2, dd )

local bb := Alias(), wy := 0, bDBE_Tyt := DBE_Tyt

if dd = NIL; dd := 'FV,RU,FVK,RUK'; endif

private baza := 'ANALIZA1'
ON( baza )
wy := DokAna11( baza, dd, 'Sprzedaß ûrednia towaru', t, d1, d2 )

Select( bb )

DBE_Tyt := bDBE_Tyt

return wy

******************************************************************************

procedure DokAna1s( a, b, h, t, dd1, dd2, hh, dd )

local tab, x
local il, d1, d2, i, mn
private it := 0, typy, ciasno := "T", czymz := "N"

b := if( b # NIL, b, '' )
typy := PadR( b, 50 )

GetIni(,,@tab)

if Len( tab ) > 0 .and. !Empty( tab[ 1 ])
   typy := PadR( tab[ 1 ], Len( typy ))
endif

if Len( tab ) > 1 .and. !Empty( tab[ 2 ])
   it := Val( tab[ 2 ])
endif


if Len( tab ) > 2 .and. !Empty( tab[ 3 ])
   ciasno := tab[ 3 ]
endif

if Len( tab ) > 3 .and. !Empty( tab[ 4 ])
   czymz := tab[ 4 ]
endif

il := 0

if Ana_Daty_B; data2 := Datee(); endif

if t # NIL .or. NewSysForm( a )
   if t # NIL
      it := t
      typy := b
      data1 := dd1
      data2 := dd2
   endif
   Czek( 1 )
   DBZap('')

   typy := AllTrim( typy )
   MAGAZYNY->( DBSetOrder( 2 )) && Str(ID_T)+Str(ID)
   DOKUM->( DBSetOrder( 1 ))    && ID
   SPEC->( DBSetOrder( 2 ))     && ID_T
   SPEC->( DBSeek( it ))
   Przerwa( SPEC->( LastRec()))
   while SPEC->ID_T = it .and. SPEC->( !Eof())
      if DOKUM->( DBSeek( SPEC->ID_D ))
         if DOKUM->NABYWCA # 0 .and. DOKUM->DATAS <= data2 .and. DOKTYPY->( DBSeek( DOKUM->TYP ))
            if ( baza )->( !DBSeek( DOKUM->NABYWCA ))
               ( baza )->( DBAppend())
               ( baza )->ID_F := DOKUM->NABYWCA
               ( baza )->ID_T := it
               ( baza )->DATAP := DOKUM->DATAS
               ( baza )->DATAK := DOKUM->DATAS
            endif
            ( baza )->DATAP := Min( DOKUM->DATAS, ( baza )->DATAP )
            ( baza )->DATAK := Max( DOKUM->DATAS, ( baza )->DATAK )
            if DataRW() = 1
               mn := 0
               if FirmaMAG( DOKUM->NABYWCA )
                  do case
                     case DOKTYPY->MAGAZYNP = 1; mn := 1
                     case DOKTYPY->MAGAZYNP = 2; mn :=-1

                     case DOKTYPY->MAGAZYNP = 3; mn := 3
                  endcase
               endif
               ( baza )->STAN     := if( mn = 3, SPEC->ILOSC, ( baza )->STAN + SPEC->ILOSC * mn )
               ( baza )->ILEDOK   := ( baza )->ILEDOK   + 1
            endif
         endif
      endif
      if Przerwa(); exit; endif

      SPEC->( DBSkip())
   enddo
   Przerwa( 0 )

   MAGAZYNY->( DBSeek( Str( it )))                     && Str(ID_T)+Str(ID)
   Przerwa( MAGAZYNY->( LastRec()))
   while MAGAZYNY->ID_T = it .and. MAGAZYNY->( !Eof())
         if !( czymz == "T" ) .and. MAGAZYNY->ID = 0
            MAGAZYNY->( DBSkip())
            loop
         endif
         if ( baza )->( !DBSeek( MAGAZYNY->ID ))
            ( baza )->( DBAppend())
            ( baza )->ID_F := MAGAZYNY->ID
            ( baza )->ID_T := it
         endif
         if Przerwa(); exit; endif
         MAGAZYNY->( DBSkip())
   enddo

   Przerwa( 0 )

   go top
   IncDBES( 1 )

   Przerwa( LastRec())
   while !Eof()
         if t = NIL; IncDBES(); endif
         if Przerwa(); exit; endif
         skip
   enddo
   Przerwa( 0 )


   go top
   wy := 2
   Czek( 0 )

if hh = NIL; hh := 'po obrotach dnia '; endif
if dd = NIL; dd := 0; endif

   h := h + ' "' + AllTrim( TOWARY->( GetPole( 1, 'it', 'NAZWA' ))) + '" ' + hh + DtoC( data2 + dd )
*   h += 'Indeks towaru: ' + TOWARY->( GetPole( 1, 'it', 'INDEKS' ) + 'EOL'
*   h += '        nazwa: ' + TOWARY->( GetPole( 1, 'it', 'NAZWA' ) + 'EOL'
*   h += 'dokumenty przychodowe: ' + typyp
*   h += ', dokumenty rozchodowe: ' + typyr
*   h += if( zmroli == "T", hh, '' )
   DBE_Tyt := h + '|' + typy + '|' + AllS( it ) + '|' + ciasno + '|' + czymz

   PutIni()
   if t = NIL; ShowDBES( 1 ); endif  && bez GETIni() na poczatku
   DBE_Tyt := h

endif

return il

******************************************************************************

procedure DokAna11( a, b, h, t, dd1, dd2 )

local tab, x
local il, d1, d2, i
private it := 0, typy, ciasno := "T", czymz := "N", czytpm := 'N'

b := if( b # NIL, b, '' )
typy := PadR( b, 50 )


GetIni(,,@tab)

if Len( tab ) > 0 .and. !Empty( tab[ 1 ])
   typy := PadR( tab[ 1 ], Len( typy ))
endif

if Len( tab ) > 1 .and. !Empty( tab[ 2 ])
   it := Val( tab[ 2 ])

endif

if Len( tab ) > 2 .and. !Empty( tab[ 3 ])
   ciasno := tab[ 3 ]
endif

if Len( tab ) > 3 .and. !Empty( tab[ 4 ])
   czymz := tab[ 4 ]
endif

il := 0

if Ana_Daty_B; data2 := Datee(); endif

if t # NIL .or. NewSysForm( a )
   if t # NIL
      it := t
      typy := b
      data1 := dd1
      data2 := dd2
   endif
   Czek( 1 )
   DBZap('')
   typy := AllTrim( typy )
   MAGAZYNY->( DBSetOrder( 2 )) && Str(ID_T)+Str(ID)
   DOKUM->( DBSetOrder( 1 ))    && ID
   SPEC->( DBSetOrder( 2 ))     && ID_T
   SPEC->( DBSeek( it ))
   Przerwa( SPEC->( LastRec()))
   while SPEC->ID_T = it .and. SPEC->( !Eof())
      if DOKUM->( DBSeek( SPEC->ID_D )) .and. DOKUM->BLOKADA == ' '
         if data1 <= DOKUM->DATAS .and. DOKUM->DATAS<= data2 .and.;
                  (( ','+AllTrim(DOKUM->TYP)+',') $ (','+typy+','))
            if ( baza )->( !DBSeek( DOKUM->NABYWCA ))
               ( baza )->( DBAppend())

               ( baza )->ID_F := DOKUM->NABYWCA
               if ciasno == 'T'
                  ( baza )->DATAP := DOKUM->DATAS
                  ( baza )->DATAK := DOKUM->DATAS
               else
                  ( baza )->DATAP := data1

                  ( baza )->DATAK := data2
               endif
            endif
            if ciasno == 'T'
               ( baza )->DATAP := Min( DOKUM->DATAS, ( baza )->DATAP )
               ( baza )->DATAK := Max( DOKUM->DATAS, ( baza )->DATAK )
            endif
            if DataRW() = 1
               ( baza )->SPRZEDAZW:= ( baza )->SPRZEDAZW+ Grosz( SPEC->( ILOSC * CENA ))
               ( baza )->SPRZEDAZ := ( baza )->SPRZEDAZ + SPEC->ILOSC
               ( baza )->ILEDOK   := ( baza )->ILEDOK   + 1
            endif
         endif
      endif
      if Przerwa(); exit; endif
      SPEC->( DBSkip())

   enddo

   Przerwa( 0 )


   MAGAZYNY->( DBSeek( Str( it )))                     && Str(ID_T)+Str(ID)
   Przerwa( MAGAZYNY->( LastRec()))
   while MAGAZYNY->ID_T = it .and. MAGAZYNY->( !Eof())
         if !( czymz == "T" ) .and. MAGAZYNY->ID = 0
            MAGAZYNY->( DBSkip())
            loop
         endif

         if ( baza )->( !DBSeek( MAGAZYNY->ID ))
            ( baza )->( DBAppend())
            ( baza )->ID_F := MAGAZYNY->ID
         endif
if FirmaMAG( MAGAZYNY->ID, 1 )
         ( baza )->STAN += MAGAZYNY->ILOSC
endif
         if Przerwa(); exit; endif
         MAGAZYNY->( DBSkip())
   enddo
   Przerwa( 0 )

   il := 0
   go top
   IncDBES( 1 )
   Przerwa( LastRec())
   while !Eof()
      if czytpm == 'T' .and. !FirmaMAG(( baza )->ID_F, 1 )
         BDelete()
      else
         ( baza )->SREDNIO := ( baza )->SPRZEDAZ / IleMcy(( baza )->DATAP, ( baza )->DATAK )
         if t = NIL; IncDBES(); endif
         if Przerwa(); exit; endif
         il += ( baza )->SPRZEDAZ
      endif
      skip
   enddo
   Przerwa( 0 )

   go top
   wy := 2
   Czek( 0 )

   h := h + ' "' + AllTrim( TOWARY->( GetPole( 1, 'it', 'NAZWA' ))) + '" w okresie ' + DtoC( data1 ) + '-' + DtoC( data2 )
*   h += 'Indeks towaru: ' + TOWARY->( GetPole( 1, 'it', 'INDEKS' ) + 'EOL'
*   h += '        nazwa: ' + TOWARY->( GetPole( 1, 'it', 'NAZWA' ) + 'EOL'
*   h += 'dokumenty przychodowe: ' + typyp
*   h += ', dokumenty rozchodowe: ' + typyr
*   h += if( zmroli == "T", hh, '' )
   DBE_Tyt := h + '|' + typy + '|' + AllS( it ) + '|' + ciasno + '|' + czymz

   PutIni()

   if t = NIL; ShowDBES( 1 ); endif  && bez GETIni() na poczatku
   DBE_Tyt := h

endif

return il

******************************************************************************

procedure DokAna1( a, b, h )

local tab, x
local il, d1, d2, i
private it := 0, typy, ciasno := "T"

b := if( b # NIL, b, '' )
typy := PadR( b, 50 )

GetIni(,,@tab)

if Len( tab ) > 0 .and. !Empty( tab[ 1 ])
   typy := PadR( tab[ 1 ], Len( typy ))
endif

if Len( tab ) > 1 .and. !Empty( tab[ 2 ])

   it := Val( tab[ 2 ])

endif


if Len( tab ) > 2 .and. !Empty( tab[ 3 ])
   ciasno := tab[ 3 ]

endif



if Ana_Daty_B; data2 := Datee(); endif

if NewSysForm( a )
   Czek( 1 )
   DBZap('')

   typy := AllTrim( typy )
   DOKUM->( DBSetOrder( 4 ))    && Str( nabywca ) + DtoS( DATAS )
   SPEC->( DBSetOrder( 3 ))     && Str( dokument ) + Str( towar )
   MAGAZYNY->( DBSetOrder( 2 ))
   MAGAZYNY->( DBSeek( Str( it, 10 )))
   Przerwa( MAGAZYNY->( LastRec()))
   while it = MAGAZYNY->ID_T .and. MAGAZYNY->( !Eof())
         DBAppend()
         x := MAGAZYNY->ID
         replace ID_F with x





if FirmaMAG( x, 1 )
         replace STAN with MAGAZYNY->ILOSC
endif

         il := 0

         if ciasno == 'T'
            d1 := NIL
            d2 := DATAK
         else
            d1 := data1
            d2 := data2
         endif

         i := 0
         DOKUM->( DBSeek( Str( x, 10 )))
         while DOKUM->NABYWCA = ID_F .and. DOKUM->( !Eof())
               if data1 <= DOKUM->DATAS .and. DOKUM->DATAS<= data2 .and.;
                  (( ','+AllTrim(DOKUM->TYP)+',') $ (','+typy+','))
                  SPEC->( DBSeek( Str( DOKUM->ID, 10 ) + Str( it, 10 )))
                  while DOKUM->ID = SPEC->ID_D .and.;
                        it = SPEC->ID_T .and.;
                        SPEC->( !Eof())
                        if DataRW() = 1
                           i ++
                           il += SPEC->ILOSC
                        endif
                        if ciasno == 'T'
                           d1 := if( d1 = NIL, DOKUM->DATAS, d1 )
                           d2 := Max( d2, DOKUM->DATAS )
                        endif
                        SPEC->( DBSkip())
                  enddo
               endif
               DOKUM->( DBSkip())
         enddo
         replace SPRZEDAZ with il
         replace SREDNIO with il/IleMcy( d1, d2 )
         replace ILEDOK with i
if d1 # NIL; replace DATAP with d1; endif
if d2 # NIL; replace DATAK with d2; endif
         MAGAZYNY->( DBSkip())
         if Przerwa(); exit; endif
   enddo


   Przerwa( 0 )


   go top
   IncDBES( 1 )

   while !Eof()
         IncDBES()
         skip
   enddo

   go top
   wy := 2
   Czek( 0 )

   h := h + ' "' + AllTrim( TOWARY->( GetPole( 1, 'it', 'NAZWA' ))) + '" w okresie ' + DtoC( data1 ) + '-' + DtoC( data2 )
*   h += 'Indeks towaru: ' + TOWARY->( GetPole( 1, 'it', 'INDEKS' ) + 'EOL'
*   h += '        nazwa: ' + TOWARY->( GetPole( 1, 'it', 'NAZWA' ) + 'EOL'
*   h += 'dokumenty przychodowe: ' + typyp
*   h += ', dokumenty rozchodowe: ' + typyr
*   h += if( zmroli == "T", hh, '' )

   DBE_Tyt := h + '|' + typy + '|' + AllS( it ) + '|' + ciasno

   PutIni()
   ShowDBES( 1 )  && bez GETIni() na poczatku
   DBE_Tyt := h

endif

******************************************************************************
* cz = NIL, ID_D > 0 = main spec
* cz # NIL, ID_D < 0 = mirror spec
* idf - identyfikator podmagazynu

function DokFor( cz )

local idf, typ

if cz # NIL .and. cz = -99
   cz := NIL
   idf := FIRMY->ID_F
else
   idf := MAGAZYNY->ID
endif

typ := DOKUM->( GetPole( 1, 'ID_D', 'TYP' )) 
if typ == 'KOR' .or. typ == 'PWC' .or. typ == 'RWC' 
   return .f.
endif

if MZzalezny
   return if( cz = NIL, ID_D > 0,  ID_D < 0 .and. if( cz = 0, .t., CENA = cz ));
       .and.;
          if( idf = 0, .t.,;
              idf = DOKUM->( GetPole( 1, 'ID_D', 'NABYWCA' ));
              .or.;
              idf = DOKUM->( GetPole( 1, 'ID_D', 'MAGAZYN' )))
else
   return if( cz = NIL, ID_D > 0,  ID_D < 0 .and. if( cz = 0, .t., CENA = cz ));
       .and.;
          if( idf = 0, .t.,;
              idf = DOKUM->( GetPole( 1, 'ID_D', 'NABYWCA' )))
endif

******************************************************************************

procedure DokDokInwent( k, b, s, x )

local i, n, dt

if !File( k + b + '.dbf' ); return; endif

use ( k + b ) new
dt := Datee() + 100
n := ' '
while !Eof()

      if !( Datee() = dt )
         if !Empty( n ); DokClose(); endif   && pierwszy raz nie robi
         dt := Datee()
         n := b+'/'+DtoS( dt )
         DokDokum( s, AllTrim( n ), dt, 0 )
      endif

      if !TOWARY->( DBSeek( Upper(( b )->INDEKS )))
         TOWARY->( DBAppend())
         TOWARY->ID := TOWARY->( GetLast( 1, 1 ) + 1 )
         TOWARY->INDEKS := ( b )->INDEKS
         TOWARY->NAZWA  := ( b )->NAZWA
         TOWARY->VAT    := ( b )->VVAT
         TOWARY->SWW    := ( b )->SWW
      endif

      if x = 0 .and. ( b )->CENA_ZAK # 0
         TOWARY->CENA_Z := ( b )->CENA_ZAK
      endif

      if x = 0 .and. ( b )->CENA_SPRZ # 0
         TOWARY->CENA_S := ( b )->CENA_SPRZ
      endif

      SPEC->( DBAppend())
      SPEC->ID_D := DOKUM->ID
      SPEC->ID_T := TOWARY->ID
      SPEC->CENA:= ( b )->CENA_ZAK
      SPEC->ILOSC:= ( b )->ILOSC

      DOKUM->WARTOSC += Grosz( ILOSC * ( b )->CENA_ZAK )
      DOKUM->NETTO0  += Grosz( ILOSC * ( b )->CENA_ZAK )

      skip
enddo


if !Empty( n ); DokClose(); endif   && ostatni robi

Zwolnij( b )

******************************************************************************

procedure DokDokInw( k, b, s )

local i, n, dt

if !File( k + b + '.dbf' ); return; endif

use ( k + b ) new
dt := DATA + 100
n := ' '
while !Eof()

      if !( DATA = dt )
         if !Empty( n ); DokClose(); endif   && pierwszy raz nie robi
         dt := DATA
         n := DtoS( dt )+'/'+b
         DokDokum( s, AllTrim( n ), dt, 0 )
      endif

      if !TOWARY->( DBSeek( Upper(( b )->INDEKS )))
         TOWARY->( DBAppend())
         TOWARY->ID := TOWARY->( GetLast( 1, 1 ) + 1 )
         TOWARY->INDEKS := ( b )->INDEKS
         TOWARY->NAZWA  := ( b )->NAZWA
         TOWARY->VAT    := 0
         TOWARY->SWW    := '2712-1'

      endif

      SPEC->( DBAppend())
      SPEC->ID_D := DOKUM->ID
      SPEC->ID_T := TOWARY->ID

      SPEC->ILOSC:= ( b )->ILOSC

      skip
enddo

if !Empty( n ); DokClose(); endif   && ostatni robi

Zwolnij( b )

******************************************************************************

procedure DokDokTow( k, b )

local n, dt

if !File( k + b + '.dbf' ); return; endif

use ( k + b ) new
w := 0
n := ' '
while !Eof()

      if !( NR_FAKTURY == n )
         if !Empty( n ); DokClose(); endif   && pierwszy raz nie robi
         n := NR_FAKTURY
         dt := DATA
         if Year( dt ) < 1996
            dt := Get_U( 10, 10, 'Podaj prawidíowÜ datë:', '@S8', dt )
         endif
         DokDokum( Upper( Left( b, 2 )), AllTrim( n ), dt, 0 )

      endif

      if !TOWARY->( DBSeek( Upper(( b )->INDEKS )))
         TOWARY->( DBAppend())
         TOWARY->ID := TOWARY->( GetLast( 1, 1 ) + 1 )
         TOWARY->INDEKS := ( b )->INDEKS
         TOWARY->NAZWA  := ( b )->NAZWA
         TOWARY->CENA_Z := ( b )->CENA
         TOWARY->CENA_S := ( b )->CENA
         TOWARY->VAT    := 0
         TOWARY->JM     := ( b )->MIARA
         TOWARY->SWW    := '2712-1'
      endif

      if TOWARY->CENA_Z = 0 .and. ( b )->CENA # 0
         TOWARY->CENA_Z := ( b )->CENA
      endif

      TOWARY->CENA_S := Max(( b )->CENA, TOWARY->CENA_S )

      SPEC->( DBAppend())
      SPEC->ID_D := DOKUM->ID
      SPEC->ID_T := TOWARY->ID
      SPEC->CENA := ( b )->CENA
      SPEC->ILOSC:= ( b )->ILOSC

*      DOKUM->DATAW := ( b )->DATA

*      DOKUM->DATAS := ( b )->DATA

*      DOKUM->DATAO := ( b )->DATA
*      DOKUM->DATAT := ( b )->DATA

      DOKUM->WARTOSC += Grosz( ILOSC * ( b )->CENA )
      DOKUM->NETTO0  += Grosz( ILOSC * ( b )->CENA )


      skip

enddo

if !Empty( n ); DokClose(); endif   && ostatni robi

Zwolnij( b )

******************************************************************************

procedure DokTowar( b, c, z, y )

local mn

      ( b )->( DBSeek( c ))
      while ( b )->NR_FAKTURY == c .and. !( b )->( Eof())

            mn := if( y = NIL .or. Upper( Left(( b )->KTORA, 1 )) $ TypyKonMAG, 1, -1 )

            if !TOWARY->( DBSeek(Upper(( b )->INDEKS )))
               TOWARY->( DBAppend())
               TOWARY->ID := TOWARY->( GetLast( 1, 1 ) + 1 )
               TOWARY->INDEKS := ( b )->INDEKS
               TOWARY->NAZWA  := ( b )->NAZWA

               TOWARY->VAT    := ( b )->VVAT


               if z = NIL
                  TOWARY->CENA_Z := ( b )->CENA_ZAK
                  TOWARY->CENA_S := ( b )->CENA
               else
                  TOWARY->CENA_Z := ( b )->CENA
               endif
               TOWARY->JM     := ( b )->MIARA
               TOWARY->SWW    := ( b )->SWW
            endif



            TOWARY->CENA_S := Max(( b )->CENA, TOWARY->CENA_S )

            SPEC->( DBAppend())
            SPEC->ID_D := DOKUM->ID
            SPEC->ID_T := TOWARY->ID
            if z = NIL
               SPEC->CENA := ( b )->CENA
            else
               SPEC->CENA := TOWARY->CENA_Z
            endif

            SPEC->ILOSC:= ( b )->ILOSC * mn


            if y # NIL
               DOKUM->DATAW := ( b )->DATA
*               DOKUM->DATAS := ( b )->DATA_SP
               DOKUM->DATAO := ( b )->DATA_SP
               DOKUM->SPOSOB:= ( b )->FORMA_PL
               DOKUM->NUMERFD:=LTrim(( b )->NR_FS )
               DOKUM->UWAGI := ( b )->TYTUL_ZMN
            elseif z = NIL
               DOKUM->DATAW := ( b )->DATA_WYST
               DOKUM->DATAS := ( b )->DATA_SP
               DOKUM->DATAT := ( b )->TERMINP
               DOKUM->WPLACONO := ( b )->KWOTAP
               DOKUM->SPOSOB := ( b )->FORMA_PLT
            else
               DOKUM->DATAW := ( b )->DATA_WYST
               DOKUM->DATAO := ( b )->DATA_PZ
               DOKUM->DATAT := ( b )->TERMIN_PL
               DOKUM->NUMERFD := ( b )->NR_FZ
               DOKUM->WPLACONO := ( b )->KWOTAP
            endif

            ( b )->( DBSkip())
      enddo

******************************************************************************

procedure DokFirmy( n, a, o, t, e, b )


local x := n

      if !Empty( a )
         if Empty( x ) .or. !FIRMY->( DBSeek( x ))
            if Empty( x )
               x := a
               FIRMY->( DBSetOrder( 4 ))
               if !FIRMY->( DBSeek( x ))

                  FIRMY->( DBAppend())

                  FIRMY->ID_F := FIRMY->(GetLast(1,1)+1)
                  FIRMY->TYP := t
                  FIRMY->NAZWA1 := o
                  DokADRES( a )
                  FIRMY->NIP := n
               endif
               FIRMY->( DBSetOrder( 5 ))
            else
                  FIRMY->( DBAppend())
                  FIRMY->ID_F := FIRMY->(GetLast(1,1)+1)
                  FIRMY->TYP := t
                  FIRMY->NAZWA1 := o
                  DokADRES( a )
                  FIRMY->NIP := n
            endif
         endif
      endif

               if e # NIL
                  FIRMY->TELEFON := e
               endif

               if b # NIL
                  FIRMY->OSOBA := b
               endif


******************************************************************************

procedure DokDokum( t, i, d, w, n, n23, v23, n22, v22, n8, v8, n7, v7, n5, v5, n0, nzw )

      DOKUM->( DBAppend())
      DOKUM->ID := DOKUM->( GetLast( 1, 1 ) + 1 )
      DOKUM->BLOKADA := "O"
      DOKUM->TYP := t
      DOKUM->INDEKS := i
      DOKUM->NABYWCA := FIRMY->ID_F
   if d # NIL
      DOKUM->DATAW := d
      DOKUM->DATAS := d
      DOKUM->DATAO := d
      DOKUM->DATAT := d
   endif
      DOKUM->WARTOSC := w
      DOKUM->WPLACONO := w
      DOKUM->SPOSOB := "got¢wka"
   if n # NIL
      DOKUM->NUMERFD := n
   endif

if n23 # NIL; DOKUM->NETTO23 := n23; endif
if n22 # NIL; DOKUM->NETTO22 := n22; endif
if n8  # NIL; DOKUM->NETTO8  := n8 ; endif
if n7  # NIL; DOKUM->NETTO7  := n7 ; endif
if n5  # NIL; DOKUM->NETTO5  := n5 ; endif

if n0  # NIL; DOKUM->NETTO0  := n0
else        ; DOKUM->NETTO0  := w  ; endif

if nzw # NIL; DOKUM->NETTOZW := nzw; endif

if v23 # NIL; DOKUM->VAT23   := v23; endif
if v22 # NIL; DOKUM->VAT22   := v22; endif
if v8  # NIL; DOKUM->VAT8    := v8 ; endif
if v7  # NIL; DOKUM->VAT7    := v7 ; endif
if v5  # NIL; DOKUM->VAT5    := v5 ; endif

******************************************************************************

function GetSKROT( s )

local k1, k2

s := StrTran( s, "'", '"' )    && zmienia pojedyncze cudzys'owy na podw¢jne

s := StrTran( s, ">>", '"' )   && zmienia pojedyncze cudzys'owy na podw¢jne
s := StrTran( s, "<<", '"' )   && zmienia pojedyncze cudzys'owy na podw¢jne

s := StrTran( s, ' NR', '' )   && zmienia "SKLEP NR 2" na "SKLEP 2"


*s := StrTran( s, 'Z.P.CH.R.', '' ) && usuwa P.P.H
*s := StrTran( s, 'ZPCHR', '' )  && usuwa P.P.H

*s := StrTran( s, 'Z.P.CH.', '' ) && usuwa P.P.H
*s := StrTran( s, 'ZPCH', '' )  && usuwa P.P.H

*s := StrTran( s, 'P.P.CH.', '' ) && usuwa P.P.H
*s := StrTran( s, 'PPCH', '' )  && usuwa P.P.H

s := StrTran( s, 'P.P.H.U.', '' ) && usuwa P.P.H
s := StrTran( s, 'PPHU', '' )  && usuwa P.P.H

s := StrTran( s, 'P.P.H.', '' ) && usuwa P.P.H
s := StrTran( s, 'PPH', '' )   && usuwa P.P.H

s := StrTran( s, ' SP Z ', '_SP_Z_' )
s := StrTran( s, ' SP. Z ', '_SP._Z_' )

s := StrTran( s, ' SP ', '_SP_' )
s := StrTran( s, ' SP. ', '_SP._' )

s := StrTran( s, ' SA ', '_SA_' )
s := StrTran( s, ' S.A. ', '_S.A._' )


s := StrTran( s, 'PRZEDSIEBIORSTWO', 'P' )
s := StrTran( s, 'PRZEDS.', 'P' )

s := StrTran( s, 'PRZEMYSLU', 'P' )
s := StrTran( s, 'PRZEM.', 'P' )

s := StrTran( s, 'CHLODNICZEGO', 'CH' )
s := StrTran( s, 'CHLODN.', 'CH' )
s := StrTran( s, 'CHLOD.', 'CH' )

s := StrTran( s, 'CHLODNIA', 'CH.' )
s := StrTran( s, 'CHLODNIE', 'CH.' )

if 0 <> ( k1 := At( '"', s ))
   s := SubStr( s, k1 + 1 )
   if 0 <> ( k2 := At( '"', s ))
      s := Left( s, k2 - 1 )
   endif
endif

s := StrTran( s, ' ', '' )
s := StrTran( s, '_', ' ' )
if Left( s, 1 ) == ','; s := SubStr( s, 2 ); endif
s := StrTran( s, ',', '.' )

return s

******************************************************************************
* mode = 1 => kod
* mode = 2 => miasto
* mode = 3 => ulica

function DokAdres( a, mode )

local wy := '', x1, x2, y1, y2, z1, i

a := AllTrim( a )

z1 := At( 'UL.', Upper( a ))
if z1 = 0
   z1 := At( 'AL.', Upper( a ))
endif

if IsDigit( Left( a, 1 ))
   x1 := 1
   x2 := 6
   y1 := 7
   y2 := z1 - y1
else
   i := 1
   while i <= Len( a ) .and. !IsDigit( SubStr( a, i, 1 )); i++; enddo
   do case
      case z1 = 0      && brak "ul.": Wroc'aw 90-123 Rynek 50
         x1 := i

         x2 := 6
         y1 := 1
         y2 := i - y1
         z1 := i + 6  - 3
      case z1 # 0 .and. i > z1    && brak kodu: Lodz ul. Boja 28 m 5
         x1 := 1

         x2 := 0
         y1 := 1
         y2 := z1 - y1
   otherwise               && Lodz 90-146 ul. Boja 28
         x1 := i
         x2 := 6
         y1 := 1
         y2 := i - y1
   endcase
endif

if mode = NIL
   FIRMY->KOD    := AllTrim( SubStr( a, x1, x2 ))
   FIRMY->MIASTO := AllTrim( SubStr( a, y1, y2 ))
   FIRMY->NAZWA3 := AllTrim( SubStr( a, z1 + 3 ))
   FIRMY->ADRES  := a
else
   do case
   case mode = 1; return AllTrim( SubStr( a, x1, x2 ))
   case mode = 2; return AllTrim( StrTran( SubStr( a, y1, y2 ), ',', '' ))
   case mode = 3; return AllTrim( SubStr( a, z1 + 3 ))
   endcase
endif


******************************************************************************

procedure DokTowAkt( vIDDokumentu )

local s0, s1, wcz, cbuf, minCZ, maxCZ, firCZ, lasCZ, minDATA, maxDATA

if !RozneCenyZ;return; endif  && gdy ma mieszaç z r¢ßnymi cenami zakupu

TOWARY->( DBSetOrder( 1 ))
MAGAZYNY->( DBSetOrder( 2 ))     && Str(ID_T)+Str(ID)+Str(CENA_Z)
SPEC->( DBSetOrder( 1 ))
SPEC->( DBSeek( vIDDokumentu ))
while SPEC->ID_D = vIDDokumentu .and. !SPEC->( Eof())
      s0 := 0
      s1 := 0
      wcz:= 0
      minCZ := NIL
      maxCZ := NIL
      firCZ := 0
      lasCZ := 0
      minDATA := NIL
      maxDATA := NIL
      MAGAZYNY->( DBSeek( Str( SPEC->ID_T )))
      while MAGAZYNY->ID_T = SPEC->ID_T .and. MAGAZYNY->( !Eof())
            if MAGAZYNY->ID = 0
               if MAGAZYNY->CENA_Z # 0.00
                  if minCZ = NIL .or. minCZ > MAGAZYNY->CENA_Z
                     minCZ := MAGAZYNY->CENA_Z   && tani
                  endif
                  if maxCZ = NIL .or. maxCZ < MAGAZYNY->CENA_Z
                     maxCZ := MAGAZYNY->CENA_Z   && drogi
                  endif
                  if minDATA = NIL .or. minDATA > MAGAZYNY->DATA_Z
                     minDATA := MAGAZYNY->DATA_Z   && first

                     firCZ := MAGAZYNY->CENA_Z
                  endif
                  if maxDATA = NIL .or. maxDATA < MAGAZYNY->DATA_Z

                     maxDATA := MAGAZYNY->DATA_Z   && last
                     lasCZ := MAGAZYNY->CENA_Z
                  endif
               endif
               s0 += MAGAZYNY->ILOSC
               wcz += MAGAZYNY->( Grosz( ILOSC * CENA_Z ))

            else

               s1 += MAGAZYNY->ILOSC
            endif
            MAGAZYNY->( DBSkip())
      enddo
      if TOWARY->( DBSeek( SPEC->ID_T ))
         TOWARY->( Blokuj_R())
         TOWARY->STAN := s0
         if TowOstMini .and. ( TOWARY->STAN < TOWARY->STAN_MIN )
            Alarm( '"' + AllTrim( TOWARY->NAZWA ) + '";stan ponißej minimum o ' + AllS( TOWARY->STAN_MIN - TOWARY->STAN ))
         endif
      if TowZmiCenW
         if wcz = 0.00 .or. s0 = 0.000
            do case
               case MagStanMin = 1; cbuf := firCZ && gdzie
               case MagStanMin = 2; cbuf := lasCZ && by
               case MagStanMin = 3; cbuf := minCZ && go
               case MagStanMin = 4; cbuf := maxCZ && tu
            endcase
            TOWARY->CENA_Z := if( cbuf = NIL, 0, cbuf )
         else
            TOWARY->CENA_Z := if( s0 = 0, 0, Grosz( wcz / s0 ))
         endif
      endif
         TOWARY->( OdBlokuj_R())
      endif
      SPEC->( DBSkip())

enddo

******************************************************************************
* mode = NIL - zablokuj
* mode # NIL - odblokuj - pomijane
* first - pierwszy raz usuwa stary mirror i tworzy nowy,
*         nast'pne tylko korzystajÜ z istniejÜcego mirrora

procedure Mirror( vInOut, vIDDokumentu, vIDMagazynu, mode, first )

local rroSL, rrdSL, cc, rrF, rrL, rrT, rrD, minCZ, maxCZ, il, rr, idt, wcz, ccc
local vIDTowaru, vIlTowaru, rLSTowar, rASTowar, vASCenaTowar, dokladnie := .f.
                              && mirror tworzy tylko:
if !RozneCenyZ;return; endif  && gdy ma mieszaç z r¢ßnymi cenami zakupu
if mode # NIL; return; endif  && nie przy odblokowywaniu dokumentu
if vInOut = 0; return; endif  && nie dla dokument¢w oboj'tnych

if ( vInOut = 1 ) .and. Inn( DOKUM->TYP, DokSyaleCZ, 1 )
	&& mirror juø jest przy okazji rozchodu
	&& wiÍc nie usuwaj mirrora bo bÍdzie przychÛd wedlug niego !!!
	return
endif

if ( vInOut = 2 ) .and. ( vIDMagazynu = 0 ) .and. Inn( DOKUM->TYP, DokSyaleCZ, 1 )
	&& rochÛd ze zbiorczego ma byÊ welug tego jak przed chwilπ zeszlo z glowego MG
	&& wiÍc nie usuwaj mirrora bo bÍdzie rozchÛd wedlug niego !!!
	return
endif

*if first = NIL; first := .t.; endif

*if first
   SPEC->( DBSetOrder( 1 ))
   SPEC->( DBSeek( -vIDDokumentu ))
   while SPEC->ID_D = -vIDDokumentu .and. !SPEC->(Eof())    && stary mirror
         SPEC->( BDelete())
         SPEC->( DBSkip())
   enddo
*endif

wcz := 0                         && wartoûç w cenach netto zakupu
MAGAZYNY->( DBSetOrder( 1 ))     && Str(ID)+Str(ID_T)+DtoS(DATA_Z)
SPEC->( DBSetOrder( 3 ))         && Str(ID)+Str(ID_T)+Str(CENA)
SPEC->( DBSeek( Str( vIDDokumentu )))
while SPEC->ID_D = vIDDokumentu .and. !SPEC->(Eof())

* Zabezpieczenie przed brakiem pud'a w magazynie na taki towar

   if !MAGAZYNY->( DBSeek( Str( vIDMagazynu ) + Str( SPEC->ID_T )))
      MAGAZYNY->(DBAppend())
      MAGAZYNY->ID:=vIDMagazynu
      MAGAZYNY->ID_T:=SPEC->ID_T
      MAGAZYNY->CENA_Z:=SPEC->CENA  && przypuszczalnie cena zakupu
      MAGAZYNY->DATA_Z:=DOKUM->DATAS
   endif


if vInOut = 1        && przych¢d: mirror identyczny ze specyfikacjÜ

   cc  := SPEC->CENA
   il  := SPEC->ILOSC
   idt := SPEC->ID_T
   rr  := SPEC->( RecNo())

*   if first .or. !( SPEC->( DBSeek( Str( -vIDDokumentu, 10 ) + Str( idt, 10 ) + Str( cc, 12, 2 ))))
      SPEC->( DBAdd())
      SPEC->ID_D := -vIDDokumentu
      SPEC->ID_T := idt
      SPEC->CENA := cc
*   endif


   SPEC->ILOSC := il


   SPEC->( DBGoTo( rr ))

else

   if vInOut = 3
      rrdSL := NIL
      cc := SPEC->CENA
      vIlTowaru := SPEC->ILOSC
   else                             && rozch¢d
      cc := SPEC->CENA
      vIlTowaru := 0                && agregacja wystÜpie§ tego samego towaru

      vIDTowaru := SPEC->ID_T
      rLSTowar := SPEC->( RecNo())
      if !Inn( DOKUM->TYP, DokSyaleCZ, 1 ) .and. Inn( DOKUM->TYP_F, TypyKonMag ) && rozch¢d z podmagazynu
         vIlTowaru += SPEC->ILOSC
         dokladnie := .t.           && dok'adnie wskazana cena ma byç !!!
      else
         while SPEC->ID_D = vIDDokumentu .and.;
               SPEC->ID_T = vIDTowaru .and.;
               SPEC->( !Eof())
               cc := SPEC->CENA              && ostatnia cena
               vIlTowaru += SPEC->ILOSC      && suma iloûci
               rLSTowar := SPEC->( RecNo())  && miejsce ostatniego wystÜpienienia
               SPEC->( DBSkip())
         enddo
         SPEC->( DBGo( rLSTowar ))  && go to last specification of Towar

      endif
   endif


   minCZ := 91000

   maxCZ := -1000
   il := vIlTowaru
   rrF := MAGAZYNY->( RecNo())   && first
   rroSL := NIL                  && nieokreûlony rekord mirrora tego towaru
   rASTowar := NIL               && zapisany minus
   vASCenaTowar := NIL           && cena minusa

   if dokladnie                  && najpierw pr¢ba zdj'cia ze wskazanej ceny
      ccc := cc
      idt := SPEC->ID_T
      if SPEC->( !DBSeek( Str( -vIDDokumentu ) + Str( idt ) + Str( ccc )))
         SPEC->( DBAdd())
         SPEC->ID_D := -vIDDokumentu
         SPEC->ID_T := idt
         SPEC->CENA := ccc
      endif

      SPEC->( Blokuj_R())
      MAGAZYNY->( DBSetOrder( 2 ))  && Str(ID_T)+Str(ID)+Str(CENA_Z)
      if MAGAZYNY->( DBSeek( Str( SPEC->ID_T ) + Str( vIDMagazynu ) + Str( SPEC->CENA )))

         if il <= MAGAZYNY->ILOSC;   && pe'ne pokrycie w magazynie na rozch¢d
            .or.;
            SPEC->ILOSC + il = 0     && korekta bez zmian (+-=0)
            SPEC->ILOSC += il
            il := 0.000
         else                                && cz'ûciowe pokrycie
            SPEC->ILOSC += MAGAZYNY->ILOSC   && bießemy co jest
            il -= MAGAZYNY->ILOSC            && ale troch' zostaje do zdj'cia
            rASTowar := SPEC->( RecNo())     && zapisany pretendent na minusa
            vASCenaTowar := SPEC->CENA       && cena pretendenta na minusa
         endif
         wcz += Grosz( SPEC->( ILOSC * CENA ))
      endif
      MAGAZYNY->( DBSetOrder( 1 ))           && Str(ID)+Str(ID_T)+DtoS(DATA_Z)
      MAGAZYNY->( DBSeek( Str( vIDMagazynu ) + Str( SPEC->ID_T )))
      SPEC->( OdBlokuj_R())
      SPEC->( DBGo( rLSTowar ))  && go to last specification of Towar
   endif



   while MAGAZYNY->(( ID = vIDMagazynu ) .and. ( ID_T = SPEC->ID_T ) .and. !Eof())

* po sekcji "if dokladnie", "il" moße byç = 0.000

         if vInOut # 3 .and. il = 0.000; exit; endif

         if minCZ > MAGAZYNY->CENA_Z
            minCZ := MAGAZYNY->CENA_Z
            rrT := MAGAZYNY->( RecNo())   && tani
         endif

         if maxCZ < MAGAZYNY->CENA_Z
            maxCZ := MAGAZYNY->CENA_Z
            rrD := MAGAZYNY->( RecNo())   && drogi
         endif

         rrL := MAGAZYNY->( RecNo())   && last

* Nie pr¢buj kombinowaç przy rozchodzie z zerowymi pozycjami magazynu
* bo i tak nic z tego nie wyjdzie

      if !( vInOut = 2 .and. MAGAZYNY->ILOSC = 0.000 )   && zabezpiecza przed
         rr  := SPEC->( RecNo())                         && rozdmuchaniem
         idt := SPEC->ID_T                               && mirrora
         ccc := MAGAZYNY->CENA_Z
         if SPEC->( !DBSeek( Str( -vIDDokumentu ) + Str( idt ) + Str( ccc )))
            SPEC->( DBAdd())
            SPEC->ID_D := -vIDDokumentu
            SPEC->ID_T := idt
            SPEC->CENA := ccc
         endif
         SPEC->( Blokuj_R())
         if vInOut = 3                 && inwentaryzacja
*            SPEC->ILOSC := 0
            rroSL := SPEC->( RecNo())  && ostatnia cena mirrora tego towaru
            if cc = MAGAZYNY->CENA_Z
               rrdSL := SPEC->( RecNo())   && dobra cena mirrora tego towaru
            endif
         else                          && rozch¢d
            if il <= MAGAZYNY->ILOSC;  && pe'ne pokrycie w magazynie na rozch¢d
               .or.;
               SPEC->ILOSC + il = 0
               SPEC->ILOSC += il
               il := 0
            else                                && cz'ûciowe pokrycie
               SPEC->ILOSC += MAGAZYNY->ILOSC   && bießemy co jest
               il -= MAGAZYNY->ILOSC            && ale troch' zostaje do zdj'cia

               rASTowar := SPEC->( RecNo())     && zapisany pretendent na minusa
               vASCenaTowar := SPEC->CENA       && cena pretendenta na minusa
            endif
         endif
         wcz += Grosz( SPEC->( ILOSC * CENA ))
         SPEC->( OdBlokuj_R())
         SPEC->( DBGoTo( rr ))
      endif
         if vInOut # 3 .and. il = 0.000; exit; endif
         MAGAZYNY->( DBSkip())
   enddo

   if il # 0.000 .or.;                     && nieza'atwiona iloûç lub
      ( vInOut = 3 .and. rroSL # NIL )     && inwentaryzowanie okreûlonego

      do case
         case MagStanMin = 1; MAGAZYNY->( DBGoTo( rrF )) && gdzie
         case MagStanMin = 2; MAGAZYNY->( DBGoTo( rrL )) && by
         case MagStanMin = 3; MAGAZYNY->( DBGoTo( rrT )) && go
         case MagStanMin = 4; MAGAZYNY->( DBGoTo( rrD )) && tu
      endcase

      rr  := SPEC->( RecNo())
      idt := SPEC->ID_T
      if vInOut = 3
         if rrdSL # NIL
            SPEC->( DBGoTo( rrdSL ))  && dobra cena mirrora tego towaru
            SPEC->( Blokuj_R())
               SPEC->ILOSC := il         && ca'a iloûç tutaj
            SPEC->( OdBlokuj_R())
            wcz += Grosz( SPEC->( ILOSC * CENA ))
         elseif cc = 0.00

            SPEC->( DBGoTo( rroSL ))  && ostatnia cena mirrora tego towaru
            SPEC->( Blokuj_R())

               SPEC->ILOSC := il         && ca'a iloûç tutaj
               SPEC->CENA := MAGAZYNY->CENA_Z
            SPEC->( OdBlokuj_R())
            wcz += Grosz( SPEC->( ILOSC * CENA ))
         else

            MAGAZYNY->( DBAppend())
            MAGAZYNY->ID := vIDMagazynu
            MAGAZYNY->ID_T := SPEC->ID_T
            MAGAZYNY->CENA_Z := cc
            MAGAZYNY->DATA_Z := DOKUM->DATAS

            SPEC->( DBAdd())
            SPEC->ID_D := -vIDDokumentu
            SPEC->ID_T := idt
            SPEC->CENA := MAGAZYNY->CENA_Z
            SPEC->ILOSC := il
            wcz += Grosz( SPEC->( ILOSC * CENA ))

         endif
      else
         if il > 0.000 .and.;
            rASTowar # NIL .and.;
            vASCenaTowar = MAGAZYNY->CENA_Z
            SPEC->( DBGo( rASTowar ))
            SPEC->( Blokuj_R())
               SPEC->ILOSC += il
            SPEC->( OdBlokuj_R())
            wcz += Grosz( SPEC->( il * CENA ))

         else
            SPEC->( DBAdd())
            SPEC->ID_D := -vIDDokumentu
            SPEC->ID_T := idt
            SPEC->CENA := MAGAZYNY->CENA_Z
            SPEC->ILOSC := il
            wcz += Grosz( SPEC->( ILOSC * CENA ))
         endif
         if TowOstMinu .and. il > 0.000
            TOWARY->( DBSetOrder( 1 ))
            TOWARY->( DBSeek( SPEC->ID_T ))

            if !( TOWARY->STATUS == TowStatusU )
               Alarm( '"' + AllTrim( TOWARY->NAZWA ) + '";stan ujemny = -' + AllS( il ))
            endif
         endif
      endif
      SPEC->( DBGoTo( rr ))
   endif
endif

   SPEC->( DBSkip())
enddo

if ObAuDoWCZ
   DOKUM->( Blokuj_R())
   DOKUM->NETTOCZ := wcz
   DOKUM->( OdBlokuj_R())
endif

******************************************************************************
* mode # NIL => cofanie operacji (operacja odwrotna=odblokowanie dokumentu)

procedure DokInOut( vInOut, vIDDokumentu, vIDMagazynu, mode )

local zMirrora, klucz

if vInOut = 0; return; endif

*zMirrora := (( vInOut = 2 .or. vInOut = 3 ) .and. RozneCenyZ )
zMirrora := RozneCenyZ

if mode # NIL
   if vInOut = 3; return; endif   && weryfikacji stan¢w nie cofa
   vInOut = if( vInOut = 1, 2, 1 )
endif

if zMirrora; vIDDokumentu := -vIDDokumentu; endif

if !Empty( TowStatusU ); TOWARY->( DBSetOrder( 1 )); endif
SPEC->( DBSetOrder( 1 ))
SPEC->( DBSeek( vIDDokumentu ))
MAGAZYNY->( DBSetOrder( 2 ))
while SPEC->ID_D = vIDDokumentu .and. !SPEC->(Eof())
   if !Empty( TowStatusU )
      TOWARY->( DBSeek( SPEC->ID_T ))
      if TOWARY->STATUS == TowStatusU; SPEC->( DBSkip()); loop; endif
   endif
   klucz := Str( SPEC->ID_T ) + Str( vIDMagazynu )
   if RozneCenyZ; klucz += Str( SPEC->CENA ); endif
   if !MAGAZYNY->( DBSeek( klucz ))

      MAGAZYNY->(DBAppend())
      MAGAZYNY->ID:=vIDMagazynu
      MAGAZYNY->ID_T:=SPEC->ID_T
      if RozneCenyZ
         MAGAZYNY->CENA_Z := SPEC->CENA
         MAGAZYNY->DATA_Z := DOKUM->DATAS
      endif
   endif
   MAGAZYNY->( Blokuj_R())
   do case
   case vInOut = 3
      MAGAZYNY->ILOSC:=SPEC->ILOSC
   case vInOut = 2
      MAGAZYNY->ILOSC+=SPEC->ILOSC * -1
   case vInOut = 1                  && przych¢d
      MAGAZYNY->ILOSC+=SPEC->ILOSC  && inkrement
      if DOKUM->BLOKADA == "O"      && znaczy teraz jest w trakcie zamykania

         MAGAZYNY->DATA_Z := DOKUM->DATAS        && nowa data zakupu do FIFO

      endif && przy otwieraniu towar wraca na magazyn, ale nie jest to zakup
   endcase
   MAGAZYNY->( OdBlokuj_R())
   SPEC->( DBSkip())
enddo

klucz := ''		&& to tylko punkt koÒcowy procedury do debuggowania

******************************************************************************
* Firma magazynowa ?
* if( nr = NIL, DOKUM->NABYWCA, nr ) = FIRMY->ID_F   && moße juß na nim stoi ?

function FirmaMAG( nr, zFirm )

local bb := Alias(), jestFIRMY, rrFIRMY, iiFIRMY, okFIRMY, stoi

stoi := .f.
okFIRMY := .f.                && program dzia'a tylko na magazynie g'¢wnym
if !Empty( TypyKonMag )       && jeûli wyczyûciç TypyKonMag
   if TypyKonZmi .and. zFirm = NIL
      okFIRMY := !Empty( DOKUM->TYP_F ) .and. Upper( DOKUM->TYP_F ) $ Upper( TypyKonMag )
   else
      jestFIRMY := Jest_baza( 'FIRMY' )
      if jestFIRMY
         stoi := ( if( nr = NIL, DOKUM->NABYWCA, nr ) = FIRMY->ID_F )  && moße juß na nim stoi ?
         rrFIRMY := FIRMY->( RecNo())
         iiFIRMY := FIRMY->( IndexOrd())
      endif
      okFIRMY := .f.
      if !stoi
         ON( 'FIRMY' )
         if DBSeek( if( nr = NIL, DOKUM->NABYWCA, nr ))
            okFIRMY := Empty( FIRMY->TYP ) .or. Upper( FIRMY->TYP ) $ Upper( TypyKonMag )
         endif
      else
         okFIRMY := Empty( FIRMY->TYP ) .or. Upper( FIRMY->TYP ) $ Upper( TypyKonMag )
      endif
      if jestFIRMY .and. !stoi
         FIRMY->( DBGo( rrFIRMY ))
         FIRMY->( DBSetOrder( iiFIRMY ))
      endif
   endif
endif

Jest_baza( bb )

return okFIRMY


******************************************************************************
* mode = NIL - zablokuj
* mode # NIL - odblokuj

function DokInOutPre( mode )

if !DOKTYPY->( DBSeek( DOKUM->TYP ))
   Alarm( "Nieznany typ dokumentu: " + DOKUM->TYP )
   return .f.
endif

ON( 'SPEC' )

if MZzalezny

if NRMG = 0                                                 && Mistral

   DokInOut( DOKTYPY->MAGAZYNG, DOKUM->ID, 0, mode )
   if DOKUM->MAGAZYN # 0
      DokInOut( DOKTYPY->MAGAZYNG, DOKUM->ID, DOKUM->MAGAZYN, mode )
   endif

   DokInOut( DOKTYPY->MAGAZYNP, DOKUM->ID, 0, mode )
   if DOKUM->NABYWCA # 0
      DokInOut( DOKTYPY->MAGAZYNP, DOKUM->ID, DOKUM->NABYWCA, mode )
   endif

else                                                        && Piatek 13

	&& rozchÛd z MG na podmagazyn
if ( DOKTYPY->MAGAZYNG = 2 ) .and. ( DOKTYPY->MAGAZYNP * DOKTYPY->MAGAZYNG = 2 )

   if DOKUM->MAGAZYN # 0
     	Mirror(   DOKTYPY->MAGAZYNG, DOKUM->ID, DOKUM->MAGAZYN, mode )	&& mirror dla MG
     	DokInOut( DOKTYPY->MAGAZYNG, DOKUM->ID, DOKUM->MAGAZYN, mode )	&& z MG wed≥ug mirrora
   	DokInOut( DOKTYPY->MAGAZYNG, DOKUM->ID, 0, mode )		&& z MZ z tego samego mirrora co dla MG
   else
	Mirror(   DOKTYPY->MAGAZYNG, DOKUM->ID, 0, mode )		&& mirror dla MZ
   	DokInOut( DOKTYPY->MAGAZYNG, DOKUM->ID, 0, mode )		&& z MZ wed≥ug mirrora
   endif

   if FirmaMAG()

      if DOKUM->NABYWCA # 0
	 Mirror(   DOKTYPY->MAGAZYNP, DOKUM->ID, DOKUM->NABYWCA, mode )	&& mirror dla podmagazynu niezaleøny od mirrora MG (na øyczenie P13)
         DokInOut( DOKTYPY->MAGAZYNP, DOKUM->ID, DOKUM->NABYWCA, mode )
      endif

      if ( DOKTYPY->MAGAZYNP = 3 .and. DOKUM->NABYWCA = 0 );         && MZ INW
         .or. ( DOKTYPY->MAGAZYNP * DOKTYPY->MAGAZYNG = 2 )          && MZ->MP->MZ
         DokInOut( DOKTYPY->MAGAZYNP, DOKUM->ID, 0, mode )
      endif

   endif

		&& rozchÛd z podmagazynu na MG
elseif ( DOKTYPY->MAGAZYNP = 2 ) .and. FirmaMAG() .and. ( DOKTYPY->MAGAZYNP * DOKTYPY->MAGAZYNG = 2 )

   if DOKUM->NABYWCA # 0
      Mirror(   DOKTYPY->MAGAZYNP, DOKUM->ID, DOKUM->NABYWCA, mode ) && MP
      DokInOut( DOKTYPY->MAGAZYNP, DOKUM->ID, DOKUM->NABYWCA, mode )
      DokInOut( DOKTYPY->MAGAZYNP, DOKUM->ID, 0, mode )
	else
      Mirror(   DOKTYPY->MAGAZYNP, DOKUM->ID, 0, mode ) && MP
      DokInOut( DOKTYPY->MAGAZYNP, DOKUM->ID, 0, mode )
   endif

	if DOKUM->MAGAZYN # 0
      DokInOut( DOKTYPY->MAGAZYNG, DOKUM->ID, DOKUM->MAGAZYN, mode )
		DokInOut( DOKTYPY->MAGAZYNG, DOKUM->ID, 0, mode )		&& ten sam mirror co dla MG
	else
		DokInOut( DOKTYPY->MAGAZYNG, DOKUM->ID, 0, mode )
	endif

else

   if DOKUM->MAGAZYN # 0
      Mirror(   DOKTYPY->MAGAZYNG, DOKUM->ID, DOKUM->MAGAZYN, mode ) && MG najpierw
      DokInOut( DOKTYPY->MAGAZYNG, DOKUM->ID, DOKUM->MAGAZYN, mode )
   	DokInOut( DOKTYPY->MAGAZYNG, DOKUM->ID, 0, mode )		&& ten sam mirror co dla MG
	else
	   Mirror(   DOKTYPY->MAGAZYNG, DOKUM->ID, 0, mode )     && niezaleøny mirror
   	DokInOut( DOKTYPY->MAGAZYNG, DOKUM->ID, 0, mode )
   endif

   if FirmaMAG()

      if DOKUM->NABYWCA # 0
         Mirror(   DOKTYPY->MAGAZYNP, DOKUM->ID, DOKUM->NABYWCA, mode ) && MP
         DokInOut( DOKTYPY->MAGAZYNP, DOKUM->ID, DOKUM->NABYWCA, mode )
      endif

      if ( DOKTYPY->MAGAZYNP = 3 .and. DOKUM->NABYWCA = 0 );         && MZ INW
         .or. ( DOKTYPY->MAGAZYNP * DOKTYPY->MAGAZYNG = 2 )          && MZ->MP->MZ
         Mirror(   DOKTYPY->MAGAZYNP, DOKUM->ID, 0, mode )
         DokInOut( DOKTYPY->MAGAZYNP, DOKUM->ID, 0, mode )
      endif

   endif
endif

   DokTowAkt( DOKUM->ID )

endif

else              && Literatura

   if FirmaMAG()
      Mirror(   DOKTYPY->MAGAZYNP, DOKUM->ID, DOKUM->NABYWCA, mode )
      DokInOut( DOKTYPY->MAGAZYNP, DOKUM->ID, DOKUM->NABYWCA, mode )
   else
      Mirror( DOKTYPY->MAGAZYNG, DOKUM->ID, 0, mode )
   endif
   DokInOut(  DOKTYPY->MAGAZYNG, DOKUM->ID, 0, mode )
   DokTowAkt( DOKUM->ID )

endif

if ( mode = NIL ) .and. Inn( DOKUM->TYP, DokSyaleCZ, 1 )
	KopiaSCZ()
endif

return .t.

******************************************************************************
* kopia mirrora jako specyfikacji glÛwnej

procedure KopiaSCZ()

local r

SPEC->( DBSetOrder( 1 ))
SPEC->( DBSeek( DOKUM->ID ))
while ( SPEC->ID_D = DOKUM->ID ) .and. !SPEC->(Eof())    && stara specyfikacja
	SPEC->( BDelete())
	SPEC->( DBSkip())
enddo

SPEC->( DBSeek( -DOKUM->ID ))
while ( SPEC->ID_D = -DOKUM->ID ) .and. !SPEC->(Eof())    && stara specyfikacja
	r := SPEC->( RecNo())
	SPEC->( KopiujRec( 'SPEC', 'SPEC' ))
	SPEC->ID_D := -SPEC->ID_D
	SPEC->( DBGoTo( r ))
	SPEC->( DBSkip())
enddo

DokumLicz( 'SPEC->ID_T', 'VAT',, 1, DOKUM->ID )

******************************************************************************
* mode = NIL - zablokuj
* mode # NIL - odblokuj
* bg - bez generowania pe'nej kasy, a tylko na r¢ßnic'

function DokClose( a, mode, bg )

local bb := Alias(), wp, popObAuDoWCZ := ObAuDoWCZ

if mode = NIL

if DOKUM->BLOKADA == " "
   if Alarm( 'Dokument "' + AllTrim( DOKUM->TYP ) + '" Nr "' +;
             AllTrim( DOKUM->INDEKS ) + '" juß zamkniëty.;ZamknÜç ponownie?', nt ) # 2
      return
   endif
endif

wp := if( rozlacz, 0, DOKUM->WPLACONO )		&& zapamiÍtaj ile by≥o wp≥acone przed zamkniÍciem dokumentu
*if a # NIL; DOKUM->WPLACONO := WARTOSC; endif
if if( a = NIL, .t., NewSysForm( a ))

   DOKUM->( Blokuj_R())
   	DOKUM->BLOKADA := " "
   	DOKUM->CZAS := Time()   && czas zablokowania decydujπcy przy inwentaryzacji
   DOKUM->( OdBlokuj_R())

	GenerujWZ(,,bg)				&& tu moøe zmieniÊ siÍ specyfikacja i wartoúÊ dokumentÛw
	DokInOutPre()					&& tu moøe zmieniÊ siÍ specyfikacja i wartoúÊ dokumentÛw, np. RW i KopiaSCZ()
	ObAuDoWCZ := popObAuDoWCZ	&& mog≥o byÊ wy≥πczone przez RW i teraz musi wrÛciÊ do poprzedniego stanu

   Naleznosci( mode )

*   if !GenerujWZ(,,bg) .and. ( wp # 0.00 ) .and. ( wp = DOKUM->WPLACONO )

	if wp # DOKUM->WPLACONO		&& zmieni≥a siÍ wp≥ata
		private vp := { 0, 0, 0, DOKUM->WPLACONO - wp, Datee(), 'got¢wka z pola "Wplacono"' }
	else
		private vp := { 0, 0, 0, 0, Datee(), 'got¢wka z pola "Wplacono"' }
	endif
	DOKUM->( SetNaleznosci())

*	endif
endif

else

if DOKUM->BLOKADA == "O"
   if Alarm( 'Dokument "' + AllTrim( DOKUM->TYP ) + '" Nr "' +;
             AllTrim( DOKUM->INDEKS ) + '" juß otwarty.;Otworzyç ponownie?', nt ) # 2
      return
   endif
endif

if DokInOutPre( mode )
   DOKUM->( Blokuj_R())
   DOKUM->BLOKADA := "O"
   DOKUM->CZAS := Time()   && czas odblokowania
   DOKUM->( OdBlokuj_R())
   Naleznosci( mode )
	private vp := { 0, 0, 0, 0, Datee(), 'got¢wka z pola "Wplacono"' }
	DOKUM->( SetNaleznosci())
endif

endif

Select( bb )

******************************************************************************

procedure DokumCheckMaska( a, b )

local x, ii, rr, td, wy := .t.


*if !( vp[ 3 ] == DOKUM->INDEKS ) .or.;
*   !( vp[ 3 ] == ( x := DOKTYPY->( DokMaska( a, b ))))

   x := DOKTYPY->( DokMaska( a, b ))

   DOKTYPY->(Blokuj_R())
   DOKTYPY->NUMER := Val( if( MaskaDelta = NIL, vp[ 3 ], SubStr( vp[ 3 ], MaskaDelta )))
   DOKTYPY->(OdBlokuj_R())

   ii := DOKUM->( IndexOrd())
   rr := DOKUM->( RecNo())
   td := DOKUM->TYP
   DOKUM->( DBSetOrder( 5 ))

   x := Upper( AllTrim( vp[ 3 ]))
   DOKUM->( DBSeek( x ))
   while Upper( Left( AllTrim( DOKUM->INDEKS ), Len( x ))) == x .and. DOKUM->( !Eof())
         if td == DOKUM->TYP .and. rr # DOKUM->( RecNo())
			   vp[ 3 ] := DOKTYPY->( DokMaska( a, b, 1 ))
				DOKUM->( DBGoTo( rr ))
				DOKUM->( Blokuj_R())
				DOKUM->INDEKS := vp[ 3 ]
				DOKUM->( OdBlokuj_R())
				x := Upper( AllTrim( vp[ 3 ]))
	DOKUM->( DBSeek( x ))
	while Upper( Left( AllTrim( DOKUM->INDEKS ), Len( x ))) == x .and. DOKUM->( !Eof())
         if td == DOKUM->TYP .and. rr # DOKUM->( RecNo())
			   x := Upper( AllTrim( vp[ 3 ]))
            if Alarm( 'Jest juß dokument "' + AllTrim( td ) + '" o numerze "' + x + '"' +;
                      ';Czy mimo wszystko pozostawiç ten numer ?', nt ) # 2
               wy := .f.
            endif
            exit
         endif
         DOKUM->( DBSkip())
   enddo
				if wy
					DokIncNr( a )
				endif
				exit
         endif
         DOKUM->( DBSkip())
   enddo

   DOKUM->( DBSetOrder( ii ))
   DOKUM->( DBGoTo( rr ))


*endif

return wy


******************************************************************************
* a - typ dokumentu
* b - numer gdy ustawiamy

function DokIncNr( a, b )

if LastKey() = K_ESC; return; endif    && wyjûcie Esc z formularza dopisania

DBSetOrder( 1 )
if DBSeek( a )

   DOKTYPY->( Blokuj_R())

   if b = NIL
      DOKTYPY->NUMER ++
   else
      DOKTYPY->NUMER := b
   endif
   DOKTYPY->( OdBlokuj_R())
endif

******************************************************************************
* Zwraca numer dokumentu podanego typu obudowany w zdefiniowanÜ mask'
* a = typ, np.: "FV "
* b = numer, np.: "15/2001"
* plus = szukamy nie tego co jest tylko o "plus" wiÍkszego numeru dokumentu od podanego

function DokMaska( a, b, plus )

private wy := ''

if plus = NIL .and. !Empty( b ) .and. a == DOKUM->TYP .and. b == DOKUM->INDEKS
   return b
endif

if Empty( a )
   return PadR( wy, 20 )
endif

DBSetOrder( 1 )

if a = NIL
   if NUMER = 0
      DOKTYPY->( Blokuj_R())
      DOKTYPY->NUMER := 1
   endif
else
   if DBSeek( a )
      if NUMER = 0
         DOKTYPY->( Blokuj_R())
         DOKTYPY->NUMER := 1
      endif
   endif
endif

wy := AllTrim( MASKA )

if Left( wy, 1 ) == "="
   wy := SubStr( wy, 2 )
	if plus # NIL
		wy := StrTran( wy, 'NUMER', 'NUMER+' + AllS( plus ))
	endif
   wy := &wy
else
   wy := AllS( NUMER + if( plus = NIL, 0, plus )) + wy
endif

DOKTYPY->( OdBlokuj_R())

return PadR( wy, 20 )

******************************************************************************
* Podsumowania subbazy i wpisanie wynik¢w do bazy
* ba - baza-cel zapisu wynik¢w
* od - tablica numer¢w sumowanych p¢l subbazy
* do - tablica numer¢w p¢l bazy-celu
* zeranie - jeûli w bazie docelowej jest # 0, a z sum wynika = 0, to nie wpisuj
* warbez - warunek pomijania pozycji

procedure SumSub( ba, od, do, zeranie, warbez )

local odo, doo, i, iod, ido, rek, wa, iodwa, se

se := if( '|' $ od, '|', ',' )

iod := {}

ido := {}
rek := {}

if IsDigit( od )

   while !Empty( od )
         Aadd( iod, Val( Odetnij( @od, se )))          && zerowanie
         Aadd( ido, Val( Odetnij( @do, se )))
         Aadd( rek, 0 )
   enddo

   go top
   while !Eof()
         for i := 1 to Len( iod )
				if iod[ i ] < 0
					wa := 1					&& zliczanie pozycji
				else
					wa := FieldGet( iod[ i ])
				endif
             rek[ i ] += wa       && sumowanie
         next
         skip
   enddo

   for i := 1 to Len( iod )
       if zeranie = NIL
          ( ba )->( FieldPut( ido[ i ], rek[ i ]))    && rejestrowanie wynik¢w
       else
          if rek[ i ] # 0
             ( ba )->( FieldPut( ido[ i ], rek[ i ]))
          endif
       endif
   next


else

   go top
   wa := 0

   while !Eof()
         if !RunCommand( warbez )
            wa += &od
         endif
         skip
   enddo

   buf := ba + '->' + do
   if zeranie = NIL
      &buf := wa                  && rejestrowanie wynik¢w
   else
      if wa # 0
         &buf := wa               && rejestrowanie wynik¢w niezerowych
      endif
   endif

endif

won := .t.

******************************************************************************

procedure DokCloseAll()

local b1, b2

if Alarm( 'ZamknÜç dokumenty?', tk ) = 1
   b1 := TowOstMinu
   b2 := TowOstMini
   TowOstMinu := .f.
   TowOstMini := .f.
   ON( 'TOWARY' )
   ON( 'MAGAZYNY' ); DBZap('')
   ON( 'DOKTYPY' )
   ON( 'DOKUM', 3 )
   Czek( 1 )

   Przerwa( LastRec())
   while !Eof()

         if DOKUM->TYP == "INW"
            if Alarm( 'ZamknÜç dokument inwentaryzacji?', tk ) = 1
               DokClose()
            endif

         else
            DokClose()
         endif
         if Przerwa(); exit; endif
         skip
   enddo
   Przerwa( 0 )
   TowOstMinu := b1
   TowOstMini := b2
   Czek( 0 )
endif

******************************************************************************

procedure DokRozliAll()

if Alarm( 'Wyczyûciç rozliczenia dokument¢w;z pewnego okresu czasu?', tk ) = 1

   if ( NIL = Get_Okres( @data1 , @data2 )); return; endif

   ON( 'DOKUM', 3 )
   Czek( 1 )

   Przerwa( LastRec())
   while !Eof()
         if data1 <= DATAS .and. DATAS <= data2
            DOKUM->WPLACONO := DOKUM->WARTOSC
         endif
         if Przerwa(); exit; endif
         skip
   enddo
   Przerwa( 0 )
   Czek( 0 )


endif

******************************************************************************
* mode = NIL - wszystkie pozycje
* mode # NIL - zwr¢ç 1 cen'


function DokumCeny( rc, mode, idtt )

local wa, rr, x, cc

wa := Alarm( 'Wybierz wariant zmiany cen:',;
           { 'Ceny zakupu',;
             'Ceny sprzedaßy 1',;
             'Ceny sprzedaßy 2',;
             'Ceny sprzedaßy 3',;
             'Ceny sprzedaßy 4',;
             'Ceny sprzedaßy 5' })
if wa = 0; return mode; endif

if mode = NIL
   rr := RecNo()
   go top
endif

private idt
while !Eof()
      idt := if( idtt = NIL, ID_T, idtt )
      do case
         case wa = 1; cc := TOWARY->(GetPole(1,'idt','CENA_Z'))
         case wa = 2; cc := TOWARY->(GetPole(1,'idt','CENA_S'))
         case wa = 3; cc := TOWARY->(GetPole(1,'idt','CENA_S2'))
         case wa = 4; cc := TOWARY->(GetPole(1,'idt','CENA_S3'))
         case wa = 5; cc := TOWARY->(GetPole(1,'idt','CENA_S4'))
         case wa = 6; cc := TOWARY->(GetPole(1,'idt','CENA_S5'))
      endcase
      if mode # NIL; return cc; endif
      replace CENABEZR with cc

      replace CENA with Grosz(((100-RABAT)*0.01)*CENABEZR)
      skip
enddo
zmiana := .t.
DBGoTo( rr )
DokumZlicz( rc )
wy := 2

******************************************************************************
* Generowanie kont rozliczeniowych
* x - wst'pna maska (np.: "208-")
* ko - pole zawierajÜce konto, np.: REJ_SP->K24 (UWAGI)

procedure GenerujKR( x, a )

local i, n, xx, bb := Alias(), rr := RecNo(), nn, rrr, ok

i := Alarm( 'Wybierz wariant generowania kont rozliczeniowych',;
          { 'Formularze kont do weryfikacji', 'Bez weryfikacji' })
if i = 0; return; endif

if a = NIL; a := 'KNORDPOL,Dane wygenerowanego konta'; endif

xx := x


ON( 'KNORDPOL' )

Select( bb )
go top

while !Eof()

      if !IsDigit(( bb )->K24 ) .or. !KNORDPOL->( DBSeek(( bb )->K24 ))
         KNORDPOL->( DBAppend())
         if Left( xx, 1 ) == '&'
            x := RunCommand( SubStr( xx, 2 ))
         endif
         n := PopKonto( 'KNORDPOL', 'KONTO', 4, x )
         if n = NIL
            KNORDPOL->( BDelete())
            skip
            loop
         endif
         KNORDPOL->TRESC := ( bb )->NAZWA
         KNORDPOL->NAZWA := ( bb )->NAZWA
         KNORDPOL->NIP   := ( bb )->NIP
         KNORDPOL->NUMER := n

         KNORDPOL->PSEUDO:= GetSkrot( KNORDPOL->NAZWA )
         KNORDPOL->TRESCG:= ( bb )->ADRES
         KNORDPOL->KOD_POCZT := DokAdres( KNORDPOL->TRESCG, 1 )
         KNORDPOL->MIASTO    := DokAdres( KNORDPOL->TRESCG, 2 )
         KNORDPOL->ULICA     := DokAdres( KNORDPOL->TRESCG, 3 )
         ok := .t.
         if i = 1
            Select( 'KNORDPOL' )
            if !( ok := NewSysForm( a ))
               BDelete()
            endif
         endif
         Select( bb )
         if !ok
            if Alarm( 'Przerwaç generowanie kont?', nt ) = 2; exit; endif
         else
            rrr := RecNo()       && od tego miejsca
            nn := NIP            && o tym NIPie
            while !Eof()         && wszystkim
                  if nn == NIP .and. !IsDigit( K24 )     && o nieuzupe'nionym

                     Blokuj_R()                          && jeszcze koncie
                     ( bb )->NRKONT := KNORDPOL->NUMER   && wpisz numer i
                     ( bb )->PSKONT := KNORDPOL->PSEUDO  && pseudo kontrahenta
                     ( bb )->K24    := AllTrim( KNORDPOL->KONTO ) + ' ' + ( bb )->K24  && i oczywiûcie UWAGI, czyli KONTO
                     OdBlokuj_R()
                  endif
                  skip
            enddo
            DBGoTo( rrr )
         endif
      endif
      skip
enddo

DBGoTo( rr )
wy := 2

******************************************************************************
* Generowanie RWC, PWC


procedure GenRW( znaki )


local i := 0, bb := Alias(), r1, sc := SaveScreen(), rko

ON( 'SPEC' )
ON( 'TOWARY' )
ON( 'MAGAZYNY' )
ON( 'DOKTYPY' )
ON( znaki, 0 )
while !Eof()
      i ++
      skip
enddo

if Alarm( 'Iloûç kontrahent¢w do generowania PWC, RWC: ' + AllS( i ) + ';Zweryfikuj pierwszy dokument, dalsze bëdÜ analogiczne' ) = 0; return; endif
rko := ( Alarm( 'Pytaç o rabaty kontrahent¢w;i stosowaç na PWC cennik Nr ... ?', { ' NIE ', ' cennik 2 ', ' cennik 3 ' }))
if rko = 0; return; endif
*rko := ( rko = 2 )

Przerwa( i * 2 )
ON( znaki, 0 )


CSay( 0, 0, mc, PadC( '', mc ))
CSay( mr, 0, mc, PadC( 'Generowanie dokument¢w PWC, RWC', mc ), miga )
while ( znaki )->( !Eof())

      FIRMY->( GetPole( 1, znaki + '->POLE', 'INDEKS' ))
      Select( 'DOKUM' )

      UGBT(,,'PWC')
      if r1 = NIL .or. ( rko > 1 )
      if ( rko > 1 )
         if !NewSysDopisz('DOKUM,Nowa pozycja,,,73,DIN("Q"),,,22',,,;
            'AppendRecord("DOKUM",{GetLast(1,1)+1,"O",globalbuf,,FIRMY->ID_F,,'+;
            'Datee(),Datee(),Datee(),Datee(),PadR("przelew/got¢wka",20),,,,,,,,,,,,'+;
            'FIRMY->INDEKS,FIRMY->TYP,FIRMY->NAZWA1,FIRMY->NAZWA2,FIRMY->NAZWA3,'+;
            'FIRMY->KOD,FIRMY->MIASTO,FIRMY->ADRES,FIRMY->NIP,-1,,FIRMY->OSOBA},1)')
            exit
         endif
      else
         if !NewSysDopisz('DOKUM,Nowa pozycja,,,73,DIN("Q"),,,16',,,;
            'AppendRecord("DOKUM",{GetLast(1,1)+1,"O",globalbuf,,FIRMY->ID_F,,'+;
            'Datee(),Datee(),Datee(),Datee(),PadR("przelew/got¢wka",20),,,,,,,,,,,,'+;
            'FIRMY->INDEKS,FIRMY->TYP,FIRMY->NAZWA1,FIRMY->NAZWA2,FIRMY->NAZWA3,'+;
            'FIRMY->KOD,FIRMY->MIASTO,FIRMY->ADRES,FIRMY->NIP,-1,,FIRMY->OSOBA},1)')
            exit
         endif
      endif
         r1 := if( r1 = NIL, DOKUM->( RecNo()), r1 )
         MAGAZYNY->( CopyMSpec( rko ))
         SPEC->( DokumLicz( 'SPEC->ID_T', 'VAT',, 1, DOKUM->ID ))
         FIRMY->( GetPole( 1, znaki + '->POLE', 'INDEKS' ))
      else
         KopiujRec( "DOKUM", "DOKUM" )
         AppendRecord("DOKUM",{GetLast(1,1)+1,"O",globalbuf,'',FIRMY->ID_F,,,,,,,,,,,,,,,,,,;
         FIRMY->INDEKS,FIRMY->TYP,FIRMY->NAZWA1,FIRMY->NAZWA2,FIRMY->NAZWA3,;
         FIRMY->KOD,FIRMY->MIASTO,FIRMY->ADRES,FIRMY->NIP,,,FIRMY->OSOBA},1)
         DOKUM->INDEKS := DOKTYPY->( DokMaska( globalbuf, '' ))
         DOKTYPY->( DokIncNr( globalbuf ))
         MAGAZYNY->( CopyMSpec())
         SPEC->( DokumLicz( 'SPEC->ID_T', 'VAT',, 1, DOKUM->ID ))
      endif

      UGBT(,,'RWC')
      KopiujRec( "DOKUM", "DOKUM" )
      AppendRecord("DOKUM",{GetLast(1,1)+1,"O",globalbuf,'',FIRMY->ID_F,,,,,,,,,,,,,,,,,,;
      FIRMY->INDEKS,FIRMY->TYP,FIRMY->NAZWA1,FIRMY->NAZWA2,FIRMY->NAZWA3,;
      FIRMY->KOD,FIRMY->MIASTO,FIRMY->ADRES,FIRMY->NIP,,,FIRMY->OSOBA},1)
      DOKUM->INDEKS := DOKTYPY->( DokMaska( globalbuf, '' ))
      DOKTYPY->( DokIncNr( globalbuf ))
      MAGAZYNY->( CopyMSpec())
      SPEC->( DokumLicz( 'SPEC->ID_T', 'VAT',, 1, DOKUM->ID ))

      ( znaki )->( BDelete())
      ( znaki )->( DBSkip())
      Przerwa()
enddo
Przerwa( 0 )

CSay( 0, 0, mc, PadC( '', mc ))
CSay( mr, 0, mc, PadC( 'Zamykanie dokument¢w PWC, RWC', mc ), miga )
DOKUM->( DBSetOrder( 0 ))
DOKUM->( DBGoTo( r1 ))
Przerwa( i * 2 )
while !Eof()
      if DOKUM->TYP == 'RWC' .or. DOKUM->TYP == 'PWC'
         DokClose()
         Przerwa()
      endif
      skip
enddo

Przerwa( 0 )


ON( znaki, 1 )
Select( bb )
RestScreen( ,,,, sc )
wy := 2

******************************************************************************
* Generowanie INW

procedure GenINW( znaki )


local i := 0, bb := Alias(), r1, sc := SaveScreen()

ON( 'SPEC' )
ON( 'TOWARY' )
ON( 'MAGAZYNY' )

ON( 'DOKTYPY' )
ON( znaki, 0 )
while !Eof()
      i ++
      skip
enddo

if Alarm( 'Iloûç kontrahent¢w do generowania INW: ' + AllS( i ) + ';Zweryfikuj pierwszy dokument, dalsze bëdÜ analogiczne' ) = 0; return; endif

Przerwa( i )
ON( znaki, 0 )


CSay( 0, 0, mc, PadC( '', mc ))
CSay( mr, 0, mc, PadC( 'Generowanie dokument¢w INW', mc ), miga )
while ( znaki )->( !Eof())

      FIRMY->( GetPole( 1, znaki + '->POLE', 'INDEKS' ))
      Select( 'DOKUM' )

      UGBT(,,'INW')
      if r1 = NIL
         if !NewSysDopisz('DOKUM,Nowa pozycja,,,73,DIN("Q"),,,16',,,;
            'AppendRecord("DOKUM",{GetLast(1,1)+1,"O",globalbuf,,FIRMY->ID_F,,'+;
            'Datee(),Datee(),Datee(),Datee(),PadR("przelew/got¢wka",20),,,,,,,,,,,,'+;
            'FIRMY->INDEKS,FIRMY->TYP,FIRMY->NAZWA1,FIRMY->NAZWA2,FIRMY->NAZWA3,'+;
            'FIRMY->KOD,FIRMY->MIASTO,FIRMY->ADRES,FIRMY->NIP,-1,,FIRMY->OSOBA},1)')
            exit
         endif
         r1 := DOKUM->( RecNo())
         MAGAZYNY->( CopyMSpec())
         SPEC->( DokumLicz( 'SPEC->ID_T', 'VAT',, 1, DOKUM->ID ))
         FIRMY->( GetPole( 1, znaki + '->POLE', 'INDEKS' ))
      else
         KopiujRec( "DOKUM", "DOKUM" )
         AppendRecord("DOKUM",{GetLast(1,1)+1,"O",globalbuf,'',FIRMY->ID_F,,,,,,,,,,,,,,,,,,;
         FIRMY->INDEKS,FIRMY->TYP,FIRMY->NAZWA1,FIRMY->NAZWA2,FIRMY->NAZWA3,;
         FIRMY->KOD,FIRMY->MIASTO,FIRMY->ADRES,FIRMY->NIP,,,FIRMY->OSOBA},1)
         DOKUM->INDEKS := DOKTYPY->( DokMaska( globalbuf, '' ))
         DOKTYPY->( DokIncNr( globalbuf ))
         MAGAZYNY->( CopyMSpec())
         SPEC->( DokumLicz( 'SPEC->ID_T', 'VAT',, 1, DOKUM->ID ))
      endif
      ( znaki )->( BDelete())
      ( znaki )->( DBSkip())
      Przerwa()
enddo
Przerwa( 0 )

CSay( 0, 0, mc, PadC( '', mc ))
CSay( mr, 0, mc, PadC( 'Zamykanie dokument¢w INW', mc ), miga )
DOKUM->( DBSetOrder( 0 ))
DOKUM->( DBGoTo( r1 ))
Przerwa( i )
while !Eof()
      if DOKUM->TYP == 'INW'
         DokClose()
         Przerwa()
      endif
      skip
enddo
Przerwa( 0 )

ON( znaki, 1 )
Select( bb )
RestScreen( ,,,, sc )
wy := 2

******************************************************************************

procedure CopyMSpec( rko )

local bb := Alias(), cs

rko := if( rko = NIL, 1, rko )
DBSeek( Str( DOKUM->NABYWCA ))
while DOKUM->NABYWCA = ID .and. !Eof()
   if ILOSC # 0
   if ( rko > 1 )
      cs := TOWARY->( GetPole( 1, bb + '->ID_T', if( rko = 2, 'CENA_S2', 'CENA_S3' )))
      AppendRecord( 'SPEC', { DOKUM->ID, ID_T, Upust( cs, TowUstawRa ), ILOSC, TowUstawRa, cs })
   else
      AppendRecord( 'SPEC', { DOKUM->ID, ID_T, CENA_Z, ILOSC, 0, CENA_Z })
   endif
   endif
      skip
enddo

******************************************************************************
* Czy da siÍ skorygowaÊ Dokumenty Do Korekty (ddk)
* z uwzglÍdnieniem dokumentÛw korekt (dko)

function DaSieKor( ddk, dko )

local bb := Alias(), ii := IndexOrd(), rr := RecNo(), wy, klucz, cenytez
local b := 'DOKUM', i := DOKUM->( IndexOrd()), r := DOKUM->( RecNo()), p, sc

cenytez := ( Alarm( 'Ceny tylko te wskazane na dokumencie "KOR" ?', nt ) = 2 )

ON( 'ANALIZAB' )
ON( 'ANALIZAB',,,, .t. )

if cenytez
	klucz := 'SPEC->(Str(ID_T)+Str(CENA))'
else
	klucz := 'SPEC->(Str(ID_T))'
endif

p := .f.
ON( 'SPEC' )
SPEC->( DBSeek( DOKUM->ID ))
while DOKUM->ID=ID_D .and. !Eof()
		if ANALIZAB->( !DBSeek( &klucz ))
			KopiujRec( 'SPEC', 'ANALIZAB' )
		else
*			if !p
*				sc := SaveScreen()
*				cls
*			endif
*			p := .t.
*			? PadR( Str( SPEC->ID_T ), mc )
			ANALIZAB->ILOSC += SPEC->ILOSC
		endif
		skip
enddo

*if p
*	? 
*	? 'Press any key ...'
*	Inkey( 1 )
*	RestScreen(,,,,sc)
*endif

ON( 'ANALIZAB' )
while !Eof()
		if ILOSC = 0
			BDelete()
		endif
		skip
enddo
go top

wy := ( DokAnAB( , ddk, dko, DOKUM->NABYWCA, cenytez ) > 0 )

Select( b )
DBSetOrder( i )
DBGoTo( r )

Select( bb )
DBSetOrder( ii )
DBGoTo( rr )

return wy

******************************************************************************
* ustalenie ile siÍ da skorygowaÊ
* paform - parametry formularza
* lidok - lista dokumentÛw
* likor - lista korekt dokumentÛw
* idf - identyfikator firmy

procedure DokAnAB( paform, lidok, likor, idf, cenytez )

local ile, ilos, iled, tab, nrd, nrdb, nrs, nra, nri, iid, rrd, rrp, ekran := SaveScreen()

if idf = NIL; idf := DOKUM->( GetPole( 1, 'ID_D', 'NABYWCA' )); endif
if Get_Okres( @data_od , @data_do ) = NIL; return 0; endif

Czek( 1 )

if lidok = NIL; lidok := ''; endif
if likor = NIL; likor := ''; endif

ON( 'ANALIZAP' )
ON( 'ANALIZAP',,,, .t. )

ON( 'DOKUM', 4 )     && Str(NABYWCA)+DtoS(DATAS)
ON( 'SPEC', 3 )      && Str(ID_D)+Str(ID_T)+Str(CENA)

Select( 'ANALIZAB' ); go top
if Eof(); return 0; endif
while !Eof()
   ilos := 0
   iled := 0
   Select( 'DOKUM' )
   DBSeek( Str( idf, 10 ))
   while idf = NABYWCA .and. !Eof()
      if data_od <= DATAS .and. DATAS <= data_do;
      .and. DOKUM->BLOKADA == ' ';
      .and. Inn( TYP, lidok, 1 )
         ile := 0
         Select( 'SPEC' )
         if DBSeek( Str( DOKUM->ID ) + Str( ANALIZAB->ID_T ))
				if cenytez .and. ANALIZAB->CENA # SPEC->CENA		&& pomiÒ
				else
					iled ++
		         KopiujRec( 'SPEC', 'ANALIZAP' )  && jedna pozycja
   		      while ID_D = DOKUM->ID .and. ID_T = ANALIZAB->ID_T .and. !Eof()
      		      ilos += ILOSC
		            ile += ILOSC
   		         skip
      		   enddo
	      	   ANALIZAP->ILOSC := ile        && o zsumowanej iloúci
				endif
			endif
      endif
      Select( 'DOKUM' )
      skip
   enddo
   Select( 'ANALIZAB' )
//   ANALIZAB->( Blokuj_R())
//   ANALIZAB->ILESIEDA := ilos
//   ANALIZAB->ILEDOKUM := iled
//   ANALIZAB->( OdBlokuj_R())
   skip
enddo

if !Empty( likor )
Select( 'ANALIZAB' ); go top
if Eof(); return 0; endif
while !Eof()
   ilos := 0
   Select( 'DOKUM' )
   DBSeek( Str( idf, 10 ))
   while idf = NABYWCA .and. !Eof()
	nrd := AllTrim( NUMERFD )
	nrdb := nrd
	nri := At( ',', nrdb )					&& "FV 15/2001, FV 16/2002"
	if nri > 0
		nrdb := Left( nrdb, nri - 1 )			&& "FV 15/2001"
	endif

	nrs := nrd
	
	nri := At( ' ', nrs )					&& "FV 15/2001, FV 16/2002"
	if nri > 2 .and. nri < 6				&& na 3, 4 lub 5 miejscu jest spacja
		nrs := SubStr( nrs, nri + 1 )		&& "15/2001, FV 16/2002"
	endif
	
	nri := At( ',', nrs )					&& "15/2001, FV 16/2002"
	if nri > 2									&& jest przecinek
		nrs := SubStr( nrs, 1, nri - 1 )	&& "15/2001"
	endif

      if data_od <= DATAS .and. DATAS <= data_do;
     .and. data_od <= DATAO .and. DATAO <= data_do;
     .and. DOKUM->BLOKADA == ' ';
     .and. Inn( TYP, likor, 1 );
     .and. !Empty( nrd )
         ile := 0
         Select( 'SPEC' )
         if DBSeek( Str( DOKUM->ID ) + Str( ANALIZAB->ID_T ));
            .and. ANALIZAP->( DBSeek( Str( ANALIZAB->ID_T )))
		if cenytez .and. ANALIZAB->CENA # SPEC->CENA		&& pomiÒ
		else
			while ID_D = DOKUM->ID .and. ID_T = ANALIZAB->ID_T .and. !Eof()
				ilos += ILOSC
				ile += ILOSC
				skip
			enddo
	//            rrp := NIL
	//            rrd := DOKUM->( RecNo())
	//            iid := DOKUM->( IndexOrd())
	//            Select( 'ANALIZAP' )
	//            while ID_T = ANALIZAB->ID_T .and. !Eof()
	//		nra := DOKUM->( GetPole( 1, 'ANALIZAP->ID_D', 'INDEKS' ))
	//               if nrdb $ nra
	//                  rrp := RecNo()
	//                  exit
	//               endif
	//               if nrs $ nra
	//                  rrp := RecNo()
	//                  exit
	//               endif
	//               DBSkip()
	//            enddo
	//            DOKUM->( DBGoTo( rrd ))
	//            DOKUM->( DBSetOrder( iid ))
	//            if rrp = NIL
	//		if !cenytez
	//	               ? 'Brak faktury do korekty ' + AllTrim( DOKUM->INDEKS )
	//		endif
	//            else
	               ANALIZAP->ILOSC += ile        && o zsumowanej iloúci
	               if ANALIZAP->ILOSC < 0
	                  ? 'IloúÊ ujemna (' +  AllS( ANALIZAP->ILOSC, '999,999' ) + ') po korekcie Nr ' + AllTrim( DOKUM->INDEKS ) + ';na towarze "' + AllTrim(TOWARY->( GetPole( 1, 'ANALIZAB->ID_T','NAZWA'))) + '";PrzyjÍto iloúÊ zerowπ tego towaru ...'
	                  ANALIZAP->ILOSC := 0
	               endif
	//            endif
	         endif
         endif
      endif
      Select( 'DOKUM' )
      skip
   enddo
   Select( 'ANALIZAB' )
//   ANALIZAB->( Blokuj_R())
//   ANALIZAB->ILESIEDA += ilos
//   ANALIZAB->( OdBlokuj_R())
   skip
enddo
endif

Select( 'ANALIZAB' )
DBSetOrder( 0 )	
while !Eof()
	ANALIZAB->( Blokuj_R())
	ANALIZAB->ILESIEDA := 0
	ANALIZAB->ILEDOKUM := 0
	skip
enddo

Select( 'ANALIZAB' ); DBSetOrder( 1 )	
Select( 'ANALIZAP' ); DBSetOrder(0)
go top
while !Eof()
	if ANALIZAP->ILOSC = 0
		ANALIZAP->( BDelete())
	else
		klucz := Str(ID_T)+if( cenytez, Str(CENA), '' )
		Select( 'ANALIZAB' )
		if DBSeek( klucz )
			ANALIZAB->ILESIEDA += ANALIZAP->ILOSC
			ANALIZAB->ILEDOKUM += 1
		endif
	endif
	Select( 'ANALIZAP' )
	skip
enddo
Zwolnij( 'ANALIZAP' )

ilos := 0

Select( 'ANALIZAB' )    && ile siÍ nie da skorygowaÊ ?
go top
while !Eof()
   if ILESIEDA < -ILOSC; ilos --; endif
   skip
enddo

Czek( 0 )

Select( 'ANALIZAB' )
wy := 2
go top

RestScreen(,,,,ekran)

if ilos < 0          && ile siÍ nie da skorygowaÊ ?
	if paform = NIL            && przy zamykaniu dokumentu KOR
		tab := { ' OK ', 'PokazaÊ szczegÛ≥y' }
	endif                && po aktualizacji rÍcznej
	if Alarm( 'NIE UDA SI  skorygowaÊ ' + AllS( -ilos ) + ' pozycji', tab, 1 ) = 2
		ViewDBF( 'ANALIZAB' )
	endif
else
	ilos := MinimumKor( @tab, cenytez )
	if Len( tab ) > 0
		if paform = NIL            && przy zamykaniu dokumentu KOR
			Aadd( tab, '-' )
			Aadd( tab, 'PokazaÊ szczegÛ≥y' )
		endif                && po aktualizacji rÍcznej
		if Alarm( 'UDA SI  skorygowaÊ ' + AllS( ilos ) + ' ' +;
			if( ilos = 1, 'korektπ poniøszego dokumentu',;
		                   'korektami poniøszych dokumentÛw' ),;
		         tab, 1 ) = Len( tab )
		      ViewDBF( 'ANALIZAB' )
		endif
	else
		ilos := 0
	endif
endif

Select( 'ANALIZAB' )
wy := 2
go top

if ilos > 0
   if Alarm( 'GenerowaÊ ' + AllS( ilos ) + ' ' +;
         if( ilos = 1, 'korektÍ',;
            if( ilos < 5, 'korekty (lub mniej :)', 'korekt (lub mniej :)' )) + ' ?', nt, 1 ) # 2
      ilos := 0
   endif
endif

return ilos

******************************************************************************
* Minimalna iloúÊ korekt

function MinimumKor( mm, cenytez )

local xx, x, i, k, n, h, ok, vtab, htab, koniec, sc := SaveScreen(), ros, sio, recznie
local tabrc, tabwc, ic := 0, global_t1c, global_t2c, global_t3c

private tab := {}, tabk := {}, tabr := {}, tabw := {}, jedynki

x := 0
xx := 0
jedynki := 0

global_ta1:= {}     && identyfikatory towarÛw do korekty
global_ta2:= {}     && iloúci towarÛw do korekty
if cenytez
	global_ta3:= {}     && ceny towarÛw do korekty
else
	global_ta3:= NIL    && ceny towarÛw do korekty
endif

Czek( 1 )

ON( 'ANALIZAP' )
ON( 'ANALIZAB', 1 )
if Eof(); return 0; endif
while !Eof()
		if ILEDOKUM = 1; skip; loop; endif		&& jedynki juø sπ jedynkami
		i := 0
		k := 0
		n := 0
	   Select( 'ANALIZAP' )
   	DBSeek( Str( ANALIZAB->ID_T ))
	   while ANALIZAB->ID_T = ANALIZAP->ID_T .and. !Eof()
			if cenytez .and. ( ANALIZAB->CENA # ANALIZAP->CENA )
				skip
				loop
			endif
			if n # 0
				h := RecNo()	&& tu
				DBGoTo( n )		&& poprzedni
				i += ILOSC		&& poprzednia iloúÊ
				DBGoTo( h )		&& wrÛÊ tu
			endif
			k += ILOSC
			n := RecNo()		&& pamiÍtaj poprzeni
	      skip
   	enddo
	   Select( 'ANALIZAB' )
		if ( -ILOSC > i ) .and. ( -ILOSC <= k )	&& do przedostatniego nie starcza≥o i dopiero ostatni dope≥ni≥
			Blokuj_R()
			ANALIZAB->ILEDOKUM := 1
			OdBlokuj_R()
		endif
		skip
enddo

ON( 'ANALIZAP' )
ON( 'ANALIZAB', 2 )
if Eof(); return 0; endif
while !Eof()
	Aadd( global_ta1, ANALIZAB->ID_T )
	Aadd( global_ta2, ANALIZAB->ILOSC )	&& ujemna
if cenytez
	Aadd( global_ta3, ANALIZAB->CENA )
endif
   Select( 'ANALIZAP' )
   DBSeek( Str( ANALIZAB->ID_T ))
   while ANALIZAB->ID_T = ANALIZAP->ID_T .and. !Eof()
		if cenytez .and. ( ANALIZAB->CENA # ANALIZAP->CENA )
			skip
			loop
		endif
      ok := .f.      && namierzony ?
      for i := 1 to Len( tabr )
         if tabr[ i ] = ID_D
            ok := .t.      && tak
            exit
         endif
      next
      if !ok               && jeszcze nie, wiÍc
         Aadd( tabr, ID_D )   && dodaj do namierzonych
			if ANALIZAB->ILEDOKUM = 1
				jedynki ++
			endif
      endif
      Aadd( tabw, { ID_D, ILOSC })
      skip
   enddo
   Aadd( tab, tabw ); tabw := {}
   Aadd( tabk, -ANALIZAB->ILOSC )      && tabela koniecznych korekt
   Select( 'ANALIZAB' )
   skip
enddo

Czek( 0 )

sio := .f.
recznie := .f.
ros := ( Alarm( 'W jaki sposÛb szukaÊ;minimalnej iloúci korekt ?', { 'od do≥u', 'od gÛry' }, 1 ) = 1 )
i := if( ros, jedynki, Len( tabr ))

if haker

if ( i := Get_U( 10, 10, 'Start od ilu korekt ?:', '9999', i )) = NIL
	i := 0
	sio := .t.
endif

if ( i > 0 ) .and. ( recznie := ( Alarm( 'Chcesz rÍcznie zainicjowaÊ wskaüniki ?', nt, 1 ) = 2 ))
   tabw := {}
   for k := 1 to i         && inicjowanie "i" wskaünikÛw
		if k = 1
			n := k
		else
			n := tabw[ k - 1 ] + 1
		endif
      n := Get_U( 10, 10, 'Podaj Nr ' + AllS( k ), '999', n )  && tabela wskaünikÛw na elementy "tabr"
      Aadd( tabw, n )      && tabela wskaünikÛw na elementy "tabr"
   next
endif

endif

@ 0, 0 say PadR( 'Testy dla ilu korekt ? ' + AllS( i ), mc )
while !sio
   @ 0, 0 say PadR( 'Testy dla ilu korekt ? ' + AllS( i ), mc/2 )
	Przerwa( Len( tabr ))
	if recznie
		recznie := .f.
	else
	   tabw := {}
   	for k := 1 to i         && inicjowanie "i" wskaünikÛw
	      Aadd( tabw, k )      && tabela wskaünikÛw na elementy "tabr"
   	next
	endif
   ok := .f.
   while !sio
      koniec := .f.
      while !DobryUklad( tabw )
         if !ZmienUklad( @tabw, jedynki ) && nie zmieni≥ uk≥adu
            koniec := .t.        && wiÍc koniec wariacji
            exit           && wyjúcie z powodu braku wariacji
         endif
			if Inkey() = 27
				sio := .t.
				exit
			endif
      enddo
      if koniec            && koniec wariacji tych rozwiπzaÒ
         exit              && wyjdü
      else
         if ( ok := Sprawdz( tabw ))
            exit
         else
            if !ZmienUklad( @tabw, jedynki ) && nie zmieni≥ uk≥adu
               exit           && wyjúcie z powodu braku wariacji
            endif
         endif
      endif


*		x := tabw[ Min( jedynki + 1, Len( tabw ))]
*		if x # xx
*			xx := x
*			@ 0, 40 say x    && 100 * ( x / ( Len( tabr ) - tabw[ Max( jedynki, 1 )])) picture '999%'
*		endif

*		@ 2, 0 say ''
*		for k := 1 to Len( tabw )
*			?? tabw[ k ]
*		next
*		?? Space( 20 )

		if Przerwa(); sio := .t.; endif

		if sio .or. Inkey() = 27
			if haker .and. ( tabw # NIL )
				@ 1, 0 say ''
				for k := 1 to Len( tabw )
					?? tabw[ k ]
				next
				?? Space( 20 )
			endif
			if tabwc = NIL
				sio := ( Alarm( 'Nie ma jeszcze korekt !;Mimo wszystko koniec ?', nt ) = 2 )
			else
				sio := ( Alarm( 'Teraz jest ' + AllS( ic ) + ' korekt !;Teraz koniec ?', nt ) = 2 )
			endif
		endif
   enddo

	Przerwa( 0 )	

	if sio
		global_ta1 := global_t1c
		global_ta2 := global_t2c
		global_ta3 := global_t3c
		tabw := tabwc
		tabr := tabrc
		i := ic
		exit
	endif
	if ros
	   if ok; exit; endif      && mamy rozwiπzanie !!!
		i ++
		if i > Len( tabr )
			exit
		endif
	else
	   if ok					      && mamy rozwiπzanie !!!
			global_t1c := global_ta1
			global_t2c := global_ta2
			global_t3c := global_ta3
			ic := i
			tabrc := AClone( tabr )
			tabwc := AClone( tabw )
			h := 'Obecne korekty: ' + AllS( i )
			@ 0, mc - Len( h ) say h
		endif
		i --
		if i < 1
			global_ta1 := global_t1c
			global_ta2 := global_t2c
			global_ta3 := global_t3c
			tabw := tabwc
			tabr := tabrc
			i := ic
			exit
		endif
	endif
enddo                 && nie mamy wiÍc trzeba wiÍcej korekt

mm := {}
global_tab := {}     && identyfikatory dokumentÛw do korekty
for k := 1 to i
	if Len( tabw ) >= k .and. Len( tabr ) >= tabw[ k ]
	   Aadd( global_tab, tabr[ tabw[ k ]])
	   Aadd( mm, AllTrim( DOKUM->( GetPole( 1, 'tabr[tabw[' + AllS( k ) + ']]', 'INDEKS' ))) + ' / ' + DtoC( DOKUM->DATAS ))
	endif
next

RestScreen( ,,,, sc )

if haker .and. ( tabw # NIL )
		@ 1, 0 say ''
		for k := 1 to Len( tabw )
			?? tabw[ k ]
		next
		?? Space( 20 )
endif

return i

******************************************************************************
* Poprzesuwaj wskaüniki

function ZmienUklad( tabw, jedynki )

local i, j, k

i := Len( tabw )
while .t.
	if i <= jedynki; return .f.; endif	&& nie zmieniaj uk≥adu poniøej progu jedynek
   tabw[ i ] := tabw[ i ] + 1			&& dalej
				@ 0, 0 say tabw[ i ]
   if tabw[ i ] > Len( tabr ) - ( Len( tabw ) - i )	&& za daleko
	   tabw[ i ] := tabw[ i ] - 1		&& cofnij
      i --									&& a poprzedni dalej
		if i < 1; exit; endif
		for j := i + 1 to Len( tabw )
		   tabw[ j ] := tabw[ i ] + j + 1 - i		&& cofnij tuø za poprzedniego
		next
				@ 1, 0 say ''
				for k := 1 to Len( tabw )
					?? tabw[ k ]
				next
				?? Space( 20 )
   else
      exit
   endif
enddo

return i > 0			&& i <= Len( tabw )

******************************************************************************
* Dobry to taki gdzie dwa wskaüniki nie pokazujπ na taki sam element

function DobryUklad( tabw )

local i, j

for i := 1 to Len( tabw )
   for j := i + 1 to Len( tabw )
      if tabw[ i ] = tabw[ j ]   && taki sam
         return .f.        && nie dobry uk≥ad
      endif
   next
next

return .t.

******************************************************************************

procedure Sprawdz( tabw )

local i, j, k, n, w, ok := .t.

for i := 1 to Len( tab )
   n := 0
   for j := 1 to Len( tabw )
      for k := 1 to Len( tab[ i ])
         if tab[ i, k, 1 ] = tabr[ tabw[ j ]]
            n += tab[ i, k, 2 ]
            exit
         endif
      next
   next
   if !( ok := ( n >= tabk[ i ]))
      exit
   endif
next

return ok

******************************************************************************
* a = domyûlna sekwencja dla NewSysDopisz( a )
* b = kwota wp'acona dotÜd, np. za zamÛwienie
* w - warunek do generowania, np.: RabatZero()
* przeci - przeciwne iloúci w stosunku do dokumentu ürÛd≥owego

function Generowanie( xa, xb, xw, xprzeci )

local a := xa, b := xb, w := xw, przeci := xprzeci
local v3, ty, uzu, roz, wag, warunek, warunekC := .f., wx := 0
local rr := DOKUM->( RecNo()), ii := DOKUM->( IndexOrd())

private dknr, dkdt, dkdd, wa, pc, dw, ds, wp, st, do, rozlacz := .f.
private formularzd := ' ', formularzz := ' '

SPEC->( DBSetOrder( 1 ))
Select( 'DOKUM' )

warunek := ( w # NIL .and. !Empty( w ))
przeci := if( przeci = NIL, .f., przeci )
roz := ( DOKTYPY->( ROZLICZ ) == 'T' )     && rozliczeniowy
uzu := (( b # NIL ) .and. roz )            && uzupe≥nienie
pc := przeci

if uzu
   wa := DOKUM->WARTOSC - b
   if wa = 0; return 0; endif
endif

if a = NIL
   if Empty( DOKTYPY->( formularzz ))
      a := 'DOKUM,Generowany dokument,,,73,DOKTYPY->(DokIncNr(DOKUM->TYP)),,,18'
   else
      a := AllTrim( DOKTYPY->( formularzz )) + ',Generowany dokument,,,73,DOKTYPY->(DokIncNr(DOKUM->TYP)),,,18'
   endif
endif

dkdd := DOKUM->TYP
if !Empty( DOKUM->NUMERFD )
	dknr := DOKUM->NUMERFD
	dkdt := DOKUM->DATAO
else
	dknr := AllTrim( dkdd ) + ' ' + AllTrim( DOKUM->INDEKS )
	dkdt := DOKUM->DATAS
endif
do := DOKUM->ID						&& stary

Ustaw("globalbuf", DOKTYPY->TYP )
DOKUM->( DBSetOrder( 3 ))
set filter to

if warunek

   ON( 'SPEC', 1, 'ROBOCZY', 'ROB' )      && baza docelowa o pseudo rob
   ON( 'SPEC', 1, 'ROBOCZY', 'ROB', .t. ) && ZAP rob w katalogu 'cat'

   Select( 'DOKUM' )
   warunekC := ( Left( w, 1 ) == '+' )		&& ca≥kowity, np .: +WieleKorekt
   if warunekC							&& czyli ca≥kowicie
      w := SubStr( w, 2 )					&& zastÍpujπcy normalny
      w := StrTran( w, '()', '(par)' )		&& zastÍpujπcy normalny
      RunCommand( w,,,, 1 )				&& tok procedury
   endif
   KopiujRec( "DOKUM", "DOKUM" )
   if uzu
      AppendRecord("DOKUM",{GetLast(1,1)+1,"O",globalbuf,"",,,,,dkdt,,'kompensata',wa,dknr}, 1 )
   else
      AppendRecord("DOKUM",{GetLast(1,1)+1,"O",globalbuf,"",,,dw,ds,dkdt,,'kompensata',wp,dknr}, 1 )
	DOKUM->INDEKS:=DOKTYPY->(DokMaska(globalbuf,DOKUM->INDEKS))
	DOKUM->DATAT:=DATAS+7
	DOKUM->( ON( 'OSOBY' ))
	OSOBY->( DBGoTo( 1 ))
	DOKUM->WYSTAWIL:=OSOBY->NAZWA
	DOKTYPY->( Blokuj_R())
	DOKTYPY->NUMER:=DOKTYPY->NUMER+1
   endif
	if warunekC
      RunCommand( w,,,, 2 )
	elseif !roz
		if rozlacz := ( Left( w, 1 ) == '-' )
			w := SubStr( w, 2 )
		endif
      SPEC->( DBSeek( do ))
      KopiaRec( 'SPEC', 'ROB', {|| SPEC->ID_D = do },, w, {|| if( ROB->( !Eof()), AppendRecord( 'ROB', { DOKUM->ID }, 1 ),), .f. })
		if rozlacz
			rozlacz := ( ROB->( LastRec()) # 0 )
		endif
   endif
   Select( 'ROB' )
   DokumLicz( 'ROB->ID_T', 'VAT',, 1 )
   Select( 'DOKUM' )
	if DOKUM->WARTOSC = 0.00
		rozlacz := NIL		//wycofaj siÍ z tworzenia tego dokumentu
	elseif rozlacz
		if DOKUM->WPLACONO > DOKUM->WARTOSC
			wx := DOKUM->( WPLACONO - WARTOSC )
			DOKUM->( Blokuj_R())
			DOKUM->WPLACONO := DOKUM->WARTOSC
		endif
	endif

	if rozlacz # NIL
//	   NewSysForm( a )		//nie edytuj tego co do wycofania
	endif
*private vp := { 0, 0, 0, DOKUM->WPLACONO, DOKUM->DATAW, 'got¢wka' }
*DOKUM->( SetNaleznosci())
else
   if uzu
      NewSysDopisz( a, 1,, 'AppendRecord("DOKUM",{GetLast(1,1)+1,"O",globalbuf,"",,,,,dkdt,,,wa,dknr},1)')
   else
      NewSysDopisz( a, 1,, 'AppendRecord("DOKUM",{GetLast(1,1)+1,"O",globalbuf,"",,,,,dkdt,,,,dknr},1)')
   endif
endif

if rozlacz = NIL .or. LastKey() = 27
   if rozlacz = NIL .or. warunek; BDelete(); endif   
	rozlacz := .f.
else

   st := do								&& stary
   do := DOKUM->ID						&& nowy
   wa := WPLACONO
   dkdd := DOKUM->TYP
   dknr := DOKUM->INDEKS
   dkdt := DOKUM->DATAS

   if !roz
      if !warunek
         ON( 'SPEC', 1, 'ROBOCZY', 'ROB' )      && baza docelowa o pseudo rob
         ON( 'SPEC', 1, 'ROBOCZY', 'ROB', .t. ) && ZAP rob w katalogu 'cat'
      endif

   else
      v3 := ( DOKUM->( Field( 35 )) == 'NETTO3' )
      DOKUM->( Blokuj_R())
      DOKUM->WARTOSC := wa

      DOKUM->NETTO23 := 0
      DOKUM->NETTO22 := 0
      DOKUM->NETTO8  := 0
      DOKUM->NETTO7  := 0
      DOKUM->NETTO5  := 0

      if v3; DOKUM->NETTO3  := 0; endif

      DOKUM->NETTO0  := 0
      DOKUM->NETTOZW := 0

      DOKUM->VAT23 := 0
      DOKUM->VAT22 := 0
      DOKUM->VAT8 := 0
      DOKUM->VAT7 := 0
      DOKUM->VAT5 := 0

      if v3; DOKUM->VAT3 := 0; endif

      DOKUM->NETTOCZ := 0

      DOKUM->( OdBlokuj_R())
   endif

   DOKUM->( DBSetOrder( 1 ))
   DOKUM->( DBSeek( st ))			&& stary
   DOKUM->( DBSetOrder( 3 ))
   DOKUM->( Blokuj_R())
   if Empty( DOKUM->NUMERFD )
	DOKUM->NUMERFD := AllTrim( dkdd ) + ' ' + AllTrim( dknr )
	DOKUM->DATAO := dkdt
   elseif right(DOKUM->TYP,1)=='K'	//stary to korekta rozdzielana na "J", wiÍc musi byÊ tylko do jednej faktury
   else
	DOKUM->NUMERFD := AllTrim( DOKUM->NUMERFD ) + ', ' + AllTrim( dkdd ) + ' ' + AllTrim( dknr )
   endif

   if uzu
      DOKUM->WPLACONO := b + wa     && b = dotÜd wp'acono, wa = teraz wp'acono
   elseif roz
      DOKUM->WPLACONO := wa
   endif

   DOKUM->( OdBlokuj_R())

   if DOKTYPY->( FieldPos( 'ROZLICZ' )) # 0
*     wpisanie zwiÜzku KP( id, typ), FV( id, typ), wa
      Zwiazek( do, dkdd, DOKUM->ID, DOKUM->TYP, if( roz, wa, 0 ))
   endif

   if !warunek .and. !roz
      SPEC->( DBSeek( DOKUM->ID ))
      KopiaRec( 'SPEC', 'ROB', {|| SPEC->ID_D = DOKUM->ID },, w, {|| ROB->ID_D := do, ROB->ILOSC := if( pc, -1, 1 ) * SPEC->ILOSC, .f. })
   endif

   if !roz
      if przeci
        ROB->( DBSetOrder( 3 ))
         ROB->( DBGoTop())
        ROB->( Scal_ROB( 0 ))
      endif
      ROB->( DBSetOrder( 1 ))
      ROB->( DBGoTop())
	if warunekC		&& w korekcie mogπ byÊ pozycje z ILOSC=0
      KopiaRec( 'ROB', 'SPEC' )
	else
      KopiaRec( 'ROB', 'SPEC',,, {|| ROB->ILOSC # 0 })
	endif
   endif

   DOKUM->( DBSetOrder( 1 ))
   DOKUM->( DBSeek( do ))           && nowy
*   rr := DOKUM->( RecNo())

   if przeci
      ROB->( DBGoTop())
      DokumZlicz()
   endif

   DokClose(,,1)                    && bez generowania pe'nej kasy
   wy := 2
   zmiana := .t.

   if ( b # NIL ) .and. ( DOKTYPY->( KASOWY ) == 'T' )   && kasa na pozosta'oûç
      GenerujKASA( DOKUM->( WPLACONO - b ))
   endif

if warunekC
	if RunCommand( w,,,, 4 )	&& naniesienie NETTOCZ i ewentualny wydruk
//	   RunMenu( 66,,1 )      && wydruk orygina'u lub kopii
	endif
else
//   RunMenu( 66,,1 )      && wydruk orygina'u lub kopii
endif

	Select( 'DOKUM' )
	DBSetOrder( ii )
	DBGoTo( rr )

	if rozlacz		&& usuwanie ze ürÛd≥a przeniesionych pozycji
		if DOKUM->WPLACONO # 0.00
			DOKUM->( Blokuj_R())
			DOKUM->WPLACONO := wx
*		private vp := { 0, 0, 0, DOKUM->WPLACONO, DOKUM->DATAW, 'got¢wka' }
*		DOKUM->( SetNaleznosci())
		endif
		SPEC->( DBSeek( DOKUM->ID ))
		while SPEC->ID_D = DOKUM->ID .and. SPEC->( !Eof())
				if RunCommand( w )
					SPEC->( BDelete())
				endif
				SPEC->( DBSkip())
		enddo
		SPEC->( DokumLicz( 'SPEC->ID_T', 'VAT',, 1, DOKUM->ID ))
	endif
endif

Select( 'DOKUM' )
DBSetOrder( ii )
DBGoTo( rr )

if warunekC		&& w korekcie mogπ byÊ pozycje z ILOSC=0
	if RunCommand( w,,,, 3 )
		Generowanie( xa, xb, xw, xprzeci )
	endif
endif

return if( rozlacz, 1, 0 )

******************************************************************************
* Funkcja wspÛ≥pracuje z "Generowanie"
* Jest stosowana w "Warunkach do generowania" z plusem ("+WieleKorekt")
* Korzysta z "global_tab" (identyfikatory dokumentÛw do korekty)

function WieleKorekt( krok )

local idd, bb := Alias(), ii := IndexOrd(), rr := RecNo(), klucz, i, r, sc := SaveScreen()

do case
case krok = 1			&& ustawienie siÍ na dokumencie do korekty

	if Len( global_tab ) = 0 .or. global_tab[ 1 ] = NIL; return; endif
	idd := global_tab[ 1 ]
	global_tab := ADel( global_tab, 1 )
	DOKUM->( DBSetOrder( 1 ))
	DOKUM->( DBSeek( idd ))
	do := DOKUM->ID						&& stary
	dkdd := DOKUM->TYP
	dknr := AllTrim( dkdd ) + ' ' + AllTrim( DOKUM->INDEKS )
	dkdt := DOKUM->DATAS
	dw := Datee()
	ds := Datee()
	wp := 0

case krok = 2			&& okreúlenie specyfikacji do korekty

	SPEC->( DBSeek( do ))
	KopiaRec( 'SPEC', 'ROB', {|| SPEC->ID_D = do },,, {|| if( ROB->( !Eof()), AppendRecord( 'ROB', { DOKUM->ID }, 1 ),), .f. })

	Select( 'DOKUM' )
	DBSetOrder( 4 )	&& Str(NABYWCA)+DtoS(DATAS)
	DBSeek(( klucz := Str( NABYWCA )) + DtoS( dkdt ))
	while ( klucz == Str( NABYWCA )) .and. !Eof()
		if ( dknr $ DOKUM->NUMERFD );
			.and.;
			( dkdt = DATAO );
			.and.;
			( RecNo() # rr )
				? 'Jest korekta ' + AllTrim( DOKUM->TYP ) + ' ' + AllTrim( DOKUM->INDEKS ) + ' z dnia ' + DtoC( DOKUM->DATAS ) +;
                       '; do faktury ' + AllTrim( dknr ) + ' z dnia ' + DtoC( dkdt )
				SPEC->( DBSeek( DOKUM->ID ))
				KopiaRec( 'SPEC', 'ROB', {|| SPEC->ID_D = DOKUM->ID },,, {|| if( ROB->( !Eof()), AppendRecord( 'ROB', { do }, 1 ),), .f. })
				Select( 'ROB' ); DBSetOrder( 3 ); DBGoTop(); Scal_ROB( 0 )
		endif
		Select( 'DOKUM' )
		skip
	enddo

	Select( 'ROB' )
	DBSetOrder( 0 )
	DBGoTop()				&& robimy "By≥o"
	while !Eof()
		ROB->ILOSC := -ROB->ILOSC
		if ROB->ILOSC > 0
			? 'Jest minus na fakturze po korektach !;Nie da siÍ prawid≥owo okreúliÊ dokumentu.;' + AllTrim( dknr ) + ' z dnia ' + DtoC( dkdt )
			ROB->ILOSC := 0
		endif
		skip
	enddo

	DBSetOrder( 0 )
	DBGoTop()				&& robimy "Jest"
	while !Eof()

		if ROB->ILOSC < 0
			r := RecNo()
			KopiujRec( 'ROB', 'ROB' )
			ROB->ILOSC := -ROB->ILOSC				&& plus
			for i := 1 to Len( global_ta1 )
				if ROB->ID_T = global_ta1[ i ] .and. if( global_ta3 # NIL, ROB->CENA = global_ta3[ i ], .t. )
					ROB->ILOSC += global_ta2[ i ]	&& zmniejsz
					if ROB->ILOSC < 0				&& za bardzo
						global_ta2[ i ] := ROB->ILOSC	&& reszta
						ROB->ILOSC := 0				&& do zera
					else
						global_ta2[ i ] := 0
					endif
					exit
				endif
			next
			DBGoTo( r )
		endif
		skip
	enddo

	if Jest_baza( bb )
		DBSetOrder( ii )
		DBGoTo( rr )
	endif

case krok = 3			&& okreúlenie wyjúcia

	if Len( global_tab ) = 0 .or. global_tab[ 1 ] = NIL; RestScreen(,,,,sc); return .f.; endif

endcase

RestScreen(,,,,sc)

return .t.

******************************************************************************

procedure DokAnaN( h )

local bb := Alias(), idt, i, x

if Get_Okres( @data1, @data2 ) = NIL; return; endif

Czek( 1 )
DBZap('')
ON( 'TOWARK' )
ON( 'TOWARKS' )
while !Eof()
		if ( data1 <= TOWARKS->DATA ) .and. ( TOWARKS->DATA <= data2 )
			idt := TOWARK->( GetPole( 1, 'TOWARKS->ID_K', 'ID_T' ))
			if !( bb )->( DBSeek( idt ))
				AppendRecord( bb, { idt })
			endif
			if ( 0 # ( i := ( bb )->( FieldPos( 'ROK' + AllS( Year( TOWARKS->DATA ) - Year( data1 ) + 1 )))))
				( bb )->( FieldPut( i, TOWARKS->NAKLAD + FieldGet( i )))
			endif
		endif
		if Przerwa(); exit; endif
		skip
enddo
Przerwa( 0 )

Select( bb )
go top
IncDBES( 1 )
while !Eof()
		IncDBES()
		skip
enddo

go top
wy := 2
Czek( 0 )

h := h + ' w okresie ' + DtoC( data1 ) + '-' + DtoC( data2 )

DBE_Tyt := h

PutIni()
*ShowDBES( 1 )
DBE_Tyt := h

******************************************************************************
* Przetworzenie parametr¢w wyrobu gotowego w parametry surowc¢w
* iinwg - indeks indeksu wg
* iilwg - indeks iloûci wg
* iwspr - indeks rozciÜgni'cia
* isur1 - indeks surowca 1

* r, c - wsp¢'rz'dne pierwszego pola "iloûç" surowc¢w
* cc - kolumna indeks¢w surowc¢w ( wiersz ten sam co j.w. )
* sep - separator parametr¢w surowc¢w w indeksie wyrobu gotowego
* si - sprawdz indeks towaru
* cfpre - character function pre

procedure WG2SUR( iinwg, iilwg, iwspr, isur1, r, c, cc, sep, si, cfpre )

static idt := 0

local bb := Alias(), rrt, le := 32, pi := '@Z 999,999,999.99', ok := .f.
local in := vp[ iinwg ]
local il := vp[ iilwg ]
local wr := vp[ iwspr ]
local mianownik, a
local n := 5                                && maksymalna iloûç surowc¢w
local tisu[ n ], twsu[ n ], tzdw[ n ], i

*RunCommand( cfpre )

if si # NIL
   if !GdyBrak('TOWARY,2,Upper(buf_sys),PressKey("F1")',.t.)
      return .f.
   endif
	idt := TOWARY->ID
	@ Row(), Col() + 1 say PadR( TOWARY->NAZWA, si )
endif

if ZAMOW->STATUS # "O"; return .t.; endif && jak zamkni'te, to nie pokazuj
                                          && bo juß jest wszystko ustalone
                                          && i to byç moße lepiej bo r'cznie
if cc = NIL; cc := c - 33; endif
if sep = NIL; sep := ' '; endif

for i := 1 to n; tisu[ i ] := ''; next
for i := 1 to n; twsu[ i ] := 0 ; next
for i := 1 to n; tzdw[ i ] := 1 ; next

if File( 'TOWARYR.DBF' )	&& Mykogen JM
	i := 0
	le := 15
	pi := '@Z 999,999?999999'
	rrt := TOWARY->( RecNo())
	ON( 'TOWARYR' )
	DBSeek( idt )
	if LastKey() = 13						&& enter przelicza, s.wdÛ≥ nie przelicza
		while idt = ID_T .and. !Eof()
			i ++
			if i <= n
				tisu[ i ] := GetPole( 1, 'TOWARYR->ID_S', 'INDEKS', 'TOWARY' )
				Select( 'TOWARYR' )
				twsu[ i ] := ILOSC * il
			endif
			skip
		enddo
		TOWARY->( DBGoTo( rrt ))
		ok := .t.
	endif
	Select( bb )

else		&& Mistral

	i := 1
	while !Empty( in )            && rozpykanie poszczeg¢lnych symboli surowc¢w
	   a := Left( in, 1 )
   	if a == sep
         i ++
      else
         tisu[ i ] += a
      endif
      in := SubStr( in, 2 )
	enddo

	for i := 1 to n               && rozpykanie zdwoje§ i wartoûci parametr¢w
    in := tisu[ i ]
    if !Empty( in )
       if IsDigit( in )
          tzdw[ i ] := Val( Left( in, 1 ))         && zapami'taj zdwojenie
          tisu[ i ] := SubStr( tisu[ i ], 2 )      && pokaß bez zdwojenia
       endif
       while .t.
             in := SubStr( in, 2 )
             if Empty( in ) .or. IsDigit( in ); exit; endif
       enddo
       twsu[ i ] := Val( in )
    endif
	next

	if wr = 0; return .t.; endif

	twsu[ 1 ] := twsu[ 1 ] / wr                                && 20 / 3 = 7
	for i := 2 to n; twsu[ i ] := twsu[ i ] * tzdw [ i ]; next

	mianownik := 0
	for i := 1 to n; mianownik += twsu[ i ]; next

	if mianownik = 0; return .t.; endif

	for i := 1 to n; twsu[ i ] := Round( il * ( twsu[ i ] / mianownik ), 2 ); next

	mianownik := 0
	for i := 1 to n; mianownik += twsu[ i ]; next
	twsu[ 1 ] += il - mianownik     && r¢ßnice z zaokrÜgle§ wrzucaj do elastyny

	ok := .t.

endif

if ok
	for i := 1 to n; vp[ isur1 + i - 1 ] := twsu[ i ]; next     && wartoûci
	for i := 1 to n
    if Empty( vp[ isur1 + i - 1 - n ]);
      .or.;
      Len( AllTrim( vp[ isur1 + i - 1 - n ])) = Len( tisu[ i ])
         vp[ isur1 + i - 1 - n ] := PadR( tisu[ i ], le )     && indeksy
    endif
	next
endif

SetColor( Right( STC, 3 ))             && pokaß na ekranie
for i := 1 to n
    @ r + i - 1, cc say vp[ isur1 + i - 1 - n ] picture '@K!S' + AllS( le )
    @ r + i - 1, c say Tra( vp[ isur1 + i - 1 ], pi )
next
SetColor( STC )

return .t.

******************************************************************************
* Zwraca pierwszπ datÍ w roku i ustawia przesuniÍcie w zmiennej "n"
* n = delta przesuniÍcia (przez zmiennπ !!!)

function BaseDate( dt, n, r )

local nd

if dt = NIL; dt := Datee(); endif
if r = NIL .or. r = 0; r := Year( dt ); endif
dt := CtoD( '01.01.' + AllS( r ))
nd := Left( CDoW( dt - 1 ), 2 )

do case
case nd = 'po'; n := 0
case nd = 'wt'; n := 1
case nd = 'ûr'; n := 2
case nd = 'cz'; n := 3
case nd = 'pi'; n := 4
case nd = 'so'; n := 5
case nd = 'nd'; n := 6
endcase

return dt

******************************************************************************

procedure gloDATAT( bez )

if bez = NIL
	globalbuf := if( Empty( ZAMOW->DATAT ), Space( 10 ), DtoC( ZAMOW->DATAT ))
else
	globalbuf := Space( 10 )
endif

******************************************************************************
* t - tydzieÒ
* d - data
* p - pole

function NormujDate( t, d, p )

local x, i, tt, dd, ok := .f.

tt := vp[ t ]
dd := vp[ d ]

if Empty( Left( dd, 1 ))
	ZAMOW->( Blokuj_R())
	ZAMOW->DATAT := CtoD( '' )
	vp[ d ] := DtoC( ZAMOW->DATAT )
	return .t.
endif

x := Date4Ty( tt )
for i := 1 to 7
	if Day( x ) = Val( Left( dd, 2 ))
		vp[ d ] := DtoC( x )
		ok := .t.
		exit
	endif
	x++
next

if ok
	Show_Dzien( '15', 'CtoD(vp[' + AllS( d ) + '])' )
	ZAMOW->( Blokuj_R())
	ZAMOW->DATAT := CtoD( vp[ d ])
else
	Alarm( 'W wybranym tygodniu brak takiego dnia' )
endif

return ok

******************************************************************************
* Pierwszy dzieÒ podanego numeru tygodnia

function Date4Ty( x, r )

local dt, n

if r = NIL .or. ( x # Int( x ))
	r := 100 * ( x - Int( x )) + 2000
endif

dt := BaseDate( dt, @n, r )

return dt + ( Int( x ) - 1 ) * 7 - n

******************************************************************************
* Numer tygodnia podanej daty

function Date2Ty( te, dt, n, r )

local x

if r = NIL
	if te = NIL .or. Empty( te )
		te := Datee()	
	endif
	r := Year( te )
endif

if dt = NIL .or. n = NIL
	dt := BaseDate( dt, @n, r )
endif

if dt > te
	dt := BaseDate( te, @n, r )
endif

if Year( dt ) # Year( te )
	dt := BaseDate( te, @n, r )
endif

x := te - dt + n
x := Int( x / 7 ) + 1
x := x + Val( Right( AllS( r ), 2 )) * 0.01

return x

******************************************************************************
* dni = dni do przodu od dziú
* mode = NIL = pyta
* mode # NIL = bez pytaÒ
* mode = 1 - tygodniami
* mode = 2 - tydzieÒ dniami
* bez = po wyjúciu z podglπdu zamÛwieÒ bez zmiany "data_do, data_do"

procedure AktZam( mode, dni, bez )

local dt, n, x, idt, te, s, ii := IndexOrd()

if AktZamDaty( @mode, @dni, @bez, @dt ) = NIL; return; endif

DBZap('')

ON( 'ZAMOWTS', 2 )
DBZap('')

ON( 'ZAMOW' )

while !Eof()
	te := DATAT
	if Empty( te ) .or. ( data_od <= te .and. te <= data_do )
		if Empty( te )
			x := TYDZIEN
			te := Date4Ty( x )
			if !( data_od <= te .and. te <= data_do )
				skip
				loop
			endif
		else
			x := Date2Ty( DATAT, dt, n )
		endif

		s := x
		ZAMOWT->( DBSetOrder( 1 ))
		if mode = 2
			ZAMOWT->( DBSetOrder( 2 ))
			s := Str( x, 5, 2 ) + DtoS( te )
		endif

		if ZAMOWT->( !DBSeek( s ))
			ZAMOWT->( DBAppend())
			ZAMOWT->ID := x
			if mode = 2
				ZAMOWT->DATAT1 := te
			else
				ZAMOWT->DATAT1 := Date4Ty( x )
				ZAMOWT->DATAT2 := Date4Ty( x + 1 ) - 1
			endif
		endif
		ZAMOWT->ILEZAM := ZAMOWT->ILEZAM + 1
		ZAMOWT->ILEKOS := ZAMOWT->ILEKOS + KOSTKI
		ZAMOWT->ILELUZ := ZAMOWT->ILELUZ + if( KOSTKI = 0, WGILOSCT, 0 )
		ZAMOWT->ILETOW := ZAMOWT->ILETOW + WGILOSCT

		idt := GetPole( 2, 'Upper(ZAMOW->WGINDP)', 'ID', 'TOWARY' )
		Select( 'ZAMOW' )
		if !Empty(idt)
			if ZAMOWTS->( !DBSeek( Str( x, 5, 2 ) + Str( idt, 10 )))
				AppendRecord( 'ZAMOWTS', { x, idt,, 'ton' })
			endif
			ZAMOWTS->ILE   := ZAMOWTS->ILE + WGILOSCT
		endif

		ZAMOWT->ILES2  := ZAMOWT->ILES2  + S2ILOSCT

		idt := GetPole( 2, 'Upper(ZAMOW->S2INDP)', 'ID', 'TOWARY' )
		Select( 'ZAMOW' )
		if !Empty(idt)
			if ZAMOWTS->( !DBSeek( Str( x, 5, 2 ) + Str( idt, 10 )))
				AppendRecord( 'ZAMOWTS', { x, idt,, 'kg' })
			endif
			ZAMOWTS->ILE   := ZAMOWTS->ILE + S2ILOSCT
		endif

		ZAMOWT->ILES3  := ZAMOWT->ILES3  + S3ILOSCT

		idt := GetPole( 2, 'Upper(ZAMOW->S3INDP)', 'ID', 'TOWARY' )
		Select( 'ZAMOW' )
		if !Empty(idt)
			if ZAMOWTS->( !DBSeek( Str( x, 5, 2 ) + Str( idt, 10 )))
				AppendRecord( 'ZAMOWTS', { x, idt,, 'kg' })
			endif
			ZAMOWTS->ILE   := ZAMOWTS->ILE + S3ILOSCT
		endif

		ZAMOWT->ILES4  := ZAMOWT->ILES4  + S4ILOSCT

		idt := GetPole( 2, 'Upper(ZAMOW->S4INDP)', 'ID', 'TOWARY' )
		Select( 'ZAMOW' )
		if !Empty(idt)
			if ZAMOWTS->( !DBSeek( Str( x, 5, 2 ) + Str( idt, 10 )))
				AppendRecord( 'ZAMOWTS', { x, idt,, 'kg' })
			endif
			ZAMOWTS->ILE   := ZAMOWTS->ILE + S4ILOSCT
		endif

		ZAMOWT->ILES5  := ZAMOWT->ILES5  + S5ILOSCT

		idt := GetPole( 2, 'Upper(ZAMOW->S5INDP)', 'ID', 'TOWARY' )
		Select( 'ZAMOW' )
		if !Empty(idt)
			if ZAMOWTS->( !DBSeek( Str( x, 5, 2 ) + Str( idt, 10 )))
				AppendRecord( 'ZAMOWTS', { x, idt,, 'kg' })
			endif
			ZAMOWTS->ILE   := ZAMOWTS->ILE + S5ILOSCT
		endif

		x --									&& poprzedni tydzieÒ
		if x < 1			&& np.: 0.03
			x := 52 + (( x - Int( x )) - 0.01 )		&& 0.03 -> 52.02
		endif

		te := te - 7

		s := x
		ZAMOWT->( DBSetOrder( 1 ))
		if mode = 2
			ZAMOWT->( DBSetOrder( 2 ))
			s := Str( x, 5, 2 ) + DtoS( te )
		endif

		if ZAMOWT->( !DBSeek( s ))
			ZAMOWT->( DBAppend())
			ZAMOWT->ID := x
			if mode = 2
				ZAMOWT->DATAT1 := te
			else
				ZAMOWT->DATAT1 := Date4Ty( x )
				ZAMOWT->DATAT2 := Date4Ty( x + 1 ) - 1
			endif
		endif
		ZAMOWT->ILES1  := ZAMOWT->ILES1  + S1ILOSCT
		buf := 'ZAMOWT->TUNEL' + AllS( ZAMOW->TUNEL )
		&buf := &buf + S1ILOSCT

		idt := GetPole( 2, 'Upper(ZAMOW->S1INDP)', 'ID', 'TOWARY' )
		Select( 'ZAMOW' )
		if !Empty(idt)
			if ZAMOWTS->( !DBSeek( Str( x, 5, 2 ) + Str( idt, 10 )))
				AppendRecord( 'ZAMOWTS', { x, idt,, 'ton' })
			endif
			ZAMOWTS->ILE   := ZAMOWTS->ILE + S1ILOSCT
		endif

	endif
	skip
enddo

Select( baza )
DBSetOrder( ii )
go top
wy := 2

******************************************************************************
* dni = dni do przodu od dziú
* mode = NIL = pyta
* mode # NIL = bez pytaÒ
* mode = 1 - tygodniami
* mode = 2 - tydzieÒ dniami
* bez = po wyjúciu z podglπdu zamÛwieÒ bez zmiany "data_do, data_do"

procedure AktZamDaty( mode, dni, bez, dt )

static r
local n, x, x1, x2

do case
case mode = NIL; mode := 1
case Abs( mode ) = 1
		if r = NIL; r := Year( Datee()); endif
		dni := if( dni = NIL, 5*7, dni )
	if bez = NIL
		data_od := CtoD( '01.01.' + AllS( r ))
		data_do := Datee() + dni
	endif
	if mode < 0
		mode := -mode
		x1 := 1 + (( r - 2000 ) * 0.01 )
		x2 := Date2Ty( Datee() + dni, @dt, @n )	&& przysz≥y tydzieÒ
		if Get_okres( @x1, @x2, 'Podaj zakres tygodni:' ) = NIL; return; endif
		x := x2
		data_od := Date4Ty( x1 )
		data_do := Date4Ty( x2 )
		if Get_Okres( @data_od, @data_do ) = NIL; return; endif
	endif
case Abs( mode ) = 2
		dni := if( dni = NIL, 7, dni )
		x := Date2Ty( Datee() + dni, @dt, @n )	&& przysz≥y tydzieÒ
	if bez = NIL
		data_od := Date4Ty( x )
		data_do := Date4Ty( x + 1 ) - 1
	endif
	if mode < 0
		mode := -mode
*		if r = NIL; r := Year( Datee()); endif
*		if ( r := Get_U( 10, 10, 'Podaj rok:', '9999', r )) = NIL; return; endif
		x := Date2Ty( Datee() + dni, @dt, @n ) && przysz≥y tydzieÒ
		if ( x := Get_U( 10, 10, 'Podaj numer tygodnia:', '99.99', x )) = NIL; return; endif
		data_od := Date4Ty( x )
		data_do := Date4Ty( x + 1 ) - 1
		if Get_Okres( @data_od, @data_do ) = NIL; return; endif
	endif
endcase

if dt = NIL
	dt := BaseDate( data_od, @n )
endif

return 1

******************************************************************************
* dni = dni do przodu od dziú
* mode = NIL = pyta
* mode # NIL = bez pytaÒ
* mode = 1 - tygodniami
* mode = 2 - tydzieÒ dniami
* bez = po wyjúciu z podglπdu zamÛwieÒ bez zmiany "data_do, data_do"

procedure AktZamK( mode, dni, bez, h )

local dt, n, x, idt, te, s, ii := IndexOrd(), tab

GetIni(,, @tab )

if AktZamDaty( @mode, @dni, @bez, @dt ) = NIL; return; endif

DBZap('')

ON( 'ZAMOW' )

while !Eof()
	te := DATAT
	if Empty( te ) .or. ( data_od <= te .and. te <= data_do )
		if Empty( te )
			x := TYDZIEN
			te := Date4Ty( x )
			if !( data_od <= te .and. te <= data_do )
				skip
				loop
			endif
		else
			x := Date2Ty( DATAT, dt, n )
		endif

		if ( baza )->( !DBSeek( ZAMOW->NABYWCA ))
		   ( baza )->( DBAppend())
		   ( baza )->ID_F := ZAMOW->NABYWCA
		endif
			
	   ( baza )->KOSTKA += ZAMOW->KOSTKI
	   ( baza )->LUZ += if( ZAMOW->KOSTKI = 0, ZAMOW->WGILOSCT, 0 )
	   ( baza )->MASA += ZAMOW->WGILOSCT
	endif
	skip
enddo

Select( baza )
DBSetOrder( ii )

   go top
   IncDBES( 1 )
   while !Eof()
         IncDBES()
         skip
   enddo

go top
wy := 2

h := h + ' w okresie ' + DtoC( data_od ) + '-' + DtoC( data_do )

DBE_Tyt := h

PutIni()

ShowDBES( 1 )  && bez GETIni() na poczatku
DBE_Tyt := h

******************************************************************************

procedure MAGImport()

local bb := Alias()

ON('MAGAZYNY')

Select('MAGAZYNY')
go top
while !Eof()
     if DOKUMENT->MAG2==MAGAZYNY->MAG
	Select(bb)
	DBAppend()
	replace KOD_TOWARU with MAGAZYNY->KOD_WEW
	replace SYMBOL with MAGAZYNY->SYMBOL
	replace NAZWA with MAGAZYNY->NAZWA
	replace VAT with MAGAZYNY->VAT
	replace CENA with MAGAZYNY->CENA_Z
	replace ILOSC_MAX with MAGAZYNY->ILOSC
	replace ILOSC with MAGAZYNY->ILOSC
     endif
	Select('MAGAZYNY')
	skip
enddo

Select(bb)

******************************************************************************

function DzienVAT0()

return !wysylka ;
         .and.;
             (( DtoS(DOKUM->DATAS)>='20110101' ;
         .and. DtoS(DOKUM->DATAS)<='20110430' ;
         .and. Day(DOKUM->DATAS)/2==Int(Day(DOKUM->DATAS)/2);
         .and. (Left(DOKUM->TYP,1)=='F' .or. Left(DOKUM->TYP,2)=='RW');
         .and. (Left(DOKUM->TYP,2)<>'FZ');
              );
         .or. ( DtoS(DOKUM->DATAS)<'20110101') ;
         .or. (Year(DOKUM->DATAO)<2011 .and. right(DOKUM->TYP,1)=='K');
             )

******************************************************************************

procedure DokKond()

local idd, idt, cen, ilo, rab, cbr, rr1, rr2 

go top
idd := ID_D
idt := ID_T
cen := CENA
ilo := ILOSC
rab := RABAT
cbr := CENABEZR
rr1 := RecNo()
skip

while !Eof()
      sio := .f.
      if     idd = ID_D; 
       .and. idt = ID_T;
       .and. cen = CENA;
       .and. ilo = -ILOSC;
       .and. rab = RABAT;
       .and. cbr = CENABEZR
         sio := .t.
         rr2 := RecNo()
      endif
      idd := ID_D
      idt := ID_T
      cen := CENA
      ilo := ILOSC
      rab := RABAT
      cbr := CENABEZR

      if sio
         go rr1; BDelete()
         go rr2; BDelete()
      endif
      
      rr1 := RecNo()
      skip
enddo

go top

******************************************************************************

procedure DokKond2()

local idd, idt, cen, ilo, rab, cbr, rr1, rr2 

go top
idd := ID_D
cen := CENA_DOK
ilo := ILOSC_DOK
rr1 := RecNo()
skip

while !Eof()
      sio := .f.
      if     idd = ID_D; 
       .and. cen = CENA_DOK;
       .and. ilo = -ILOSC_DOK
         sio := .t.
         rr2 := RecNo()
      endif
      idd := ID_D
      cen := CENA_DOK
      ilo := ILOSC_DOK

      if sio
         go rr1; BDelete()
         go rr2; BDelete()
      endif
      
      rr1 := RecNo()
      skip
enddo

go top

******************************************************************************
