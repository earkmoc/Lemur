<?php require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");?>

<div class="tab-content">
   <div class="tab-pane active in" id="home" style="margin: 20px 0px 20px 0px; padding: 0px;">
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

<?php
if($dane['ID']>0)
{
?>
<ul class="nav nav-tabs">
<li class="active" id="liObroty">     <a href="#Obroty"			data-toggle="tab">1. Obroty</a></li>
</ul>

<div class="tab-content">
   <div class="tab-pane active in" id="Obroty" style="margin: 20px 0px 20px 0px; padding: 0px;">
      <div class="container-fluid bs-docs-container">
         <div class="row">
            <div class="col-md-12">
				<iframe id="iframeObroty" width='100%' height='800' src='<?php echo "/$baza/Obroty/Tabela/index.php?indeks=$dane[INDEKS]";?>'></iframe>
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
