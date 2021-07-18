<?php

@ini_set("session.gc_maxlifetime",28800); 
@ini_set("session.gc_probability",1); 
@ini_set("session.gc_divisor",1); 

require('dbconnect.inc');

session_start();

$ido=$_SESSION['osoba_id'];

//------------------------------------------------------------------------------------------------------------------
//Badanie kandydatów do konwersji

$ileDoKonwersji=0;
$listaAbDoKonwersji='';

$naDzien=date('Y-m-d', strtotime('first day of next month'));    //2018-11-01
$rokMc12=(substr($naDzien,0,4)*1-1).substr($naDzien,4,3); //2017-11
$rokMc24=(substr($naDzien,0,4)*1-2).substr($naDzien,4,3); //2016-11

$w=mysql_query("
  select *
    from specuslugA
   where (  (   DATASTART like '$rokMc12%'
            and OKRES like '12%'
			)
         or (   DATASTART like '$rokMc24%' 
		    and OKRES like '24%'
			)
		 )
     and TYP<>'R'
	 and XCYKLICZNY<>'1'
	 and WARIANTCEN not IN ('S','A','B')
");
while($r=mysql_fetch_array($w))
{
	if( (mysql_fetch_row(mysql_query("
				select count(*)
				  from specuslugA
				 where DATASTART>'$r[DATASTART]'
				   and IDABONENTA='$r[IDABONENTA]'
				   and ZTYTULU='$r[ZTYTULU]'
					"))[0]==0
		)
		and 
		(  (mysql_fetch_row(mysql_query("
					select count(*)
					  from opldod
					 where IDABONENTA='$r[IDABONENTA]'
					   and (DATAOPER between '$r[DATASTART]' and '$naDzien')
					   and (TYPOPER IN ('a','o'))
					   and (if(TYPOPER='o',C1='$r[ZTYTULU]' and C2=122,C1=98))
				"))[0]==0
			)
			or 
			(mysql_fetch_row(mysql_query("
					select count(*)
					  from opldod
					 where IDABONENTA='$r[IDABONENTA]'
					   and (DATAOPER = '$naDzien')
					   and (TYPOPER IN ('o'))
					   and (C1='$r[ZTYTULU]' and C2=112 and C5 IN (65, 66, 83))
				"))[0]<>0
			)
	    )
	  )
	{
		++$ileDoKonwersji;
		$listaAbDoKonwersji.=($listaAbDoKonwersji?',':'').$r['IDABONENTA'];
	}
}

mysql_query("
update filtry
   set OPIS='abonenci.ID IN ($listaAbDoKonwersji)'
where NAZWA='Kandydaci do konwersji'
");

//------------------------------------------------------------------------------------------------------------------
//Badanie kandydatów do konwersji na 2 m-ce w przód

$ileDoKonwersji2=0;
$listaAbDoKonwersji2='';

$naDzien=date('Y-m-d', strtotime("$naDzien +1 month"));    //2020-03-01
$rokMc12=(substr($naDzien,0,4)*1-1).substr($naDzien,4,3); //2017-11
$rokMc24=(substr($naDzien,0,4)*1-2).substr($naDzien,4,3); //2016-11

$w=mysql_query("
  select *
    from specuslugA
   where (  (   DATASTART like '$rokMc12%'
            and OKRES like '12%'
			)
         or (   DATASTART like '$rokMc24%' 
		    and OKRES like '24%'
			)
		 )
     and TYP<>'R'
	 and XCYKLICZNY<>'1'
	 and WARIANTCEN not IN ('S','A','B')
");
while($r=mysql_fetch_array($w))
{
	if( (mysql_fetch_row(mysql_query("
				select count(*)
				  from specuslugA
				 where DATASTART>'$r[DATASTART]'
				   and IDABONENTA='$r[IDABONENTA]'
				   and ZTYTULU='$r[ZTYTULU]'
					"))[0]==0
		)
		and 
		(  (mysql_fetch_row(mysql_query("
					select count(*)
					  from opldod
					 where IDABONENTA='$r[IDABONENTA]'
					   and (DATAOPER between '$r[DATASTART]' and '$naDzien')
					   and (TYPOPER IN ('a','o'))
					   and (if(TYPOPER='o',C1='$r[ZTYTULU]' and C2=122,C1=98))
				"))[0]==0
			)
			or 
			(mysql_fetch_row(mysql_query("
					select count(*)
					  from opldod
					 where IDABONENTA='$r[IDABONENTA]'
					   and (DATAOPER = '$naDzien')
					   and (TYPOPER IN ('o'))
					   and (C1='$r[ZTYTULU]' and C2=112 and C5 IN (65, 66, 83))
				"))[0]<>0
			)
	    )
	  )
	{
		++$ileDoKonwersji2;
		$listaAbDoKonwersji2.=($listaAbDoKonwersji2?',':'').$r['IDABONENTA'];
	}
}

mysql_query("
update filtry
   set OPIS='abonenci.ID IN ($listaAbDoKonwersji2)'
where NAZWA='Kandydaci do konwersji2'
");

//------------------------------------------------------------------------------------------------------------------
//Badanie niedobitków

$niedobitki=0;
$listaAb='';

if(date('d')*1>15)	//badaj/pokazuj to po 15-tym ka¿dego miesi¹ca, tj. po masowym generowaniu faktur
{
	$w=mysql_query("
	  SELECT IDABONENTA
		FROM wplaty
	   where KPLUBBANK IN ('0','1','2')
		 and NRFAKTURY=''
		 and left(DATAWPLATY,7)=left(CurDate(),7)
		 and left(DODNIA,7)<=left(CurDate(),7)
		 and ZTYTULU<>210
		 and ZAMIESIAC<>'2018.08'
	group by IDABONENTA
	  having sum(WYSWPL)>0
	");
	while($r=mysql_fetch_row($w))
	{
		++$niedobitki;
		$listaAb.=($listaAb?',':'').$r[0];
	}

	$w=mysql_query("
	  SELECT IDABONENTA
		FROM splaty
	   where KPLUBBANK IN ('0','1','2')
		 and NRFAKTURY=''
		 and left(DATAWPLATY,7)=left(CurDate(),7)
		 and left(DODNIA,7)<=left(CurDate(),7)
		 and ZTYTULU<>210
		 and left(DODNIA,7)<>'2018-08'
	group by IDABONENTA
	  having sum(WYSWPL)>0
	");
	while($r=mysql_fetch_row($w))
	{
		++$niedobitki;
		$listaAb.=($listaAb?',':'').$r[0];
	}

	mysql_query("
	update filtry
	   set OPIS='abonenci.ID IN ($listaAb)'
	where NAZWA='Niedobitki do fakturowania'
	");
}

//------------------------------------------------------------------------------------------------------------------

if ($_GET['pierwszyRaz']==1) {
    mysql_query("update osoby set CZAS=Now() where ID=19"); //Lemur te¿ jest zalogowany ...
    mysql_query("update abonenci SET ZALEGLE=0");

    mysql_query("truncate table oplatyrob");
    mysql_query("insert into oplatyrob select 0, oplaty.IDABONENTA, '', '', oplaty.DODNIA, oplaty.KWOTA, '', '', '' from oplaty where DODNIA<CurDate()");
    mysql_query("insert into oplatyrob select 0, dlugi.IDABONENTA, '', '', dlugi.DODNIA, dlugi.KWOTA, '', '', '' from dlugi where DODNIA<CurDate()");

    mysql_query("truncate table oplatyrob2");
    mysql_query("insert into oplatyrob2 select 0, oplatyrob.IDABONENTA, '', '', '', sum(oplatyrob.KWOTA), '', '', '' from oplatyrob group by IDABONENTA");
    mysql_query("update abonenci left join oplatyrob2 on oplatyrob2.IDABONENTA=abonenci.ID SET abonenci.ZALEGLE=oplatyrob2.KWOTA");

    require('Aktywni.php');
    require('Uslugi.php');
//    require('OdcinajAuto.php');
    require('MailPDF_login.php');
}

//------------------------------------------------------------------------------------------------------------------
//Badanie odcinanych automatycznie

$doOdciecia=0;
$listaAb='';

$w=mysql_query("
   SELECT DISTINCT(IDABONENTA) 
     FROM oplaty 
left join abonenci 
       on abonenci.ID=oplaty.IDABONENTA 
	WHERE abonenci.STATUS='A' 
	  and (  abonenci.PAKIET_TV=oplaty.ZTYTULU 
	      or abonenci.PAKIET_INT=oplaty.ZTYTULU
		  ) 
	  and Left(DODNIA,7)=Left(Date_Add(Curdate(),interval -3 month),7) 
	  and KWOTA<>0 order by IDABONENTA
");
while($r=mysql_fetch_row($w))
{
	++$doOdciecia;
	$listaAb.=($listaAb?',':'').$r[0];
}

mysql_query("
update filtry
   set OPIS='abonenci.ID IN ($listaAb)'
where NAZWA='Abonenci do odcinania'
");

//------------------------------------------------------------------------------------------------------------------

function getIP()
{
//   $ip_address=$_SERVER['HTTP_X_FORWARDED_FOR'];
//   if ($ip_address==NULL){
      $ip_address=$_SERVER['REMOTE_ADDR']; 
//   }
   return $ip_address;
}

if (@$_GET['punkt']>0) {$_SESSION['osoba_pu']=$_GET['punkt'];}

if (!$_SESSION['osoba_upr']) {
	echo '<script type="text/javascript" language="JavaScript">'."\n";
	echo '<!--'."\n";
	echo 'location.href="Tabela.php?tabela=osoby";'."\n";
	echo '-->'."\n";
	echo '</script>."\n"';
	exit;
} else {

if (@$_SESSION['osoba_se']) {
	$ttab="#D00000";
} else {
	$ttab="#D0DCE0";
}

$tnag="#EFEFDF";
$cnag="#CCCCCC";	//"#FF6600";
$twie="#F5F5F5";	//#FFFFFF";
$cwie="#FFCC66";
$mysz="#B0D0E0";

$tyt='menu g³ówne';
if ($_SESSION['osoba_upr']) {
   $tyt=$_SESSION['osoba_upr'];
}
if (@$_SESSION['osoba_se']) {
	$tyt="<font style='background-color:white;'>&nbsp;&nbsp;&nbsp;&nbsp;BAZA TESTOWA - $tyt&nbsp;&nbsp;&nbsp;&nbsp;</font>";
} else {
	$tyt="Lemur ver 2011.08 (IP: ".getIP().") - $tyt ($ido)";
}

?>
<html>
<head>
<meta http-equiv="refresh" content="1200" >
<meta http-equiv="Content-type" content="text/html; charset=iso-8859-2" />

<?php echo "<title>$tyt</title>";?>

<style type="text/css">
<!--
body {font-family: arial}
a {text-decoration: none; font-style: normal}
td {line-height: 12pt}
.nagtab {background: <?php echo $cnag; ?>; font-family: arial, sans serif; font-size: 12pt}
-->
</style>

<script type="text/javascript" language="JavaScript">
<!--

var r, m;

r=1;
m=1;

<?php
//********************************************************************
// zapamiêtaj stan tabeli dla zalogowanej osoby
@$idt=$_POST['idtab'];

if ($ido) {
   $w=mysql_query("select CZAS from dokwplat order by ID desc limit 1");
   if ($w) {
      $w=mysql_fetch_row($w);
     if ($w) {
        $testdata=$w[0];
        if ($idt) {
            $ipole=$_POST['ipole'];
            $str=$_POST['strpole'];
            $r=$_POST['rpole'];
            $c=$_POST['cpole'];
            $ox=$_POST['offsetX'];
            $oy=$_POST['offsetY'];
            $w=mysql_query("select count(*) from tabeles where ID_TABELE=$idt and ID_OSOBY=$ido"); $w=mysql_fetch_row($w);
            if ($w[0]>0) 	{
               $w=mysql_query(     "update tabeles set ID_POZYCJI=$ipole,NR_STR=$str,NR_ROW=$r,NR_COL=$c,OX_POZYCJI=$ox,OY_POZYCJI=$oy where ID_TABELE=$idt and ID_OSOBY=$ido limit 1");
            } else {
               $w=mysql_query("Insert into tabeles set ID_POZYCJI=$ipole,NR_STR=$str,NR_ROW=$r,NR_COL=$c,OX_POZYCJI=$ox,OY_POZYCJI=$oy,ID_TABELE=$idt,ID_OSOBY=$ido");
            }
        }
        $w=mysql_query($q="select * from tabeles where ID_TABELE=0 and ID_OSOBY=$ido");
        if ($w&&mysql_num_rows($w)>0) {
            $w=mysql_fetch_row($w);
            if ($w[5]) {
            	echo 'r='.$w[5].';';
            	echo 'm='.$w[6].';';
            }
        } else {
            echo 'r=1;';
            echo 'm=1;';
        }
        //require('dbdisconnect.inc');
     }
   }
} else {
	echo 'r=1;';
	echo 'm=1;';
}
// zapamiêtaj stan tabeli dla zalogowanej osoby
//********************************************************************
?>

function UstawKursor()  {

	if(m==1&&r<=0) {m=4;r=6;}	//w górê
	if(m==2&&r<=0) {m=5;r=4;}
	if(m==3&&r<=0) {m=6;r=8;}
	if(m==4&&r<=0) {m=1;r=11;}
	if(m==5&&r<=0) {m=2;r=12;}
	if(m==6&&r<=0) {m=3;r=12;}

	if(m<=0) {m=6;}	//w lewo
	if(m>6) {m=1;}	//w prawo

	if(m==1&&r>11) {m=4;r=1;}	//w dó³
	if(m==2&&r>12) {m=5;r=1;}
	if(m==3&&r>12) {m=6;r=1;}
	if(m==4&&r>6)  {m=1;r=1;}
	if(m==5&&r>5)  {m=2;r=1;}
	if(m==6&&r>8)  {m=3;r=1;}

	if(m==1&&r>11) {r=11;}		//w lewo lub w prawo
	if(m==2&&r>12) {r=12;}
	if(m==3&&r>12) {r=12;}
	if(m==4&&r>6)  {r=5;}
	if(m==5&&r>5)  {r=3;}
	if(m==6&&r>8)  {r=8;}

	eval("p"+m+r+".focus();");
	Nad2(eval("t"+m+r),1);
}

function Nad2(x,n)  {
	if (n==1) {x.style.background="<?php echo $cwie; ?>";}
	if (n==0) {x.style.background="";}
}
function Nad(x,n)  {
	if (n==1) {x.style.background="<?php echo $mysz; ?>";}
	if (n==0) {x.style.background="";}
}
function enter(){
        if (event.keyCode==27) {location.href="Tabela_End.php";}
        if (event.keyCode==37) {Nad2(eval("t"+m+r),0);m--;UstawKursor();}		//lewo
        if (event.keyCode==38) {Nad2(eval("t"+m+r),0);r--;UstawKursor();}		//góra
        if (event.keyCode==39) {Nad2(eval("t"+m+r),0);m++;UstawKursor();}		//prawo
        if (event.keyCode==40) {Nad2(eval("t"+m+r),0);r++;UstawKursor();}		//dó³
}
document.onkeypress=enter;
document.onkeydown=enter;

-->
</script>
</head>

<!--
¹=±
œ=¶
Ÿ=¼
-->

<body onload="UstawKursor()" bgcolor="<?php echo $ttab; ?>" text="#000000" link="#000000" alink="#000000" vlink="#000000" >

<table width="100%" border=0 cellpadding="10" cellspacing="0">

<?php 
echo '<caption align="center" style="font-size:14pt; font-family:Times">'.$tyt;
echo '</caption>';
?>
<tr valign="top" align="center">

<td>
<table width="100%" bgcolor="<?php echo $twie; ?>" border=1 cellpadding="4" cellspacing="0">
<th class="nagtab"><font color="blue">A</font><font color="#A00000">b</font><font color="orange">o</font><font color="blue">n</font><font color="#3F9F0F">e</font><font color="#A00000">n</font>ci</th>
<tr height="5pt">
<td id="t11" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p11" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=abonenci&m=1&mm=1">
&nbsp;Kasa i Bank&nbsp;
<?php 
echo ($niedobitki?'( <a href="ustaw.php?tabela=abonenci&m=1&mm=1&filtr=Niedobitki do fakturowania"><font color="blue"><b><u>'."$niedobitki faktur do wystawienia".'</u></b></font></a> )':'');
echo ($ileDoKonwersji2?'<br>( <a href="ustaw.php?tabela=abonenci&m=1&mm=1&filtr=Kandydaci do konwersji2"><font color="blue"><b><u>'."$ileDoKonwersji2 konwersji pakietów za 2 m-ce".'</u></b></font></a> )':'');
?>
</a></td></tr>
<tr height="5pt">
<td id="t12" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p12" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=abonencisz&m=1&mm=2">
&nbsp;Biuro Obs³ugi Abonenta&nbsp;
<?php 
echo ($ileDoKonwersji?'<br>( <a href="ustaw.php?tabela=abonencisz&m=1&mm=1&filtr=Kandydaci do konwersji"><font color="blue"><b><u>'."$ileDoKonwersji konwersji pakietów za 1 m-c ".'</u></b></font></a> )':'');
echo ($doOdciecia?'<br>( <a href="ustaw.php?tabela=abonencisz&m=1&mm=1&filtr=Abonenci do odcinania"><font color="blue"><b><u>'."$doOdciecia Abonentów do <font color='red'>odciêcia</font>".'</u></b></font></a> )':'');
?>
</a></td></tr>
<tr height="5pt">
<td id="t13" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p13" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=abonencis5&m=1&mm=3">
&nbsp;Biuro Obs³ugi Abonenta - zmiany&nbsp;</a></td></tr>
<tr>
<td id="t14" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p14" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=abonencis3&m=1&mm=4">
&nbsp;Administrator&nbsp;</a></td></tr>
<tr>
<td id="t15" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p15" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=abonencis6&m=1&mm=5">
&nbsp;Ró¿nice w cennikach pocz/zako&nbsp;</a></td></tr>
<tr>
<td id="t16" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)" style="border-top: double #000000">
<a id="p16" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=infoMasowe&m=1&mm=6">
&nbsp;Aktualne zlecenia&nbsp;</a></td></tr>
<tr>
<td id="t17" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p17" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=opldodP&m=1&mm=7">
&nbsp;Aktualne zmiany w danych i us³ugach&nbsp;</a></td></tr>
<tr>
<td id="t18" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p18" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=umowy6&m=1&mm=8">
&nbsp;Aktualne zmiany w umowach&nbsp;</a></td></tr>
<tr>
<td id="t19" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)" style="border-top: double #000000">
<a id="p19" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=faktury&m=1&mm=9">
&nbsp;Faktury VAT&nbsp;
</a></td></tr>
<tr>
<td id="t110" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p110" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=dokwplat&m=1&mm=10">
&nbsp;Dokumenty Kasa/Bank&nbsp;</a></td></tr>
<tr>
<td id="t111" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p111" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=umowy&m=1&mm=11">
&nbsp;Dokumenty BOA&nbsp;
</a></td></tr>
</table>

<br>

<table width="100%" bgcolor="<?php echo $twie; ?>" border=1 cellpadding="4" cellspacing="0">
<th class="nagtab"><font color="blue">O</font>peracje masowe</th>
<tr>
<td id="t41" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p41" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=oplatyzak&m=4&mm=1">
&nbsp;Zak³adanie op³at&nbsp;</a></td></tr>
<tr>
<td id="t42" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p42" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=fakturyzak&m=4&mm=2">
&nbsp;Generowanie faktur&nbsp;</a></td></tr>
<tr>
<td id="t43" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)" style="border-top: double #000000">
<a id="p43" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=maile&m=4&mm=3">
&nbsp;Maile wys³ane&nbsp;</a></td></tr>
<tr>
<td id="t44" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p44" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Lemur2/Wydruki/Tabela/?m=4&mm=4">
&nbsp;Wydruki wed³ug ID abonentów&nbsp;</a></td></tr>
<tr>
<td id="t45" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p45" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Lemur2/WydrukiBlokami/Tabela/?m=4&mm=5">
&nbsp;Wydruki wed³ug Bloków abonentów&nbsp;</a></td></tr>
<tr>
<td id="t46" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)" style="border-top: double #000000">
<a id="p46" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=todo&m=4&mm=6">
&nbsp;Rejestr zmian&nbsp;</a></td></tr>
</table>

</td>

<td>
<table width="100%" bgcolor="<?php echo $twie; ?>" border=1 cellpadding="4" cellspacing="0">
<th class="nagtab"><font color="blue">P</font>arametry</th>
<tr>
<td id="t21" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p21" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=parametry&m=2&mm=1">
&nbsp;Zmienne&nbsp;</a></td></tr>
<tr>
<td id="t22" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p22" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=banki&m=2&mm=2">
&nbsp;Konta bankowe&nbsp;</a></td></tr>
<tr>
<td id="t23" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p23" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=osiedla&m=2&mm=3">
&nbsp;Osiedla&nbsp;</a></td></tr>
<tr>
<td id="t24" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p24" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=ulice&m=2&mm=4">
&nbsp;Ulice&nbsp;</a></td></tr>
<tr>
<td id="t25" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p25" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=grupyA&m=2&mm=5">
&nbsp;Grupy&nbsp;</a></td></tr>
<tr>
<td id="t26" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p26" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=stawkvat&m=2&mm=6">
&nbsp;Stawki VAT&nbsp;</a></td></tr>
<tr>
<td id="t27" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p27" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=typydok&m=2&mm=7">
&nbsp;Typy dokumentów&nbsp;</a></td></tr>
<tr>
<td id="t28" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)" style="border-top: double #000000">
<a id="p28" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=typoplatAA&m=2&mm=8">
&nbsp;Tytu³y op³at / Aktywne us³ugi&nbsp;</a></td></tr>
<tr>
<td id="t29" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p29" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=typoplatAT&m=2&mm=9">
&nbsp;Tytu³y op³at / Parametry&nbsp;</a></td></tr>
<tr>
<td id="t210" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)" style="border-top: double #000000">
<a id="p210" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=slownik&m=2&mm=10">
&nbsp;S³ownik tematów info&nbsp;</a></td></tr>
<tr>
<td id="t211" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p211" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=odsetki&m=2&mm=11">
&nbsp;Odsetki ustawowe&nbsp;</a></td></tr>
<tr>
<td id="t212" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p212" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=promocje&m=2&mm=12">
&nbsp;Promocje&nbsp;</a></td></tr>
</table>

<br>

<table width="100%" bgcolor="<?php echo $twie; ?>" border=1 cellpadding="4" cellspacing="0">
<th class="nagtab"><font color="blue">I</font>nne</th>
<tr>
<td id="t51" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p51" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=specbuf4&m=5&mm=1">
&nbsp;Raport UKE SIIS za XII&nbsp;</a></td></tr>
<tr>
<td id="t52" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p52" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=specbuf5&m=5&mm=2">
&nbsp;Raport COCOM za VII&nbsp;</a></td></tr>
<tr>
<td id="t53" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p53" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=opis&m=5&mm=3">
&nbsp;Instrukcja&nbsp;</a></td></tr>
<tr>
<td id="t54" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p54" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Historia.php?m=5&mm=4">
&nbsp;Historia systemu&nbsp;</a></td></tr>
<tr>
<td id="t55" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p55" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="http://www.ericom.pl">
&nbsp;Strona domowa systemu&nbsp;</a></td></tr>
</table>

</td>

<td>
<table width="100%" bgcolor="<?php echo $twie; ?>" border=1 cellpadding="4" cellspacing="0">
<th class="nagtab"><font color="blue">Z</font>estawienia</th>
<tr>
<td id="t31" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p31" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=zestwpkp&m=3&mm=1">
&nbsp;1 a. Wp³aty z KP analitycznie&nbsp;</a></td></tr>
<tr>
<td id="t32" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p32" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=zestwpko&m=3&mm=2">
&nbsp;2 b. Wp³aty z KP wed³ug operatorów&nbsp;</a></td></tr>
<tr>
<td id="t33" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)" style="border-top: double #000000">
<a id="p33" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=zestwpbp&m=3&mm=3">
&nbsp;3 e. Zbiorówki z banków dniami&nbsp;</a></td></tr>
<tr>
<td id="t34" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p34" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=zestwpbp1r&m=3&mm=4">
&nbsp;3 f1. Zbiorówki z banków grupami (PKO)&nbsp;</a></td></tr>
<tr>
<td id="t35" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p35" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=zestwpbp2r&m=3&mm=5">
&nbsp;3 f2. Zbiorówki z banków grupami (MEDIA)&nbsp;</a></td></tr>
<tr>
<td id="t36" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)" style="border-top: double #000000">
<a id="p36" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=zestwpbpsy&m=3&mm=6">
&nbsp;3 h. Zbiorówki z banków abonentami&nbsp;</a></td></tr>
<tr>
<td id="t37" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p37" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=zestwpb1sy&m=3&mm=7">
&nbsp;3 h1. Zbiorówki z banków abonentami (PKO)&nbsp;</a></td></tr>
<tr>
<td id="t38" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p38" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=zestwpb2sy&m=3&mm=8">
&nbsp;3 h2. Zbiorówki z banków abonentami (MEDIA)&nbsp;</a></td></tr>
<tr>
<td id="t39" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)" style="border-top: double #000000">
<a id="p39" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=zestfa&m=3&mm=9">
&nbsp;5 a. Faktury z okresu&nbsp;</a></td></tr>
<tr>
<td id="t310" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p310" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=zestfk&m=3&mm=10">
&nbsp;5 b. Faktury koryguj±ce z okresu&nbsp;</a></td></tr>
<tr>
<td id="t311" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p311" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=zestzaop1&m=3&mm=11">
&nbsp;10 b. Zaleg³e op³aty o terminach w okresie&nbsp;</a></td></tr>
<tr>
<td id="t312" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)" style="border-top: double #000000">
<a id="p312" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=zestawy&m=3&mm=12">
&nbsp;Zestawienia wszystkie&nbsp;</a></td></tr>
</table>

<br>

<table width="100%" bgcolor="<?php echo $twie; ?>" border=1 cellpadding="4" cellspacing="0">
<th class="nagtab"><font color="blue">Z</font>arz±dzanie danymi</th>
<tr>
<td id="t61" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p61" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=wzoryumow&m=6&mm=1">
&nbsp;Wzory wydruków&nbsp;</a></td></tr>
<tr>
<td id="t62" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p62" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Konserwuj.php?m=6&mm=2">
&nbsp;Konserwacja danych&nbsp;</a></td></tr>
<tr>
<td id="t63" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p63" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Lemur2/JPK_VAT3/index.php?m=6&mm=3">
&nbsp;JPK_VAT (3) (okres 2018.01-2020.09)&nbsp;</a></td></tr>
<tr>
<td id="t64" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p64" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Lemur2/JPK_FA2/index.php?m=6&mm=4">
&nbsp;JPK_FA (2) (okres 2019.07-2019.10)&nbsp;</a></td></tr>
<tr>
<td id="t65" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p65" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Lemur2/JPK_FA3/index.php?m=6&mm=5">
&nbsp;JPK_FA (3) (okres 2019.11-...)&nbsp;</a></td></tr>
<tr>
<td id="t66" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p66" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Lemur2/JPK_V7M/index.php?m=6&mm=6">
&nbsp;JPK_V7M (1) (okres 2020.10-...)&nbsp;</a></td></tr>
<tr>
<td id="t67" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p67" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Lemur2/GUS/index.php?m=6&mm=7">
&nbsp;GUS&nbsp;</a></td></tr>
<tr>
<td id="t68" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)" style="border-top: double #000000">
<a id="p68" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="Tabela.php?tabela=osobyp&m=6&mm=8">
&nbsp;Zmiana operatora&nbsp;</a></td></tr>
</table>

</td>

</tr>
</table>
</body>
</html>

<?php 
/*
<tr>
<td id="t69" onmouseover="Nad(this,1)" onmouseout="Nad(this,0)">
<a id="p69" onfocus="Nad2(this,1)" onblur="Nad2(this,0)" href="ZmianaBazy.php?m=6&mm=9">
&nbsp;Zmiana bazy (Testowa 
<?php if ($testdata) {echo "($testdata)";}?>
<-> G³ówna)&nbsp;</a></td></tr>
*/
} 
?>