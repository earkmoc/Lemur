<?php

$wzor=$_GET['Wzory'];
$firma=$_GET['firma'];

$drugiRaz=true;
require("setup.php");
$tabelaNazwa=strtolower((@$firma&&(!stripos($tabela,'_')||stripos($tabela,'_X'))?"{$firma}_{$tabela}":$tabela));

$set='';
$where='';
foreach($_POST as $klucz => $wartosc)
{
   //echo "$klucz => $wartosc <br>";
   //$wartosc=iconv('UTF-8', 'ISO-8859-2', $wartosc);	// def=false => serwer???
   $wartosc=AddSlashes($wartosc);
   //$wartosc=Strip_Tags($wartosc);
	if ($klucz=='ID') {
		$id=$wartosc;
	} elseif ( (substr($klucz,0,1)=="(")
			||(substr($klucz,0,3)=="if(")
			||(substr($klucz,0,7)=="format(")
			||(strpos($klucz,'.')>0)
			) {
		//ignoruj
	} 
	else 
	{
		$ignoruj=false;
		$numeryczne=false;
		foreach($fields as $field)
		{
			if  ( ($field['pole']==$klucz)
				||($field['pole']==str_replace('_','.',$klucz))
				)
			{
				if ($field['align']=='right')
				{
					$numeryczne=true;
				}
				if ($field['readonly'])
				{
					$ignoruj=true;
				}
			}
		}
		if(!$ignoruj)
		{
			if($wartosc) 
			{
				$wartosc=str_replace("'",'`',$wartosc);
				if($numeryczne)
				{
					$wartosc=str_replace(',','.',"'$wartosc'");
				}
				else
				{
					$wartosc="'$wartosc'";
				}
			}
			else
			{
				if($numeryczne)
				{
					$wartosc='0';
				}
				else 
				{
					$wartosc="''";
				}
			}
			$set.=($set?', ':'set ').StrToUpper($klucz)."=".$wartosc;
		}
	}
}

$where=" where ID=$id";

if($id==0)
{
   $q=("insert into $tabelaNazwa $set");
}
elseif($_GET[usun])
{
   $q=("delete from $tabelaNazwa $where limit 1");
}
else
{
   $q=("update $tabelaNazwa $set $where limit 1");
}

//die($q);
mysqli_query($link, $q);
if(mysqli_error($link))
{
	die(mysqli_error($link).'<br>'.$q);
}
else
{
	if(!$noHeader)
	{
		header("Location:../Tabela/?".($wzor?"Wzory=$wzor&":'')."firma=$firma");
	}
}
