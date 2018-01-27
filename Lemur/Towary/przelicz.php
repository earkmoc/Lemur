<?php

$towary=mysqli_query($link,$q="
select *
  from dokumentm
 where if('$idd'*1<=0,ID_D<=0 and KTO=$ido,ID_D='$idd')
 order by ID
");

$id=0;
$nettos=array();
$vats=array();
$bruttos=array();
while($towar=mysqli_fetch_array($towary))
{
	if($od_netto)
	{
		$nettos[$towar['STAWKA']]=((@!isset($nettos[$towar['STAWKA']]))?$towar['NETTO']:1*$nettos[$towar['STAWKA']]+$towar['NETTO']);
	}
	else
	{
		$bruttos[$towar['STAWKA']]=((@!isset($bruttos[$towar['STAWKA']]))?$towar['BRUTTO']:1*$bruttos[$towar['STAWKA']]+$towar['BRUTTO']);
	}
	$id=$towar['ID'];
}

$vat=0;
$netto=0;
$brutto=0;

if($od_netto)
{
	foreach($nettos as $key => $value)
	{
		$netto+=$value;
		$vat+=round($value*$key*0.01,2);
	}
	$brutto=$netto+$vat;
}
else
{
	foreach($bruttos as $key => $value)
	{
		$brutto+=$value;
		$netto+=round(($value*100)/(100+($key*1)),2);
	}
	$vat=$brutto-$netto;
}


if($brutto!=0)
{
	mysqli_query($link, $q="update dokumenty set WARTOSC='$brutto', NETTOVAT='$netto', PODATEK_VAT='$vat', KTO='$ido', CZAS=Now() where ID=$idd");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
	$brutto=number_format($brutto,2,'.','');
}
?>

<script type="text/javascript">
	parent.$('input[name=WARTOSC]').val(<?php echo "'$brutto'";?>);
	location="../Tabela";
</script>
