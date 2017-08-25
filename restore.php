<?php

$raw=0;

if(count($_POST)>0)
{
	$archiwum=$_POST['archiwum'];
	if(substr($archiwum,0,11)=='BazaDanych_')
	{
		header("location: Lemur");
		$content="";
		foreach($_POST as $key => $value)
		{
			if($key!='archiwum')
			{
				$content.='"C:\\Program Files\\7-Zip\\7z.exe" x -y C:\\Archiwa\\'.$archiwum.' '.trim($key)."_Dump.7z\n";
				$content.="call Restore_from_Dump.bat $key\n";
			}
		}
		file_put_contents("Restore.bat",$content);
		system("Restore.bat");
	}
	else
	{
		header("location: restore.php");
	}
}
else
{
	$title="Restore";
	$buttons=array();
	$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>"Lemur/Klienci");
	$buttons[]=array('klawisz'=>'Enter','nazwa'=>'Enter=wykonaj Restore','akcja'=>"restore.php");
	$buttons[]=array('klawisz'=>'AltZ','nazwa'=>'Zaznacz wszystkich','js'=>"$('input').prop('checked', true)");
	$buttons[]=array('klawisz'=>'AltO','nazwa'=>'Odznacz wszystkich','js'=>"$('input').prop('checked', false)");

	$file="{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl"; if($raw) {$file.='x';}
	if(file_exists($file)) 
	{
		require($file);
	}
	else
	{
		echo "<form action='restore.php' method='POST'";
	}

	echo "<table width='100%' height='100%'>";
	echo "<tr>";
	echo "<td>";

	if(!file_exists('C:\Program Files\7-Zip\7z.exe'))
	{
		die('<h1 style="color:red">Zainstaluj program 7-zip. WWW: <a target="_blank" href="http://7-zip.org.pl/">7-zip.org.pl</a></h1>');
	}

	echo '<h1>Wybierz archiwum bazy danych</h1>';
	echo '<select name="archiwum">';

	$dir = opendir('C:\Archiwa'); 
	while(false !== ( $plik=readdir($dir)) ) 
	{ 
		if(substr($plik,0,11)=='BazaDanych_')
		{
			echo "<option>$plik";
		} 
	} 
	closedir($dir); 

	echo '</select>';
	echo "<hr>";

	echo "<h1>Wybierz klientów do odtworzenia z powy¿szego archiwum".((!file_exists($file))?", a potem kliknij <button> Wykonaj odtworzenie </button>":'')."</h1>";
	echo "<hr>";

//---------------------------------------------------------------------------------------------------

	$wampVer='C:\wamp';
	$wampVer=(file_exists($wampVer)?$wampVer:$wampVer.'64');
	if(!file_exists($wampVer))
	{
		die('<h1 style="color:red">Zainstaluj serwer WAMP '."(brak $wampVer)".': <a target="_blank" href="http://www.wampserver.com/en/">wampserver.com</a></h1>');
	}

//---------------------------------------------------------------------------------------------------

	$mySQLver='';
	$d = dir($wampVer."\\bin\\mysql\\");
	while (false !== ($entry = $d->read())) {
	   if(substr($entry,0,5)=='mysql')
	   {
		   $mySQLver=$d->path.$entry;
	   }
	}
	$d->close();
	if(!file_exists($mySQLver))
	{
		die('<h1 style="color:red">'."Brak $mySQLver)".'</h1>');
	}

//---------------------------------------------------------------------------------------------------

	$plikZnacznikowy=$mySQLver.'\data\lemur2\tabele.MYD';
	$checked=(!file_exists($plikZnacznikowy)?'checked':'');
	$file="{$_SERVER['DOCUMENT_ROOT']}/dump_all.bat";
	foreach(explode("\n",file_get_contents($file)) as $key => $value)
	{
		$linia=explode('.bat ',$value);
		echo ((count($linia)>1)?"<input $checked type='checkbox' name='$linia[1]' />$linia[1]<br>":"<br>");
	}

	echo "</td>";
	echo "</tr></table>";

//---------------------------------------------------------------------------------------------------

	function ChangeFile($name,$search,$repl)
	{
		$file="{$_SERVER['DOCUMENT_ROOT']}/$name";
		$dumpBat=file_get_contents($file);
		foreach(explode("\n",$dumpBat) as $key => $value)
		{
			$linia=explode($search,$value);
			if(count($linia)>1)
			{
				$dumpBat=str_replace($linia[0],$repl,$dumpBat);
			}
		}
		file_put_contents($file,$dumpBat);
	}

	ChangeFile('Restore_from_Dump.bat','mysql.exe',$mySQLver."\\bin\\");
	ChangeFile('dump.bat','mysqldump.exe',$mySQLver."\\bin\\");

//---------------------------------------------------------------------------------------------------

	$file="{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl"; if($raw) {$file.='x';}
	if(file_exists($file))
	{
		require($file);
	}
	else
	{
		echo "</form";
	}
}