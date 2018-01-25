<?php

require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

$title="Parametry";
$buttons=array();
$buttons[]=array('klawisz'=>'AltO','nazwa'=>'Enter=Okres zapisz','akcja'=>"okresSet.php");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"..");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

$okres=mysqli_fetch_row(mysqli_query($link,$q="
	select OPIS
	  from slownik
	 where ID=$_GET[id]
"))[0];

?>

<div class="tab-content">
   <div class="tab-pane active in" id="home" style="margin: 20px 0px 20px 0px; padding: 0px;">
      <div class="container-fluid bs-docs-container">

		<div class="row">
			<div class="col-md-6 nag">
				Okres sprawozdawczy dla wszystkich rejestrów
			</div>
			<div class="col-md-6">
				<input type="text" class="form-control" name="okres" placeholder="yyyy-mm" value="<?php echo $okres;?>" />
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
