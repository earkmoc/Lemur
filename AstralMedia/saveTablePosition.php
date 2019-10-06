<?php

//error_reporting(E_ERROR | E_PARSE | E_WARNING);//E_NOTICE | 
//print_r($_GET);die;

if ($_GET['next'])
{
	require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
}

if(@$tableInit)
{
	$_GET['str']=1;
	$_GET['row']=1;
}

if ($_GET['str']) {$str=$_GET['str'];}
if ($_GET['row']) {$row=$_GET['row'];}
if ($_GET['col']) {$col=$_GET['col'];}
if ($_GET['id'])  {$id=$_GET['id'];}
if ($_GET['idTabeli'])  {$idTabeli=$_GET['idTabeli'];}

if ($idTabeli)
{
	$sets='';
	$sets.=($str?($sets?', ':'')."NR_STR='$str'":'');
	$sets.=($row?($sets?', ':'')."NR_ROW='$row'":'');
	$sets.=($str?($sets?', ':'')."NR_COL='$col'":'');
	$sets.=($str?($sets?', ':'')."ID_POZYCJI='$id'":'');
	$sets.=($str?($sets?', ':'')."ID_TABELE='$idTabeli'":'');
	$sets.=($str?($sets?', ':'')."ID_OSOBY='$ido'":'');

	if(@$tableInit)
	{
		$sets.=", WARUNKI=''";
		$sets.=", SORTOWANIE='$tableInit'";
	}

	$innaBaza=($innaBaza?$innaBaza:'');
	mysqli_query($link, $q="
				 insert 
				   into $innaBaza.tabeles
					set $sets
on duplicate key update $sets
	");
	if (mysqli_error($link)) {
		die(mysqli_error($link).'<br>'.$q);
	} else {
		if ($_GET['next'])
		{
			//echo 'header("location: '.$_GET['next'].'");';die;
			header("location: {$_GET['next']}");
		}
	}
}
