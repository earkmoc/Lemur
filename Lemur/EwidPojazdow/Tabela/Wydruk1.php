<?php

require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

$parametry='';
foreach($_GET as $key => $value)
{
	$parametry.="&$key=$value";
}

$title="Parametry wydruku";
$buttons=array();
$buttons[]=array('klawisz'=>'AltD','nazwa'=>'Enter=Drukuj','akcja'=>"drukujLP.php?$parametry");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"..");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

$w=mysqli_query($link,$q="
	select TRESC
		 , OPIS
	  from slownik
	 where TYP='parametry'
	   and SYMBOL='wydruk1'
");
while($r=mysqli_fetch_array($w))
{
	$_POST[$r[0]]=StripSlashes($r[1]);
}

$_POST['tytul']='Ewidencja wyposa¿enia';
$_POST['naglowek1']=(@$_POST['naglowek1']?$_POST['naglowek1']:$baza);
$_POST['naglowekN']=(isset($_POST['naglowekN'])?$_POST['naglowekN']:$baza);
$_POST['strona1']=(@$_POST['strona1']?$_POST['strona1']:'12');
$_POST['stronaN']=(@$_POST['stronaN']?$_POST['stronaN']:'18');
$_POST['czcionka']=(@$_POST['czcionka']?$_POST['czcionka']:'arial');
$_POST['wielkosc']=(@$_POST['wielkosc']?$_POST['wielkosc']:'10');

?>

<div class="tab-content">
   <div class="tab-pane active in" id="home" style="margin: 20px 0px 20px 0px; padding: 0px;">
      <div class="container-fluid bs-docs-container">

		<div class="row">
			<div class="col-md-3 nag">
				Tytu³ wydruku
			</div>
			<div class="col-md-9">
				<input type="text" class="form-control" name="tytul" value="<?php echo $_POST['tytul'];?>" />
			</div>
		</div>

		<div class="row">
			<div class="col-md-3 nag">
				Ilo¶æ pozycji na pierwszej stronie
			</div>
			<div class="col-md-1">
				<input type="text" class="form-control" name="strona1" value="<?php echo $_POST['strona1'];?>" />
			</div>
		</div>

		<div class="row">
			<div class="col-md-3 nag">
				Nag³ówek na dalszych stronach
			</div>
			<div class="col-md-4">
				<textarea class="form-control" name="naglowekN" rows="3"><?php echo $_POST['naglowekN'];?></textarea>
			</div>
		</div>

		<div class="row">
			<div class="col-md-3 nag">
				Ilo¶æ pozycji na dalszych stronach
			</div>
			<div class="col-md-1">
				<input type="text" class="form-control" name="stronaN" value="<?php echo $_POST['stronaN'];?>" />
			</div>
		</div>

		<div class="row">
			<div class="col-md-3 nag">
				Nazwa czcionki
			</div>
			<div class="col-md-2">
				<input type="text" class="form-control" name="czcionka" value="<?php echo $_POST['czcionka'];?>" />
			</div>
		</div>

		<div class="row">
			<div class="col-md-3 nag">
				Wielko¶æ czcionki
			</div>
			<div class="col-md-1">
				<input type="text" class="form-control" name="wielkosc" value="<?php echo $_POST['wielkosc'];?>" />
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
