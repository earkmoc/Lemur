<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

if ($idd=$_SESSION["{$baza}DokumentyID_D"])
{
	$_POST['ID_D']=$idd;
}
$_POST['KTO']=$_SESSION['osoba_id'];
$_POST['CZAS']=date('Y-m-d H:i:s');
$_POST['KWOTA']=(strpos($_POST['KWOTA'],',')&&strpos($_POST['KWOTA'],'.')?str_replace(',','',$_POST['KWOTA']):$_POST['KWOTA']);

$noHeader=true;
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveFormFields.php");

$idd=($idd==0?-1:$idd);
$suma=mysqli_fetch_row(mysqli_query($link, $q="
		select sum(KWOTA)
		  from $tabela
		 where ID_D='$idd'
"))[0];
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

$dokKwoty=mysqli_fetch_row(mysqli_query($link, $q="
		select replace(group_concat(concat(PRZEDMIOT,'=',KWOTA)),',',';')
		  from $tabela
		 where ID_D='$idd'
"))[0];
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
?>

<script type="text/javascript">
	parent.$('input[name=WARTOSC]').val(<?php echo "'$suma'";?>);
	parent.$('input[name=WPLACONO]').val(<?php echo "'$suma'";?>);
	parent.$('input[name=UWAGI]').val(<?php echo "'$dokKwoty'";?>);
	location="../Tabela";
</script>
