<?php

require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

$parametry='';
foreach($_GET as $key => $value)
{
	$parametry.="&$key=$value";
}

$title="Parametry przetwarzania";
$buttons=array();
$buttons[]=array('klawisz'=>'AltP','nazwa'=>'Enter=Przetwarzaj','akcja'=>"przetwarzaj.php?$parametry");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"..");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

$w=mysqli_query($link,$q="
	select TRESC
		 , OPIS
	  from slownik
	 where TYP='parametry'
	   and SYMBOL='AOK'
");
while($r=mysqli_fetch_array($w))
{
	$_POST[$r[0]]=StripSlashes($r[1]);
}

$_POST['data1']=(@$_POST['data1']?$_POST['data1']:date('Y-m-d'));
$_POST['data2']=(@$_POST['data2']?$_POST['data2']:date('Y-m-d'));
$_POST['gdzie']=(@$_POST['gdzie']?$_POST['gdzie']:'ksiêgi i bufor');
$_POST['maska']=(@$_POST['maska']?$_POST['maska']:'131*');
$_POST['BO']=(@$_POST['BO']?$_POST['BO']:'on');

?>

<div class="tab-content">
   <div class="tab-pane active in" id="home" style="margin: 20px 0px 20px 0px; padding: 0px;">
      <div class="container-fluid bs-docs-container">

		<div class="row">
			<div class="col-md-5 nag">
				Od daty:
			</div>
			<div class="col-md-2">
				<input type="text" class="form-control" name="data1" value="<?php echo $_POST['data1'];?>" />
			</div>
		</div>

		<div class="row">
			<div class="col-md-5 nag">
				Do daty:
			</div>
			<div class="col-md-2">
				<input type="text" class="form-control" name="data2" value="<?php echo $_POST['data2'];?>" />
			</div>
		</div>

		<div class="row">
			<div class="col-md-5 nag">
				¬ród³o:
			</div>
			<div class="col-md-2">
				<select class="form-control" name="gdzie">
				<option>bufor
				<option>ksiêgi
				<option selected>ksiêgi i bufor
				</select>
			</div>
		</div>

		<div class="row">
			<div class="col-md-5 nag">
				Maska:
			</div>
			<div class="col-md-2">
				<input type="text" class="form-control" name="maska" value="<?php echo $_POST['maska'];?>" />
			</div>
		</div>

		<div class="row">
			<div class="col-md-5 nag">
				Uwzglêdniaæ B.O.?:
			</div>
			<div class="col-md-1">
				<input type="checkbox" class="form-control" name="BO" <?php echo ($_POST['BO']?'checked':'');?> />
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
