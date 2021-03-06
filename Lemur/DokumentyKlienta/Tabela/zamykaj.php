<?php

//die(print_r($_POST));

$czas=date('Y-m-d H:i:s');

ini_set('max_execution_time', 600);
error_reporting(E_ERROR | E_PARSE);

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

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

			if($pz>0)
			{
				++$lp;
				++$wynik;
				mysqli_query($link, $q="update dokumenty set GDZIE='ksi�gi', PK_DOK='$dk', PK_NR='$nr', DWPROWADZE='$dt' where ID=$dokument[ID]");
				if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
			}

			$towary=mysqli_query($link,$q="
				select *
				  from dokumentm
				 where ID_D=$dokument[ID]
			  order by ID
			");
			if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

			$mnoznik=(in_array($typ,array('ST','SU','WZ','MM','FV','FVK','RW','IR'))?-1:1);
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
				mysqli_query($link, $q="update dokumenty set GDZIE='ksi�gi', DWPROWADZE='$dt' where ID=$dokument[ID]");
				if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
			}

		}
	}
}

$title="Zamykanie dokument�w: raport";
$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powr�t','akcja'=>"..");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

echo "<table width='100%' height='100%'>";
echo "<tr>";
echo "<td width='33%'></td>";
echo "<td>";

echo "<h1>Raport zamykania:</h1>";
echo "<br>$wynik dokument�w zamkni�tych";
echo '<hr>';

echo '<div class="form-group">';
echo $czas.' czas rozpocz�cia';
echo '</div>';

echo '<div class="form-group">';
echo date('Y-m-d H:i:s').' czas zako�czenia';
echo '</div>';

echo "</td>";
echo "<td width='33%'></td>";
echo "</tr></table>";

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");