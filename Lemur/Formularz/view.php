<?php require("{$_SERVER[DOCUMENT_ROOT]}/Lemur2/header.tpl");?>

<div class="tab-content">
   <div class="tab-pane active in" id="home" style="margin: 20px 0px 20px 0px; padding: 0px;">
      <div class="container-fluid bs-docs-container">

<?php
	$szpalty=1;
	$szerokosc=12;

	$szerokoscOpisu=2;//$szerokosc/$szpalty/2;
	$szerokoscPola=$szerokosc/$szpalty-$szerokoscOpisu;

	$i=0;
	foreach($fields as $field) {
		if($i>0)
		{
			echo "\n";
			echo '</div>';
			echo "\n";
		}
		echo '<div class="row">';
		
		$field=$fields[$i];
		echo '
		<div class="col-md-'.$szerokoscOpisu.' nag">'.($field['nazwa']).':</div>
		';

		echo '
		<div class="col-md-'.($field[grid]*1>0?$field[grid]:$szerokoscPola).'">
			<input 
			 type="text" 
			 name="'.($field[pole]).'" 
			 value="'.(($field[bezZer]&&($dane[$field['pole']]*1==0))?'':$dane[$field['pole']]).'"';

			if (substr($field[pole],0,4)=='DATA') {
				echo ' class="form-control datePicker"';
			} else {
				echo ' class="form-control"';
			}

			if ($field[readonly]) {
			   echo ' readonly';
			}

			if ($field[align]) {
			   echo ' style="text-align: '.($field[align]).'"';
			}

			if ($field[len]) {
			   echo ' maxlength="'.$field[len].'"';
			}

			if ($field[valid]) {
			   echo ' onchange="valid(\''.($field[pole]).'\',\''.($field[valid]).'\')"';
			}

			echo ' />';
		echo '
		</div>';
		++$i;
	}
	echo "\n";
	echo '</div>';
	echo "\n";
?>
      </div>
   </div>
</div>

<?php require("{$_SERVER[DOCUMENT_ROOT]}/Lemur2/footer.tpl");?>
<link href="view.css" rel="stylesheet">
<script src="view.js"></script>
