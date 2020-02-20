<?php

require("setup.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

$tmp=mysqli_fetch_row(mysqli_query($link, "
select PSKONT 
  from $tabela 
 where ID=$id
")); 
$folder=$tmp[0];

if(in_array(strtoupper($folder),array('SYS','MYSQL','LEMUR2')))
{
	die('Nie usuwaj tego folderu!!!');
}

/*
try
{
	$dir = "{$_SERVER['DOCUMENT_ROOT']}/$folder";
	$it = new RecursiveDirectoryIterator($dir, RecursiveDirectoryIterator::SKIP_DOTS);
	$files = new RecursiveIteratorIterator($it,
				 RecursiveIteratorIterator::CHILD_FIRST);
	foreach($files as $file) {
		if ($file->isDir()){
			rmdir($file->getRealPath());
		} else {
			unlink($file->getRealPath());
		}
	}
	rmdir($dir);
} catch(Exception $e)
{
    echo 'Caught exception: ',  $e->getMessage(), "\n";
}
*/

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
