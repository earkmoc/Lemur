<?php

class Wydruk
{
	var $title='';
	var $parametry='';
	
	function Wydruk($gets)
	{
		foreach($gets as $key => $value)
		{
			$this->parametry.="&$key=$value";
		}
	}
	
	function DefTitle($title)
	{
		$this->title=$title;
	}
	
	function ParametryUstalone()
	{
		return isset($_POST['tytul']);
	}

	function Formularz($buttony,$pola)
	{
		require("setup.php");
		require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

		$title="Parametry wydruku";
		$buttons=$buttony;

		require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

		$w=mysqli_query($link,$q="
			select TRESC
				 , OPIS
			  from slownik
			 where TYP='parametry'
			   and SYMBOL='wydruk1'
		");
		while($r=mysqli_fetch_array($w))
		{
			$_POST[$r[0]]=StripSlashes($r[1]);
		}

		$_POST['tytul']=$this->title;
		?>

		<div class="tab-content">
		   <div class="tab-pane active in" id="home" style="margin: 20px 0px 20px 0px; padding: 0px;">
			  <div class="container-fluid bs-docs-container">
<?php
foreach($pola as $field)
{
	echo "\n				<div class='row'>";
	echo "\n					<div class='col-md-{$field['labelSize']} nag'>";
	echo "\n						{$field['label']}";
	echo "\n					</div>";
	echo "\n					<div class='col-md-{$field['fieldSize']}'>";
	if(isset($field['fieldType'])&&($field['fieldType']=='textarea'))
	{
		echo "\n						<{$field['fieldType']} "
							 .(isset($field['fieldRows'])?"rows='{$field['fieldRows']}' ":'')
							 ."class='form-control' "
							 ."name='{$field['fieldName']}' "
							 .">{$_POST[$field['fieldName']]}"
						."</{$field['fieldType']}>";
	}
	else
	{
		echo "\n						<input type='text' "
							 ."class='form-control' "
							 ."name='{$field['fieldName']}' "
							 ."value='{$_POST[$field['fieldName']]}' "
							 ."/>";
	}
	echo "\n					</div>";
	echo "\n				</div>\n\n";
}
?>
			  </div>
		   </div>
		</div>

		<?php
			require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");
		?>

		<link href="view.css" rel="stylesheet">
		<script type="text/javascript" src="view.js"> </script>
		<?php
	}
}