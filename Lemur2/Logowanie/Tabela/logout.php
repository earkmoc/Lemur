<?php

require("setup.php");

$ido=@$_SESSION['osoba_id'];
$tmp=mysqli_fetch_row(mysqli_query($link, $q="
	select USER
	  from $tabela 
	 where ID='$ido'
"));
@$user=$tmp[0];

$title="Wylogowanie u¿ytkownika ".($user?"\"$user\"":'');
$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"..");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");
echo "<table width='100%' height='100%'>";
echo "<tr align='center'>";

if ($ido==0)
{
	echo "<td><h1>U¿ytkownik nie jest zalogowany<h1></td>";
} else
{
	mysqli_query($link, $q="
		update $tabela 
		   set CZAS=''
		 where ID=$ido
	");
	if (mysqli_error($link)) {
		die(mysqli_error($link).'<br>'.$q);
	} else {
		mysqli_close($link);
		mysqli_close($linkLemur);
		$_SESSION['osoba_id']='';
		echo "<td><h1>U¿ytkownik \"$user\" zosta³ wylogowany<h1></td>";
	}
}
echo "</tr></table>";
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");
