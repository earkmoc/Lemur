<?php

require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

$idd=mysqli_fetch_row(mysqli_query($link, "
select ID_D
  from $tabela 
 where ID=$id
"))[0];

mysqli_query($link, "
delete 
  from $tabela 
 where ID=$id
");
if (mysqli_error($link)) {
	die(mysqli_error($link));
}

$towary=mysqli_query($link,$q="
select *
  from dokumentm
 where if('$idd'*1<=0,ID_D<=0 and KTO=$ido,ID_D='$idd')
 order by ID
");

$nettos=array();
$vats=array();
$bruttos=array();
while($towar=mysqli_fetch_array($towary))
{
	$nettos[$towar['STAWKA']]=((@!isset($nettos[$towar['STAWKA']]))?$towar['NETTO']:1*$nettos[$towar['STAWKA']]+$towar['NETTO']);
}

$vat=0;
$netto=0;
foreach($nettos as $key => $value)
{
	$netto+=$value;
	$vat+=round($value*$key*0.01,2);
}

$brutto=$netto+$vat;

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
