<?php

$drugiRaz=true;
require("setup.php");

$set='';
$where='';
foreach($_POST as $klucz => $wartosc) {
   $wartosc=AddSlashes($wartosc);
   //echo "$klucz => $wartosc <br>";
   //$wartosc=iconv ( 'utf-8', 'iso-8859-2', $wartosc);
   //$wartosc=Strip_Tags($wartosc);
	if ($klucz=='ID') {
		$id=$wartosc;
	} elseif ( (substr($klucz,0,1)=="(")
			||(substr($klucz,0,3)=="if(")
			||(substr($klucz,0,7)=="format(")
			||(strpos($klucz,'.')>0)
			) {
		//ignoruj
	} else {
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
		if  (!$ignoruj)
		{
			if ($wartosc) 
			{
				$wartosc=str_replace("'",'`',$wartosc);
				if($numeryczne)
				{
					$wartosc=str_replace(',','.',"'$wartosc'");
				} else
				{
					$wartosc="'$wartosc'";
				}
			} else
			{
				if($numeryczne)
				{
					$wartosc='0';
				} else 
				{
					$wartosc="''";
				}
			}
			$set.=($set?', ':'set ').StrToUpper($klucz)."=".$wartosc;
		}
	}
}

$where=" where ID=$id";

if ($id==0) {
   $q=("insert into $tabela $set");
} elseif ($_GET[usun]) {
   $q=("delete from $tabela $where limit 1");
} else {
   $q=("update $tabela $set $where limit 1");
}

//die($q);
mysqli_query($link, $q);
if (mysqli_error($link)) {
	die(mysqli_error($link).'<br>'.$q);
} else
{
	if(!$noHeader)
	{
		header('Location:../Tabela');
	}
}
