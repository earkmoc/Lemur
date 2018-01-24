<?php

require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

//if($ido==1)
//{
	mysqli_query($link, "update dokumenty set GDZIE=if(GDZIE='bufor','ksiêgi','bufor'), CZAS=Now() where ID=$id");
//}

$dokument=mysqli_fetch_array(mysqli_query($link, "select TYP, NUMER, DOPERACJI, GDZIE, NRKONT, WARTOSC from dokumenty where ID=$id"));

if( ($dokument['TYP']=='FV')
  ||($dokument['TYP']=='FJ')
  )
{
	if(mysqli_fetch_row(mysqli_query($link, "select count(*) from dokumentr where ID_D=$id"))[0]==0)	//brak zapisów w rejestrach
	{
		$_GET['idd']=$id;
		$_GET['typ']=$dokument['TYP'];
		$_GET['data']=$dokument['DOPERACJI'];
		$_GET['brutto']=$dokument['WARTOSC'];
		require("{$_SERVER['DOCUMENT_ROOT']}/Batory/RejestryVAT/Tabela/automat.php");
	}
}

if( ($dokument['TYP']=='KP')
  ||($dokument['TYP']=='KW')
  )
{
	//nowy numer raportu kasowego
	$nrRaportu=mysqli_fetch_row(mysqli_query($link, "
		select DODOK 
		  from dokumenty 
		 where ID<$id 
		   and TYP IN ('KP','KW')
		   and DOPERACJI<'$dokument[DOPERACJI]' 
	  order by DOPERACJI desc
			 , ID desc 
		 limit 1
	"))[0]+1;
	mysqli_query($link, "update dokumenty set DODOK='$nrRaportu' where ID=$id");

	//nanoszenie zap³at na dokumenty
	$wplaty=mysqli_query($link, "select * from dokumentz where ID_D=$id");
	while($wplata=mysqli_fetch_array($wplaty))
	{
		$mnoznik=($dokument['GDZIE']=='ksiêgi'?1:-1);
		$dokumDocelowe=mysqli_query($link, "select ID from dokumenty where TYP IN ('FV','FJ','KC') and NUMER='$wplata[PRZEDMIOT]'");// and NRKONT='$dokument[NRKONT]'
		while($dokumDocelowy=mysqli_fetch_array($dokumDocelowe))
		{
			mysqli_query($link, "update dokumenty set WPLACONO=WPLACONO+($mnoznik*'$wplata[KWOTA]') where ID='$dokumDocelowy[ID]'");
			$nrKPKW="$dokument[TYP] $dokument[NUMER]";
			$napis=AddSlashes("100 Raport kasowy Nr $nrRaportu/$nrKPKW z dnia $dokument[DOPERACJI]");
			if($mnoznik==1)
			{
				mysqli_query($link, "update dokumenty set DODOK=concat(DODOK,if(DODOK='','',';'),'$nrKPKW') where ID='$dokumDocelowy[ID]'");
				mysqli_query($link, "insert into dokumentz set ID_D='$dokumDocelowy[ID]', KTO='$ido', CZAS=Now(), DATA='$dokument[DOPERACJI]', KWOTA=($mnoznik*'$wplata[KWOTA]'), PRZEDMIOT='$napis'");
			}
			else
			{
				mysqli_query($link, "update dokumenty set DODOK=replace(replace(DODOK,';$nrKPKW',''),'$nrKPKW','') where ID='$dokumDocelowy[ID]'");
				mysqli_query($link, "delete from dokumentz where ID_D='$dokumDocelowy[ID]' and DATA='$dokument[DOPERACJI]' and KWOTA='$wplata[KWOTA]' limit 1");
			}
		}
	}
}

if(!@$noHeader)
{
	header("location:../Tabela");
}
