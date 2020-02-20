<?php

error_reporting(E_ERROR | E_PARSE | E_WARNING);//E_NOTICE | 

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

// ----------------------------------------------

$wzor=$_GET['wzor'];
$firma=$_GET['firma'];
$tabela=$_GET['tabela'];
$widok=$_GET['widok'];
$orderBy='';
$groupBy='';
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

//----------------------------------------------

$_SESSION['error']='';
//$_SESSION['wynik']='';

$first=(!$_GET['limit']);

$_GET['searchText']=($_GET['searchText']?$_GET['searchText']:'');
$_GET['sortOrder']=($_GET['sortOrder']?$_GET['sortOrder']:'asc');

$_GET['search']=($_GET['search']?$_GET['search']:$_GET['searchText']);
$_GET['search']=($_GET['search']?$fields[$_GET['col']-1]['pole']." like '%$_GET[search]%'":1);
$_GET['search']=(($_GET['mandatory']&&($_GET['mandatory']!='1'))?"(".$_GET['search'].") and ($_GET[mandatory])":$_GET['search']);

//$_SESSION['search']=$_GET['search'];die;

if($idTabeles)
{
	if(true||$_GET['search']==1)
	{
		$r=mysqli_fetch_row(mysqli_query($link, "
					 select WARUNKI
						  , SORTOWANIE
					   from tabeles
					  where ID_TABELE='$idTabeli'
						and ID_OSOBY='$ido'
		"));
		$tabelaNazwa=strtolower((@$firma&&(!stripos($tabela,'_')||stripos($tabela,'_X'))?"{$firma}_{$tabela}":$tabela));
		$r[0]=str_replace('<firma_tabela>',$tabelaNazwa,$r[0]);
		$r[1]=str_replace('<firma_tabela>',$tabelaNazwa,$r[1]);
		$_GET['search']=StripSlashes($r[0]);
		$_GET['search']=($_GET['search']?$_GET['search']:1);
		$_GET['search']=(($_GET['mandatory']&&($_GET['mandatory']!='1'))?"(".$_GET['search'].") and ($_GET[mandatory])":$_GET['search']);
//$_SESSION['search']=$_GET['search'];die;

		$orderBy=($r[1]?'order by '.StripSlashes($r[1]):$orderBy);

	} else
	{
		if(strpos($_GET[search],"all"))
		{
			$_GET[search]="1";
		}
		
		$sets="ID_TABELE='$idTabeli'
			 , ID_OSOBY='$ido'
		     , WARUNKI='".AddSlashes($_GET[search])."'
		";
		mysqli_query($link, "
					 insert 
					   into tabeles
						set $sets
	on duplicate key update $sets
		");
	}
}

$fromwhere=$from." where $_GET[search]";
if(strpos($from,'where'))
{
	$fromwhere=str_replace('where',"where ({$_GET[search]}) and",$from);
}

$tmp=mysqli_fetch_row($w=mysqli_query($link,$q="
	select count(*)
	$fromwhere
	$groupBy
")); $total=$tmp[0]; if(mysqli_error($link)) {echo ("Error: ".$_SESSION['error'].=mysqli_error($link).'<br>'.$q);}

$total=($groupBy?(mysqli_num_rows($w)==1?$total:mysqli_num_rows($w)):$total);

$_GET['pageSize']=($_GET['pageSize']?$_GET['pageSize']:10);
$_GET['pageNumber']=($_GET['pageNumber']?$_GET['pageNumber']:1);

if($total<=($_GET['pageSize']*($_GET['pageNumber']-1)))
{
	$_GET['pageNumber']=(int)(($total-1)/($_GET['pageSize'])+1);
	$_GET['pageNumber']=(($_GET['pageNumber']>= 1)?$_GET['pageNumber']:1);
}

$_GET['limit']=($_GET['limit']?$_GET['limit']:$_GET['pageSize']);
$_GET['offset']=($_GET['offset']?$_GET['offset']:($_GET['pageNumber']-1)*$_GET['limit']);

$_GET['sort']=($_GET['sort']?$_GET['sort']:0);
$_GET['order']=($_GET['order']?$_GET['order']:$_GET['sortOrder']);

// ----------------------------------------------
// Wartości tabeli

$pola = '';
foreach($fields as $column) 
{
	$pola.=($pola?', ':'').$column['pole'];
}

$orderBy=($orderBy?$orderBy:'order by '."{$fields[$_GET[sort]][pole]} $_GET[order]");
$orderBy=($groupBy?" $groupBy ":'').$orderBy;

$rows=array();
if($pola)
{
	$q=("
		select $pola
		$fromwhere
		$orderBy 
		limit $_GET[offset],$_GET[limit]
	");

//$_SESSION['Q']=$q;
//$_SESSION['GET']=$_GET;
//$_SESSION['POST']=$_POST;
//$_SESSION['REQUEST']=$_REQUEST;

	$w=mysqli_query($link, $q); if(mysqli_error($link)) {echo "Error: ".$_SESSION['error'].=mysqli_error($link)." in $q";}
	while($r=mysqli_fetch_row($w))
	{
		$i=0;
		foreach($r as $k => $v)
		{
			$column=$fields[$i];
			if(strpos($column['format'],'@Z')!==false)
			{
				if($v*1==0)
				{
					$v='';
				}
				else
				{
					if(($x=strlen($v)-strpos($v, '.'))>3)	//ile miejsc od kropki do końca liczby
					{
						if($v==floor($v))					//.00000 => ______
						{
							$v=str_replace('.'.str_repeat('0', $x - 1), ' '.str_repeat('&nbsp;&nbsp;', $x - 1), $v);
						}
						else
						{
							$spaces='';
							for($xx=0;$xx<$x;++$xx)
							{
								$c=substr($v, -1, 1);
								if($c=='0')
								{
									$spaces.='&nbsp;&nbsp;';
									$v=substr($v, 0, -1);
								}
								elseif($c=='.')
								{
									$spaces.=' ';
									$v=substr($v, 0, -1);
								}
								else
								{
									break;
								}
							}
							$v.=$spaces;
						}
					}
//					$v=$x;
				}
			}
			$r[$k]=$v;	// $dev=false; => serwer
			$r[$k]=StripSlashes(iconv('ISO-8859-2', 'UTF-8//IGNORE', $v));	//$dev=true
			++$i;
		}
		$rows[]=$r;
	}
}

// ------------------------------------------------------------------------------------------------

$wynik=array();
$wynik['total']=$total;
$wynik['rows']=$rows;
$wynik['pageSize']=$_GET['pageSize'];
$wynik['offset']=$_GET['offset'];

$filtr = explode('where',$fromwhere);
$filtr = $filtr[1];
$filtr=(json_encode($filtr)?$filtr:'');
$filtr=str_ireplace($wzor.'.','',$filtr);
$filtr=str_ireplace($firma.'_','',$filtr);
//$filtr=str_ireplace(' like ',' jak ',$filtr);
$wynik['filtr']=(($filtr=='')||($filtr=='1')||(strpos($filtr,'(1)'))?'':"<b>Filtr</b>: $filtr");

$sortowanie=explode('order by',$orderBy);
$sortowanie=$sortowanie[1];
$sortowanie=str_replace(strtolower($wzor).'.','',$sortowanie);
$sortowanie=str_replace(strtolower($firma).'_','',$sortowanie);
//$sortowanie=str_replace(' asc',' rosnąco',$sortowanie);
//$sortowanie=str_replace(' desc',' malejąco',$sortowanie);
$sortowanie=str_replace(',ID','',$sortowanie);
$wynik['sort'].=(($sortowanie=='')?'':"<b>Sortowanie</b>: $sortowanie");

//$_SESSION['wynik']=$wynik;
if($wynik=json_encode($wynik))
{
	echo $wynik;
//	$_SESSION['wynik2']=$wynik;
} else {
//	$_SESSION['wynik']='problem z json_encode';
}
