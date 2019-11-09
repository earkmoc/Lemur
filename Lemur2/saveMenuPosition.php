<?php

saveMenuPosition($ido,$link);

function saveMenuPosition($ido,$link)
{
	if  ( @$_GET['mm']
		&&@$_GET['m']
		)
	{
		$sets="NR_ROW='$_GET[mm]'
			 , NR_COL='$_GET[m]'
			 , ID_TABELE=0
			 , ID_OSOBY='$ido'
		";
		mysqli_query($link, "
					 insert 
					   into tabeles
						set $sets
	on duplicate key update $sets
		");
	}
}
