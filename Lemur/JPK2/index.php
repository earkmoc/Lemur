<?php

$path='C:\Archiwa';

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$baza=$_GET['baza'];
$klient=mysqli_fetch_array(mysqli_query($link,$q="select * from Lemur.klienci where PSKONT='$baza'"));

for($i=10;$i<=39;++$i)
{
	$_POST["K$i"]='';
}

for($i=43;$i<=46;++$i)
{
	$_POST["K$i"]='';
}

$w=mysqli_query($link,$q="
	select TRESC
		 , OPIS
	  from Lemur.slownik
	 where TYP='parametry'
	   and SYMBOL='JPK'
");
while($r=mysqli_fetch_array($w))
{
	$_POST[$r[0]]=StripSlashes($r[1]);
}

if($_POST['OdDaty'])
{
	$odDaty=$_POST['OdDaty'];
	$doDaty=$_POST['DoDaty'];
}
else
{
	$dataBazowa=date('Y-m-01');
	$doDaty=mysqli_fetch_row(mysqli_query($link,$q="select Date_Add('$dataBazowa',interval -1 day)"))[0];
	$odDaty=substr($doDaty,0,8).'01';
}

$title="JPK(2) - generowanie pliku dla $baza";
$buttons=array();
$buttons[]=array('klawisz'=>'AltG','nazwa'=>'Enter=Generuj','akcja'=>"generuj.php?baza=$baza");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powr�t','akcja'=>"../Klienci");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");
?>

<div class="tab-content">
   <div class="tab-pane active in" id="home" style="margin: 20px 0px 20px 0px; padding: 0px;">
      <div class="container-fluid bs-docs-container">

		<div class="row">
			<div class="col-md-3 nag">
				Cel z�o�enia:
			</div>
			<div class="col-md-4">
				<select class="form-control" name="cel">
					<option>1 - z�o�enie JPK po raz pierwszy za danych okres
					<option>2 - korekta JPK za danych okres
				</select>
			</div>
		</div>

		<div class="row">
			<div class="col-md-3 nag">
				Od daty
			</div>
			<div class="col-md-2">
				<input type="text" class="form-control" name="OdDaty" value="<?php echo $odDaty;?>" />
			</div>
		</div>

		<div class="row">
			<div class="col-md-3 nag">
				Do daty
			</div>
			<div class="col-md-2">
				<input type="text" class="form-control" name="DoDaty" value="<?php echo $doDaty;?>" />
			</div>
		</div>

		<div class="row">
			<div class="col-md-3 nag">
				Kod urz�du skarbowego
<a href='http://www.mf.gov.pl/documents/764034/1497829/Dane+teleadresowe+Administracja+Podatkowa+16+12+2016.xls'>(lista kod�w)</a>
			</div>
			<div class="col-md-1">
				<input type="text" class="form-control" name="kodUS" value="<?php echo $klient['KODUS'];?>" />
			</div>
		</div>

		<div class="row">
			<div class="col-md-3 nag">
				Plik docelowy:
			</div>
			<div class="col-md-9">
				<input type="text" class="form-control" name="filename" value="<?php echo "$path\\JPK_VAT_$baza.XML";?>" />
			</div>
		</div>
		
		<hr>
		
<?php 	foreach($_POST as $key => $value)
		{
			if(substr($key,0,1)=='K')
			{
?>
				<div class="row">
					<div class="col-md-3 nag">
						Formu�a liczenia pola <?php echo $key;?>:
					</div>
					<div class="col-md-9">
						<input type="text" class="form-control" name="<?php echo $key;?>" value="<?php echo $value;?>" />
					</div>
				</div>
<?php		}
		}
?>
      </div>
   </div>
</div>

<?php
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");
?>

<link href="view.css" rel="stylesheet">
<script type="text/javascript" src="view.js"> </script>
