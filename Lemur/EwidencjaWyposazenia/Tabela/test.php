<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/class.Wydruk.php");
$wydruk=new Wydruk($_GET);

if($wydruk->ParametryUstalone())
{
//	$wydruk->Drukuj();
}
else
{
	$wydruk->DefTitle('Ewidencja wyposa�enia');

	$buttons=array();
	$buttons[]=array('klawisz'=>'AltD','nazwa'=>'Enter=Drukuj','akcja'=>"test.php?$wydruk->parametry");
	$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powr�t','akcja'=>"..");

	$fields=array();
	$fields[]=array('label'=>'Tytu� wydruku','labelSize'=>3,'fieldName'=>'tytul','fieldSize'=>9);
	$fields[]=array('label'=>'Ilo�� pozycji na pierwszej stronie','labelSize'=>3,'fieldName'=>'strona1','fieldSize'=>1);
	$fields[]=array('label'=>'Nag��wek na dalszych stronach','labelSize'=>3,'fieldName'=>'naglowekN','fieldSize'=>4,'fieldType'=>'textarea','fieldRows'=>3);
	$fields[]=array('label'=>'Ilo�� pozycji na dalszych stronach','labelSize'=>3,'fieldName'=>'stronaN','fieldSize'=>1);
	$fields[]=array('label'=>'Nazwa czcionki','labelSize'=>3,'fieldName'=>'czcionka','fieldSize'=>2);
	$fields[]=array('label'=>'Wielko�� czcionki','labelSize'=>3,'fieldName'=>'wielkosc','fieldSize'=>1);

	$wydruk->Formularz($buttons,$fields);
}
