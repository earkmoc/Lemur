<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

//-----------------------------------------------
//Zmiany struktur:

$widok=$tabela='slownik'; require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");
mysqli_query($link, $q="ALTER TABLE `slownik` CHANGE `OPIS` `OPIS` text NOT NULL DEFAULT ''");
if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}

do
{
	mysqli_query($link, $q="ALTER TABLE `slownik` ADD UNIQUE `TST` (`TYP`, `SYMBOL`, `TRESC`)");
	if ($e=mysqli_error($link)) {
//			die($e.'<br><br>'.$q);
		$x=explode(" ",$e);
		if	( ($x[0]=='Duplicate')
			&&($x[1]=='key')
			&&($x[2]=='name')
			)
		{
			break;
		}

//	die(mysqli_error($link));
		$x=explode("'",$e);
		$x=explode('-',$x[1]);
		if	( ($x[0]=='parametry')
			&&($x[1]=='SrodkiTr')
			&&($x[2]=='rok')
			)
		{
			mysqli_query($link, $q="
				delete 
				from `slownik` 
				where TYP='parametry'
				  and SYMBOL='SrodkiTr'
				  and TRESC='rok'
			");
		}
		elseif	( ($x[0]=='parametry')
			&&($x[1]=='REJVAT')
			&&($x[2]=='data')
			)
		{
			mysqli_query($link, $q="
				delete 
				from `slownik` 
				where TYP='parametry'
				  and SYMBOL='REJVAT'
			");
		}
		elseif	( ($x[0]=='parametry')
			&&($x[1]=='STR')
			&&($x[2]=='data')
			)
		{
			mysqli_query($link, $q="
				delete 
				from `slownik` 
				where TYP='parametry'
				  and SYMBOL='STR'
			");
		}
		elseif	( ($x[0]=='parametry')
			&&($x[1]=='wydruk1')
			&&($x[2]=='tytul')
			)
		{
			mysqli_query($link, $q="
				delete 
				from `slownik` 
				where TYP='parametry'
				  and SYMBOL='wydruk1'
			");
		}
		else
		{
			die($e.'<br><br>'.$q);
		}
	}
} while ($e);

//zapomnij konkretny dokument, wiêc w podtabelach (Rejestry VAT, Towary, Dekrety) poka¿e wszystko
foreach($_SESSION as $key => $value)
{
	if	( (strtoupper(substr($key,0,strlen($baza)))==strtoupper($baza))
		&&(substr($key,-4,4)=='ID_D')
		)
	{
		unset($_SESSION[$key]);
	}
}

//zapomnij konkretny rejestr
unset($_SESSION['rejestr']);
unset($_SESSION['rejestrName']);
unset($_SESSION['rejestrOkres']);

//niezbedne do importu DBF, który moze byc wykonany bez wchodzenia w cokolwiek
$widok=$tabela='schematy';  require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");
$widok=$tabela='schematys'; require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");
$tabela='knordpol'; $widok=$tabela.'2'; require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

// ----------------------------------------------
// Parametry widoku

$title=$baza.': Menu';
$tabela='menu';

mysqli_query($link, "ALTER TABLE `$tabela` CHANGE `SKROT` `SKROT` CHAR(20) NOT NULL DEFAULT ''");
mysqli_query($link, "ALTER TABLE `$tabela` ADD `LP` INT(11) NOT NULL DEFAULT 99 AFTER `ID`");

$widok=$tabela;
$mandatory='';
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

//----------------------------------------------

$params="idTabeli=$idTabeli&row='+row+'&col='+col+'&str='+str+'&id=";
$enter="saveTablePosition.php?next=http://{$_SERVER['HTTP_HOST']}/$baza/'+GetCol(3)+'/&$params'+GetID()+'";
$formularz="../Formularz/?$params'+GetID()+'";
$dopisz="../Formularz/?{$params}0'+'";
$usun="usun.php?$params'+GetID()+'";

$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>'/Lemur2/Klienci/?baza='.$baza);
//$buttons[]=array('klawisz'=>'Enter','nazwa'=>'Enter=wej¶cie','akcja'=>"saveTablePosition.php?next=http://{$_SERVER['HTTP_HOST']}/'+GetCol(2)+'/KPiR'+'");
$buttons[]=array('klawisz'=>'Enter','nazwa'=>'Enter=wej¶cie','akcja'=>$enter);
$buttons[]=array('klawisz'=>'AltF','nazwa'=>'Formularz','akcja'=>$formularz);
$buttons[]=array('klawisz'=>'AltD','nazwa'=>'Dopisz','akcja'=>$dopisz);
$buttons[]=array('klawisz'=>'AltS','nazwa'=>'Szukaj','js'=>"$('#modalSzukaj').modal('show')");
//$buttons[]=array('klawisz'=>'AltU','nazwa'=>'Usuñ','atrybuty'=>" type='button' data-toggle='modal' data-target='#myModal'");
$buttons[]=array('klawisz'=>'AltU','nazwa'=>'Usuñ','akcja'=>$usun);
$buttons[]=array('klawisz'=>'AltI','nazwa'=>'Import','akcja'=>"/$baza/ImportDBF/");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/navigationButtons.php");
