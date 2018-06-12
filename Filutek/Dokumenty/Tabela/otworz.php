<?php

require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

mysqli_query($link, "update dokumenty set GDZIE=if(GDZIE='bufor','ksiêgi','bufor') where ID=$id");

$typ=mysqli_fetch_row(mysqli_query($link,$q="
select TYP
  from dokumenty
 where ID='$id'
"))[0];
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

$gdzie=mysqli_fetch_row(mysqli_query($link,$q="
select GDZIE
  from dokumenty
 where ID='$id'
"))[0];
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

$otwieranie=($gdzie=='bufor');

$mnoznik=(in_array($typ,array('FV','FVK','WZ','MM','RW','IR'))?-1:1);
$mnoznik=(in_array($typ,array('INW'))?0:$mnoznik);
$mnoznik*=($otwieranie?-1:1);

$dt=date('Y-m-d');

$towary=mysqli_query($link,$q="
	select *
	  from dokumentm
	 where ID_D=$id
  order by ID
");
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

while($towar=mysqli_fetch_array($towary))
{
	if(mysqli_fetch_row(mysqli_query($link,$q="
		select count(*)
		  from towary
		 where INDEKS='$towar[INDEKS]'
	"))[0]==0)
	{
		mysqli_query($link,$q="
			insert
			  into towary
			   set STATUS='{$towar['TYP']}'
				 , NAZWA='{$towar['NAZWA']}'
				 , INDEKS='{$towar['INDEKS']}'
				 , PKWIU='{$towar['PKWIU']}'
				 , JM='{$towar['JM']}'
				 , CENA_S='{$towar['CENA']}'
				 , CENA_Z='{$towar['CENA']}'
				 , STAWKA='{$towar['STAWKA']}'
				 , DATA='{$dt}'
		");
	}

	mysqli_query($link,$q="
		update towary
		   set STAN=STAN+($mnoznik*'$towar[ILOSC]')
		 where INDEKS='$towar[INDEKS]'
		   and STATUS<>'U'
	");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
}

header("location:../Tabela");
