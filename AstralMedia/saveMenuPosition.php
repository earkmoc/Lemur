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
		$sets.=(isset($_GET['NIP'])?", WARUNKI='$_GET[NIP]'":"");
		$sets.=(isset($_GET['NAZWA'])?", SORTOWANIE='$_GET[NAZWA]'":"");
	/*
			 , WARUNKI=''
			 , SORTOWANIE=''
			 , MX_POZYCJI=0
			 , screenLeft=0
			 , screenTop=0
			 , screenWidth=0
			 , screenHeight=0
	*/
		mysqli_query($link, "
					 insert 
					   into tabeles
						set $sets
	on duplicate key update $sets
		");
	}
}
