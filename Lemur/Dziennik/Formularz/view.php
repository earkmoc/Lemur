<?php require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");?>

<!-- Modal -->
<div class="modal" id="myModalWn" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
   <div class="modal-dialog modal-lg">
      <div class="modal-content">
         <div class="modal-body">
				<iframe  id="iframeKontaWn" width='100%' height='700' src='<?php echo "http://{$_SERVER['HTTP_HOST']}/$baza/KontaWn/Tabela/";?>'></iframe>
         </div>
      </div>
   </div>
</div>

<div class="modal" id="myModalMa" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
   <div class="modal-dialog modal-lg">
      <div class="modal-content">
         <div class="modal-body">
				<iframe  id="iframeKontaMa" width='100%' height='700' src='<?php echo "http://{$_SERVER['HTTP_HOST']}/$baza/KontaMa/Tabela/";?>'></iframe>
         </div>
      </div>
   </div>
</div>

<div class="tab-content">
   <div class="tab-pane active in" id="home" style="margin: 20px 0px 20px 0px; padding: 0px;">
      <div class="container-fluid bs-docs-container">
<?php
	$szerokoscOpisu=2;
	$szerokoscPola=10;
	require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/formView.php");
?>
      </div>
   </div>
</div>

<?php require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");?>
<link href="view.css" rel="stylesheet">
<script src="view.js"></script>
