<?php

header('Location:../Tabela');
require("setup.php");

$set='';
$where='';
foreach($_POST as $klucz => $wartosc) {
   $wartosc=AddSlashes($wartosc);
   //$wartosc=iconv ( 'utf-8', 'iso-8859-2', $wartosc);
   //$wartosc=Strip_Tags($wartosc);
   if ($klucz=='ID') {
      $id=$wartosc;
   } elseif ( (substr($klucz,0,1)=="(")
			||(substr($klucz,0,3)=="if(")
			||(substr($klucz,0,7)=="format(")
			||(strpos($klucz,'.')>0)
			) {
   } else {
	   $numeryczne=false;
	   foreach($fields as $field)
	   {
		   if	( ($field['pole']==$klucz)
			    &&($field['align']=='right')
				)
		   {
			   $numeryczne=true;
		   }
	   }
		if ($wartosc) 
		{
			$wartosc="'$wartosc'";
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

$where=" where ID=$id";

if ($id==0) {
   $q=("insert into $tabela $set");
} elseif ($_GET[usun]) {
   $q=("delete from $tabela $where");
} else {
   $q=("update $tabela $set $where limit 1");
}

mysqli_query($link, $q);
if (mysqli_error($link)) {
	die(mysqli_error($link));
}
