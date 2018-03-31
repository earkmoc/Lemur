<?php

$innaBaza='Lemur2';
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$q=mysqli_query($link,"
select *
  from Lemur2.klienci
 where PSKONT='$baza'
");
while($r=mysqli_fetch_array($q))
{
	$nazwa="$r[NAZWA]";
	$adres="$r[ADRES]";
	$nip="$r[NIP]";
	$telefony="$r[OPIS]";
}

//$innaBaza='';
//require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
?>
<table border="0" width="100%">
<tr>
<td>
	<table cellspacing="0" cellpadding="3" rules="none" width="378" bgcolor="#ffffff" border="1" frame="box">
	<tbody>
	<tr align="middle">
		<td nowrap><font style="font-size:20pt"><?php echo $nazwa;?></font></td>
	</tr>
	<tr align="middle">
		<td><?php echo $adres;?></td>
	</tr>
	<tr align="middle">
		<td>NIP: <?php echo $nip;?></td>
	</tr>
	<tr align="middle">
		<td style="FONT-SIZE: 12px"><?php echo $ttelefony;?></td>
	</tr>
	</tbody>
	</table>
</td>

<td align="right">
	<table cellspacing="0" cellpadding="0" bgcolor="#ffffff">
	<tbody>
	<tr>
		<td style="FONT-SIZE: 15px" align="right">Data wydruku:&nbsp;</td>
		<td style="FONT-SIZE: 15px" align="left" id="dataw"><?php echo (@$_POST['data']?$_POST['data']:date('Y.m.d'));?></td>
	</tr>
	<tr>
		<td style="FONT-SIZE: 15px" align="right">Czas wydruku:&nbsp;</td>
		<td style="FONT-SIZE: 15px" align="left" id="czasw"><?php echo (@$_POST['czas']?$_POST['czas']:date('G.i.s'));?></td>
	</tr>
	</tbody>
	</table>
</td>
</tr>
</table>
