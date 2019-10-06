</form>

<?php
if(!isset($bezLemurVer))
{
	$timestampLemur=file_get_contents("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/timestamp.ver");
	echo '<div id="stopka" class="container-fluid" style="text-align: right; color: white;">';
	echo '<p>Lemur&sup2; ver '.(substr($timestampLemur,0,10)).' by ericom Arkadiusz Moch</p>';
	echo '</div>';
}
?>

</body>
</html>

<script src="<?php echo 'https://'.$_SERVER['HTTP_HOST'];?>/Lemur2/js/jquery-1.10.2.min.js"></script>

<script src="<?php echo 'https://'.$_SERVER['HTTP_HOST'];?>/bootstrap-master/dist/js/bootstrap.min.js"></script>

<script src="<?php echo 'https://'.$_SERVER['HTTP_HOST'];?>/bootstrap-table-master/dist/bootstrap-table.min.js"></script>
<script src="<?php echo 'https://'.$_SERVER['HTTP_HOST'];?>/Lemur2/js/bootstrap-table-pl-PL.min.js"></script>
<script src="<?php echo 'https://'.$_SERVER['HTTP_HOST'];?>/bootstrap-table-master/dist/extensions/flat-json/bootstrap-table-flat-json.min.js"></script>
<script src="<?php echo 'https://'.$_SERVER['HTTP_HOST'];?>/bootstrap-table-master/dist/extensions/multiple-sort/bootstrap-table-multiple-sort.min.js"></script>

<script src="<?php echo 'https://'.$_SERVER['HTTP_HOST'];?>/bootstrap-master/docs/assets/js/vendor/holder.js"></script>
<script src="<?php echo 'https://'.$_SERVER['HTTP_HOST'];?>/bootstrap-master/docs/assets/js/application.js"></script>

<!-- ---------------------------------------------------------------------------------------- -->

<link href="<?php echo 'https://'.$_SERVER['HTTP_HOST'];?>/Lemur2/css/datepicker.css" rel="stylesheet">
<script type="text/javascript" src="<?php echo 'https://'.$_SERVER['HTTP_HOST'];?>/Lemur2/js/bootstrap-datepicker.js" charset="UTF-8"></script>

<link href="<?php echo 'https://'.$_SERVER['HTTP_HOST'];?>/Lemur2/css/bootstrap-datetimepicker.css" rel="stylesheet">
<script src="<?php echo 'https://'.$_SERVER['HTTP_HOST'];?>/Lemur2/js/bootstrap-datetimepicker.js"></script>

<!--
<script type="text/javascript" src="<?php echo 'https://'.$_SERVER['HTTP_HOST'];?>/Lemur2/js/bootstrap-confirmation.js"></script>
-->

<!-- ---------------------------------------------------------------------------------------- -->
<!-- Include the plugin's CSS and JS: -->
<script type="text/javascript" src="<?php echo 'https://'.$_SERVER['HTTP_HOST'];?>/bootstrap-multiselect/js/bootstrap-multiselect.js"></script>
<link rel="stylesheet" href="<?php echo 'https://'.$_SERVER['HTTP_HOST'];?>/bootstrap-multiselect/css/bootstrap-multiselect.css" type="text/css"/>
 
<!-- ---------------------------------------------------------------------------------------- -->

<?php require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.js");?>
