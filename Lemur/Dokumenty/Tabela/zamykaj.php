<?php

//die(print_r($_POST));

$czas=date('Y-m-d H:i:s');

ini_set('max_execution_time', 600);
error_reporting(E_ERROR | E_PARSE);

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$saZapisyKPR=mysqli_fetch_row(mysqli_query($link,$q="
				select count(*)
				  from kpr
"))[0];
$saZapisyDG=mysqli_fetch_row(mysqli_query($link,$q="
				select count(*)
				  from nordpol
"))[0];
$klientNaKPR=($saZapisyKPR&&!$saZapisyDG);

$dk='DK';
$lp=0;
$wynik=0;

for($dzien=1;$dzien<=31;++$dzien)
{
	if(!$_POST['okres'])
	{
		$typ=mysqli_fetch_row(mysqli_query($link,$q="
			select TYP
			  from dokumenty
			 where GDZIE='bufor'
			   and ID='$_POST[id]'
		"))[0];
		if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

		$typy=array($typ);
	}
	else
	{
		$data=$_POST['okres'].'-'.substr('0'.$dzien,-2,2);
		$typy=explode(',',$_POST['typy']);
		$typy=((count($typy)>0)?$typy:array(1));
	}
	foreach($typy as $typ)
	{
		$typ=trim($typ);

		$dokumenty=mysqli_query($link,$q="
			select *
			  from dokumenty
			 where GDZIE='bufor'
			   and if('$_POST[okres]'='',ID='$_POST[id]',DOPERACJI='$data')
			   and if('$_POST[typy]'='',1,TYP='$typ')
		  order by DOPERACJI, ID
		");
		if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

		while($dokument=mysqli_fetch_array($dokumenty))
		{
			$dt=($_POST['dataks']?$_POST['dataks']:$dokument['DOPERACJI']);
			$nr=substr($dt,5,2)*1;
			$do=$dokument['NUMER'];
			$tr=$dokument['PRZEDMIOT'];
			$na=$dokument['NAZWA'];
			$dt2=$dokument['DDOKUMENTU'];

			if($klientNaKPR)
			{
				$pz=mysqli_fetch_row(mysqli_query($link,$q="
					select count(*)
					  from kpr
					 where ID_D=$dokument[ID]
				"))[0];
			}
			else
			{
				if(!$lp)
				{
					$lp=mysqli_fetch_row(mysqli_query($link,$q="
						select LP
						  from nordpol
						 where DOK='$dk'
						   and NR='$nr'
						 order by LP*1 desc
						 limit 1
					"))[0]+1;
				}

				$dekrety=mysqli_query($link,$q="
					select *
					  from dokumentk
					 where ID_D=$dokument[ID]
				  order by ID
				");
				if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

				$pz=0;
				while($dekret=mysqli_fetch_array($dekrety))
				{
					++$pz;
					$wa=$dekret['WINIEN'];
					$wn=$dekret['KONTOWN'];
					$ma=$dekret['KONTOMA'];
					$op=$dekret['PRZEDMIOT'];
					mysqli_query($link,$q="
						insert 
						  into nordpol 
						values (0, '$dk', '$nr', '$dt', '$lp', '$pz', '$wa', '$wn', '$ma', '$do', '$na', '$dt2', '$op', '', $ido, Now())
					");
					if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
				}

				if	( ($dokument['TYP']=='LP')
					&&($pz>0)
					)
				{
					$od=date('01.m.Y',strtotime($dt));
					$do=date('t.m.Y',strtotime($dt));
					$dowod="Listy p³ac z okresu: $od - $do";

					$dekrety=mysqli_query($link, "
					select *
					  from nordpol
					 where DATA='$dt' 
					   and LP=$lp
					order by PZ
					");

					$suma=0;
					$idpracownika=0;
					$danePracownika='';
					while($dekret=mysqli_fetch_array($dekrety))
					{
						if(substr($dekret['MA'],0,3)=='241')
						{
							$idpracownika=str_replace('241-','',$dekret['MA']);
							$danePracownika=mysqli_fetch_row(mysqli_query($link, "select NAZWISKOIMIE from pracownicy where ID=$idpracownika"))[0];
						}
						if(substr($dekret['WINIEN'],0,3)=='241')
						{
							$idpracownika=str_replace('241-','',$dekret['WINIEN']);
							$danePracownika=mysqli_fetch_row(mysqli_query($link, "select NAZWISKOIMIE from pracownicy where ID=$idpracownika"))[0];
						}
						if(substr($dekret['WINIEN'],0,3)=='231')
						{
							$idpracownika=str_replace('231-','',$dekret['WINIEN']);
							$danePracownika=mysqli_fetch_row(mysqli_query($link, "select NAZWISKOIMIE from pracownicy where ID=$idpracownika"))[0];
						}
						/*
						if	( (substr($dekret['WINIEN'],0,3)=='404')
							&&(substr($dekret['MA'],0,3)=='241')
							)
						{
							$suma=0;
						}
						if	( (substr($dekret['WINIEN'],0,3)=='404')
							||(substr($dekret['WINIEN'],0,3)=='405')
							)
						{
							$suma+=$dekret['KWOTA'];
						}
						if	( (substr($dekret['WINIEN'],0,3)=='503')
							)
						{
							mysqli_query($link, $q="
								update nordpol
								   set KWOTA='$suma'
								 where DATA='$dt'
								   and LP=$lp
								   and ID=$dekret[ID]
							");
							
							if($suma<>($kw=mysqli_fetch_row(mysqli_query($link, $q="
								select KWOTA
								  from nordpol
								 where DATA='$dt'
								   and LP=$lp
								   and ID=$dekret[ID]
							"))[0]))
							{
								echo "Pracownik $idpracownika, $danePracownika: $suma <> $kw <br>";
							}
						}
						*/
						mysqli_query($link, $q="
							update nordpol
							   set NAZ1='$dowod'
								 , NAZ2='$danePracownika'
							 where DATA='$dt'
							   and LP=$lp
							   and ID=$dekret[ID]
						");
					}
				}
			}
			
			if($pz>0)
			{
				++$lp;
				++$wynik;
				mysqli_query($link, $q="update dokumenty set GDZIE='ksiêgi', PK_DOK='$dk', PK_NR='$nr', DWPROWADZE='$dt' where ID=$dokument[ID]");
				if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
			}

			$towary=mysqli_query($link,$q="
				select *
				  from dokumentm
				 where ID_D=$dokument[ID]
			  order by ID
			");
			if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

			$mnoznik=(in_array($typ,array('ST','SU','STU','WZ','MM','FV','FVK','RW','IR'))?-1:1);
			$mnoznik=(in_array($typ,array('FZK','FVT','FVN','FVF','FVX','FVZ'))?0:$mnoznik);
			
			$pz=0;
			while($towar=mysqli_fetch_array($towary))
			{
				++$pz;
				mysqli_query($link,$q="
					update towary
					   set STAN=STAN+($mnoznik*'$towar[ILOSC]')
					 where INDEKS='$towar[INDEKS]'
					   and STATUS<>'U'
				");
				if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
			}

			if($pz>0)
			{
				++$lp;
				++$wynik;
				mysqli_query($link, $q="update dokumenty set GDZIE='ksiêgi', DWPROWADZE='$dt' where ID=$dokument[ID]");
				if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
			}

		}
	}
}

$title="Zamykanie dokumentów: raport";
$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"..");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

echo "<table width='100%' height='100%'>";
echo "<tr>";
echo "<td width='33%'></td>";
echo "<td>";

echo "<h1>Raport zamykania:</h1>";
echo "<br>$wynik dokumentów zamkniêtych";
echo '<hr>';

echo '<div class="form-group">';
echo $czas.' czas rozpoczêcia';
echo '</div>';

echo '<div class="form-group">';
echo date('Y-m-d H:i:s').' czas zakoñczenia';
echo '</div>';

echo "</td>";
echo "<td width='33%'></td>";
echo "</tr></table>";

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");