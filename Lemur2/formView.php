<?php

function isLabelWithFieldInOneRow($field)
{
	return substr($field['nazwa'],-1,1)==':';
}

function isFieldInRow($fields,$row)
{
	$jest=false;
	foreach($fields as $field)
	{
		if ($field['gridrow']==$row)
		{
			$jest=true;
		}
	}
	return $jest;
}

function isFieldInRowBelowLabel($fields,$row)
{
	$jest=false;
	foreach($fields as $field)
	{
		if  (  ($field['gridrow']==$row)
			&& !isLabelWithFieldInOneRow($field)
			)
		{
			$jest=true;
		}
	}
	return $jest;
}

function ShowField($field,$row,$dane,$szerokoscPola,$link)
{
	if	( ($row==0)
		||($field['gridrow']==$row)
		)
	{
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
//				echo 'Query="'.$field['query'].'"';
			} else
			{
				echo "<input 
						 type='".($field['checkbox']?'checkbox':($field['pass']?'password':'text'))."' 
							   ".($field['checkbox']&&$wartosc?'checked':'')." 
						 name='".($field['pole'])."' 
						 value='".($field['checkbox']?1:$wartosc)."'";
			}

			if  ($field['data'])
			{
				//echo ' class="form-control datePicker"';
				echo ' class="form-control"';
			} 
			elseif  ($field['dataczas'])
			{
				//echo ' class="form-control dateTimePicker"';
				echo ' class="form-control"';
			} else {
				echo ' class="form-control"';
			}

			if ($field['readonly']) {
			   echo ' readonly';
			}

			if ($field['style']) {
			   echo ' '.($field['style']);
			} elseif ($field['align']) {
			   echo ' style="text-align: '.($field['align']).'"';
			}

			if ($field['valid']) {
			   echo ' onchange="valid(\''.($field['pole']).'\',\''.($field['valid']).'\');"';
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
				if	(	(substr($field['pole'],0,5)!='GDZIE')
					&&	(substr($field['pole'],0,3)!='TYP')
					&&	(substr($field['pole'],0,4)!='USER')
					&&	!$bylSelected
					)
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

				if ($field['szerokosc']) {
				   echo ' maxlength="'.$field['szerokosc'].'"';
				}

				echo ' />';
			}
		echo '
		</div>';
	}
}

function ShowLabel($field,$row,$dane,$szerokoscOpisu,$right,$musi=False)
{
	if ( ( ($row==0)
		 ||($field['gridrow']==$row)
		 )
	   &&( ($field['gridLabel']*1>0)
		 ||$musi
		 )
	   )
	{
		//	.($right?' style="text-align:right; padding-left:5px; padding-right:3px; padding-top:7px; padding-bottom:7px;"':'')
		echo "\n".'		<div class="col-md-'
			.((($szerokoscOpisu*1)>0)?$szerokoscOpisu:($field['gridLabel']*1>0?$field['gridLabel']:($field['grid']*1>0?$field['grid']:$szerokoscOpisu)))
			.' nag"'
			.' style="text-align:left; padding-left:5px; padding-right:3px; padding-top:7px; padding-bottom:7px;"'
			.' >'
			.($field['nazwa'])
			.((substr($field['nazwa'],-1,1)==':')?'':':')
			.'</div>';
	}
}

function ShowLabelOrField($field,$row,$dane,$szerokoscOpisu,$szerokoscPola,$link)
{
	if(isLabelWithFieldInOneRow($field))
	{
		ShowLabel($field,$row,$dane,$szerokoscOpisu,true);
		ShowField($field,$row,$dane,$szerokoscPola,$link);
	}
	else
	{
		ShowLabel($field,$row,$dane,$szerokoscOpisu,false);
	}
}

if ($poziomo)
{
	for($row=1;$row<=20;++$row)
	{
		if(isFieldInRow($fields,$row))
		{
			echo '<div class="row">';
			foreach($fields as $field)
			{
				ShowLabelOrField($field,$row,$dane,0,$szerokoscPola,$link);
			}
			echo '</div>';
			
			if(isFieldInRowBelowLabel($fields,$row))
			{
				echo '<div class="row">';
				foreach($fields as $field)
				{
					ShowField($field,$row,$dane,$szerokoscPola,$link);
				}
				echo '</div>';
			}
		}
	}
	echo "<br>";
}
else
{
	foreach($fields as $field) 
	{
		echo "\n".'<div class="row">';
		ShowLabel($field,0,$dane,$szerokoscOpisu,true,true);
		ShowField($field,0,$dane,$szerokoscPola,$link);
		echo "\n".'</div>';
	}
}