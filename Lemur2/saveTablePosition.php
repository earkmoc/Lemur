<?php

error_reporting(E_ERROR | E_PARSE | E_WARNING);

if (@$_GET['next'])
{
	require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
}

if (@$_GET['pagesize'])
{
	@session_start();
	$_SESSION['pagesize']=$_GET['pagesize'];
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

if ($_GET['warunki'])    {$warunki=$_GET['warunki'];}
if ($_GET['sortowanie']) {$sortowanie=$_GET['sortowanie'];}

if ($idTabeli)
{
	$sets='';
	$sets.=($str?($sets?', ':'')."NR_STR='$str'":'');
	$sets.=($row?($sets?', ':'')."NR_ROW='$row'":'');
	$sets.=($col?($sets?', ':'')."NR_COL='$col'":'');
	$sets.=($id?($sets?', ':'')."ID_POZYCJI='$id'":'');
	$sets.=($idTabeli?($sets?', ':'')."ID_TABELE='$idTabeli'":'');
	$sets.=($ido?($sets?', ':'')."ID_OSOBY='$ido'":'');

	$sets.=(@$warunki && !@$resetWarunki?($sets?', ':'')."WARUNKI='".AddSlashes($warunki)."'":'');
	$sets.=(@$sortowanie && !@$resetSortowanie?($sets?', ':'')."SORTOWANIE='".AddSlashes($sortowanie)."'":'');

	$sets.=(@$resetWarunki?($sets?', ':'')."WARUNKI=''":'');
	$sets.=(@$resetSortowanie?($sets?', ':'')."SORTOWANIE=''":'');

	if(@$tableInit)
	{
		$sets.=", WARUNKI=''";
		$sets.=", SORTOWANIE='$tableInit'";
	}

	if($sets)
	{
		$innaBaza=($innaBaza?$innaBaza:'');
		mysqli_query($link, $q="
						 insert
						   into $innaBaza.tabeles
							set $sets
		on duplicate key update $sets
		");
		if (mysqli_error($link))
		{
			die("File:<br>".__file__.'<br><br>Query:<br>'.nl2br($q).'<br>Message:<br>'.mysqli_error($link));
		} 
	}
	if ($_GET['next'])
	{
		header("location: $_GET[next]");
	}
}
