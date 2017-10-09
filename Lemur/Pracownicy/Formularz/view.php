<?php require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");?>

<ul class="nav nav-tabs">
<li class="active" id="liDane"     ><a href="#Dane"			data-toggle="tab">1. Dane</a></li>
<li                id="liAbsencje">	<a href="#Absencje"		data-toggle="tab">2. Absencje</a></li>
<li                id="liListyPlac"><a href="#ListyPlac"	data-toggle="tab">3. Listy P³ac</a></li>
<li                id="liHistoriaP"><a href="#HistoriaP"	data-toggle="tab">4. Historia zatrudnienia</a></li>
</ul>

<div class="tab-content">

   <div class="tab-pane active in" id="Dane" style="margin: 20px 0px 20px 0px; padding: 0px;">
      <div class="container-fluid bs-docs-container">
		<?php
			$szerokoscOpisu=4;
			$szerokoscPola=12-$szerokoscOpisu;
			require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/formView.php");
		?>
      </div>
   </div>

   <div class="tab-pane" id="Absencje" style="margin: 20px 0px 20px 0px; padding: 0px;">
      <div class="container-fluid bs-docs-container">
		<div class="row">
			<div class="col-md-12">
				<div id="Kalendarz"></div>
				<script type="text/javascript">
					var idPracownika=<?php echo $id;?>;
					var data='<?php echo $data;?>';
				</script>
			</div>
		</div>
      </div>
   </div>

   <div class="tab-pane" id="ListyPlac" style="margin: 20px 0px 20px 0px; padding: 0px;">
      <div class="container-fluid bs-docs-container">
		<div class="row">
			<div class="col-md-12">
				<iframe  id="iframePracownicyListy" width='100%' height='500' src='<?php echo "/$baza/PracownicyListy/Tabela/index.php?id_d=$id";?>'></iframe>
			</div>
		</div>
      </div>
   </div>

   <div class="tab-pane" id="HistoriaP" style="margin: 20px 0px 20px 0px; padding: 0px;">
      <div class="container-fluid bs-docs-container">
		<div class="row">
			<div class="col-md-12">
				<iframe  id="iframeHistoriaP" width='100%' height='500' src='<?php echo "/$baza/PracownicyHistoria/Tabela/index.php?id_d=$id";?>'></iframe>
			</div>
		</div>
      </div>
   </div>

</div>

<?php require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");?>
<link href="view.css" rel="stylesheet">
<script src="view.js"></script>
