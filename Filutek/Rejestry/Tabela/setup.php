<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

// ----------------------------------------------
// Parametry widoku

$title='Rejestry';
$tabela='slownik';
$widok=$tabela.'rej';
$mandatory='';
//$mandatory="$tabela.TYP='dokumentr' and $tabela.TRESC like 'Rejestr%'";
//mysqli_query($link, "ALTER TABLE `$tabela` ADD INDEX `SYMBOL` (`SYMBOL`)");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

//----------------------------------------------

$params="idTabeli=$idTabeli&row='+row+'&col='+col+'&str='+str+'&id=";
$esc="saveTablePosition.php?next=http://{$_SERVER['HTTP_HOST']}/$baza/Menu/&$params'+GetID()+'";
$enter="saveTablePosition.php?next=http://{$_SERVER['HTTP_HOST']}/$baza/RejestryVAT/Tabela/?rejestr='+GetCol(2)+','+GetCol(4)+','+GetCol(3)+'&$params'+GetID()+'";
$formularz="../Formularz/?$params'+GetID()+'";
$dopisz="../Formularz/?{$params}0'+'";
$kopia="../Formularz/?$params-'+GetID()+'";

$buttons=array();
$buttons[]=array('klawisz'=>'Enter','nazwa'=>'Enter=Pozycje','akcja'=>$enter);
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>$esc);
$buttons[]=array('klawisz'=>'F','nazwa'=>'Formularz','akcja'=>$formularz);
$buttons[]=array('klawisz'=>'D','nazwa'=>'Dopisz','akcja'=>$dopisz);
$buttons[]=array('klawisz'=>'C','nazwa'=>'Copy','akcja'=>$kopia);
$buttons[]=array('klawisz'=>'U','nazwa'=>'Usuñ','akcja'=>"usun.php?$params'+GetID()+'");
$buttons[]=array('klawisz'=>'O','nazwa'=>'Okres','akcja'=>"okresGet.php?$params'+GetID()+'");
$buttons[]=array('klawisz'=>'S','nazwa'=>'Szukaj','js'=>"$('#modalSzukaj').modal('show')");
$buttons[]=array('klawisz'=>'W','nazwa'=>'Wydruk','akcja'=>"Wydruk.php?wydruk=Raporta&batab=$tabela&natab=$widok&strona1=15&stronan=20&tytul=Rejestry VAT");
$buttons[]=array('klawisz'=>'1','nazwa'=>'1=sprzeda¿','akcja'=>"Wydruk.php?wydruk=Raporta&batab=$tabela&natab=slownikzes&strona1=15&stronan=20&tytul=Rejestry VAT - zestawienie sprzeda¿y");
$buttons[]=array('klawisz'=>'2','nazwa'=>'2=zakup','akcja'=>"Wydruk.php?wydruk=Raporta&batab=$tabela&natab=slownikzez&strona1=15&stronan=20&tytul=Rejestry VAT - zestawienie zakupów");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");

require("update_dokumentr.php");
