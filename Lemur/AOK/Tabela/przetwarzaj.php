<?php

//die(print_r($_GET));

if($_GET['maska'])
{
	foreach($_GET as $key => $value)
	{
		$_POST[$key]=$value;
	}
}

$czas=date('Y-m-d H:i:s');
ini_set('max_execution_time', 600);
error_reporting(E_ERROR | E_PARSE);

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

mysqli_query($link, "ALTER TABLE `slownik` CHANGE `OPIS` `OPIS` text NOT NULL DEFAULT ''");
mysqli_query($link, "ALTER TABLE `slownik` ADD UNIQUE `TST` (`TYP`, `SYMBOL`, `TRESC`)");

$_POST['BO']=(@$_POST['BO']?$_POST['BO']:'');
foreach($_POST as $key => $value)
{
	$value=AddSlashes($value);
	$sets="TYP='parametry'
	   , SYMBOL='AOK'
	   , TRESC='$key'
	   , OPIS='$value'
	";
	mysqli_query($link,$q="
					  insert 
						into slownik
						 set $sets
	 on duplicate key update $sets
	");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br><br>'.$q);}
}

$maska=$_POST['maska'];
$maska=str_replace('*','%',$maska);

mysqli_query($link,"truncate zest2rr");

if (($_POST['gdzie']=='bufor')||($_POST['gdzie']=='ksiêgi i bufor')) 
{
$z="insert into zest2rr select 0, '', '', dokumenty.DOPERACJI, 0, 0, WINIEN, 0, KONTOMA, concat(dokumenty.TYP,' ',dokumenty.NUMER), concat(dokumenty.NAZWA), dokumentk.PRZEDMIOT, $ido, 0 from dokumentk left join dokumenty on (dokumenty.ID=dokumentk.ID_D) where (dokumentk.KONTOWN like '$maska') and (dokumenty.DOPERACJI < '".$_POST['data1']."') and GDZIE='bufor'"; mysqli_query($link,$z);
$z="insert into zest2rr select 0, '', '', dokumenty.DOPERACJI, 0, 0, 0, WINIEN, KONTOWN, concat(dokumenty.TYP,' ',dokumenty.NUMER), concat(dokumenty.NAZWA), dokumentk.PRZEDMIOT, $ido, 0 from dokumentk left join dokumenty on (dokumenty.ID=dokumentk.ID_D) where (dokumentk.KONTOMA like '$maska') and (dokumenty.DOPERACJI < '".$_POST['data1']."') and GDZIE='bufor'"; mysqli_query($link,$z);
}

if (($_POST['gdzie']=='ksiêgi')||($_POST['gdzie']=='ksiêgi i bufor'))
{
//BO poprzedniego roku
//$z="insert into zest2rr select 0, DOK, NR, DATA, LP, PZ, KWOTA, 0,     MA, NAZ1, NAZ2, OPIS, $ido from nordpol where (WINIEN like '$maska') and (Year(DATA)+1 = Year('".$_POST['data1']."')) and not(DOK='BO' and DATA between '".$_POST['data1']."' and '".$_POST['data2']."')"; mysqli_query($link,$z);
//$z="insert into zest2rr select 0, DOK, NR, DATA, LP, PZ, 0, KWOTA, WINIEN, NAZ1, NAZ2, OPIS, $ido from nordpol where (    MA like '$maska') and (Year(DATA)+1 = Year('".$_POST['data1']."')) and not(DOK='BO' and DATA between '".$_POST['data1']."' and '".$_POST['data2']."')"; mysqli_query($link,$z);
$z="insert into zest2rr select 0, DOK, NR, DATA, LP, PZ, KWOTA, 0,     MA, NAZ1, NAZ2, OPIS, $ido, 0 from nordpol where (WINIEN like '$maska') and (Year(DATA)+1 = Year('".$_POST['data1']."'))"; mysqli_query($link,$z);
$z="insert into zest2rr select 0, DOK, NR, DATA, LP, PZ, 0, KWOTA, WINIEN, NAZ1, NAZ2, OPIS, $ido, 0 from nordpol where (    MA like '$maska') and (Year(DATA)+1 = Year('".$_POST['data1']."'))"; mysqli_query($link,$z);

//obroty bie¿¹cego roku wp³ywaj¹ce na BO (gdy okres nie od 1-go stycznia)
//$z="insert into zest2rr select 0, DOK, NR, DATA, LP, PZ, KWOTA, 0,     MA, NAZ1, NAZ2, OPIS, $ido from nordpol where (WINIEN like '$maska') and (DATA < '".$_POST['data1']."') and Year(DATA)=Year('".$_POST['data1']."') and not(DOK='BO' and DATA between '".$_POST['data1']."' and '".$_POST['data2']."')"; mysqli_query($link,$z);
//$z="insert into zest2rr select 0, DOK, NR, DATA, LP, PZ, 0, KWOTA, WINIEN, NAZ1, NAZ2, OPIS, $ido from nordpol where (    MA like '$maska') and (DATA < '".$_POST['data1']."') and Year(DATA)=Year('".$_POST['data1']."') and not(DOK='BO' and DATA between '".$_POST['data1']."' and '".$_POST['data2']."')"; mysqli_query($link,$z);
$z="insert into zest2rr select 0, DOK, NR, DATA, LP, PZ, KWOTA, 0,     MA, NAZ1, NAZ2, OPIS, $ido, 0 from nordpol where (WINIEN like '$maska') and (DATA < '".$_POST['data1']."') and Year(DATA)=Year('".$_POST['data1']."')"; mysqli_query($link,$z);
$z="insert into zest2rr select 0, DOK, NR, DATA, LP, PZ, 0, KWOTA, WINIEN, NAZ1, NAZ2, OPIS, $ido, 0 from nordpol where (    MA like '$maska') and (DATA < '".$_POST['data1']."') and Year(DATA)=Year('".$_POST['data1']."')"; mysqli_query($link,$z);
}

mysqli_query($link,"truncate zest2r");

if($_POST['BO'])
{
	$z="insert into zest2r select 0, 'BO', '', Date_Add('".$_POST['data1']."',interval -1 day ), '', '', sum(OBROTYWN), sum(OBROTYMA), '', '', concat(format(sum(OBROTYWN) - sum(OBROTYMA),2),' = wynik' ), 'Bilans otwarcia', $ido, 0 from zest2rr"; mysqli_query($link,$z);
}

if (($_POST['gdzie']=='bufor')||($_POST['gdzie']=='ksiêgi i bufor')) 
{
$z="insert into zest2r select 0, '', '', dokumenty.DOPERACJI, 0, 0, WINIEN, 0, KONTOMA, concat(dokumenty.TYP,' ',dokumenty.NUMER), concat(dokumenty.NAZWA), dokumentk.PRZEDMIOT, $ido, 0 from dokumentk left join dokumenty on (dokumenty.ID=dokumentk.ID_D) where (dokumentk.KONTOWN like '$maska') and (dokumenty.DOPERACJI between '".$_POST['data1']."' and '".$_POST['data2']."') and GDZIE='bufor'"; mysqli_query($link,$z);
$z="insert into zest2r select 0, '', '', dokumenty.DOPERACJI, 0, 0, 0, WINIEN, KONTOWN, concat(dokumenty.TYP,' ',dokumenty.NUMER), concat(dokumenty.NAZWA), dokumentk.PRZEDMIOT, $ido, 0 from dokumentk left join dokumenty on (dokumenty.ID=dokumentk.ID_D) where (dokumentk.KONTOMA like '$maska') and (dokumenty.DOPERACJI between '".$_POST['data1']."' and '".$_POST['data2']."') and GDZIE='bufor'"; mysqli_query($link,$z);
}

if (($_POST['gdzie']=='ksiêgi')||($_POST['gdzie']=='ksiêgi i bufor'))
{
$z="insert into zest2r select 0, DOK, NR, DATA, LP, PZ, KWOTA, 0,     MA, NAZ1, NAZ2, OPIS, $ido, 0 from nordpol where (WINIEN like '$maska') and (DATA between '".$_POST['data1']."' and '".$_POST['data2']."')"; mysqli_query($link,$z);
$z="insert into zest2r select 0, DOK, NR, DATA, LP, PZ, 0, KWOTA, WINIEN, NAZ1, NAZ2, OPIS, $ido, 0 from nordpol where (    MA like '$maska') and (DATA between '".$_POST['data1']."' and '".$_POST['data2']."')"; mysqli_query($link,$z);
}

//mysqli_query($link,"delete from zest2r where (DOK='BO' and DATA between '".$_POST['data1']."' and '".$_POST['data2']."')");

mysqli_query($link,"delete from zest2 where ID_OSOBYUPR=$ido");
mysqli_query($link,"insert into zest2 select 0, DOK, NR, DATA, LP, PZ, OBROTYWN, OBROTYMA, KONTOP, NAZ1, NAZ2, OPIS, $ido, 0 from zest2r order by DATA, LP, PZ");

$saldo=0;
$w=mysqli_query($link,"select * from zest2 where ID_OSOBYUPR=$ido order by ID");
while($r=mysqli_fetch_array($w))
{
	$saldo+=$r['OBROTYWN']-$r['OBROTYMA'];
	mysqli_query($link,"update zest2 set SALDO='$saldo' where ID=$r[ID]");
}

$w=mysqli_query($link,"
	select   0
			,format(sum(OBROTYWN),2)
			,format(sum(OBROTYMA),2)
			,format(if(sum(OBROTYWN)>sum(OBROTYMA),sum(OBROTYWN)-sum(OBROTYMA),0),2)
			,format(if(sum(OBROTYWN)<sum(OBROTYMA),sum(OBROTYMA)-sum(OBROTYWN),0),2)
		from zest2
	   where ID_OSOBYUPR=$ido
");
$wynik=mysqli_fetch_row($w);

if($_GET['maska'])
{
	header("location:index.php?maska=$_GET[maska]&data1=$_GET[data1]&data2=$_GET[data2]");
	die();
}

$title="Przetwarzanie: raport";
$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"..");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

echo "<table width='100%' height='100%'>";
echo "<tr>";
echo "<td width='33%'></td>";
echo "<td>";

echo "<h1>Raport przetwarzania:</h1>";
echo "<br><input value='$wynik[1]' style='text-align:right'/>: Obroty Wn";
echo "<br><input value='$wynik[2]' style='text-align:right'/>: Obroty Ma";
echo "<br><input value='$wynik[3]' style='text-align:right'/>: Wynik Wn";
echo "<br><input value='$wynik[4]' style='text-align:right'/>: Wynik Ma";

echo '<hr>';

echo '<div class="form-group">';
echo $czas.' czas rozpoczêcia';
echo '</div>';

echo '<div class="form-group">';
echo date('Y-m-d H:i:s').' czas zakoñczenia';
echo '</div>';

echo "</td>";
echo "<td width='33%'></td>";
echo "</tr></table>";

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");