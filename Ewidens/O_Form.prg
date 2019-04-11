*****************************************************************************
*************************   System obs’ugi formularzy  **********************
*****************************************************************************
#include 'Inkey.ch'

procedure Init_SysForm()

public SysForm := 'sys_form'
public SysFormKlip := ''

*****************************************************************************
* To clipboard

procedure ToClip

private a := ReadVar(), bb := Alias()

if Jest_baza( SysForm )
   ( SysForm )->( Blokuj_R())
endif

Jest_baza( bb )

SysFormKlip := &a

*****************************************************************************
* From clipboard

procedure FromClip

private a := ReadVar()

&a := SysFormKlip

*****************************************************************************

procedure MoveSysForm( k )

if !full_dostep; return; endif

( SysForm )->( Blokuj_R())

do case
case k = 1; ( SysForm )->POLE_ROW --
case k = 2; ( SysForm )->POLE_ROW ++
case k = 3; ( SysForm )->POLE_COL --
case k = 4; ( SysForm )->POLE_COL ++
endcase

*****************************************************************************

procedure MoveForm( name, k, koniec )

if !full_dostep; return; endif

if DBSeek( name )
   MoveSysForm( k )
   skip
   MoveSysForm( k )
endif

Keyboard Chr( K_ESC )
koniec := NIL   && §e tu by’

*****************************************************************************

procedure MoveField( name, k, koniec )

local a := Val( SubStr( ReadVar(), 4 )) + 1, parka := .f., rr, n := 0

if !full_dostep; return; endif

if DBSeek( PadR( name, 10 ) + Str( a, 2 ))
   rr := RecNo()
   while PadR( name, 10 ) = FORM_NAME .and. !Bof()
         if Empty( POLE_VAR )
            n ++
         endif
         skip -1
   enddo
   DBGoTo( rr )
   parka := Empty( POLE_NAME )
   if !ReadInsert(); MoveSysForm( k ); endif
endif

if parka
   if DBSeek( PadR( name, 10 ) + Str( a - 1, 2 ))  && tytu’ poprzedzaj†cy te§
      MoveSysForm( k )
   endif
endif

Keyboard Chr( K_ESC ) + Replicate( Chr( K_DOWN ), a - n )
koniec := NIL

*****************************************************************************

procedure MoveFrame( name, k, koniec )

if !full_dostep; return; endif

if DBSeek( name )
   skip
   MoveSysForm( k )   && prawy dolny r¢g ramki
endif

Keyboard Chr( K_ESC )
koniec := NIL

*****************************************************************************

procedure RenForm

local bb := FORM_NAME, lp := POLE_LP, rr := RecNo(), i := 0

while FORM_NAME == bb .and. !Eof()
      i ++
      skip
enddo
skip -1
while FORM_NAME == bb .and. RecNo() # rr .and. !Bof()
      i --
      ( SysForm )->( Blokuj_R())
      ( SysForm )->POLE_LP := lp + i
      skip -1
enddo
wy := 2

******************************************************************************

procedure FormHelp( name )

local czytane := ReadVar()
local a := Val( SubStr( czytane, 4 )) + 1

if DBSeek( PadR( name, 10 ) + Str( a, 2 ))
   if HELP_FUNC = 0; Alarm( AllTrim( HELP_PARA ), Ent )
   else; Eval( SysFunction[ HELP_FUNC ], HELP_PARA )
   endif
endif

ReadVar( czytane )

*****************************************************************************

procedure FormValid( name )

local a, b
private buf_sys := ReadVar()

a := Val( SubStr( buf_sys, 4 )) + 1
buf_sys := RunCommand( buf_sys )

if DBSeek( PadR( name, 10 ) + Str( a, 2 ))
   if VALID_FUNC # 0
      b := Eval( SysFunction[ VALID_FUNC ], VALID_PARA )
   endif
endif

return if( b = NIL, .t., b )

*****************************************************************************
* Nr 4. Wykonanie oblicze¤ w formularzu

procedure ValidWykonaj( a )

local pole
private x := Odetnij( @a ), wyrazenie := a, wynikvalid := .t.

pole := RunCommand( wyrazenie )
if ValType( pole ) == 'C'
   pole := Konwert(pole,maz,lat,.t.)
endif
&x := pole

return wynikvalid

*****************************************************************************
* Nr 41. Wykonanie weryfikacji w formularzu
* vp[4]<=Date,Data p¢¦niejsza ni§ bie§†ca!!!,Show_Dzien(vp[4]), mimo wszystko .t.

procedure ValidSprawdz( a )

private wyrazenie, kom, f_ok, f_ko

wyrazenie := Odetnij( @a )
kom       := Odetnij( @a )
f_ok      := Odetnij( @a )
f_ko      := Odetnij( @a )

if 'Dziwna data' $ kom; return .t.; endif

if RunCommand( wyrazenie )
   RunCommand( f_ok )
   return .t.
else
   Alarm( kom )
   return RunCommand( f_ko )
endif

*****************************************************************************
* zewn - formularz jest wywolywany dla zewnetrznej (innej) bazy danych

function NewSysDopisz( a, dopis, blok, cblok, zewn )

local rrr, rre

if dopis # NIL; blok := { || .t. }; endif    && z kopi† rekordu

rre := RecNo()
DBCAppend( blok )
rrr := RecNo()

if cblok # NIL .and. !Empty( cblok )
   RunCommand( cblok )
endif

if NewSysForm( a )
   if serio
      wy := 2
   if zewn = NIL
      Ch_il( 1 , rr[ 1 ] - 2 )           && Inc( licznik )
      DBGoBottom()
      if rrr = RecNo()
         wy := 1
         Keyboard Chr( K_CTRL_PGDN ) + LastZnak
      else
         DBGoTo( rrr )
         LastZero()
         Keyboard LastZnak
      endif
      LastZnak := ''
   endif
      
if AKT_PO_DOP
   Akt_kontrahenta(1)
endif

      return .t.
   else
      NoChange()
   endif
endif

DBGoTo( rrr )
BDelete()
DBGoTo( rre )

return .f.

*****************************************************************************
* a: nazwa,tytu’,fpre,ppre,fpost,ppost,czyžci,test,polestart
* NoGet: bez kursora, czyli bez "Read()"
* ShowOnly: bez zatrzymania, czyli bez "Inkey( 0 )"
* polenr: "if polenr # NIL; nrpol := RunCommand( polenr ); endif"
* fpostYES: "if wynik; RunCommand( fpostYES ); endif"
*
* Znaki w polu "POLE_VAR":
* = - zmienne      (      show &       get &       write)
* : - wartožci     (      show &       get & don't write)
* @ - pokazywane   (      show & don't get & don't write)
* ? - niewidzialne (don't show & don't get &       write)

function NewSysForm( a, NoGet, ShowOnly, polenr, fpostYES, runvalids )

local bb := Alias(), ii := IndexOrd(), rr := RecNo(), ekran, samdol, nam, ni
local nazwa, tytul, fpre, ppre, fpost, ppost, czyscic, test, i, nrpol, odp
local oF1, o1, o2, o3, o4, o5, o6, o7, o8, o9, oa, ob, oc, oe, od
local move_op, r1, r2, c1, c2, koniec := .f., bezvalids := .f.
local r0 := Row() + if( RecNo() # 1 .and. Right( a, 1 ) == ',', 1, 0 )

private wynik, pola := {}, vp := {}, buf, GetList := {}
private picture_jm  && zabezpieczenie przed star¹ struktur¹

if NoGet = NIL; NoGet := .f.; endif
if ShowOnly = NIL; ShowOnly := .f.; endif
if runvalids = NIL; runvalids := .f.; endif

nazwa   := Odetnij( @a )
tytul   := Odetnij( @a )
fpre    := Val( Odetnij( @a ))   && funkcja pre
ppre    := Odetnij( @a )         && jej par.
fpost   := Val( Odetnij( @a ))   && funkcja post
ppost   := Odetnij( @a )         && jej par.
czyscic := Odetnij( @a )
test    := Odetnij( @a )
nrpol   := Val( Odetnij( @a ))

if polenr # NIL; nrpol := RunCommand( polenr ); endif

if fpre # 0
   Eval( SysFunction[ fpre ], ppre )     && wykonanie funkcji inicjuj†cej
endif

bb := Alias()
ii := IndexOrd()
rr := RecNo()

if NoGet
   ekran  := SaveScreen()
else
   ekran  := SaveScreen( 0, 0, mr - 3, mc )
   samdol := SaveScreen( mr - 2, 0, mr, mc )
endif

odp := if( !Empty( test ) .and. ( Alarm( 'Dopasowa wst‘pnie ?', nt ) = 2 ), 2, 1 )

while !koniec

ON( SysForm )

if !DBSeek( nazwa )
   Zwolnij( SysForm )
else
   r1 := POLE_ROW
   c1 := POLE_COL
   skip
   r2 := POLE_ROW
   c2 := POLE_COL
   skip
   if Empty( czyscic )
      if Empty( tytul )
         @ mr, 0 clear
      else
         @ r1, c1 clear to r2, c2
*         @ mr - 2, 0 clear
         @ mr, 0 clear
      endif
   else
      @ 2, 0 clear
   endif

if Empty( tytul )
   @ mr, 0 say Konwert("Esc-wyjžcie, Enter-wprowadzenie wartožci pola",maz,lat,.t.) //, PgDn-pole ni§ej, PgUp-pole wy§ej
else
   RRamka({ r1, r2 }, { c1, c2 })
   CSay( r1 - 1, c1, c2, tytul, jasny )
   if NoGet
      Esc( 1 )
   else
      CSay( r2 - 1, c1, c2, 'F1 - pomoc', jasny )
      Esc( 1 )
      PgDn( 1 )
   endif
endif

endif

ni := 0
i := 0
pola := {}
vp := {}
while AllTrim( FORM_NAME ) == AllTrim( nazwa ) .and. !Eof()
      i ++
      buf := RTrim( POLE_VAR )
      Aadd( pola, buf )
      if Left( buf, 1 ) $ ':=@?'     && ? -> nie wyžwietla, ale jest
         buf := SubStr( buf, 2 )     && zmienne : "=zmienna" i wartosci ":wa"
         if Left( buf, 1 ) $ ':=@?'  && ? -> nie wyžwietla, ale jest
            buf := SubStr( buf, 2 )  && zmienne : "=zmienna" i wartosci ":wa"
         endif
      endif
      ( bb )->( Aadd( vp, if( Empty( buf ), '', &buf )))
      if ValType( vp[len(vp)] ) == 'C'
         vp[len(vp)] := Konwert(vp[len(vp)],maz,lat,.t.)
      endif
      if odp = 2
         ( SysForm)->( Blokuj_R())
         if i + r1 < r2
            ( SysForm)->POLE_ROW := i
            ( SysForm)->POLE_COL := 1
            ( SysForm)->( OdBlokuj_R())
         else
            ( SysForm)->POLE_ROW := i + r1 - r2
            ( SysForm)->POLE_COL := 50
            ( SysForm)->( OdBlokuj_R())
         endif
      endif
   if Empty( tytul )
      if Empty( buf )        && napisy
         @ if( POLE_ROW < 0, r0, r1 + POLE_ROW ), c1 + POLE_COL say Konwert(RTrim( POLE_NAME ),maz,lat,.t.)
      elseif Left( POLE_VAR, 1 ) == '?'
      elseif Left( POLE_VAR, 1 ) == '@'
         @ if( POLE_ROW < 0, r0, r1 + POLE_ROW ), c1 + POLE_COL say Konwert(RTrim( POLE_NAME ),maz,lat,.t.) + ' ' + vp[ i ]
      elseif Empty( POLE_PIC )
         ni ++
         nam := POLE_NAME
         nam := RTrim( nam )
         if ';' $ nam; nrpol := ni; nam := StrTran( nam, ';', ':' ); endif
         @ if( POLE_ROW < 0, r0, r1 + POLE_ROW ), c1 + POLE_COL say Konwert(nam,maz,lat,.t.);
                                        get vp[ i ];
                                        valid FormValid( nazwa )
      else
         ni ++
         nam := POLE_NAME
         nam := RTrim( nam )
         if ';' $ nam; nrpol := ni; nam := StrTran( nam, ';', ':' ); endif
         @ if( POLE_ROW < 0, r0, r1 + POLE_ROW ), c1 + POLE_COL say Konwert(nam,maz,lat,.t.);
                                        get vp[ i ];
                                        picture AllTrim( POLE_PIC );
                                        valid FormValid( nazwa )
      endif
   else
      if Empty( buf )
         @ r1 + POLE_ROW, c1 + POLE_COL say Konwert(RTrim( POLE_NAME ),maz,lat,.t.)  && napisy
      elseif Left( POLE_VAR, 1 ) == '?'
      elseif Left( POLE_VAR, 1 ) == '@'
			if ValType( vp[ i ]) == 'C'
				@ r1 + POLE_ROW, c1 + POLE_COL say Konwert(RTrim( POLE_NAME ),maz,lat,.t.) + ' ' + vp[ i ]
			else
				@ r1 + POLE_ROW, c1 + POLE_COL say Konwert(RTrim( POLE_NAME ),maz,lat,.t.) + ' ' + Transform( vp[ i ], POLE_PIC )
			endif
		   if ( VALID_FUNC # 0 ) .and. !( Left( VALID_PARA, 2 ) == 'vp' )
		      Eval( SysFunction[ VALID_FUNC ], VALID_PARA )
		   endif
      elseif Empty( POLE_PIC )
         ni ++
         nam := POLE_NAME
         nam := RTrim( nam )
         if ';' $ nam; nrpol := ni; nam := StrTran( nam, ';', ':' ); endif
         @ r1 + POLE_ROW, c1 + POLE_COL say Konwert(nam,maz,lat,.t.);
                                        get vp[ i ];
                                        valid FormValid( nazwa )
      else
         ni ++
         nam := POLE_NAME
         nam := RTrim( nam )
         if ';' $ nam; nrpol := ni; nam := StrTran( nam, ';', ':' ); endif
			if '?' $ POLE_PIC
   	      @ r1 + POLE_ROW, c1 + POLE_COL say Konwert(nam,maz,lat,.t.);
                                        get vp[ i ];
                                        picture StrTran( AllTrim( POLE_PIC ), '?', '.' );
                                        valid FormValid( nazwa )
				SetColor( 'W/B' )
      	   @ r1 + POLE_ROW, c1 + POLE_COL + Len( nam ) + 1 say Konwert(Tra( vp[ i ], AllTrim( POLE_PIC )),maz,lat,.t.)
				SetColor( STC )
*				if runvalids;
*					.or.;
*					( 'Print' $ VALID_PARA );
*					.or.;
*					( 'Show' $ VALID_PARA )
*					if runvalids 
*						bezvalids := .t.		&& nie uruchamiaj póŸniej validów
*					endif
*				   if VALID_FUNC # 0
*				      Eval( SysFunction[ VALID_FUNC ], VALID_PARA )
*				   endif
*				endif
			else
   	      @ r1 + POLE_ROW, c1 + POLE_COL say Konwert(nam,maz,lat,.t.);
                                        get vp[ i ];
                                        picture AllTrim( POLE_PIC );
                                        valid FormValid( nazwa )
			endif
      endif
   endif
	RunCommand( picture_jm )
   skip
enddo
         koniec := .f.
         move_op := .f.

if !Empty( test )
         o1 := SetKey( K_CTRL_UP,   { || MoveForm( nazwa, 1, @koniec )})
         o2 := SetKey( K_CTRL_DOWN, { || MoveForm( nazwa, 2, @koniec )})
         o3 := SetKey( K_CTRL_LEFT, { || MoveForm( nazwa, 3, @koniec )})
         o4 := SetKey( K_CTRL_RIGHT,{ || MoveForm( nazwa, 4, @koniec )})
         o5 := SetKey( K_ALT_UP,    { || MoveField( nazwa, 1, @koniec )})
         o6 := SetKey( K_ALT_DOWN,  { || MoveField( nazwa, 2, @koniec )})
         o7 := SetKey( K_ALT_LEFT,  { || MoveField( nazwa, 3, @koniec )})
         o8 := SetKey( K_ALT_RIGHT, { || MoveField( nazwa, 4, @koniec )})
         o9 := SetKey( K_CTRL_PGUP, { || MoveFrame( nazwa, 1, @koniec )})
         oa := SetKey( K_CTRL_PGDN, { || MoveFrame( nazwa, 2, @koniec )})
         ob := SetKey( K_CTRL_HOME, { || MoveFrame( nazwa, 3, @koniec )})
         oc := SetKey( K_CTRL_END,  { || MoveFrame( nazwa, 4, @koniec )})
endif

         od := SetKey( K_CTRL_INS,  { || ToClip()})
         oe := SetKey( K_ALT_INS,   { || FromClip()})
         oF1:= SetKey( K_F1,        { || FormHelp( nazwa )})

wynik := .f.
if NoGet
   if runvalids .and. !bezvalids
      Keyboard Replicate( Chr( K_DOWN ), Len( GetList )) + Chr( K_ENTER )
      Read( .t. )
   endif
   if !ShowOnly; Inkey( 0 ); endif
   koniec := koniec # NIL
else
   if nrpol > 1; Keyboard Replicate( Chr( K_DOWN ), nrpol - 1 ); endif
   if nrpol < 0; Keyboard Replicate( Chr( K_DOWN ), -nrpol - 1 ) + Chr( K_RIGHT ) + Chr( K_LEFT ); endif
   if Read( .t. )
      wynik := .t.
      koniec := .t.
      zmiana := .t.
      Select( bb )
      if Eof() .or. LastRec() = 0         && Bof()
         DBSkip(-1)                       && gdy stoi za ostatnim, to si‘ cofa
         if Bof(); DBSkip( 1); endif      && gdy stoi przed pierwszym, to krok
      endif
      if Eof(); DBAdd(); endif
      Blokuj_R()
*
* Znaki w polu "POLE_VAR":
* = - zmienne      (      show &       get &       write)
* : - wartožci     (      show &       get & don't write)
* @ - pokazywane   (      show & don't get & don't write)
* ? - niewidzialne (don't show & don't get &       write)

      for i := 1 to Len( vp )
          if Empty( pola[ i ]); loop
          elseif Left( pola[ i ], 1 ) == '@'; loop
          elseif Left( pola[ i ], 1 ) == '='
             buf := SubStr( pola[ i ], 2 )     &&  zmienne : "=zmienna"
             &buf := vp[ i ]
          else
             if serio
                buf := pola[ i ]                     && pola baz : "pole_bazy"
                if Left( buf, 1 ) == '?'
                   buf := SubStr( pola[ i ], 2 )     && pole niewidzialne
                   pola[ i ] := buf                  && "?:" -> ":"
                endif
                if !( '->' $ buf )
                   buf := bb + '->' + buf            && pola baz : "pole_bazy"
                endif
                if Left( pola[ i ], 1 ) == '='
                   buf := SubStr( pola[ i ], 2 )     &&  zmienne : "=zmienna"
                   &buf := vp[ i ]
                elseif Left( pola[ i ], 1 ) # ':'
                     if ValType( vp[i] ) == 'C'
                        vp[i] := Konwert(vp[i],lat,maz,.t.)
                     endif
                   &buf := vp[ i ]
                endif
             endif
          endif
      next
      Odblokuj_R()
   else
      koniec := koniec # NIL
   endif
endif

if !Empty( test )
         SetKey( K_CTRL_UP,    o1 )
         SetKey( K_CTRL_DOWN,  o2 )
         SetKey( K_CTRL_LEFT,  o3 )
         SetKey( K_CTRL_RIGHT, o4 )
         SetKey( K_ALT_UP,     o5 )
         SetKey( K_ALT_DOWN,   o6 )
         SetKey( K_ALT_LEFT,   o7 )
         SetKey( K_ALT_RIGHT,  o8 )
         SetKey( K_CTRL_PGUP,  o9 )
         SetKey( K_CTRL_PGDN,  oa )
         SetKey( K_CTRL_HOME,  ob )
         SetKey( K_CTRL_END,   oc )
endif

         SetKey( K_CTRL_INS,   od )
         SetKey( K_ALT_INS,    oe )
         SetKey( K_F1,         oF1 )

if !NoGet; RestScreen( 0, 0, mr - 3, mc, ekran ); endif

enddo

if NoGet
   if !ShowOnly; RestScreen( ,,,, ekran ); endif
else;     RestScreen( mr - 2, 0, mr, mc, samdol )
endif

Select( bb )
DBSetOrder( ii )
DBGo( rr )

if fpost # 0
*   Blokuj_R()
   Eval( SysFunction[ fpost ], ppost )     && wykonanie funkcji ko¤cz†cej
*   OdBlokuj_R()
endif

if AKT_PO_FOR .and. wynik
   Akt_kontrahenta()
endif

if wynik
   DBCommit()                 && ka§dy zmieniony formularz zapisz na dysk
   RunCommand( fpostYES )
endif

return wynik

*****************************************************************************

procedure KopiaForm( a )

local bb := FORM_NAME, cat, ali, newname

if !full_dostep; return; endif

cat := Odetnij( @a )
ali := Odetnij( @a )

newname := bb
newname := Get_U( 10, 10, 'Podaj now† nazw‘ :', Replicate( 'X', Len( newname )), newname )
if newname = NIL .or. newname = bb; return; endif

ON( SysForm,, cat, ali )
ON( SysForm,, cat, ali, .t. )
KopiaRec( SysForm, ali, { || bb == FORM_NAME })

Select( ali )
DBSetOrder( 0 )
go top
while !Eof(); ( ali )->FORM_NAME := newname; skip; enddo
go top
KopiaRec( ali, SysForm )
Zwolnij( ali )

Select( SysForm )
wy := 2

*****************************************************************************

procedure UsunForm( a )

local fn := FORM_NAME

if !full_dostep; return; endif

if Alarm( a + ' "' + fn + '" ?', tk ) = 1
   DBSetOrder( 1 )
   DBSeek( fn )
   while fn == FORM_NAME .and. !Eof(); BDelete(); DBSkip(); enddo
endif

*****************************************************************************

function Pokaz_Logic( a )       && 87
private i := ReadVar()
?? ' ' + if( &i, 'TAK', 'nie' )
return .t.

*******************************************************************************
* Nr 38. a = 'len'
* np.: x = 'globalbuf'

procedure Show_Dzien( a, x )

private kod := if( x = NIL, ReadVar(), x )
if !Empty( &kod )
	klucz := CDoW( &kod - 1 )
	?? ' ' + PadR( klucz, Val( a ))
endif

******************************************************************************
* a = 'baza, len, pole, indeks, komunikat zabronienia, wartož pola zast‘pcza,;
*      pole wpisu, pole pobrania'
* bez - wartož pola, kt¢ra zwraca spacje
* cc - przesuniêcie w prawo od bie¿¹cej pozycji kursora o cc spacji

function Show_Nazwa( a, bez, cc )

local baza, bb, ii, ll, r := Row(), c := Col(), klucz, kom, war, pow, pob

private kod := ReadVar(), pole, buf

baza := Odetnij( @a )
ll := Val( Odetnij( @a ))
if cc = NIL; cc := 0; endif

pole := Odetnij( @a )
pole := if( Empty( pole ), 'NAZWA', pole )

ii := Odetnij( @a )
ii := if( Empty( ii ), 2, Val( ii ))

kom:= Odetnij( @a )
war:= Odetnij( @a )
pow:= Odetnij( @a )
pob:= Odetnij( @a )

if !Empty( kod )
	klucz := &kod
else
	klucz := &kom		&& klucz w komunikacie zabronienia
	kom := ''
endif

bb := Alias()

if bez # NIL .and. klucz = bez
   ii := .t.
   MemVar->kod := Space( ll )
else
   ON( baza, ii ); ii := .t.
   if DBSeek( klucz ); MemVar->kod := ( baza )->( &pole )
   elseif ValType( klucz ) == 'C'
      klucz := PadL( AllTrim( klucz ), Len( klucz ))   && pr¢ba zmiany klucza
      if DBSeek( klucz )
         &kod := klucz
         kod := ( baza )->&pole
      else; ii := .f.
      endif
   else; ii := .f.
   endif
endif

if ii
   if !Empty( pob ) .and. !Empty( pow )
      buf := pob
      pole := pow
      &pole := &buf
   endif
else
   kod := 'brak danych ...'   && komunikat zast‘pczy
   ii := .t.
   if !Empty( kom )
      Alarm( kom )
      if !Empty( war )        && jest co wstawi zast‘pczo
         pole := ReadVar()
         buf := war
         &pole := &buf
      endif
   endif
endif
@ r, c + cc say ' ' + PadR( MemVar->kod, ll )
Select( bb )

return ii

******************************************************************************
* Nr 34
* a = empty => Init : KOD_WEW, LP, DATA
* a # empty => Init : KOD_WEW, LP

procedure Init_DBF_Main( a )

if Empty( a )
   replace KOD_WEW with PadL( Val( GetLast( 1, 2 )) + 1, Len( KOD_WEW )),;
           LP with PadL( Val( GetLast( 2, 1 )) + 1, Len( LP )),;
           DATA with Datee()
else
   replace KOD_WEW with PadL( Val( GetLast( 1, 2 )) + 1, Len( KOD_WEW )),;
           LP with PadL( Val( GetLast( 2, 1 )) + 1, Len( LP ))
endif

******************************************************************************
* Nr 58
* a = pole "MAIN->KOD_WEW"

procedure Init_DBF_Sub( a )

private pole := AllTrim( a )

replace KOD_WEW with &pole,;
        LP with PadL( Val( GetLast( 2, 1 )) + 1, Len( LP )),;
        DATA with Datee()

******************************************************************************
* Nr 16
* a = delta( INC( LP ))

procedure Init_LPiDATA( a )

replace LP with PadL( Val( GetLast( 1, 1 )) + Val( Odetnij( a )), Len( LP )),;
        DATA with Datee()

******************************************************************************
* Put Last ID

procedure PLID( x )

MemoWrit( Alias() + '.LID', AllS( x ))

******************************************************************************
* nrf - numer zwracanego pola
* nri - numer stosowanego indeksu
* zfi - z filtrem
* war - warunek uznania
* warcopy - wariant funkcji Copy, gdzie trzeba pomin¹æ ten na którym stoi

function GetLast( nrf, nri, zfi, war, warcopy )

local bb, ii, rr, ww, i, x, r

nrf := if( nrf = NIL, 1, nrf )
nri := if( nri = NIL, 1, nri )

rr := RecNo()
ii := IndexOrd()

if File( Alias() + '.LID' )							&& Last ID zapamiêtany w pliku
	if zfi = NIL
	   filtr := DBFilter()
   	set filter to
	endif
	ww := Val( MemoRead( Alias() + '.LID' ))
	DBSetOrder( nri )
	DBGoBottom()
	ww := Max( ww, FieldGet( nrf ))
	if zfi = NIL
	   set filter to &filtr
	endif
	DBGoTo( rr )
	DBSetOrder( ii )
   return ww
endif

*bb := Alias()

if zfi = NIL
   filtr := DBFilter()
   set filter to
endif

DBSetOrder( nri )
go bottom

if war # NIL
	if warcopy # NIL
			DBSkip( -1 )
	endif
	while !( &war ) .and. !Bof()
			DBSkip( -1 )
	enddo
endif

ww := FieldGet( nrf )

if ( nrf = 1 ) .and. ( Alias() == 'DOKUM' ) .and. ( LastRec() > 20 )
	DBSetOrder( 0 )
	DBGoBottom()
	r := RecNo()
	for i := 1 to 25
		skip -1
		if r # RecNo()			&& ruszy³ siê choæ o 1 rekord po skip -1
			nrf++					&& faktycznie jest normalny rekord
			r := RecNo()
		endif
	next
if nrf > 20						&& faktycznie nieskasowanych rekordów jest > 20
	DBSetOrder( 0 )
	DBGoBottom()
	if RecNo() = rr; skip -1; endif
	x := FieldGet( 1 )
	r := RecNo()
	skip -1
	for i := 1 to 10
		if ( x <= FieldGet( 1 )) .or. ( ww < x )
			cls
			DBGoBottom()
			? FieldGet( 1 ), '=', ww + 1
			DBSkip( -1 )
			for i := 1 to 10
				? FieldGet( 1 )
				DBSkip( -1 )
			next
			Alarm( 'UWAGA: Wykryto uszkodzenie indeksów bazy danych !!!;Wymagana natychmiastowa reindeksacja;Jeœli problem bêdzie siê powtarza³;skontaktuj siê z autorem (tel. 0660-736-575)',, 1 )
			exit
		endif
		x := FieldGet( 1 )
		skip -1
	next
endif
endif

if zfi = NIL
   set filter to &filtr
endif

*Select( bb )
DBGoTo( rr )
DBSetOrder( ii )

return ww

******************************************************************************
* sPole  - szukane i inkrementowane pole (NUMER, INDEKS, LP, ID ... )
* sPole1 - nazwa pola por¢wnywanego 1
* nPole1 - wartož pola por¢wnywanego 1
* sPole2 - nazwa pola por¢wnywanego 2
* nPole2 - wartož pola por¢wnywanego 2

function GetThis( sPole, sPole1, nPole1, sPole2, nPole2 )

local bb, ii, rr, ww, ll

*bb := Alias()
rr := RecNo()
ii := IndexOrd()
filtr := DBFilter()
set filter to

ww := &sPole
ll := Len( ww )
ww := Space( ll )
DBSkip( -1 )
while !Bof()
      if &sPole1 = nPole1 .and. &sPole2 = nPole2
         ww := &sPole
         exit
      endif
      DBSkip( -1 )
enddo

ww := PadR( AllS( Val( ww ) + 1 ), ll )

set filter to &filtr
*Select( bb )
DBGoTo( rr )
DBSetOrder( ii )

return ww

******************************************************************************
procedure NoChange()
Alarm( 'Ta wersja programu nie pozwala nic zmienia !' )
******************************************************************************

procedure SysForm_W( wzor )

local n := FORM_NAME, re := RecNo()
W_DBEdit( wzor,,, { || FORM_NAME == n })
go re

******************************************************************************
* mode = NIL - formularz
* mode # NIL - dopisanie

procedure Akt_kontrahenta( mode )

local bb := Alias()
local pop_akt1 := AKT_PO_FOR
local pop_akt2 := AKT_PO_DOP

private baza := bb

AKT_PO_FOR := .f.
AKT_PO_DOP := .f.

if bb == 'FIRMY'
   ON( 'KNORDPOL' )
   baza := Alias()
   if mode # NIL
      DBAppend()
      KNORDPOL->NUMER:=if(GetLast(15,5)<99999,GetLast(15,5)+1,0)
   endif
   KNORDPOL->( Blokuj_R())
   KNORDPOL->KONTO := FIRMY->KONTO
   KNORDPOL->TRESC := FIRMY->( AllTrim( NAZWA1 ) + ' ' + AllTrim( NAZWA2 ) + ' '  + AllTrim( NAZWA3 ))
   KNORDPOL->PSEUDO := FIRMY->INDEKS
   KNORDPOL->NAZWA := KNORDPOL->TRESC
   KNORDPOL->NIP := FIRMY->NIP
   KNORDPOL->BANK := FIRMY->BANK
   KNORDPOL->RACH := FIRMY->RACH
*   KNORDPOL->BRANZA := 
*   KNORDPOL->SKR_POCZT := 
   KNORDPOL->ULICA := FIRMY->( FieldGet( 9 ))   && ULICA / ADRES
*   KNORDPOL->KRAJ := 
   KNORDPOL->KOD_POCZT := FIRMY->KOD
   KNORDPOL->MIASTO := FIRMY->MIASTO

   NewSysForm("KNORDPOL,Dane konta")
   KNORDPOL->( Blokuj_R())
   FIRMY->( Blokuj_R())
   FIRMY->NUMER := KNORDPOL->NUMER
   FIRMY->KONTO := KNORDPOL->KONTO
   Select( bb )
elseif bb == 'KNORDPOL' .and. !Empty( KNORDPOL->NAZWA )
   ON( 'FIRMY' )
   baza := Alias()
   FIRMY->( Blokuj_R())
   if mode # NIL
      DBAppend()
      FIRMY->ID_F:=GetLast(1,1)+1
   endif
*   FIRMY->TYP := 
   FIRMY->NUMER := KNORDPOL->NUMER
   FIRMY->KONTO := KNORDPOL->KONTO
   FIRMY->INDEKS := KNORDPOL->PSEUDO
   FIRMY->NAZWA1 := Left( KNORDPOL->NAZWA, 50 )
   FIRMY->NAZWA2 := SubStr( KNORDPOL->NAZWA, 51, 50 )
   FIRMY->NAZWA3 := SubStr( KNORDPOL->NAZWA, 101, 50 )
   FIRMY->KOD := KNORDPOL->KOD_POCZT
   FIRMY->MIASTO := KNORDPOL->MIASTO
   FIRMY->ULICA := KNORDPOL->ULICA
*   FIRMY->TELEFON := 
*   FIRMY->OSOBA := 
   FIRMY->NIP := KNORDPOL->NIP
*   FIRMY->REGON := 
   FIRMY->BANK := KNORDPOL->BANK
   FIRMY->RACH := KNORDPOL->RACH
   NewSysForm('FIRMY,Dane bie§†cej pozycji')
   FIRMY->( OdBlokuj_R())
   Select( bb )
endif

AKT_PO_FOR := pop_akt1
AKT_PO_DOP := pop_akt2

*****************************************************************************
* bada czy zmienna jest tekstowa i zwraca .t. gdy Upper() = "T"

function TAK( a )

if ValType( a ) == "C" .and. Upper( AllTrim( Left( a, 1 ))) == "T"
   return .t.
endif

return .f.

******************************************************************************

function NextNr( nr )

local pre, vnr, snr, pra

nr := AllTrim( nr )                 && RK 1/2000

pre := ''
while !IsDigit( Left( nr, 1 ))
      pre += Left( nr, 1 )          && przedrostek 'RK'
      nr := SubStr( nr, 2 )         && reszta
      if Empty( nr ); exit; endif
enddo

vnr := Val( nr )
snr := AllS( vnr )                  && numer liczbowy stringowo
pra := SubStr( nr, Len( snr ) + 1 )
vnr := Val( nr ) + 1
snr := AllS( vnr )                  && numer liczbowy stringowo
nr := pre + snr + pra

return nr

******************************************************************************
