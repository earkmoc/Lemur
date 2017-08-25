<?php

$path='C:\Archiwa';

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$baza='Inez2017';
$klient=$_GET['klient'];

$title="Import bilansu z innego klienta do '$klient'";
$buttons=array();
$buttons[]=array('klawisz'=>'AltI','nazwa'=>'Enter=Importuj','akcja'=>"importuj.php?klient=$klient");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"../Klienci");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");
?>

<div class="tab-content">
   <div class="tab-pane active in" id="home" style="margin: 20px 0px 20px 0px; padding: 0px;">
      <div class="container-fluid bs-docs-container">

		<div class="row">
			<div class="col-md-3 nag">
				¬ród³owy klient
			</div>
			<div class="col-md-2">
				<input type="text" class="form-control" name="baza" value="<?php echo $baza;?>"/>
			</div>
		</div>

      </div>
   </div>
</div>

<?php
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");
?>

<link href="view.css" rel="stylesheet">
<script type="text/javascript" src="view.js"> </script>
