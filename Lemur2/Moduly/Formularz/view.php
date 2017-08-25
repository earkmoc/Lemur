<?php require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");?>

<?php
	if($ido>0)
	{
		echo '<br><br><br><br><br><br>';
	}
	$szerokoscOpisu=2;
	$szerokoscPola=7;
	require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/formView.php");
?>

<?php require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");?>
<?php
if($ido>0)
{
	echo '<link href="view.css" rel="stylesheet">';
}
?>
<script src="view.js"></script>
