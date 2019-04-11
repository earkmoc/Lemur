<?php

require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

//mysqli_query($link,$q="
//update dokumentm left join dokumenty on dokumenty.ID=dokumentm.ID_D set dokumenty.TYP=if(GDZIE='bbufor','',dokumenty.TYP)
//"); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

$inw=mysqli_fetch_array(mysqli_query($link,$q="
select * from dokumenty where TYP='INW' order by ID desc limit 1
")); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

$sets="
 CENA_Z=if(values(CENA_Z)>0,values(CENA_Z),CENA_Z)
,CENA_B=if(values(CENA_B)>0,values(CENA_B),CENA_B)
,NAZWA=values(NAZWA)
,JM=values(JM)
,STATUS=values(STATUS)
,PKWIU=values(PKWIU)
,STAWKA=values(STAWKA)
,STAN=STAN+values(STAN)
";

mysqli_query($link,$q="
truncate towary
"); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

mysqli_query($link,$q="
  insert 
    into towary
  select 0,0,'',dokumentm.INDEKS,dokumentm.NAZWA
         ,if(dokumenty.TYP IN ('INW','FZ','FZK'),dokumentm.CENABEZR,0)
         ,0,0,0,0,0,dokumentm.JM,dokumentm.PKWIU,dokumentm.STAWKA
         ,if(dokumenty.TYP IN ('INW','FZ','FZK'),1,-1)*dokumentm.ILOSC
		 ,0,dokumentm.TYP,'2018-01-01',0,'',0,0,0,0,''
         ,if(dokumenty.TYP not IN ('INW','FZ','FZK'),dokumentm.CENABEZR,0)
         ,0,0,0,0,'',0 
    from dokumentm 
	left join dokumenty on dokumenty.ID=dokumentm.ID_D
   where 1
order by dokumentm.ID_D
on duplicate key update $sets
"); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

mysqli_query($link,$q="
update towary set STAN=0
"); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

mysqli_query($link,$q="
  insert 
    into towary
  select 0,0,'',dokumentm.INDEKS,dokumentm.NAZWA
         ,if(dokumenty.TYP IN ('INW','FZ','FZK'),dokumentm.CENABEZR,0)
         ,0,0,0,0,0,dokumentm.JM,dokumentm.PKWIU,dokumentm.STAWKA
         ,if(dokumenty.TYP IN ('INW','FZ','FZK'),1,-1)*dokumentm.ILOSC
		 ,0,dokumentm.TYP,'2018-01-01',0,'',0,0,0,0,''
         ,if(dokumenty.TYP not IN ('INW','FZ','FZK'),dokumentm.CENABEZR,0)
         ,0,0,0,0,'',0 
    from dokumentm 
	left join dokumenty on dokumenty.ID=dokumentm.ID_D
   where (  (dokumentm.ID_D='$inw[ID]')
         or (dokumenty.DDOKUMENTU>='$inw[DDOKUMENTU]')
		 )
order by dokumentm.ID_D
on duplicate key update $sets
"); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

header("location:index.php");
