******************************************************************************
*********************  ELIMINACJA ZBDNYCH PROCEDUR  *************************
******************************************************************************
#include 'Inkey.ch'

#IFDEF total

procedure InitDekret( a )    && 53      FK
procedure WpiszDekrety( a )  && 55
procedure ZEST1_Tworz( a )   && 62
procedure ZEST1W_Tworz( a )  && 67
procedure SprawdzKonta( a )  && 69
procedure SaldoKonta( a )    && 70
procedure KontoDopisz( a )   && 71
procedure FrykasImport( a )  && 72
procedure Rej_SP( a )        && 76
procedure Rej_ZA( a )        && 77
procedure ZEST1S_Tworz( a )  && 78
function Szablon( k, s )
procedure ZEST1WB_Tworz( a ) && 79
procedure ZEST2_Tworz( a, b, c )  && 80
procedure ZEST3_Tworz( a, b )  && 81

procedure SrTrwAmoDop( a )   && 17     ˜rodki trwa’e
procedure SrTrwaleDop( a )   && 26
procedure Amortyzuj( a )     && 27
procedure Wycof_AMO( a )     && 28
procedure Wydruk_AMO()       && 29

procedure SprawyDopisz( a )  && 30     Sprawy do za’atwienia
procedure Wypisz_sprawy

procedure DrukPrzelew( l1, l2, l3 )   && 32    Przelewy

procedure Init_Dokument( a )       && 40       Dokument
procedure Dodaj_towar( nr, b )     && 42
procedure INC_MAG( kod, il, m_skad, m_dokad, przychod, nietr )
procedure Znakuj( a )              && 47
function Znak( sy )
procedure WybierzTowary( a, b )   && 46
procedure INC_ROZ( ce, il, po )
procedure KonToBufor( kod )
procedure KonToMagazyn( kod, m_skad, m_dokad, przychod )
procedure ReadKontrakt( a )   && 48
procedure ReadObroty( a )     && 49
function Jest_Towar( kod, m_skad, m_dokad )
function Jest_Dokument( kod )
procedure WpiszKontrakt( d_kod, m_skad, m_dokad, przychod )
procedure WypiszKontrakt( d_kod, m_skad, m_dokad, przychod )
procedure WpiszDokument( d_kod, przychod )
procedure WpiszRozlicze( k_kod, przychod )
function Dok_OK( w )
procedure Done_Dokument( a )    && 43
procedure UsunDokument( a )     && 50
procedure ObliczStan( a )       && 51
procedure LiczStan( dd )
procedure LiczObroty( d1, d2, przychody )
procedure PutStanTo( p )
procedure RozlMagazyn( a )     && 52

******************************************************************************
* Pokazywanie zaznaczonych pozycji

function Znak_ASO( sy, ce )

return if( ASOR_WYB->( DBSeek( sy + Str( ce, 12, 2 ))), '*', ' ' )

******************************************************************************
* Zaznaczanie wybranych pozycji

procedure Zaznacz_ASO( sy, ce )     && Nr 82

sy := SYMBOL
ce := CENA_Z

if ASOR_WYB->( DBSeek( sy + Str( ce, 12, 2 )))  && jest
   ASOR_WYB->( BDelete())    && skasuj
else                          && nie ma
   ASOR_WYB->( DBAppend())    && dopisz
   ASOR_WYB->SYMBOL := sy     && i wpisz SYMBOL
   ASOR_WYB->CENA_Z := ce     && i wpisz CEN
endif

Keyboard Chr( K_DOWN )

******************************************************************************
* Podžwietlanie wybranych pozycji
* sy - kod Odbiorcy

function Znak_ODB( sy )

return if( ODB_WYB->( DBSeek( sy )), '*', ' ' )

******************************************************************************

procedure Zaznacz_ODB( sy )         && Nr 83

sy := KOD

if ODB_WYB->( DBSeek( sy ))
   ODB_WYB->( BDelete())
else
   ODB_WYB->( DBAppend())
   ODB_WYB->( FieldPut( 1, sy ))
endif

Keyboard Chr( K_DOWN )

******************************************************************************
* Podžwietlanie wybranych pozycji
* sy - kod dostawcy

function Znak_DOS( sy )

return if( DOS_WYB->( DBSeek( sy )), '*', ' ' )

******************************************************************************

procedure Zaznacz_DOS( sy )         && Nr 84

sy := KOD

if DOS_WYB->( DBSeek( sy ))
   DOS_WYB->( BDelete())
else
   DOS_WYB->( DBAppend())
   DOS_WYB->( FieldPut( 1, sy ))
endif

Keyboard Chr( K_DOWN )

******************************************************************************
* Si‘gaj do ODBIORC£W, zaznaczaj i poka§ ile zaznaczy’ež

function F1_ODB_WYB( a )     && 85

local bb := Alias()

ViewDBF( a, .t. )

private i := ReadVar()

&i := 0
ON( 'ODB_WYB' )
while !Eof()
      &i ++
      DBSkip()
enddo

Select( bb )

******************************************************************************
* Rozliczenie odbiorc¢w dokumentami

procedure Roz_Odb( a )         && 86

local bb := Alias()

private il_od, fv_ok, ru_ok

store .t. to fv_ok, ru_ok

il_od := 0

ON( 'ODB_WYB' )
while !Eof()
      il_od ++
      DBSkip()
enddo

if !NewSysForm( a )
   Select( bb )
   return
endif

ON( bb )
ON( bb,,,, .t. )

if il_od # 0; ON( 'ODB_WYB' ); endif

if fv_ok
   ON( 'FAKTURY' )
   DBSeek( DtoS( data_od ), .t. )
   while DATASP <= data_do .and. !Eof()
         if !ANULOWANA .and. ( il_od = 0 .or. Znak_ODB( PLATNIK ) == '*' )
            AppendRecord( 'ROZ_ODBD', { PLATNIK, 'FAKTURY', 'FV', NUMER, DATA, DATASP, ILOSC, WARTOSC, KWOTA })
         endif
         DBSkip()
   enddo
   Zwolnij( 'FAKTURY' )
endif

Select( bb )
wy := 2
go top

******************************************************************************
#ELSE
******************************************************************************

function Znak_ASO( sy, ce )
procedure Zaznacz_ASO( sy, ce )     && 82
function Znak_ODB( sy )
procedure Zaznacz_ODB( sy )         && 83
function Znak_DOS( sy )
procedure Zaznacz_DOS( sy )         && 84
function F1_ODB_WYB( a )            && 85
procedure Roz_Odb( a )              && 86

#ENDIF

******************************************************************************
