<?php

require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

$readonly=( ((mysqli_fetch_row(mysqli_query($link, "select GDZIE from dokumenty where ID=$id"))[0])=='ksiêgi')
			||( ($ido==0)
			  &&($id)
			  &&((mysqli_fetch_row(mysqli_query($link, "select KTO from dokumenty where ID=$id"))[0])!=$ido)
			  )
);

if($readonly)
{
	header("location:../Tabela");

}
else
{
	mysqli_query($link, "
	delete 
	  from $tabela 
	 where ID=$id
	");
	if (mysqli_error($link)) {
		die(mysqli_error($link));
	} else {
		header("location:../Tabela");
	}

	mysqli_query($link, $q="delete from dokumentk where ID_D='$id'");if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
	mysqli_query($link, $q="delete from dokumentm where ID_D='$id'");if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
	mysqli_query($link, $q="delete from dokumentr where ID_D='$id'");if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
	mysqli_query($link, $q="delete from kpr       where ID_D='$id'");if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
}