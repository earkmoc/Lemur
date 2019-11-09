<?php

$tabelaNazwa=(@$firma?"{$firma}_{$tabela}":$tabela);

if	( ($tabela<>'osoby')
	&&($widok<>'osoby')
	&&(!@$_SESSION['osoba_id'])
	)
{
	header('Location:/Lemur2/Logowanie');
}

$fields=array();

$idTabeli=0;
$w=mysqli_query($linkLemur, "
	select ID, TABELA, STRUKTURA
	  from tabele
	 where NAZWA='$widok'
	 limit 1
");

$from='';
while($r=mysqli_fetch_row($w)) {

	$idTabeli=$r[0];
	$wiersze=explode("\n",stripSlashes($r[1]));

	$struktura=StripSlashes($r[2]);
	$struktura=explode(';',$struktura);
	$struktura=$struktura[0];
	$struktura=str_replace('TYPE=MyISAM','ENGINE=MyISAM  DEFAULT CHARSET=latin1',$struktura);
	$struktura=str_replace($tabela,$tabelaNazwa,$struktura);

	$i=0;
	foreach($wiersze as $wiersz) {
		if (substr($wiersz,0,5)=='from ') {
		   $from=$wiersz;
		} elseif (substr($wiersz,0,5)=='left ') {
		   $from.=$wiersz;
		} elseif (substr($wiersz,0,6)=='force ') {
		   $from.=$wiersz;
		} elseif (substr($wiersz,0,5)=='where') {
		   $from.=$wiersz;
		} elseif (substr($wiersz,0,5)=='order') {
			$orderBy=$wiersz;
		} elseif (substr($wiersz,0,5)=='group') {
			$groupBy=$wiersz;
		} elseif (substr($wiersz,0,8)=='prequery') {
			continue;
		} elseif (!trim($wiersz)) {
			continue;
		} else {
		   $kolumny=explode("|",$wiersz);
		   if ($i++>0) 
		   {
		      if ( (substr($kolumny[0],0,1)=="(")
		         ||(substr($kolumny[0],0,3)=="if(")
		         ||(substr($kolumny[0],0,7)=="format(")
		         ||(substr($kolumny[0],0,6)=="round(")
		         ||(strpos($kolumny[0],'.')>0)
		         )
		      {
		         $pole=$kolumny[0];
		      } else {
		         $pole="$tabelaNazwa.".$kolumny[0];
		      }
			  $pole=str_replace('osoba_id',$ido,$pole);
			  $poleNum=str_replace(array('format(',',2)'),array('',''),$pole);
		      //$nazwa=iconv ( 'iso-8859-2', 'utf-8', $kolumny[1]?$kolumny[1]:$kolumny[0]);
		      $nazwa=(@$kolumny[1]?$kolumny[1]:ucfirst(strtolower($kolumny[0])));
			  $align=(strpos(@$kolumny[3],'right')?'right':(strpos(@$kolumny[3],'center')?'center':'left'));
			  $visible=(@$kolumny[2]=='0'?'false':'true');
			  //$visible=(((substr($pole,-4,4)=='CZAS')&&($ido!==1))?'false':$visible);
			  $width=@$kolumny[2]*1;
			  if(	( (@$kolumny[2]!='0')
					||(@$kolumny[0]=='ID')
					)
					&&!((substr(trim($pole),-4)=='CZAS')&&($ido!=1))
					&&!((substr(trim($pole),-3)=='KTO')&&($ido!=1))
					&&!((substr(trim($nazwa),-4)=='ID_D')&&($ido!=1)&&($visible))
				)
			  {
				@$fields[]=array(
					 'pole'=>$pole
					,'nazwa'=>$nazwa
					,'format'=>$kolumny[2]
					,'align'=>$align
					,'visible'=>$visible
					,'width'=>$width
					,'poleNum'=>$poleNum
				);
			  }
		   }
		}
	}
}

$from=str_replace('osoba_id',$ido,$from);
$from=str_replace($tabela,$tabelaNazwa,$from);

//jeśli w where jest coś w stylu "where ID=[0]", to wytnij wszystko po "where" i polegaj na "mandatory"
if (strpos(trim($from),']')!==false)
{
	$from=explode('where',$from)[0];
}

require_once("saveMenuPosition.php");

//utworzenie pustej tabeli gdy jej nie ma
if (mysqli_num_rows(mysqli_query($link, $q="
	show tables like '$tabelaNazwa'
"))==0)
{
	mysqli_query($link, $struktura);
	if (mysqli_error($link)) {
		die(mysqli_error($link)."<br>tabela=$tabelaNazwa<br>widok=$widok<br>struktura=$struktura");
	}
}

if(in_array($tabela,array('menu','schematy','schematys','rejestry','dnordpol','slownik')))
{
	if( mysqli_fetch_row(mysqli_query($link,"
			select count(*) from $tabelaNazwa
		"))[0]==0
	  )
	{
		mysqli_query($link,"
			insert into $tabelaNazwa select * from Lemur.$tabela
		");
	}
}

if($tabela=='knordpol')
{
	if( mysqli_fetch_row(mysqli_query($link,"
			select count(*) from $tabelaNazwa
		"))[0]==0
	  )
	{
		mysqli_query($link,"
			insert into $tabelaNazwa select * from Lemur.$tabela where NAZWA=''
		");
	}
}

$w=mysqli_query($link,"
	select *
	  from tabeles
	 where ID_TABELE='$idTabeli'
	   and ID_OSOBY='$ido'
");
while($r=mysqli_fetch_array($w)) {
	$str=$r['NR_STR'];
	$row=$r['NR_ROW'];
	$col=$r['NR_COL'];
	$idTabeles=$r['ID'];
}
