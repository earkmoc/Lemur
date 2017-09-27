<?php

require("setup.php");

if($ido==1)
{
	unset($_POST['NX']);
	unset($_POST['NY']);
	require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveFormFields.php");
}
else
{
	//die(print_r($_POST));
	$user=trim(explode('-',$_POST['USER'])[0]);
	$w=mysqli_query($link,$q="select ID, NAZWA, PASS from $tabela where USER='$user' limit 1");
	$r=mysqli_fetch_row($w);
	if	(	$user
		&&	($r[2]==$_POST['PASS'])
		)
	{
		$id=$r[0];
		$_SESSION['osoba_id']=$r[0];
		$_SESSION['osoba_upr']=$r[1];

		$q="update $tabela SET CZAS=Now()";
		if	(	($_POST['NX']<>'')
			&&	($_POST['NX']==$_POST['NY'])
			)
		{
			$q.=", PASS='$_POST[NX]'";
		}

		$w=mysqli_query($link,$q.=" where ID=$id limit 1");
		mysqli_error($link)? die(mysqli_error($link).'<br>'.$q): header('Location:/Lemur2/Moduly');

		//------------------------------------------------------------------------------------------------------------

		require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/update_dump_all.php");

		//------------------------------------------------------------------------------------------------------------

	} else
	{
		header('Location:/Lemur2/Logowanie/Tabela/logout.php');
	}
}