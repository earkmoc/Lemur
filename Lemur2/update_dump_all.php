<?php

function AddToFile($fileName,$klient)
{
	$fileHandler="{$_SERVER['DOCUMENT_ROOT']}/$fileName";
	$fileContent=file_get_contents($fileHandler);
	$search='call dump.bat Lemur2'."\n";
	$replace="call dump.bat $klient"."\n";
	if(!stripos($fileContent,$replace))
	{
		$fileContent=str_replace($search,$search.$replace,$fileContent);
		file_put_contents($fileHandler,$fileContent);
	}
}

$w=mysqli_query($link,$q="
	select PSKONT 
	  from Lemur.klienci
");
while($r=mysqli_fetch_row($w))
{
	AddToFile("dump_all.bat",$r[0]);
}