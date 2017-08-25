<?php require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");?>

<?php
/*
<!-- Modal -->
<div class="modal" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
   <div class="modal-dialog modal-lg">
      <div class="modal-content">
         <div class="modal-body">
				<iframe  id="iframePracownicy" width='100%' height='700' src='<?php echo "http://{$_SERVER['HTTP_HOST']}/$baza/Pracownicy/Tabela/";?>'></iframe>
         </div>
      </div>
   </div>
</div>
*/
?>

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
<li id="liSpecyfikacja" class="active"><a href="#Specyfikacja"  		data-toggle="tab">1. Specyfikacja</a></li>
</ul>

<div class="tab-content">

   <div class="tab-pane active in" id="Specyfikacja" style="margin: 0px 0px 0px 0px; padding: 0px;">
      <div class="container-fluid bs-docs-container">
         <div class="row">
            <div class="col-md-12">
				<iframe  id="iframeSpecyfikacja" width='100%' height='500' src='<?php echo "/$baza/ListyPlacPozycje/Tabela/index.php?id_d=$id";?>'></iframe>
            </div>
         </div>
      </div>
   </div>

</div>

<?php require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");?>
<link href="view.css" rel="stylesheet">
<script src="view.js"></script>
