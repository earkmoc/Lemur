<?php
//die(print_r($_GET));
//die(print_r($_POST));
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$_POST['KTO']=$_SESSION['osoba_id'];
$_POST['CZAS']=date('Y-m-d H:i:s');
$_POST['CZYROZLICZAC']=($_POST['CZYROZLICZAC']?1:'');

$id=$_GET['id'];
if($id)
{
	$rok='';
	foreach($_POST as $key => $value)
	{
		if($key*1>0)
		{
			$rok=substr($key,0,4);
			break;
		}
	}

	if($rok)
	{
		mysqli_query($link, $q="delete from absencje where ID_D=$id and left(DATA,4)='$rok'");
		if (mysqli_error($link)) {
			die(mysqli_error($link).'<br>'.$q);
		}
	}
}

$plDOW=array(
 'Nd'
,'Pn'
,'Wt'
,'Sr'
,'Cz'
,'Pt'
,'Sb'
);

foreach($_POST as $key => $value)
{
	if($key*1>0)
	{
		if(!in_array($value,$plDOW))
		{
			mysqli_query($link, $q="
				insert into absencje set ID_D=$id, DATA='$key', KOD='$value'
			");
			if (mysqli_error($link)) {
				die(mysqli_error($link).'<br>'.$q);
			}
		}
		unset($_POST[$key]);
	}
}

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveFormFields.php");
