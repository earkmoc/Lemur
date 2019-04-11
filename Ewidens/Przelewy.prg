******************************************************************************
***************************  P R Z E L E W Y  ********************************
******************************************************************************

function KasaZakoncz( bazy, splaty, dt, ca )

local r, s, p, a, b, c, n, ww, w, i, tt, tabn, tabw, tabr, x, bb := Alias()
local zak, pca, ps, pp

private wplatyp := 0

if ca = NIL; ca := ''; endif
pca := ca
c := ''

Czek( 1 )

tt := AllTrim( TRESC )
tabn := {}
tabw := {}
tabr := {}
while !Empty( tt )
      a := Odetnij( @tt, ';' )
      if '=' $ a
         n := Odetnij( @a, '=' )
         w := Odetnij( @a, '=' )
         if !Empty( n ) .and. !Empty( w )
            w := StrTran( w, ',', '' )
            w := Val( w )
            if w # 0
               n := Str( w, 15, 2 ) + '=' + AllTrim( n )
               Aadd( tabn, n )
            endif
         endif
      endif
enddo

tabn := ASort( tabn )
n := Len( tabn )
for i := 1 to n
   r := ''
   x := tabn[ n - i + 1 ]
   w := Grosz( Val( x ))
   tt := AllTrim( SubStr( x, At( '=', x ) + 1 ))
   s := bazy
   p := splaty
   while !Empty( s ) .and. !Empty( x )
		pp := p
		ps := s
		while .t.
         b := Odetnij( @p )
         ON( c + b )
         a := Odetnij( @s )
         ON( c + a )
         while !Eof() .and. !Empty( x )
               if AllTrim( NUMER ) == tt .and. NRKONT = ( bb )->NRKONT
                  if zak := ( FieldPos( 'K9' ) > 0 )
                    ww := Grosz( K9 - ( K26 + WPLATYP ))  && kwota do zaplaty
                  else
                    ww := Grosz( K11 - K21 )
                  endif
                  if ww >= 0 .and. w >=0   && normalna faktura
                     if ww >= w .and. ww > 0    && do zap’aty pokrywa kwot‘ "w"
                        r := x + ' dopasowano do LP=' + AllS( LP ) + ' w ' + AllTrim( a )
                        x := ''
				            Blokuj_R()
				            if zak
				               replace K26 with K26 + w
				            else
				               replace K21 with K21 + w
				            endif
				            if ( FieldPos( 'D5' ) > 0 )   && data zap³aty koñcowej
                          if zak
                            if Abs( K9 - ( K26 + WPLATYP )) < 0.01
                              if Empty( D5 ) .or. ( D5 = dt )
                                  replace D5 with dt
                              else
                                if ( Alarm( 'Na dokumencie zakupu ju¿ jest wpisana data zap³aty;Data zap³aty na dokumencie=' + DtoC( D5 ) + ',; wpisywana data zap³aty=' + DtoC( dt ) + ';Nadpisaæ poprzedni¹ datê, tj. przyj¹æ now¹ datê ?', tk, 1 ) = 1 )
                                  replace D5 with dt
                                endif
                              endif
                            endif
                          else
                            if Abs( K11 - K21 ) < 0.01
                              replace D5 with dt
                            endif
                          endif
			             	endif
         			    	Odblokuj_R()
                      	AppendRecord( b, { LP, dt, w, '100  Raport kasowy Nr ' + ( bb )->( AllTrim( NRK ) + '/' + AllTrim( NUMER )) + ' z dnia ' + DtoC(( bb )->D3 )})
                        exit
                     endif
                  else                 && faktura ujemna ( np.: koryguj†ca )
                     if ww <= w     && do zap’aty pokrywa kwot‘ "w"
                        r := x + ' dopasowano do LP=' + AllS( LP ) + ' w ' + AllTrim( a )
                        x := ''
			               Blokuj_R()
			               if zak
			                  replace K26 with K26 + w
			               else
			                  replace K21 with K21 + w
			               endif
			               if ( FieldPos( 'D5' ) > 0 )   && data zap³aty koñcowej
                          if zak
                            if Abs( K9 - ( K26 + WPLATYP )) < 0.01
                              if Empty( D5 ) .or. ( D5 = dt )
                                replace D5 with dt
                              else
                                if ( Alarm( 'Na dokumencie zakupu ju¿ jest wpisana data zap³aty;Data zap³aty na dokumencie=' + DtoC( D5 ) + ',; wpisywana data zap³aty=' + DtoC( dt ) + ';Nadpisaæ poprzedni¹ datê, tj. przyj¹æ now¹ datê ?', tk, 1 ) = 1 )
                                  replace D5 with dt
                                endif
                              endif
                            endif
                          else
			                    if Abs( K11 - K21 ) < 0.01
                              replace D5 with dt
			                    endif
			                 endif
			               endif
			               Odblokuj_R()
                        AppendRecord( b, { LP, dt, w, '100  Raport kasowy Nr ' + ( bb )->( AllTrim( NRK ) + '/' + AllTrim( NUMER )) + ' z dnia ' + DtoC(( bb )->D3 )})
                        exit
                     endif
                  endif
               endif
               skip
         enddo
         Zwolnij( a )
         Zwolnij( b )
			if Empty( c := Odetnij( @ca )); exit; endif
		   s := ps
		   p := pp
			c := c + '\'
		enddo
		ca := pca
   enddo
   if !Empty( x ); Aadd( tabw, x ); endif
   if !Empty( x ); Aadd( tabr, x + ' niedopasowano' ); endif
   if !Empty( r ); Aadd( tabr, r ); endif
next

Select( bb )

Czek( 0 )

if Len( tabr ) # 0
   Alarm( 'Raport kasowy Nr ' + AllTrim( NRK ) + '/' + AllTrim( NUMER ) + ' dla "' + AllTrim( NAZWA ) +;
        '";Raport dopasowania pozycji:', tabr )
endif

if Len( tabw ) # 0
   REJ_KA->( Blokuj_R())
   REJ_KA->OTWARTY := '?'
   REJ_KA->( OdBlokuj_R())
   return .f.
endif

return .t.

******************************************************************************
* Nr : 32  
*  a : liczba znak¢w w wierszu dla "s’ownie"

procedure KasaBlokuj( bazaz, bazy, splaty, ca )

local i, w, rr := RecNo(), dt := data1

dt := D3
if NIL = ( dt := Get_U( 10 , 20 , 'Podaj dat‘ blokowania:' , '@S10' , dt )); return; endif

( bazaz )->( DBGoTop())
if ( bazaz )->( Eof())
  w := 1
   if w = 0
   elseif w = 1
      if REJ_KA->OTWARTY == 'B'
         if Alarm( 'Raport kasowy ju§ jest zablokowany.;Zablokowa powt¢rnie ?', nt ) # 2; return; endif
      endif
      REJ_KA->( Blokuj_R())
      REJ_KA->OTWARTY := 'B'
      REJ_KA->( OdBlokuj_R())
      KasaZakoncz( bazy, splaty, dt, ca )
   elseif w = 2
      go top
      while !Eof()
         if REJ_KA->OTWARTY == ' '
            REJ_KA->( Blokuj_R())
            REJ_KA->OTWARTY := 'B'
            REJ_KA->( OdBlokuj_R())
            if !KasaZakoncz( bazy, splaty, dt, ca )
               if Alarm( 'Przerwa blokowanie  ?', tk ) = 1
                  rr := REJ_KA->( RecNo())
                  exit
               endif
            endif
         endif
         skip
      enddo
   endif
else
   i := 0
   w := 0
   REJ_KA->( DBSetOrder( 1 ))
   while ( bazaz )->( !Eof())
         if REJ_KA->( DBSeek(( bazaz )->POLE ))
            i ++
            w += K10 + K11
         endif
         ( bazaz )->( DBSkip())
   enddo
   if ( 1 = Alarm( 'Zaznaczono ' + AllS( i ) + ' pozycji na kwot‘ ' + AllS( w, '999,999,999.99 z’') + ';Zablokowa zaznaczone pozycje ?', tk ))
      ( bazaz )->( DBGoTop())
      while ( bazaz )->( !Eof())
            if REJ_KA->( DBSeek(( bazaz )->POLE ))
               if !( REJ_KA->OTWARTY == 'B' )
                  REJ_KA->( Blokuj_R())
                  REJ_KA->OTWARTY := 'B'
                  REJ_KA->( OdBlokuj_R())
                  if !KasaZakoncz( bazy, splaty, dt )
                     if Alarm( 'Przerwa blokowanie  ?', tk ) = 1
                        rr := REJ_KA->( RecNo())
                        exit
                     endif
                  endif
               endif
            endif
           ( bazaz )->( DBSkip())
      enddo
   endif
endif

DBGoTo( rr )
wy := 2

******************************************************************************

function WyciagZakoncz( bazy, splaty, dt, ca )

local r, s, p, a, b, c, n, ww, w, i, tt, tabn, tabw, tabr, x, bb := Alias()
local zak, pca, ps, pp

private wplatyp := 0

if ca = NIL; ca := ''; endif
pca := ca
c := ''

Czek( 1 )

tt := AllTrim( PRZEDMIOT )
tabn := {}
tabw := {}
tabr := {}
while !Empty( tt )
      a := Odetnij( @tt, ';' )
      if '=' $ a
         n := Odetnij( @a, '=' )
         w := Odetnij( @a, '=' )
         if !Empty( n ) .and. !Empty( w )
            w := StrTran( w, ',', '' )
            w := Val( w )
            if w # 0
               n := Str( w, 15, 2 ) + '=' + AllTrim( n )
               Aadd( tabn, n )
            endif
         endif
      endif
enddo

tabn := ASort( tabn )
n := Len( tabn )
for i := 1 to n
   r := ''
   x := tabn[ n - i + 1 ]
   w := Grosz( Val( x ))                          && kwota wplacana
   tt := AllTrim( SubStr( x, At( '=', x ) + 1 ))
   s := bazy
   p := splaty
   while !Empty( s ) .and. !Empty( x )
		pp := p
		ps := s
		while .t.
         b := Odetnij( @p )
         ON( c + b )
         a := Odetnij( @s )
         ON( c + a )
         while !Eof() .and. !Empty( x )
               if AllTrim( NUMER ) == tt .and. NRKONT = ( bb )->NRKONT
                  if zak := ( FieldPos( 'K9' ) > 0 )
                    ww := Grosz( K9 - ( K26 + WPLATYP ))  && kwota do zaplaty
                  else
                    ww := Grosz( K11 - K21 )
                  endif
                  if ww >= 0 .and. w >=0   && normalna faktura
*                   if ww >= w     && do zap’aty pokrywa kwot‘ "w"
                        r := x + ' dopasowano do LP=' + AllS( LP ) + ' w ' + AllTrim( a )
                        x := ''
                        Blokuj_R()
                        if zak
                           if ( FieldPos( 'WPLATYP' ) > 0 )
                              replace WPLATYP with WPLATYP + w
                           else
                              replace K26 with K26 + w
                           endif
                        else
                          replace K21 with K21 + w
                        endif
                        if ( FieldPos( 'D5' ) > 0 )   && data zap³aty koñcowej
                          if zak
                            if Abs( K9 - ( K26 + WPLATYP )) < 0.01
                              if Empty( D5 ) .or. ( D5 = dt )
                                  replace D5 with dt
                              else
                                if ( Alarm( 'Na dokumencie zakupu ju¿ jest wpisana data zap³aty;Data zap³aty na dokumencie=' + DtoC( D5 ) + ',; wpisywana data zap³aty=' + DtoC( dt ) + ';Nadpisaæ poprzedni¹ datê, tj. przyj¹æ now¹ datê ?', tk, 1 ) = 1 )
                                  replace D5 with dt
                                endif
                              endif
                            endif
                          else
                            if Abs( K11 - K21 ) < 0.01
                              replace D5 with dt
                            endif
                          endif
                        endif
                        Odblokuj_R()
                        AppendRecord( b, { LP, dt, w, '130  Wyci†g Nr ' + ( bb )->( AllTrim( NRK ) + '/' + AllTrim( NUMER )) + ' z dnia ' + DtoC(( bb )->D3 )})
                        exit
*                    endif
                  else                 && faktura ujemna ( np.: koryguj†ca )
                     if ww <= w     && do zap’aty pokrywa kwot‘ "w"
                        r := x + ' dopasowano do LP=' + AllS( LP ) + ' w ' + AllTrim( a )
                        x := ''
                        Blokuj_R()
                        if zak
                           if ( FieldPos( 'WPLATYP' ) > 0 )
                              replace WPLATYP with WPLATYP + w
                           else
                              replace K26 with K26 + w
                           endif
                        else
                          replace K21 with K21 + w
                        endif
                        if ( FieldPos( 'D5' ) > 0 )   && data zap³aty koñcowej
                          if zak
                            if Abs( K9 - ( K26 + WPLATYP )) < 0.01
                              if Empty( D5 ) .or. ( D5 = dt )
                                replace D5 with dt
                              else
                                if ( Alarm( 'Na dokumencie zakupu ju¿ jest wpisana data zap³aty;Data zap³aty na dokumencie=' + DtoC( D5 ) + ',; wpisywana data zap³aty=' + DtoC( dt ) + ';Nadpisaæ poprzedni¹ datê, tj. przyj¹æ now¹ datê ?', tk, 1 ) = 1 )
                                  replace D5 with dt
                                endif
                              endif
                            endif
                          else
                            if Abs( K11 - K21 ) < 0.01
                              replace D5 with dt
                            endif
                          endif
                        endif
                        Odblokuj_R()
                        AppendRecord( b, { LP, dt, w, '130  Wyci†g Nr ' + ( bb )->( AllTrim( NRK ) + '/' + AllTrim( NUMER )) + ' z dnia ' + DtoC(( bb )->D3 )})
                        exit
                     endif
                  endif
               endif
               skip
         enddo
         Zwolnij( a )
         Zwolnij( b )
			if Empty( c := Odetnij( @ca )); exit; endif
		   s := ps
		   p := pp
			c := c + '\'
		enddo
		ca := pca
   enddo
   if !Empty( x ); Aadd( tabw, x ); endif
   if !Empty( x ); Aadd( tabr, x + ' niedopasowano' ); endif
   if !Empty( r ); Aadd( tabr, r ); endif
next

Select( bb )

Czek( 0 )

if Len( tabr ) # 0
   Alarm( 'Wyci†g Nr ' + AllTrim( NRK ) + '/' + AllTrim( NUMER ) + ' dla "' + AllTrim( NAZWA ) +;
        '";Raport dopasowania pozycji:', tabr )
endif

if Len( tabw ) # 0
   REJ_BA->( Blokuj_R())
   REJ_BA->OTWARTY := '?'
   REJ_BA->( OdBlokuj_R())
*   Alarm( 'Przelew Nr ' + AllS( LP ) + ' dla "' + AllTrim( NAZ21 ) +;
*        '";Nie uda’o si‘ dopasowa nast‘puj†cych pozycji:', tabw )
   return .f.
endif

return .t.

******************************************************************************
* Nr : 32  
*  a : liczba znak¢w w wierszu dla "s’ownie"

procedure WyciagBlokuj( bazaz, bazy, splaty, ca )

local i, w, rr := RecNo(), dt := data1

dt := D3
if NIL = ( dt := Get_U( 10 , 20 , 'Podaj dat‘ blokowania:' , '@S10' , dt )); return; endif

( bazaz )->( DBGoTop())
if ( bazaz )->( Eof())
*   w := Alarm( 'Nie zaznaczono §adnych wyci†g¢w;Kt¢re wyci†gi zablokowa ?', { 'tylko jeden (bie§†cy)', 'wszystkie niezablokowane' })
  w := 1
   if w = 0
   elseif w = 1
      if REJ_BA->OTWARTY == 'B'
         if Alarm( 'Przelew ju§ jest zablokowany.;Zablokowa powt¢rnie ?', nt ) # 2; return; endif
      endif
      REJ_BA->( Blokuj_R())
      REJ_BA->OTWARTY := 'B'
      REJ_BA->( OdBlokuj_R())
      WyciagZakoncz( bazy, splaty, dt, ca )
   elseif w = 2
      go top
      while !Eof()
         if REJ_BA->OTWARTY == ' '
            REJ_BA->( Blokuj_R())
            REJ_BA->OTWARTY := 'B'
            REJ_BA->( OdBlokuj_R())
            if !WyciagZakoncz( bazy, splaty, dt, ca )
               if Alarm( 'Przerwa blokowanie  ?', tk ) = 1
                  rr := REJ_BA->( RecNo())
                  exit
               endif
            endif
         endif
         skip
      enddo
   endif
else
   i := 0
   w := 0
   REJ_BA->( DBSetOrder( 1 ))
   while ( bazaz )->( !Eof())
         if REJ_BA->( DBSeek(( bazaz )->POLE ))
            i ++
            w += K10 + K11
         endif
         ( bazaz )->( DBSkip())
   enddo
   if ( 1 = Alarm( 'Zaznaczono ' + AllS( i ) + ' wyci†g¢w na kwot‘ ' + AllS( w, '999,999,999.99 z’') + ';Zablokowa zaznaczone wyci†gi ?', tk ))
      ( bazaz )->( DBGoTop())
      while ( bazaz )->( !Eof())
            if REJ_BA->( DBSeek(( bazaz )->POLE ))
               if !( REJ_BA->OTWARTY == 'B' )
                  REJ_BA->( Blokuj_R())
                  REJ_BA->OTWARTY := 'B'
                  REJ_BA->( OdBlokuj_R())
                  if !WyciagZakoncz( bazy, splaty, dt, ca )
                     if Alarm( 'Przerwa blokowanie  ?', tk ) = 1
                        rr := REJ_BA->( RecNo())
                        exit
                     endif
                  endif
               endif
            endif
           ( bazaz )->( DBSkip())
      enddo
   endif
endif

DBGoTo( rr )
wy := 2

******************************************************************************

function PrzelewZakoncz( bazy, splaty, dt )

local r, s, p, a, b, n, w, i, tt, tabn, tabw, tabr, x, bb := Alias()

tt := AllTrim( TYT11 ) + AllTrim( TYT22 )
tabn := {}
tabw := {}
tabr := {}
while !Empty( tt )
      a := Odetnij( @tt, ';' )
      if '=' $ a
         n := Odetnij( @a, '=' )
         w := Odetnij( @a, '=' )
         if !Empty( n ) .and. !Empty( w )
            w := StrTran( w, ',', '' )
            w := Val( w )
            if w # 0
               n := Str( w, 15, 2 ) + '=' + AllTrim( n )
               Aadd( tabn, n )
            endif
         endif
      endif
enddo

tabn := ASort( tabn )
n := Len( tabn )
for i := 1 to n
   r := ''
   x := tabn[ n - i + 1 ]
   w := Grosz( Val( x ))
   tt := AllTrim( SubStr( x, At( '=', x ) + 1 ))
   s := bazy
   p := splaty
   while !Empty( s ) .and. !Empty( x )
         b := Odetnij( @p )
         ON( b )
         a := Odetnij( @s )
         ON( a )
         while !Eof() .and. !Empty( x )
               if AllTrim( NUMER ) == tt .and. NRKONT = ( bb )->NUMER2
                  if Grosz( K9 - K26 ) >= 0 .and. w >=0   && normalna faktura
                     if Grosz( K9 - K26 ) >= w     && do zap’aty pokrywa kwot‘ "w"
                        r := x + ' dopasowano do LP=' + AllS( LP ) + ' w ' + AllTrim( a )
                        x := ''
            Blokuj_R()
                        replace K26 with K26 + w
            Odblokuj_R()
                        AppendRecord( b, { LP, dt, w, '130  Przelew Nr ' + AllS(( bb )->LP ) + ' z dnia ' + DtoC(( bb )->DATA )})
                        exit
                     endif
                  else                 && faktura ujemna ( np.: koryguj†ca )
                     if Grosz( K9 - K26 ) <= w     && do zap’aty pokrywa kwot‘ "w"
                        r := x + ' dopasowano do LP=' + AllS( LP ) + ' w ' + AllTrim( a )
                        x := ''
            Blokuj_R()
                        replace K26 with K26 + w
            Odblokuj_R()
                        AppendRecord( b, { LP, dt, w, '130  Przelew Nr ' + AllS(( bb )->LP ) + ' z dnia ' + DtoC(( bb )->DATA )})
                        exit
                     endif
                  endif
               endif
               skip
         enddo
         Zwolnij( a )
         Zwolnij( b )
   enddo
   if !Empty( x ); Aadd( tabw, x ); endif
   if !Empty( x ); Aadd( tabr, x + ' niedopasowano' ); endif
   if !Empty( r ); Aadd( tabr, r ); endif
next

Select( bb )

if Len( tabr ) # 0
   Alarm( 'Przelew Nr ' + AllS( LP ) + ' dla "' + AllTrim( NAZ21 ) +;
        '";Raport dopasowania pozycji:', tabr )
endif

if Len( tabw ) # 0
   PRZELEW->( Blokuj_R())
   PRZELEW->STATUS := '?'
   PRZELEW->( OdBlokuj_R())
*   Alarm( 'Przelew Nr ' + AllS( LP ) + ' dla "' + AllTrim( NAZ21 ) +;
*        '";Nie uda’o si‘ dopasowa nast‘puj†cych pozycji:', tabw )
   return .f.
endif

return .t.

******************************************************************************
* Nr : 32  
*  a : liczba znak¢w w wierszu dla "s’ownie"

procedure PrzelewBlokuj( bazaz, bazy, splaty )

local i, w, rr := RecNo(), dt := data1

if NIL = ( dt := Get_U( 10 , 20 , 'Podaj dat‘ blokowania:' , '@S10' , dt )); return; endif

( bazaz )->( DBGoTop())
if ( bazaz )->( Eof())
   w := Alarm( 'Nie zaznaczono §adnych przelew¢w;Kt¢re przelewy zablokowa ?', { 'tylko jeden (bie§†cy)', 'wszystkie niezablokowane' })
   if w = 0
   elseif w = 1
      if PRZELEW->STATUS == 'B'
         if Alarm( 'Przelew ju§ jest zablokowany.;Zablokowa powt¢rnie ?', nt ) # 2; return; endif
      endif
      PRZELEW->( Blokuj_R())
      PRZELEW->STATUS := 'B'
      PRZELEW->( OdBlokuj_R())
      PrzelewZakoncz( bazy, splaty, dt )
   elseif w = 2
      go top
      while !Eof()
         if PRZELEW->STATUS == ' '
            PRZELEW->( Blokuj_R())
            PRZELEW->STATUS := 'B'
            PRZELEW->( OdBlokuj_R())
            if !PrzelewZakoncz( bazy, splaty, dt )
               if Alarm( 'Przerwa blokowanie  ?', tk ) = 1
                  rr := PRZELEW->( RecNo())
                  exit
               endif
            endif
         endif
         skip
      enddo
   endif
else
   i := 0
   w := 0
   PRZELEW->( DBSetOrder( 1 ))
   while ( bazaz )->( !Eof())
         if PRZELEW->( DBSeek(( bazaz )->POLE ))
            i ++
            w += KWOTA
         endif
         ( bazaz )->( DBSkip())
   enddo
   if ( 1 = Alarm( 'Zaznaczono ' + AllS( i ) + ' przelew¢w na kwot‘ ' + AllS( w, '999,999,999.99 z’') + ';Zablokowa zaznaczone przelewy ?', tk ))
      ( bazaz )->( DBGoTop())
      while ( bazaz )->( !Eof())
            if PRZELEW->( DBSeek(( bazaz )->POLE ))
               if !( PRZELEW->STATUS == 'B' )
                  PRZELEW->( Blokuj_R())
                  PRZELEW->STATUS := 'B'
                  PRZELEW->( OdBlokuj_R())
                  if !PrzelewZakoncz( bazy, splaty, dt )
                     if Alarm( 'Przerwa blokowanie  ?', tk ) = 1
                        rr := PRZELEW->( RecNo())
                        exit
                     endif
                  endif
               endif
            endif
           ( bazaz )->( DBSkip())
      enddo
   endif
endif

DBGoTo( rr )
wy := 2

******************************************************************************

procedure PrzelewKonto( bazaz )

local i, w, rr := RecNo(), tab[ FCount()], dt

( bazaz )->( DBGoTop())
if ( bazaz )->( Eof())
   if ( 1 = Alarm( 'Nie zaznaczono §adnych przelew¢w;Zmieni konto ¦r¢d’owe bie§†cego przelewu?', tk ))
      PRZELEW->( Blokuj_R())
      PRZELEW->NAZ11 := ''
      NewSysForm('PRZELEW,Formularz danych,,,,,,,3')
   endif
else
   i := 0
   w := 0
   PRZELEW->( DBSetOrder( 1 ))
   while ( bazaz )->( !Eof())
         if PRZELEW->( DBSeek(( bazaz )->POLE ))
            i ++
            w += KWOTA
         endif
         ( bazaz )->( DBSkip())
   enddo
   if ( 1 = Alarm( 'Zaznaczono ' + AllS( i ) + ' przelew¢w na kwot‘ ' + AllS( w, '999,999,999.99 z’') + ';Zmieni konto ¦r¢d’owe zaznaczonych przelew¢w?', tk ))
      Alarm( 'Zweryfikuj konto ¦r¢d’owe i dat‘ pierwszego przelewu;pozosta’e b‘d† analogiczne' )
      ( bazaz )->( DBGoTop())
      while !( i := PRZELEW->( DBSeek(( bazaz )->POLE )))
            ( bazaz )->( DBSkip())
      enddo
      if i
         PRZELEW->( Blokuj_R())
         PRZELEW->NAZ11 := ''
         if NewSysForm('PRZELEW,Formularz danych pierwszego z zaznaczoncych przelew¢w,,,,,,,3')
            dt := PRZELEW->DATA
            for i := 1 to Len( tab )
                tab[ i ] := PRZELEW->( FieldGet( i ))
            next
            while ( bazaz )->( !Eof())
                  if PRZELEW->( DBSeek(( bazaz )->POLE ))
                     PRZELEW->( Blokuj_R())
                     for i := 2 to 12
                         PRZELEW->( FieldPut( i, tab[ i ]))
                     next
                     PRZELEW->DATA := dt
                  endif
                  ( bazaz )->( DBSkip())
            enddo
         endif
      endif
   endif
endif

DBGoTo( rr )
wy := 2

******************************************************************************

procedure SerPrzelewow( bazaz, wzor )

( bazaz )->( DBGoTop())
if ( bazaz )->( Eof())
   PRZELEW->( Wydruk( wzor,,,,, 1 ))
else
   if wzor = NIL
      wzor := ''
   else
      wzor := "'" + wzor + "'"
   endif
   OperujZnaki("PRZELEW,Mark('PRZELEWZ'%LP%'*'),*,Wydruk("+wzor+"%%%%%0)",,"mOpen(cat_wydr+'przelewy.txt')","Druk(cat_wydr+'przelewy.txt'%1)")
endif

******************************************************************************
* GenPrzelewy('LPLACZ','dowy')
* bazaz - baza znak¢w
* kodz - kod kluczowej pozycji

procedure GenPrzelewy( bazaz, kodz )

local bb, ii, rr, w, i

bb := Alias()
ii := IndexOrd()
rr := RecNo()

if bazaz = NIL; bazaz := 'LPLACZ'; endif
( bazaz )->( DBGoTop())
if ( bazaz )->( Eof())
   if Alarm( 'Brak zaznacze¤ list do generowania.;Czy ma to by generowanie z bie§†cej listy?', tk ) # 1
      return
   endif
   ( bazaz )->( DBAdd())
   ( bazaz )->POLE := LPLAC->ID
endif

ON( 'PRZELEW' ); DBGoBottom()
ON( 'PRZELEWZ',,,,.t.)
ON( 'LPRAC' )
ON( 'LPDPD', 2 )                    && Upper( KOD )

if LPDPD->( DBSeek( Upper( kodz ))) && szukamy kodu zmiennej
   kodz := LPDPD->ID                && wydobycie ID zmiennej (ID_LPDPD)
else
   Alarm( 'Brak definicji zmiennej "' + kodz + '"' )
   Select( bb )
   return
endif

LPLAC->( DBSetOrder( 1 ))
LPLACP->( DBSetOrder( 2 ))       && Str(ID_LPLAC)+Str(ID)
LPLACPP->( DBSetOrder( 2 ))      && Str(ID_LPLAC)+Str(ID_LPLACP)+Str(ID_LPDPD)

i := 0
( bazaz )->( DBGoTop())
while ( bazaz )->( !Eof())
      LPLAC->( DBSeek( ( bazaz )->POLE ))       && lista
      LPLACP->( DBSeek( Str(LPLAC->ID)))        && pozycja
      while LPLACP->ID_LPLAC = LPLAC->ID .and. LPLACP->( !Eof())
            if LPLACPP->( DBSeek( Str(LPLAC->ID)+Str(LPLACP->ID)+Str(LPDPD->ID)))
               w := UT( LPLACPP->WARTOSC )
               if w > 0
                  i ++
                  GenerujPrzelew( w, i )
               endif
            endif
            LPLACP->( DBSkip())
      enddo
      ( bazaz )->( DBSkip())
enddo

if i > 0
   ViewDBF( 'PRZELEW' )
endif

Select( bb )
DBSetOrder( ii )
DBGoTo( rr )
wy := 2

******************************************************************************

procedure GenerujPrzelew( w, i )

PRZELEW->( DBCAppend({ || FillPrzelew( w )}))

if i = 1
   Alarm( 'Zweryfikuj pierwszy przelew,;konto ¦r¢d’owe, data, tytu’ ...;pozosta’e b‘d† analogiczne' )
   PRZELEW->TYT11 := 'P’aca za ' + Nazwa_M( Month( LPLAC->DATA )) + ' ' + Str( Year( LPLAC->DATA ), 4 ) + 'r.'
   PRZELEW->TYT22 := 'Lista Nr ' + LPLAC->NUMER
   PRZELEW->( NewSysForm('PRZELEW,Nowy przelew,,,,,,,2' ))
endif

Mark('PRZELEWZ',PRZELEW->LP)

******************************************************************************

procedure FillPrzelew( w )

LPRAC->( DBSeek( LPLACP->ID_PRAC ))

PRZELEW->LP := PRZELEW->( PopRec('LP')) + 1
PRZELEW->NUMER2 := LPRAC->ID
PRZELEW->SYMBOL2 := ''
PRZELEW->NAZ21 := LPRAC->NAZWA
PRZELEW->NAZ22 := ''
PRZELEW->NAZ23 := ''
PRZELEW->NAZ24 := ''
PRZELEW->BANK21 := LPRAC->US_BANK
PRZELEW->BANK22 := ''
PRZELEW->BANK23 := ''
PRZELEW->RACH21 := Left( LPRAC->US_KONTO, Len( PRZELEW->RACH21 ))
PRZELEW->RACH22 := SubStr( LPRAC->US_KONTO, Len( PRZELEW->RACH21 ) + 1 )
PRZELEW->KWOTA := w

******************************************************************************
