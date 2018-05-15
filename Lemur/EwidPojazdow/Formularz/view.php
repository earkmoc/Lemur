<?php require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");?>

<div class="tab-content">
   <div class="tab-pane active in" id="home" style="margin: 20px 0px 20px 0px; padding: 0px;">
      <div class="container-fluid bs-docs-container">
<?php
	$szerokoscOpisu=2;
	$szerokoscPola=10;
	if(!$baza) {die("Brak danych o baza");}
//	$poziomo=isset($id_d);
	$poziomo=true;
	require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/formView.php");
?>
      </div>
   </div>
</div>

<?php
	if(!isset($id_d))	
	{
?>

<ul class="nav nav-tabs">
<li class="active" id="liEwidPrzeb">  <a href="#EwidPrzeb"		data-toggle="tab">1. Ewidencja Przebiegu Pojazdu</a></li>
<li                id="liDokumenty">  <a href="#Dokumenty"		data-toggle="tab">2. Dokumenty kosztów przejazdu</a></li>
</ul>

<div class="tab-content">

   <div class="tab-pane active in" id="EwidPrzeb" style="margin: 20px 0px 20px 0px; padding: 0px;">
      <div class="container-fluid bs-docs-container">
         <div class="row">
            <div class="col-md-12">
				<iframe  id="iframeEwidPrzeb" width='100%' height='400' src='<?php echo "/$baza/EwidPrzeb/Tabela/index.php?id_d=$id";?>'></iframe>
            </div>
         </div>
      </div>
   </div>

   <div class="tab-pane" id="Dokumenty" style="margin: 20px 0px 20px 0px; padding: 0px;">
      <div class="container-fluid bs-docs-container">
         <div class="row">
            <div class="col-md-12">
				<iframe  id="iframeDokumenty" width='100%' height='400' src='<?php echo "/$baza/DokumentyPojazdu/Tabela/index.php?id_d=$id";?>'></iframe>
            </div>
         </div>
      </div>
   </div>

</div>

<?php
	}
?>

<?php require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");?>
<link href="view.css" rel="stylesheet">
<script src="view.js"></script>
