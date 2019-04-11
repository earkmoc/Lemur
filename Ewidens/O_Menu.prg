*****************************************************************************
****************************    SYSTEM   MENU   *****************************
*****************************************************************************
#include 'Inkey.ch'
#include 'Box.ch'
 
******************************************************************************

function Init_SysMenu

public SysMenu := 'sys_menu'   && baza danych

******************************************************************************

procedure SysMenuFillForm

( SysMenu )->LP_OPCJI ++
( SysMenu )->N_OPCJI := ''
( SysMenu )->R_OPCJI ++
( SysMenu )->F_SYSTEMU := 0
( SysMenu )->P_SYSTEMU := ''

******************************************************************************
* Uruchamia tylko przy przegl†daniu "SysMenu"

procedure SysMenuRozsun

local rr := RecNo(), kk := Kod_menu, r1, r2

if !full_dostep; return; endif

DBSetOrder( 1 )
DBSeek( Str( kk + 1, 2 ), .t. )
DBSkip( -1 )
while rr # RecNo() .and. kk = Kod_menu .and. !Bof()
		r2 := RecNo()
      DBSkip( -1 )
		r1 := RecNo()
		DBGoTo( r2 )
      ( SysMenu )->( Blokuj_R())
      ( SysMenu )->Lp_opcji ++
      ( SysMenu )->R_opcji ++
      ( SysMenu )->( OdBlokuj_R())
		DBGoTo( r1 )
enddo

wy := 2
DBGo( rr )

******************************************************************************
* Nr 33

procedure SysMenuZmiana

local rr := RecNo(), kk := Kod_menu, nk, nr

if !full_dostep; return; endif

if ( nk := Get_U( 10, 10, 'Podaj nowy KOD MENU :',, kk )) = NIL; return; endif

DBSetOrder( 1 )
DBSeek( Str( kk, 2 ), .t. )
while kk = Kod_menu .and. !Eof()
      DBSkip( 1 ); nr := RecNo()
      DBSkip(-1 )
      ( SysMenu )->( Blokuj_R())
      ( SysMenu )->Kod_menu := nk
      ( SysMenu )->( OdBlokuj_R())
      go nr
enddo

wy := 2
DBGo( rr )

******************************************************************************
* Uruchamia tylko przy przegl†daniu "SysMenu"

procedure SysMenuDopisz( a )

if !full_dostep; return; endif

SysMenuRozsun()
KopiujRec( SysMenu, SysMenu )
( SysMenu )->Lp_opcji ++
( SysMenu )->R_opcji ++
wy := 2

******************************************************************************
* Uruchamia tylko przy przegl†daniu "SysMenu"

procedure SysMenuUsun( a )

local rr := RecNo(), kk := Kod_menu

if !full_dostep; return; endif

private zmiana := .f.

Kasuj( a )

if zmiana
   while kk = Kod_menu .and. !Eof()
         ( SysMenu )->( Blokuj_R())
         ( SysMenu )->Lp_opcji --
         ( SysMenu )->R_opcji --
         DBSkip()
   enddo
endif

wy := 2
DBGo( rr )
skip 0

******************************************************************************

procedure SysMenuHelpNazwa( h )

local oo := 0
local tt := { 'Ä', 'ÉÍ»º¼ÍÈº', 'ÚÄ¿³ÙÄÀ³', 'ÖÄ·º½ÄÓº', 'ÕÍ¸³¾ÍÔ³' }

if !full_dostep; return; endif

private bb := ReadVar()
             
if ( oo := Alarm( AllTrim( h ), tt )) # 0
   &bb := tt[ oo ]
endif

******************************************************************************
* bezfun = bez funkcji na dole ekranu, czyli czyžci @ mr, 0 clear to mr, mc

procedure RunMenu( menu, test, zamykanie, wyjscie, tytul, bezfun )

local o0, o1, o2, o3, o4, o5, o6, o7, o8, o9, o10
local r1, c1, r2, c2, bbr, md, t, i, ramka, odp, ekran, auto, koniec, first
local rr1, cc1, rr2, cc2, rm
local funkcja, parametr, bb, rr

if zamykanie # NIL
   bb := Alias()
   rr := RecNo()
endif

private move_op, move_opkier, move_r, move_l

if menu = NIL; menu := ( SysMenu )->KOD_MENU; endif
if test = NIL; test := .f.; endif
if Empty( wyjscie ); wyjscie := NIL; endif

if menu < 0
   if !full_dostep; return; endif
   menu := -menu
endif

ON( SysMenu )

first := .t.
koniec := .f.
if DBSeek( Str( menu, 2 ))
   while !koniec
         On( SysMenu )
         if DBSeek( Str( menu, 2 ) + ' 0' )  && lewy g¢rny r¢g ramki
            r1 := R_OPCJI
            c1 := C_OPCJI
            t := AllTrim( N_OPCJI )
            ramka := .t.
         else             && bez ramki
            r1 := 0
            c1 := 0
            rr1 := r1
            cc1 := c1
            t := ''
            ramka := .f.
         endif

         if ramka .and. test
            auto := ( Alarm( 'Automat ustawiania wierszy opcji ?', nt ) = 2 )
            if auto; wy := 2; endif
            test := .f.
            cls
         else
            auto := .f.
         endif

         if !DBSeek( Str( menu, 2 )); Alarm( 'Brak menu o kodzie :' + Str( menu, 2 ))
         else
            if ramka; DBSkip(); endif    && mija lini‘ definicji ramki
         endif

      if ramka

         bbr := RecNo()
         md := 0
         i := 0
         while KOD_MENU == menu .and. !Eof()
               if !EnvOK( V_systemu ); skip; loop; endif
               i++
               if auto
                  ( SysMenu )->R_OPCJI := r1 + i
                  ( SysMenu )->C_OPCJI := c1 + 1
               endif
               md := Max( md, Len( AllTrim( N_OPCJI )))
               skip
         enddo

         r2 := r1 + i + 1
         c2 := c1 + md + 3

         if tytul # NIL
            rr1 := r1 - 4
            rr2 := r2 + 2
            cc1 := c1 - 6
            cc2 := c2 + 6
         else
            rr1 := r1
            rr2 := r2
            cc1 := c1
            cc2 := c2
         endif

         if first
            first := .f.
            ekran := SaveScreen( rr1, cc1, rr2, cc2 )
         endif

         if tytul # NIL
            @ rr1, cc1, rr2, cc2 box B_SINGLE + ' '
            CSay( r1 - 2, c1, c2, tytul, jasny )
         endif

         @ r1, c1, r2, c2 box t

         go bbr

      endif

         funkcja := {}
         parametr := {}
         rm := r1
         while KOD_MENU == menu .and. !Eof()
               if !EnvOK( V_systemu ); skip; loop; endif
               rm ++
               if Left( N_OPCJI, 1 ) == 'Ä'
                  @ if( menu = 0, R_OPCJI, rm ), c1 + 1 say Replicate( 'Ä', c2 - c1 - 1 )
               else
                  Aadd( funkcja, F_SYSTEMU )
                  Aadd( parametr, if( IsDigit( P_SYSTEMU ) .or.;
                                    ( Left( P_SYSTEMU, 1 ) == '-' ),;
                                      Val( P_SYSTEMU ),;
                                      AllTrim( P_SYSTEMU )))
                if audyt .and. menu = 0 .and. F_SYSTEMU = 2 .and. !full_dostep
                   exit
                else
                  if ramka; @ if( menu = 0, R_OPCJI, rm ), C_OPCJI prompt ' ' + PadR( N_OPCJI, md ) + ' '
                  else;     @ if( menu = 0, R_OPCJI, rm ), C_OPCJI prompt ' ' + AllTrim( N_OPCJI ) + ' '
                  endif
                endif
               endif
               skip
         enddo

         koniec := .f.
         move_r := .f.
         move_l := .f.
         move_op := .f.

      if menu = 0
         o0 := SetKey( K_DOWN, { || if( menu = 0, LastZero( K_ENTER ),)})
      endif

      if menu = 0 .and. F_SYSTEMU = 2 .and. !full_dostep
         odp := 1
      else
         o1 := SetKey( K_CTRL_UP,   { || MoveMenu( menu, 1, @koniec )})
         o2 := SetKey( K_CTRL_DOWN, { || MoveMenu( menu, 2, @koniec )})
         o3 := SetKey( K_CTRL_LEFT, { || MoveMenu( menu, 3, @koniec )})
         o4 := SetKey( K_CTRL_RIGHT,{ || MoveMenu( menu, 4, @koniec )})
         o5 := SetKey( K_ALT_UP,    { || MoveOption( 1 )})
         o6 := SetKey( K_ALT_DOWN,  { || MoveOption( 2 )})
         o7 := SetKey( K_ALT_LEFT,  { || MoveOption( 3 )})
         o8 := SetKey( K_ALT_RIGHT, { || MoveOption( 4 )})
         if menu # 0
            o9 := SetKey( K_RIGHT,  { || MoveOption( 5 )})
            o10:= SetKey( K_LEFT,   { || MoveOption( 6 )})
         endif

         if zamykanie = NIL .or. bezfun # NIL
            if bezfun # NIL
               bezfun := SaveScreen( mr, 0, mr, mc )
               @ mr, 0 clear to mr, mc
            endif
            Esc()
            Choice()
         endif

         MENU to odp

        if bezfun # NIL
           RestScreen( mr, 0, mr, mc, bezfun )
        endif

      if menu = 0
         SetKey( K_DOWN,       o0 )
      endif
         SetKey( K_CTRL_UP,    o1 )
         SetKey( K_CTRL_DOWN,  o2 )
         SetKey( K_CTRL_LEFT,  o3 )
         SetKey( K_CTRL_RIGHT, o4 )
         SetKey( K_ALT_UP,     o5 )
         SetKey( K_ALT_DOWN,   o6 )
         SetKey( K_ALT_LEFT,   o7 )
         SetKey( K_ALT_RIGHT,  o8 )
         if menu # 0
            SetKey( K_RIGHT,   o9 )
            SetKey( K_LEFT,    o10)
         endif

         if     move_r; Keyboard Chr( K_RIGHT ) &&+ Chr( K_ENTER )
         elseif move_l; Keyboard Chr( K_LEFT )  &&+ Chr( K_ENTER )
         endif

      endif   && if menu = 0 .and. F_SYSTEMU = 2 .and. !full_dostep

         if move_op
            OptionNr( menu, odp, move_opkier )
            koniec := .f.
         elseif koniec = NIL; koniec := .f.
         elseif odp = 0; koniec := .t.
         elseif odp # 0 .and. funkcja[ odp ] # 0
            DBSeek( Str( menu, 2 ) + Str( odp, 2 ))
            OpcLastName := N_OPCJI
            Eval( SysFunction[ funkcja[ odp ]], parametr[ odp ])
            if ( zamykanie = NIL );
               .and.;
               ( funkcja[ odp ] # 1 ) && nie chodzi o wyjžcie z menu (lewo,pra)
               Pozamykaj()
            endif
         endif

         DatyCzas()

         if wyjscie # NIL; exit; endif

   enddo
endif

RestScreen( rr1, cc1, rr2, cc2, ekran )

DatyCzas()

if zamykanie # NIL
   if Jest_baza( bb ); DBGo( rr ); endif
endif

******************************************************************************

procedure MoveMenu( menu, k, koniec )

if !full_dostep; return; endif

DBSeek( Str( menu, 2 ))
while KOD_MENU == menu .and. !Eof()
      ( SysMenu )->( Blokuj_R())
      do case
      case k = 1; ( SysMenu )->R_OPCJI --
      case k = 2; ( SysMenu )->R_OPCJI ++
      case k = 3; ( SysMenu )->C_OPCJI --
      case k = 4; ( SysMenu )->C_OPCJI ++
      endcase
      skip
enddo

Keyboard Chr( K_ESC )
koniec := NIL
wy := 2

******************************************************************************

procedure MoveOption( k )

do case
case k = 5; Keyboard Chr( K_ESC ); move_r := .t.
case k = 6; Keyboard Chr( K_ESC ); move_l := .t.
otherwise
    if !full_dostep; return; endif
     move_op := .t.
     move_opkier := k
     Keyboard Chr( K_ENTER )
     wy := 2
endcase

******************************************************************************

procedure OptionNr( menu, nr, k )

if DBSeek( Str( menu, 2 ) + Str( nr, 2 ))
   ( SysMenu )->( Blokuj_R())
   do case
   case k = 1; ( SysMenu )->R_OPCJI --
   case k = 2; ( SysMenu )->R_OPCJI ++
   case k = 3; ( SysMenu )->C_OPCJI --
   case k = 4; ( SysMenu )->C_OPCJI ++
   endcase
endif

******************************************************************************

procedure KopiaMenu( a )

local rr := RecNo(), kk := Kod_menu, nk, nr

if !full_dostep; return; endif

if ( nk := Get_U( 10, 10, 'Podaj nowy KOD MENU :',, kk )) = NIL; return; endif

cat := Odetnij( @a )
ali := Odetnij( @a )

ON( SysMenu,, cat, ali,,, cat )
ON( SysMenu,, cat, ali, .t.,, cat )
KopiaRec( SysMenu, ali, { || kk = Kod_menu })

Select( ali )
DBSetOrder( 0 )
go top
while !Eof(); ( ali )->Kod_menu := nk; skip; enddo
go top
KopiaRec( ali, SysMenu )
Zwolnij( ali )

Select( SysMenu )
wy := 2
DBGo( rr )

*****************************************************************************

function EnvOK( aa )

local plik, wy := .f., a

a := aa

if Empty( a ); return .t.; endif

if poz_dostepu = -1
   while !Empty( plik := Odetnij( @a, ',' ))
         if !FFile( cat_wzorow + plik + '.txt' ); return .f.; endif
   enddo
   return .t.
else
   while !Empty( plik := Odetnij( @a, ',' ))
         if plik $ uprawnienia
            wy := .t.
            exit
         endif      
   enddo
   a := aa
   if !wy
      while !Empty( plik := Odetnij( @a, ',' ))
            if '->' $ plik
               if RunCommand( plik ); wy := .t.; exit; endif
            else
               if FFile( cat_wzorow + plik + '.txt' ); wy := .t.; exit; endif
            endif
      enddo
   endif
endif

return wy

*****************************************************************************
