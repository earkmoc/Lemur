<?php

$path='C:\Archiwa';

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$baza=$_GET['baza'];
$klient=mysqli_fetch_array(mysqli_query($link,$q="select * from Lemur2.klienci where PSKONT='$baza'"));

$_POST["P_1"]='0.00';
$_POST["P_2"]='0.00';
$_POST["P_3"]='0.00';
$_POST["P_4"]='0.00';
$_POST["P_5A"]='';
$_POST["P_5B"]='';

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

$title="JPK_PKPIR (1) - generowanie pliku dla $baza";
$buttons=array();
$buttons[]=array('klawisz'=>'AltG','nazwa'=>'Enter=Generuj','akcja'=>"generuj.php?baza=$baza");
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"../Menu");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");
?>

<div class="tab-content">
   <div class="tab-pane active in" id="home" style="margin: 20px 0px 20px 0px; padding: 0px;">
      <div class="container-fluid bs-docs-container">

		<div class="row">
			<div class="col-md-3 nag">
				Cel z³o¿enia:
			</div>
			<div class="col-md-4">
				<select class="form-control" name="cel">
					<option>1 - z³o¿enie JPK po raz pierwszy za dany okres
					<option>2 - korekta JPK za dany okres
					<option>3 - korekta JPK za dany okres
					<option>4 - korekta JPK za dany okres
					<option>5 - korekta JPK za dany okres
					<option>6 - korekta JPK za dany okres
					<option>7 - korekta JPK za dany okres
					<option>8 - korekta JPK za dany okres
					<option>9 - korekta JPK za dany okres
				</select>
			</div>
		</div>

		<div class="row">
			<div class="col-md-3 nag">
				Od daty:
			</div>
			<div class="col-md-2">
				<input type="text" class="form-control" name="OdDaty" value="<?php echo $odDaty;?>" />
			</div>
		</div>

		<div class="row">
			<div class="col-md-3 nag">
				Do daty:
			</div>
			<div class="col-md-2">
				<input type="text" class="form-control" name="DoDaty" value="<?php echo $doDaty;?>" />
			</div>
		</div>

		<div class="row">
			<div class="col-md-3 nag">
				Kod urzêdu skarbowego
			</div>
			<div class="col-md-5">
				<select class="form-control" name="kodUS">
					<?php
					require('kodyUS.php');
					foreach($kodyUS as $key => $value)
					{
						echo "<option".($key==$klient['KODUS']?' selected':'').">$key - $value";
					}
					?>
				</select>
			</div>
		</div>

		<div class="row">
			<div class="col-md-3 nag">
				Plik docelowy:
			</div>
			<div class="col-md-9">
				<input type="text" class="form-control" name="filename" value="<?php echo "$path\\JPK_PKPIR_$baza.XML";?>" />
			</div>
		</div>
		
		<hr>
		
		<div class="row">
			<div class="col-md-6 nag">
				Warto¶æ spisu z natury na pocz±tek roku podatkowego:
			</div>
			<div class="col-md-3">
				<input type="text" class="form-control" style="text-align:right" name="P_1" value="<?php echo number_format($_POST['P_1'],2,'.',',');?>" />
			</div>
		</div>

		<div class="row">
			<div class="col-md-6 nag">
				Warto¶æ spisu z natury na koniec roku podatkowego:
			</div>
			<div class="col-md-3">
				<input type="text" class="form-control" style="text-align:right" name="P_2" value="<?php echo number_format($_POST['P_2'],2,'.',',');?>" />
			</div>
		</div>

		<div class="row">
			<div class="col-md-6 nag">
				Razem koszty uzyskania przychodu, wg obja¶nieñ do podatkowej ksiêgi przychodów i rozchodów:
			</div>
			<div class="col-md-3">
				<input type="text" class="form-control" style="text-align:right" name="P_3" value="<?php echo number_format($_POST['P_3'],2,'.',',');?>" />
			</div>
		</div>

		<div class="row">
			<div class="col-md-6 nag">
				Dochód osi±gniêty w roku podatkowym, wg obja¶nieñ do podatkowej ksiêgi przychodów i rozchodów:
			</div>
			<div class="col-md-3">
				<input type="text" class="form-control" style="text-align:right" name="P_4" value="<?php echo number_format($_POST['P_4'],2,'.',',');?>" />
			</div>
		</div>

		<div class="row">
			<div class="col-md-6 nag">
				Data spisu z natury sporz±dzonego w ci±gu roku podatkowego:
			</div>
			<div class="col-md-2">
				<input type="text" class="form-control" name="P_5A" value="<?php echo $_POST['P_5A'];?>" />
			</div>
		</div>

		<div class="row">
			<div class="col-md-6 nag">
				Warto¶æ spisu z natury sporz±dzonego w ci±gu roku podatkowego:
			</div>
			<div class="col-md-3">
				<input type="text" class="form-control" style="text-align:right" name="P_5B" value="<?php echo number_format($_POST['P_5B'],2,'.',',');?>" />
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
