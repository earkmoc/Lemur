#include 'Inkey.ch'
******************************************************************************
* Procedury obslugi wszystkich DbEdit'ow w programie

procedure Obsluga( tryb , nr )

static suma, gorne_bloki := .t.
local gtyt := ''
private r := row(), c := col(), key := Lastkey(), won := .f., wy

if gorne_bloki
   DatyCzas()
   private bl1 := 'bl_il_poz', bl2 := 'bl_napis', lhas, lhas2
   if Type( bl1 ) = 'B'               && blok z metodÜ uzyskania iloûci pozycji
      lhas  := il_poz + Eval( &bl1 )
      lhas2 := Len( AllTrim( lhas ))
      @ rr[ 1 ] - 2 , cc[ 2 ] - lhas2 say PadR( lhas , lhas2 )
   endif
   if Type( bl2 ) = 'B'               && blok z metodÜ uzyskania napisu tytuíu
      gtyt := Eval( &bl2 )
      gtyt := Konwert( gtyt, maz, lat, .t. )
      if Len( gtyt ) > 74
         @ rr[ 1 ] - 3 , 1 say ''
         ?? DwieLinie( gtyt, 74, 1 )
      else
         @ rr[ 1 ] - 2 , 1 say gtyt
      endif
   endif
   gorne_bloki := .f.
endif

private bl3 := 'bl_pozycja'
if Type( bl3 ) = 'B'               && blok z metodÜ obs≥ugi pozycji
   Eval( &bl3 )
endif

do case
case tryb = 0
*     if sumykolumn .and. Len( DBE_Sumy ) > 0
*        for i := 1 to Len( DBE_kolumny )
*            if nr = DBE_kolumny[ i ]
*               SetColor( jasny )
*               @ rr[ 1 ] + 1, c - 2 say '‰=' + Transform( DBE_Sumy[ i ], szablon[ nr ])
*               SetColor( STC )
*               exit
*            endif
*        next
*     endif
     if TAK_INVERS
        Pokoloruj( rr[1], c, rr[1], Mi( naglowki[ nr ], c ), 7, 15 )
        Pokoloruj( r, 1, r, mc - 1 )
        Keyboard Chr( Inkey( 0 ))
        Pokoloruj( rr[1], c, rr[1], Mi( naglowki[ nr ], c ), 15, 7 )
     endif
     return 1
case tryb > 0 .and. tryb < 4   && komunikaty trybow
     do case
     case DBE_ADD # NIL .and. ( tryb = 2 .or. tryb = 3 )
          if ValType( DBE_ADD ) == "C"
             Keyboard DBE_ADD
          else
             DBAppend()
             DBSkip( -1 )
             Keyboard Chr( K_DOWN ) + 'Q'
          endif
          return 1
     otherwise
          Kokat( tryb )
          return 1
     endcase
endcase

@ r,c say ''

wy := 1

do case
case DBE_Run( key, nr, DBE_Function, DBE_Tab_Fun, @gorne_bloki )
case key = K_F12 .and. full_dostep
     ne_com := .t.
     key := AllTrim( StrTran( DBE_Wzor, '.txt', '' ))
     bubu := Alarm( 'Wybierz definicjë "' + key + '" :',;
                  { 'Tabela', 'Formularz', 'Struktura', 'Indeksy', 'Funkcje', 'Wydruk' })
     do case
     case bubu = 1; Opis( cat_wzorow + key + '.txt', '' )
     case bubu = 2; Opis( cat_wzorow + key + '*.for', '' )
     case bubu = 3; Opis( cat_wzorow + key + '.str', '' )
     case bubu = 4; Opis( cat_wzorow + key + '.ind', '' )
     case bubu = 5; Opis( cat_wzorow + key + '.fun', '' )
     case bubu = 6; Opis( cat_wzorow + key + '*.wyd', '' )
     case bubu = 8; Opis( cat_wzorow + baza + '.txt', '' )
     case bubu = 9; Opis( cat_wzorow + baza + '*.for', '' )
     case bubu =10; Opis( cat_wzorow + baza + '.str', '' )
     case bubu =11; Opis( cat_wzorow + baza + '.ind', '' )
     case bubu =12; Opis( cat_wzorow + baza + '*.wyd', '' )
     case bubu =13; Opis( cat_wzorow + baza + '.fun', '' )
     endcase
case key = K_F5
     SetKolumna( nr )
case key = K_F6
     CompareDBF()
case key = K_F7         && private Kryteria := ''
     SetKryteria( nr )
case key = K_F8
     UseKryteria( nr ); gorne_bloki := .t.
case key = K_F2
     gorne_bloki := .t.
     Literka( 'F2', nr )
case key = K_CTRL_DEL
     if Alarm( 'Wyrzuciç zbëdne dane ?', nt ) = 2
        Czek( 1 )
        ON( Alias(),,,,,.t.)
        Czek( 0 )
        gorne_bloki := .t.
        return 2
     endif
case key = K_CTRL_INS .and. full_dostep
     nr := Alarm( 'Wybierz operacjë', { 'Reindeksacja', 'Deleted ON', 'Deleted OFF', 'Delete', 'Recall' })
     do case
        case nr = 0; return 1
        case nr = 1
             Czek( 1 )
             DBReindex()
             go top
             Czek( 0 )
             gorne_bloki := .t.
             return 2
        case nr = 2
             set deleted on
             return 2
        case nr = 3
             set deleted off
             return 2
        case nr = 4
             BDelete()
             return 1
        case nr = 5
             Blokuj_R()
             DBRecall()
             return 1
     endcase
case key = 43 ; suma := Dodaj( nr , suma , '+' )
case key = 45 ; suma := Dodaj( nr , suma , '-' )
case Chr( key ) == '*'; Niechrony( nr )
case Chr( key ) == '/'; suma := Dodaj()
case Chr( key ) == '='; Duble( nr )
case key = K_ENTER ; gorne_bloki := .t. ; Enter( nr )
case key = K_ESC               && wyjscie ...
     DBE_Sumy := {}
*     DBE_kolumny := {}
     @ 0,0                     && wyczyszczenie sumy w lewym gornym
     set relation to           && gaszenie relacji
     clear typeahead           && czyszczenie bufora klawiatury
     gorne_bloki := .t.
     return 0
otherwise
     gorne_bloki := .t.
     return Literka( Chr( key ), nr )   && inne bloki instrukcji
endcase

if won
   DBE_Sumy := {}
*   DBE_kolumny := {}
   @ 0,0                     && wyczyszczenie sumy w lewym gornym
   set relation to           && gaszenie relacji
   clear typeahead           && czyszczenie bufora klawiatury
   gorne_bloki := .t.
   return 0
endif

return wy

******************************************************************************
* Odczytuje z ekranu wartosc po znaku ':' w linii rr
* dodaje 'x' i umieszcza w tym samym miejscu

procedure Ch_il( x , rr )

local lhas, lhas2

private l := SaveScreen( rr , 0 , rr , mc ) , ll := '' , ccc := 0

ccc := Rat( ':' , l )
l := SubStr( l , ccc + 2 )

for i := 1 to Len( l )
    ll += if( IsDigit( SubStr( l, i, 1 )), SubStr( l, i, 1 ), '' )
next

lhas := AllTrim( Str( Val( ll ) + x ))
lhas2:= Len( lhas )
@ rr, 78 - lhas2 say PadR( lhas, lhas2 )

*******************************************************************************

function Dodaj( nr , suma , znak )

if nr = NIL; suma := 0
else
   private t := ValType( suma ) , w := &( kolumny[ nr ] )

   if ValType( w ) =='C'     && byç moße liczba w formie tekstowej?
      w := StrTran( w, ',', '' )
      w := StrTran( w, '.', '' )
      w := Val( w ) * 0.01
   elseif ValType( w ) # 'N' && zabezpieczenie przed nienumerycznymi kolumnami
      w := 0
   endif

   if znak = '+' ; suma := if( t = 'U' , w , suma + w )
   else          ; suma := if( t = 'U' , - w , suma - w )
   endif
   Keyboard Chr( K_DOWN )
endif

@ 0, 0 clear to 0, mc
@ 0, 0 say Transform( suma , '999,999,999,999.99' )

return suma

******************************************************************************
* |U|Usu§|Kasuj('usuwasz tÜ pozycjë',;
*               'SkasujRec("TOWAR_Z"%"1"%"(baza)->LP"%"(baza)->LP==LPP")';
*               'SkasujRec("SPLATYZ"%"1"%"(baza)->LP"%"(baza)->LP==LPP")';)|

function Kasuj( h, b, c )

if !serio; NoChange(); return .f.; endif
if h = NIL; h := ''; endif

if ( osoba_upr == 'AMoch' ) .or. ( Alarm( 'Na pewno ' + h + '?' , nt ) = 2 )
   wy := 2
   zmiana := .t.
   NumerySio(b,c)
   RunCommand( b )    && skasowanie specyfikacji subbazy 1
   RunCommand( c )    && skasowanie specyfikacji subbazy 2
   BDelete()
   DBSkip( 0 )
   Ch_il( -1 , rr[ 1 ] - 2 )
   return .t.
else
   return .f.
end

***************************************************************************

procedure SysDopisz( a )

DBCAppend({ || .t. })
if SysForm( a ); Ch_il( 1 , rr[ 1 ] - 2 )           && Inc( licznik )
else           ; BDelete()
endif

***************************************************************************
* Dopisanie DBEdit'a
* Fnr - numer funkcji obsíugujÜcej formularz wprowadzania danych
* a, b, c - parametry wypeíniania formularza
* bfill - blok wypeíniania dopisanego rekordu

procedure DBE_Dopisz( Fnr, a, b, c, bfill )

DBCAppend( bfill )
if Eval( DBE_Tab_Fun[ Fnr ], a, b, c ); Ch_il( 1 , rr[ 1 ] - 2 )  && Inc( licznik )
else                                  ; BDelete()
endif

******************************************************************************

procedure DBCAppend( bfill )

local rekord[ FCount()], i

if bfill = NIL; DBAppend()
else
   for i := 1 to FCount(); rekord[ i ] := FieldGet( i ); next
   DBAppend()
   for i := 1 to FCount(); FieldPut( i, rekord[ i ]); next
   Eval( bfill )
endif

******************************************************************************

procedure Szukaj( nr )

local rek, mtyp, bufor, r, ekran, odp

if ( bufor := Pob_war( nr )) = NIL
   Lastzero()
   return
endif

rek := RecNo()            && pozycja wyjsciowa do szukania
skip

mtyp := ValType( bufor )

r := rr[ 2 ] + 2
ekran := SaveScreen( r, 0, mr, mc )
@ r, 0 clear to mr, mc
CSay( r, 0, mc - 1, 'Esc - przerwanie operacji ...', miga )

Przerwa( LastRec())
do case                   && szukanie podanej wartosci
case mtyp $ 'ND'
     while !Eof()
           if &( kolumny[ nr ]) = bufor; exit; endif
           if Przerwa(); go rek; exit; endif
           skip
     enddo
case mtyp = 'C'
     bufor := Alltrim( bufor )
     while !Eof()
           if Upper( bufor ) $ Upper( &( kolumny[ nr ])); exit; endif
           if Przerwa(); go rek; exit; endif
           skip
     enddo
endcase
*Przerwa( 0 )

*Przerwa( LastRec())

if Eof()                  && nie znaleziono

   go rek                    && powrot do pozycji przed szukaniem

   odp := Alert( Konwert('Nie znaleziono w czëûci ponißej.;Wybierz spos¢b szukania w czëûci powyßej:',maz,lat,.t.),;
               { Konwert('W g¢rë do szczytu',maz,lat,.t.), Konwert('Od szczytu w d¢í',maz,lat,.t.) })

   do case
   case odp = NIL .or. odp = 0
   case odp = 1

skip -1
do case                   && szukanie podanej wartosci
case mtyp $ 'ND'
     while !Bof()         && .and. RecNo() # rek
           if &( kolumny[ nr ]) = bufor; exit; endif
           if Przerwa(); go rek; exit; endif
           skip -1
     enddo
case mtyp = 'C'
     bufor := Alltrim( bufor )
     while !Bof()         && .and. RecNo() # rek
           if Upper( bufor ) $ Upper( &( kolumny[ nr ])); exit; endif
           if Przerwa(); go rek; exit; endif
           skip -1
     enddo
endcase

   case odp = 2

go top
do case                   && szukanie podanej wartosci
case mtyp $ 'ND'
     while rek # RecNo() .and. !Eof()
           if &( kolumny[ nr ]) = bufor; exit; endif
           if Przerwa(); go rek; exit; endif
           skip
     enddo
case mtyp = 'C'
     bufor := Alltrim( bufor )
     while rek # RecNo() .and. !Eof()
           if Upper( bufor ) $ Upper( &( kolumny[ nr ])); exit; endif
           if Przerwa(); go rek; exit; endif
           skip
     enddo
endcase
endcase

endif
Przerwa( 0 )

RestScreen( r, 0, mr, mc, ekran )

if Bof() .or. Eof() .or. RecNo() == rek
   Kokat( 'Nie znaleziono !!!' )
   go rek                     && powrot do pozycji przed szukaniem
endif

Lastzero()

******************************************************************************

function Pob_war( nr )

local nn, r, dl, ekran, od, oe

*if '(' $ kolumny[ nr ]; return NIL; endif

bufor := &( kolumny[ nr ])

r := rr[ 2 ] + 2
ekran := SaveScreen( r, 0, mr, mc )
@ r, 0 clear to mr, mc

nn := StrTran( naglowki[ nr ] , ';' , '' )    && pobranie do czystego pola
nn := StrTran( nn , '-' , '' )
@ r, 5 say nn + ' : ' get bufor picture KK( szablon[ nr ])

         od := SetKey( K_CTRL_INS,  { || ToClip()})
         oe := SetKey( K_ALT_INS,   { || FromClip()})

if !Read(1); bufor := NIL; endif

         SetKey( K_CTRL_INS,   od )
         SetKey( K_ALT_INS,    oe )

RestScreen( r, 0, mr, mc, ekran )

return bufor

******************************************************************************
* Komunikat w zaleznosci od trybu DbEdit'a

procedure Kokat( nr )

local ekran, kokaty

kokaty := { 'To jest pierwsza pozycja !!!',;
            'To jest ostatnia pozycja !!!',;
            '       Brak danych !!!      ' }
ekran := SaveScreen()

Keyboard Chr( K_ENTER )
SetColor( 'I,,,,' )
private p := if( ValType( nr ) = 'N' , TN( 13 , 25 , kokaty[ nr ] ) ,;
                                       TN( 13 , 25 , nr ) )
SetColor( STC )
Inkey( 1 )

RestScreen( ,,,, ekran )

******************************************************************************
* reakcja na Enter

procedure Enter( nr )

local ekran := SaveScreen(), bnr := Alias()

private rn := RecNo()

if Type( 'bl_Enter' ) # 'U' ; Eval( bl_Enter, nr ); endif

RestScreen( ,,,, ekran )





select ( bnr )

if rn >= 0; go rn
else
   go -rn     && wymuszone wpasowanie sië w filtr
   skip 0
endif

******************************************************************************

procedure Pomoc
local ekran :=  SaveScreen()

if Type( 'bl_F1' ) # 'U'
   Eval( bl_F1 )
endif

RestScreen( ,,,, ekran )

******************************************************************************
* Obsluga wciûniëcia klawisza klawiatury przez przypiëty blok

procedure Literka( l, nr )

local ekran := SaveScreen() , bb := Alias()
private blok := 'bl_' + Upper( l ) , wy := 1 , rn := RecNo()

if Type( blok ) # 'U'
   Eval( &blok, nr )
endif

RestScreen( ,,,, ekran )
Select( bb )

if rn >= 0; go rn
else
   go -rn     && wymuszone wpasowanie sië w filtr
   skip -1
   if RecNo() # -rn; skip 1; endif
endif

return wy

******************************************************************************

procedure SysIndeks( a )

local t1 := {}, t2 := {}

while !Empty( a )
      Aadd( t1, Odetnij( @a ))
      Aadd( t2, Val( Odetnij( @a )))
enddo

Indeks( t1, t2 )

******************************************************************************
* Funkcja obsíugujÜca klawisz 'I' wykorzystywana w blokach obsíugi DBEdit
* tab - tablica haseí dla 'Alert'
* ind - tablica numer¢w indeks¢w odpowiadajÜcych hasíom z 'tab'

function Indeks( tab, ind )

local k := Alarm( 'Jak posortowaç dane ?' , tab )

if k = 0 ; return NIL
else
   wy := 2
   if ind # NIL; k := ind[ k ]; endif
   set order to k
   return k
endif

******************************************************************************
* Nr 18.
* a : 'wzor.txt,     1,2,3,     , tytuí, DATA,          coû            ,;
* sub         , DATA     , ILOSC # 0, proc1, proc2, proc3
*      wz¢r wydruku, sumy, puste, tytuí, typ zakresu, okres "data_od" ?,;
* subSysWydruk, typ_zak 2, war_druk,  init, operation, done
* sumy moßna podaç w pliku tekstowym podanym zamiast "1,2,3", wtedy jest '.'.

procedure SysWydruk( a )


local buf, wzor, sumy, tytul, z1, z2, zakres, rr := RecNo(), hh, bb, cc, i
local bl_wtr, bl_end, proc1, proc2, proc3   &&, baza


private sub, typ_zak, typ_zak2, war_druk

*bb := Alias()
*baza := bb
Select( baza )

wzor := Odetnij( @a )

sumy := {}
buf := Odetnij( @a )
if '.' $ buf                       && sumy zdefiniowane w pliku
   sumy := ReadWzor( buf )
   buf := Odetnij( @a )     && puste won
else
   while !Empty( buf )
         Aadd( sumy, Val( buf ))
         buf := Odetnij( @a )
   enddo
endif

hh := Odetnij( @a )

if Left( hh, 1 ) == '&'
   hh := StrTran( SubStr( hh, 2 ), ';', ',' )         && makro tytuí
   hh := &hh
endif

tytul := EOL + ReadWzor( cat_main + '\' + 'max.txt', 11 ) + EOL + hh
tytul := Konwert( tytul )

typ_zak := Odetnij( @a )
cc  := Odetnij( @a )    && czy dopisaç okreûlenie okresu na podstawie "data_od"
sub := StrTran( Odetnij( @a ), ';', ',' )    && rodzaj subsum
typ_zak2 := Odetnij( @a )
war_druk := Odetnij( @a )
proc1    := Odetnij( @a )
proc2    := Odetnij( @a )
proc3    := Odetnij( @a )

data_od := MemVar->data1
data_do := MemVar->data2

if Empty( war_druk )
do case
case Empty( typ_zak )
case typ_zak == 'data'
     if Get_Okres( @data_od, @data_do ) = NIL; return; endif
case typ_zak == 'DATA'
     if Get_Okres( @data_od, @data_do ) = NIL; return; endif
     zakres := { || DATA >= data_od .and. DATA <= data_do }
     tytul += DtoC( data_od ) + ' - ' + DtoC( data_do )
otherwise
     z1 := &typ_zak
     z2 := &typ_zak
     if Get_Okres( @z1, @z2, hh ) = NIL; return; endif
     if ValType( z1 ) = 'C'
        z1 := AllTrim( z1 )
        z2 := AllTrim( z2 )
        do case
        case Empty( typ_zak2 )
             zakres := { || z1 <= PadL( AllTrim( &( typ_zak )), Len( z1 )) .and.;
                            z2 >= PadL( AllTrim( &( typ_zak )), Len( z2 ))}
             tytul += AllTrim( z1 ) + ' - ' + AllTrim( z2 )
        case typ_zak2 == 'DATA'
             if Get_Okres( @data_od, @data_do ) = NIL; return; endif
             zakres := { || z1 <= PadL( AllTrim( &( typ_zak )), Len( z1 )) .and.;
                            z2 >= PadL( AllTrim( &( typ_zak )), Len( z2 )) .and.;
                            DATA >= data_od .and. DATA <= data_do }
             tytul += AllTrim( z1 ) + ' - ' + AllTrim( z2 )
        endcase
     else
        do case
        case Empty( typ_zak2 )
             zakres := { || z1 <= &( typ_zak ) .and.  z2 >= &( typ_zak )}
             tytul += AllS( z1 ) + ' - ' + AllS( z2 )
        case typ_zak2 == 'DATA'
             if Get_Okres( @data_od, @data_do ) = NIL; return; endif
             zakres := { || z1 <= &( typ_zak ) .and.;
                            z2 >= &( typ_zak ) .and.;
                            DATA >= data_od .and.;
                            DATA <= data_do }
             tytul += AllS( z1 ) + ' - ' + AllS( z2 )
        endcase
     endif
endcase
else
do case
case Empty( typ_zak )
     zakres := { || &( war_druk ) }
case typ_zak == 'data'
     if Get_Okres( @data_od, @data_do ) = NIL; return; endif
case typ_zak == 'DATA'
     if Get_Okres( @data_od, @data_do ) = NIL; return; endif
     zakres := { || DATA >= data_od .and. DATA <= data_do .and. &( war_druk ) }
     tytul += DtoC( data_od ) + ' - ' + DtoC( data_do )
otherwise
     z1 := &typ_zak
     z2 := &typ_zak
     if Get_Okres( @z1, @z2, hh ) = NIL; return; endif
     if ValType( z1 ) = 'C'
        z1 := AllTrim( z1 )
        z2 := AllTrim( z2 )
        do case
        case Empty( typ_zak2 )
             zakres := { || z1 <= PadL( AllTrim( &( typ_zak )), Len( z1 )) .and.;
                            z2 >= PadL( AllTrim( &( typ_zak )), Len( z2 )) .and. &( war_druk )}
             tytul += AllTrim( z1 ) + ' - ' + AllTrim( z2 )
        case typ_zak2 == 'DATA'
             if Get_Okres( @data_od, @data_do ) = NIL; return; endif
             zakres := { || z1 <= PadL( AllTrim( &( typ_zak )), Len( z1 )) .and.;
                            z2 >= PadL( AllTrim( &( typ_zak )), Len( z2 )) .and.;
                            DATA >= data_od .and. DATA <= data_do .and. &( war_druk ) }
             tytul += AllTrim( z1 ) + ' - ' + AllTrim( z2 )
        endcase
     else
        do case
        case Empty( typ_zak2 )
             zakres := { || z1 <= &( typ_zak ) .and.  z2 >= &( typ_zak ) .and. &( war_druk )}
             tytul += AllS( z1 ) + ' - ' + AllS( z2 )
        case typ_zak2 == 'DATA'
             if Get_Okres( @data_od, @data_do ) = NIL; return; endif
             zakres := { || z1 <= &( typ_zak ) .and.;
                            z2 >= &( typ_zak ) .and.;
                            DATA >= data_od .and.;
                            DATA <= data_do .and. &( war_druk ) }
             tytul += AllS( z1 ) + ' - ' + AllS( z2 )
        endcase
     endif
endcase
endif

if !Empty( cc )
   tytul += cc + DtoC( data_od ) + ' - ' + DtoC( data_do )
endif

if !Empty( sub )
   private subSysWydruk, suma_tak, suma_nie
   if sub == 'persaldo'
      subSysWydruk:= '1=1'                && warunek sumowania dla subprocedur
      bl_end := { || PerSaldo()}
   else
      subSysWydruk:= sub                  && warunek sumowania dla subprocedur
      bl_end := { || EndSuma()}
   endif
   bl_wtr := { |a,b| SubSuma( a, b )}
   suma_tak := {}
   suma_nie := {}
   for i := 1 to Len( sumy ); Aadd( suma_tak, 0 ); next    && zerowanie sum
   for i := 1 to Len( sumy ); Aadd( suma_nie, 0 ); next    && zerowanie sum
endif

W_DBEdit( wzor, @sumy, { || tytul }, @zakres, @bl_wtr, @bl_end,,,, proc1, proc2, proc3 )

DBGo( rr )
*Select( bb )

******************************************************************************

procedure SubSuma( sumy, tab )

local i

if &subSysWydruk; for i := 1 to Len( sumy ); suma_tak[ i ] += tab[ sumy[ i ]]; next
else            ; for i := 1 to Len( sumy ); suma_nie[ i ] += tab[ sumy[ i ]]; next
endif

******************************************************************************

procedure EndSuma()

? Naglowek_wydruku() + Linia_wydruku( suma_tak )
? Naglowek_wydruku() + Linia_wydruku( suma_nie )
??Naglowek_wydruku() + Linia_wydruku({''})

******************************************************************************

procedure PerSaldo()

suma_nie[ 1 ] := suma_tak[ 1 ] - suma_tak[ 2 ]
suma_nie[ 2 ] := suma_tak[ 2 ] - suma_tak[ 1 ]

if Len( suma_nie ) > 2
   suma_nie[ 3 ] := suma_tak[ 3 ] - suma_tak[ 4 ]
   suma_nie[ 4 ] := suma_tak[ 4 ] - suma_tak[ 3 ]
endif

if Len( suma_nie ) > 4
   suma_nie[ 5 ] := suma_tak[ 5 ] - suma_tak[ 6 ]
   suma_nie[ 6 ] := suma_tak[ 6 ] - suma_tak[ 5 ]
endif

if Len( suma_nie ) > 6
   suma_nie[ 7 ] := suma_tak[ 7 ] - suma_tak[ 8 ]
   suma_nie[ 8 ] := suma_tak[ 8 ] - suma_tak[ 7 ]
endif

suma_nie[ 1 ] := if( suma_nie[ 1 ] < 0, 0, suma_nie[ 1 ] )
suma_nie[ 2 ] := if( suma_nie[ 2 ] < 0, 0, suma_nie[ 2 ] )

if Len( suma_nie ) > 2
   suma_nie[ 3 ] := if( suma_nie[ 3 ] < 0, 0, suma_nie[ 3 ] )
   suma_nie[ 4 ] := if( suma_nie[ 4 ] < 0, 0, suma_nie[ 4 ] )
endif

if Len( suma_nie ) > 4
   suma_nie[ 5 ] := if( suma_nie[ 5 ] < 0, 0, suma_nie[ 5 ] )
   suma_nie[ 6 ] := if( suma_nie[ 6 ] < 0, 0, suma_nie[ 6 ] )
endif

if Len( suma_nie ) > 6
   suma_nie[ 7 ] := if( suma_nie[ 7 ] < 0, 0, suma_nie[ 7 ] )
   suma_nie[ 8 ] := if( suma_nie[ 8 ] < 0, 0, suma_nie[ 8 ] )
endif

? Naglowek_wydruku() + Linia_wydruku( suma_tak )
? Naglowek_wydruku() + Linia_wydruku( suma_nie )
??Naglowek_wydruku() + Linia_wydruku({''})

******************************************************************************
* Standardowa procedura drukujÜca zawartoûç tabeli DBEdit'a
* 1.wzor - nazwa zbioru w katalogu 'WZORY' okreûlajÜcego wyglÜd wydruku
* 2.sumy - tablica numer¢w kolumn do sumowania
* 3.bl_naglowka - drukuje sië na poczÜtku
* 4.bl_warunku  - musi byç speíniony aby coû drukowaç
* 5.bl_wtretu   - wykonywany po kaßdej linii wydruku
* 6.bl_end      - wykonywany po uko§czeniu wydruku
* 7.se          - znak separacji kolumn
* 8.bl_war_sum  - blok warunku sumowania linii wydruku
* 9.bl_while    - dodatkowy warunek 'while', na og¢í = 'bl_warunku'
*10.proc1       - init
*11.proc2       - operation
*12.proc3       - done

procedure W_DBEdit( wzor, sumy, bl_naglowka, bl_warunku, bl_wtretu, bl_end, se, bl_war_sum, bl_while, proc1, proc2, proc3 )

local tak_dsum := .f., dsum, i

if !FFile( cat_wzorow + wzor )
   Alarm( 'Brak wzoru : ' + wzor + ' !!!', Ent )
   return
endif

if sumy = NIL; sumy := {} ; endif
if bl_naglowka = NIL; bl_naglowka := { || '' }; endif
if bl_warunku = NIL; bl_warunku := { || .t. }; endif
if bl_wtretu = NIL; bl_wtretu := { || .t. }; endif
if bl_end = NIL; bl_end := { || .t. }; endif
if bl_war_sum = NIL; bl_war_sum := { || .t. }; endif

if bl_while = NIL
   go top
   bl_while := { || .t. }
endif

if ValType( sumy ) = 'C'
   tak_dsum := .t.            && sumy definiowane
   dsum := {}
   for i := 1 to MLCount( sumy )
       Aadd( dsum, RTrim( MemoLine( sumy,, i )))
   next
   sumy := dsum       && "sumy" stajÜ sië tablicÜ tak díugÜ jak "dsum"
endif

RunCommand( proc1 )

private szablon_wzoru := NIL
private bufor_wzoru := ReadWzor( wzor )

Czek( 1 )
mOpen( cat_wydr + wzor )

?? Naglowek_wydruku() + Linia_wydruku({ Time()})
?? Naglowek_wydruku() + Linia_wydruku({ Datee()})

?  Konwert( Eval( bl_naglowka ),maz,lat,.t.)
?? Konwert( Naglowek_wydruku() + Linia_wydruku({ DBE_Tyt }))
?? Konwert( Naglowek_wydruku() + Linia_wydruku({''}))
?  Konwert( Naglowek_wydruku())

private tab := AClone( kolumny ), tab_sum := {}

for i := 1 to Len( sumy ); Aadd( tab_sum, 0 ); next    && zerowanie sum

Linia_wydruku({''})        && zeßryj szablon ( na wszelki wypadek )
Przerwa( LastRec(), 1 )
while Eval( bl_while ) .and. !Eof()
      if Eval( bl_warunku )
         for i := 1 to Len( kolumny ); tab[ i ] := Konwert( &( kolumny[ i ])); next
         if tak_dsum
            for i := 1 to Len( sumy )
                tab_sum[ i ] += &( sumy[ i ])
            next
         else
            if Eval( bl_war_sum, @sumy )
               for i := 1 to Len( sumy ); tab_sum[ i ] += tab[ sumy[ i ]]; next
            endif
         endif
         ? Linia_wydruku( tab, se )
         RunCommand( proc2 )
         if !tak_dsum; Eval( bl_wtretu, @sumy, @tab ); endif
      endif
      if Przerwa(,1); ?;? '... przerwanie klawiszem Esc ...'; ?; exit; endif
      skip
enddo
Przerwa( 0, 1 )

if Len( sumy ) > 0 ; ? Naglowek_wydruku() + Linia_wydruku( tab_sum ); endif

?? Naglowek_wydruku() + Linia_wydruku({''})  && linia ko§czÜca

RunCommand( proc3 )

Eval( bl_end )        && procedura ko§czÜca

mClose()
Czek( 0 )
Druk( cat_wydr + wzor, 1 )    && druk natychmiastowy

******************************************************************************
* dodaje nowy rekord identyczny z bießÜcym

function Append_Copy( wypelnic )

local i , dane := {}

if wypelnic # NIL
   for i := 1 to FCount()
       Aadd( dane , FieldGet( i ))   && data of current record
   next
endif

DBAppend()

if wypelnic # NIL
   for i := 1 to FCount()
       FieldPut( i , dane[ i ] )     && fill new record
   next
endif

******************************************************************************

procedure SysMySeek( a, b, c )

local nr, kol := {}, ind := {}, wiele:= {}, i, k, jest, czytane := ReadVar(), sc

private GetList := {}

nr := if( b = NIL, Val( Odetnij( @a )), b )

while !Empty( a )
      Aadd( kol, Val( Odetnij( @a )))
      Aadd( ind, Val( Odetnij( @a )))
		if c # NIL
	      Aadd( wiele, Val( Odetnij( @c )))
		endif
enddo

jest := .f.
if c # NIL
	for i := 1 to Len( wiele )
		if nr = wiele[ i ]
			jest := .t.
			exit
		endif
	next
	if jest
		private ko := kolumny, na := naglowki, sza := szablon
		private kolumny := {}, naglowki := {}, szablon := {}
		for i := 1 to Len( wiele )
			Aadd( kolumny, ko[ wiele[ i ]])
			Aadd( naglowki, na[ wiele[ i ]])
			Aadd( szablon, sza[ wiele[ i ]])
		next
		sc := SaveScreen()
		if jest := U_Get_Read(,,'Szukanie po wielu polach:',,20,1 )
			Czek( 1 )
			k := RecNo()
			DBSkip()
			jest := NIL		&& jeszcze nic nie szuka≥, wiÍc nie wiadomo czy jest
			Przerwa( LastRec())
			while !Eof()
					jest := .t.
					for i := 1 to Len( wiele )
						if kolumny[ i ] # &( ko[ wiele[ i ]])
							jest := .f.
							exit
						endif
					next
					if jest; exit; endif
					if Przerwa(); exit; endif
					DBSkip()
			enddo
			Przerwa( 0 )
			if jest = NIL .or. !jest		&& nie szuka≥ lub nie jest
				DBGoTo( k )
				DBSkip( -1 )
				Przerwa( LastRec())
				while !Bof()
						jest := .t.
						for i := 1 to Len( wiele )
							if kolumny[ i ] # &( ko[ wiele[ i ]])
								jest := .f.
								exit
							endif
						next
						if jest; exit; endif
						DBSkip( -1 )
						if Przerwa(); exit; endif
				enddo
				Przerwa( 0 )
			endif
			Czek( 1 )
			if jest = NIL .or. !jest
				DBGoTo( k )
			endif
		endif
		RestScreen( ,,,, sc )
		kolumny := ko
		naglowki := na
		szablon := sza
	endif
endif

if !jest
	MySeek( nr, kol, ind )
endif

ReadVar( czytane )

******************************************************************************
* nr - numer kolumny DBEdit'a
* kol - tablica obsíugiwanych kolumn
* ind - tablica stosowanych indeks¢w

function MySeek( nr, kol, ind )

local r, lin, k, od, oe
private buf

if ( k := AScan( kol, nr )) = 0        && kolumna nie obsíugiwana
   Szukaj( nr )
   return
endif

r := rr[ 2 ] + 2
n := StrTran( naglowki[ nr ], ';', '' )
n := StrTran( n, '-', '' )
n := 'Szybkie wyszukiwanie wedíug pola "' + n + '" : '

buf := &( kolumny[ nr ])
lin := SaveScreen( r, 0, mr, mc )
@ r, 0 clear to mr, mc
@ r, 0 say n get buf picture KK( szablon[ nr ])

od := SetKey( K_CTRL_INS,  { || ToClip()})
oe := SetKey( K_ALT_INS,   { || FromClip()})
if Read()
   DBSetOrder( ind[ k ])
   if !DBSeek( buf, .t. )
      wy := ValType( buf )
      do case
         case wy = 'C'; buf := Upper( buf )
         case wy = 'D'; buf := DtoS( buf )
      otherwise; buf := Transform( buf, szablon[ nr ])
      endcase
      DBSeek( buf, .t. )
   endif
   wy := 2
endif
SetKey( K_CTRL_INS,   od )
SetKey( K_ALT_INS,    oe )
RestScreen( r, 0, mr, mc, lin )

return .t.

******************************************************************************

function Sz_9( n )
return Replicate( '9', n )

******************************************************************************

function Sz_X( n )
return Replicate( 'X', n )

******************************************************************************

function Normuj( key )

do case
case key = K_ESC;   key := 'ESC'
case key = K_ENTER; key := 'ENTER'
case key = K_TAB; key := 'TAB'
case key = K_F12; key := 'F12'
case key = K_F11; key := 'F11'
case key = K_F10; key := 'F10'
case key = K_F9; key := 'F9'
case key = K_F8; key := 'F8'
case key = K_F7; key := 'F7'
case key = K_F6; key := 'F6'
case key = K_F5; key := 'F5'
case key = K_F4; key := 'F4'
case key = K_F3; key := 'F3'
case key = K_F2; key := 'F2'
case key = K_F1; key := 'F1'
otherwise; key := Upper( Chr( key ))
endcase

return key

******************************************************************************
* key - podany klawisz
* nr - numer kolumny tabeli
* tf - tablica moßliwych funkcji
* tr - tablica realizacji w.w. funkcji ( bloki kodu )
* gorne bloki

procedure DBE_Run( key, nr, tf, tr, gb )

local i, k, p1, p2, p3, p4, p5, ltfi, sysf := .f.

key := Normuj( key )

if Len( tr ) = 0
   tr := SysFunction
   sysf := .t.
endif

for i := 1 to Len( tf )

    if Upper( tf[ i, 2 ]) == key     && detekcja 'hot key'

       if Empty( tf[ i, 1 ])

          if Len( tf[ i ]) >= 4 .and. !Empty( p1 := tf[ i, 4 ])
             gb := .t.
             p1 := StrTran( p1, ';', '|' )
             if ( '{' $ p1 ) .or. ( '(baza)->' $ p1 )
                p1 := StrTran( p1, '(nr,', '(' + AllS( nr ) + ',' )
                p1 := RunCommand( p1 )
             else
	             p1 := StrTran( p1, '%%', ',' )
                p1 := '{|nr|' + p1 + '}'
                p1 := &p1
                p1 := Eval( p1, nr )
             endif
          endif

       else

          ltfi := Len( tf[ i ]) && iloûç element¢w danego wiersza 'tf'

          DBEGetParam( @k,  1, tf, ltfi, i )
          DBEGetParam( @p1, 4, tf, ltfi, i )
          DBEGetParam( @p2, 5, tf, ltfi, i )
          DBEGetParam( @p3, 6, tf, ltfi, i )
          DBEGetParam( @p4, 7, tf, ltfi, i )
          DBEGetParam( @p5, 8, tf, ltfi, i )

          if p1 # NIL .and.;
             ValType( p1 ) # 'N' .and.;
             p1 = 'nr'    && wyjÜtek dla 'Szukaj'
             if sysf
                p1 := AllTrim( Str( nr )) + SubStr( p1, 3 )
             else
                p1 := nr
             endif
          endif

          gb := .t.
          Eval( tr[ k ], p1, p2, p3, p4, p5 )   && uruchomienie k-tej realizacji

       endif

       return .t.
    endif
next

return .f.

******************************************************************************

procedure DBEGetParam( p, n, tf, lt, i )

if lt < n; p := NIL
else
   p := tf[ i, n ]   && parametry
   if IsDigit( p ) .or. Left( p, 1 ) == '-'; p := Val( p ); endif   && liczby
endif

******************************************************************************
* Ustawienie pewnych zmiennych 

procedure Setup_DBEdit( wzor, cat, ind, seekkey, whilekey, ind2, seekkey2, whilekey2, for_key, PressKey )

local plik, wsp, rob, ss, ps

rob := if( Alias() == 'ROB', 'ROB2', 'ROB' )

if '+' $ baza
   baza := &baza     && obliczenie bazy z wzoru
endif

if wzor = NIL .or. wzor == ''
   wzor := baza + '.txt'
   DBE_wzor := wzor
endif

if ( plik := ReadWzor( wzor )) == ''
   plik := DefWzor( baza, wzor )
endif

//plik := Konwert( plik, maz, lat, .t.)
if IsDigit( MemoLine( plik, dl_memo, 2,, .t. ))

   DBE_Tyt := AllTrim( MemoLine( plik, dl_memo, 1,, .t. ))
   bl_il_poz := bl_s_il_poz

   i := 3
   j := 0
   kolumny := {}
   naglowki:= {}
   szablon := {}
   while !Empty( line := MemoLine( plik, dl_memo, i,, .t. ))
         Aadd( kolumny , Odetnij( @line, '|' ))
			ss := Odetnij( @line, '|' )
			if Left( ss, 1 ) == '&'
				ss := SubStr( ss, 2 )
				ss := RunCommand( ss )
			endif
         Aadd( naglowki, Konwert(ss,maz,lat,.t.) )
         Aadd( szablon , Odetnij( @line, '|' ))
         i ++
   enddo

   wsp := LineTab( MemoLine( plik, dl_memo, 2,, .t. ))
   rr := { Val( wsp[ 1 ]), Val( wsp[ 2 ])}
   cc := { Val( wsp[ 3 ]), Val( wsp[ 4 ])}

   DBE_Dod := ''

plik := ''
if !(( plik := StrTran( DBE_Wzor, '.txt', '' )) == baza ) .and. FFile( cat_wzorow + plik + '.fun' )
   if ( plik := ReadWzor( plik + '.fun' )) == ''
      plik := DefWzor( baza, plik + '.fun' )
   endif
else
   if FFile( Matka( baza ) + '.fun' )
      plik := ReadWzor( Matka( baza ) + '.fun' )
   else
      plik := DefWzor( Matka( baza ), Matka( baza ) + '.fun' )
   endif
endif

   i := 1
   j := 0
   DBE_Function := {}

   while !Empty( line := MemoLine( plik, dl_memo, i,, .t. ))
         j := LineTab( line,, 1 )
         if Len( j ) = 0
         elseif Len( j ) > 8
            if FFile( cat_wzorow + j[ 9 ])
               Aadd( DBE_Function, j )
            endif
         else
            Aadd( DBE_Function, j )
         endif
*         k := {}
*         Aadd( k, '')
*         Aadd( k, Odetnij( @line, '|' ))
*         Aadd( k, Odetnij( @line, '|' ))
*         Aadd( k, Odetnij( @line, '|' ))
*         Aadd( DBE_Function, k )
         i ++
   enddo

else

   kolumny := LineTab( MemoLine( plik, dl_memo, 1,, .t. ))
   naglowki := LineTab( MemoLine( plik, dl_memo, 2,, .t. ),,,1)
   szablon := LineTab( MemoLine( plik, dl_memo, 3,, .t. ))

   wsp := LineTab( MemoLine( plik, dl_memo, 4,, .t. ))
   rr := { Val( wsp[ 1 ]), Val( wsp[ 3 ])}
   cc := { Val( wsp[ 2 ]), Val( wsp[ 4 ])}

   DBE_Tyt := AllTrim( MemoLine( plik, dl_memo, 5,, .t. ))
   bl_il_poz := bl_s_il_poz

   DBE_Dod := MemoLine( plik, dl_memo, 6,, .t. )

   DBE_Function := {}
   for i := 7 to MLCount( plik, dl_memo,, .t. )
       j := LineTab( MemoLine( plik, dl_memo, i,, .t. ))
       if Len( j ) = 0
       elseif Len( j ) > 8
          if FFile( cat_wzorow + j[ 9 ])
             Aadd( DBE_Function, j )
          endif
      else
          Aadd( DBE_Function, j )
       endif
   next

endif

@ rr[ 1 ] - 2, 0 clear
RRamka( rr , cc )
DBE_Linia( rr[ 2 ] + 2 )
if !Empty( DBE_Dod ); CSay( mr, 0, mc, DBE_Dod, miga ); endif

if Empty( cat )
   ON( @baza, if( Empty( ind ), NIL, Val( ind )))
   if !Empty( seekkey )
      private buf_sys := ReadVar()        && pole wartoûci
      private sseek := StrTran( seekkey, ';', ',' ) && wyraßenie
      buf_sys := RunCommand( buf_sys )              && wartoûç
      set filter to
      DBSeek( &sseek, .t. )               && szuka wyniku wyraßenia
      if Eof(); DBGoTop(); endif
   endif
elseif !Empty( seekkey )
*   Czek( 1 )                                 && chodzi o subbazë
   private sseek := seekkey, bububu
   ON( Syn( baza) , Val( ind ), cat, rob )   && baza docelowa o pseudo rob
   ON( Syn( baza ), Val( ind ), cat, rob, .t. ) && ZAP rob w katalogu 'cat'
   ON( baza, Val( ind ))                          && baza ¶r¢díowa o pseudo
*  bububu := RunCommand( sseek )
*  DBSeek( bububu )                             && zmienionym z "B?A" na "B_A"
   set filter to
   DBSeek( &sseek )                             && zmienionym z "B?A" na "B_A"
   KopiaRec( Matka( baza ), rob, whilekey,, for_key ) && kopia z pseudo do "ROB"
   if !Empty( seekkey2 )
      DBSetOrder( Val( ind2 ))
      sseek := seekkey2
      set filter to
      DBSeek( &sseek )
      KopiaRec( Matka( baza ), rob, whilekey2,, for_key )
   endif
   Select( rob )
   baza := rob
   go top
*   Czek( 0 )
else
	ps := siec
	if 'ROBOCZY' $ cat; siec := .f.; 	endif		&& Exclusive
   ON( @baza, Val( ind ), cat )
	siec := ps
endif

if Left( DBE_Tyt, 1 ) == '&'
   DBE_Tyt := '{||'+SubStr( DBE_Tyt, 2 )+'}'
   bl_napis := &DBE_Tyt
else
   bl_napis := { || DBE_Tyt }
endif

if Len( wsp ) > 5
   if !Empty( wsp[ 6 ])
		if ( Alias() # 'ROB' ) .and. ( seekkey # NIL ) .and. !Empty( seekkey )
			ps := RecNo()
			if ValType( &seekkey ) == 'N'
				DBSeek( &seekkey + 1, .t. )
			else
				DBSeek( &seekkey + 'zzzzz', .t. )
			endif
			DBSkip( -1 )
			globalbuf3 := RecNo()
			DBGoTo( ps )
   	   Keyboard Replicate( Chr( K_RIGHT ), Val( wsp[ 5 ]) - 1 ) +;
               Chr( K_PGUP ) + Chr( K_CTRL_PGDN ) + '~' +;
               if( Len( wsp ) > 6, wsp[ 7 ], '' ) +;
               if( PressKey # NIL, PressKey, '' )
		else
	      go bottom
   	   Keyboard Replicate( Chr( K_RIGHT ), Val( wsp[ 5 ]) - 1 ) +;
               Chr( K_PGUP ) + Chr( K_CTRL_PGDN ) +;
               if( Len( wsp ) > 6, wsp[ 7 ], '' ) +;
               if( PressKey # NIL, PressKey, '' )
		endif
   else
      Keyboard Replicate( Chr( K_RIGHT ), Val( wsp[ 5 ]) - 1 ) +;
               if( Len( wsp ) > 6, wsp[ 7 ], '' ) +;
               if( PressKey # NIL, PressKey, '' )
   endif
else
   Keyboard Replicate( Chr( K_RIGHT ), Val( wsp[ 5 ]) - 1 ) +;
               if( PressKey # NIL, PressKey, '' )
endif

if Len( wsp ) > 7 .and. !Empty( wsp[ 8 ])
   TAK_INVERS := ( wsp[8] == 't' )
endif

if Len( wsp ) > 8
   rob := Alias()
   for i := 9 to Len( wsp )
       RunCommand( wsp[ i ])
   next
   Select( rob )
endif

DBEFiltr( DBE_Filtr, 1 )

***************************************************************************

function Matka( baza )
baza := StrTran( baza, '?', '_' )
return baza

***************************************************************************

function Syn( baza )
baza := StrTran( baza, '_', '?' )
return baza

***************************************************************************
* Tworzenie tablicy string¢w z podanej linii
* jepu = jeden pusty
* musi konwertowaÊ maz => lat

function LineTab( line, liczby, jepu, musi )

local k, tab, sep := '|', cz, plik, i

if liczby = NIL; liczby := .f.; endif

tab := {}
if jepu # NIL
   Aadd( tab, '' )
endif

if Left( line, 2 ) == '##'
	line := SubStr( line, 2 )
else
	if Left( line, 1 ) == '#'
   	plik := ReadWzor( SubStr( line, 3 ))
	   line := MemoLine( plik, dl_memo, Val( SubStr( line, 2, 1 )),, .t. )
	endif
endif

if (musi<>NIL)
   line := Konwert(line,maz,lat,.t.)
endif

i := 0
while !Empty( line )
      i ++
      if ( k := At( sep, line )) = 0      && brak "|" na ko§cu
         k := Len( line ) + 1             && symulacja, ße jest
      endif
      cz := Left( line, k - 1 )
		if Len( cz ) > 1							&& jedna spacja moøe byÊ, ale nie wiÍcej !
	      cz := LTrim( Left( line, k - 1 ))
		endif
      if i < 3 .and. Left( cz, 1 ) == '.'
         cz := SubStr( cz, 2 )
         if !haker; tab := {}; exit; endif
      endif
      Aadd( tab, if( liczby, Val( cz ), cz ))
      line := SubStr( line, k + Len( sep ))
enddo

if       ( tab # NIL );
	.and. (     (( Len( tab ) > 0 ) .and. ( ValType( tab[ 1 ]) = 'C' ) .and. ( tab[ 1 ] = 'pozycja' ));
	       .or. (( Len( tab ) > 1 ) .and. ( ValType( tab[ 2 ]) = 'C' ) .and. ( tab[ 2 ] = 'pozycja' ));
         )
	global_buf4 := tab[ Len( tab )]
	bl_pozycja := { || &global_buf4 }
endif

return tab

***************************************************************************
* Wyûwietla linië opcji pod tabelÜ

procedure DBE_Linia( r )

local linia, przerwa, c , i , lit, lll, dwie := .f., x

przerwa := 0
lll := DBE_Function
AEval( lll, { |a| przerwa += Len( a[ 3 ])}) && ustalanie rozstawu
i := Len( lll ) - 1
i := if( i = 0, 1000, ( mc - przerwa ) / i )
przerwa := Min( i, 5 )   && najwyßej 5 spacji

linia := ''
AEval( lll , { |a| linia += a[ 3 ] + Space( przerwa ) } )

linia := Konwert(linia,maz,lat,.t.)
if ( rr[ 2 ] = 21 ) .and. ( Len( linia ) > mc )
	dwie := .t.
	@ r , 1 say ''
	?? linia := DwieLinie( linia, mc -1, 1 )
else
	@ r , 1 say PadR( linia , mc )
endif

SetColor( podkresl )
for i := 1 to Len( lll )
	lit := lll[ i, 2 ]         && wyíowienie literki z 'k'
	c := At( lit , linia )     && ustalenie miejsca w 'linia'
	x := r
	if c > mc
		c -= mc + 2
		x ++
	endif
	if c # 0 ; @ x, c say lit ; endif   && wyûwietlenie podûwietlonej literki
next
SetColor( STC )

******************************************************************************
* Help formularza
* 'v' ma zawieraç 'pole99'
* 'FormF1Blok' ma wskazywaç na tÜ procedurë

procedure FHelp( v, fp )

private GetList := {}

SetKey( K_F1 )
Eval( TabHelp[ fp[ Val( SubStr( v, 5 ))]], v )
SetKey( K_F1, FormF1Blok )

***************************************************************************

function SysForm( a )

private TabValid := {}
private TabHelp := {}

return Formularz( Odetnij( @a ), Odetnij( @a ), ( Odetnij( @a ) == 'tak' ))

***************************************************************************
* Ustawienie pewnych zmiennych formularza i uruchomienie go
* TabValid
* TabHelp

function Formularz( wzor, tyt, czysc )

local plik, wsp, rr, cc, buf, ekran := SaveScreen(), od, oe
local FTyt, FDod, FPoz, FPola, FTexty, FSzablony, FValidy, FHelpy, FWpisz

if czysc = NIL; czysc := .f.; endif

if wzor = NIL .or. wzor == ''
   wzor := baza + '.frm'
endif

if ( plik := ReadWzor( wzor )) == ''
   plik := DefWzor( baza, wzor, .t. )
endif

FTyt := ' ' + if( Empty( tyt ), AllTrim( MemoLine( plik, dl_memo, 1,, .t. )), tyt ) + ' '
FDod := AllTrim( MemoLine( plik, dl_memo, 2,, .t. ))

FPola := LineTab( MemoLine( plik, dl_memo, 3,, .t. ), .t. )
FTexty := LineTab( MemoLine( plik, dl_memo, 4,, .t. ))
FSzablony := LineTab( MemoLine( plik, dl_memo, 5,, .t. ))
FValidy := LineTab( MemoLine( plik, dl_memo, 6,, .t. ), .t. )
FHelpy := LineTab( MemoLine( plik, dl_memo, 7,, .t. ), .t. )

wsp := LineTab( MemoLine( plik, dl_memo, 8 ), .t. )
rr := { wsp[ 1 ], wsp[ 3 ]}
cc := { wsp[ 2 ], wsp[ 4 ]}
Keyboard Replicate( Chr( K_DOWN ), wsp[ 5 ] - 1 )

private np, snp
FPoz := {}
for np := 1 to Len( FPola )
    snp := AllTrim( Str( np ))
    private pole&snp := FieldGet( FPola[ np ])
    Aadd( FPoz, LineTab( MemoLine( plik, dl_memo, np + 8,, .t. ), .t. ))
next

if czysc
   @ 2, 0 clear
else
   @ rr[ 1 ], cc[ 1 ] clear to rr[ 2 ], cc[ 2 ]
   @ mr - 2, 0 clear
endif

Esc()
PgDn()
RRamka( rr , cc )
if !Empty( FTyt ); CSay( rr[ 1 ] - 1, cc[ 1 ], cc[ 2 ], FTyt, jasny ); endif
if !Empty( FDod ); CSay( rr[ 2 ] - 1, cc[ 1 ], cc[ 2 ], FDod, jasny ); endif

for np := 1 to Len( FPola )
    snp := AllTrim( Str( np ))
    @ rr[ 1 ] + FPoz[ np, 1 ], cc[ 1 ] + FPoz[ np, 2 ];
      say FTexty[ np ];
      get pole&snp;
      picture FSzablony[ np ];
      valid if( np > Len( TabValid ), .t., Eval( TabValid[ FValidy[ np ]]))
next

private FormF1Blok := { |p,l,v| FHelp( v, FPola )}
private hF1_oryg := SetKey( K_F1, FormF1Blok )
private hF4_oryg := SetKey( K_F4, { || Opis( cat_wzorow + wzor, .t. )})

         od := SetKey( K_CTRL_INS,  { || ToClip()})
         oe := SetKey( K_ALT_INS,   { || FromClip()})

FWpisz := Read()

         SetKey( K_CTRL_INS,   od )
         SetKey( K_ALT_INS,    oe )

SetKey( K_F1, hF1_oryg )
SetKey( K_F4, hF4_oryg )

if FWpisz .and. Rekord_OK()
   wy := 2
   for np := 1 to Len( FPola )
       snp := AllTrim( Str( np ))
       buf := pole&snp
       Blokuj_R()
       FieldPut( FPola[ np ], buf )
   next
   Rekord_Free()
else
   FWpisz := .f.
endif

RestScreen( ,,,, ekran )

return FWpisz

***************************************************************************
* Ma przygotowaç rekord do wpisania danych

function Rekord_OK

if !siec; return .t.
else
   Blokuj_R()
   return .t.
endif

***************************************************************************
* Ma zwolniç rekord do dalszego ußycia

function Rekord_Free

if !siec; return .t.
else
   OdBlokuj_R()
   return .t.
endif

***************************************************************************

function DefWzor( baza, wzor, formularz )

local l0 := '', l1 := '', l2 := '', l3 := '', plik, i := 0, k

if formularz = NIL; formularz := .f.; endif

ON( SysBaz )
DBSeek( Upper( baza ))
while RTrim( Upper( DBF_NAME )) = Upper( baza ) .and. DBF_LP < 90 .and. !Eof()
      i ++
      l0 += AllTrim( Str( i )) + '|'
      l1 += AllTrim( DBF_FIELD ) + '|'
      l3 += StrTran( AllTrim( DBF_OPIS ), ' ', ';' ) + '|'
      l2 += Replicate( if( DBF_TYPE == 'C', 'X', '9'),;
            Min( DBF_LEN - if( DBF_DEC # 0, DBF_DEC + 1, 0 ), 5 ))
      if DBF_DEC # 0
         l2 += '.' + Replicate( if( DBF_TYPE == 'C', 'X', '9'), DBF_DEC )
      endif
      l2 += '|'
      skip
enddo

if formularz
   k := i
   plik := 'Modyfikacja danych' + EOL +;
           'F1 - pomoc' + EOL +;
            l0 + EOL +;
            l1 + EOL +;
            l2 + EOL +;
            l0 + EOL +;
            l0 + EOL +;
            '5|3|20|70|1|'
   for i := 1 to k
       plik += EOL + AllTrim( Str( i )) + '|2|'
   next
else
   plik := l1 + EOL + l3 + EOL + l2 + EOL +;
          '5|1|22|78|1|' + EOL + 'Baza danych "' + baza + '"'+;
           EOL + EOL + '5|Esc|Esc - wyjûcie|'
endif

MemoWrit( cat_wzorow + wzor, plik )

return plik

***************************************************************************

procedure Popraw( a, b, xx, nn, kk1, kk2 )

local ok

a := if( a = NIL, '', a )
ok := Len( a ) > 3

private GetList := {}, nr

if nn # NIL
   nr := nn
else

   nr := if( xx # NIL, xx, Val( Odetnij( @a )))

if ok

private no := Val( Odetnij( @a ))   && numer kolumny podstawowej
private k1 := Val( Odetnij( @a ))   && kolumna por¢wnywana wiëksza
private k2 := Val( Odetnij( @a ))   && kolumna por¢wnywana mniejsza

if no # nr
   Keyboard Chr( K_CTRL_HOME ) + if( no = 1, '', Chr( K_END )) + Chr( K_ENTER )
   return
endif

endif
endif

private bufor, row := rr[ 2 ] + 2
private ekran := SaveScreen( row, 0, mr, mc )

bufor := kolumny[ nr ]

*if ( "->" $ bufor ) .or. ( "(" $ bufor )
if ( "(" $ bufor )
   clear gets
else
   @ row , 0 clear
   if ok; CSay( row, 0, mc, 'Esc - koniec wpisywania wartoûci', miga )
   else ; CSay( row, 0, mc, '', miga )
   endif
   if nr <= Len( szablon )
      @ r , c get &bufor picture KK( szablon[ nr ])
   else
      @ r , c get &bufor
   endif
   Blokuj_R()
   if Read(); zmiana := .t.; endif
   OdBlokuj_R()
endif

do case
   case kk1 = NIL
        if ok; Zakoncz( nr, b ); endif
   case LastKey() = K_ENTER .and. kk1 # NIL .and. kk2 = NIL; Keyboard Chr( kk1 )
   case LastKey() = K_ENTER .and. kk1 # NIL .and. kk2 # NIL; Keyboard Chr( kk1 ) + kk2
endcase
RestScreen( row, 0, mr, mc, ekran )

******************************************************************************

procedure Zakoncz( nr, b )

if !Empty( DOKUMENT->MAG1 ) .and. ( &( kolumny[ k1 ]) < &( kolumny[ k2 ]))
   if Alarm( 'Przekroczono stan magazynu !!! Co wpisaç ?',;
           { 'Iloûç = STAN', 'Pozostawiç iloûç ...' }) = 1
      private buf := kolumny[ k2 ]
      replace &buf with &( kolumny[ k1 ])
   endif
endif

do case
case LastKey() = K_ESC; Lastzero()
case Eoff() .and. nr # 1; Keyboard Chr( K_CTRL_HOME ) + Chr( K_DOWN )
otherwise
   if DBE_ADD # NIL; Eval( DBE_ADD, nr, b ); endif
endcase

******************************************************************************

function Eoff()

local koniec

skip
koniec := Eof()
skip -1
return koniec

******************************************************************************

procedure Pokoloruj( r1, c1, r2, c2, k, n )

local ekran
if c2 < 0; c2 := -c2; r2 ++; endif
ekran := SaveScreen( r1, c1, r2, c2 )
ekran := StrTran( ekran, Chr( if( k = NIL, 7, k )), Chr( if( n = NIL, 112, n )))
RestScreen( r1, c1, r2, c2, ekran )

******************************************************************************

function KK( s )

if '@' $ s
   s := StrTran( s, '@S', '@KS' )
   s := StrTran( s, '@Z', '@K' )
else
   s := '@K ' + s
endif

return s

******************************************************************************

function Mi( s, c )

local n

n := - At( ';', s )
if n = 0
   n := Len( s ) + c
else
   n := n - c
endif

return n

******************************************************************************

*function Przerwa

*if Inkey() # 0
*   if LastKey() = K_ESC
*      return Alarm( 'Wciûniëto klawisz "ESC" !!!',;
*                  { 'Przerwaç operacjë', 'Kontynuowaç' }) = 1
*   endif
*   LastZero()
*endif

*return .f.

******************************************************************************

function Przerwa( w, ss, bezESC )

static pp := 0, kk := 1, pscreen := ''
static time_0 := 0, time_1 := '', dryf := .f., delta := 0, r, c, dr, dc

if ss # NIL
   set device to screen
endif

if w = NIL
   pp ++
   if !dryf
      delta := Val( StrTran( Time(), ':', '' )) - time_0
      if delta > 10
         dryf := .t.
         pscreen := SaveScreen()
         @ 0, 0 clear
         print_ok := .f.
      endif
      if pp # kk; @ r, c say AllS( 100*pp/kk, '999%' ); endif
   elseif Time() # time_1
      time_1 := Time()
      @ r, c say '    '
      r += dr
      c += dc
      if r >= mr
         r := mr
         dr := -1
      elseif r < 0
         r := 0
         dr := 1
      endif
      if c >= mc
         c := mc
         dc := -1
      elseif c < 0
         c := 0
         dc := 1
      endif
      @ r, c say AllS( 100*pp/kk, '999%' )
   endif
else
   do case
      case w > 0                                  && INIT
           r := 0
           c := 40
           pp := 0
           kk := w
           dr := 1
           dc := 1
           dryf := .f.
           time_0 := Val( StrTran( Time(), ':', '' ))
           time_1 := Time()
      case w = 0
           if !Empty( pscreen )
              RestScreen( ,,,, pscreen )          && DONE
           endif
           @ 0, 40 say '    '
           pscreen := ''
           dryf := .f.
           pp := 0
   endcase
endif

if Inkey() # 0 .and. w = NIL
   if !Empty( pscreen )
      RestScreen( ,,,, pscreen )           && DONE
   endif
   pscreen := ''
   r := 0
   c := 40
   dr := 1
   dc := 1
   dryf := .f.
   print_ok := .t.
   if bezESC = NIL .and. LastKey() = K_ESC
      w := Alarm( 'Wciûniëto klawisz "ESC" !!!',;
                { 'Przerwaç operacjë', 'Kontynuowaç', 'Wyjûcie z programu' })
      if w = 3; OpuscSys(1); endif
      if ss # NIL
         set device to printer
      endif
      return w = 1
   endif
   time_0 := Val( StrTran( Time(), ':', '' ))
   time_1 := Time()
   LastZero()
endif

if ss # NIL
   set device to printer
endif

return .f.

******************************************************************************

procedure Duble( nr )

local x, y, n, jest := .f., rr := RecNo()

if nr = NIL; return; endif

x := &( kolumny[ nr ] )
skip
Przerwa( LastRec())
while !Eof()
      y := &( kolumny[ nr ] )
      if x = y
         jest := .t.
*         exit
BDelete()
      endif
      x := y
      skip
      if Przerwa(); exit; endif
enddo
Przerwa( 0 )
wy := 2

if !jest
   Alarm( 'Brak dalszych dubli' )
   DBGoTo( rr )
endif

******************************************************************************
* Wyszukiwanie braku chronologii w inkrementowanych pozycjach typu Lp, Pz

procedure Niechrony( nr )

local x, y, n, jest := .f., rr := RecNo()
local x_wzgledem, y_wzgledem

private pole_wzgledem

if nr = NIL; return; endif

pole_wzgledem := Get_U( 10, 5, 'Podaj nazwë pola wzglëdem kt¢rego ma byç chronologia:', '@KS10', PadR( 'DATA', 10 ))
if pole_wzgledem # NIL .and. Empty( pole_wzgledem )
   pole_wzgledem := NIL
endif

x := &( kolumny[ nr ] )         && stoimy tu
if ValType( x ) == "C"
   x := AllTrim( x )
   while !IsDigit( x ) .and. !Empty( x )
         x := SubStr( x, 2 )
   enddo

   x := Val( x )
endif
if pole_wzgledem # NIL; x_wzgledem := &( pole_wzgledem ); endif
skip
Przerwa( LastRec())
while !Eof()
      y := &( kolumny[ nr ])        && nastëpna pozycja
      if ValType( y ) == "C"
         y := AllTrim( y )
         while !IsDigit( y ) .and. !Empty( y )
               y := SubStr( y, 2 )
         enddo
         y := Val( y )
      endif
      if pole_wzgledem = NIL        
         if x = y                   && ten sam numer dokumentu
         elseif x + 1 = y           && lub o jeden wiëkszy
         elseif y = 1               && lub r¢wny 1, czyli od poczÜtku
         else
            jest := .t.
            exit
         endif
      else
         y_wzgledem := &( pole_wzgledem )
         if x_wzgledem = y_wzgledem    && ten sam dzie§
            if x = y                   && ten sam numer dokumentu
            elseif x + 1 = y           && lub o jeden wiëkszy
            else
               jest := .t.
               exit
            endif
         endif
         x_wzgledem := y_wzgledem
      endif
      x := y
      skip
      if Przerwa(); exit; endif
enddo
Przerwa( 0 )
wy := 2

if !jest
   Alarm( 'Koniec' )
   DBGoTo( rr )
endif

******************************************************************************

procedure UseKryteria( nr )

local x, sc
private bufor := 'C:\TmpBufor'

if Empty( Kryteria )
	SetKryteria( nr )
endif

sc := SaveScreen()
SetKryteria(,1)	&& show only
set cursor on
set cursor off
x := Alarm( 'Operacja z buforem (B):', { 'Import z B', 'Kopiuj do B', 'PrzesuÒ do B' }, 1 )
if x = 0
	RestScreen( ,,,, sc )
	return
endif

bufor := PadR( bufor, 120 )
if ( bufor := Get_U( 23, 1, 'Podaj parametry bufora:', '@S50', bufor )) = NIL
	RestScreen( ,,,, sc )
	return
endif
bufor := AllTrim( bufor )

KryteriaS := 2				&& uøyj ale nie drukuj
Czek( 1 )
do case
case x = 1
		append from &bufor for KryteriaOK()
		zmiana := .t.
		DBSetOrder( 0 )
		Keyboard Chr( K_PGUP ) + Chr( K_CTRL_PGDN )
case x = 2; copy to &bufor for KryteriaOK()
case x = 3; copy to &bufor for KryteriaOK()
		DBEval({|| BDelete()}, {||KryteriaOK()})
		zmiana := .t.
endcase
Czek( 0 )
RestScreen( ,,,, sc )
wy := 2

******************************************************************************
* show # NIL => pokaø i sio bez czyszczenia ekranu

procedure SetKryteria( nr, show )

local od, do, na, sc := SaveScreen()

if nr # NIL

od := &( kolumny[ nr ])
do := od

na := StrTran( naglowki[ nr ], ';', ' ' )
na := StrTran( na, '- ', '' )
na := '"' + na + '"'

if Ana_Daty_B .and. ValType( od ) == "D"
	do := Datee()
endif

if Get_Okres( @od, @do, 'Podaj zakres dla pola ' + na ) # NIL

if Empty( Kryteria )
   Kryteriau := ''
else
   Kryteria += EOL + '.and.' + EOL
endif

if !Empty( Kryteriau )
   Kryteriau += EOL + 'oraz' + EOL
endif

if ValType( od ) == "C"
   od := AllTrim( od )
   do := AllTrim( do )
   od := StrTran( od, '_', ' ' )
   do := StrTran( do, '_', ' ' )
   Kryteria += '((' + "'" + od + "'" + '<=' + kolumny[ nr ] + ').and.('
   Kryteria +=                      kolumny[ nr ] + '<='+ "'" + do + "'" + '))'
   if od == do
      Kryteriau+= na + ' o treûci "' + od + '"'
   else
      Kryteriau+= na + ' z zakresu od "' + od + '" do "' + do + '"'
   endif
elseif ValType( od ) == "D"
   Kryteria += '(("' + DtoS( od ) + '"<=DtoS(' + kolumny[ nr ] + ')).and.('
   Kryteria +=                         'DtoS(' + kolumny[ nr ] + ')<="' + DtoS( do ) + '"))'
   if od == do
      Kryteriau+= na + ' z dnia "' + DtoC( od ) + '"'
   else
      Kryteriau+= na + ' z okresu: ' + DtoC( od ) + ' - ' + DtoC( do )
   endif
else
   od := AllS( od )
   do := AllS( do )
   Kryteria += '((' + od + '<=' + kolumny[ nr ] + ').and.('
   Kryteria +=                    kolumny[ nr ] + '<=' + do + '))'
   if od == do
      Kryteriau+= na + ' o wartoûci r¢wnej ' + od
   else
      Kryteriau+= na + ' z zakresu: ' + od + ' ˆ ' + do
   endif
endif
endif
endif

if !Empty( Kryteriau ) .and. !Empty( Kryteria )
   @ 3, 0 clear
   Edit( Kryteriau, 'Kryteria uwzglëdniania danych (wersja dla ußytkownika)',,,, 12,, 1 )
   Edit( Kryteria, 'Kryteria uwzglëdniania danych (wersja dla komputera)',, 15,, 20,, 1 )
	if show # NIL; return; endif
   while .t.
         Kryteriau := MemoEdit( Kryteriau, 4, 1, 12, 78, .t., '', 200 ); if LastKey() = K_ESC; exit; endif
         Kryteria := MemoEdit( Kryteria,15, 1, 20, 78, .t., '', 200 ); if LastKey() = K_ESC; exit; endif
   enddo
   if Empty( Kryteriau )   && czyszczenie przez ußytkownika
      Kryteria := ''
   endif

   RestScreen( ,,,, sc )

endif

******************************************************************************

function KryteriaOK( xxx )

xxx := Kryteria

if KryteriaS = 0; return .t.; endif

xxx := StrTran( xxx, EOL, '' )
xxx := &xxx

return xxx

******************************************************************************
* Zapytaj co z kryterium

procedure KryteriaAsk()

local od

if Empty( Kryteria )
   KryteriaS := 0    && starus = 0 => nie ußywaç
   return
endif

while .t.

      od := Alarm( 'Jest okreûlone kryterium uwzglëdniania danych',;
                 { 'Ußyç i wydrukowaç',;
                   'Ußyç, ale nie drukowaç',;
                   'Nie ußywaj = Esc',;
                   'Pokazaç',;
                   'Wymazaç' })

      do case
      case od = 0; KryteriaS := 0
      case od = 1; KryteriaS := 1     && Ußyç i wydrukowaç
      case od = 2; KryteriaS := 2     && Ußyç, ale nie drukowaç
      case od = 3; KryteriaS := 0
      case od = 4; SetKryteria(); loop
      case od = 5; KryteriaS := 0; Kryteria := ''
      endcase

      exit

enddo

******************************************************************************

procedure CompareDBF()

local cat := '\FK.03', bb := Alias(), i, ok := .t., sc := SaveScreen(), s

cat := Get_U( 10, 10, 'Podaj katalog podobnej bazy danych:', '@S20', PadR( cat, 50 ))
if cat = NIL; return; endif
cat := AllTrim( cat )

*DBSetOrder( 0 )

ON( bb, IndexOrd(), cat, 'PODOBNA' )
DBGoTo(( bb )->( RecNo()))

Select( bb )
*set filter to
*go top
while !Eof()
		ok := .t.
		for i := 1 to FCount()
			if FieldGet( i ) # PODOBNA->( FieldGet( i ))
				ok := .f.
				exit
			endif
		next
		if !ok
			cls
			CSay( 0, 0, mc/2, 'Obecna baza (' + AllS( RecNo()) + ')' )
			CSay( 0, mc/2, mc, 'Podobna baza (' + AllS( PODOBNA->( RecNo())) + ')' )
			for i := 1 to FCount()
				if FieldGet( i ) # PODOBNA->( FieldGet( i ))
					SetColor( 'I' )
				endif
				@ i, 0 say ''
				s := FieldName( i ) + '='
				if ValType( FieldGet( i )) == 'C'
					s += FieldGet( i )
					?? PadR( s, 40 )
				else
					?? s
					?? FieldGet( i )
				endif
				SetColor( STC )
			next
			for i := 1 to FCount()
				if FieldGet( i ) # PODOBNA->( FieldGet( i ))
					SetColor( 'I' )
				endif
				@ i, 40 say ''
				s := PODOBNA->( FieldName( i )) + '='
				if ValType( PODOBNA->( FieldGet( i ))) == 'C'
					s += PODOBNA->( FieldGet( i ))
					?? PadR( s, 40 )
				else
					?? s
					?? PODOBNA->( FieldGet( i ))
				endif
				SetColor( STC )
			next
			?
			? "Press any key (Esc=exit, Home,End=lewa, PgUp,PgDn=prawa, lewo,prawo=transfer)"
			Inkey( 0 )
			do case
			case LastKey() = K_ESC  ; exit
			case LastKey() = K_HOME ; skip -1
			case LastKey() = K_END  ; skip  1
			case LastKey() = K_PGUP ; PODOBNA->( DBSkip( -1 ))
			case LastKey() = K_PGDN ; PODOBNA->( DBSkip(  1 ))
			case LastKey() = K_LEFT
					if Alarm( 'Kopia danych z prawej na lewo ?   <---', nt ) = 2
						Blokuj_R()
						for i := 1 to FCount()
							FieldPut( i, PODOBNA->( FieldGet( i )))
						next
						OdBlokuj_R()
					endif
			case LastKey() = K_RIGHT
					if Alarm( 'Kopia danych z lewej na prawo ?   --->', nt ) = 2
						PODOBNA->( Blokuj_R())
						for i := 1 to FCount()
							PODOBNA->( FieldPut( i, ( bb )->( FieldGet( i ))))
						next
						PODOBNA->( OdBlokuj_R())
					endif
			otherwise
				skip
				PODOBNA->( DBSkip())
			endcase
			if PODOBNA->( Eof())
				exit
			endif
		else
			skip
			PODOBNA->( DBSkip())
			if PODOBNA->( Eof())
				exit
			endif
		endif
enddo

RestScreen(,,,,sc)

******************************************************************************

procedure SetKolumna( nr )

local h := 'if(Empty(PSEUDO),NAZWA,PSEUDO)', rr := RecNo()

if Alarm( 'Operacja na kolumnie "' + kolumny[ nr ] + '" ?', nt ) # 2; return; endif

h := StrTran( h, 'PSEUDO', kolumny[ nr ])
h := Get_U( 15, 5, 'Operacja: ', '@S30', PadR( h, 99 ))
if h = NIL; return; endif
h := AllTrim( h )

DBSetOrder( 0 )
set filter to
go top
while !Eof()
		Blokuj_R()
		RunCommand( Alias() + '->' + kolumny[ nr ] + ':=' + h )
		OdBlokuj_R()
		skip
enddo

DBGoTo( rr )

******************************************************************************









