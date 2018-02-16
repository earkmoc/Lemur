<?php

mysqli_query($link, $q="
	truncate dokumentr
");
mysqli_query($link, $q="
	insert 
	  into dokumentr
	select 0
	     , dokumentm.ID_D
		 , $ido
		 , Now()
		 , 'RST'
		 , ''
		 , 0
		 , 0
		 , round(sum(dokumentm.BRUTTO)*100/(100+dokumentm.STAWKA*1),2)
		 , dokumentm.STAWKA
		 , sum(dokumentm.BRUTTO)-round(sum(dokumentm.BRUTTO)*100/(100+dokumentm.STAWKA*1),2)
		 , sum(dokumentm.BRUTTO)
		 , dokumenty.DDOKUMENTU
	  from dokumentm
 left join dokumenty
        on dokumenty.ID=dokumentm.ID_D
	 where dokumenty.TYP like '%FV%'
  group by dokumentm.ID_D, dokumentm.STAWKA
");
mysqli_query($link, $q="
	insert 
	  into dokumentr
	select 0
	     , dokumentm.ID_D
		 , $ido
		 , Now()
		 , 'RZT'
		 , ''
		 , 0
		 , 0
		 , sum(dokumentm.NETTO)
		 , dokumentm.STAWKA
		 , round(sum(dokumentm.NETTO)*(dokumentm.STAWKA*0.01),2)
		 , round(sum(dokumentm.NETTO)*(dokumentm.STAWKA*0.01),2)+sum(dokumentm.NETTO)
		 , dokumenty.DDOKUMENTU
	  from dokumentm
 left join dokumenty
        on dokumenty.ID=dokumentm.ID_D
	 where dokumenty.TYP like '%FZ%'
  group by dokumentm.ID_D, dokumentm.STAWKA
");
