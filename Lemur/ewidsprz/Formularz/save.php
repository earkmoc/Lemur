 <?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

if ($idd=@$_SESSION["{$baza}DokumentyID_D"])
{
	$_POST['ID_D']=$idd;
	$dokument=mysqli_fetch_array(mysqli_query($link, "select * from dokumenty where ID=$idd"));
//	$_POST['DATAW']=$dokument['DOPERACJI'];
//	$_POST['DATA']=$dokument['DDOKUMENTU'];
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
$_POST['PRZYCHOD3'] =str_replace(',','.',$_POST['PRZYCHOD3']);

$_POST['KTO']=$_SESSION['osoba_id'];

$_POST['PRZYCHODR']=$_POST['PRZYCHOD1']+$_POST['PRZYCHOD2']+$_POST['PRZYCHOD3'];

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveFormFields.php");
