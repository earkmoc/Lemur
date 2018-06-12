<?php

require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

mysqli_query($link,$q="
truncate towary
"); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

mysqli_query($link,$q="
update dokumentm left join dokumenty on dokumenty.ID=dokumentm.ID_D set dokumentm.ORIGIN=if(GDZIE='bbufor','',dokumenty.TYP)
"); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

mysqli_query($link,$q="
insert into towary
select 0,0,'',INDEKS,NAZWA,
max(if(ORIGIN IN ('INW','FZ','FZK'),CENABEZR,0)),
0,0,0,0,0,JM,PKWIU,STAWKA,sum(if(ORIGIN IN ('INW','FZ','FZK'),1,-1)*ILOSC),0,TYP,'2018-01-01',0,'',0,0,0,0,'',
max(if(ORIGIN not IN ('INW','FZ','FZK'),CENABEZR,0)),
0,0,0,0,'',0 from dokumentm where ID_D>=1266 and ORIGIN<>'' group by NAZWA
"); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

header("location:index.php");
