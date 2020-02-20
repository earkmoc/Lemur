<?php

//$wzor=$_GET['Wzory'];

$file=strtoupper($wzor);	//SPOZAP
$wzor=strtolower($wzor);	//spozap
$wzory=array();
$wzory['tabela']=$wzor;
$wzory['widok']=$wzor;

if($r=mysqli_fetch_row(mysqli_query($linkLemur, "
	select count(*), OPIS
	  from tabele
	 where NAZWA='$wzor'
	")))
{
	if($r[0]!=0)
	{
		$wzory['title']=$r[1];
	}
	else
	{
		$fileName="../Wzory/{$file}.txt";
		if(!($handle=fopen($fileName, "r"))) {die("Can't open file $fileName.");}
		$i=0;
		$kolumny='';
		while(($line=fgets($handle))!==false)
		{
			$line=str_replace("\n","",$line);
			$line=str_replace("\r","",$line);
			$line=str_replace("’","³",$line);
			$line=str_replace("¾","¶",$line);
			$line=str_replace("«","æ",$line);
			$line=str_replace("'","",$line);
			++$i;
			switch(true)
			{
				case $i==1: 
					$wzory['title']=$line; 
					$line1=$line;
					break;
				case $i==2: $line2=$line; break;
				case $i==3: $line3=$line; 
				case $i==5: $line5=$line;
				case $i>2: 
					$kolumny.="$line\n"; 
					break;
			}
		}
		fclose($handle);

		if(strpos($wzory['title'], '|')!==False)	//wariant z pierwsz± lini± nazw pól
		{
			$kolumny='';
			$pola=explode('|', $line1);
			$etyk=explode('|', $line2);
			$szab=explode('|', $line3);
			for($i=0; $i<count($pola); ++$i)
			{
				if($pola[$i])
				{
					$pola[$i]=str_replace(array('ID_F'),array('ID'),$pola[$i]);
					$szab[$i]=str_replace(array('@Z','@S'),array('',''),$szab[$i]);
					$kolumny.="{$pola[$i]}|{$etyk[$i]}|{$szab[$i]}|\n";
				}
			}
			$wzory['title']=$line5; 
		}

		$fileName="../Wzory/TABELE.SQL";
		if(!($handle=fopen($fileName, "r"))) {die("Can't open file $fileName.");}
		$notuj=False;
		$struktura='';
		while(($line=fgets($handle))!==False)
		{
			$line=AddSlashes($line);
			if($notuj&&(substr($line,0,1)=='#')) {break;}
			if($notuj) {$struktura.="$line";}
			if(stripos($line, "DROP TABLE IF EXISTS $wzor;")===0) {$notuj=True;}
		}
		fclose($handle);

		$pola="{$wzor}\n{$kolumny}from {$wzor}\nwhere ID=";
		$kolumny="{$wzor}\nID|ID|0|\n{$kolumny}from {$wzor}";
		mysqli_query($linkLemur, $q="
			insert 
			  into tabele
			   set NAZWA='$wzor'
				 , OPIS='{$wzory['title']}'
				 , STRUKTURA='$struktura'
				 , TABELA='$kolumny'
				 , FORMULARZ='$pola'
		"); if (mysqli_error($linkLemur)) {die(mysqli_error($linkLemur));}
	}
}
