<?php require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");?>

<div class="tab-content">
   <div class="tab-pane active in" id="home" style="margin: 20px 0px 20px 0px; padding: 0px;">
      <div class="container-fluid bs-docs-container">
			Data wyst: <input id="datawyst" value="" onblur="parent.$('input[name=DDOKUMENTU]').val($(this).val());" />
		<br>Data oper: <input value="" onblur="parent.$('input[name=DOPERACJI]').val($(this).val());" />
		<br>Numer dok.: <input value="" onblur="parent.$('input[name=NUMER]').val($(this).val());" />
		<br>NIP kontr.: <input value="" />
		<br>Kwota: <input value="" onblur="parent.$('input[name=WARTOSC]').val($(this).val());" />
		<br>Automat: <input value="" />
<?php
/*
	$szerokoscOpisu=2;
	$szerokoscPola=10;
	require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/formView.php");
*/
?>
      </div>
   </div>
</div>

<?php require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");?>
<link href="view.css" rel="stylesheet">
<script src="view.js"></script>
