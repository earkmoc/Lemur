<?php

//die(print_r($_POST));

$czas=date('Y-m-d H:i:s');
ini_set('max_execution_time', 600);
error_reporting(E_ERROR | E_PARSE);

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

mysqli_query($link, "ALTER TABLE `slownik` CHANGE `OPIS` `OPIS` text NOT NULL DEFAULT ''");
mysqli_query($link, "ALTER TABLE `slownik` ADD UNIQUE `TST` (`TYP`, `SYMBOL`, `TRESC`)");

foreach($_POST as $key => $value)
{
	$value=AddSlashes($value);
	$sets="TYP='parametry'
	   , SYMBOL='ZSY'
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

mysqli_query($link,"truncate zest1sr");

if (($_POST['gdzie']=='bufor')||($_POST['gdzie']=='ksiêgi i bufor')) 
{
$z="insert into zest1sr select 0, KONTOWN, '', WINIEN, 0, 0, 0, WINIEN, 0, 0, 0, dokumentk.PRZEDMIOT, $ido from dokumentk left join dokumenty on (dokumenty.ID=dokumentk.ID_D) where KONTOWN<>'' and (dokumenty.DOPERACJI <       '".$_POST['data1']                      ."') and GDZIE='bufor'"; mysqli_query($link,$z);
$z="insert into zest1sr select 0, KONTOMA, '', 0, WINIEN, 0, 0, 0, WINIEN, 0, 0, dokumentk.PRZEDMIOT, $ido from dokumentk left join dokumenty on (dokumenty.ID=dokumentk.ID_D) where KONTOMA<>'' and (dokumenty.DOPERACJI <       '".$_POST['data1']                      ."') and GDZIE='bufor'"; mysqli_query($link,$z);
$z="insert into zest1sr select 0, KONTOWN, '', WINIEN, 0, 0, 0, 0, 0, WINIEN, 0, dokumentk.PRZEDMIOT, $ido from dokumentk left join dokumenty on (dokumenty.ID=dokumentk.ID_D) where KONTOWN<>'' and (dokumenty.DOPERACJI between '".$_POST['data1']."' and '".$_POST['data2']."') and GDZIE='bufor'"; mysqli_query($link,$z);
$z="insert into zest1sr select 0, KONTOMA, '', 0, WINIEN, 0, 0, 0, 0, 0, WINIEN, dokumentk.PRZEDMIOT, $ido from dokumentk left join dokumenty on (dokumenty.ID=dokumentk.ID_D) where KONTOMA<>'' and (dokumenty.DOPERACJI between '".$_POST['data1']."' and '".$_POST['data2']."') and GDZIE='bufor'"; mysqli_query($link,$z);
}

if (($_POST['gdzie']=='ksiêgi')||($_POST['gdzie']=='ksiêgi i bufor')) 
{
//BO poprzedniego roku
//$z="insert into zest1sr select 0,  WINIEN, '',   KWOTA, 0, 0, 0, KWOTA, 0, 0, 0, '', $ido from nordpol where WINIEN<>'' and (Year(DATA)+1 = Year('".$_POST['data1']."')) and not(DOK='BO' and DATA between '".$_POST['data1']."' and '".$_POST['data2']."')"; mysqli_query($link,$z);
//$z="insert into zest1sr select 0,      MA, '',  0,  KWOTA, 0, 0, 0, KWOTA, 0, 0, '', $ido from nordpol where     MA<>'' and (Year(DATA)+1 = Year('".$_POST['data1']."')) and not(DOK='BO' and DATA between '".$_POST['data1']."' and '".$_POST['data2']."')"; mysqli_query($link,$z);
$z="insert into zest1sr select 0,  WINIEN, '',   KWOTA, 0, 0, 0, KWOTA, 0, 0, 0, '', $ido from nordpol where WINIEN<>'' and (Year(DATA)+1 = Year('".$_POST['data1']."'))"; mysqli_query($link,$z);
$z="insert into zest1sr select 0,      MA, '',  0,  KWOTA, 0, 0, 0, KWOTA, 0, 0, '', $ido from nordpol where     MA<>'' and (Year(DATA)+1 = Year('".$_POST['data1']."'))"; mysqli_query($link,$z);

//obroty bie¿¹cego roku wp³ywaj¹ce na BO (gdy okres nie od 1-go stycznia)
//$z="insert into zest1sr select 0,  WINIEN, '',   KWOTA, 0, 0, 0, KWOTA, 0, 0, 0, '', $ido from nordpol where WINIEN<>'' and (DATA <       '".$_POST['data1']."' and Year(DATA)=Year('".$_POST['data1']."')) and not(DOK='BO' and DATA between '".$_POST['data1']."' and '".$_POST['data2']."')"; mysqli_query($link,$z);
//$z="insert into zest1sr select 0,      MA, '',  0,  KWOTA, 0, 0, 0, KWOTA, 0, 0, '', $ido from nordpol where     MA<>'' and (DATA <       '".$_POST['data1']."' and Year(DATA)=Year('".$_POST['data1']."')) and not(DOK='BO' and DATA between '".$_POST['data1']."' and '".$_POST['data2']."')"; mysqli_query($link,$z);
$z="insert into zest1sr select 0,  WINIEN, '',   KWOTA, 0, 0, 0, KWOTA, 0, 0, 0, '', $ido from nordpol where WINIEN<>'' and (DATA <       '".$_POST['data1']."' and Year(DATA)=Year('".$_POST['data1']."'))"; mysqli_query($link,$z);
$z="insert into zest1sr select 0,      MA, '',  0,  KWOTA, 0, 0, 0, KWOTA, 0, 0, '', $ido from nordpol where     MA<>'' and (DATA <       '".$_POST['data1']."' and Year(DATA)=Year('".$_POST['data1']."'))"; mysqli_query($link,$z);

//obroty bie¿¹cego roku
//$z="insert into zest1sr select 0,  WINIEN, '',   KWOTA, 0, 0, 0, 0, 0, KWOTA, 0, '', $ido from nordpol where WINIEN<>'' and (DATA between '".$_POST['data1']."' and '".$_POST['data2']."') and not(DOK='BO' and DATA between '".$_POST['data1']."' and '".$_POST['data2']."')"; mysqli_query($link,$z);
//$z="insert into zest1sr select 0,      MA, '',  0,  KWOTA, 0, 0, 0, 0, 0, KWOTA, '', $ido from nordpol where     MA<>'' and (DATA between '".$_POST['data1']."' and '".$_POST['data2']."') and not(DOK='BO' and DATA between '".$_POST['data1']."' and '".$_POST['data2']."')"; mysqli_query($link,$z);
$z="insert into zest1sr select 0,  WINIEN, '',   KWOTA, 0, 0, 0, 0, 0, KWOTA, 0, '', $ido from nordpol where WINIEN<>'' and (DATA between '".$_POST['data1']."' and '".$_POST['data2']."')"; mysqli_query($link,$z);
$z="insert into zest1sr select 0,      MA, '',  0,  KWOTA, 0, 0, 0, 0, 0, KWOTA, '', $ido from nordpol where     MA<>'' and (DATA between '".$_POST['data1']."' and '".$_POST['data2']."')"; mysqli_query($link,$z);
}

$z='left(KONTO,'.$_POST['ile'].")";
mysqli_query($link,"delete from zest1s where ID_OSOBYUPR=$ido");
mysqli_query($link,"insert into zest1s select 0, $z, '', sum(OBROTYWN), sum(OBROTYMA), 0, 0, sum(BO_WINIEN), sum(BO_MA), sum(OBROTYMW), sum(OBROTYMM), '', $ido from zest1sr group by $z");
//mysqli_query($link,"update      zest1s set SALDOWN=if(OBROTYWN>OBROTYMA,OBROTYWN-OBROTYMA,0), SALDOMA=if(OBROTYWN<OBROTYMA,-OBROTYWN+OBROTYMA,0) where ID_OSOBYUPR=$ido");
mysqli_query($link,"update    zest1s left join knordpol on (knordpol.KONTO like concat(zest1s.KONTO,'%')) set zest1s.SALDOWN=if(zest1s.OBROTYWN>zest1s.OBROTYMA,zest1s.OBROTYWN-zest1s.OBROTYMA,0), zest1s.SALDOMA=if(zest1s.OBROTYWN<zest1s.OBROTYMA,-zest1s.OBROTYWN+zest1s.OBROTYMA,0), zest1s.NAZWA=knordpol.TRESC where ID_OSOBYUPR=$ido");

$w=mysqli_query($link,"
	select   0
			,format(sum(BO_WINIEN),2)
			,format(sum(BO_MA),2)
			,format(sum(OBROTYMW),2)
			,format(sum(OBROTYMM),2)
			,format(sum(OBROTYWN),2)
			,format(sum(OBROTYMA),2)
			,format(sum(SALDOWN),2)
			,format(sum(SALDOMA),2)
			,format(if(sum(SALDOWN)>sum(SALDOMA),sum(SALDOWN)-sum(SALDOMA),0),2)
			,format(if(sum(SALDOWN)<sum(SALDOMA),sum(SALDOMA)-sum(SALDOWN),0),2)
		from zest1s
	   where ID_OSOBYUPR=$ido
");
$wynik=mysqli_fetch_row($w);

$title="Przetwarzanie: raport";
$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"..");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

echo "<table width='100%' height='100%'>";
echo "<tr>";
echo "<td width='33%'></td>";
echo "<td>";

echo "<h1>Raport przetwarzania:</h1>";
echo "<br><input value='$wynik[1]' style='text-align:right'/>: BO Wn";
echo "<br><input value='$wynik[2]' style='text-align:right'/>: BO Ma";
echo "<br><input value='$wynik[3]' style='text-align:right'/>: Obroty miesi±ca Wn";
echo "<br><input value='$wynik[4]' style='text-align:right'/>: Obroty miesi±ca Ma";
echo "<br><input value='$wynik[5]' style='text-align:right'/>: Obroty Wn";
echo "<br><input value='$wynik[6]' style='text-align:right'/>: Obroty Ma";
echo "<br><input value='$wynik[7]' style='text-align:right'/>: Saldo Wn";
echo "<br><input value='$wynik[8]' style='text-align:right'/>: Saldo Ma";
echo "<br><input value='$wynik[9]' style='text-align:right'/>: Wynik Wn";
echo "<br><input value='$wynik[10]' style='text-align:right'/>: Wynik Ma";

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