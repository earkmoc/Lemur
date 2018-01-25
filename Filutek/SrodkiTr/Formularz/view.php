<?php require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");?>

<!-- Modal -->
<div class="modal" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
   <div class="modal-dialog modal-lg">
      <div class="modal-content">
         <div class="modal-body">
				<iframe  id="iframeKontrahenci" width='100%' height='700' src='<?php echo "http://{$_SERVER['HTTP_HOST']}/$baza/Kontrahenci/Tabela/";?>'></iframe>
         </div>
      </div>
   </div>
</div>

<div class="tab-content">
   <div class="tab-pane active in" id="home" style="margin: 0px 0px 0px 0px; padding: 0px;">
      <div class="container-fluid bs-docs-container">
<?php
	$szerokoscOpisu=1;
	$szerokoscPola=12-$szerokoscOpisu;
	$poziomo=true;
	require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/formView.php");
?>
      </div>
   </div>
</div>

<ul class="nav nav-tabs">
<li class="active" id="liOT">		<a href="#OT"  		data-toggle="tab">1. Dokumenty OT</a></li>
<li                id="liZmiany">	<a href="#Zmiany"	data-toggle="tab">2. Zmiany</a></li>
<li                id="liHistoria">	<a href="#Historia"	data-toggle="tab">3. Historia</a></li>
</ul>

<div class="tab-content">

   <div class="tab-pane active in" id="OT" style="margin: 0px 0px 0px 0px; padding: 0px;">
      <div class="container-fluid bs-docs-container">
         <div class="row">
            <div class="col-md-12">
				<iframe  id="iframeSrodkiTrOT" width='100%' height='500' src='<?php echo "/$baza/SrodkiTrOT/Tabela/index.php?id_d=$id";?>'></iframe>
            </div>
         </div>
      </div>
   </div>

   <div class="tab-pane" id="Zmiany" style="margin: 0px 0px 0px 0px; padding: 0px;">
      <div class="container-fluid bs-docs-container">
         <div class="row">
            <div class="col-md-12">
				<iframe  id="iframeSrodkiTrZmiany" width='100%' height='500' src='<?php echo "/$baza/SrodkiTrZm/Tabela/index.php?id_d=$id";?>'></iframe>
            </div>
         </div>
      </div>
   </div>

   <div class="tab-pane" id="Historia" style="margin: 0px 0px 0px 0px; padding: 0px;">
      <div class="container-fluid bs-docs-container">
         <div class="row">
            <div class="col-md-12">
				<iframe  id="iframeSrodkiTrHistoria" width='100%' height='500' src='<?php echo "/$baza/SrodkiTrHi/Tabela/index.php?id_d=$id";?>'></iframe>
            </div>
         </div>
      </div>
   </div>

</div>

<?php require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");?>
<link href="view.css" rel="stylesheet">
<script src="view.js"></script>
