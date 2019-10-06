<?php
	
function Oblicz($link, $idSrodkaTrwalego, $rok)
{
	if($rok*1<1967) {return 0;}
	
	$stawka=mysqli_fetch_row(mysqli_query($link,$q="
	select STOPAB
	  from srodkihi
	 where DATA<'$rok-12-01'
	   and ID_D='$idSrodkaTrwalego'
	 order by DATA desc, ID desc
	 limit 1
	"))[0];
	$stawka=($stawka?$stawka:0);

	$wibo=mysqli_fetch_row(mysqli_query($link,$q="
	select sum(ZMWI)
	  from srodkihi
	 where Year(DATA)<'$rok'
	   and ID_D='$idSrodkaTrwalego'
	 order by DATA desc, ID desc
	 limit 1
	"))[0];
	$wibo=($wibo?$wibo:0);

	$wizw=mysqli_fetch_row(mysqli_query($link,$q="
	select sum(ZMWI)
	  from srodkihi
	 where Year(DATA)='$rok'
	   and ID_D='$idSrodkaTrwalego'
	   and ZMWI>0
	"))[0];
	$wizw=($wizw?$wizw:0);

	$wizm=mysqli_fetch_row(mysqli_query($link,$q="
	select sum(ZMWI)
	  from srodkihi
	 where Year(DATA)='$rok'
	   and ID_D='$idSrodkaTrwalego'
	   and ZMWI<0
	"))[0];
	$wizm=($wizm?$wizm:0);
	
	$wibz=$wibo+$wizw+$wizm;
	
	$umbo=mysqli_fetch_row(mysqli_query($link,$q="
	select WUBZ
	  from srodkihi
	 where Year(DATA)<'$rok'
	   and ID_D='$idSrodkaTrwalego'
	 order by DATA desc, ID desc
	 limit 1
	"))[0];
	$umbo=($umbo?$umbo:0);

	$umzw=mysqli_fetch_row(mysqli_query($link,$q="
	select sum(ZMWU)
	  from srodkihi
	 where Year(DATA)='$rok'
	   and ID_D='$idSrodkaTrwalego'
	   and ZMWU>0
	"))[0];
	$umzw=($umzw?$umzw:0);

	$umzm=mysqli_fetch_row(mysqli_query($link,$q="
	select sum(ZMWU)
	  from srodkihi
	 where Year(DATA)='$rok'
	   and ID_D='$idSrodkaTrwalego'
	   and ZMWU<0
	"))[0];
	$umzm=($umzm?$umzm:0);
	
	$umro=mysqli_fetch_row(mysqli_query($link,$q="
	select sum(WAAM)
	  from srodkihi
	 where Year(DATA)='$rok'
	   and ID_D='$idSrodkaTrwalego'
	"))[0];
	$umro=($umro?$umro:0);
	
	$umbz=$umbo+$umzw-$umzm+$umro;
	
	$amortyzacjaMiesiaca=mysqli_fetch_row(mysqli_query($link,$q="
	select 0
		 , sum(if(Month(DATA)=1,WAAM,0))
		 , sum(if(Month(DATA)=2,WAAM,0))
		 , sum(if(Month(DATA)=3,WAAM,0))
		 , sum(if(Month(DATA)=4,WAAM,0))
		 , sum(if(Month(DATA)=5,WAAM,0))
		 , sum(if(Month(DATA)=6,WAAM,0))
		 , sum(if(Month(DATA)=7,WAAM,0))
		 , sum(if(Month(DATA)=8,WAAM,0))
		 , sum(if(Month(DATA)=9,WAAM,0))
		 , sum(if(Month(DATA)=10,WAAM,0))
		 , sum(if(Month(DATA)=11,WAAM,0))
		 , sum(if(Month(DATA)=12,WAAM,0))
	  from srodkihi
	 where Year(DATA)='$rok'
	   and ID_D='$idSrodkaTrwalego'
	"));
	if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}

	mysqli_query($link,$q="
	update srodkitr
	   set WIBO='$wibo'
		 , WIZW='$wizw'
		 , WIZM='$wizm'
		 , WIBZ='$wibz'
		 , UMBO='$umbo'
		 , UMZW='$umzw'
		 , UMZM='$umzm'
		 , UMWUR='$umro'
		 , UMBZ='$umbz'
		 , STAWKA=if(STAWKA>0 and ('$stawka'*1=0),STAWKA,'$stawka')
		 , WMUA1='$amortyzacjaMiesiaca[1]'
		 , WMUA2='$amortyzacjaMiesiaca[2]'
		 , WMUA3='$amortyzacjaMiesiaca[3]'
		 , WMUA4='$amortyzacjaMiesiaca[4]'
		 , WMUA5='$amortyzacjaMiesiaca[5]'
		 , WMUA6='$amortyzacjaMiesiaca[6]'
		 , WMUA7='$amortyzacjaMiesiaca[7]'
		 , WMUA8='$amortyzacjaMiesiaca[8]'
		 , WMUA9='$amortyzacjaMiesiaca[9]'
		 , WMUA10='$amortyzacjaMiesiaca[10]'
		 , WMUA11='$amortyzacjaMiesiaca[11]'
		 , WMUA12='$amortyzacjaMiesiaca[12]'
	 where ID='$idSrodkaTrwalego'
	");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}

	return mysqli_affected_rows($link);
}
