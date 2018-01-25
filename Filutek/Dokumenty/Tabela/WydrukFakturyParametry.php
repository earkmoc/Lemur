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
$buttons[]=array('klawisz'=>'AltD','nazwa'=>'Enter=Drukuj','akcja'=>"WydrukFaktury.php?$parametry");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"..");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

$w=mysqli_query($link,$q="
	select TRESC
		 , OPIS
	  from slownik
	 where TYP='parametry'
	   and SYMBOL='faktura'
");
while($r=mysqli_fetch_array($w))
{
	$_POST[$r[0]]=StripSlashes($r[1]);
}

$dokument=mysqli_fetch_array($q=mysqli_query($link,"
select *
  from $tabela
 where ID='$_GET[id]'
"));

$_POST['miasto']=(isset($_POST['miasto'])?$_POST['miasto']:'£ód¼');
$_POST['dataWystawienia']=$dokument['DDOKUMENTU'];
$_POST['nazwaDokumentu']=(isset($_POST['nazwaDokumentu'])?$_POST['nazwaDokumentu']:'FAKTURA');
$_POST['numer']=$dokument['NUMER'];
$_POST['zamowienie']=(isset($_POST['zamowienie'])?$_POST['zamowienie']:'');
$_POST['srodekTransportu']=(isset($_POST['srodekTransportu'])?$_POST['srodekTransportu']:'');
$_POST['dataWykonania']=$dokument['DOPERACJI'];
$_POST['sposZapl']=$dokument['SPOSZAPL'];
$_POST['wplacono']=$dokument['WPLACONO'];
$_POST['wartosc']=$dokument['WARTOSC'];

$_POST['termin']=$dokument['DTERMIN'];
$_POST['termin']=($_POST['termin']*1==0?'':$_POST['termin']);

$_POST['bank']=(isset($_POST['bank'])?$_POST['bank']:'');
$_POST['konto']=(isset($_POST['konto'])?$_POST['konto']:'');
$_POST['uwagi']=(isset($_POST['uwagi'])?$_POST['uwagi']:'');

$_POST['czcionka']=(@$_POST['czcionka']?$_POST['czcionka']:'arial');
$_POST['wielkosc']=(@$_POST['wielkosc']?$_POST['wielkosc']:'10');

?>

<div class="tab-content">
   <div class="tab-pane active in" id="home" style="margin: 20px 0px 20px 0px; padding: 0px;">
      <div class="container-fluid bs-docs-container">

		<div class="row">
			<div class="col-md-6 nag">
				Miasto:
			</div>
			<div class="col-md-2">
				<input type="text" class="form-control" name="miasto" value="<?php echo $_POST['miasto'];?>" />
			</div>
			<div class="col-md-2 nag">
				Data wystawienia:
			</div>
			<div class="col-md-2">
				<input type="text" class="form-control" name="dataWystawienia" value="<?php echo $_POST['dataWystawienia'];?>" />
			</div>
		</div>

		<div class="row">
			<div class="col-md-6">
				<h1><input type="text" name="nazwaDokumentu" value="<?php echo $_POST['nazwaDokumentu'];?>" /></h1>
			</div>
			<div class="col-md-6" style="text-align: left">
				<h1> Nr <?php echo $_POST['numer'];?></h1>
			</div>
		</div>

		<div class="row">
			<div class="col-md-2 nag">
				Zamówienie: 
			</div>
			<div class="col-md-2">
				<input type="text" class="form-control" name="zamowienie" value="<?php echo $_POST['zamowienie'];?>" />
			</div>
			<div class="col-md-2 nag">
				¦rodek transportu: 
			</div>
			<div class="col-md-2">
				<input type="text" class="form-control" name="srodekTransportu" value="<?php echo $_POST['srodekTransportu'];?>" />
			</div>
			<div class="col-md-2 nag">
				Data wykonania: 
			</div>
			<div class="col-md-2">
				<input type="text" class="form-control" name="dataWykonania" value="<?php echo $_POST['dataWykonania'];?>" title="Data dokonania lub zakoñczenia dostawy lub wykonania us³ugi (zaliczki)" />
			</div>
		</div>

		<div class="row">
			<div class="col-md-2 nag">
				Sposób p³atno¶ci: 
			</div>
			<div class="col-md-2">
				<input type="text" class="form-control" name="sposZapl" value="<?php echo $_POST['sposZapl'];?>" />
			</div>
			<div class="col-md-2 nag">
				Termin: 
			</div>
			<div class="col-md-2">
				<input type="text" class="form-control" name="termin" value="<?php echo $_POST['termin'];?>" placeholder="rrrr-mm-dd" />
			</div>
		</div>

		<div class="row">
			<div class="col-md-2 nag">
				Wp³acono (<?php echo $dokument['WARTOSC'];?>): 
			</div>
			<div class="col-md-2">
				<input type="text" class="form-control" name="wplacono" align="right" value="<?php echo $_POST['wplacono'];?>" />
			</div>
			<div class="col-md-2 nag">
				Bank: 
			</div>
			<div class="col-md-2">
				<input type="text" class="form-control" name="bank" value="<?php echo $_POST['bank'];?>" />
			</div>
		</div>

		<div class="row">
			<div class="col-md-6 nag">
				Konto: 
			</div>
			<div class="col-md-3">
				<input type="text" class="form-control" name="konto" value="<?php echo $_POST['konto'];?>" />
			</div>
		</div>

		<div class="row">
			<div class="col-md-1 nag">
				Uwagi: 
			</div>
			<div class="col-md-12">
				<textarea class="form-control" name="uwagi" rows="5"><?php echo $_POST['uwagi'];?></textarea>
			</div>
		</div>

		<div class="row">
			<div class="col-md-2 nag">
				Nazwa czcionki
			</div>
			<div class="col-md-2">
				<input type="text" class="form-control" name="czcionka" value="<?php echo $_POST['czcionka'];?>" />
			</div>
		</div>

		<div class="row">
			<div class="col-md-2 nag">
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
/*
		<div class="row">
			<div class="col-md-3 nag">
				Lewe/prawe naprzemiennie:
			</div>
			<div class="col-md-1">
				<input type="checkbox" class="form-control" name="naprzemiennie" value="1" <?php echo ($_POST['naprzemiennie']?'checked':'');?> />
			</div>
		</div>
*/
?>

<link href="view.css" rel="stylesheet">
<script type="text/javascript" src="view.js"> </script>
