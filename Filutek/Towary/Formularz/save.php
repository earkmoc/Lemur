<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

if ($idd=$_SESSION["{$baza}DokumentyID_D"])
{
	$_POST['ID_D']=$idd;
}
$_POST['KTO']=$_SESSION['osoba_id'];
$_POST['CZAS']=date('Y-m-d H:i:s');

$_POST['CENABEZR']  =str_replace(',','.',$_POST['CENABEZR']);
$_POST['RABAT']  =str_replace(',','.',$_POST['RABAT']);

$_POST['RABAT'] =(1*$_POST['RABAT']?$_POST['RABAT']:0);
$_POST['CENA']  =($_POST['CENABEZR']-0.01*$_POST['RABAT']*$_POST['CENABEZR']);
$_POST['STAWKA']=(!$_POST['STAWKA']?'23%':$_POST['STAWKA']);

$_POST['ILOSC'] =str_replace(',','.',$_POST['ILOSC']);
$_POST['CENA']  =str_replace(',','.',$_POST['CENA']);
$_POST['NETTO'] =str_replace(',','.',$_POST['NETTO']);
$_POST['VAT']   =str_replace(',','.',$_POST['VAT']);
$_POST['BRUTTO']=str_replace(',','.',$_POST['BRUTTO']);

// $_POST['NETTO']=(1*$_POST['NETTO']?$_POST['NETTO']:round($_POST['ILOSC']*$_POST['CENA'],2));
// $_POST['VAT']=round(1*$_POST['VAT']?$_POST['VAT']:$_POST['NETTO']*$_POST['STAWKA']*0.01,2);
// $_POST['BRUTTO']=(1*$_POST['BRUTTO']?$_POST['BRUTTO']:$_POST['NETTO']+$_POST['VAT']);

$_POST['NETTO']=round($_POST['ILOSC']*$_POST['CENA'],2);
$_POST['VAT']=round($_POST['NETTO']*$_POST['STAWKA']*0.01,2);
$_POST['BRUTTO']=($_POST['NETTO']+$_POST['VAT']);

$_POST['OG_WA_PRZ']=$_POST['BRUTTO'];

$noHeader=true;
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveFormFields.php");

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
