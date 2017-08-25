<?php

$path='C:\Archiwa';

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$baza=$_GET['baza'];
$dataBazowa=date('Y-m-01');
$doDaty=mysqli_fetch_row(mysqli_query($link,$q="select Date_Add('$dataBazowa',interval -1 day)"))[0];
$odDaty=substr($doDaty,0,8).'01';

$title="Export danych z '$baza' do innego klienta ";
$buttons=array();
$buttons[]=array('klawisz'=>'AltE','nazwa'=>'Enter=Exportuj','akcja'=>"exportuj.php?baza=$baza");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"../Klienci");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");
?>

<div class="tab-content">
   <div class="tab-pane active in" id="home" style="margin: 20px 0px 20px 0px; padding: 0px;">
      <div class="container-fluid bs-docs-container">

		<div class="row">
			<div class="col-md-3 nag">
				Docelowy klient
			</div>
			<div class="col-md-2">
				<input type="text" class="form-control" name="klient" value=""/>
			</div>
		</div>

		<div class="row">
			<div class="col-md-3 nag">
				Dane od daty
			</div>
			<div class="col-md-2">
				<input type="text" class="form-control" name="odDaty" value="<?php echo $odDaty;?>" />
			</div>
		</div>

		<div class="row">
			<div class="col-md-3 nag">
				do daty
			</div>
			<div class="col-md-2">
				<input type="text" class="form-control" name="doDaty" value="<?php echo $doDaty;?>" />
			</div>
		</div>

      </div>
   </div>
</div>

Uwaga: dokumenty i zawarto¶æ ich zak³adek u klienta docelowego zostan± nadpisane nowymi danymi!

<?php
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");
?>

<link href="view.css" rel="stylesheet">
<script type="text/javascript" src="view.js"> </script>
