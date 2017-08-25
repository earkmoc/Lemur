<?php

function NextNumer($link, $typ, $data, $val, $iddExcluded)
{
	$wynik=$val;
	$typ=explode('-',$typ)[0];
	if(	($val=='')
	  &&( (substr($typ,0,1)=='S')
		||(substr($typ,0,2)=='WZ')
		||(substr($typ,0,2)=='PZ')
		)
	  )
	{
		$q="select NUMER from dokumenty where TYP='$typ' and DDOKUMENTU<='$data'";
		$q.=($iddExcluded?" and ID<>$iddExcluded":'');
		$q.=" order by DDOKUMENTU desc, ID desc limit 1";
		$numer=mysqli_fetch_row(mysqli_query($link, $q))[0];
		$prefix="";
		$loop=0;
		while	(	(($litera=substr($numer,0,1))*1)==0
				&&	(++$loop<100)
				)
		{
			if($litera=='')
			{
				break;
			}
			$prefix.=$litera;
			$numer=substr($numer,1);
		}
		$nr=1*$numer;
		$sufix=substr($numer,strlen($nr));
		$wynik=$prefix.($nr+1).$sufix;
	}
	return $wynik;
}
