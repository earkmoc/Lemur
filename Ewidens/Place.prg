*****************************************************************************
*************************          Píace         *****************************
******************************************************************************
#include 'Inkey.ch'

******************************************************************************

procedure ZUS( n, x )

if x = NIL; x := ZUSWYNIK->LEN; endif

return PadR( StrTran( AllS( n ), '.', '' ), x )

******************************************************************************

procedure ZUSAktualizuj()

local r, rr, w, ww, ok, x, bb := Alias(), rca, rsa, tylko5, tylkoi, sc := SaveScreen(), dwa, drugi
local rsp, rrsp, rcp, rrcp, idlprac, wolniej := '', testsumasuz := 0

private rsa_kod := '', rsa_od := '', rsa_do := '', rsa_ile := '', rsa_razy := 0, rsa_ktory := 0

if NIL = Get_Okres( @data_od, @data_do, 'Listy píac z okresu:', 10 )
   return
endif

@ 0, 0 say Space( mc )
CSay( 0, 0, mc, 'Ustalenie pracownik¢w aktywnych w podanym okresie', jasny )
ON( 'LPLACP' )
ON( 'LPLAC' )
ON( 'LPRAC' )
SumPolaSuba( 'LISTYP', 'ile', 'LPLACP', 3, 'Str(LPRAC->ID)','LPRAC->ID=LPLACP->ID_PRAC','LPLAC->(GetPole(1,"LPLACP->ID_LPLAC","ID_LPD")) # 0 .and. Between( LPLAC->DATA, data_od, data_do )' )

@ 0, 0 say Space( mc )
CSay( 0, 0, mc, Konwert( 'Obliczanie formu≥', win, maz ), jasny )

r := NIL
rca := .f.
rsa := .f.
drugi := .f.			&& teraz nie leci drugi zapis na tπ osobÍ

ON( 'ZUSWYNIK', 0,,, .t. )
ON( 'ZUSPRA' )
ON( 'ZUSKODY' )
ON( 'ZUSFORM' )
ON( 'ZUSBAZA', 0 )
cls
while !Eof()

		rca := ( AllTrim( POZIOMY ) == 'KEDU/ZUSRCA.DP/ZUSRCA/DDORCA' )
		rcp := ( AllTrim( POZIOMY ) == 'KEDU/ZUSRCA.DP' )
		if rcp .and. ( rrcp = NIL )				&& poczπtek sekcji RCA bazy wynikowej
			rrcp := ZUSWYNIK->( RecNo())
		endif

		rsa := ( AllTrim( POZIOMY ) == 'KEDU/ZUSRSA.DP/ZUSRSA/DDORSA' )
		rsp := ( AllTrim( POZIOMY ) == 'KEDU/ZUSRSA.DP' )
		if rsp .and. ( rrsp = NIL )				&& poczπtek sekcji RSA bazy wynikowej
			rrsp := ZUSWYNIK->( RecNo())
		endif

		if ( rca .or. rsa ) .and. ( r = NIL )			&& poczπtek sekcji
			r := RecNo()
		endif

		if !( rca .or. rsa ) .and. ( r # NIL )			&& kopiowanie pracownikÛw do sekcji
			rr := RecNo()																&& koniec sekcji
			ON( 'LPRAC', 2 )
			while !Eof()
					dwa := .f.			&& dwa zapisy na jednπ osobÍ
//if LPRAC->ID=206; Alarm('kazmierczak agnieszka');endif
					if LISTYP # 0
						? NAZWA
						ZUSBAZA->( DBGoTo( r ))	&& poczπtek sekcji bazowej
						w := ZUSWYNIK->( RecNo())	&& koniec poprzedniego wyniku
						ok := .t.			&& na razie OK
						rca := ZUSBAZA->( AllTrim( POZIOMY ) == 'KEDU/ZUSRCA.DP/ZUSRCA/DDORCA' )
						rsa := ZUSBAZA->( AllTrim( POZIOMY ) == 'KEDU/ZUSRSA.DP/ZUSRSA/DDORSA' )
						idlprac := LPRAC->ID
						if rca
//if LPRAC->ID=198; Alarm('markowska');endif
							dwa := DwaRCA( idlprac, @drugi )
							ZUSPRA->( DBSeek( Str( idlprac, 10 ) + Str(  0, 10 )))
						endif
						tylko5 := .f.		&& pierwsze 5 pÛl moøna poøyczyÊ z RCA
						if rsa
							if !ZUSPRA->( DBSeek( Str( idlprac, 10 ) + Str( 30, 10 )))
								ZUSPRA->( DBSeek( Str( idlprac, 10 ) + Str(  0, 10 )))
								tylko5 := .t.
							endif
						endif
						if ZUSPRA->( Eof())			&& nie ma tych sekcji
							ZUSPRA->( DBGoTop())		&& pierwszy z gÛry
//							?? '     <- przypadkowe dane w RCA'
							wolniej += AllTrim( LPRAC->NAZWA ) + EOL
							idlprac := ZUSPRA->ID
							if rca
								ZUSPRA->( DBSeek( Str( idlprac, 10 ) + Str(  0, 10 )))
							endif
							tylko5 := .f.		&& pierwsze 5 pÛl moøna poøyczyÊ z RCA
							if rsa
								if !ZUSPRA->( DBSeek( Str( idlprac, 10 ) + Str( 30, 10 )))
									ZUSPRA->( DBSeek( Str( idlprac, 10 ) + Str(  0, 10 )))
									tylko5 := .t.
								endif
							endif
						endif
						if ZUSPRA->( Eof())
							while .t.
									KopiujRec( 'ZUSBAZA', 'ZUSWYNIK' )
									x := AllTrim( GetPole( 2, 'ZUSBAZA->(Str(LP)+POZIOMY)', if( drugi, 'TEKST2', 'TEKST'), 'ZUSFORM' ))
									if !Empty( x )
										if Left( x, 1 ) == '='; x := SubStr( x, 2 ); 	endif
										ZUSWYNIK->TEKST := RunCommand( x )
										if ( Left( x, 1 ) == '+' ) .and. ( Val( ZUSWYNIK->TEKST ) = 0 ); ok := .f.; endif
									endif
									ZUSBAZA->( DBSkip())
									if ZUSBAZA->( RecNo()) = rr; exit; endif
							enddo
						else
							tylkoi := 1
							while ZUSPRA->( idlprac == ID .and. !Eof())
									x := AllTrim( GetPole( 2, 'ZUSBAZA->(Str(LP)+POZIOMY)', if( drugi, 'TEKST2', 'TEKST'), 'ZUSFORM' ))
									KopiujRec( 'ZUSBAZA', 'ZUSWYNIK' )
									if tylko5 .and. ( tylkoi > 6 )			&& nie poøyczamy dalszych niø 6
									elseif tylko5 .and. ( tylkoi = 1 )		&& nie poøyczamy pierwszego, bo to znacznik sekcji <RCA>
									else
										if tylkoi=5
											ZUSWYNIK->TEKST := LPRAC->PESEL
										else
											ZUSWYNIK->TEKST := ZUSPRA->POLE		&& reszta zamazywana z zasobÛw
										endif
									endif
									if rca .and. tylkoi=6 .and. drugi
										ZUSWYNIK->TEKST := '124000'
									elseif rsa .and. tylkoi=7
//if LPRAC->ID=198; Alarm('markowska');endif
//if LPRAC->ID=206; Alarm('kazmierczak agnieszka');endif
										DwaOkresy(LPRAC->ID,.f.)
										DwaOkresy(LPRAC->ID,!drugi)
										ZUSWYNIK->TEKST := rsa_kod
										x := AllTrim(ZUSKODY->(GetPole(1,'Val(rsa_kod)','ID_LIST')))
										globalbuf := SumaPozP('ogprzychod',data_od,data_do,x,,if(x='46','DNIZAS','dni'),if(Val(rsa_ile)=99,'>=99','=Val(rsa_ile)'))
										x := ''
									elseif rsa .and. tylkoi=8; ZUSWYNIK->TEKST := rsa_od
									elseif rsa .and. tylkoi=9; ZUSWYNIK->TEKST := rsa_do
									elseif rsa .and. tylkoi=10;ZUSWYNIK->TEKST := rsa_ile
									endif
									tylkoi++
									if !Empty( x )
										if Left( x, 1 ) == '='; x := SubStr( x, 2 ); 	endif
										ZUSWYNIK->TEKST := RunCommand( x )
										if '8.' $ x
											?? ', '
											?? AllTrim( ZUSWYNIK->TEKST )
											testsumasuz += Val( ZUSWYNIK->TEKST )
										endif
										if ( Left( x, 1 ) == '+' ) .and. ( Val( ZUSWYNIK->TEKST ) = 0 ); ok := .f.; endif
										if !dwa .and. !drugi .and. rsa
											dwa := DwaOkresy(LPRAC->ID,.f.)
										endif
									endif
									ZUSPRA->( DBSkip())
									ZUSBAZA->( DBSkip())
									if ZUSBAZA->( RecNo()) = rr; exit; endif
							enddo
						endif
						ww := ZUSWYNIK->( RecNo())			&& koniec obecnego wyniku
						if !ok									&& kasowanie ca≥ej sekcji, bo !OK
							ZUSWYNIK->( DBGoTo( w + 1 ))
							while ZUSWYNIK->( RecNo() <= ww .and. !Eof()); BDelete(); DBSkip(); enddo
							ZUSWYNIK->( DBGoBottom())
						endif
					endif
					Select( 'LPRAC' )
					if dwa
						if rsa .and. (rsa_ktory>=rsa_razy)
							dwa := .f.
							drugi := .t.		&& teraz leci drugi zapis na tπ osobÍ
						endif
						if rca
							if !drugi
								dwa := .f.
								drugi := .t.		&& teraz leci drugi zapis na tπ osobÍ
							else
								drugi := .f.			&& teraz nie leci drugi zapis na tπ osobÍ
								skip
							endif
						endif
					else
						drugi := .f.			&& teraz nie leci drugi zapis na tπ osobÍ
						skip
					endif
			enddo
			r := NIL
			ZUSBAZA->( DBGoTo( rr - 1 ))				&& koniec sekcji bazowej
		elseif r = NIL
			KopiujRec( 'ZUSBAZA', 'ZUSWYNIK' )
			x := AllTrim( GetPole( 2, 'Str(LP)+POZIOMY', 'TEKST', 'ZUSFORM' ))
			if !Empty( x )
				if Left( x, 1 ) == '='; x := SubStr( x, 2 ); 	endif
				ZUSWYNIK->TEKST := RunCommand( x )
			endif
		endif
		Select( 'ZUSBAZA' )
		skip
enddo

if testsumasuz # 0	&& =ZUS(Grosz(SumaPozP('psuz',data_od,data_do)*0.01*8.50))
	?
	? 'Suma "suz": ' + AllS( testsumasuz / 100 )	&& 6,295.12 dla 8.50%, a ze zbiorÛwki: 6,295.16
	? Space( 40 ) + 'Wcisnij ENTER'
	Inkey( 0 )
endif

if rrcp # NIL
	rca := .f.
	Select( 'ZUSWYNIK' )
	DBSetOrder( 1 )
	if !DBSeek( Str( 1, 10 ) + 'KEDU/ZUSRCA.DP/ZUSRCA/DDORCA')	&& brak sekcji RCA pracownika
		DBSetOrder( 0 )
		DBGoTo( rrcp + 1 )
		while !Eof()
				if AllTrim( POZIOMY ) = 'KEDU/ZUSRCA.DP'				&& skasuj wnÍtrze RCA
					BDelete()
				endif
				skip
		enddo
	endif
endif

if rrsp # NIL
	rsa := .f.
	Select( 'ZUSWYNIK' )
	DBSetOrder( 1 )
	if !DBSeek( Str( 1, 10 ) + 'KEDU/ZUSRSA.DP/ZUSRSA/DDORSA')	&& brak sekcji RSA pracownika
		DBSetOrder( 0 )
		DBGoTo( rrsp + 1 )
		while !Eof()
				if AllTrim( POZIOMY ) = 'KEDU/ZUSRSA.DP'				&& skasuj wnÍtrze RSA
					BDelete()
				endif
				skip
		enddo
	endif
endif

if .f. .and. !Empty( wolniej )
	?
	? 'Pracownicy z przypadkowymi danymi w RCA/RSA:'
	? wolniej
	? Space( 40 ) + 'Wcisnij ENTER'
	Inkey( 0 )
endif

@ 0, 0 say Space( mc )
RestScreen( ,,,, sc )
Select( bb )
DBSetOrder( 0 )
go top
wy := 2

******************************************************************************

function DwaOkresy( id, przerwijpo1 )

local i := 0, bb := Alias()

ON('ZUSRSA',2); DBSeek( Str( id, 10))
while !Eof() .and. ID_PRAC=id
//	if data_od<=DATA1 .and. DATA1<=data_do .and. data_od<=DATA2 .and. DATA2<=data_do	//wewn. okresu
	if data_od<=DATA3 .and. DATA3<=data_do 							//dotyczy okresu
		i ++
		rsa_kod := AllS( KOD )
		rsa_od := SubStr(DtoS(DATA1),7,2)+SubStr(DtoS(DATA1),5,2)
		rsa_do := SubStr(DtoS(DATA2),7,2)+SubStr(DtoS(DATA2),5,2)
		rsa_ile := AllS( ILE )
		if przerwijpo1
			if i>=rsa_ktory; rsa_ktory++; exit; endif
		else
			rsa_razy := i
		endif
	endif
	skip
enddo

Select( bb )

return i>1

******************************************************************************
* drugi przez zmiennπ

function DwaRCA( id, drugi )

local i := 0, im := 0, ii := 0, bb := Alias()

ON('LPLACP',3); DBSeek( Str( id, 10))
while !Eof() .and. ID_PRAC=id
	d3:=LPLAC->(GetPole(1,'LPLACP->ID_LPLAC','DATA'))
	if data_od<=d3 .and. d3<=data_do 		//dotyczy okresu
		if LPLAC->ID_LPD=46; im++; endif 	//macierzyÒskie
		if LPLAC->ID_LPD<>46; ii++; endif 	//inne
		i++
	endif
	skip
enddo
DBSetOrder(1)

Select( bb )

if ii<1 .and. im>0; drugi := .t.; endif

return im>0 .and. ii>0

******************************************************************************

procedure ZUSEksport()

local n := 'zus_path.txt'
local p := ReadWzor( n ), d

d := PadR( '200304', 100 )
d := Get_U( 10, 10, 'Podaj nazwe` dla KDU:', '@S30', d )
if d = NIL; return; endif

d := p + '\' + AllTrim( d ) + '.KDU'

Czek( 1 )
mOpen( d )
go top
while !Eof()
		? PadR( TEKST, LEN )
		skip
enddo
mClose()
Czek( 0 )

******************************************************************************

procedure ZUSBaza()

local p

if Alarm( 'Bieøπce KDU ma byÊ bazπ dla innych ?', nt, 1 ) # 2; return; endif

ON( 'ZUSbaza',,,, .t. )
ON( 'ZUS', 0 )
while !Eof()
		ZUSBAZA->( DBAppend())
		ZUSBAZA->LEN := ZUS->LEN
		ZUSBAZA->TEKST := ZUS->TEKST
		ZUSBAZA->POZIOMY := ZUS->POZIOMY
		skip
enddo

ON( 'ZUSbaza' )

p := 'KEDU/ZUSRCA.DP/ZUSRCA/DDORCA'
if !DBSeek( p )
	Alarm( 'Brak sekcji RCA' )
else
	while AllTrim( POZIOMY ) == p; DBSkip(); enddo							&& pomiÒ pierwsze RCA
	while Left( POZIOMY, Len( p )) == p; BDelete(); DBSkip(); enddo		&& nastÍpne RCA usuÒ
endif

p := 'KEDU/ZUSRSA.DP/ZUSRSA/DDORSA'
if !DBSeek( p )
	Alarm( 'Brak sekcji RSA' )
else
	while AllTrim( POZIOMY ) == p; DBSkip(); enddo							&& pomiÒ pierwsze RSA
	while Left( POZIOMY, Len( p )) == p; BDelete(); DBSkip(); enddo		&& nastÍpne RSA usuÒ
endif

ZUSCzysc( 'KEDU/ZUSDRA.DP/ZUSDRA/INN7', 6 )
ZUSCzysc( 'KEDU/ZUSDRA.DP/ZUSDRA/ZSDRAI' )
ZUSCzysc( 'KEDU/ZUSDRA.DP/ZUSDRA/ZWDRA' )
ZUSCzysc( 'KEDU/ZUSDRA.DP/ZUSDRA/RIVDRA' )
ZUSCzysc( 'KEDU/ZUSDRA.DP/ZUSDRA/ZSDRA' )
ZUSCzysc( 'KEDU/ZUSDRA.DP/ZUSDRA/ZDRAV' )
ZUSCzysc( 'KEDU/ZUSDRA.DP/ZUSDRA/LSKD' )
ZUSCzysc( 'KEDU/ZUSDRA.DP/ZUSDRA/OPLS', 5 )
ZUSCzysc( 'KEDU/ZUSRCA.DP/ZUSRCA/DDORCA' )
ZUSCzysc( 'KEDU/ZUSRCA.DP/ZUSRCA/DDORCA', 6 )
ZUSCzysc( 'KEDU/ZUSRSA.DP/ZUSRSA/DDORSA' )
ZUSCzysc( 'KEDU/ZUSRSA.DP/ZUSRSA/DDORSA', 6 )
ZUSNumeruj()

******************************************************************************

procedure ZUSCzysc( p, x )

local war := { || .t. }

do case
case x = NIL; war := { || ZUSBAZA->LEN > 9 }
case x > 0  ; war := { || ZUSBAZA->LEN = x }
otherwise   ; war := { || ZUSBAZA->LEN > 0 }
endcase

if !DBSeek( p )
	Alarm( 'Brak sekcji ' + p )
else
	while AllTrim( POZIOMY ) == p
			if Eval( war ) .and. !( Left( ZUSBAZA->TEKST, 1 ) == '<' )
				ZUSBAZA->( Blokuj_R())
				ZUSBAZA->TEKST := ''
				ZUSBAZA->( OdBlokuj_R())
			endif
			DBSkip()
	enddo
endif

******************************************************************************

procedure ZUSNumeruj()

local x, i

ON( 'ZUSbaza' )
x := ''
while !Eof()
		if x <> POZIOMY
			i := 1
			x := POZIOMY
		endif
		ZUSBAZA->( Blokuj_R())
		ZUSBAZA->LP := i++
		ZUSBAZA->( OdBlokuj_R())
		skip
enddo

******************************************************************************

procedure ZUSImport( lpra )

local n := 'zus_path.txt'
local d := ReadWzor( n )
local pp, p, i, x, mm := {}
local p1, p2, p3, p4
local irca, irsa

if lpra = NIL; lpra := 'LPRAC'; endif

d := PadR( d, 100 )
d := Get_U( 10, 10, 'Podaj katalog danych ZUS:', '@S30', d )
if d = NIL; return; endif

d := AllTrim( d )
MemoWrit( cat_wzorow + n, d )

p := Directory( d + '\*.kdu' )
do case
case Len( p ) = 0; Alarm( 'Brak plikÛw KDU w podanym katalogu',, 1 ); return
case Len( p ) = 1
	p := p[ 1, 1 ]
case Len( p ) > 1
	for i := 1 to Len( p )
		Aadd( mm, p[ i, 1 ])
	next
	i := Alarm( 'Wybierz plik z danymi do importu:', mm )
	if i = 0; return; endif
	p := mm[ i ]
endcase

Czek( 1 )
p := AllTrim( p )
p := MemoRead( d + '\' + p )

ON( 'ZUSPO',,,, .t. )
ON( 'ZUS', 0,,, .t. )
while !Empty( p )
   m := Odetnij( @p, EOL )
	DBAppend()
	ZUS->LEN := Len( m )
	ZUS->TEKST := m
enddo

DBSetOrder( 0 )
DBGoTop()
x := NIL
store '' to p, p1, p2, p3, p4
while !Eof()
		if Left( TEKST, 2 ) == '</'				&& koÒcÛwka jakiegoú poziomu

			p := SubStr( TEKST, 3, LEN - 3 )		&& nazwa
			pp := p										&& zapamiÍtaj bo zaraz siÍ pozmienia
			p := PadR( p, 200 )

			if ZUSPO->( DBSeek( p ))				&& jest taki
				i := 1
				while .t.
					p := PadR( AllTrim( pp ) + '.' + AllS( i++ ), 200 )
					if !ZUSPO->( DBSeek( p ))				&& nie ma takiego
						exit
					endif
				enddo
			endif

			ZUSPO->( DBAppend())
			ZUSPO->POZIOM := p

			x := RecNo()
			while .t.
				do case
				case Empty( POZIOM1 ); ZUS->POZIOM1 := p
				case Empty( POZIOM2 ); ZUS->POZIOM2 := p
				case Empty( POZIOM3 ); ZUS->POZIOM3 := p
				case Empty( POZIOM4 ); ZUS->POZIOM4 := p
				case Empty( POZIOM5 ); ZUS->POZIOM5 := p
				endcase
				if ( pp == SubStr( TEKST, 2, LEN - 2 ))
					exit
				endif
				skip -1
				if Bof()
					exit
				endif
			enddo
			DBGoTo( x )
		endif
		skip
enddo

ON( 'ZUSPO',,,, .t. )
ON( 'ZUS', 0 )
while !Eof()
		p := AllTrim( POZIOM5 ) + '/' + AllTrim( POZIOM4 ) + '/' + AllTrim( POZIOM3 ) + '/' + AllTrim( POZIOM2 ) + '/' + AllTrim( POZIOM1 )
		while Left( p, 1 ) == '/'; p := SubStr( p, 2 ); enddo
		ZUS->POZIOMY := p
		if !ZUSPO->( DBSeek( ZUS->POZIOMY ))
			ZUSPO->( DBAppend())
			ZUSPO->POZIOM := p
			ZUSPO->ILE := 1
		else
			ZUSPO->ILE := ZUSPO->ILE + 1
		endif
		skip
enddo

irca := 0
ON( 'LPRAC', 2 )
ON( 'ZUSPRA' )
ON( 'ZUS' )
pp := 'KEDU/ZUSRCA.DP/ZUSRCA/DDORCA'
p := pp
if !DBSeek( p )
	Alarm( 'Brak sekcji RCA' )
else
	while .t.
		DBSkip()		&& mija <DDORCA> i stoi na nazwisku
		n := AllTrim( TEKST )
		DBSkip()		&& mija nazwisko i stoi na imieniu
		i := AllTrim( TEKST )
		n := Konwert( n, zus, maz )
		i := Konwert( i, zus, maz )
		x := NIL
		do case
		case LPRAC->( DBSeek( n + ' ' + i )); x := LPRAC->ID
		case LPRAC->( DBSeek( i + ' ' + n )); x := LPRAC->ID
		case LPRAC->( DBSeek( n + '  ' + i )); x := LPRAC->ID
		case LPRAC->( DBSeek( i + '  ' + n )); x := LPRAC->ID
		endcase
	if x = NIL
		n := Konwert( n, maz, bezpl )
		i := Konwert( i, maz, bezpl )
		do case
		case LPRAC->( DBSeek( n + ' ' + i )); x := LPRAC->ID
		case LPRAC->( DBSeek( i + ' ' + n )); x := LPRAC->ID
		case LPRAC->( DBSeek( n + '  ' + i )); x := LPRAC->ID
		case LPRAC->( DBSeek( i + '  ' + n )); x := LPRAC->ID
		endcase
	endif
		if x = NIL
			Alarm( 'Jest problem z odnalezieniem osoby;' + n + ' ' + i + ';Ustaw na niej podúwietlenie i wyjdü klawiszem Esc' )
			ViewDBF( lpra, .t. )
			x := LPRAC->ID
		endif
		if .t.
			irca ++
			i := 0
			DBSeek( p )
			while AllTrim( POZIOMY ) == p
					if ZUSPRA->( DBSeek( Str( x, 10 ) + Str( i, 10 )))
						ZUSPRA->( Blokuj_R())
					else
						ZUSPRA->( DBAppend())
						ZUSPRA->ID := x
						ZUSPRA->LP := i
					endif
					ZUSPRA->LEN := ZUS->LEN
					ZUSPRA->POLE := ZUS->TEKST
					ZUSPRA->( OdBlokuj_R())
					i ++
					DBSkip()
			enddo
			p := AllTrim( POZIOMY )			&& nowy poziom, np.: KEDU/ZUSRCA.DP/ZUSRCA/DDORCA.1
		endif
		if Left( p, Len( pp )) <> pp		&& koniec sekcji RCA
			exit
		endif
	enddo
endif

irsa := 0
ON( 'ZUS' )
pp := 'KEDU/ZUSRSA.DP/ZUSRSA/DDORSA'
p := pp
if !DBSeek( p )
	Alarm( 'Brak sekcji RSA' )
else
	while .t.
		DBSkip()		&& mija <DDORCA> i stoi na nazwisku
		n := AllTrim( TEKST )
		DBSkip()		&& mija nazwisko i stoi na imieniu
		i := AllTrim( TEKST )
		n := Konwert( n, zus, maz )
		i := Konwert( i, zus, maz )
		x := NIL
		do case
		case LPRAC->( DBSeek( n + ' ' + i )); x := LPRAC->ID
		case LPRAC->( DBSeek( i + ' ' + n )); x := LPRAC->ID
		case LPRAC->( DBSeek( n + '  ' + i )); x := LPRAC->ID
		case LPRAC->( DBSeek( i + '  ' + n )); x := LPRAC->ID
		endcase
	if x = NIL
		n := Konwert( n, maz, bezpl )
		i := Konwert( i, maz, bezpl )
		do case
		case LPRAC->( DBSeek( n + ' ' + i )); x := LPRAC->ID
		case LPRAC->( DBSeek( i + ' ' + n )); x := LPRAC->ID
		case LPRAC->( DBSeek( n + '  ' + i )); x := LPRAC->ID
		case LPRAC->( DBSeek( i + '  ' + n )); x := LPRAC->ID
		endcase
	endif
		if x = NIL
			Alarm( 'Jest problem z odnalezieniem osoby;' + n + ' ' + i + ';Ustaw na niej podúwietlenie i wyjdü klawiszem Esc' )
			ViewDBF( lpra, .t. )
			x := LPRAC->ID
		endif
		if .t.
			irsa ++
			i := 30
			DBSeek( p )
			while AllTrim( POZIOMY ) == p
					if ZUSPRA->( DBSeek( Str( x, 10 ) + Str( i, 10 )))
						ZUSPRA->( Blokuj_R())
					else
						ZUSPRA->( DBAppend())
						ZUSPRA->ID := x
						ZUSPRA->LP := i
					endif
					ZUSPRA->LEN := ZUS->LEN
					ZUSPRA->POLE := ZUS->TEKST
					ZUSPRA->( OdBlokuj_R())
					i ++
					DBSkip()
			enddo
			p := AllTrim( POZIOMY )			&& nowy poziom, np.: KEDU/ZUSRCA.DP/ZUSRCA/DDORCA.1
		endif
		if Left( p, Len( pp )) <> pp		&& koniec sekcji RCA
			exit
		endif
	enddo
endif

Czek( 0 )

if irsa # 0 .or. irca # 0
	Alarm( 'Aktualizowano dane;' + AllS( irca ) + ' osÛb z RCA i ' + AllS( irsa ) + ' osÛb z RSA',, 1 )
endif

******************************************************************************
* pw - pola wynikowe, np.: 'listyp'
* ps - pola skíadowe, np.: 'ile'
* sub- subbaza, np.: "LPLACP"
* i  - index, np.: 3
* s  - seek, np.: 'Str(LPRAC->ID)'
* k  - klucz, np.: 'LPRAC->ID=LPLACP->ID_PRAC'
* w  - warunek, np.: 'LPLAC->(GetPole(1,'LPLACP->ID_LPLAC','ID_LPD')) # 0'
* v  - value, np.: 'Val(LPLACPP->WARTOSC)'

procedure SumPolaSuba( pw, ps, sub, i, s, k, w, v )

local bb := Alias(), rr := RecNo(), x

if ps = NIL .or. Empty( ps )
   ps := 'ile'
endif

if v = NIL .or. Empty( v )
   v := ps
endif

ON( sub, i )      && ON( 'LPLACP,3' )
Select( bb )      && Select( 'LPRAC' )
go top
while !Eof()
      x := 0
      Select( sub )                          && Select( 'LPRACP' )
      DBSeek( RunCommand( s ))               && DBSeek( Str( LPRAC->ID ))
      while RunCommand( k ) .and. !Eof()     && while LPRAC->ID=LPLACP->ID_PRAC
            if RunCommand( w )      && if LPLAC->(GetPole(1,'LPLACP->ID_LPLAC','ID_LPD')) # 0
               if ps == 'ile'
                  x ++
               else
                  x += RunCommand( v )       && x += Val(LPLACPP->WARTOSC)
               endif
            endif
            skip
      enddo
      Select( bb )
      Blokuj_R()
      FieldPut( FieldPos( Upper( pw )), x )  && ( bb )->ILE := x
      OdBlokuj_R()
      skip
enddo
DBGoTo( rr )
wy := 2

******************************************************************************

procedure PlaceCzysc()

local i, bb := Alias()

if Alarm( 'UsunÜç ze specyfikacji pozycje skasowanych list píac ?', nt ) # 2; return; endif

ON( 'LPLAC' )

i := 0
ON( 'LPLACPP' )
Przerwa( LastRec())
while !Eof()
      if !LPLAC->( DBSeek( LPLACPP->ID_LPLAC ))
         i ++
         @ 0, 0 say i
         BDelete()
      endif
      Przerwa()
      skip
enddo
Przerwa( 0 )
Zwolnij( 'LPLACPP' )

Alarm( 'Usuniëto ' + AllS( i ) + ' pozycji z LPLACPP' )

@ 0, 0 say Space( mc )

i := 0
ON( 'LPLACP' )
Przerwa( LastRec())
while !Eof()
      if !LPLAC->( DBSeek( LPLACP->ID_LPLAC ))
         i ++
         @ 0, 0 say i
         BDelete()
      endif
      Przerwa()
      skip
enddo
Przerwa( 0 )
Zwolnij( 'LPLACP' )

Alarm( 'Usuniëto ' + AllS( i ) + ' pozycji z LPLACP' )

@ 0, 0 say Space( mc )

Select( bb )

******************************************************************************

function CheckPodatek()

local podstawy := ponapodoch, x := 0, dt, xx

if ponapodosu > 0.00
   podstawy += ponapodosu
else
   podstawy += SumaPoz( 'ponapodoch' ) + SumaPoz( 'pbrutto' )
endif

*********
* teoria ( matematyka )
*********

do case
   case podstawy <= prog1kwota; x := prog1proc
   case podstawy <= prog2kwota; x := prog2proc
   otherwise                  ; x := prog3proc
endcase

***********
* praktyka ( decyzja pracownika lub ußytkownika programu )
***********
* domyûlnie pola: PROCENT1 = prog1proc, OD_DNIA1 = '01.01.xxxx'
* muszÜ byç pola: PROCENT2, PROCENT3, OD_DNIA2, OD_DNIA3

if .t.            && x > prog1proc     && zmiana stawki podatkowej ponad pr¢g 1

   if LPRAC->( FieldPos( 'PROCENT2' )) # 0      && jest takie pole
      dt := PDNM( data_listy )                  && od PDNM="Pierwszego Dnia NastÍpnego Miesiπca"

*      if x = prog2proc

         if ( x = prog2proc );
            .and.;
            ( Empty( LPRAC->OD_DNIA2 );           && pusta
              .or.;                               && lub dotyczy
              Year( LPRAC->OD_DNIA2 ) # Year( data_listy ))   && innego roku
            while Alarm( 'Czy pracownik "' + AllTrim( LPRAC->NAZWA ) +;
                     '", kt¢rego podstawa naliczenia podatku dochodowego = ' + AllS( podstawy, '999,999,999.99' ) +;
                      ', bëdzie miaí ' + AllS( x, '999' ) + '% podatku dochodowego od dnia ' + DtoC( dt ) + ' ?', nt ) # 2
                  if ( xx := Get_U( 10, 10, 'Podaj procent podatku dochodowego od dnia ' + DtoC( dt ), '999%', x )) # NIL
            LPRAC->( Blokuj_R())
                     LPRAC->PROCENT2 := xx
            LPRAC->( OdBlokuj_R())
                     x := xx
                  endif
            enddo
            LPRAC->( Blokuj_R())
            LPRAC->PROCENT2 := x
            LPRAC->OD_DNIA2 := dt
            LPRAC->( OdBlokuj_R())
            x := prog1proc
         else
            if !Empty( LPRAC->OD_DNIA2 );
               .and.;
               data_listy >= LPRAC->OD_DNIA2
               x := LPRAC->PROCENT2             && po nowemu
            else
*               x := prog1proc                   && po staremu
            endif
         endif

*      endif

*      if x = prog3proc                          && x = prog3proc

         if ( x = prog3proc );
            .and.;
            ( Empty( LPRAC->OD_DNIA3 );           && pusta
              .or.;                               && lub dotyczy
              Year( LPRAC->OD_DNIA3 ) # Year( data_listy ))   && innego roku
            while Alarm( 'Czy pracownik "' + AllTrim( LPRAC->NAZWA ) +;
                     '", kt¢rego podstawa naliczenia podatku dochodowego = ' + AllS( podstawy, '999,999,999.99' ) +;
                      ', bëdzie miaí ' + AllS( x, '999' ) + '% podatku dochodowego od dnia ' + DtoC( dt ) + ' ?', nt ) # 2
                  if ( xx := Get_U( 10, 10, 'Podaj procent podatku dochodowego od dnia ' + DtoC( dt ), '999%', x )) # NIL
            LPRAC->( Blokuj_R())
                     LPRAC->PROCENT3 := xx
            LPRAC->( OdBlokuj_R())
                     x := xx
                  endif
            enddo
            LPRAC->( Blokuj_R())
            LPRAC->PROCENT3 := x
            LPRAC->OD_DNIA3 := dt
            LPRAC->( OdBlokuj_R())
            x := prog2proc
         else
            if !Empty( LPRAC->OD_DNIA3 );
               .and.;
               data_listy >= LPRAC->OD_DNIA3
               x := LPRAC->PROCENT3
            else
*               x := prog2proc
            endif
         endif

*      endif



   endif
endif

*if x # prog1proc                    && jeûli nie jesteûmy przed progiem 1, to
*   if kwolna # 0
*      Alarm( 'Pracownik "' + AllTrim( LPRAC->NAZWA ) +;
*          '", kt¢rego podstawa naliczenia podatku dochodowego = ' + AllS( podstawy, '999,999,999.99' ) +;
*           ', przekroczyí pr¢g 1 skali podatkowej i jego "kwota wolna" powinna byç zerowa. ' +;
*             'Podatek bëdzie obliczony prawidíowo, ale "kwotë wolnÜ" popraw rëcznie.' )
*      kwolna := 0                      && zeruj kwotë wolnÜ od podatku
*   endif
*endif

return x

******************************************************************************
* drugiproc # NIL => liczyç "procpodat := CheckPodatek()" w "PodatekDochodowy"

function PodatekDochodowy( x, kwolne, podstawy, potracone, tylkoplus, drugiproc )

local znak := if( x < 0, -1, 1 ), procent

x := x * znak

if podstawy # NIL
   x += podstawy
endif

if kwolne = NIL

   if drugiproc # NIL
      procpodat := CheckPodatek()
   endif

   procent := if( procpodat > 0.001, procpodat, prog1proc )

   x := Grosz( x * procent * 0.01 ) - kwolna

else

do case
   case x <= prog1kwota; x := Grosz( x * prog1proc * 0.01 ) - kwolne
   case x <= prog2kwota; x := Grosz( prog2rycz + ( x - prog1kwota ) * prog2proc * 0.01 )
   otherwise           ; x := Grosz( prog3rycz + ( x - prog2kwota ) * prog3proc * 0.01 )
endcase

endif

if potracone # NIL
   x -= potracone
endif

x := x * znak

if tylkoplus # NIL .and. x < 0.01
   x := 0.00
endif

return x

******************************************************************************

procedure LPLACStorno()

local bb := Alias(), rr := RecNo(), a

if Alarm( 'Minusowaç wszystkie kwoty (storno) ?', nt ) # 2; return; endif

go top
skip           && opr¢cz pierwszej pozycji, kt¢ra jest pewnie LP
while !Eof()
      a := AllTrim( WARTOSC )
      if IsDigit( a )
         ( bb )->( Blokuj_R())
         ( bb )->WARTOSC := PadL( '-' + a, Len( RTrim( WARTOSC )))
         ( bb )->( OdBlokuj_R())
      endif
      skip
enddo

DBGoTo( rr )
zmiana := .t.
wy := 2

******************************************************************************
* bz - baza znak¢w
* idlp - id rodzaju listy píac
* idlo - id rodzaju listy os¢b
* idpo1- id pozycji gdzie zapisaç kwotë 1
* idpo2- id pozycji gdzie zapisaç kwotë 2
* idpo3- id pozycji gdzie zapisaç kwotë 3

procedure GenLPRP67( bz, idlp, idlo, idpo1, idpo2, idpo3 )

local odp, n, i, j, bb := Alias(), idpo

odp := Alarm( 'Generowaç listë píac ?', tk )
if odp = 0; return; endif
if odp = 1

   ON( 'LPD' )
   if !DBSeek( idlp )
      Alarm( 'Brak odpowiedniej definicji listy píac (' + AllS( idlp ) + ')' ) 
      Select( bb )
      return
   endif

   baza := 'LPLACP'

   ON( 'LPDPD' )
   ON( 'LPLAC' )
   if NewSysDopisz('LPLAC,Nowa lista píac,,,,,,,3',,,'LPLAC->ID:=GetLast(1,1)+1,LPLAC->ID_LPD:=' + AllS(idlp) + ',LPLAC->ID_LPD2:=' + AllS(idlo))
      ON( 'LPD' ); set filter to; DBSeek( idlp )
      ON( 'LPLACPP' )
      ON( 'LPLACP' )
      ON( 'LPRACZ?', 0 )
      i := 1
      while !Eof()

            LPLACP->( DBAppend())
            LPLACP->ID := i++
            LPLACP->ID_LPLAC := LPLAC->ID
            LPLACP->ID_PRAC := LPRACZ_->POLE

            n := 1        && licznik, kt¢ra kwota teraz jest odczytywana
            j := 1
            ON( 'LPDP' )
            DBSeek( Str( LPD->ID ))
            while ID_LPD = LPD->ID .and. !Eof()
                  LPLACPP->( DBAppend())
                  LPLACPP->ID := j++
                  LPLACPP->ID_LPLAC := LPLAC->ID
                  LPLACPP->ID_LPLACP:= LPLACP->ID
                  LPLACPP->ID_LPDPD := LPDP->ID_LPDPD
                  buf := LPDPD->( GetPole( 1, 'LPDP->ID_LPDPD', 'DEFINICJA' ))
                  do case
                  case n = 1; idpo := idpo1
                  case n = 2; idpo := idpo2
                  case n = 3; idpo := idpo3
                  endcase
                  if idpo = NIL
                        if Left( buf, 1 ) == '='
                           buf := AllTrim( SubStr( buf, 2 ))
                           buf := RunCommand( buf )
                           if ValType( buf ) == "N" .and. IsDigit( LPDPD->MASKA )
                              LPLACPP->WARTOSC := TU( Transform( buf, AllTrim( LPDPD->MASKA )), LPDPD->ZNAK_T, LPDPD->ZNAK_U, LPDPD->ZERA_TEZ, buf )
                           else
                              LPLACPP->WARTOSC := buf
                           endif
                        else
                           LPLACPP->WARTOSC := ''
                        endif
                  else
                     if idpo = LPDP->ID_LPDPD
                        do case
                        case n = 1; buf := LPRACZ_->KWOTA1
                        case n = 2; buf := LPRACZ_->KWOTA2
                        case n = 3; buf := LPRACZ_->KWOTA3
                        endcase
                        n ++
                        LPLACPP->WARTOSC := TU( Transform( buf, AllTrim( LPDPD->MASKA )), LPDPD->ZNAK_T, LPDPD->ZNAK_U, LPDPD->ZERA_TEZ, buf )
                     else
                        if Left( buf, 1 ) == '='
                           buf := AllTrim( SubStr( buf, 2 ))
                           buf := RunCommand( buf )
                           if ValType( buf ) == "N" .and. IsDigit( LPDPD->MASKA )
                              LPLACPP->WARTOSC := TU( Transform( buf, AllTrim( LPDPD->MASKA )), LPDPD->ZNAK_T, LPDPD->ZNAK_U, LPDPD->ZERA_TEZ, buf )
                           else
                              LPLACPP->WARTOSC := buf
                           endif
                        else
                           LPLACPP->WARTOSC := ''
                        endif
                     endif
                  endif
                  skip
            enddo

            Select( 'LPRACZ_' )
            skip

      enddo
   endif
endif

ON('LPRACZ?' )
odp := Alarm( 'UsunÜç gwiazdki i kwoty ?', tk )
if odp = 1
   ON('LPRACZ?',,,,.t.)
endif

wy := 2

baza := bb
Select( bb )

******************************************************************************
* pole, np.: 'STATUS'
* s - string, np.: NUMER
* d - data, np.: DATA

procedure Odblokuj( pole, s, d )

local h, hh, x, xx, b, bb := Alias()

if &pole == ' '
   Alarm( 'Nie ma blokady' )
   return
endif

xx := s + ', ' + DtoC( d )
x := xx + ', ' + DtoC( Datee()) + ', ' + Time()

h := PadR( x, 75 )
hh:= h
h := Get_U( 10, 1, "Podaj hasío:", '@KS60', h )

if NIL # h
   h := StrTran( h, ' ', '' )
   if h # hh .and.;
      Len( h ) > 4 .and.;
      Val( Right( h, 1 )) + Val( Right( x, 1 )) = 9
      Blokuj_R(); &pole := ' '; OdBlokuj_R()
      Alarm( b := 'Teraz nie ma blokady' )
   else
      Alarm( b := 'Zíe hasío' )
   endif

ON( 'ODBLOKI' )
DBAppend()
replace DOKUMENT with xx
replace Z_DNIA with d
replace DATA with Datee()
replace CZAS with Time()
replace UWAGI with b + ': ' + h
Zwolnij( 'ODBLOKI' )

endif

Jest_baza( bb )

******************************************************************************

procedure BlokujListy( kod )

local od := 0, bb := Alias(), rr := RecNo(), ii := IndexOrd(), i, n, testy := .f.

i := 0
LPLACZ->( DBGoTop())
while LPLACZ->( !Eof()); i ++; LPLACZ->( DBSkip()); enddo
if i = 0
   if ( od := Alarm( 'Brak zaznacze§ list do blokowania.;Kt¢re listy zablokowaç ?',;
                   { 'Tylko bießÜcÜ', 'Wszystkie listy','TEST - Tylko bießÜcÜ', 'TEST - Wszystkie listy' })) = 0
      return
   endif
   if od>2
	testy := .t.
	od:=od-2
   endif
   if od = 1
      LPLACZ->( DBAdd())
      LPLACZ->POLE := LPLAC->ID
   endif
else
   if Alarm( 'Zaznaczonych list: ' + AllS( i ) + ';Na pewno zablokowaç zaznaczone listy ?', nt ) # 2
      return
   endif
endif

private zmienna, buf

Czek( 1 )

LPLAC->( DBSetOrder( 1 ))
LPLACP->( DBSetOrder( 2 ))       && Str(ID_LPLAC)+Str(ID)
LPLACPP->( DBSetOrder( 2 ))      && Str(ID_LPLAC)+Str(ID_LPLACP)+Str(ID_LPDPD)

ON( 'LPDPD' )

ON( 'LPD', 2 )
if !DBSeek( Upper( kod ))
   Alarm( 'Brak definicji listy "' + kod + '"' )
   Select( bb )
   return
endif

ON( 'LPDP' )
if !DBSeek( Str( LPD->ID ))
   Alarm( 'Brak element¢w definicji listy "' + kod + '"' )
   Select( bb )
   return
endif

i := 0
n := 0
while LPDP->ID_LPD = LPD->ID .and. LPDP->( !Eof()); n++; LPDP->( DBSkip()); enddo

DBSeek( Str( LPD->ID ))
Przerwa( n )
while LPDP->ID_LPD = LPD->ID .and. LPDP->( !Eof())

      i++

      LPDPD->( DBSeek( LPDP->ID_LPDPD ))              && element
      zmienna := AllTrim( LPDPD->KOD )                && kod zmiennej
      private &zmienna := 0                           && deklaracja := 0

      if od = 2                     && wszystkie
         LPLAC->( DBGoTop())        && czesanie od poczÜtku
         while LPLAC->( !Eof())
               if LPLAC->ID_LPD # 0
                  &zmienna := 0; LPLAC_SubZbiorowka()
			if testy
	                  buf := 'LPLAC->K' + AllS( i )
			  if (Abs(&buf-&zmienna)>0.009)
				@ 0, 0 say ''
				? &buf, &zmienna
				Alarm('Lista '+AllTrim(LPLAC->NUMER)+' '+buf+'<>'+zmienna)
			  endif
			else
        	          LPLAC->( Blokuj_R()); buf := 'LPLAC->K' + AllS( i ); &buf := &zmienna; LPLAC->STATUS := 'B'; LPLAC->( OdBlokuj_R())
			endif
               endif
               LPLAC->( DBSkip())
         enddo
      else
         LPLACZ->( DBGoTop())
         while LPLACZ->( !Eof())
               LPLAC->( DBSeek( LPLACZ->POLE ))          && lista
               &zmienna := 0; LPLAC_SubZbiorowka()
			if testy
	                  buf := 'LPLAC->K' + AllS( i )
			  if (Abs(&buf-&zmienna)>0.009)
				@ 0, 0 say ''
				? &buf, &zmienna
				Alarm('Lista '+AllTrim(LPLAC->NUMER)+' '+buf+'<>'+zmienna)
			  endif
			else
		               LPLAC->( Blokuj_R()); buf := 'LPLAC->K' + AllS( i ); &buf := &zmienna; LPLAC->STATUS := 'B'; LPLAC->( OdBlokuj_R())
			endif
               LPLACZ->( DBSkip())
         enddo
      endif

      LPDP->( DBSkip())
      if Przerwa(); exit; endif
enddo

Przerwa( 0 )
Czek( 0 )

Select( bb )
DBSetOrder( ii )
DBGoTo( rr )
wy := 2

******************************************************************************
* GetWart - pobierz wartoûç pozycji z listy z danego pracownika
* ie - identyfikator elementu

function GetWart( ie )

local il, ip, wy := PadR( '', 50 )

il := ROB->ID_LPLAC
ip := ROB->ID
* ON( LPLACPP, 4 ) => Str(ID_LPDPD)+Str(ID_LPLAC)+Str(ID_LPLACP)
if LPLACPP->( DBSeek( Str( ie, 10 ) + Str( il, 10 ) + Str( ip, 10 )))
   wy := LPLACPP->WARTOSC
endif

return UT( wy )

******************************************************************************
* kod definicji tabeli
* pre - przedrostek, np.: "LPLAC->"
* pre = "" => nie Kn z list, tylko WARTOSC z LPLACPP

procedure TabDefFill( kod, pre )

local bb := Alias(), i, s

i := 1
ON( 'LPLACPP', 4 )     && Str(ID_LPDPD)+Str(ID_LPLAC)+Str(ID_LPLACP)
ON( 'LPDPD' )
ON( 'LPD', 2 )
DBSeek( Upper( kod ))
ON( 'LPDP' )
DBSeek( Str( LPD->ID ))
while LPD->ID = ID_LPD .and. !Eof()
      if LPDPD->( DBSeek( LPDP->ID_LPDPD ))
         if pre = NIL
            Aadd( kolumny, 'K' + AllS( i++ ))
         elseif Empty( pre )
            Aadd( kolumny, 'GetWart(' + AllS( LPDP->ID_LPDPD ) + ')' )
         else
            Aadd( kolumny, pre + 'K' + AllS( i++ ))
         endif
         s := AllTrim( LPDPD->NAZWA )
*         s := StrTran( s, '_', ' ' )
         s += ';(' + AllTrim( LPDPD->KOD ) + ')'
         Aadd( naglowki, s )
         Aadd( szablon, '@Z ' + LPDPD->MASKA )
      endif
      skip
enddo

Jest_baza( bb )

******************************************************************************
* w - wiersz
* a - all

procedure ReLP( w, a )

local bb := Alias(), rr := RecNo(), ii := IndexOrd(), blp := NUMER

if w = NIL; w := 0; endif

wy := 1
DBSetOrder( 0 )
go top
while .t.
      if NUMER < blp; skip; loop; endif
      Blokuj_R()
      ( bb )->NUMER += w
      OdBlokuj_R()
      if a = NIL; exit; endif
      wy := 2
      skip
      if Eof(); exit; endif
enddo
DBGoTo( rr )
DBSetOrder( ii )
zmiana := .t.

******************************************************************************
* w - wiersz
* k - kolumna
* a - all

procedure WK( w, k, a )

local bb := Alias(), rr := RecNo()

if w = NIL; w := 0; endif
if k = NIL; k := 0; endif

wy := 1
while .t.
      Blokuj_R()
      ( bb )->WIERSZ += w
      ( bb )->KOLUMNA += k
      OdBlokuj_R()
      if a = NIL; exit; endif
      wy := 2
      skip
      if Eof(); exit; endif
enddo
DBGoTo( rr )
zmiana := .t.

******************************************************************************

procedure PITUsun( a )

local bb := Alias(), i

if !serio; NoChange(); return .f.; endif

ON( 'PITZ' )
if Eof()
   Select( bb )
   if Right( Str( ROK_MC ), 3 ) == '.00'
      Alarm( 'To jest wzorcowa deklaracja.; Lepiej jej nie usuwaj.')
   endif
   Kasuj('usuwasz tÜ pozycjë', a )
else
   i := 0; while !Eof(); i ++; skip; enddo
   if Alarm( 'Iloûç zaznaczonych deklaracji: ' + AllS( i ) + ';Na pewno je usunÜç ?', nt ) = 2
      go top
      while !Eof()
            Select( bb ); DBSetOrder( 1 )
            if DBSeek( PITZ->POLE )
               if Right( Str( ROK_MC ), 3 ) == '.00'
*                  Alarm( 'Nie usuwaj grupowo wzorcowych deklaracji')
               else
                  Mark( 'PITZ', LP ) && odznacz skasowanÜ deklaracjë
                  wy := 2
                  zmiana := .t.
                  RunCommand( a )    && skasowanie specyfikacji subbazy
                  BDelete()
                  DBSkip( 0 )
                  Ch_il( -1 , rr[ 1 ] - 2 )
               endif
            endif
            Select( 'PITZ' )
            skip
      enddo
   endif
endif
Select( bb )

******************************************************************************

function PITLenT( t )

local x, n, k

x := StrTran( t, '_', '' )   && tekst bez "_"
n := Len( t ) - Len( x )     && ilosc "_" w tekscie

return 2 * Len( x ) + n

******************************************************************************

function PITPrint( t, s, w, c )

local a, b, o

t := Konwert( t )

a := ''
b := ''

if s == 'T'; a += "W1"; endif
if w == 'T'; a += "w1"; endif
if w == 'T'; b += "w0"; endif
if s == 'T'; b += "W0"; endif

o := if( Empty( a ), t, a + StrTran( t, '_', b + ' ' + a ) + b )

if c # 0
   o := "#<" + PadR( c, 2 ) + o +".>#"
endif

return o

******************************************************************************
* Obudowanie procedury "PITWydruk()" dla zaznaczonych PIT¢w

procedure PITDruk()

local bb := Alias(), wa, str, kombyl := .f., laststr, kier      &&, stopac
private plik := 'pit.txt'

ON( 'PITZ' )
if Eof()
   Select( bb )
   PITWydruk()
else
   i := 0; while !Eof(); i ++; skip; enddo
   if i = 1
      Select( bb )
      PITWydruk()
   elseif Alarm( 'Iloûç zaznaczonych deklaracji: ' + AllS( i ) + ';Na pewno je wydrukowaç ?', nt ) = 2

      wa := Alarm( 'Wybierz wariant sposobu druku deklaracji:',;
                 { 'Wszystkie strony pierwszej deklaracji, potem drugiej itd.',;
                   'Wszystkie strony pierwsze, potem wszystkie drugie itd.',;
                   'j.w., ale odwrotna kolejnoûç deklaracji parzystych stron' })

      if wa = 0; Select( bb ); return; endif

*      stopac := ( Alarm( 'Czy komunikowaç przed wydrukiem kaßdej strony ?', nt ) = 2 )

      str := 1
      kier := 1
      go top

      Select( bb ); DBSetOrder( 1 ); DBSeek( PITZ->POLE )
      PITP->( DBSeek( Str( PIT->LP ) + '999', .t. ))
      PITP->( DBSkip( -1 ))    && ostatnia strona
      laststr := PITP->STRONA  && zapamiëtaç

      while .t.

            Select( bb ); DBSetOrder( 1 )
            if DBSeek( PITZ->POLE )
               if wa = 1; PITWydruk( AllTrim( PIT->OPIS ) + ';' )
               else
                  if !kombyl
Alarm( 'Wí¢ß do drukarki plik deklaracji w taki spos¢b' +;
       ';aby drukowaíy sië teraz strony Nr ' + AllS( str ) +;
       ';Pierwsza jest dla: ' + AllTrim( PIT->OPIS ))
                  endif
                  PITWydruk( , str, kombyl )
                  ? EJE; SetPRC( 0 , 0 )
                  kombyl := .t.
               endif
            endif

            Select( 'PITZ' )
            DBSkip( kier )
            if Bof() .or. Eof()
               if wa = 1; exit; endif
               mClose()
               Druk( cat_wydr + plik, 2 )
               kombyl := .f.
               str ++
               if laststr < str; exit; endif
               if wa = 2; go top; endif
               if wa = 3
                  kier := -kier
                  if kier = 1
                     go top
                  else
                     go bottom
                  endif
               endif
            endif
      enddo
   endif
endif
Select( bb )

******************************************************************************

function PITWydruk( h, str, kombyl )

local bb := Alias(), r, c, br, bc, bs, t
private czcionka := 0, zsun_w_dol := 0
private plik := 'pit.txt'

if h = NIL; h := ''; endif

br := 0
bs := 0
Select( 'PITP' )
DBSeek( Str( PIT->LP ))
while PIT->LP = LP_PIT .and. !Eof()

      if str # NIL         && chcemy konkretnÜ stronë
         if STRONA # str   && to nie ta strona
            skip; loop     && pomi§
         endif
      endif

   if STRONA # 0 .and. ( !Empty( TEKST ) .or. CZCIONKA # 0 .or. ZSUN_W_DOL # 0 )
      if STRONA # bs
         if str = NIL .and. bs # 0
            mClose()
            Druk( cat_wydr + plik, 2 )
         endif
         bs := STRONA
         br := 0           && br jako znacznik
         if str = NIL      && jak konkretna strona, to sië tu nie zatrzymuj
            if Alarm( h + 'Wí¢ß do drukarki stronë Nr ' + AllS( bs )) = 0; exit; endif
         endif
         br := 1
         bc := 1
         if str = NIL .or. !kombyl     && otw¢rz plik gdy nie konkretna strona
            mOpen( cat_wydr + plik )   && lub gdy pierwszy raz po komunikacie
            SetPRC( 0 , 0 )
         endif
      endif
      t := RTrim( TEKST )
      r := WIERSZ + PIT->WIERSZ
      c := KOLUMNA+ PIT->KOLUMNA

      if ZSUN_W_DOL # 0                   && dodatkowa linia odstëpu
         if r < br; r := br; endif
         while br < r - 1; ?; br ++; bc := 1; enddo      && jedna mniej
         if r > 1
            ? PITPrint( ' ',,, ZSUN_W_DOL )              && mniejsza
            ?; br ++; bc := 1                            && jedna wiëcej
         else
            ?? PITPrint( ' ',,, ZSUN_W_DOL )             && mniejsza
            ?; bc := 1                                   && bez "jedna wiëcej"
         endif
      else
         if r < br; r := br; endif
         while br < r; ?; br ++; bc := 1; enddo          && normalnie
      endif

      if Empty( t )                && choç jedna spacja kurde w linii
         t := ' '
      else
         if c < bc; c := bc; endif
         while bc < c; ?? " "; bc ++; enddo
      endif

      ?? PITPrint( t, SZERSZE, WYZSZE, CZCIONKA )
      bc += if( SZERSZE == "T", PITLenT( t ), Len( t ))
   endif
   skip
enddo

if str = NIL .and. br # 0
   mClose()
   Druk( cat_wydr + plik, 2 )
endif

Select( bb )

******************************************************************************

procedure Nanies()

local a[ 5 ], rr := RecNo()

if Alarm( 'Nanieûç wszystkim pracownikom pola;Kraj, Wojew¢dztwo, Powiat, Gmina, Poczta;okreûlone przy bießÜcym pracowniku?', tk ) # 1; return; endif

a[ 1 ] := KRAJ
a[ 2 ] := WOJEWOD
a[ 3 ] := POWIAT
a[ 4 ] := GMINA
a[ 5 ] := POCZTA

go top
while !Eof()
      LPRAC->( Blokuj_R())
      LPRAC->KRAJ := a[ 1 ]
      LPRAC->WOJEWOD := a[ 2 ]
      LPRAC->POWIAT := a[ 3 ]
      LPRAC->GMINA := a[ 4 ]
      LPRAC->POCZTA := a[ 5 ]
      LPRAC->( OdBlokuj_R())
      skip
enddo
DBGoTo( rr )

******************************************************************************
* n - n-te síowo z a

function NWord( a, n, se, og )

local i, w

if se = NIL; se := ' '; endif
if og = NIL; og := ','; endif

og := At( og, a )
if og # 0
   a := Left( a, og - 1 )
endif

for i := 1 to n
    w := Odetnij( @a, se )
next

w := StrTran( w, '_', ' ' )
*w := StrTran( w, '%', '~' )

return w

******************************************************************************
* n - numer pozycji drugiej daty

procedure PIT11_Generuj( n )

local bb := Alias(), rr := RecNo(), dt

if !( Right( Str( ROK_MC ), 3 ) == '.00' )
   Alarm( 'Ustaw sië na wzorcowej deklaracji')
   return
endif

Alarm( 'Zaznacz pracownik¢w do generowania ' + AllTrim( TYP ))

ViewDBF( 'LPRAC', .t. )


Select( 'LPRACZ' ); DBGoTop()

if Eof()
   Alarm( 'Nie wybrano ßadnego pracownika' )
endif

while !Eof()
   LPRAC->( DBSetOrder( 1 ))
   if LPRAC->( DBSeek( LPRACZ->POLE ))
      PIT->( DBGoTo( rr ))             && bazowy PIT-11
      PITDopisz(, "KopiujRec( 'PIT', 'PIT' ), PIT->LP := GetLast( 1, 1 ) + 1, PIT->OPIS := LPRAC->NAZWA, .t." )
      Mark( 'PITZ', LP )
      if PITP->( DBSeek( Str( PIT->LP, 5 ) + Str( n, 3 )))
         dt := AllTrim( PITP->TEKST )
         dt := CtoD( dt )
         PIT->ROK_MC := Year( dt ) + Month( dt ) * 0.01
         dt := Datee() - 183         && 183 = 365 / 2
         if PIT->ROK_MC = 0.00
            PIT->ROK_MC := Year( dt ) + 0.12
         endif
      endif
   endif
   Select( 'LPRACZ' )
   skip
enddo

wy := 2
Select( bb )
DBSetOrder( 0 )
Keyboard Chr( K_CTRL_PGDN )

******************************************************************************

procedure PITDopisz( a, b )

local lpp, lppp

Select( 'PIT' )
lpp := LP

if ( a # NIL .and. NewSysDopisz( a, '',, b ));
   .or.;
   ( a = NIL .and. RunCommand( b ))

   lppp := LP
   private baza := 'ROB'
   ON( 'PITP',, 'ROBOCZY', baza )
   ON( 'PITP',, 'ROBOCZY', baza, .t. )
   Select( 'PITP' ); DBSeek( Str( lpp ))
   KopiaRec( 'PITP', baza, { || PITP->LP_PIT = lpp },,, { || ( baza )->LP_PIT := lppp, .f. })
   ( baza )->( PITPrzelicz())
   ( baza )->( DBGoTop())
   KopiaRec( baza, 'PITP' )
endif
Select( 'PIT' )

******************************************************************************
* a - baza ("PITP") lub seria baz ("REJ_SP,-REKSP")

function SSumuj( b, a, c, d, e, f, g, h )

local wy := 0, bb, mn

while !Empty( a )
      mn := 1
      bb := Odetnij( @a )
      if Left( bb, 1 ) == '-'
         mn := -1
         bb := SubStr( bb, 2 )
      endif
      wy += mn * Sumuj( b, bb, c, d, e, f, g, h )
enddo

return wy

******************************************************************************
* a - baza ("PITP") lub seria baz ("REJ_SP,-REKSP")
* b - pole ("KWOTA")
* c - do daty ("1998.10"), jeûli c = -1998.10, to chodzi o okres 1X98-30X98
* d - zmiana znaku 1 (".")
* e - zmiana znaku 1 (",")
* f - zmiana maski wyniku
* g - rodzaj deklaracji "Z.P.D."
* h - pole daty "DATA"

function Sumuj( b, a, c, d, e, f, g, h )

local wy := 0, bb := Alias(), cs, dt, ds, lpp, maxn, rr, dzis := .f.

private anulowano := .f.

if a = NIL; a := "PITP"; endif
if b = NIL; b := "KWOTA";endif
if c = NIL
   if Jest_baza( 'PIT' )
      c := PIT->ROK_MC
   else
      c := Datee()
      dzis := .t.
   endif
endif
if d # NIL; znak_1 := d; endif
if e # NIL; znak_2 := e; endif
if f # NIL; maska  := f; endif

if !Jest_baza( a ); ON( a ); endif
rr := RecNo()
if g = NIL
  if dzis
      go top
      while !Eof()
            if h = NIL        && bez daty
               wy += &b
            else
               dt := &h
               if MemVar->data1 <= dt .and. dt <= MemVar->data2
                  wy += &b
               endif
            endif
            skip
      enddo
  else
   if h = NIL; h := "DATA";endif
   if c > 0
      c := StrTran( Str( c ), '.', '' )   && 199800
      cs:= Left( c, 4 )                   && 1998
      go top
      while !Eof()
            dt:= Left( DtoS( &h ), 6 )
            ds:= Left( dt, 4 )
            if ds == cs .and. dt <= c
               if !ANULOWANO
                  wy += &b
               endif
            endif
            skip
      enddo
   else
      c := StrTran( Str( -c, 7, 2 ), '.', '' )   && 199810
      go top
      while !Eof()
            dt:= Left( DtoS( &h ), 6 )           && 199810
            if dt == c
               if !ANULOWANO
                  wy += &b
               endif
            endif
            skip
      enddo
   endif
  endif
else
   c := Str( c, 7, 2 )   && 1998.10
   maxn := Val( SubStr( c, 6 ))
   c := Left( c, 4 )     && 1998
   c += '.00'            && 1998.00
   c += g                && 1998.00Z.P.D.
   lpp := PITGetLP( c )
   DBSeek( Str( lpp ) + '  1' )
   while LP_PIT = lpp .and. NUMER <= maxn .and. !Eof()
         if !ANULOWANO
            wy += &b
         endif
         skip
   enddo
endif

DBGoTo( rr )

Select( bb )

return wy

******************************************************************************

function PITGetLP( c )

local lpp, rr

rr := PIT->( RecNo())
PIT->( DBSetOrder( 2 ))
PIT->( DBSeek( c ))
lpp := PIT->LP              && LP innego PITu, np. poprzedniego miesiÜca
PIT->( DBGoTo( rr ))

return lpp

******************************************************************************
* b - seekklucze ("28,29,-30,-31")

function PPozycja( b, d, e, f, a, c, g )

local wy := 0, bb, mn, rr, bbb

while !Empty( b )
      mn := 1
      bb := Odetnij( @b )
      if Left( bb, 1 ) == '-'
         mn := -1
         bb := SubStr( bb, 2 )
      endif
      if ( baza )->NUMER < Val( bb )  && stoimy na < pozycji niß ta w formule
         bbb := Str(PIT->LP) + PadL( Val( bb ), 3) && namiar na tÜ p¢¶niejszÜ
         rr := ( baza )->( RecNo())                && zapamiëtaj miejsce tu
         ( baza )->( DBSeek( bbb ))                && skocz tam
         ( baza )->( PITPrzelicz( 1 ))             && oblicz jÜ ( tylko 1 )
         ( baza )->( DBGoTo( rr ))                 && i wracaj tu
      endif
      wy += mn * Pozycja( bb, d, e, f, a, c, g )
enddo

return wy

******************************************************************************
* b - seekklucz
* a - baza     ( "PITP" )
* c - inny PIT ( "Str( PIT->ROK_MC - 0.01, 7, 2 ) + 'PIT-5'" )
* d - zmiana znaku 1 (".")
* e - zmiana znaku 1 (",")
* f - zmiana maski wyniku
* g - inne pole niß "KWOTA"

function Pozycja( b, d, e, f, a, c, g )

local wy := 0, rr, lpp

if a = NIL; a := baza; endif
if g = NIL; g := 'KWOTA'; endif
if d # NIL; znak_1 := d; endif
if e # NIL; znak_2 := e; endif
if f # NIL; maska  := f; endif

if c = NIL
   lpp := PIT->LP
else
   lpp := PITGetLP( c )
endif

b := Str( lpp ) + PadL( b, 3 )
rr := ( a )->( RecNo())
( a )->( DBSeek( b ))
wy := ( a )->( &g )
if g = 'TEKST'
   wy := AllTrim( wy )
endif
( a )->( DBGoTo( rr ))

return wy

******************************************************************************
* a - kwota
* b - rodzaj deklaracji ("STAWKI")
* c - rok_mc (1998.10)
* d - zmiana znaku 1 (".")
* e - zmiana znaku 1 (",")
* f - zmiana maski wyniku

function Podatek( a, b, c, d, e, f )

local wy := 0, rr, lpp, k[10], jest, i, n, x

if b = NIL; b := 'STAWKI'; endif
if c = NIL; c := PIT->ROK_MC; endif
if x = NIL; x := PIT->ROK_MC; endif
if d # NIL; znak_1 := d; endif
if e # NIL; znak_2 := e; endif
if f # NIL; maska  := f; endif

rr := PIT->( RecNo())
PIT->( DBSetOrder( 2 ))

i := 0
jest := .f.
n := Val( Left( AllS( c ), 4 ))
while i < 100
   c := Left( AllS( n ), 4 ) + '.00' + b    && "1998.00STAWKI"
   if ( lpp := PITGetLP( c )) <> 0
      jest := .t.
      exit
   endif
   i ++
   n --
enddo

PIT->( DBGoTo( rr ))

if !jest
   Alarm( 'Brak okreûlenia stawek podatkowych.')
   return 0
endif

rr := PITP->( RecNo())

PITP->( DBSeek( Str( lpp ) + '  1' )); k[1] := PITP->KWOTA  && ulga do progu 1
PITP->( DBSeek( Str( lpp ) + '  2' )); k[2] := PITP->KWOTA  && prog 1 zí.
PITP->( DBSeek( Str( lpp ) + '  3' )); k[3] := PITP->KWOTA  && prog 1 %

PITP->( DBSeek( Str( lpp ) + '  5' )); k[5] := PITP->KWOTA  && prog 2 zí.
PITP->( DBSeek( Str( lpp ) + '  6' )); k[6] := PITP->KWOTA  && prog 1 ryczaít
PITP->( DBSeek( Str( lpp ) + '  7' )); k[7] := PITP->KWOTA  && prog 2 %

PITP->( DBSeek( Str( lpp ) + '  9' )); k[9] := PITP->KWOTA  && prog 2 ryczaít
PITP->( DBSeek( Str( lpp ) + ' 10' )); k[10]:= PITP->KWOTA  && ponad 2 %

PITP->( DBGoTo( rr ))

do case
   case a < k[2]; wy := Grosz(  a         * k[3] * 0.01 ) - k[1]  && Grosz((( k[1] / 12 ) * 100 * ( x - Int( x ))))
   case a < k[5]; wy := Grosz(( a - k[2]) * k[7] * 0.01 ) + k[6]
   otherwise    ; wy := Grosz(( a - k[5]) * k[10]* 0.01 ) + k[9]
endcase

return wy

******************************************************************************

function PITDef( a, b, x )

local wy := '', k := 0

private znak_1, znak_2, maska

maska  := if( !Empty( PIT->MASKA ), PIT->MASKA, '9,999,999.99' )
znak_1 := if( !Empty( PIT->ZNAK_T ), PIT->ZNAK_T, '' )
znak_2 := if( !Empty( PIT->ZNAK_U ), PIT->ZNAK_U, ' ' )

if Empty( a )
   if vp[4] # 0
      wy := Transform( vp[4], maska )
      wy := StrTran( wy, '.', '~' )
      wy := StrTran( wy, ',', znak_1 )
      wy := StrTran( wy, '~', ',' )
      vp[5] := PadR( wy, 100 )
   endif
else
   do case
      case a = 'mm-rrrr'
           wy := Str( 100 * ( PIT->ROK_MC - Int( PIT->ROK_MC )), 2 )
           wy := StrTran( wy, ' ', '0' )
           wy += '-'
           wy += Str( Int( PIT->ROK_MC ), 4 )
      case a = 'mm'
           wy := SubStr(Str(PIT->ROK_MC,7,2),6,2)
      case a = 'rrrr'
           wy := Left(Str(PIT->ROK_MC,7,2),4)
      case Left( a, 1 ) == '='
           k := RunCommand( SubStr( a, 2 ))
           if ValType( k ) = 'C'
              wy := k
              k := 0
           else
              if k = 0 .and. vp[11] # 'T'
                 wy := Space( 100 )
              else
                 wy := Transform( k, maska )
                 wy := StrTran( wy, '.', '~' )
                 wy := StrTran( wy, ',', znak_1 )
                 wy := StrTran( wy, '~', znak_2 )
              endif
           endif
   endcase

   if x # NIL; wy := PadR( wy, x ); endif

   vp[4] := k
   vp[5] := wy

endif

return .t.

******************************************************************************
* mode # NIL => przelicz ten na kt¢rym stoisz

procedure PITPrzelicz( mode )

local rr := RecNo(), i
private vp[ FCount()]

if mode = NIL
   go top
endif
while !Eof()
      for i := 1 to FCount()
          vp[ i ] := FieldGet( i )
      next
      PITDef( vp[ 3 ], vp[ 5 ])
      for i := 1 to FCount()
          FieldPut( i, vp[ i ])
      next
      if mode # NIL
         exit
      endif
      skip

enddo
zmiana:=.t.
DBGoTo( rr )
wy := 2

******************************************************************************

procedure ZUSDRARNA( katKDU, katPP )

local plik := '', x, rna, dra, x1, x2, x3, x4, x5
local tekst, tekstlen, tekstwy, linia

plik := Freshest( katKDU, '*.kdu' )
tekst := MemoRead( plik )
tekstwy := ''
RunCommand( 'run del zus_?.txt' )
while ( tekstlen := Len( tekst )) > 0
      x := At( EOL, tekst )
      linia := Left( tekst, x - 1 )
      tekst := SubStr( tekst, x + 2 )
      tekstwy += linia + EOL
      do case
      case ZUSLine( '<ZSDRAI>', linia ); MemoWrit( 'ZUS_1.txt', tekstwy ); tekstwy := ''
      case ZUSLine( '</ZUSDRA.DP>', linia ); MemoWrit( 'ZUS_DRA.txt', tekstwy ); tekstwy := ''
      case ZUSLine( '<DDORNA>', linia )
           if !File( 'ZUS_2.txt' )
              MemoWrit( 'ZUS_2.txt', tekstwy )
           endif
           tekstwy := ''
      case ZUSLine( '</ZUSRNA.DP>', linia ); MemoWrit( 'ZUS_RNA.txt', tekstwy ); tekstwy := ''
      endcase
enddo
MemoWrit( 'ZUS_3.txt', tekstwy )
tekstwy := ''

dra := {}
tekst := MemoRead( 'ZUS_DRA.txt' )
while ( tekstlen := Len( tekst )) > 0
      x := At( EOL, tekst )
      linia := Left( tekst, x - 1 )
      if !ZUSLine( '<', linia ); Aadd( dra, Len( linia )); endif
      tekst := SubStr( tekst, x + 2 )
enddo
tekst := ''

rna := {}
tekst := MemoRead( 'ZUS_RNA.txt' )
while ( tekstlen := Len( tekst )) > 0
      x := At( EOL, tekst )
      linia := Left( tekst, x - 1 )
      if !ZUSLine( '<', linia ); Aadd( rna, Len( linia )); endif
      tekst := SubStr( tekst, x + 2 )
enddo
tekst := ''

tekst := MemoRead( 'ZUS_1.txt' )
tekst += ZUSDRA( dra, 1, ZUSSum( 'sue_Z' ) + ZUSSum( 'suepZ' ))
tekst += ZUSDRA( dra, 2, ZUSSum( 'sur_Z' ) + ZUSSum( 'surpZ' ))
tekst += ZUSDRA( dra, 3, x1 := ( ZUSSum( 'sur_Z' ) + ZUSSum( 'surpZ' ) + ZUSSum( 'sue_Z' ) + ZUSSum( 'suepZ' )))
tekst += ZUSDRA( dra, 4, ZUSSum( 'sue_Z' ))
tekst += ZUSDRA( dra, 5, ZUSSum( 'sur_Z' ))
tekst += ZUSDRA( dra, 6, ZUSSum( 'sur_Z' ) + ZUSSum( 'sue_Z' ))
tekst += ZUSDRA( dra, 7, ZUSSum( 'suepZ' ))
tekst += ZUSDRA( dra, 8, ZUSSum( 'surpZ' ))
tekst += ZUSDRA( dra, 9, ZUSSum( 'surpZ' ) + ZUSSum( 'suepZ' ))
tekst += ZUSDRA( dra, 10 )
tekst += ZUSDRA( dra, 11 )
tekst += ZUSDRA( dra, 12 )
tekst += ZUSDRA( dra, 13 )
tekst += ZUSDRA( dra, 14 )
tekst += ZUSDRA( dra, 15 )
tekst += ZUSDRA( dra, 16 )
tekst += ZUSDRA( dra, 17 )
tekst += ZUSDRA( dra, 18 )
tekst += ZUSDRA( dra, 19, ZUSSum( 'such_Z' ))
tekst += ZUSDRA( dra, 20, ZUSSum( 'suchpZ' ))
tekst += ZUSDRA( dra, 21, x2 := ( ZUSSum( 'suchpZ' ) + ZUSSum( 'such_Z' )))
tekst += ZUSDRA( dra, 22, ZUSSum( 'such_Z' ))
tekst += ZUSDRA( dra, 23 )
tekst += ZUSDRA( dra, 24, ZUSSum( 'such_Z' ))
tekst += ZUSDRA( dra, 25, ZUSSum( 'suchpZ' ))
tekst += ZUSDRA( dra, 26, ZUSSum( 'suchpZ' ))
tekst += ZUSDRA( dra, 27 )
tekst += ZUSDRA( dra, 28 )
tekst += ZUSDRA( dra, 29 )
tekst += ZUSDRA( dra, 30 )
tekst += ZUSDRA( dra, 31 )
tekst += ZUSDRA( dra, 32, x1 + x2 )
tekst += '</ZSDRAI>' + EOL
tekst += '<ZWDRA>' + EOL
tekst += ZUSDRA( dra, 33 )
tekst += ZUSDRA( dra, 34 )
tekst += ZUSDRA( dra, 35 )
tekst += ZUSDRA( dra, 36 )
tekst += ZUSDRA( dra, 37 )
tekst += '</ZWDRA>' + EOL
tekst += '<RIVDRA>' + EOL
tekst += ZUSDRA( dra, 38 )
tekst += ZUSDRA( dra, 39, x1 + x2 )
tekst += '</RIVDRA>' + EOL
tekst += '<ZSDRA>' + EOL
tekst += ZUSDRA( dra, 40, ZUSSum( 'suz_Z' ))
tekst += ZUSDRA( dra, 41 )
tekst += ZUSDRA( dra, 42 )
tekst += ZUSDRA( dra, 43, x3 := ZUSSum( 'suz_Z' ))
tekst += '</ZSDRA>' + EOL
tekst += '<ZDRAV>' + EOL
tekst += ZUSDRA( dra, 44, ZUSSum( 'fpracyZ' ))
tekst += ZUSDRA( dra, 45, ZUSSum( 'fgspZ' ))
tekst += ZUSDRA( dra, 46, x4 := ZUSSum( 'fgspZ' ) + ZUSSum( 'fpracyZ' ))
tekst += '</ZDRAV>' + EOL
tekst += '<LSKD>' + EOL
tekst += ZUSDRA( dra, 47, x1+x2+x3+x4 )
tekst += '</LSKD>' + EOL
tekst += '<KNDK>' + EOL
tekst += ZUSDRA( dra, 48 )
tekst += ZUSDRA( dra, 49 )
tekst += ZUSDRA( dra, 50 )
tekst += ZUSDRA( dra, 51 )
tekst += '</KNDK>' + EOL
tekst += '<DDDU>' + EOL
tekst += ZUSDRA( dra, 52 )
tekst += ZUSDRA( dra, 53 )
tekst += ZUSDRA( dra, 54 )
tekst += ZUSDRA( dra, 55 )
tekst += ZUSDRA( dra, 56 )
tekst += '</DDDU>' + EOL
tekst += '<OPLS>' + EOL
tekst += '00000' + EOL
tekst += '00001' + EOL
tekst += '00000' + EOL
tekst += '00000' + EOL
tekst += '00000' + EOL
tekst += '00001' + EOL
tekst += '        ' + EOL
x5 := DtoS( Datee())
tekst += SubStr( x5, 7, 2 ) + SubStr( x5, 5, 2 ) + Left( x5, 4 ) + EOL
tekst += '</OPLS>' + EOL
tekst += '</ZUSDRA>' + EOL
tekst += '<stopka.DP>' + EOL
tekst += '</stopka.DP>' + EOL
tekst += '</ZUSDRA.DP>' + EOL

*tekst += MemoRead( 'ZUS_2.txt' )
tekst += MemoRead( 'ZUS_3.txt' )
MemoWrit( 'ZUS.txt', tekst )

if katPP # NIL .and. File( katPP )
   MemoWrit( katKDU + '\ZUS.KDU', tekst )
   RunCommand( 'run ' + katPP + ' ' + katKDU + '\ZUS.KDU' )
endif

*     tekstwy += Konwert( linia, zus, maz ) + EOL
******************************************************************************

function ZUSSum( kod )
return 0

******************************************************************************

function ZUSDRA( tab, i, w )

if w = NIL
   x := Space( 50 )
else
*   x := Str( w, 20, 2 )
   x := Str( i, 20, 2 )
   x := StrTran( x, '.', '' )
   x := StrTran( x, ' ', '0' )
endif

return Right( x, tab[ i ]) + EOL

******************************************************************************
* ZUSLine( '</INN7>', linia )

function ZUSLine( s, l )

return Left( l, Len( s )) == s

******************************************************************************
* n = ile sí¢w
* n <= 0  = ileû tam pustych linii i kreska
* n = NIL = sumy ko§cowe
* nn = 3 od 3 indeksu tablicy tytuí¢w drukowaç "Razem:"
* sep = separator (domyûlnie "-")
* raz = síowo "Razem:"
* czylplac - wyb¢r, czy LPLAC, czy LPRAC jest rdzeniem nazwy bazy gí¢wnej
* rdzen - podanie rdzenia: LPRAZ
* if odstep # NIL .and. LPDPD->KOD == 'zlam_linie'
* ilens - iloûç pracownik¢w na stronie
* pliknag - w jakim pliku w katalogu "cat_main" jest nagí¢wek strony
* dwa # NIL - sÜ dwa ( lub wiëcej ) pliki nagí¢wkowe dla dw¢ch linii liczb
* sep2 - drugi separator dla nagí¢wka wydruk¢w 1A, 1A, 1B, 2B
* poledruku = 'DRUKOWAC' lub 'NAKARCIE'

function TytWydruku( n, nn, sep, raz, czylplac, rdzen, odstep, ilens, pliknag, dwa, sep2, poledruku )

static kreska, lpns, lpstr

local x := 0, y, j, s, warunek
local tab := {}, tabn := {}, tabm := {}, tabx := {}, tabl := {}  &&, tabz := {}

sep := if( sep = NIL, "-", sep )
raz := if( raz = NIL, "Razem:", raz )
czylplac := if( czylplac = NIL, .t., czylplac )
poledruku := if( poledruku = NIL, 'DRUKOWAC', poledruku )
poledruku := 'LPDPD->' + poledruku

if n = NIL
   ?
elseif n > 0      && druk nagí¢wk¢w
   lpns := 1
   lpstr:= 1
elseif n < 1
   n := -n
   for j := 2 to n; ?; next         && przerwa
   if n > 0
      ? Replicate( sep, kreska )    && kreska
   endif
   if nn = NIL                      && nie sumy ko§cowe, wiëc
      if ilens # NIL                && chyba íamiemy stronë
         lpns ++
         if lpns > ilens            && teraz
            if dwa = NIL
               ?
               ? 'Strona Nr ' + AllS( lpstr ) +;
                 if( stronaABC = 0, '', Chr( 64 + stronaABC )) +;
                 Konwert( ', przeniesienie na stronë Nr ' ) + AllS( lpstr + 1 ) +;
                 if( stronaABC = 0, '', Chr( 64 + stronaABC ))
            endif
            ?? EJE
            if pliknag # NIL .and. !Empty( pliknag )
               Print(Firma(cat_main+"\"+pliknag,0),1)
               if stronaABC > 0 .and. sep2 # NIL
                  ? Replicate( sep2, kreska )    && kreska
                  Print(Firma(cat_main+"\"+AllS( stronaABC ) + '.prn', 0 ), 0 )  && 1.prn, 2.prn, 3.prn ...
               endif
            endif
            lpns := 1
            lpstr ++
         endif
      endif
      return                        && koniec
   else           && sumy ko§cowe, wiëc
      n := NIL    && nie nagí¢wki
      ?
   endif
endif

if n = NIL
   Aadd( tabl, '' )                 && miejsce na linië sum
endif

i := 1
j := Str( ID )

if czylplac
   *ON( 'LPLACP' , 2 ); DBSeek( Str( LPLAC->ID ))
   ON( 'LPLACPP', 3 ); DBSeek( Str( LPLAC->ID ) + j )
   warunek := { || ( Str( LPLAC->ID ) + j ) == ( Str( ID_LPLAC ) + Str( ID_LPLACP ))}
else
   if rdzen = NIL; rdzen := 'LPRAC'; endif
   *ON( rdzen + 'P' , 2 ); DBSeek( Str( LPRAC->ID ))
   ON( rdzen + 'PP', 3 ); DBSeek( Str( LPRAC->ID ) + j )
   warunek := { || ( Str( LPRAC->ID ) + j ) == ( Str( ID_LPRAC ) + Str( ID_LPRACP ))}
endif
while Eval( warunek ) .and. !Eof()
      if czylplac
         y := AllTrim( LPDPD->(GetPole(1,'LPLACPP->ID_LPDPD','MASKA')))
      else
         y := AllTrim( LPDPD->(GetPole(1, rdzen + 'PP->ID_LPDPD','MASKA')))
      endif
      Aadd( tabm, y )   && díugoûci element¢w wszystkich
      y := if(IsDigit( y ),Len( y ),Len(Transform(Replicate(sep,100), y )))
      if !( &poledruku == "N" )
         x += y + 1    && zwiëkszenie díugoûci linii
      else
         y := -y       && nie drukowaç
      endif
      Aadd( tab, y )   && díugoûci element¢w drukowanych
      if odstep # NIL .and. LPDPD->KOD == 'zlam_linie'
*         Aadd( tabz, Len( tab ))   && zanotowanie elementu miejsca íamiÜcego
         Aadd( tabx, x - 2 )        && zanotowanie aktualnej díugoûci linii
      endif
      if n = NIL                    && sumy ko§cowe
         if !( &poledruku == "N" )
            if i < nn - 1
               tabl[ 1 ] += " " + Space( Abs( y ))
            elseif i = nn - 1
               tabl[ 1 ] += " " + PadL( raz, Abs( y ))
            else
               y := i - nn + 1
               if y < 1 .or. y > Len( tabs )
                  y := Len(tabs)
               endif
               s := Transform( tabs[ y ], if( !( LPDPD->ZERA_TEZ == "T" ), '@Z ', '' ) + tabm[ i ])
               if rdzen # NIL .and. !( Left( rdzen, 1 ) == Upper( Left( rdzen, 1 )))
                  tabl[ 1 ] += EOL+PadL(AllTrim(StrTran(StrTran(LPDPD->(GetPole(1,'LPRAZPP->ID_LPDPD','NAZWA')),"_"," "),"- ","")),50)+":"
               endif
               tabl[ 1 ] += " " + if( !( LPDPD->SUMOWAC == "N" ), TU( s, LPDPD->ZNAK_T, LPDPD->ZNAK_U ), Space( Abs( tab[ i ])))
            endif
         endif
         i++
      endif
      Aadd( tabn, LPDPD->NAZWA ) && nagí¢wki wszystkie
      skip
enddo

if Len( tabx ) > 0   && ustalenie najdíußszej kreski
   Aadd( tabx, x - 2 * Len( tabx ))  && zanotowanie caíkowitej díugoûci linii
   x := tabx[ 1 ]
   for i := 2 to Len( tabx )
       x := Max( odstep + tabx[ i ] - tabx[ i - 1 ], x )
   next
endif

if n = NIL
   if Len( tabx ) > 0   && drukowanie serii poíamanych podsumowa§
      if stronaABC < 2  && 0, 1
         y := 1
         for j := 1 to 1
             ?? SubStr( tabl[ j ], y, tabx[ 1 ])
         next
      endif
      odstep -= 2       && díugoûç elementu 'zlam_linie'
      for i := 2 to Len( tabx )
          y := tabx[ i - 1 ] + 1
          if stronaABC = 0 .or. stronaABC = i
             for j := 1 to 1
                 if stronaABC = 0; ?; endif
                 ?? Space( odstep ) + SubStr( tabl[ j ], y, tabx[ i ] - tabx[ i - 1 ] + 2 )
             next
          endif
      next
   else
      ?? tabl[ 1 ]
   endif
   if lpstr # NIL .and. lpstr > 0
      ?
      ? 'Strona Nr ' + AllS( lpstr ) +;
        if( stronaABC = 0, '', Chr( 64 + stronaABC )) +;
        ', koniec.'
   endif
   return
endif

kreska := x
x := Replicate( sep, kreska )

?
?? x          && krecha
if n # NIL                 && nagí¢wki

   for j := 1 to n
       Aadd( tabl, '' )
       for i := 1 to Len( tab )
           if tab[ i ] > 0
              tabl[ j ] += " " + Konwert( PadC( Slowo( tabn[ i ], j ), tab[ i ]))
           endif
       next
   next

if Len( tabx ) > 0   && drukowanie serii skr¢conych nagí¢wk¢w
   if stronaABC < 2  && 0, 1
      if dwa # NIL                            && .or. sep2 # NIL
         mOpen( cat_main + '\1.prn' )
      endif
      y := 1
      for j := 1 to n      && pierwsza linia nagí¢wk¢w
          ?
          ?? SubStr( tabl[ j ], y, tabx[ 1 ])
      next
      ?
      ?? x           && krecha
   endif
   odstep -= 2       && díugoûç elementu 'zlam_linie'
   for i := 2 to Len( tabx )      && nastëpne linie nagí¢wk¢w
       if stronaABC = 0 .or. stronaABC = i
          if dwa # NIL                            && .or. sep2 # NIL
             mOpen( cat_main + '\' + AllS( i ) + '.prn' )    && 2.prn, 3.prn ...
          endif
          y := tabx[ i - 1 ] + 1
          for j := 1 to n
              ?
              ?? Space( odstep ) + SubStr( tabl[ j ], y, tabx[ i ] - tabx[ i - 1 ])
          next
          ?
          ?? x           && krecha
       endif
   next
else
   for j := 1 to n
       ?
       ?? tabl[ j ]
   next
   ?
   ?? x           && krecha
endif
*?

endif

*******************************************************************************
* odstep = NIL - 'zlam_linie' ignorowane
* odstep > -1  - 'zlam_linie' = EOL + Space( odstep )
* odstep <  0  - 'zlam_linie' = next page
* dwa # NIL => dwa nagí¢wki oddzielone kreskÜ

function LPLACWartosc( odstep, dwa, bb )

static lp_zlam_linie := 0, zlamano := .f.

local x, w

if bb = NIL; bb := 'LPLACPP'; endif

x := AllTrim( LPDPD->( GetPole( 1, bb + '->ID_LPDPD', 'MASKA' )))

if odstep # NIL                        && .and. dwa # NIL
   if AllTrim( LPDPD->KOD ) == 'lp' .or.;
      AllTrim( LPDPD->KOD ) == 'nazwiskoim' .or.;
      AllTrim( LPDPD->KOD ) == 'mies' .or.;
      AllTrim( LPDPD->KOD ) == 'dzie'
      lp_zlam_linie := 1
   endif
endif

if odstep # NIL                        && z íamaniem
   if LPDPD->KOD == 'zlam_linie'       && teraz íamanie
      lp_zlam_linie ++                 && nastëpna strona lub linia
      zlamano := .t.                   && jest íamanie linii
      if stronaABC = 0 .or. stronaABC = lp_zlam_linie - 1
         if dwa # NIL                  && nagí¢wki oddzielane kreskÜ
            dwa := MemoRead( cat_main+'\1.prn' )
            ? RTrim( MemoLine( dwa, 254, MlCount( dwa, 254 )))       && krecha
            Print(Firma(cat_main+"\"+AllS( lp_zlam_linie ) + '.prn', 0 ), 0 )  && 2.prn, 3.prn ...
         endif
      endif
      return NIL
   endif
endif

if stronaABC = 0 .or. stronaABC = lp_zlam_linie
   if odstep # NIL .and.;          && moßna íamaç
      lp_zlam_linie > 1 .and.;     && to jest drugi i dalsze kawaíki linii
      zlamano                      && za poprzednim przebiegiem íamano linië
      zlamano := .f.               && wyíÜcz
      ?? if( stronaABC = 0, EOL, '' ) + Space( odstep )
   endif
   if IsDigit( x )
      w := Left( WARTOSC, Len( x ))
   else
      w := Transform( WARTOSC, x )
   endif
endif

return w

******************************************************************************
* wydruk listy w formie 1 wiersz na kilku stronach
* a = 'lplacl'    && konkretne strony ( A, B, C ... )
* o = 'lplacls0'  && nagí¢wki przyszíych stron
* b = 'lplacls1'  && wszystkie strony: pierwsza strona
* c = 'lplacls2'  && wszystkie strony: reszta stron

procedure LPLAC3s( a, o, b, c )

local x, i, n, bb := Alias(), mm := {}

ON( 'LPDPD', 2 )
if !DBSeek( Upper( 'zlam_linie' ))
   Alarm( 'Brak elementu "zlam_linie" w definicjach pozycji' )
   Select( bb )
   return
endif

ON( 'LPLACPP', 4 )   &&  Str(ID_LPDPD)+Str(ID_LPLAC)+Str(ID_LPLACP)
if !DBSeek( Str( LPDPD->ID ) + Str( LPLAC->ID ))
   Alarm( 'Brak elementu "zlam_linie" na tej liûcie' )
   Select( bb )
   return
endif

n := 0                  && liczymy elementy "zlam_linie"
x := Str( ID_LPLACP )
while Str( LPDPD->ID ) + Str( LPLAC->ID ) + x == Str(ID_LPDPD)+Str(ID_LPLAC)+Str(ID_LPLACP) .and. !Eof()
      n ++              && jest kolejny
      skip
enddo

Aadd( mm, '1. Wszystkie strony' )
for i = 1 to n + 1
    Aadd( mm, AllS( i + 1 ) + '. Strony "' + Chr( 64 + i ) + '"' )
next

if ( 0 = ( x := Alarm( 'Wybierz wariant wydruku stron:', mm )))
   Select( bb )
   return
endif
 
Select( bb )

if x = 1                && wszystkie
   Czek( 1 )
   LPLAC->( Drukuj( o, 1 ))               && nagí¢wki
   mOpen( cat_wydr + b + '.txt' )
   for i = 1 to n + 1
       stronaABC := i
       if i = 1
          LPLAC->( Drukuj( b, 1 ))        && pierwsza strona
       else
          LPLAC->( Drukuj( c, 1 ))        && nastëpne
       endif
   next
   mClose()
   Czek( 0 )
   if ( NIL # Druk( cat_wydr + b + '.txt' , 1 )) && pierwszy wydruk poszedí
      while PROP_KOPIA .and. ( NIL # Druk( cat_wydr + b + '.txt' , 1 )); enddo
   endif
else
   stronaABC := x - 1   && tylko strony "x - 1"
   LPLAC->( Drukuj( a ))
endif

stronaABC := 0
Select( bb )

******************************************************************************

function Slowo( s, n )

local i := 1, w := '', x

s := AllTrim( s )
while !Empty( s ) .and. i <= n
      x := At( " ", s )
      if x = 0
         if i = n
            w := s
         else
            w := ""
         endif
         exit
      else
         w := Left( s, x - 1 )
         s := SubStr( s, Len( w ) + 2 )
      endif
      i ++
enddo

return StrTran( w, '_', ' ' )

*******************************************************************************

procedure Inccctab( n, d, w )

n := n - d
if n > 0
   ww := w
   ww := StrTran( ww, ',', '' )
   ww := StrTran( ww, '.', '' )
   while Len( tabs ) < n; Aadd( tabs, 0 ); enddo
   tabs[ n ] += Val( ww ) * 0.01
endif

return w

*******************************************************************************
* Kombinacja ACopy i Aadd
* ts - tab source
* td - tab dest
* od - od indeksu ts
* do - do indeksu ts (jak NIL to do ko§ca ts)
* lub
* il - ile od "od" ts
* ot - otoczenie, np. PadC(x,10), gdzie x jest zastëpowany ts[ i ]
* li - ts zawiera liczbë, wiëc trzeba zamieniç to na String
* &ACadd( kolumny, tab, 9,,, 'IncccTab(y,0,TU(Transform(x,"@Z 9,999.99")))' )

procedure ACadd( ts, td, od, do, il, ot, li )

local i, s

if do = NIL; do := Len( ts ); endif
if il # NIL; do := od + il - 1; endif

for i := od to do
    s := ts[ i ]
    if ot # NIL
       if li # NIL; s := Str( s ); endif
       s := StrTran( ot, 'x', s )
       s := StrTran( s, '(y,', '(' + AllS( i ) + ',' )
       s := StrTran( s, '%', '~' )
    endif
    Aadd( td, s )
next

*******************************************************************************
* od, do - linie pliku

function Firma( plik, kod, od, do )

local linie

if plik = NIL; plik := cat_main + '\max.txt'; endif
if kod = NIL; kod := 11; endif

plik := ReadWzor( plik, kod )

linie := ''
if od # NIL .or. do # NIL
   od := if( od = NIL,   1, od )
   do := if( do = NIL, 999, do )
   for i := 1 to MLCount( plik )
       if od <= i .and. i <= do
          linie += if( Len( linie ) = 0, '', EOL ) + MemoLine( plik,, i )
       endif
   next
   plik := linie
endif

if KryteriaS = 1
   plik += EOL + EOL + 'Kryteria uwzglëdniania danych:'
   plik += EOL + Kryteriau + EOL
endif

return plik

*******************************************************************************

procedure LPLACDopisz()

local odp

odp := Alarm( 'Wybierz wariant nowej listy:', { 'Lista píac', 'Lista os¢b kom¢rki organizacyjnej' })

if odp = 0; return; endif

if odp = 1
   if (baza)->ID_LPD = 0
      NewSysDopisz( 'LPLAC,Nowa lista píac,,,73,WSerii(),,,3', 1,, '(baza)->ID:=GetLast(1,1)+1,(baza)->NUMER:=""' )
   else
      NewSysDopisz( 'LPLAC,Nowa lista píac,,,73,WSerii(),,,7', 1,, '(baza)->ID:=GetLast(1,1)+1,(baza)->NUMER:=""' )
   endif
else
   NewSysDopisz( 'LPLACK,Nowa lista os¢b kom¢rki organizacyjnej' +;
   ',,,73,WSerii(),,,7', 1,, '(baza)->ID:=GetLast(1,1)+1,(baza)->NUMER:=""' +;
   ',(baza)->ID_LPD:=0' +;
   ',(baza)->DATA:=CtoD("")' )
endif

******************************************************************************

procedure LPLAC_Przenies( x )

local ekran, n, cat

if NIL = Get_Okres( @data_od, @data_do, 'Przeniesienie list píac z okresu:', 10 )
   return
endif

ON( 'LPLAC' )           && LPLAC z katalogu gí¢wnego
DBGoBottom()
if ID_LPD # 0 .and. data_od <= DATA .and. DATA <= data_do
   Zwolnij( 'LPLAC' )
   Alarm( 'Podany okres czasu obejmie r¢wnieß;ostatniÜ listë, a tego robiç nie wolno.' )
   return
endif
Zwolnij( 'LPLAC' )      && zwalniamy LPLAC z katalogu gí¢wnego

ekran := SaveScreen()

cat := cat_main                     && prawdziwy cat_main

if !CatSwich( x ); return; endif    && nowy cat_main

buf := cat + '\LPRAC.db?'; run copy &buf
buf :=        'LPRAC?.ntx'; run del &buf

buf := cat + '\LPD.db?'; run copy &buf
buf :=        'LPD?.ntx'; run del &buf

buf := cat + '\LPDP.db?'; run copy &buf
buf :=        'LPDP?.ntx'; run del &buf

buf := cat + '\LPDPD.db?'; run copy &buf
buf :=        'LPDPD?.ntx'; run del &buf

RestScreen(,,,, ekran )

Czek( 1 )

*if !Eof()
*   Zwolnij( 'LPLAC' )
*   Alarm( 'Wybierz inny katalog, bo;w podanym katalogu sÜ juß dane!' )
*   CatSwich()
*   return
*endif

ON( 'LPLAC' ); n := LastRec()           && LPLAC z archiwum
append from ( cat + '\LPLAC.DBF' ) for ID_LPD # 0 .and. data_od <= DATA .and. DATA <= data_do
n := LastRec() - n

ON( 'LPLACP' )
append from ( cat + '\LPLACP.DBF' ) for JestLista( ID_LPLAC )
Zwolnij( 'LPLACP' )

ON( 'LPLACPP' )
append from ( cat + '\LPLACPP.DBF' ) for JestLista( ID_LPLAC )
Zwolnij( 'LPLACPP' )

CatSwich(,,1)        && katalog gí¢wny bez zamykania "LPLAC" w archiwum

ON( 'LPLACP' )
delete for JestLista( ID_LPLAC )
Zwolnij( 'LPLACP' )

ON( 'LPLACPP' )
delete for JestLista( ID_LPLAC )
Zwolnij( 'LPLACPP' )

Zwolnij( 'LPLAC' )      && zwalniamy LPLAC z archiwum

ON( 'LPLAC' )           && LPLAC z katalogu gí¢wnego
delete for ID_LPD # 0 .and. data_od <= DATA .and. DATA <= data_do
Zwolnij( 'LPLAC' )

*ON( 'LPLAC',,,,, .t. ); Zwolnij( 'LPLAC' )
*ON( 'LPLACP',,,,, .t. ); Zwolnij( 'LPLACP' )
*ON( 'LPLACPP',,,,, .t. ); Zwolnij( 'LPLACPP' )

RestScreen(,,,, ekran )

Alarm( 'Przeniesiono ' + Alls( n ) + ' list píac;z okresu: ' + DtoC( data_od ) + '-' + DtoC( data_do ))

******************************************************************************

function JestLista( x )

return LPLAC->ID = x .or. LPLAC->( DBSeek( x ))

******************************************************************************
* im - import ?

procedure LPLACImpExp( im )

local buf, ii, rr

ii := LPLAC->( IndexOrd())
rr := LPLAC->( RecNo())

if im = NIL
   im := ( Alarm( 'Wybierz wariant procedury:', { 'Import', 'Export' }) = 1 )
elseif im
   if Alarm( 'Importowaç listy píac?', nt ) # 2; return; endif      
else
   if Alarm( 'Exportowaç listy píac?', nt ) # 2; return; endif
endif

if im

if File( 'c:\ARCHIWUM\_PLAC.DBF' ) .and.;
   File( 'c:\ARCHIWUM\_PLACP.DBF' ) .and.;
   File( 'c:\ARCHIWUM\_PLACPP.DBF' )

   ON( 'LPLACZ',,,, .t. )           && gwiazdki sio

   LPLAC->( DBSetOrder( 1 ))        && ID
   LPLAC->( DBGoBottom())

   buf := LPLAC->ID

   use ( 'c:\ARCHIWUM\_PLACPP' ) new
   use ( 'c:\ARCHIWUM\_PLACP' ) new
   use ( 'c:\ARCHIWUM\_PLAC' ) new

else

   Alarm( 'Brak kompletu baz danych do importu.' )
   return

endif

Select( '_PLAC' ); go top
while !Eof()

      buf++

      KopiujRec( '_PLAC', 'LPLAC' ); LPLAC->ID := buf
      Mark( 'LPLACZ', LPLAC->ID )

      Select( '_PLACP' ); go top
      while !Eof()
            if ID_LPLAC = _PLAC->ID
               KopiujRec( '_PLACP', 'LPLACP' ); LPLACP->ID_LPLAC := buf
            endif
            skip
      enddo

      Select( '_PLACPP' ); go top
      while !Eof()
            if ID_LPLAC = _PLAC->ID
               KopiujRec( '_PLACPP', 'LPLACPP' ); LPLACPP->ID_LPLAC := buf
            endif
            skip
      enddo

      Select( '_PLAC' ); skip

enddo

Select ( '_PLAC' ); use
Select ( '_PLACP' ); use
Select ( '_PLACPP' ); use

else

   LPLACZ->( DBGoTop())
   if LPLACZ->( Eof())
      if Alarm( 'Brak zaznacze§ list do exportu.;Czy ma to byç bießÜca lista?', tk ) # 1
         return
      endif
      LPLACZ->( DBAdd())
      LPLACZ->POLE := LPLAC->ID
   endif

Czek( 1 )

LPLAC->( DBSetOrder( 1 ))        && ID
LPLACP->( DBSetOrder( 2 ))       && Str(ID_LPLAC)+Str(ID)
LPLACPP->( DBSetOrder( 2 ))      && Str(ID_LPLAC)+Str(ID_LPLACP)+Str(ID_LPDPD)

Select( 'LPLAC' ); copy to ( 'c:\ARCHIWUM\_PLAC' ) while .f.

Select( 'LPLACP' ); copy to ( 'c:\ARCHIWUM\_PLACP' ) while .f.
Select( 'LPLACPP' ); copy to ( 'c:\ARCHIWUM\_PLACPP' ) while .f.

use ( 'c:\ARCHIWUM\_PLAC' ) new
use ( 'c:\ARCHIWUM\_PLACP' ) new
use ( 'c:\ARCHIWUM\_PLACPP' ) new

Select( 'LPLACZ' ); DBGoTop()
Przerwa( LastRec(),,1)
while LPLACZ->( !Eof())
      LPLAC->( DBSeek( LPLACZ->POLE ))          && lista
      LPLACP->( DBSeek( Str(LPLAC->ID)))        && pozycja
      LPLACPP->( DBSeek( Str(LPLAC->ID)))       && pozycja pozycji
      while LPLACP->ID_LPLAC = LPLAC->ID .and.;
            LPLACP->( !Eof())
            if LPLACPP->( DBSeek( Str(LPLAC->ID)+Str(LPLACP->ID)))
               while LPLACPP->ID_LPLAC = LPLAC->ID .and.;
                     LPLACPP->ID_LPLACP= LPLACP->ID .and.;
                     LPLACPP->( !Eof())
                     KopiujRec( 'LPLACPP', '_PLACPP' )
                     LPLACPP->( DBSkip())
               enddo
            endif
            KopiujRec( 'LPLACP', '_PLACP' )
            LPLACP->( DBSkip())
      enddo
      KopiujRec( 'LPLAC', '_PLAC' )
      LPLACZ->( DBSkip())
      Przerwa(,,1)
enddo
Przerwa( 0,, 1 )
Czek( 0 )

Select ( '_PLAC' ); go top
   while !Eof(); replace ID with -ID; skip; enddo
   use
Select ( '_PLACP' ); go top
   while !Eof(); replace ID_LPLAC with -ID_LPLAC; skip; enddo
   use
Select ( '_PLACPP' ); go top
   while !Eof(); replace ID_LPLAC with -ID_LPLAC; skip; enddo
   use

endif

Select( 'LPLAC' )
LPLAC->( DBSetOrder( ii ))
LPLAC->( DBGoTo( rr ))
wy := 2

******************************************************************************

procedure PRACOdtworz()

local x := ID, bb := Alias()

if Alarm( 'Odtworzyç pracownika Nr ' + AllS( x ) + ' ?', nt ) # 2; return; endif

set deleted off
ON( 'LPLACP', 3 )
DBSeek( Str( x, 10 ))
while x = ID_PRAC .and. !Eof()
      DBRecall()
      skip
enddo
set deleted on

Select( bb )

******************************************************************************
* jesteûmy w buforze LPDP

procedure LPDPExport()

local bb := Alias(), x, dane, i, s, co, k

x := Pad( 'a:\lpdp_exp.txt', 50 )
if NIL = ( x := Get_U( 10, 10, 'Podaj ûcießkë do pliku:', '@S20', x )); return; endif

LPDPD->( DBSetOrder( 1 ))        && ID

k := 1
dane := ''
go top
while !Eof()
      if LPDPD->( DBSeek(( bb )->ID_LPDPD ))
         dane += LPDPD->( KOD + ', ' + NAZWA + ', ' + DEFINICJA ) + EOL
      endif
      skip
enddo

MemoWrit( x, dane )
Select( bb )
wy := 2
go top

******************************************************************************
* jesteûmy w buforze LPDP

procedure LPDPImport()

local bb := Alias(), x, dane, i, s, co, k

x := Pad( 'a:\lpdp_imp.txt', 50 )
if NIL = ( x := Get_U( 10, 10, 'Podaj ûcießkë do pliku:', '@S20', x )); return; endif

LPDPD->( DBSetOrder( 2 ))        && Upper(KOD)

k := 1
dane := MemoRead( x )
for i := 1 to MLCount( dane )
    s := MemoLine( dane, dl_memo, i )     && ogprzychod, K_costam+K_inne ...
    co := AllTrim( Odetnij( @s ))
    if !Empty( co ) .and. LPDPD->( DBSeek( Upper( co )))
       zmiana := .t.
       DBAppend()
       replace ID with k ++
       replace ID_LPD with LPD->ID
       replace ID_LPDPD with LPDPD->ID
    endif
next

Select( bb )
wy := 2
go top

******************************************************************************

procedure FillLPLACPP( pliktxt )

local dane := MemoRead( pliktxt ), i, s, co, na

LPLACPP->( DBSetOrder( 2 ))      && Str(ID_LPLAC)+Str(ID_LPLACP)+Str(ID_LPDPD)
LPDPD->( DBSetOrder( 2 ))        && Upper(KOD)
for i := 1 to MLCount( dane )
    s := MemoLine( dane, dl_memo, i )
    co := AllTrim( Odetnij( @s ))
    na := AllTrim( Odetnij( @s ))
    if !Empty( co ) .and. !Empty( na ) .and. LPDPD->( DBSeek( Upper( co )))
       if LPLACPP->( DBSeek( Str(LPLAC->ID)+Str(LPLACP->ID)+Str(LPDPD->ID)))
          LPLACPP->( Blokuj_R())
          LPLACPP->WARTOSC := Str( LISTYPP->( &na ), 13, 2 )
       endif
    endif
next

******************************************************************************

function ListyOld2New( pliktxt )

local bb := Alias(), x

x := 0
ON( 'LISTY_Z' )
while !Eof()
      x ++
      skip
enddo

Select( bb )
if x = 0
   x := Alarm( 'Brak zaznaczonych list', { 'Wyjûç', 'Export wszystkich list do nowej gaíëzi' })
   if x = 0 .or. x = 1; return; endif
   go top
   while !Eof()
         Mark('LISTY_Z',LP)
         skip
   enddo
else
   if Alarm( 'Export zaznaczonych list do nowej gaíëzi?', tk ) # 1; return; endif
endif

pliktxt := if( pliktxt = NIL, 'old2new.txt', pliktxt )

Select( bb )
DBSetOrder( 1 )

Select( 'LISTY_Z' )
DBGoTop()
while !Eof()

      if !( bb )->( DBSeek( LISTY_Z->( FieldGet( 1 )))); skip; loop; endif

ON( 'LPDPD' )
ON( 'LPDP' )
ON( 'LPD', 2 ); DBSeek( 'STARA' )

ON( 'LPLAC' )
DBAppend()
LPLAC->ID := GetLast( 1, 1 ) + 1
LPLAC->ID_LPD := LPD->ID
LPLAC->NUMER := ( bb )->NUMER
LPLAC->DATA := ( bb )->DATA

ON( 'LPRAC' )

ON( 'LPLACPP' )
ON( 'LPLACP' )

ON( 'LISTYPO' )
ON( 'LISTYPP', 2 )
DBSeek(( bb )->LP )
x := 1
while LP_LISTYP = ( bb )->LP .and. !Eof()
      if LISTYPO->( DBSeek( LISTYPP->LP_LISTYPO ))       && PUBRUTTOW
         LPLACP->( DBAdd())
         LPLACP->ID := x++
         LPLACP->ID_LPLAC := LPLAC->ID
         LPLACP->ID_PRAC := LISTYPO->PUBRUTTOW
         LPLACP->( CSeriiDef( LPLAC->ID, LPD->ID, LPLACP->ID ))
         FillLPLACPP( pliktxt )
      endif
      Select( 'LISTYPP' )
      skip
enddo

Select( 'LISTY_Z' )
skip

enddo

Select( bb )

******************************************************************************
* mode = NIL - pierwsza faza ( alltrim i strtran( '  ', ' ' ))
* mode # NIL - druga    faza ( konwert( maz, bezpl ))

function Unormuj( n, mode )

n := AllTrim( n )
n := StrTran( n, '  ', ' ' )
n := StrTran( n, '  ', ' ' )
n := StrTran( n, '  ', ' ' )
n := StrTran( n, '  ', ' ' )

if mode # NIL
   n := Konwert( n, maz, bezpl )
endif

return n

******************************************************************************
* n = nazwisko i imië

function PracGetID( n )

local imi, naz, x

n := Unormuj( n )
if !DBSeek( Upper( n ))
   x := At( ' ', n )       && spacja rozdzielajÜca imië i nazwisko
   if x > 0                   && jest
      naz := Left( n, x - 1 )    && nazwisko
      imi := SubStr( n, x + 1 )  && imië
      n := imi + ' ' + naz       && zamianka
      if !DBSeek( Upper( n ))       && nie znalazí
         n := Konwert( n, maz, bezpl ) && moße bez polskich znak¢w?
         if !DBSeek( Upper( n ))          && nie znalazí
            go top                           && powolne szukanie
            while !Eof()
                  if Left( Upper( Unormuj( NAZWA, 1 )), Len( n )) == Upper( n )
                     exit
                  endif
                  skip
            enddo
            if Eof()                         && nie znalazí
               n := naz + ' ' + imi             && zamianka
               n := Konwert( n, maz, bezpl )    && moße bez polskich znak¢w?
               go top                              && powolne szukanie
               while !Eof()
                     if Left( Upper( Unormuj( NAZWA, 1 )), Len( n )) == Upper( n )
                        exit
                     endif
                     skip
               enddo
            endif
         endif
      endif
   endif
endif

return ID            && identyfikator lub 0 (=nie znalazí)

******************************************************************************
* pole = 'PUBRUTTOW'

procedure PracWeryf( pole )

local bb := Alias(), rr := RecNo()

if Alarm( 'PowiÜzaç pracownik¢w z tej gaíëzi;z pracownikami z nowej gaíëzi?', tk ) # 1; return; endif

@ 0, 0 say PadR( 'Zerowanie', mc )
go top
while !Eof()
      Blokuj_R()
         replace &pole with 0
      OdBlokuj_R()
      skip
enddo

@ 0, 0 say PadR( 'WiÜzanie', mc )
ON( 'LPRAC', 2 )           && Upper(Left(NAZWA,30))')|
Select( bb )
DBSetOrder( 0 )
go top
while !Eof()
      Blokuj_R()
         replace &pole with LPRAC->( PracGetID(( bb )->NAZWA ))
      OdBlokuj_R()
      skip
enddo

DBGoTo( rr )

******************************************************************************
* pole = 'PUBRUTTOW'

procedure PracPrzepisz( pole )

local bb := Alias(), rr := RecNo(), x

@ 0, 0 say PadR( 'Zliczanie', mc )
x := 0
go top
while !Eof()
      if &pole = 0.00; x ++; endif
      skip
enddo

if Alarm( 'Przepisaç ' + AllS( x ) + ' pracownik¢w do nowej gaíëzi?', nt ) # 2; return; endif

ON( 'LPRAC', 2 )           && Upper(Left(NAZWA,30))')|
Select( bb )
DBSetOrder( 0 )

@ 0, 0 say PadR( 'Przepisywanie', mc )
x := 0
go top
while !Eof()
      if &pole = 0.00
         LPRAC->( DBAppend())
         LPRAC->ID := LPRAC->( GetLast(1,1)+1 )
         LPRAC->NAZWA := ( bb )->NAZWA
         ( bb )->( Blokuj_R())
            replace &pole with LPRAC->ID
         ( bb )->( OdBlokuj_R())
      endif
      skip
enddo

DBGoTo( rr )

******************************************************************************
* Import list ze starej gaíëzi

procedure LPLACImport()

******************************************************************************
* Skraca nazwy list i kom¢rek organizacyjnych

function Skrot( a )

a := StrTran( a, 'Lista píac ', '' )
a := StrTran( a, 'Lista wynagrodze§ ', '' )
a := StrTran( a, 'Lista wypíat ', '' )
a := StrTran( a, 'pracownik¢w ', '' )
a := StrTran( a, 'Pracownicy ', '' )
a := StrTran( a, 'do wynagrodze§ ', '' )

return a

******************************************************************************
* Suma pozycji o kodzie "x", np.: "kuzprzych"

function SumaPoz( x )

local wy := 0, idlplac, idprac, idlpdpd, dt, po_od
local bb := Alias(), ii := IndexOrd(), rr := RecNo()
local ii1, rr1, ii2, rr2, ii3, rr3, ii4, rr4

if x = NIL; return 0; endif
x := Upper( x )

Select( 'LPDPD' ); ii1 := IndexOrd(); rr1 := RecNo()
DBSetOrder( 2 )
if DBSeek('PODATEK_OD'); po_od := CtoD( DEFINICJA ); endif
if !DBSeek( x )
   if Jest_baza( bb )
      DBSetOrder( ii )
      DBGoTo( rr )
   endif
   return 0
endif

x := LPDPD->ID                    && mamy ID elementu sumowanego

if bb == 'ROB2'
   idlplac := ROB2->ID_LPLAC       && mamy listë bießÜcÜ
else
   idlplac := LPLACP->ID_LPLAC       && mamy listë bießÜcÜ
endif

Select( 'LPLAC' ); ii2 := IndexOrd(); rr2 := RecNo()
DBSetOrder( 1 )
DBSeek( idlplac )

dt := LPLAC->DATA                 && mamy datë granicznÜ
idprac := LPLACP->ID_PRAC         && mamy ID pracownika

Select( 'LPLACPP' ); ii4 := IndexOrd(); rr4 := RecNo()

Select( 'LPLACP' ); ii3 := IndexOrd(); rr3 := RecNo()
DBSetOrder( 3 )   && Str( ID_PRAC )
DBSeek( Str( idprac, 10 ))
while LPLACP->ID_PRAC = idprac .and. !Eof()
      LPLAC->( DBSeek( LPLACP->ID_LPLAC ))
      if LPLAC->ID_LPD = 0;     && lista os¢b
         .or.;
			if( po_od = NIL, Year( dt ) # Year( LPLAC->DATA ), LPLAC->DATA < po_od );   && inny rok
         .or.;
         dt < LPLAC->DATA;      && p¢¶niejsza datÜ
         .or.;
         LPLAC->ID >= idlplac   && p¢¶niejsza identyfikatorem
         skip                   && to pomi§
         loop
      endif
      if LPLACPP->( DBSeek( Str( LPLAC->ID ) + Str( LPLACP->ID ) + Str( x, 10 )))
         wy += UT( LPLACPP->WARTOSC )
      endif
      skip
enddo

Select( 'LPDPD' ); DBSetOrder( ii1 ); DBGoTo( rr1 )
Select( 'LPLAC' ); DBSetOrder( ii2 ); DBGoTo( rr2 )
Select( 'LPLACP' ); DBSetOrder( ii3 ); DBGoTo( rr3 )
Select( 'LPLACPP' ); DBSetOrder( ii4 ); DBGoTo( rr4 )

if Jest_baza( bb )
   DBSetOrder( ii )
   DBGoTo( rr )
endif

return wy

******************************************************************************
* Rozszerzenie funkcji "SumaPozP" o wszystkich pracownik¢w

function SumaPrac( x, d1, d2, nr1, nr2, kode, ware, newmaska )

local bb := Alias(), wy, zlicz

wy := 0
zlicz := ( Right( x, 1 ) == ',' )

if newmaska # NIL; maska := newmaska; endif

ON('LPRAC')
while !Eof()
      if zlicz
         if SumaPozP( x, d1, d2, nr1, nr2, kode, ware ) # 0
            wy ++
         endif
      else
         wy += SumaPozP( x, d1, d2, nr1, nr2, kode, ware )
      endif
      Select( 'LPRAC' )
      skip
enddo

Select( bb )
return wy

******************************************************************************
* Rozszerzenie funkcji "SumaPozPP" o znak elementu i jego wieloûç (x='ogrzych,-kuzprzych')
* Suma pozycji pracownika - baza LPRAC jest otwarta na odpowiedniej osobie
* x - nazwa elementu sumowanego
* d1 - d2 - sumowany okres
* d2 = NIL => d1 = rok tekstowo. np.: 2000
* nr1 - ID_LPD uwzglëdnianych list  (rodzaj listy)
* nr2 - ID_LPD2 uwzglëdnianych list (rodzaj kom¢rki org.)
* kode - kod elementu, np.: 'p_podst'
* ware - warunek dla elementu, np.: '>100'

function SumaPozP( x, d1, d2, nr1, nr2, kode, ware )

local s, w := 0, mn

while !Empty( x )
      mn := 1
      s := Odetnij( @x )
      if Left( s, 1 ) == '-'
         s := SubStr( s, 2 )
         mn := -1
      endif
      w += mn * SumaPozPP( s, d1, d2, nr1, nr2, kode, ware )
enddo

return w

******************************************************************************
* Suma pozycji pracownika - baza LPRAC jest otwarta na odpowiedniej osobie
* x - nazwa elementu sumowanego
* d1 - d2 - sumowany okres
* d2 = NIL => d1 = rok tekstowo. np.: 2000
* nr1 - ID_LPD uwzglëdnianych list  (rodzaj listy)
* nr2 - ID_LPD2 uwzglëdnianych list (rodzaj kom¢rki org.)
* kode - kod elementu, np.: 'p_podst'
* ware - warunek dla elementu, np.: '>100'

function SumaPozPP( x, d1, d2, nr1, nr2, kode, ware )

local wy := 0, idprac, y, ok, war_nr1
local bb := Alias(), ii := IndexOrd(), rr := RecNo()

if x = NIL; return 0; endif
x := Upper( x )

if d2 = NIL
   if Len( d1 ) = 4                 && rok
      d2 := CtoD( '31.12.' + d1 )
      d1 := CtoD( '01.01.' + d1 )
   else                             && rok i m-c, np.: 2001.01
      d2 := ODPMR( ,, Val( d1 ))
      d1 := PDPMR( ,, Val( d1 ))
   endif
endif

ON( 'LPDPD', 2 )
if !DBSeek( x )
   if Jest_baza( bb )
      DBSetOrder( ii )
      DBGoTo( rr )
   endif
   return 0
endif

x := LPDPD->ID                    && mamy ID elementu sumowanego

if kode # NIL

if !DBSeek( Upper( kode ))
   if Jest_baza( bb )
      DBSetOrder( ii )
      DBGoTo( rr )
   endif
   return 0
endif

y := LPDPD->ID                    && mamy ID elementu warunkowanego

endif

idprac := LPRAC->ID               && mamy ID pracownika

war_nr1 := { || .f. }
do case
case nr1 = NIL
case ValType( nr1 ) == 'N'; war_nr1 := { || LPLAC->ID_LPD # nr1 }
case ValType( nr1 ) == 'C'; war_nr1 := { || !Inn( AllS( LPLAC->ID_LPD ), nr1 )}
endcase

ON( 'LPLAC', 1 )     && ID
ON( 'LPLACPP', 2 )   && Str(ID_LPLAC)+Str(ID_LPLACP)+Str(ID_LPDPD)
ON( 'LPLACP', 3 )    && Str(ID_PRAC)+Str(ID_LPLAC)
DBSeek( Str( idprac, 10 ))
while LPLACP->ID_PRAC = idprac .and. !Eof()
      LPLAC->( DBSeek( LPLACP->ID_LPLAC ))
      if LPLAC->ID_LPD = 0;     && lista os¢b
         .or.;
         Eval( war_nr1 );   && pomijanie innych
         .or.;                              && rodzaj¢w list niß podany w "nr1"
         if( nr2 = NIL, .f., LPLAC->ID_LPD2 # nr2 );   && pomijanie innych
         .or.;          && rodzaj¢w kom¢rek organizacyjnych  niß podany w "nr2"
         if( importIDLP = NIL, .f., LPLAC->ID # importIDLP );   && pomijanie innych
         .or.;          && numerÛw list niø podana w "importIDLP"
         d1 > LPLAC->DATA;      && za wczesna
         .or.;
         d2 < LPLAC->DATA       && za p¢¶na
         skip                   && to pomi§
         loop
      endif
      ok := .t.
      if y # NIL                    && mamy ID elementu warunkowanego
         if LPLACPP->( DBSeek( Str( LPLAC->ID ) + Str( LPLACP->ID ) + Str( y, 10 )))
            buf := AllS(UT( LPLACPP->WARTOSC ))    && '1000'
            buf += ware                            && '1000>100'
            ok := &buf                             && prawda lub nie
         endif
      endif
      if ok
         if LPLACPP->( DBSeek( Str( LPLAC->ID ) + Str( LPLACP->ID ) + Str( x, 10 )))
            wy += UT( LPLACPP->WARTOSC )
         endif
      endif
      skip
enddo

if Jest_baza( bb )
   DBSetOrder( ii )
   DBGoTo( rr )
endif

return wy

******************************************************************************
* Aktualizacja kart pracownik¢w
* wariant = NIL => bießÜcy rok, 12 miesiëcy, dzie§ ostatniej wypíaty
* wariant = 1   => wiele lat, miesiÜc i dzie§ ostatniej wypíaty

procedure LPRACAktualizacja( znaki, kodlpd, l1, l2 )

local buf, ii, rr, wa1, wa2, d1, d2, wariant

private lmie, lmiep

lmie := 'LPRACP'
lmiep:= 'LPRACPP'

if l1 # NIL; lmie := l1; endif
if l2 # NIL; lmiep:= l2; endif

ii := LPRAC->( IndexOrd())
rr := LPRAC->( RecNo())

LPD->( DBSetOrder( 2 ))
if !LPD->( DBSeek( Upper( AllTrim( kodlpd ))))
   Alarm( 'Brak definicji zbior¢wki' )
   return
endif

( znaki )->( DBGoTop())
if ( znaki )->( Eof())
   wa1 := Alarm( 'Nie zaznaczono pracownik¢w.;Czyje karty aktualizowaç?',;
              { 'BießÜcego', 'Wszystkich' })
   if wa1 = 0; return; endif
else
   wa2 := Alarm( 'Aktualizowaç karty zaznaczonych pracownik¢w?', tk )
   if wa2 # 1; return; endif
endif

d1 := CtoD( '01.01.' + AllS( Year( Datee())))
d2 := CtoD( '31.12.' + AllS( Year( Datee())))

if NIL = Get_Okres( @d1, @d2 ); return; endif

* jeúli d1='yyyy.01.01' i d2='YYYY.mm.dd' to latami, a nie miesiπcami
if Year( d1 ) # Year( d2 ) .and. ( Right( DtoS( d1 ), 4 ) == '0101' ); wariant := 1; endif

do case
   case wa1 # NIL .and. wa2 = NIL   && brak znakÛw
      if wa1 = 1; LPRACAkt( d1, d2, wariant )
      else
         LPRAC->( DBGoTop())
         while LPRAC->(!Eof())
            LPRACAkt( d1, d2, wariant )
            LPRAC->( DBSkip())
         enddo
      endif
   case wa1 = NIL .and. wa2 # NIL   && sa znaki
      LPRAC->( DBSetOrder( 1 ))
      ( znaki )->( DBGoTop())
      while ( znaki )->( !Eof())
         LPRAC->( DBSeek(( znaki )->POLE ))
         LPRACAkt( d1, d2, wariant )
         ( znaki )->( DBSkip())
      enddo
endcase

LPRAC->( DBSetOrder( ii ))
LPRAC->( DBGoTo( rr ))
wy := 2

******************************************************************************
* usuwanie danych pracownika z tego okresu (czyûç do aktualizacji)

procedure LPRACUsu( d1, d2, wariant )

local i

( lmiep )->( DBSetOrder( 2 ))   && Str(ID_LPRAC)+Str(ID_LPRACP)+Str(ID_LPDPD)
( lmie )->( DBSetOrder( 2 ))    && Str(ID_LPRAC)+Str(MC)

if .f.           && nie zawsze usuwa wszystko i juß,      wariant = NIL

Przerwa( 12 )
for i := 1 to 12
   if !(( lmie )->( DBSeek( Str( LPRAC->ID ) + Str( i, 4 ))))
      ( lmie )->( DBAdd())
      ( lmie )->ID := i
      ( lmie )->ID_LPRAC := LPRAC->ID
      ( lmie )->MIESIAC := i
   endif
   if Month( d1 ) <= ( lmie )->MIESIAC .and. ( lmie )->MIESIAC <= Month( d2 )
      ( lmie )->( Blokuj_R())
      ( lmie )->DATA_PO := CtoD('')
      ( lmie )->DATA_KO := CtoD('')
      ( lmie )->ILE_LIST := 0
      ( lmie )->LISTY := ''
      ( lmiep )->( DBSeek( Str( LPRAC->ID ) + Str( ( lmie )->ID )))
      while Str(( lmiep )->ID_LPRAC ) + Str(( lmiep )->ID_LPRACP ) == Str( LPRAC->ID ) + Str(( lmie )->ID ) .and. ( lmiep )->( !Eof())
         ( lmiep )->( BDelete())
         ( lmiep )->( DBSkip())
      enddo
   endif
   Przerwa()
next
Przerwa( 0 )

else
   ( lmie )->( DBSeek( Str( LPRAC->ID )))
   while ( lmie )->ID_LPRAC = LPRAC->ID .and. ( lmie )->( !Eof())
         ( lmie )->( BDelete())
         ( lmie )->( DBSkip())
   enddo
   ( lmiep )->( DBSeek( Str( LPRAC->ID )))
   while ( lmiep )->ID_LPRAC = LPRAC->ID .and. ( lmiep )->( !Eof())
         ( lmiep )->( BDelete())
         ( lmiep )->( DBSkip())
   enddo
endif

******************************************************************************
* wpisanie sum element¢w z listy do karty
* ii - numer miesiÜca

procedure LPRACWpi( dt, nrl, kod, zm, ii, sett, wariant )

local i, idli

x := Len( Str(( lmie )->( MIESIAC )))

if ii = NIL
   if wariant = NIL
		if x = 6
			ii := Val( Left( DtoS( dt ), 6 ))
		else
			ii := Month( dt )
		endif
   else
      ii := Year( dt )
   endif
endif

*Alarm(Left(CurDir(),6));quit
*Alarm(dt);quit
if dt<>NIL .and. (Left(CurDir(),5)=='PLACE')
	ii := Month( dt )
endif

( lmiep )->( DBSetOrder( 2 ))   && Str(ID_LPRAC)+Str(ID_LPRACP)+Str(ID_LPDPD)
( lmie )->( DBSetOrder( 2 ))    && Str(ID_LPRAC)+Str(MIESIAC)
if !( ( lmie )->( DBSeek( Str( LPRAC->ID ) + Str( ii, x ))))
   ( lmie )->( DBSetOrder( 3 ))   && Str(ID_LPRAC)+Str(ID)
   ( lmie )->( DBSeek( Str( LPRAC->ID ) + '9999999999', .t. ))
   ( lmie )->( DBSkip( -1 )); i := 0
   if ( lmie )->ID_LPRAC = LPRAC->ID
      i := ( lmie )->ID
   endif
   ( lmie )->( DBSetOrder( 2 )) && Str(ID_LPRAC)+Str(MC)
   ( lmie )->( DBAdd())
   ( lmie )->ID := i + 1
   ( lmie )->ID_LPRAC := LPRAC->ID
	if ( lmie )->( FieldPos( 'MIESIAC' )) # 0
      if ii>12 .and. (Left(CurDir(),5)=='PLACE')
*      if ii>12
      	ii := Val(Right(AllS(ii),2))
      endif
	   ( lmie )->MIESIAC := ii
	endif
else
   ( lmie )->( Blokuj_R())
endif

if dt # NIL .and. (( lmie )->( FieldPos( 'DATA_PO' )) # 0 ) .and. (( lmie )->( FieldPos( 'DATA_KO' )) # 0 )
   if Empty(( lmie )->DATA_PO )
      ( lmie )->DATA_PO := dt
   else
      ( lmie )->DATA_KO := dt
   endif
endif

if nrl # NIL .and. (( lmie )->( FieldPos( 'LISTY' )) # 0 ) .and. (( lmie )->( FieldPos( 'ILE_LIST' )) # 0 )
   nrl := AllS( nrl )
   idli := AllTrim(( lmie )->LISTY )
   if !( ',' + nrl + ',' $ ',' + idli + ',' )
      ( lmie )->ILE_LIST := ( lmie )->ILE_LIST + 1
      ( lmie )->LISTY := idli + if( Empty( idli ), '', ',' ) + nrl
   endif
endif

if !(( lmiep )->( DBSeek( Str( LPRAC->ID ) + Str( ( lmie )->ID ) + Str( kod ))))
   ( lmiep )->( DBSetOrder( 3 ))   && Str(ID_LPRAC)+Str(ID_LPRACP)+Str(ID)
   ( lmiep )->( DBSeek( Str( LPRAC->ID ) + Str( ( lmie )->ID ) + '9999999999', .t. ))
   ( lmiep )->( DBSkip( -1 )); i := 0
   if ( lmiep )->ID_LPRAC = LPRAC->ID .and. ( lmiep )->ID_LPRACP = ( lmie )->ID
      i := ( lmiep )->ID
   endif
   ( lmiep )->( DBSetOrder( 2 ))   && Str(ID_LPRAC)+Str(ID_LPRACP)+Str(ID_LPDPD)
   ( lmiep )->( DBAdd())
   ( lmiep )->ID := i + 1
   ( lmiep )->ID_LPRAC := LPRAC->ID
   ( lmiep )->ID_LPRACP := ( lmie )->ID
   ( lmiep )->ID_LPDPD := kod
else
   ( lmiep )->( Blokuj_R())
endif

if sett = NIL
   zm += UT( ( lmiep )->WARTOSC )
endif

( lmiep )->WARTOSC := TU( Transform( zm, AllTrim( LPDPD->MASKA )), LPDPD->ZNAK_T, LPDPD->ZNAK_U )

******************************************************************************
* Liczenie pewnych wartoûci: numery miesiëcy, dni i narastajÜco
* kodz - kod zmiennej, kt¢rÜ podglÜdamy
* kodz = NIL => zerowanie wartoûci zmiennej
* dt - data poczÜtkowa okresu, kt¢ry jest przetwarzany
* idlpdpd - ID oryginalnej zmiennej do kt¢rej ma byç wpisany wynik sumy
* wariant - patrz LPRACAktualizacja ...

procedure LPRACSetN( kodz, dt, idlpdpd, def, wariant, d1, d2 )

local rr := LPDPD->( RecNo()), jest := .f., wa := 0, i, a, b

if kodz = NIL
   if wariant # NIL; return; endif
	if d1 = NIL .or. d2 = NIL
		a := 1
		b := 12
	else
		a := Val( Left( DtoS( d1 ), 6 ))
		b := Val( Left( DtoS( d2 ), 6 ))
	endif
   for i := a to b
		x := Val( Right( AllS( i ), 2 ))
		if i > 1900 .and. ( x > 12 .or. x < 1 )		//skip bo to nie miesiπc
		else
	      LPRACWpi( ,, idlpdpd, wa, i, 'set', wariant )
   	   @ 0, mc - 5 say AllS( 100 * ( i - a + 1 )/( b - a + 1 ), '999%')
		endif
   next
   @ 0, mc - 5 say Space( 4 )
   return
endif

LPDPD->( DBSetOrder( 2 ))           && Upper( KOD )
if LPDPD->( DBSeek( Upper( kodz ))) && szukamy kodu zmiennej
   kodz := LPDPD->ID                && wydobycie ID zmiennej (ID_LPDPD)
   jest := .t.
endif

LPDPD->( DBSetOrder( 1 ))        && ID
LPDPD->( DBGoTo( rr ))           && ID

if !jest        && klëska
   Alarm( 'Brak definicji zmiennej "' + kodz + '"' )
   return 0
endif

* Wartoûç poczÜtkowa o miesiÜc wczeûniej
( lmiep )->( DBSetOrder( 2 ))      && Str(ID_LPRAC)+Str(ID_LPRACP)+Str(ID_LPDPD)
( lmie )->( DBSetOrder( 2 ))       && Str(ID_LPRAC)+Str(MIESIAC)
i := if( wariant = NIL, Month( dt ), Year( dt )) - 1
if ( lmie )->( DBSeek( Str( LPRAC->ID ) + Str( i, 4 )))
   if (lmiep)->( DBSeek( Str( LPRAC->ID ) + Str(( lmie )->ID ) + Str( kodz )))
      wa := UT( ( lmiep )->WARTOSC )  && wartoûç poczÜtkowa
   endif
endif

i := if( wariant = NIL, Month( dt ), Year( dt ))
( lmie )->( DBSeek( Str( LPRAC->ID ) + Str( i, 4 ), .t. ))
while ( lmie )->ID_LPRAC = LPRAC->ID .and. ( lmie )->( !Eof())

      i := ( lmie )->MIESIAC

    if def # NIL     && "mies", "==LPRACP->MIES"

       ( lmiep )->( DBSetOrder( 3 ))      && Str(ID_LPRAC)+Str(ID_LPRACP)+Str(ID)
       ( lmiep )->( DBSeek( Str( LPRAC->ID ) + Str(( lmie )->ID )))

* ustaw wartoûci zmiennych, gdyby trzeba byío z ich wartoûci coû liczyç
       while ( lmiep )->ID_LPRACP = ( lmie )->ID .and. ( lmiep )->( !Eof())
             LPDPD->( DBSeek(( lmiep )->ID_LPDPD ))    && element
             zmienna := AllTrim( LPDPD->KOD )          && zmienna
             &zmienna := UT( ( lmiep )->WARTOSC )      && zaczytanie wartoûci
             ( lmiep )->( DBSkip())
       enddo       

       LPDPD->( DBGoTo( rr ))             && ID

       ( lmiep )->( DBSetOrder( 2 ))      && Str(ID_LPRAC)+Str(ID_LPRACP)+Str(ID_LPDPD)
       ( lmiep )->( DBSeek( Str( LPRAC->ID ) + Str(( lmie )->ID ) + Str( kodz )))

       LPRACWpi( ,, kodz, RunCommand( def ), i, 'set', wariant )

    else             && "ponapodona", "==+ ponapodoch"

       if ( lmiep )->( DBSeek( Str( LPRAC->ID ) + Str(( lmie )->ID ) + Str( kodz )))
          wa += UT( ( lmiep )->WARTOSC )  && wartoûç poczÜtkowa
       endif

       LPRACWpi( ,, idlpdpd, wa, i, 'set', wariant )

    endif

   ( lmie )->( DBSkip())

enddo

******************************************************************************
* wariant - patrz LPRACAktualizacja ...

procedure LPRACAkt( d1, d2, wariant )

local jest, bb := Alias(), nrl, idl, a, n
private zmienna

Czek( 1 )

@ 0, 0 say PadR( AllTrim( LPRAC->NAZWA ), mc )

LPRACUsu( d1, d2, wariant )

ON( 'LPLAC' )
ON( 'LPLACP' )
ON( 'LPLACPP' )
ON( 'LPDP' )
ON( 'LPDPD' )

Select( bb )

LPLAC->( DBSetOrder( 3 ))      && DtoS( DATA ) listy muszÜ byç mielone po dacie
LPLACP->( DBSetOrder( 2 ))       && Str(ID_LPLAC)+Str(ID)
LPLACPP->( DBSetOrder( 2 ))      && Str(ID_LPLAC)+Str(ID_LPLACP)+Str(ID_LPDPD)
LPDPD->( DBSetOrder( 1 ))        && ID
LPDP->( DBSetOrder( 1 ))         && ID

n := 0
LPDP->( DBSeek( Str( LPD->ID )))                      && Str(ID_LPD)+Str(ID)
while LPDP->ID_LPD = LPD->ID .and. LPDP->( !Eof())
      LPDP->( DBSkip())
      n ++
enddo

Przerwa( n )
LPDP->( DBSeek( Str( LPD->ID )))                      && Str(ID_LPD)+Str(ID)
while LPDP->ID_LPD = LPD->ID .and. LPDP->( !Eof())

      LPDPD->( DBSeek( LPDP->ID_LPDPD ))              && element
      LPRACSetN( ,, LPDP->ID_LPDPD,, wariant, d1, d2 )        && ßeby nie byli puûci

      if Left( LPDPD->DEFINICJA, 3 ) == "==+"
         zmienna := AllTrim( SubStr( LPDPD->DEFINICJA, 4 )) && kod zmiennej INC
         LPRACSetN( zmienna, d1, LPDP->ID_LPDPD,,, d1, d2 )     && set narastajÜco
         LPDP->( DBSkip())
         if Przerwa(); exit; endif
         loop
      elseif Left( LPDPD->DEFINICJA, 2 ) == "=="
         zmienna := AllTrim( LPDPD->KOD )             && kod zmiennej
         private &zmienna := 0                        && deklaracja

*         zmienna := AllTrim( SubStr( LPDPD->DEFINICJA, 3 )) && kod zmiennej INC
*         LPRACSetN( zmienna, d1, LPDP->ID_LPDPD )     && set narastajÜco

*         LPDP->( DBSkip())                            && teraz pomija
*         if Przerwa(); exit; endif
*         loop
      else
         zmienna := AllTrim( LPDPD->KOD )             && kod zmiennej
         private &zmienna := 0                        && deklaracja
      endif

      LPLAC->( DBGoTop())          && lista
      while LPLAC->( !Eof())
         if LPLAC->ID_LPD # 0 .and. d1 <= LPLAC->DATA .and. LPLAC->DATA <= d2

*            if &zmienna = NIL    && jeûli dotÜd nie zainicjowana
            &zmienna := 0     && to wyzeruj do inkrementacji
*            endif

            jest := .f.
            LPLACP->( DBSeek( Str(LPLAC->ID)))        && pozycja
            while LPLACP->ID_LPLAC = LPLAC->ID .and. LPLACP->( !Eof())
                  if LPRAC->ID # LPLACP->ID_PRAC
                     LPLACP->( DBSkip())
                     loop
                  endif
                  jest := .t.
                  if LPLACPP->( DBSeek( Str(LPLAC->ID)+Str(LPLACP->ID)+Str(LPDPD->ID)))
                     &zmienna += UT( LPLACPP->WARTOSC )
                  endif
                  LPLACP->( DBSkip())
            enddo
            if jest     && wpisanie sumy elementu z listy do karty
               LPRACWpi( LPLAC->DATA, LPLAC->ID, LPDP->ID_LPDPD, &zmienna,,, wariant )
            endif
         endif
         LPLAC->( DBSkip())
      enddo

      LPDP->( DBSkip())
      if Przerwa(); exit; endif
enddo
Przerwa( 0 )

Przerwa( n )
LPDP->( DBSeek( Str( LPD->ID )))                      && Str(ID_LPD)+Str(ID)
while LPDP->ID_LPD = LPD->ID .and. LPDP->( !Eof())
      LPDPD->( DBSeek( LPDP->ID_LPDPD ))              && element
      if Left( LPDPD->DEFINICJA, 3 ) == "==+"
      elseif Left( LPDPD->DEFINICJA, 2 ) == "=="      && teraz liczy
         zmienna := AllTrim( LPDPD->KOD )             && kod zmiennej
         LPRACSetN( zmienna, d1,,SubStr( LPDPD->DEFINICJA, 3),, d1, d2) && set wartoûci
      endif
      LPDP->( DBSkip())
      if Przerwa(); exit; endif
enddo
Przerwa( 0 )

* zmiana identyfikator¢w list na ich numery

LPLAC->( DBSetOrder( 1 ))      && ID

n := 0
( lmie )->( DBSeek( Str( LPRAC->ID )))
while ( lmie )->ID_LPRAC = LPRAC->ID .and. ( lmie )->( !Eof())
      ( lmie )->( DBSkip())
      n ++
enddo

Przerwa( n )
( lmie )->( DBSeek( Str( LPRAC->ID )))
while ( lmie )->ID_LPRAC = LPRAC->ID .and. ( lmie )->( !Eof())
   idl := ( lmie )->LISTY
   if !Empty( idl )
      nrl := ''
      while !Empty( idl )
            a := PadL( Odetnij( @idl ), 10, '0' )
            if LPLAC->( DBSeek( a ))
               nrl += AllTrim( LPLAC->NUMER ) + ', '
            endif
      enddo
      ( lmie )->( Blokuj_R())
      ( lmie )->LISTY := nrl
      ( lmie )->( OdBlokuj_R())
   endif
   if Przerwa(); exit; endif
   ( lmie )->( DBSkip())
enddo
Przerwa( 0 )

@ 0, 0 say PadR( '', mc )
Czek( 0 )

******************************************************************************

procedure LPLACPKolejnosc( znaki )

local bb := Alias(), i

( znaki )->( DBGoTop())
if ( znaki )->( Eof())
   Alarm( 'Brak znak¢w ustalajÜcych kolejnoûç os¢b.' )
else
   Alarm( 'Ustalaç kolejnoûç os¢b wedíug;kolejnoûci rëcznego zaznaczania?', nt )
   LPLACPZReszta( znaki )
   LPLACMinusy()
   i := 1
   ( znaki )->( DBSetOrder( 0 ))
   ( znaki )->( DBGoTop())
   while ( znaki )->( !Eof())
         MinusNaPlus(( znaki )->POLE, i++ )
         ( znaki )->( DBSkip())
   enddo
   ( znaki )->( DBSetOrder( 1 ))
endif

@ 0, 0 say PadR( 'usuwanie wszelkich zaznacze§', mc )
ON( znaki,,,,.t.)

@ 0, 0 say PadR( '', mc )
Select( bb )
won := .t.
wy := 2

******************************************************************************

procedure LPLACPZReszta( znaki )

@ 0, 0 say PadR( 'automatyczne zaznaczanie pozostaíych pozycji', mc )
ON( 'LPLACP', 2 )
Przerwa( LastRec())
while !Eof()
      if ID_LPLAC = LPLAC->ID
         if !Mark( znaki, ID, '*' ) == '*'
            Mark( znaki, ID )
         endif
      endif
Przerwa()
      skip
enddo
Przerwa(0)

******************************************************************************

procedure MinusNaPlus( z, na )

local r1, r2

@ 0, 0 say PadR( 'konwersja na identyfikatory docelowe', mc )
ON( 'LPLACP', 2 )
if DBSeek( Str( LPLAC->ID ) + Str( -z, 10 ))
   ON( 'LPLACPP', 2 )
Przerwa( LastRec())
   DBSeek( Str( LPLAC->ID ) + Str( -z, 10 ))
   while Str( LPLAC->ID ) + Str( -z, 10 ) == Str( ID_LPLAC ) + Str( ID_LPLACP ) .and. !Eof()
         r1 := RecNo()
         skip
Przerwa()
         r2 := RecNo()
         DBGoTo( r1 )
         Blokuj_R()
         replace ID_LPLACP with na
         DBGoTo( r2 )
   enddo
Przerwa(0)

   ON( 'LPLACP', 2 )
   if DBSeek( Str( LPLAC->ID ) + Str( -z, 10 ))
      Blokuj_R()
      replace ID with na
   endif
endif

******************************************************************************

procedure LPLACMinusy()

@ 0, 0 say PadR( 'konwersja na identyfikatory robocze 1', mc )
ON( 'LPLACP', 0 )
Przerwa( LastRec())
while !Eof()
      if ID_LPLAC = LPLAC->ID
         Blokuj_R()
         replace ID with -ID
      endif
      skip
Przerwa()
enddo
Przerwa(0)

@ 0, 0 say PadR( 'konwersja na identyfikatory robocze 2', mc )
ON( 'LPLACPP', 0 )
Przerwa( LastRec())
while !Eof()
      if ID_LPLAC = LPLAC->ID
         Blokuj_R()
         replace ID_LPLACP with -ID_LPLACP
      endif
      skip
Przerwa()
enddo
Przerwa(0)

******************************************************************************
* Zmiana numeru pracownika z ... na ...

procedure ZmPracZNA()

local z, na, bb := Alias()

if NIL = ( z := Get_U( 10, 10, 'Podaj numer pracownika jaki jest (bíëdny):', '9999999999', 0 )); return; endif
if NIL = ( na:= Get_U( 10, 10, 'Podaj numer pracownika jaki ma byç (poprawny):', '9999999999', 0 )); return; endif
if Alarm( 'Zmiana numeru pracownika z ' + AllS( z ) + ' na ' + AllS( na ), nt ) # 2; return; endif

ON( 'LPLACP', 0 )
while !Eof()
      Blokuj_R()
      if LPLACP->ID_PRAC = z
         LPLACP->( Blokuj_R())
         LPLACP->ID_PRAC := na
      endif
      skip
enddo

Select( bb )

******************************************************************************
* Aktualizacja listy os¢b na podstawie definicji element¢w (LPD)

procedure AktListy( x )

local wa, i, zazna, ii, rr

ii := LPLAC->( IndexOrd())
rr := LPLAC->( RecNo())
data_listy := LPLAC->DATA

if x = NIL
   x := LPLAC->ID_LPD
endif

if x = 0                            && lista os¢b
   LPD->( DBSetOrder( 1 ))
   if !LPD->( DBSeek( LPLAC->ID_LPD2 ))
      Alarm( 'Brak definicji tej listy os¢b' )
      return
   endif
   wa := Alarm( 'Wybierz wariant aktualizacji listy os¢b:',;
              { 'Dodaj nowe skíadniki',;
                'j.w. + usu§ zbëdne puste skíadniki',;
                'j.w. + usu§ zbëdne nawet niepuste skíadniki' })
   if wa = 0; return; endif

   Zwolnij( 'ROB1' )
   Zwolnij( 'ROB2' )

   ON( 'LPLACP' )    && na wszelki wypadek, bo znikajÜ
   ON( 'LPLACPP' )

   ON( 'LPLACPP', 3, 'BUFOR', 'ROB1', .t. )     && nowy komplet
   LPDPD->( DBSetOrder( 1 ))
   LPDP->( DBSetOrder( 1 ))
   LPDP->( DBSeek( Str( LPD->ID )))
   while LPDP->ID_LPD = LPD->ID .and. LPDP->( !Eof())
         LPDPD->( DBSeek( LPDP->ID_LPDPD ))
         ROB1->( DBAdd())
         ROB1->ID := LPDP->ID
         ROB1->ID_LPLAC := LPLAC->ID
         ROB1->ID_LPDPD := LPDP->ID_LPDPD
         if IsDigit( LPDPD->DEFINICJA )
            ROB1->WARTOSC := LPDPD->DEFINICJA
         endif
         LPDP->( DBSkip())
   enddo

   LPLACP->( DBSetOrder( 2 ))          && Str(ID_LPLAC)+Str(ID)
   LPLACP->( DBSeek( Str( LPLAC->ID )))
   Przerwa( LPLACP->( LastRec()))
   while LPLACP->ID_LPLAC = LPLAC->ID .and. LPLACP->( !Eof())

         ON( 'LPLACPP', 3, 'ROBOCZY', 'ROB2', .t. )   && stary komplet

         LPLACPP->( DBSetOrder( 3 ))   && Str(ID_LPLAC)+Str(ID_LPLACP)+Str(ID)
         LPLACPP->( DBSeek( Str( LPLAC->ID ) + Str( LPLACP->ID )))
         while LPLACPP->ID_LPLAC = LPLAC->ID;
               .and.;
               LPLACPP->ID_LPLACP = LPLACP->ID;
               .and.;
               LPLACPP->( !Eof())
               KopiujRec( 'LPLACPP', 'ROB2' )   && na bok
               LPLACPP->( BDelete())            && tu won
               LPLACPP->( DBSkip())
         enddo

         ROB1->( DBGoTop())            && nowy komplet do listy
         while ROB1->( !Eof())
               LPLACPP->( DBAdd())
               LPLACPP->ID := ROB1->ID
               LPLACPP->ID_LPLAC := LPLAC->ID
               LPLACPP->ID_LPLACP:= LPLACP->ID
               LPLACPP->ID_LPDPD := ROB1->ID_LPDPD
               ROB1->( DBSkip())
         enddo

         i := LPLACPP->ID            && last ID
*                                 && Str(ID_LPLAC)+Str(ID_LPLACP)+Str(ID_LPDPD)
         LPLACPP->( DBSetOrder( 2 ))
         ROB2->( DBGoTop())          && stary komplet do listy
         while ROB2->( !Eof())
               
            if ( wa = 1 );
               .or.;
               ( !Empty( ROB2->WARTOSC ))    && wariant 1 lub niepusty skíadnik
               if !LPLACPP->( DBSeek( Str(LPLAC->ID)+Str(LPLACP->ID)+Str(ROB2->ID_LPDPD)))
                  if wa = 3 && wariant 3 nie dodaje ßadnych starych skíadnik¢w
                     ROB2->( DBSkip())
                     loop
                  endif
*                           && wariant 2 nie dodaje pustych starych skíadnik¢w
                  if wa = 2 .and. Empty( ROB2->WARTOSC )
                     ROB2->( DBSkip())
                     loop
                  endif
                  LPLACPP->( DBAdd())
                  LPLACPP->ID := ++i
                  LPLACPP->ID_LPLAC := LPLAC->ID
                  LPLACPP->ID_LPLACP:= LPLACP->ID
                  LPLACPP->ID_LPDPD := ROB2->ID_LPDPD
               endif
               LPLACPP->( Blokuj_R())
               LPLACPP->WARTOSC := ROB2->WARTOSC
            endif
               ROB2->( DBSkip())
         enddo

         LPLACP->( DBSkip())
         if Przerwa(); exit; endif
   enddo
   Przerwa( 0 )

else                       && lista píac

   LPD->( DBSetOrder( 1 ))
   ON( 'LPLACZ' )
   zazna := LPLACZ->( !Eof())

   wa := Alarm( 'Wybierz wariant aktualizacji ' +;
      if( zazna, AllS( LPLACZ->( LastRec())) + ' list', 'listy' ) + ' píac:',;
              { 'Przelicz skíadniki wedíug aktualnych formuí',;
                'j.w. ale pozostaw w spokoju skíadniki puste',;
                '-',;
                'Sprawd¶ przeliczenia wedíug aktualnych formuí',;
                'j.w. ale pozostaw w spokoju skíadniki puste',;
                '-',;
                'Dodaj nowe skíadniki',;
                'j.w. + usu§ zbëdne puste skíadniki',;
                'j.w. + usu§ zbëdne nawet niepuste skíadniki' })

if wa # 0

   Zwolnij( 'ROB1' )
   Zwolnij( 'ROB2' )

   ON( 'LPLACZ' )

while if( zazna, LPLACZ->( !Eof()), .t. )

   if zazna
      LPLAC->( DBSetOrder( 1 ))
      LPLAC->( DBSeek( LPLACZ->POLE ))
   endif

   if !LPD->( DBSeek( LPLAC->ID_LPD ))
      Alarm( 'Brak definicji tej listy píac' )
      exit
   endif

if wa > 6

   Zwolnij( 'ROB1' )
   Zwolnij( 'ROB2' )

   ON( 'LPLACP' )    && na wszelki wypadek, bo znikajÜ
   ON( 'LPLACPP' )

   ON( 'LPLACPP', 3, 'BUFOR', 'ROB1', .t. )     && nowy komplet
   LPDPD->( DBSetOrder( 1 ))
   LPDP->( DBSetOrder( 1 ))
   LPDP->( DBSeek( Str( LPD->ID )))
   while LPDP->ID_LPD = LPD->ID .and. LPDP->( !Eof())
         LPDPD->( DBSeek( LPDP->ID_LPDPD ))
         ROB1->( DBAdd())
         ROB1->ID := LPDP->ID
         ROB1->ID_LPLAC := LPLAC->ID
         ROB1->ID_LPDPD := LPDP->ID_LPDPD
         if IsDigit( LPDPD->DEFINICJA )
            ROB1->WARTOSC := LPDPD->DEFINICJA
         endif
         LPDP->( DBSkip())
   enddo

   LPLACP->( DBSetOrder( 2 ))          && Str(ID_LPLAC)+Str(ID)
   LPLACP->( DBSeek( Str( LPLAC->ID )))
   Przerwa( LPLACP->( LastRec()))
   while LPLACP->ID_LPLAC = LPLAC->ID .and. LPLACP->( !Eof())

         ON( 'LPLACPP', 3, 'ROBOCZY', 'ROB2', .t. )   && stary komplet

         LPLACPP->( DBSetOrder( 3 ))   && Str(ID_LPLAC)+Str(ID_LPLACP)+Str(ID)
         LPLACPP->( DBSeek( Str( LPLAC->ID ) + Str( LPLACP->ID )))
         while LPLACPP->ID_LPLAC = LPLAC->ID;
               .and.;
               LPLACPP->ID_LPLACP = LPLACP->ID;
               .and.;
               LPLACPP->( !Eof())
               KopiujRec( 'LPLACPP', 'ROB2' )   && na bok
               LPLACPP->( BDelete())            && tu won
               LPLACPP->( DBSkip())
         enddo

         ROB1->( DBGoTop())            && nowy komplet do listy
         while ROB1->( !Eof())
               LPLACPP->( DBAdd())
               LPLACPP->ID := ROB1->ID
               LPLACPP->ID_LPLAC := LPLAC->ID
               LPLACPP->ID_LPLACP:= LPLACP->ID
               LPLACPP->ID_LPDPD := ROB1->ID_LPDPD
               LPLACPP->WARTOSC  := ROB1->WARTOSC     && niepewne ...
               ROB1->( DBSkip())
         enddo

         i := LPLACPP->ID            && last ID
*                                 && Str(ID_LPLAC)+Str(ID_LPLACP)+Str(ID_LPDPD)
         LPLACPP->( DBSetOrder( 2 ))
         ROB2->( DBGoTop())          && stary komplet do listy
         while ROB2->( !Eof())
               
            if ( wa = 7 );
               .or.;
               ( !Empty( ROB2->WARTOSC ))    && wariant 7 lub niepusty skíadnik
               if !LPLACPP->( DBSeek( Str(LPLAC->ID)+Str(LPLACP->ID)+Str(ROB2->ID_LPDPD)))
                  if wa = 9 && wariant 9 nie dodaje ßadnych starych skíadnik¢w
                     ROB2->( DBSkip())
                     loop
                  endif
*                           && wariant 8 nie dodaje pustych starych skíadnik¢w
                  if wa = 8 .and. Empty( ROB2->WARTOSC )
                     ROB2->( DBSkip())
                     loop
                  endif
                  LPLACPP->( DBAdd())
                  LPLACPP->ID := ++i
                  LPLACPP->ID_LPLAC := LPLAC->ID
                  LPLACPP->ID_LPLACP:= LPLACP->ID
                  LPLACPP->ID_LPDPD := ROB2->ID_LPDPD
               endif
               LPLACPP->( Blokuj_R())
               LPLACPP->WARTOSC := ROB2->WARTOSC
            endif
               ROB2->( DBSkip())
         enddo

         LPLACP->( DBSkip())
         if Przerwa(); exit; endif
   enddo

else

   ON( 'LPLACP' )                      && na wszelki wypadek, bo znikajÜ
   ON( 'LPLACPP', 3 )                  && Str(ID_LPLAC)+Str(ID_LPLACP)+Str(ID)

   LPLACP->( DBSetOrder( 2 ))          && Str(ID_LPLAC)+Str(ID)
   LPLACP->( DBSeek( Str( LPLAC->ID )))
   Przerwa( LPLACP->( LastRec()))
   while LPLACP->ID_LPLAC = LPLAC->ID .and. LPLACP->( !Eof())
         LPLACPP->( DBSeek( Str(LPLAC->ID)+Str(LPLACP->ID)))
         if !LPLACPP->( A_LPLACPP(, LPLACP->ID_PRAC, wa ))
            zazna := .f.
            exit
         endif
         LPLACP->( DBSkip())
         if Przerwa(); exit; endif
   enddo

endif

   Przerwa( 0 )

   if !zazna; exit; endif
   LPLACZ->( DBSkip())

enddo

   ON( 'LPLACZ',,,, .t. )
   wy := 2

endif
endif

Zwolnij( 'ROB1' )
Zwolnij( 'ROB2' )

Select( 'LPLAC' )
DBSetOrder( ii )
DBGo( rr )

******************************************************************************
* Aktualizacja listy píac pojedynczego pracownika + pokazanie "cosik" u g¢ry

* odID # NIL => od tego ID, a wyøej nie przeliczaj

procedure A_LPLACPP( cosik, idprac, w, odID )

local rr := RecNo(), bb := Alias(), zmienna, buf, wa, wawy := .t.
local idlpd2 := LPLAC->ID_LPD2, rrlp := LPLAC->( RecNo()), iilp := LPLAC->( IndexOrd())
local rrlpp, iilpp, rrlppp, iilppp
local kidlplac, kidlplacp, kidlpdpd

data_listy := LPLAC->DATA

if cosik # NIL

if LPLAC->ID_LPD = 0
*   Alarm( 'Aktualizacja wartoûci nie ma sensu w liûcie os¢b' )
   return wawy
endif

   LPLAC->( DBSetOrder( 2 ))
   LPLAC->( DBSeek( '         0' + Str( idlpd2 )))       && lista os¢b
   kidlplac := LPLAC->ID

   rrlpp := LPLACP->( RecNo())
   iilpp := LPLACP->( IndexOrd())

   LPLACP->( DBSetOrder( 3 ))
   LPLACP->( DBSeek( Str( idprac ) + Str( kidlplac )))  && konkretna osoba
   kidlplacp := LPLACP->ID

   rrlppp := LPLACPP->( RecNo())
   iilppp := LPLACPP->( IndexOrd())
   LPLACPP->( DBSetOrder( 2 ))
endif

LPDPD->( DBSetOrder( 1 ))    && ID
LPDPD->( DBGoTop())
while LPDPD->( !Eof())
      zmienna := AllTrim( LPDPD->KOD )      && kod zmiennej
      public &zmienna                       && deklaracja
      if cosik # NIL .and.;
         LPLACPP->(DBSeek( Str( kidlplac ) + Str( kidlplacp ) + Str( LPDPD->ID )))
         &zmienna := UT( LPLACPP->WARTOSC ) && we¶ tÜ co jest na liûcie os¢b
      else
         wa := LPDPD->DEFINICJA
         if IsDigit( wa ) .or. Left( wa, 1 ) == '-'
            &zmienna := UT( wa )
         else
            &zmienna := 0
         endif
      endif
      LPDPD->(DBSkip())
enddo

if cosik # NIL
   go top
endif

while if( cosik # NIL, .t., LPLAC->ID = ID_LPLAC .and. LPLACP->ID = ID_LPLACP ) .and. !Eof()

      ( bb )->( Blokuj_R())

      LPDPD->( DBSeek(( bb )->ID_LPDPD ))             && element
      zmienna := AllTrim( LPDPD->KOD )                && kod zmiennej
      public &zmienna := 0                            && deklaracja := 0

      wa := NIL
      if cosik = NIL
         if (( w = 2 .or. w = 5 ) .and. Empty(( bb )->WARTOSC )) .or.;
            !( '+' $ LPDPD->DEFINICJA .or.;
               '-' $ LPDPD->DEFINICJA .or.;
               '*' $ LPDPD->DEFINICJA .or.;
               '/' $ LPDPD->DEFINICJA .or.;
               'IF(' $ Upper( LPDPD->DEFINICJA ) .or.;
               'ZAOKR' $ Upper( LPDPD->DEFINICJA ) .or.;
               'PODAT' $ Upper( LPDPD->DEFINICJA ))
            wa := ( bb )->WARTOSC  && nie licz, we¶ to co jest na liûcie píac
         endif
      elseif LPLACPP->(DBSeek( Str( kidlplac ) + Str( kidlplacp ) + Str( LPDPD->ID )))
         wa := ( bb )->WARTOSC         && we¶ tÜ co jest na liûcie píac
      endif

      if wa # NIL
            buf := AllTrim( wa )
      else
            buf := AllTrim( LPDPD->DEFINICJA )
            if Empty( buf )
               buf := AllTrim(( bb )->WARTOSC )
            endif
            if cosik # NIL
               buf := StrTran( buf, '(baza)', 'ROB' )
            else
               buf := StrTran( buf, '(baza)', 'LPLACP' )
            endif
      endif

         if !Empty( buf )
            if Left( buf, 1 ) == "="         && dziaíanie
               buf := SubStr( buf, 2 )
               &zmienna := RunCommand( buf )
               buf := &zmienna
               if ValType( buf ) == "N"
                  buf := AllS( buf, '999,999,999.99' )
               endif
            endif

            if IsDigit( LPDPD->MASKA );
               .and.;
               ( IsDigit( buf );
               .or.;
               Left( buf, 1 ) == '-';
               .or.;
               Left( buf, 1 ) == '*' )     && wartoûç

               buf := UT( buf )

if LPAlarmMin .and. buf < 0
   LPAlarmMin( buf )
endif
               &zmienna := buf
               if w # NIL .and. ( w = 4 .or. w = 5 )
                  if StrTran( AllTrim(( bb )->WARTOSC ), '.', '' ) == StrTran( AllTrim( TU( Transform( buf, AllTrim( LPDPD->MASKA )), LPDPD->ZNAK_T, LPDPD->ZNAK_U, LPDPD->ZERA_TEZ, buf )), '.', '' )
                  else
                     if Alarm( 'R¢ßnica na liûcie ' + AllTrim( LPLAC->NUMER ) + ' z dnia ' + DtoC( LPLAC->DATA ) + ' (' + AllS( LPLACP->ID ) + '/' + AllS( LPLACPP->ID ) + ')' + ';' +;
                               AllTrim( LPRAC->NAZWA ) + ' / ' + AllTrim( LPDPD->NAZWA ),;
                             { '  JEST: ' + ( bb )->WARTOSC, 'MA BYC: ' + TU( Transform( buf, AllTrim( LPDPD->MASKA )), LPDPD->ZNAK_T, LPDPD->ZNAK_U, LPDPD->ZERA_TEZ, buf ), 'Stop' }) = 3
                        wawy := .f.
                        exit
                     endif
                  endif
               elseif ( odID # NIL ) .and. ( ID < odID )
                  buf := AllTrim(( bb )->WARTOSC )
	               buf := UT( buf )
	               &zmienna := buf
               else
                  ( bb )->WARTOSC := TU( Transform( buf, AllTrim( LPDPD->MASKA )), LPDPD->ZNAK_T, LPDPD->ZNAK_U, LPDPD->ZERA_TEZ, buf )
               endif
            else                          && tekst
               &zmienna := buf
               if w # NIL .and. ( w = 4 .or. w = 5 )
                  if StrTran( AllTrim(( bb )->WARTOSC ), '.', '' ) == StrTran( AllTrim( Transform( buf, AllTrim( LPDPD->MASKA ))), '.', '' )
                  else
                     if Alarm( 'R¢ßnica na liûcie ' + AllTrim( LPLAC->NUMER ) + ' z dnia ' + DtoC( LPLAC->DATA ) + ' (' + AllS( LPLACP->ID ) + '/' + AllS( LPLACPP->ID ) + ')' + ';' +;
                               AllTrim( LPRAC->NAZWA ) + ' / ' + AllTrim( LPDPD->NAZWA ),;
                             { '  JEST: ' + ( bb )->WARTOSC, 'MA BYC: ' + Transform( buf, AllTrim( LPDPD->MASKA )), 'Stop' }) = 3
                        wawy := .f.
                        exit
                     endif
                  endif
               else
                  ( bb )->WARTOSC := Transform( buf, AllTrim( LPDPD->MASKA ))
               endif
            endif
         endif

         if cosik # NIL .and. zmienna == cosik
            @ 2, 0 say ( bb )->WARTOSC
         endif

      skip

enddo

if cosik # NIL

   LPLAC->( DBSetOrder( iilp ))
   LPLAC->( DBGoTo( rrlp ))

   LPLACP->( DBSetOrder( iilpp ))
   LPLACP->( DBGoTo( rrlpp ))

   LPLACPP->( DBSetOrder( iilppp ))
   LPLACPP->( DBGoTo( rrlppp ))

endif

DBGoTo( rr )
zmiana := .t.
wy := 2

return wawy

******************************************************************************

procedure LPRACKartyWydruk( znaki, wzor )

local buf, ii, rr, wa1, wa2, d1, d2

ii := LPRAC->( IndexOrd())
rr := LPRAC->( RecNo())

( znaki )->( DBGoTop())
if ( znaki )->( Eof())
   wa1 := Alarm( 'Nie zaznaczono pracownik¢w.;Czyje karty drukowaç?',;
               { 'BießÜcego', 'Wszystkich' })
   if wa1 = 0; return; endif
else
   wa2 := Alarm( 'Drukowaç karty zaznaczonych pracownik¢w?', tk )
   if wa2 # 1; return; endif
endif

do case
   case wa1 # NIL .and. wa2 = NIL   && brak znakÛw
      if wa1 = 1; LPRAC->( Drukuj( wzor ))
      else
         LPRAC->( DBGoTop())
         while LPRAC->(!Eof())
            LPRAC->( Drukuj( wzor ))
            LPRAC->( DBSkip())
         enddo
      endif
   case wa1 = NIL .and. wa2 # NIL   && sa znaki
      LPRAC->( DBSetOrder( 1 ))
      ( znaki )->( DBGoTop())
      while ( znaki )->( !Eof())
         LPRAC->( DBSeek(( znaki )->POLE ))
         LPRAC->( Drukuj( wzor ))
         ( znaki )->( DBSkip())
      enddo
endcase

LPRAC->( DBSetOrder( ii ))
LPRAC->( DBGoTo( rr ))
wy := 2

******************************************************************************
* Import definicji listy z innej listy

procedure DefImport()

local bb := Alias(), rr := LPD->( RecNo()), idlpd := LPD->ID

ViewDBF( 'LPD,LPDimp.txt,,3', .t. )

if LastKey() # 27
   LPDP->( DBSetOrder( 1 ))
   LPDP->( DBSeek( Str( LPD->ID )))
   KopiaRec( 'LPDP', bb, {|| LPDP->ID_LPD = LPD->ID },,, {|| ROB->ID_LPD := idlpd, .f. })
   wy := 2
   zmiana := .t.
endif

LPD->( DBGoTo( rr ))
Select( bb )
go top

******************************************************************************
* definicja píacy podstawowej w zaleßnoûci od "LPD->KODDPP" danej kom¢rki org.

function Def_p_podst()

local x, rr1, rr2, ii1, ii2

rr1 := LPD->( RecNo())
ii1 := LPD->( IndexOrd())
rr2 := LPDPD->( RecNo())
ii2 := LPDPD->( IndexOrd())

LPD->(GetPole(1,'LPLAC->ID_LPD2','KODDPP'))
x := LPDPD->(GetPole(2,'Upper(LPD->KODDPP)','DEFINICJA'))
x := AllTrim( SubStr( x, 2 ))

LPD->( DBGoTo( rr1 ))
LPD->( DBSetOrder( ii1 ))
LPDPD->( DBGoTo( rr2 ))
LPDPD->( DBSetOrder( ii2 ))

return if( Empty( x ), 0, RunCommand( x ))

******************************************************************************
* idprac - tylko dla zbior¢wek pracownika

procedure LPLAC_SubZbiorowka( idprac )

            LPLACP->( DBSeek( Str(LPLAC->ID)))        && pozycja
            while LPLACP->ID_LPLAC = LPLAC->ID .and. LPLACP->( !Eof())
                  if idprac # NIL .and. idprac # LPLACP->ID_PRAC
                     LPLACP->( DBSkip())
                     loop
                  endif
                  if LPLACPP->( DBSeek( Str(LPLAC->ID)+Str(LPLACP->ID)+Str(LPDPD->ID)))
                     buf := AllTrim( LPLACPP->WARTOSC )
                     &zmienna += UT( buf )
                  endif
                  LPLACP->( DBSkip())
            enddo

******************************************************************************
* kodlpd - kod definicji zbior¢wki
* a - dane dla formularza parametr¢w
* idprac - tylko dla zbior¢wek pracownika
* katalog - okres czasu ze zwiedzaniem archiwum

procedure LPLAC_Zbiorowka( kodlpd, a, wzor, idprac, katalog )

local buf, ii, rr

*Alarm( 'Procedura w trakcie zmian !!!' )
*return

ii := LPLAC->( IndexOrd())
rr := LPLAC->( RecNo())

if katalog = NIL
   LPLACZ->( DBGoTop())
   if LPLACZ->( Eof())
      if Alarm( 'Brak zaznacze§ list do zbior¢wki.;Czy ma to byç zbior¢wka z bießÜcej listy?', tk ) # 1
         return
      endif
      LPLACZ->( DBAdd())
      LPLACZ->POLE := LPLAC->ID
   endif
endif

LPD->( DBSetOrder( 1 ))

private zbionr, zbiodata, zbiotytul

zbionr := LPLAC->NUMER
zbiodata := LPLAC->DATA

LPD->( DBSeek( LPLAC->ID_LPD ))
zbiotytul := if( idprac = NIL, LPD->NAZWA, AllTrim( LPRAC->NAZWA )) + Space(100)

LPD->( DBSeek( LPLAC->ID_LPD2 ))
zbiotytul2 := if( idprac = NIL, LPD->NAZWA, '') + Space(100)

zbiotytul3:= Space(100)

LPD->( DBSetOrder( 2 ))
if !LPD->( DBSeek( Upper( AllTrim( kodlpd ))))
   Alarm( 'Brak definicji zbior¢wki' )
   return
endif

if katalog # NIL
   if Get_Okres( @data_od, @data_do ) = NIL; return; endif
   zbiotytul2:= 'Dane z okresu: ' + DtoC( data_od ) + ' - ' + DtoC( data_do ) + Space(100)
endif

if !NewSysForm( a ); return; endif        && parametry wydruku

private zmienna

Czek( 1 )

LPLAC->( DBSetOrder( 1 ))
LPLACP->( DBSetOrder( 2 ))       && Str(ID_LPLAC)+Str(ID)
LPLACPP->( DBSetOrder( 2 ))      && Str(ID_LPLAC)+Str(ID_LPLACP)+Str(ID_LPDPD)

ON( 'LPDP' )
ON( 'LPDPD' )

LPDPD->( DBSetOrder( 1 ))
LPDP->( DBSetOrder( 1 ))
LPDP->( DBSeek( Str( LPD->ID )))

Przerwa( LPDP->( LastRec()))
while LPDP->ID_LPD = LPD->ID .and. LPDP->( !Eof())

      LPDPD->( DBSeek( LPDP->ID_LPDPD ))              && element
      zmienna := AllTrim( LPDPD->KOD )                && kod zmiennej
      private &zmienna := 0                           && deklaracja := 0

      if Left( LPDPD->DEFINICJA, 2 ) == "=="
         &zmienna := RunCommand( SubStr( LPDPD->DEFINICJA, 3 ))
      endif

      if katalog = NIL
         LPLACZ->( DBGoTop())
         while LPLACZ->( !Eof())
               LPLAC->( DBSeek( LPLACZ->POLE ))          && lista
               LPLAC_SubZbiorowka( idprac )
               LPLACZ->( DBSkip())
         enddo
      else
         LPLAC->( DBGoTop())     && czesanie od poczÜtku po dacie
         while LPLAC->( !Eof())
               if LPLAC->ID_LPD # 0 .and. data_od <= LPLAC->DATA .and. LPLAC->DATA <= data_do
                  LPLAC_SubZbiorowka( idprac )
               endif
               LPLAC->( DBSkip())
         enddo
      endif

      LPDP->( DBSkip())
      if Przerwa(); exit; endif
enddo

if katalog # NIL .and. !Empty( ReadWzor( 'katalog.txt' )) .and. CatSwich( 'katalog.txt', 1, 1 )

Zwolnij( 'LPLAC' )      && w bießÜcym
Zwolnij( 'LPLACP' )
Zwolnij( 'LPLACPP' )

ON( 'LPLAC' )           && w archiwum
ON( 'LPLACP' )
ON( 'LPLACPP' )

LPLAC->( DBSetOrder( 1 ))
LPLACP->( DBSetOrder( 2 ))       && Str(ID_LPLAC)+Str(ID)
LPLACPP->( DBSetOrder( 2 ))      && Str(ID_LPLAC)+Str(ID_LPLACP)+Str(ID_LPDPD)

LPDPD->( DBSetOrder( 1 ))
LPDP->( DBSetOrder( 1 ))
LPDP->( DBSeek( Str( LPD->ID )))

Przerwa( LPDP->( LastRec()))
while LPDP->ID_LPD = LPD->ID .and. LPDP->( !Eof())

      LPDPD->( DBSeek( LPDP->ID_LPDPD ))              && element
      zmienna := AllTrim( LPDPD->KOD )                && kod zmiennej
*      private &zmienna := 0                           && deklaracja := 0

      if Left( LPDPD->DEFINICJA, 2 ) == "=="
         &zmienna := RunCommand( SubStr( LPDPD->DEFINICJA, 3 ))
      endif

      LPLAC->( DBGoTop())     && czesanie od poczÜtku po dacie
      while LPLAC->( !Eof())
            if LPLAC->ID_LPD # 0 .and. data_od <= LPLAC->DATA .and. LPLAC->DATA <= data_do
               LPLAC_SubZbiorowka( idprac )
            endif
            LPLAC->( DBSkip())
      enddo

      LPDP->( DBSkip())
      if Przerwa(); exit; endif
enddo

Zwolnij( 'LPLAC' )      && w archiwum
Zwolnij( 'LPLACP' )
Zwolnij( 'LPLACPP' )

CatSwich(,,1)

ON( 'LPLAC' )           && w bießÜcym
ON( 'LPLACP' )
ON( 'LPLACPP' )

LPLAC->( DBSetOrder( 1 ))
LPLACP->( DBSetOrder( 2 ))       && Str(ID_LPLAC)+Str(ID)
LPLACPP->( DBSetOrder( 2 ))      && Str(ID_LPLAC)+Str(ID_LPLACP)+Str(ID_LPDPD)

endif

Przerwa( 0 )
Czek( 0 )

Drukuj( wzor )

LPLAC->( DBSetOrder( ii ))
LPLAC->( DBGoTo( rr ))
wy := 2

******************************************************************************

procedure LPLAC_Prz( wzor, kod )

local buf, ii, rr

ii := LPLAC->( IndexOrd())
rr := LPLAC->( RecNo())

LPLACZ->( DBGoTop())
if LPLACZ->( Eof())
   if Alarm( 'Brak zaznacze§ list do przelew¢w.;Czy majÜ byç z bießÜcej listy?', tk ) # 1
      return
   endif
   LPLACZ->( DBAdd())
   LPLACZ->POLE := LPLAC->ID
endif

LPDPD->( DBSetOrder( 2 ))
if !LPDPD->( DBSeek( Upper( AllTrim( kod ))))
   Alarm( 'Brak definicji elementu o kodzie "' + kod + '"' )
   return
endif
kod := LPDPD->ID;

Czek( 1 )

ON( 'LPRAC' )
while !Eof()
	LPRAC->( Blokuj_R())
	LPRAC->KWOTAPRZE := 0
	LPRAC->TYTULPRZE := ''
	LPRAC->( OdBlokuj_R())
	skip
enddo

LPLAC->( DBSetOrder( 1 ))
LPLACP->( DBSetOrder( 2 ))       && Str(ID_LPLAC)+Str(ID)
LPLACPP->( DBSetOrder( 4 ))      && Str(ID_LPDPD)+Str(ID_LPLAC)+Str(ID_LPLACP)

Przerwa( LPLACZ->( LastRec()))
while LPLACZ->( !Eof())
      LPLACPP->( DBSeek( Str( kod, 10 ) + Str( LPLACZ->POLE, 10 )))
      LPLAC->( DBSeek( LPLACZ->POLE ))
      while LPLACPP->ID_LPDPD=kod .and. LPLACPP->ID_LPLAC=LPLACZ->POLE .and. LPLACPP->(!Eof())
	if LPLACP->( DBSeek( Str( LPLACZ->POLE, 10 ) + Str( LPLACPP->ID_LPLACP, 10 )))
		if LPRAC->( DBSeek( LPLACP->ID_PRAC ))
			LPRAC->( Blokuj_R())
			LPRAC->KWOTAPRZE := LPRAC->KWOTAPRZE + UT( LPLACPP->WARTOSC )
			LPRAC->TYTULPRZE := AllTrim(LPRAC->TYTULPRZE + ' ' + LPLAC->NUMER )
			LPRAC->( OdBlokuj_R())
		endif
	endif
        LPLACPP->( DBSkip())
      enddo
      LPLACZ->( DBSkip())
      if Przerwa(); exit; endif
enddo

LPLAC->( DBSetOrder( 1 ))
LPLACP->( DBSetOrder( 2 ))       && Str(ID_LPLAC)+Str(ID)
LPLACPP->( DBSetOrder( 2 ))      && Str(ID_LPLAC)+Str(ID_LPLACP)+Str(ID_LPDPD)

Przerwa( 0 )
Czek( 0 )

ON( 'LPRAC' )
globalbuf1:=RecNo()
globalbuf:=cat_wydr
cat_wydr:='g:\programy\'
LPRAC->(Drukuj(wzor,,'g:\programy\przelewy.imp'))
cat_wydr:=globalbuf

LPLAC->( DBSetOrder( ii ))
LPLAC->( DBGoTo( rr ))
wy := 2

******************************************************************************

procedure DeleteID( bb, dx )

local rr, ii, x

if bb = NIL; bb := Alias(); endif
if dx = NIL; dx := -1; endif

x := ( bb )->ID
rr := ( bb )->( RecNo())
ii := ( bb )->( IndexOrd())

( bb )->( DBSetOrder( 0 ))
( bb )->( DBEval({|| ( bb )->ID := ( bb )->ID + dx }, {|| ( bb )->ID > x }))
( bb )->( DBSetOrder( ii ))
( bb )->( DBGoTo( rr ))

******************************************************************************
* Copy 1 definicji pola (ROB=LPDP)
* mode = NIL - kopia element¢w list do specyfikacji definicji
* mode # NIL - kopia element¢w list do specyfikacji pozycji listy

procedure C1Def( mode )

local bb := if( mode = NIL, 'ROB', 'ROB2' )

KopiujRec( bb, bb )

DeleteID( bb, 1 )                   && next ID

( bb )->ID := ( bb )->ID + 1
( bb )->ID_LPDPD := LPDPDZ->POLE    && pole zaznaczone

if mode = NIL
   ( bb )->ID_LPD := LPD->ID
else
   ( bb )->ID_LPLAC := LPLAC->ID
   ( bb )->ID_LPLACP:= ROB->ID
endif

******************************************************************************
* Dopisz serie definicji p¢l listy

procedure DSerieDef( a, b, c )

ViewDBF( a, .t.,,, b )
LPDPDZ->( DBSetOrder(0))
LPDPDZ->( DBEval({|| RunCommand( c )}))
zmiana := .t.

******************************************************************************

function Zaokr( x, y )
return Round( x, y )

******************************************************************************
* Wypeínienie serii pozycji listy

procedure WSerii()
                        && dane nowej listy
local idlplac := LPLAC->ID, idlpd := LPLAC->ID_LPD, idlpd2 := LPLAC->ID_LPD2
local rr, i := 1, kidprac, kidlplac, kidlplacp, ii := LPLAC->( IndexOrd())

if LastKey() = K_ESC; return; endif

data_listy := LPLAC->DATA

Czek( 1 )
Przerwa( LPLACP->(LastRec()))

LPLAC->( DBSetOrder(2)); LPLAC->( DBSeek(Str(0,10,0)+Str(idlpd2))) && kom¢rka
kidlplac := LPLAC->ID                  && id listy os¢b z kom¢rki
LPLACP->(DBSetOrder(2)); LPLACP->(DBSeek( Str( kidlplac )))        && osoby
while LPLACP->ID_LPLAC = kidlplac .and. LPLACP->( !Eof())
      kidprac := LPLACP->ID_PRAC
      kidlplacp := LPLACP->ID
      rr := LPLACP->( RecNo())
         LPLACP->( DBAdd())                       && kopiowanie os¢b z kom¢rki
         LPLACP->ID := i++
         LPLACP->ID_LPLAC := idlplac   && nowa lista píac
         LPLACP->ID_PRAC := kidprac    && pracownik z kom¢rki
* kopiowanie pozycji z def.
         LPLACP->(CSeriiDef( idlplac, idlpd, LPLACP->ID, kidlplac, kidlplacp))
      LPLACP->( DBGoTo( rr ))
      LPLACP->( DBSkip())
      if Przerwa(); exit; endif
enddo

Przerwa( 0 )
Czek( 0 )

LPLAC->( DBSetOrder( 1 )); LPLAC->( DBSeek( idlplac ))
LPLAC->( DBSetOrder( ii )); wy := 2

******************************************************************************
* Kopia serii definicji

procedure CSeriiDef( idlplac, idlpd, idlplacp, kidlplac, kidlplacp, kidlpdpd )

local i := 1, rr, wa, oidlpd := idlpd

private buf, zmienna, baza := Alias()

if idlplac = NIL; idlplac := LPLAC->ID; endif
if idlpd   = NIL; idlpd   := LPLAC->ID_LPD; endif     && definicja listy píac
if idlpd   = 0  ; idlpd   := LPLAC->ID_LPD2; endif    && definicja listy os¢b
if idlplacp= NIL; idlplacp:= ROB->ID; endif
if oidlpd  = NIL; oidlpd  := 0; endif


LPDP->(DBSetOrder(2))
LPDPD->( DBGoTop())        && inicjacja staíych publicznych (stawki pod_doch)
while LPDPD->( !Eof())

      zmienna := AllTrim( LPDPD->KOD )
      buf := Val( AllTrim( LPDPD->DEFINICJA ))

      wa := NIL

      if kidlplac # NIL
         ON('LPLACPP',2)
         Select( baza )
      endif

      if kidlplac # NIL                      && czy wartoûç jest w kom¢rce org.?
         rr := LPLACPP->( RecNo())
         kidlpdpd := LPDPD->ID
         if LPLACPP->(DBSeek( Str( kidlplac ) + Str( kidlplacp ) + Str( kidlpdpd )))
            wa := LPLACPP->WARTOSC
            LPLACPP->( DBGoTo( rr ))
         else
            LPLACPP->( DBGoTo( rr ))
         endif
      endif

      if wa # NIL
         buf := Val( AllTrim( wa ))
      endif

      if !IsDigit( AllTrim( LPDPD->DEFINICJA )); && nie jest to kwota dodatnia
         .and.;                                       && i
         !(Left( AllTrim( LPDPD->DEFINICJA ), 1 ) == '-' ) && nie kwota ujemna
         if !LPDP->(DBSeek(Str(idlpd)+Str(LPDPD->ID)))      && jak nie ma pola
            buf := 0                         && w definicji danej listy to = 0
         endif      &&  mimo, ße moße jest wûr¢d definicji osoby w kom¢rce org.
      endif       && np. KZP, ktoû ma zdefniowane, ale na tej liûcie tego brak

      public &zmienna := buf

      LPDPD->( DBSkip())
enddo

if kidlplac # NIL
   ON('LPLACPP',2)
   Select( baza )
endif

LPDPD->(DBSetOrder(1))
LPD->( DBSetOrder(1)); LPD->(DBSetFilter({||.t.})); LPD->(DBSeek( idlpd ))
LPDP->(DBSetOrder(1)); LPDP->(DBSeek(Str(LPD->ID)))
while LPDP->ID_LPD = LPD->ID .and. LPDP->( !Eof())
      LPLACPP->(DBAdd())
      LPLACPP->ID := i++
      LPLACPP->ID_LPLAC := idlplac
      LPLACPP->ID_LPLACP := idlplacp
      LPLACPP->ID_LPDPD := LPDP->ID_LPDPD

wa := NIL

if kidlplac # NIL                      && czy wartoûç jest w kom¢rce org.?
   rr := LPLACPP->( RecNo())
   kidlpdpd := LPDP->ID_LPDPD
   if LPLACPP->(DBSeek( Str( kidlplac ) + Str( kidlplacp ) + Str( kidlpdpd )))
      wa := LPLACPP->WARTOSC
      LPLACPP->( DBGoTo( rr ))
      LPLACPP->WARTOSC := wa     && jest
   else
      LPLACPP->( DBGoTo( rr ))
   endif
endif

      if !LPDPD->(DBSeek(LPDP->ID_LPDPD))
         Alarm( 'Brak definicji pozycji o kodzie ' + AllS(LPDP->ID_LPDPD))
      else
         zmienna := AllTrim( LPDPD->KOD )
         public &zmienna := 0
         buf := AllTrim( LPDPD->DEFINICJA )
         if Empty( buf )
            buf := AllTrim( LPLACPP->WARTOSC )
         endif
         if wa # NIL
            buf := AllTrim( wa )
         endi
         if !Empty( buf )
            if Left( buf, 1 ) == "="         && dziaíanie
               buf := SubStr( buf, 2 )
               &zmienna := RunCommand( buf )
               buf := &zmienna
               if ValType( buf ) == "N"
                  buf := AllS( buf )
               endif
            endif
            if IsDigit( LPDPD->MASKA );
               .and.;
               ( IsDigit( buf );
               .or.;
               Left( buf, 1 ) == '-' )     && wartoûç

               if oidlpd = 0               && kopia definicji do listy os¢b
                  LPLACPP->WARTOSC := buf  && liczba jak w definicji pola
               endif                       && np.: "32.90", a nie "32,90"

               buf := Val(buf)

if LPAlarmMin .and. buf < 0
   LPAlarmMin( buf )
endif

               &zmienna := buf

               if oidlpd # 0               && !(kopia definicji do listy os¢b)
                  if buf # 0 .or. LPDPD->ZERA_TEZ == "T"
                     buf := Transform( buf, AllTrim( LPDPD->MASKA ))
                     buf := StrTran( buf, '.', '~' )
                     buf := StrTran( buf, ',', if( Empty( LPDPD->ZNAK_T ), ".", LPDPD->ZNAK_T ))
                     buf := StrTran( buf, '~', if( Empty( LPDPD->ZNAK_U ), ",", LPDPD->ZNAK_U ))
                  else
                     buf := ''
                  endif
                  LPLACPP->WARTOSC := buf    && liczba
               endif
            else
               &zmienna := buf
               LPLACPP->WARTOSC := buf    && tekst
            endif
         endif
      endif
      
      LPDP->( DBSkip())
enddo

******************************************************************************
* DSeriePrac('LPRAC',
*            "ON('LPRACZ'),ON('LPRACZ',,,,.t.)",
*            '(baza)->(DBAdd()),
*             (baza)->ID:=(baza)->(GetLast(1,1)+1),
*             (baza)->ID_LPLAC:=LPLAC->ID,
*             (baza)->ID_PRAC:=LPRACZ->POLE,
*             (baza)->(CSeriiDef())',
*             LPLAC->STATUS='B')
* Dopisz serie pracownik¢w

procedure DSeriePrac( a, b, c, d )

local rr, rr1

if d # NIL .and. d; Alarm('Lista zablokowana'); return; endif

rr := RecNo()
DBGoBottom()
rr1 := if( Eof(), 0, RecNo()) + 1

ViewDBF( a, .t.,,, b )
LPRACZ->( DBEval({|| RunCommand( c )}))
if !DBGo( rr1 )
   if !DBGo( rr )
      go top
   endif
endif
zmiana := .t.

******************************************************************************
* PracNadaj('LPRACT,lpractt.txt',
*            'LPRACZ',
*            '(baza)->(DBSeek(LPRACZ->POLE)),
*             (baza)->(Blokuj_R()),
*             (baza)->TYP:=globalbuf,
*             (baza)->(OdBlokuj_R())')
* Nadaj wybranym pracownikom wybrany typ

procedure PracNadaj( a, b, c )

local rr := RecNo(), ii := IndexOrd()

DBSetOrder( 1 )
globalbuf := NIL
ViewDBF( a, .t. )
if globalbuf # NIL
   ( b )->( DBEval({|| RunCommand( c )}))
endif
DBSetOrder( ii )
DBGo( rr )
LastZero()
zmiana := .t.

******************************************************************************

function PracAktual( slplist )

local bb := Alias(), ii := IndexOrd(), rr := RecNo(), od, zd := .f.

od :=  Alarm( 'Aktualizowaç wartoûci skíadnik¢w píacy pracownika?',;
            { 'Wszystkie listy', 'Listy z zakresu dat', 'Esc=Anuluj' })
do case
   case od = 0; return
   case od = 3; return
   case od = 2
        if NIL = Get_Okres( @data1, @data2 ); return; endif
        zd := .t.   && zakres dat
endcase

ON( 'LISTYPO' )
while !Eof(); replace PUBRUTTOW with 0; skip; enddo

ON( 'LISTYPP' )
while ( 'LISTYPP' )->( !Eof())
      ( 'LISTYP' )->( DBSeek(( 'LISTYPP' )->LP_LISTYP ))
      if zd .and. (( data1 > ( 'LISTYP' )->DATA ) .or. ( data2 < ( 'LISTYP' )->DATA ))
         ( 'LISTYPP' )->( DBSkip())
         loop
      endif         
      if ',' + AllS(( 'LISTYP' )->LP_LISTYPR ) + ',' $ ',' + slplist + ','
         if ( 'LISTYPO' )->( DBSeek(( 'LISTYPP' )->LP_LISTYPO ))
            ( 'LISTYPO' )->PUBRUTTOW += ( 'LISTYPP' )->K_PBEZSKLA
         endif
      endif
      ( 'LISTYPP' )->( DBSkip())
enddo

Select( bb )
DBSetOrder( ii )
DBGoTo( rr )

wy := 2

******************************************************************************
* x - parametry formularza
* bm - baza mark
* pm - pole mark

procedure SeriaWydruk( x, bm, pm )

local i, jest_eject, fdo, szl, rr := RecNo()

private ips := 2   && iloûç per strona

if bm = NIL
   szl := .f.
else
   ( bm )->( DBGoTop())
   szl := ( bm )->( !Eof())       && sÜ zaznaczone listy
endif

if szl
   fdo := fast_druk
   fast_druk := .t.
   DBGoTop()
   i := 0
   jest_eject := .f.
   while !Eof()
         if !( Mark( bm, &pm, '*' ) == '*' ); skip; loop; endif
         i ++
         jest_eject := .f.
         Wydruk(AllTrim(LISTYPR->(GetPole(,'LP_LISTYPR','FORMULARZ')))+'.wyd','LISTYP','LISTYPP','LP',2,,,'LP_LISTYP',,,,,,1)
         mOpen( 'a' )
         skip
         if Eof()
            ?? MemoRead( cat_wzorow + 'listypko.txt' )
         endif
         skip -1
         if i = ips
            i := 0
            eject
            jest_eject := .t.
         else
            ?
            ?
         endif
         mClose( 'a' )
         skip
   enddo
   if !jest_eject
      mOpen( 'a' )
      eject
      mClose( 'a' )
   endif
   fast_druk := fdo
elseif NewSysForm( x )
   fdo := fast_druk
   fast_druk := .t.
   DBSetOrder( 3 )
   DBSeek( data_od, .t. )
   i := 0
   jest_eject := .f.
   while DATA <= data_do .and. !Eof()
         i ++
         jest_eject := .f.
         Wydruk(AllTrim(LISTYPR->(GetPole(,'LP_LISTYPR','FORMULARZ')))+'.wyd','LISTYP','LISTYPP','LP',2,,,'LP_LISTYP',,,,,,1)
         mOpen( 'a' )
         skip
         if !( DATA <= data_do .and. !Eof())
            ?? MemoRead( cat_wzorow + 'listypko.txt' )
         endif
         skip -1
         if i = ips
            i := 0
            eject
            jest_eject := .t.
         else
            ?
            ?
         endif
         mClose( 'a' )
         skip
   enddo
   if !jest_eject
      mOpen( 'a' )
      eject
      mClose( 'a' )
   endif
   fast_druk := fdo
endif

DBGoTo( rr )

******************************************************************************

procedure ListyKopia()

local od, no, nn, re, re_stop, dt

od := Alarm( 'Wybierz wariant kopii listy:', { 'BießÜca lista', 'Listy z zakresu dat' })

do case
   case od = 0; return
   case od = 1

        if ( dt := Get_U( 10, 10, 'Podaj datë pod jakÜ ma figurowaç nowa lista:', '@S8', Datee())) = NIL; return; endif

        no := LISTYP->LP
        nn := GetLast(1,1)+1
        KopiaRec( 'LISTYP', 'LISTYP',,,, { || LISTYP->LP := nn, LISTYP->DATA := dt, .t. })

        ON( 'LISTYPP', 2 )
        DBSeek( no )
        copy to ROB while LP_LISTYP = no
        use ROB new
        KopiaRec( 'ROB', 'LISTYPP',,,, { || LISTYPP->LP_LISTYP := nn, .f. })
        Zwolnij( 'ROB' )

   case od = 2

        if Get_Okres( @data_od, @data_do ) = NIL; return; endif
        if ( dt := Get_U( 10, 10, 'Podaj datë pod jakÜ majÜ figurowaç nowe listy:', '@S8', Datee())) = NIL; return; endif

        nn := GetLast(1,1)
        DBSetOrder( 3 )
        DBSeek( data_od, .t. )
        while DATA <= data_do .and. !Eof()
           nn ++
           no := LISTYP->LP
           re := LISTYP->( RecNo())
           KopiaRec( 'LISTYP', 'LISTYP',,,, { || LISTYP->LP := nn, LISTYP->DATA := dt, .t. })


           if re_stop = NIL; re_stop := RecNo(); endif   && pierwszy dopisany

           ON( 'LISTYPP', 2 )
           DBSeek( no )
           copy to ROB while LP_LISTYP = no
           use ROB new
           KopiaRec( 'ROB', 'LISTYPP',,,, { || LISTYPP->LP_LISTYP := nn, .f. })
           Zwolnij( 'ROB' )

           Select( 'LISTYP' )
           goto re
           skip
           if re_stop # NIL .and. re_stop = RecNo(); exit; endif
        enddo
endcase

wy := 2
Select( 'LISTYP' )

******************************************************************************

procedure LPAlarmMin( x )

local odp

   odp := Alarm( AllTrim( LPRAC->NAZWA ) + ';' +;
                 AllTrim( LPDPD->NAZWA ) + ' = ' + AllS( x ),;
               { 'Zignoruj=Esc', 'Nie alarmuj do ko§ca tej sesji', 'Nie alarmuj nigdy wiëcej' })

   if odp = 2
      Alarm( 'Parametr "LPAlarmMin" ustawiam na "NIE";do czasu wyjûcia z programu' )
      LPAlarmMin := .f.
   endif

   if odp = 3
      Alarm( 'Parametr "LPAlarmMin" ustawiam na "NIE";do odwoíania (patrz opcja "Parametry")' )
      ON( 'PARAMS' )
      if !DBSeek( 'LPALARMMIN' )
         DBAppend()
         PARAMS->ID := 'LPAlarmMin'
         PARAMS->NAZWA := 'Alarmowaç w razie wartoûci ujemnej pozycji w listach píac'
         PARAMS->TYP := 'L'
      endif
      PARAMS->( Blokuj_R())
      PARAMS->WARTOSC := 'NIE'
      PARAMS->( OdBlokuj_R())
      LPAlarmMin := .f.
   endif

******************************************************************************
* im - import ?

procedure PITImpExp( im )

local buf, ii, rr

ii := PIT->( IndexOrd())
rr := PIT->( RecNo())

if im = NIL
   im := ( Alarm( 'Wybierz wariant procedury:', { 'Import', 'Export' }) = 1 )
elseif im
   if Alarm( 'Importowaç PITy ?', nt ) # 2; return; endif      
else
   if Alarm( 'Exportowaç PITy ?', nt ) # 2; return; endif
endif

if im

if File( 'c:\ARCHIWUM\_PIT.DBF' ) .and.;
   File( 'c:\ARCHIWUM\_PITP.DBF' )

   ON( 'PITZ',,,, .t. )             && gwiazdki sio

   PIT->( DBSetOrder( 1 ))          && LP
   PIT->( DBGoBottom())

   buf := PIT->LP

   use ( 'c:\ARCHIWUM\_PIT' ) new
   use ( 'c:\ARCHIWUM\_PITP' ) new

else

   Alarm( 'Brak kompletu baz danych do importu.;MajÜ byç "_PIT" i "_PITP" w "C:\ARCHIWUM"' )
   return

endif

Select( '_PIT' ); go top
while !Eof()

      buf++

      KopiujRec( '_PIT', 'PIT' ); PIT->LP := buf
      Mark( 'PITZ', PIT->LP )

      Select( '_PITP' ); go top
      while !Eof()
            if LP_PIT = _PIT->LP
               KopiujRec( '_PITP', 'PITP' ); PITP->LP_PIT := buf
            endif
            skip
      enddo

      Select( '_PIT' ); skip

enddo

Select ( '_PIT' ); use
Select ( '_PITP' ); use

else

   PITZ->( DBGoTop())
   if PITZ->( Eof())
      if Alarm( 'Brak zaznacze§ PIT¢w do exportu.;Czy ma to byç bießÜcy PIT ?', tk ) # 1
         return
      endif
      PITZ->( DBAdd())
      PITZ->POLE := PIT->LP
   endif

Czek( 1 )

PIT->( DBSetOrder( 1 ))        && LP
PITP->( DBSetOrder( 1 ))       && Str(LP_PIT)+Str(NUMER)

Select( 'PIT' ); copy to ( 'c:\ARCHIWUM\_PIT' ) while .f.      && sama struct
Select( 'PITP' ); copy to ( 'c:\ARCHIWUM\_PITP' ) while .f.

use ( 'c:\ARCHIWUM\_PIT' ) new
use ( 'c:\ARCHIWUM\_PITP' ) new

Select( 'PITZ' ); DBGoTop()
Przerwa( LastRec(),,1)
while PITZ->( !Eof())
      PIT->( DBSeek( PITZ->POLE ))          && lista
      PITP->( DBSeek( Str( PIT->LP )))      && pozycja
      while PITP->LP_PIT = PIT->LP .and. PITP->( !Eof())
            KopiujRec( 'PITP', '_PITP' )
            PITP->( DBSkip())
      enddo
      KopiujRec( 'PIT', '_PIT' )
      PITZ->( DBSkip())
      Przerwa(,,1)
enddo
Przerwa( 0,, 1 )
Czek( 0 )

Select ( '_PIT' ); go top
   while !Eof(); replace LP with -LP; skip; enddo
   use
Select ( '_PITP' ); go top
   while !Eof(); replace LP_PIT with -LP_PIT; skip; enddo
   use

endif

Select( 'PIT' )
PIT->( DBSetOrder( ii ))
PIT->( DBGoTo( rr ))
wy := 2

******************************************************************************
* Poprzednia deklaracja: 2000.01 - 0.01 = 1999.12

function PopD( d )

local x

x := d - 0.01
if Int( x ) = x                  && miesiÜc zero
   x := Int( x ) - 1 + 0.12      && miesiÜc 12 poprzedniego roku
endif
return x

******************************************************************************
