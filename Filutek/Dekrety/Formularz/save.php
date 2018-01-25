<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

if ($idd=$_SESSION["{$baza}DokumentyID_D"])
{
	$_POST['ID_D']=$idd;
}

$_POST['KTO']=$_SESSION['osoba_id'];
Sprawdz($_POST['KONTOWN'], $link);
Sprawdz($_POST['KONTOMA'], $link);

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveFormFields.php");

function Sprawdz(&$konto, $link)
{
	$znak='.';
	$konto=str_replace(',',$znak,$konto);
	if(strpos($konto,$znak))
	{
		$czesci=explode($znak,$konto);
		$poczatekKonta=$czesci[0];
		$reszta=$czesci[1];
		if($reszta*1>0)	//NIP
		{
			$konto=mysqli_fetch_row(mysqli_query($link, $q="
				select KONTO 
				  from knordpol 
				 where KONTO like '$poczatekKonta%' 
				   and replace(replace(replace(NIP,'-',''),'PL',''),' ','') like replace(replace(replace('$reszta%','-',''),'PL',''),' ','')
			  order by ID
			"))[0];
		}
		else
		{
			$konto=mysqli_fetch_row(mysqli_query($link, $q="
				select KONTO 
				  from knordpol 
				 where KONTO like '$poczatekKonta%' 
				   and PSEUDO like '%$reszta%'
			  order by ID
			"))[0];
		}
		if($konto=='')
		{
			$konto=mysqli_fetch_row(mysqli_query($link, $q="
				select KONTO 
				  from knordpol 
				 where KONTO like '$poczatekKonta%' 
				   and NAZWA like '%$reszta%'
			  order by ID
			"))[0];
		}
	}
}
