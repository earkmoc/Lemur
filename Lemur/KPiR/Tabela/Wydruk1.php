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

$_POST['tytul']='PODATKOWA KSIÊGA PRZYCHODÓW I ROZCHODÓW';
$_POST['rodzaj']=(isset($_POST['rodzaj'])?$_POST['rodzaj']:'handel');
//$_POST['rokMc']=mysqli_fetch_row(mysqli_query($link,"select left(DATA,7) from $tabela where ID=$_GET[id]"))[0];
$_POST['odDnia']=(isset($_POST['odDnia'])?$_POST['odDnia']:mysqli_fetch_row(mysqli_query($link,"select concat(left(DATA,4),'-01-01') from $tabela where DATA*1>0 order by DATA limit 1"))[0]);
$_POST['doDnia']=(isset($_POST['doDnia'])?$_POST['doDnia']:mysqli_fetch_row(mysqli_query($link,"select concat(left(DATA,4),'-12-31') from $tabela order by DATA desc limit 1"))[0]);

$_POST['lewe']=(isset($_POST['lewe'])?$_POST['lewe']:1);
$_POST['prawe']=(isset($_POST['prawe'])?$_POST['prawe']:1);

$_POST['syntetycznie']=(isset($_POST['syntetycznie'])?$_POST['syntetycznie']:1);

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
				Rodzaj dzia³alno¶ci: 
			</div>
			<div class="col-md-3">
				<input type="text" class="form-control" name="rodzaj" value="<?php echo $_POST['rodzaj'];?>" />
			</div>
		</div>

		<div class="row">
			<div class="col-md-3 nag">
				Okres: 
			</div>
			<div class="col-md-2">
				<input type="text" class="form-control" name="odDnia" value="<?php echo $_POST['odDnia'];?>" />
			</div>
			<div class="col-md-2">
				<input type="text" class="form-control" name="doDnia" value="<?php echo $_POST['doDnia'];?>" />
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

		<div class="row">
			<div class="col-md-3 nag">
				Strony lewe:
			</div>
			<div class="col-md-1">
				<input type="checkbox" class="form-control" name="lewe" value="1" <?php echo ($_POST['lewe']?'checked':'');?> />
			</div>
		</div>

		<div class="row">
			<div class="col-md-3 nag">
				Strony prawe:
			</div>
			<div class="col-md-1">
				<input type="checkbox" class="form-control" name="prawe" value="1" <?php echo ($_POST['prawe']?'checked':'');?> />
			</div>
		</div>

		<div class="row">
			<div class="col-md-3 nag">
				Syntetycznie miesi±cami:
			</div>
			<div class="col-md-1">
				<input type="checkbox" class="form-control" name="syntetycznie" value="1" <?php echo ($_POST['syntetycznie']?'checked':'');?> />
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
