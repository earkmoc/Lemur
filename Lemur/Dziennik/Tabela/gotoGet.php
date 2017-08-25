<?php

require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

$title="Parametry przej¶cia do wybranej pozycji dziennika";
$buttons=array();
$buttons[]=array('klawisz'=>'AltG','nazwa'=>'Enter=Goto','akcja'=>"gotoSet.php?idTabeles=$idTabeles");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"..");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

$w=mysqli_query($link,$q="
	select *
	  from $tabela
	 where ID=$_GET[id]
");
$r=mysqli_fetch_array($w);

?>

<div class="tab-content">
   <div class="tab-pane active in" id="home" style="margin: 20px 0px 20px 0px; padding: 0px;">
      <div class="container-fluid bs-docs-container">

		<div class="row">
			<div class="col-md-6 nag">
				PK
			</div>
			<div class="col-md-2">
				<input type="text" class="form-control" name="pk" value="<?php echo $r['DOK'];?>" title="Polecenie ksiêgowania" >
			</div>
			<div class="col-md-6 nag">
				Nr 
			</div>
			<div class="col-md-2">
				<input type="text" class="form-control" name="nr" value="<?php echo $r['NR'];?>" title="Numer" >
			</div>
			<div class="col-md-6 nag">
				Lp 
			</div>
			<div class="col-md-2">
				<input type="text" class="form-control" name="lp" value="<?php echo $r['LP'];?>" title="Liczba porz±dkowa" >
			</div>
			<div class="col-md-6 nag">
				Pz 
			</div>
			<div class="col-md-2">
				<input type="text" class="form-control" name="pz" value="<?php echo $r['PZ'];?>" title="Pozycja" >
			</div>
      </div>
   </div>
</div>

<?php
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");
?>

<link href="view.css" rel="stylesheet">
<script type="text/javascript" src="view.js"> </script>
