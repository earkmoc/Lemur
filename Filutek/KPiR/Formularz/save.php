 <?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

if ($idd=@$_SESSION["{$baza}DokumentyID_D"])
{
	$_POST['ID_D']=$idd;
	$dokument=mysqli_fetch_array(mysqli_query($link, "select * from dokumenty where ID=$idd"));
	$_POST['DATA']=$dokument['DOPERACJI'];
	$_POST['NRDOW']=$dokument['NUMER'];
	$_POST['NRKONT']=$dokument['NRKONT'];
	$_POST['PSKONT']=$dokument['PSKONT'];
	$_POST['NIP']=$dokument['NIP'];
	$_POST['NAZWA']=$dokument['NAZWA'];
	$_POST['ADRES']=$dokument['ADRES'];
	$_POST['OPIS']=$dokument['PRZEDMIOT'];
}

$_POST['PRZYCHOD1'] =str_replace(',','.',$_POST['PRZYCHOD1']);
$_POST['PRZYCHOD2'] =str_replace(',','.',$_POST['PRZYCHOD2']);
$_POST['WYNAGRODZENIA'] =str_replace(',','.',$_POST['WYNAGRODZENIA']);
$_POST['POZOSTALE'] =str_replace(',','.',$_POST['POZOSTALE']);

$_POST['KTO']=$_SESSION['osoba_id'];

$_POST['PRZYCHOD3']=$_POST['PRZYCHOD1']+$_POST['PRZYCHOD2'];
$_POST['RAZEM']=$_POST['WYNAGRODZENIA']+$_POST['POZOSTALE'];

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveFormFields.php");
