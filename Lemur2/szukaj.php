<?php

$firma=$_GET['firma'];
require('setup.php');
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");
$tabelaNazwa=strtolower((@$firma&&!stripos($tabela,'_')?"{$firma}_{$tabela}":$tabela));

$idTabeles=($idTabeles?$idTabeles:0);

$col=$_GET['col'];
$warunek='';
$szukaj='';
$sortuj='';

if($sortuj=$_POST['sortuj'])
{
	
	if(substr($sortuj,0,1)=='+')
	{
		if	(	($fields[$col-1]['pole']!=$fields[$col-1]['poleNum'])
			||	($fields[$col-1]['pole']=='right')
			)
		{
			$sortuj=$fields[$col-1]['poleNum'].'*1';	//pole liczbowe
		}
		else
		{
			$sortuj=$fields[$col-1]['poleNum'];		//pole tekstowe
		}
	} 
	elseif(substr($sortuj,0,1)=='-')
	{
		if	(	($fields[$col-1]['pole']!=$fields[$col-1]['poleNum'])
			||	($fields[$col-1]['pole']=='right')
			)
		{
			$sortuj=$fields[$col-1]['poleNum'].'*1 desc';	//pole liczbowe
		}
		else
		{
			$sortuj=$fields[$col-1]['poleNum'].' desc';		//pole tekstowe
		}
	} 
	else
	{
		$sortuj='0';
	}
}

if($szukaj=$_POST['szukaj'])
{
	if(substr($szukaj,0,1)=='&')
	{
		$szukaj=substr($szukaj,1);
		$addWithAnd=true;
	} 
	elseif(substr($szukaj,0,1)=='|')
	{
		$szukaj=substr($szukaj,1);
		$addWithOr=true;
	} 

	if(substr($szukaj,0,1)=='!')
	{
		$szukaj=substr($szukaj,1);
		$addWithNot=true;
	} 

	if(substr($szukaj,0,1)=='=')
	{
		$szukaj=substr($szukaj,1);
		$warunek=AddSlashes($fields[$col-1]['pole']."=$szukaj");
	} 
	elseif(strpos($szukaj,'::')!==false)
	{
		$szukaj=explode('::',$szukaj);
		$szukaj1=$szukaj[0];
		$szukaj2=$szukaj[1];
		$warunek=AddSlashes($fields[$col-1]['pole']." between $szukaj1 and $szukaj2");
	} 
	elseif(substr($szukaj,0,2)=='>=')
	{
		$szukaj=substr($szukaj,2);
		$warunek=AddSlashes($fields[$col-1]['pole'].">=$szukaj");
	} 
	elseif(substr($szukaj,0,2)=='<=')
	{
		$szukaj=substr($szukaj,2);
		$warunek=AddSlashes($fields[$col-1]['pole']."<=$szukaj");
	} 
	elseif(substr($szukaj,0,1)=='>')
	{
		$szukaj=substr($szukaj,1);
		$warunek=AddSlashes($fields[$col-1]['pole'].">$szukaj");
	} 
	elseif(substr($szukaj,0,1)=='<')
	{
		$szukaj=substr($szukaj,1);
		$warunek=AddSlashes($fields[$col-1]['pole']."<$szukaj");
	} 
	elseif(substr($szukaj,0,1)=='*')
	{
		$szukaj=substr($szukaj,1);
		$warunek=AddSlashes($fields[$col-1]['pole']." like '%$szukaj'");
	} 
	elseif(substr($szukaj,-1,1)=='*')
	{
		$szukaj=substr($szukaj,0,strlen($szukaj)-1);
		$warunek=AddSlashes($fields[$col-1]['pole']." like '$szukaj%'");
	} 
	else
	{
		$warunek=AddSlashes($fields[$col-1]['pole']." like '%$szukaj%'");
	}
}

if($addWithNot)
{
	$warunek="not ($warunek)";
}

if($addWithAnd||$addWithOr)
{
	$obecnyWarunek=mysqli_fetch_row(mysqli_query($link,$q="
	select WARUNKI
	  from tabeles
	 where ID=$idTabeles
	"))[0];
	if($obecnyWarunek)
	{
		$obecnyWarunek=AddSlashes($obecnyWarunek);
		$warunek="($obecnyWarunek) ".($addWithAnd?'and':'or')." ($warunek)";
	}
}

if($sortuj!='')
{
	$sortuj=($sortuj=='0'?'':$sortuj.",$tabelaNazwa.ID");
	mysqli_query($link,$q="
		update tabeles
		   set WARUNKI=if('$warunek'<>'','$warunek',WARUNKI)
		     , SORTOWANIE='$sortuj'
		 where ID=$idTabeles
	");
} else
{
	mysqli_query($link,$q="
		update tabeles
		   set WARUNKI='$warunek'
		     , SORTOWANIE=''
		 where ID=$idTabeles
	");
}
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
//die($q);
//die(nl2br(print_r($fields,true)));
header("location:./?firma=$firma");
