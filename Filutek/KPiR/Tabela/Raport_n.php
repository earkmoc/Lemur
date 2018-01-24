<?php

$innaBaza='Lemur';
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$q=mysqli_query($link,"
select *
  from klienci
 where PSKONT='$baza'
");
while($r=mysqli_fetch_array($q))
{
	$nazwa="$r[NAZWA]";
	$adres="$r[ADRES]";
	$nip="$r[NIP]";
	$telefony="$r[OPIS]";
}

?>
<table border="0" width="100%">
<tr>
<td>
	<table cellspacing="0" cellpadding="3" rules="none" width="378" bgcolor="#ffffff" border="1" frame="box">
	<tbody>
	<tr align="middle">
		<td><font style="font-size:20pt"><?php echo $nazwa;?></font></td>
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

<td align="center">
	<table cellspacing="0" cellpadding="0" bgcolor="#ffffff" style="font-family: arial;">
	<tbody>
	<tr align="center">
		<td><font style="font-size:16pt;"><?php echo $_POST['tytul'];?></font></td>
	</tr>
	<tr align="center">
		<td><br>Rodzaj dzia³alno¶ci:</td>
	</tr>
	<tr align="center">
		<td style="border-bottom: dotted 1px black;"><?php echo $_POST['rodzaj'];?></td>
	</tr>
	</tbody>
	</table>
</td>
</tr>
</table>
