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
   <div class="tab-pane active in" id="home" style="margin: 20px 0px 20px 0px; padding: 0px;">
      <div class="container-fluid bs-docs-container">
<?php
	$szerokoscOpisu=4;
	$szerokoscPola=8;
	if(!$baza) {die("Brak danych o baza");}
	$poziomo=isset($id_d);
	require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/formView.php");
?>
      </div>
   </div>
</div>

<?php require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");?>
<link href="view.css" rel="stylesheet">
<script src="view.js"></script>
