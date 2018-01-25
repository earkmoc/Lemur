<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

// ----------------------------------------------
// Ustaw/pobierz rok sprawozdawczy

$rok=substr($baza,-4,4)*1;
$rok=($rok>2000?$rok:date('Y'));
$sets="TYP='parametry'
   , SYMBOL='SrodkiTr'
   , TRESC='rok'
   , OPIS='$rok'
";
mysqli_query($link,$q="
				  insert 
					into slownik
					 set $sets
 on duplicate key update ID=ID
");
if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}

$rok=mysqli_fetch_row(mysqli_query($link,$q="
				  select OPIS 
					from slownik
				   where TYP='parametry'
					 and SYMBOL='SrodkiTr'
					 and TRESC='rok'
"))[0];
if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}

// ----------------------------------------------
// Parametry widoku

$title="¦rodki trwa³e: rok $rok";
$tabela='srodkitr';
$widok=$tabela;
$mandatory='';
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

$params="idTabeli=$idTabeli&row='+row+'&col='+col+'&str='+str+'&id=";
$formularz="../Formularz/?$params'+GetID()+'";

$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>"saveTablePosition.php?next=http://{$_SERVER['HTTP_HOST']}/$baza/Menu/&$params'+GetID()+'");
$buttons[]=array('klawisz'=>'Enter','nazwa'=>'','akcja'=>$formularz);
$buttons[]=array('klawisz'=>'AltF','nazwa'=>'Enter=Formularz','akcja'=>$formularz);
$buttons[]=array('klawisz'=>'AltD','nazwa'=>'Dopisz','akcja'=>"../Formularz/?{$params}0'+'");
$buttons[]=array('klawisz'=>'AltC','nazwa'=>'Copy','akcja'=>"../Formularz/?$params-'+GetID()+'");
$buttons[]=array('klawisz'=>'AltS','nazwa'=>'Szukaj','js'=>"$('#modalSzukaj').modal('show')");
$buttons[]=array('klawisz'=>'AltU','nazwa'=>'Usuñ','akcja'=>"usun.php?$params'+GetID()+'");
$buttons[]=array('klawisz'=>'AltP','nazwa'=>'Przelicz','akcja'=>"przeliczanie.php?$params'+GetID()+'");
$buttons[]=array('klawisz'=>'AltW','nazwa'=>'Wydruk','akcja'=>"Wydruk.php?wydruk=Raporta&natab=$tabela&strona1=15&stronan=20&tytul=¦rodki trwa³e: rok $rok");
$buttons[]=array('klawisz'=>'Alt1','nazwa'=>'1=plan','akcja'=>"Wydruk.php?wydruk=Raporta&natab={$tabela}P&strona1=15&stronan=20&tytul=Plan amortyzacji ¶rodków trwa³ych: rok $rok");
$buttons[]=array('klawisz'=>'Alt2','nazwa'=>'2=ksiêga','akcja'=>"Wydruk.php?wydruk=Raporta&natab={$tabela}K&strona1=15&stronan=20&tytul=Ksiêga inwentarzowa ¶rodków trwa³ych: rok $rok");
$buttons[]=array('klawisz'=>'Alt3','nazwa'=>'3=tabela','akcja'=>"Wydruk.php?wydruk=Raporta&natab={$tabela}T&strona1=15&stronan=20&tytul=Tabela amortyzacji ¶rodków trwa³ych: rok $rok");
$buttons[]=array('klawisz'=>'Alt4','nazwa'=>'4=tabela 1','akcja'=>"Wydruk.php?wydruk=Raporta&natab={$tabela}1&strona1=15&stronan=20&tytul=Tabela amortyzacji ¶rodków trwa³ych: rok $rok");
$buttons[]=array('klawisz'=>'Alt5','nazwa'=>'5=tabela 2','akcja'=>"Wydruk.php?wydruk=Raporta&natab={$tabela}2&strona1=15&stronan=20&tytul=Tabela amortyzacji ¶rodków trwa³ych: rok $rok");
$buttons[]=array('klawisz'=>'AltA','nazwa'=>'Aktywne','akcja'=>"aktywne.php?$params'+GetID()+'");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
