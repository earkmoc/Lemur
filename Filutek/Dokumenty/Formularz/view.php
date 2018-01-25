<?php //die(print_r($fields));?>
<?php require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");?>

<!-- Modal -->
<div class="modal" id="myModalMagazyn" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
   <div class="modal-dialog modal-lg">
      <div class="modal-content">
         <div class="modal-body">
				<iframe  id="iframeMagazyn" width='100%' height='700' ssrc='<?php echo "http://{$_SERVER['HTTP_HOST']}/$baza/Magazyn/Tabela/";?>'></iframe>
         </div>
      </div>
   </div>
</div>

<div class="modal" id="myModalWn" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
   <div class="modal-dialog modal-lg">
      <div class="modal-content">
         <div class="modal-body">
				<iframe  id="iframeKontaWn" width='100%' height='700' ssrc='<?php echo "http://{$_SERVER['HTTP_HOST']}/$baza/KontaWn/Tabela/";?>'></iframe>
         </div>
      </div>
   </div>
</div>

<div class="modal" id="myModalMa" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
   <div class="modal-dialog modal-lg">
      <div class="modal-content">
         <div class="modal-body">
				<iframe  id="iframeKontaMa" width='100%' height='700' ssrc='<?php echo "http://{$_SERVER['HTTP_HOST']}/$baza/KontaMa/Tabela/";?>'></iframe>
         </div>
      </div>
   </div>
</div>

<div class="modal" id="myModalN" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
   <div class="modal-dialog modal-lg">
      <div class="modal-content">
         <div class="modal-body">
				<iframe  id="iframeKontrahenciN" width='100%' height='700' ssrc='<?php echo "http://{$_SERVER['HTTP_HOST']}/$baza/KontrahenciN/Tabela/";?>'></iframe>
         </div>
      </div>
   </div>
</div>

<div class="modal" id="myModalO" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
   <div class="modal-dialog modal-lg">
      <div class="modal-content">
         <div class="modal-body">
				<iframe  id="iframeKontrahenciO" width='100%' height='700' ssrc='<?php echo "http://{$_SERVER['HTTP_HOST']}/$baza/KontrahenciO/Tabela/";?>'></iframe>
         </div>
      </div>
   </div>
</div>

<div class="modal" id="myModalP" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
   <div class="modal-dialog modal-lg">
      <div class="modal-content">
         <div class="modal-body">
				<iframe  id="iframePrzedmioty" width='100%' height='700' ssrc='<?php echo "http://{$_SERVER['HTTP_HOST']}/$baza/Przedmioty/Tabela/";?>'></iframe>
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
//	$poziomo=true;
//	require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/formView.php");

	for($i=1;$i<10;++$i)
	{
		echo '<div class="row">';
		foreach($fields as $field) 
		{
//			if (!$field['gridrow']||$field['gridrow']==$i)
			if ($field['gridrow']==$i)
			{
				echo '
				<div class="col-md-'.($field[gridLabel]*1>0?$field[gridLabel]:$szerokoscOpisu).' nag">'.($field['nazwa']).':</div>
				';
				echo '
				<div class="col-md-'.($field[grid]*1>0?$field[grid]:$szerokoscPola).'">';
					$wartosc=(($field[bezZer]&&($dane[$field['pole']]*1==0))?'':trim($dane[$field['pole']]));
					$wartosc=str_replace("'","`",$wartosc);
					if ($field[wysokosc]) 
					{
						echo '<textarea 
								 name="'.($field[pole]).'" 
								 rows="'.($field[wysokosc]).'" 
								 cols="'.($field[szerokosc]).'" 
								 ';
					} elseif ($field[query]) 
					{
						echo '<select 
								 name="'.($field['pole']).'" 
								 ';
					} else
					{
						echo "<input 
								 type='text' 
								 name='".($field['pole'])."' 
								 value='".($wartosc)."'";
					}

					if  ( (substr($field[pole],0,4)=='DATA')
						||(substr($field['nazwa'],0,4)=='Data') 
						||(substr($field['nazwa'],0,6)=='Z dnia')
						||(substr($field['nazwa'],0,6)=='Termin')
						)
					{
						echo ' class="form-control datePicker"';
					} else {
						echo ' class="form-control"';
					}

					if ($field['readonly']) {
					   echo ' readonly';
					}

					if ($field['align']) {
					   echo ' style="text-align: '.($field['align']).'"';
					}

					if ($field['len']) {
					   echo ' maxlength="'.$field['len'].'"';
					}

					if ($field['valid']) {
					   echo ' onchange="valid(\''.($field['pole']).'\',\''.($field['valid']).'\')"';
					}

					if ($field['wysokosc']) 
					{
						echo '>';
						echo $wartosc;
						echo '</textarea>';
					} elseif ($field['query']) 
					{
						echo '>';

						$bylSelected=false;
						if (substr($field['pole'],0,5)!='GDZIE')
						{
							echo '<option';
							if  (	strlen($wartosc)==0
								&&	!$bylSelected
								)
							{
								echo ' selected';
								$bylSelected=true;
							}
							echo '>';
						}

						$opcje=mysqli_query($link, $field['query']);
						while ($opcja=mysqli_fetch_row($opcje))
						{
							echo '<option';
							if  (	strlen($wartosc)>0
								&&	$wartosc==substr($opcja[0],0,strlen($wartosc))
								&&	!$bylSelected
								)
							{
								echo ' selected';
								$bylSelected=true;
							}
							echo '>'.$opcja[0];
						}
						echo '</select>';
					} else
					{
						echo ' />';
					}
				echo '
				</div>';
			}
		}
		echo '</div>';
	}

	$szerokoscOpisu=2;
	$szerokoscPola=4;

	$j=0;
	foreach($fields as $field) {
		if($j<15)
		{
			++$j;
			continue;
		}
		if($j>15)
		{
			echo "\n";
			echo '</div>';
			echo "\n";
		}

		echo '<div class="row">';
		echo '
		<div class="col-md-'.($field[gridLabel]*1>0?$field[gridLabel]:$szerokoscOpisu).' nag">'.($field['nazwa']).':</div>
		';

		echo '
		<div class="col-md-'.($field['grid']*1>0?$field['grid']:$szerokoscPola).'">';
			$wartosc=(($field['bezZer']&&($dane[$field['pole']]*1==0))?'':trim($dane[$field['pole']]));
			$wartosc=str_replace("'","`",$wartosc);
			if ($field['wysokosc']) 
			{
				echo '<textarea 
						 name="'.($field['pole']).'" 
						 rows="'.($field['wysokosc']).'" 
						 cols="'.($field['szerokosc']).'" 
						 ';
			} elseif ($field['query']) 
			{
				echo '<select 
						 name="'.($field['pole']).'" 
						 ';
			} else
			{
				echo "<input 
						 type='text' 
						 name='".($field['pole'])."' 
						 value='".($wartosc)."'";
			}

			if  ($field['data'])
			{
				echo ' class="form-control datePicker"';
			} 
			elseif  ($field['dataczas'])
			{
				echo ' class="form-control dateTimePicker"';
			} else {
				echo ' class="form-control"';
			}

			if ($field['readonly']) {
			   echo ' readonly';
			}

			if ($field['align']) {
			   echo ' style="text-align: '.($field['align']).'"';
			}

			if ($field['len']) {
			   echo ' maxlength="'.$field['len'].'"';
			}

			if ($field['valid']) {
			   echo ' onchange="valid(\''.($field['pole']).'\',\''.($field['valid']).'\')"';
			}

			if ($field['wysokosc']) 
			{
				echo '>';
				echo $wartosc;
				echo '</textarea>';
			} elseif ($field['query']) 
			{
				echo '>';
				$opcje=mysqli_query($link, $field['query']);
				while ($opcja=mysqli_fetch_row($opcje))
				{
					echo '<option';
					if  (	strlen($wartosc)>0
						&&	$wartosc==substr($opcja[0],0,strlen($wartosc))
						&&	!$bylSelected
						)
					{
						echo ' selected';
						$bylSelected=true;
					}
					echo '>'.$opcja[0];
				}
				if (substr($field['pole'],0,5)!='GDZIE')
				{
					echo '<option';
					if  (	strlen($wartosc)==0
						&&	!$bylSelected
						)
					{
						echo ' selected';
						$bylSelected=true;
					}
					echo '>';
				}
				echo '</select>';
			} else
			{
				echo ' />';
			}
		echo '
		</div>';
		++$j;
	}
	echo "\n";
	echo '</div>';
	echo "\n";

?>
      </div>
   </div>
</div>

<ul class="nav nav-tabs">
<li class="active" id="liTowary">     <a href="#Towary"			data-toggle="tab">1. Towary</a></li>
</ul>

<div class="tab-content">

   <div class="tab-pane active in" id="Towary" style="margin: 20px 0px 20px 0px; padding: 0px;">
      <div class="container-fluid bs-docs-container">
         <div class="row">
            <div class="col-md-12">
				<iframe id="iframeTowary" width='100%' height='400' src='<?php echo "/$baza/Towary/Tabela/index.php?id_d=$id";?>'></iframe>
            </div>
         </div>
      </div>
   </div>

</div>

<?php $bezLemurVer=true; require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");?>
<link href="view.css" rel="stylesheet">
<script src="view.js"></script>

<?php
/*
<script type="text/javascript">

$(document).ready(function() {
	var tabindex = 1;
	$('input,select').each(function() {
	  if (this.type != "hidden") {
		var $input = $(this);
		$input.attr("tabindex", tabindex);
		tabindex++;
		tabindex++;
	  }
	});
});
</script>

*/
?>