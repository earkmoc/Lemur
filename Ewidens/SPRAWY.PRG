******************************************************************************
***************   S P R A W Y   D O   Z A œ A T W I E N I A  *****************
******************************************************************************
* funkcja 30

procedure Zanki()

public lat := '¤¨ãà—½¥†©ˆä¢˜«¾'
public maz := '•œ¥£˜ ¡†‘’¤¢ž¦§'
public inez:= '•œ¥£˜ ¡†‘’†¢ž¦§'
public bezpl:='ACELNOSZZacelnoszz'
public win := '¥ÆÊ£ÑÓŒ¯¹æê³ñóœŸ¿'
public zus := '¡ÆÊ£ÑÓ¦¬¯¡ÆÊ£ÑÓ¦¬¯'
public la2 := '¡ÆÊ£ÑÓ¦¬¯±æê³ñó¶¼¿'


******************************************************************************

procedure SprawyDopisz( a )

Init_LPiDATA( a )
if Val( LP ) = 1
   replace KOD_OBJEKT with OBJEKTY->KOD_OBJEKT
endif

******************************************************************************

function Wypisz_sprawy( h )

public runtimever := '2017.11.22'

if !( h == 'wypisz'); return .f.; endif

cls
ON( 'O_SPRAWY', 2 )
ON( 'OBJEKTY', 2 )
while !Eof()
      if !Empty( KOD_OBJEKT )
         if PRIORYTET < '9'
            Select( 'O_SPRAWY' )
            DBSeek( OBJEKTY->KOD_OBJEKT )
            while ( OBJEKTY->KOD_OBJEKT == KOD_OBJEKT ) .and. ( PRIORYTET < '9' ) .and. !Eof()
                  ? KOD_OBJEKT + ' : ' + Rtrim( TRESC )
                  skip
            enddo
            Select( 'OBJEKTY' )
         endif
      endif
      skip
enddo
?
?
Tone( 200, 1 )
Inkey( 0 )
quit

******************************************************************************
 