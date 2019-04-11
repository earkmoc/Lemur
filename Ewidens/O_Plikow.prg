#include 'Directry.ch'
#include 'Inkey.ch'

******************************************************************************

procedure MSPJawne( znaczki, s, n, d, a, r )

local ok, naz, nad, nar

naz := Right( n, 4 )

if naz == '.DOC'; AUDYTU->DOC++; endif
if naz == '.XLS'; AUDYTU->XLS++; endif
if naz == '.MDB'; AUDYTU->MDB++; endif
if naz == '.DBF'; AUDYTU->DBF++; endif
if naz == '.CDR'; AUDYTU->CDR++; endif

if DBSeek( PadR( n, 12 ))

   @ 0, 0 say PadR( s + '\' + n, 79 )
   naz := if( !Empty( NAZWA ), NAZWA, '' )
   nad := if( !Empty( EXE_DATA ), EXE_DATA, CtoD(''))
   nar := if( !Empty( EXE_SIZE ), EXE_SIZE, 0 )

   do case
   case DBSeek( PadR( n, 12 ) + DtoS( d ))

        && aktualizacja rozmiaru i ûcießki konkretnej daty
        AppendRecord( 'AUDYTP', { ,,,,, s }, 1 )

   case DBSeek( PadR( n, 12 ) + Str( r, 8 ))

        && aktualizacja rozmiaru i ûcießki konkretnego rozmiaru
        AppendRecord( 'AUDYTP', { ,,,,, s }, 1 )

   case DBSeek( PadR( n, 12 ))

        ok := .f.
        while !ok .and. Upper( EXE_NAZWA ) == PadR( n, 12 ) .and. !Eof()

              naz := if( !Empty( NAZWA ), NAZWA, naz )
              nad := if( !Empty( EXE_DATA ), EXE_DATA, nad )
              nar := if( !Empty( EXE_SIZE ), EXE_SIZE, nar )

              if Empty( EXE_DATA ) .and. ( EXE_SIZE = 0 )      && po rozmiarze
                 AppendRecord( 'AUDYTP', { ,, n,, r, s }, 1 )
                 ok := .t.
                 exit
              endif

              skip
        enddo

        if !ok
           if Empty( nad )    && po rozmiarze
              nad := NIL
           else               && po dacie
              nad := d
              r := 0
           endif
           AppendRecord( 'AUDYTP', { GetLast( 1, 1 ) + 1, AllTrim( naz ) + ' (???: ' + AllS( r ) + ')', n, nad, r, s })
        endif

   endcase

   if Mark( znaczki, Str( KOD, 10 ) + Str( AUDYTU->KOD, 10 ), '*' ) # '*'
      Mark( znaczki, Str( KOD, 10 ) + Str( AUDYTU->KOD, 10 ),, KOD, AUDYTU->KOD )
   endif

endif

******************************************************************************

procedure MSPTajne( znaczki2, s, n, d, a, r )

local ok, ok2, naz, nad, nar, ii

naz := Right( n, 4 )

if !( naz == '.EXE' .or. naz == '.COM' ); return; endif

ii := AUDYTP->( IndexOrd())

AUDYTP->( DBSetOrder( 3 ))
ok := AUDYTP->( DBSeek( PadR( n, 12 )))
ok2 := Len( s ) < 3

if !ok .and. !ok2
   AUDYTP->( DBSetOrder( 4 ))
   naz := s
   while !ok2 .and. Len( naz ) > 2
         if ( ok2 := AUDYTP->( DBSeek( PadR( naz, 80 ))))
            exit
         endif
         naz := Left( naz, RAt( '\', naz ) - 1 )
   enddo
endif

AUDYTP->( DBSetOrder( ii ))

if ok;     && plik jawny
   .or.;   && lub
   ok2     && ûcießka zarejestrowana
   return
endif

if AUDYTT->( !DBSeek( PadR( n, 12 )))
   AUDYTT->( AppendRecord( 'AUDYTT', { GetLast( 1, 1 ) + 1, n, d, r, s }))
else
   AUDYTT->( AppendRecord( 'AUDYTT', { ,, d, r, s }, 1 ))
endif

if Mark( znaczki2, Str( AUDYTT->KOD, 10 ) + Str( AUDYTU->KOD, 10 ), '*' ) # '*'
   @ 0, 0 say PadR( s + '\' + n, 79 )
   Mark( znaczki2, Str( AUDYTT->KOD, 10 ) + Str( AUDYTU->KOD, 10 ),, AUDYTT->KOD, AUDYTU->KOD )
endif

******************************************************************************
* Rekurencyjna procedura czeszÜca katalogi w poszukiwaniu plik¢w
* mode - síowne okreûlenie rodzaju poszukiwanych plik¢w

procedure SubPliki( s, mode )

local pliki := Directory( s + '\*.*', 'HSD' )
local n, d, a, r, i

if Len( s ) > 80 .or. 'RECYCLE' $ s; return; endif

private katalogi := {}

for i := 1 to Len( pliki )
    n := pliki[ i, F_NAME ]
    d := pliki[ i, F_DATE ]
    r := pliki[ i, F_SIZE ]
    a := pliki[ i, F_ATTR ]
    if n # '.' .and. n # '..'
       if 'D' $ a
          @ 0, 0 say PadR( s + '\' + n, 79 )
          Aadd( katalogi, n )
       else
          do case
          case mode == 'jawne'; MSPJawne( znaczki, s, n, d, a, r )
          case mode == 'tajne'; MSPTajne( znaczki2,s, n, d, a, r )
          endcase
       endif
    endif
next

for i := 1 to Len( katalogi )
    SubPliki( s + '\' + katalogi[ i ], mode )
next

******************************************************************************

procedure MSPCzysc( znaczki, znaczki2 )

local bb := Alias()

if Alarm( 'Czyûciç dotychczasowe zaznaczenia program¢w ?', nt ) = 2

Czek( 1 )

AUDYTU->( Blokuj_R())
AUDYTU->DOC := 0
AUDYTU->XLS := 0
AUDYTU->MDB := 0
AUDYTU->DBF := 0
AUDYTU->CDR := 0

set filter to
go top
while !Eof()
      AppendRecord( 'AUDYTP', { ,,,,, '' }, 1 )
      if Mark( znaczki, Str( KOD, 10 ) + Str( AUDYTU->KOD, 10 ), '*' ) == '*'
         Mark( znaczki, Str( KOD, 10 ) + Str( AUDYTU->KOD, 10 ),, KOD, AUDYTU->KOD )
      endif
      skip
enddo

ON( znaczki2 )
ON( 'AUDYTT', 2 )      && w/g "nazwy.exe"
AUDYTT->( DBGoTop())
while AUDYTT->( !Eof())
      if Mark( znaczki2, Str( AUDYTT->KOD, 10 ) + Str( AUDYTU->KOD, 10 ), '*' ) == '*'
         Mark( znaczki2, Str( AUDYTT->KOD, 10 ) + Str( AUDYTU->KOD, 10 ),, AUDYTT->KOD, AUDYTU->KOD )
      endif
      AUDYTT->( DBSkip())
enddo

DBZap( ',' + znaczki2, 1 )
DBZap( ',' + znaczki, 1 )

Czek( 0 )

Select( bb )
go top
wy := 2

endif

******************************************************************************
* Funkcja wykonyje 'AScan' na tablicach powstaíych po 'Directory'

function SPlik( in, bm, bm2 )

local bb := Alias(), ii := IndexOrd(), rr := RecNo(), dr

*if Alarm( 'Sprawdziç automatycznie wystëpowanie program¢w ?', tk ) # 1; return; endif
*if ( dr := Alarm( 'Wybierz dysk:', { 'dysk "C:"', 'dysk "D:"', 'inny dysk' })) < 1; exit; endif

if ( dr := Alarm( 'Sprawdziç automatycznie wystëpowanie program¢w ?', { 'dysk "C:"', 'dysk "D:"', 'inny dysk' })) < 1; return; endif
do case
   case dr = 1; dr := 'C'
   case dr = 2; dr := 'D'
   otherwise
        if NIL = ( dr := Get_U( 10, 10, 'Podaj dysk do sprawdzenia:', 'X', 'G' ))
           return
        endif
endcase

private znaczki := bm, znaczki2 := bm2

set filter to

*while .t.

ON( znaczki2 )
ON( 'AUDYTT', 2 )    && audyt program¢w tajnych

Select( bb )         && audyt program¢w jawnych
DBSetOrder( in )
go top
while !Eof()
      if !Empty( SCIEZKA )
         MSPCzysc( znaczki, znaczki2 )
         exit
      endif
      skip
enddo

Czek( 1 )
   SubPliki( dr + ':', 'jawne' )
   SubPliki( dr + ':', 'tajne' )
   @ 0, 0 say PadR( '', 79 )
Czek( 0 )

*enddo

DBSetOrder( ii )
DBGoTo( rr )
wy := 2

******************************************************************************
* Funkcja wykonyje 'AScan' na tablicach powstaíych po 'Directory'

function FScan( tab , w )

local i

for i := 1 to Len( tab )
    if tab[ i , F_NAME ] = w[ F_NAME ] .and. tab[ i , F_SIZE ] = w[ F_SIZE ]
       return i
    endif
next

return 0

******************************************************************************
