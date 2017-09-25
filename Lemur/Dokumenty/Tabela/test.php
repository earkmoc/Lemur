<?php

//die(print_r($_POST));

$raport='';
$czas=date('Y-m-d H:i:s');
ini_set('max_execution_time', 600);
error_reporting(E_ERROR | E_PARSE);

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$kl=$baza;
$dk='dokumenty';
$rej='dokumentr';

$title="Test: raport";
$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"..");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

echo "<table width='100%' height='100%'>";
echo "<tr>";
echo "<td>";

//----------------------------------------------------------------------------------------------------------------------------------------------

echo "<br>";

echo "Gdzie jest brak Nazwy lub NIP kontrahenta:";
echo "<table border='1' cellspacing='0' cellpadding='5'>";

$lp=0;
$zDK=mysqli_query($link,"select * from $kl.$dk where NIP='' or NAZWA=''");
while($dokument=mysqli_fetch_array($zDK))
{
	++$lp;
	echo "<tr>";
	echo "<td>$lp.</td><td>$dokument[ID]</td><td>$dokument[TYP]</td><td>$dokument[NUMER]</td><td>$dokument[DOPERACJI]</td><td>$rejestr[OKRES]</td>";
	echo "</tr>";
}
if($lp==0) {echo "<tr><td>Wszystko OK.</td></tr>";}
echo "</table>";

//----------------------------------------------------------------------------------------------------------------------------------------------

echo "<br>";

echo "Gdzie jest niezgodno¶æ okresu sprawozdawczego dokumentu i zapisów w zak³adce rejestrów:";
echo "<table border='1' cellspacing='0' cellpadding='5'>";

$lp=0;
$zDK=mysqli_query($link,"select * from $kl.$dk");
while($dokument=mysqli_fetch_array($zDK))
{
	$zREJ=mysqli_query($link,"select * from $kl.$rej where ID_D=$dokument[ID]");
	while($rejestr=mysqli_fetch_array($zREJ))
	{
		if($rejestr['OKRES']<>substr($dokument['DOPERACJI'],0,7))
		{
			++$lp;
			echo "<tr>";
			echo "<td>$lp.</td><td>$dokument[ID]</td><td>$dokument[TYP]</td><td>$dokument[NUMER]</td><td>$dokument[DOPERACJI]</td><td>$rejestr[OKRES]</td>";
			echo "</tr>";
		}
	}
}
if($lp==0) {echo "<tr><td>Wszystko OK.</td></tr>";}
echo "</table>";

//----------------------------------------------------------------------------------------------------------------------------------------------

$delty=mysqli_query($link,"
	select $kl.$dk.ID
		 , $kl.$dk.TYP
		 , $kl.$dk.NUMER
		 , $kl.$dk.DOPERACJI
		 , $kl.$dk.NETTOVAT as dn
		 , $kl.$dk.PODATEK_VAT as dv
		 , $kl.$dk.WARTOSC as db
		 , sum($kl.$rej.NETTO) as sn
		 , sum($kl.$rej.VAT) as sv
		 , sum($kl.$rej.BRUTTO) as sb
	  from $kl.$dk 
 left join $kl.$rej 
		on $kl.$rej.ID_D=$kl.$dk.ID
	 where 1
  group by $kl.$dk.ID
	having sn<>dn
		or sv<>dv
		or sb<>db
  order by $kl.$dk.DOPERACJI
");

echo "<br>";

echo "Gdzie jest niezgodno¶æ kwot dokumentów (wy¿ej) i kwot zak³adki rejestrów (ni¿ej): <a href='testp.php'>popraw wszystkie</a>";
echo "<table border='1' cellspacing='0' cellpadding='5'>";
$lp=0;
while($dokument=mysqli_fetch_array($delty))
{
	++$lp;
	//die(print_r($delta));
	echo "<tr>";
	echo "<td>$lp.</td><td>$dokument[ID]</td><td>$dokument[TYP]</td><td>$dokument[NUMER]</td><td>$dokument[DOPERACJI]</td><td>$dokument[dn]</td><td>$dokument[dv]</td><td>$dokument[db]</td>";
	echo "</tr>";
	echo "<tr>";
	echo "<td colspan='5'></td><td>$dokument[sn]</td><td>$dokument[sv]</td><td>$dokument[sb]</td>";
	echo "</tr>";
	if	( ($dokument['db']==$dokument['sb'])
		&&($dokument['dn']==0)
		&&($dokument['dv']==0)
		)
	{
		mysqli_query($link,$q="
			update $kl.$dk
			   set $kl.$dk.NETTOVAT=$dokument[sn]
				 , $kl.$dk.PODATEK_VAT=$dokument[sv]
			 where $kl.$dk.ID=$dokument[ID]
			 limit 1
		");
	}
}
if($lp==0) {echo "<tr><td>Wszystko OK.</td></tr>";}
echo "</table>";

//----------------------------------------------------------------------------------------------------------------------------------------------

$delty=mysqli_query($link,"
	select $kl.$dk.ID
		 , $kl.$dk.TYP
		 , $kl.$dk.NUMER
		 , $kl.$dk.DOPERACJI
		 , $kl.$dk.NETTOVAT as dn
		 , $kl.$dk.PODATEK_VAT as dv
		 , $kl.$dk.WARTOSC as db
	  from $kl.$dk 
 left join $kl.$rej 
		on $kl.$rej.ID_D=$kl.$dk.ID
	 where 1
	   and isnull($kl.$rej.ID)
  order by $kl.$dk.DOPERACJI
");

echo "<br>";

echo "Gdzie brakuje zapisu w zak³adce rejestrów:";
echo "<table border='1' cellspacing='0' cellpadding='5'>";
$lp=0;
while($dokument=mysqli_fetch_array($delty))
{
	++$lp;
	//die(print_r($delta));
	echo "<tr>";
	echo "<td>$lp.</td><td>$dokument[ID]</td><td>$dokument[TYP]</td><td>$dokument[NUMER]</td><td>$dokument[DOPERACJI]</td><td>$dokument[dn]</td><td>$dokument[dv]</td><td>$dokument[db]</td>";
	echo "</tr>";
}
if($lp==0) {echo "<tr><td>Wszystko OK.</td></tr>";}
echo "</table>";

//----------------------------------------------------------------------------------------------------------------------------------------------

$stawki=mysqli_fetch_row(mysqli_query($link,"
	select group_concat(concat('\'',SYMBOL,'\''))
	  from $kl.slownik 
	 where TYP='dokumentrs'
"))[0];

$stawki.=",'0%'";

$delty=mysqli_query($link,$q="
	select $kl.$dk.ID
		 , $kl.$dk.TYP
		 , $kl.$dk.NUMER
		 , $kl.$dk.DOPERACJI
		 , $kl.$dk.NETTOVAT as dn
		 , $kl.$dk.PODATEK_VAT as dv
		 , $kl.$dk.WARTOSC as db
		 , $kl.$rej.STAWKA as stawka
	  from $kl.$dk 
 left join $kl.$rej 
		on $kl.$rej.ID_D=$kl.$dk.ID
	 where $kl.$rej.STAWKA not IN ($stawki)
  order by $kl.$dk.DOPERACJI
");

echo "<br>";

echo "Gdzie s± zapisy w zak³adce rejestrów z niezgodnymi stawkami VAT:";
echo "<table border='1' cellspacing='0' cellpadding='5'>";
$lp=0;
while($dokument=mysqli_fetch_array($delty))
{
	++$lp;
	//die(print_r($delta));
	echo "<tr>";
	echo "<td>$lp.</td><td>$dokument[ID]</td><td>$dokument[TYP]</td><td>$dokument[NUMER]</td><td>$dokument[DOPERACJI]</td><td>$dokument[dn]</td><td>$dokument[dv]</td><td>$dokument[db]</td><td><b>$dokument[stawka]</b></td>";
	echo "</tr>";
}
if($lp==0) {echo "<tr><td>Wszystko OK.</td></tr>";}
echo "</table>";

//----------------------------------------------------------------------------------------------------------------------------------------------

$delty=mysqli_query($link,$q="
	select $kl.$dk.ID
		 , $kl.$dk.TYP
		 , $kl.$dk.NUMER
		 , $kl.$dk.DOPERACJI
		 , $kl.$rej.NETTO as rn
		 , $kl.$rej.STAWKA as stawka
		 , $kl.$rej.VAT as rv
		 , $kl.$rej.BRUTTO as rb
		 , round($kl.$rej.NETTO+$kl.$rej.VAT,2) as tb
		 , round($kl.$rej.NETTO*$kl.$rej.STAWKA*0.01,2) as tv
	  from $kl.$dk 
 left join $kl.$rej 
		on $kl.$rej.ID_D=$kl.$dk.ID
	 where abs(round($kl.$rej.NETTO+$kl.$rej.VAT,2)-$kl.$rej.BRUTTO)>100.00
	    or abs(round($kl.$rej.NETTO*$kl.$rej.STAWKA*0.01,2)-$kl.$rej.VAT)>100.00
  order by $kl.$dk.DOPERACJI
");

echo "<br>";

echo "Gdzie s± zapisy w zak³adce rejestrów z niezgodnymi o co najmniej 100 PLN warto¶ciami Netto, VAT, Brutto:";
echo "<table border='1' cellspacing='0' cellpadding='5'>";
$lp=0;
while($dokument=mysqli_fetch_array($delty))
{
	++$lp;
	//die(print_r($delta));
	echo "<tr>";
	echo "<td>$lp.</td><td>$dokument[ID]</td><td>$dokument[TYP]</td><td>$dokument[NUMER]</td><td>$dokument[DOPERACJI]</td><td>$dokument[rn]</td><td>$dokument[rv]</td><td>$dokument[rb]</td><td><b>$dokument[stawka]</b></td>";
	echo "</tr>";
	echo "<tr>";
	echo "<td colspan='6' align='right'>a teoretycznie powinno byæ</td><td>$dokument[tv]</td><td>$dokument[tb]</td>";
	echo "</tr>";
}
if($lp==0) {echo "<tr><td>Wszystko OK.</td></tr>";}
echo "</table>";

//----------------------------------------------------------------------------------------------------------------------------------------------

$delty=mysqli_query($link,$q="
	select $kl.$dk.ID
		 , $kl.$dk.TYP
		 , $kl.$dk.NUMER
		 , $kl.$dk.DOPERACJI
		 , $kl.$rej.NETTO as rn
		 , $kl.$rej.STAWKA as stawka
		 , $kl.$rej.VAT as rv
		 , $kl.$rej.BRUTTO as rb
		 , round($kl.$rej.NETTO+$kl.$rej.VAT,2) as tb
		 , round($kl.$rej.NETTO*$kl.$rej.STAWKA*0.01,2) as tv
	  from $kl.$dk 
 left join $kl.$rej 
		on $kl.$rej.ID_D=$kl.$dk.ID
	 where abs(round($kl.$rej.NETTO+$kl.$rej.VAT,2)-$kl.$rej.BRUTTO)>10.00
	    or abs(round($kl.$rej.NETTO*$kl.$rej.STAWKA*0.01,2)-$kl.$rej.VAT)>10.00
  order by $kl.$dk.DOPERACJI
");

echo "<br>";

echo "Gdzie s± zapisy w zak³adce rejestrów z niezgodnymi o co najmniej 10 PLN warto¶ciami Netto, VAT, Brutto:";
echo "<table border='1' cellspacing='0' cellpadding='5'>";
$lp=0;
while($dokument=mysqli_fetch_array($delty))
{
	++$lp;
	//die(print_r($delta));
	echo "<tr>";
	echo "<td>$lp.</td><td>$dokument[ID]</td><td>$dokument[TYP]</td><td>$dokument[NUMER]</td><td>$dokument[DOPERACJI]</td><td>$dokument[rn]</td><td>$dokument[rv]</td><td>$dokument[rb]</td><td><b>$dokument[stawka]</b></td>";
	echo "</tr>";
	echo "<tr>";
	echo "<td colspan='6' align='right'>a teoretycznie powinno byæ</td><td>$dokument[tv]</td><td>$dokument[tb]</td>";
	echo "</tr>";
}
if($lp==0) {echo "<tr><td>Wszystko OK.</td></tr>";}
echo "</table>";

//----------------------------------------------------------------------------------------------------------------------------------------------

$delty=mysqli_query($link,$q="
	select $kl.$dk.ID
		 , $kl.$dk.TYP
		 , $kl.$dk.NUMER
		 , $kl.$dk.DOPERACJI
		 , $kl.$rej.NETTO as rn
		 , $kl.$rej.STAWKA as stawka
		 , $kl.$rej.VAT as rv
		 , $kl.$rej.BRUTTO as rb
		 , round($kl.$rej.NETTO+$kl.$rej.VAT,2) as tb
		 , round($kl.$rej.NETTO*$kl.$rej.STAWKA*0.01,2) as tv
	  from $kl.$dk 
 left join $kl.$rej 
		on $kl.$rej.ID_D=$kl.$dk.ID
	 where abs(round($kl.$rej.NETTO+$kl.$rej.VAT,2)-$kl.$rej.BRUTTO)>1.00
	    or abs(round($kl.$rej.NETTO*$kl.$rej.STAWKA*0.01,2)-$kl.$rej.VAT)>1.00
  order by $kl.$dk.DOPERACJI
");

echo "<br>";

echo "Gdzie s± zapisy w zak³adce rejestrów z niezgodnymi o co najmniej 1 PLN warto¶ciami Netto, VAT, Brutto:";
echo "<table border='1' cellspacing='0' cellpadding='5'>";
$lp=0;
while($dokument=mysqli_fetch_array($delty))
{
	++$lp;
	//die(print_r($delta));
	echo "<tr>";
	echo "<td>$lp.</td><td>$dokument[ID]</td><td>$dokument[TYP]</td><td>$dokument[NUMER]</td><td>$dokument[DOPERACJI]</td><td>$dokument[rn]</td><td>$dokument[rv]</td><td>$dokument[rb]</td><td><b>$dokument[stawka]</b></td>";
	echo "</tr>";
	echo "<tr>";
	echo "<td colspan='6' align='right'>a teoretycznie powinno byæ</td><td>$dokument[tv]</td><td>$dokument[tb]</td>";
	echo "</tr>";
}
if($lp==0) {echo "<tr><td>Wszystko OK.</td></tr>";}
echo "</table>";

//----------------------------------------------------------------------------------------------------------------------------------------------

$delty=mysqli_query($link,$q="
	select $kl.$dk.ID
		 , $kl.$dk.TYP
		 , $kl.$dk.NUMER
		 , $kl.$dk.DOPERACJI
		 , $kl.$rej.NETTO as rn
		 , $kl.$rej.STAWKA as stawka
		 , $kl.$rej.VAT as rv
		 , $kl.$rej.BRUTTO as rb
		 , round($kl.$rej.NETTO+$kl.$rej.VAT,2) as tb
		 , round($kl.$rej.NETTO*$kl.$rej.STAWKA*0.01,2) as tv
	  from $kl.$dk 
 left join $kl.$rej 
		on $kl.$rej.ID_D=$kl.$dk.ID
	 where round($kl.$rej.NETTO+$kl.$rej.VAT,2)<>$kl.$rej.BRUTTO
	    or round($kl.$rej.NETTO*$kl.$rej.STAWKA*0.01,2)<>$kl.$rej.VAT
  order by $kl.$dk.DOPERACJI
");

echo "<br>";

echo "Gdzie s± zapisy w zak³adce rejestrów z niezgodnymi warto¶ciami Netto, VAT, Brutto:";
echo "<table border='1' cellspacing='0' cellpadding='5'>";
$lp=0;
while($dokument=mysqli_fetch_array($delty))
{
	++$lp;
	//die(print_r($delta));
	echo "<tr>";
	echo "<td>$lp.</td><td>$dokument[ID]</td><td>$dokument[TYP]</td><td>$dokument[NUMER]</td><td>$dokument[DOPERACJI]</td><td>$dokument[rn]</td><td>$dokument[rv]</td><td>$dokument[rb]</td><td><b>$dokument[stawka]</b></td>";
	echo "</tr>";
	echo "<tr>";
	echo "<td colspan='6' align='right'>a teoretycznie powinno byæ</td><td>$dokument[tv]</td><td>$dokument[tb]</td>";
	echo "</tr>";
}
if($lp==0) {echo "<tr><td>Wszystko OK.</td></tr>";}
echo "</table>";

//----------------------------------------------------------------------------------------------------------------------------------------------

echo '<hr>';

echo '<div class="form-group">';
echo $czas.' czas rozpoczêcia';
echo '<br>';
echo date('Y-m-d H:i:s').' czas zakoñczenia';
echo '</div>';

echo "</td>";
echo "</tr></table>";

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");