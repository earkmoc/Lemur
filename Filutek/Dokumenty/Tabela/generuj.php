<?php

//die(print_r($_POST));

function dokGeneruj($link,$dokument,$prog,$procent,$towar,$typ,$ido)
{
	$dokument[0]=0;
	$dokument[4]=$typ;
	$dokument[37]=round($dokument[24]*0.23,2);	//VAT
	$dokument[43]=$dokument[24]+$dokument[37];	//BRUTTO=NETTO
	$dokument[44]=$dokument[43];				//WPLACONO

	$q='';
	foreach($dokument as $key => $value)
	{
		//$q.=($q?',':'')."'".AddSlashes($value)."'";
		$q.=($q?',':'')."'$value'";
	}
	mysqli_query($link,$q="
		insert 
		  into dokumenty
		values ($q)
	"); 
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
	$idd=mysqli_insert_id($link);
	
	mysqli_query($link,$q="
		insert 
		  into dokumentm
		   set ID_D=$idd
		     , KTO=$ido
			 , CZAS=Now()
			 , TYP='T'
			 , NETTO='$dokument[24]'
			 , STAWKA='23%'
			 , VAT='$dokument[37]'
			 , BRUTTO='$dokument[43]'
			 , ILOSC=1
			 , NAZWA='$towar'
			 , INDEKS='czesci'
			 , PKWIU=''
			 , JM='szt.'
			 , CENABEZR='$dokument[24]'
			 , CENA='$dokument[24]'
	"); 
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

	$w=mysqli_query($link,$q="
		select ID
		  from towary
		 where INDEKS='czesci'
		   and NAZWA='$towar'
		   and CENA_Z='$dokument[24]'
		   and STATUS='T'
	"); 
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

	$r=mysqli_fetch_row($w);
	if($r&&$r[0])
	{
		$idt=$r[0];
	}
	else
	{
		mysqli_query($link,$q="
		insert 
		  into towary
		   set KTO=$ido
		     , CZAS=Now()
		     , INDEKS='czesci'
		     , NAZWA='$towar'
			 , CENA_Z='$dokument[24]'
			 , JM='szt.'
			 , PKWIU=''
			 , STAWKA='23%'
			 , STATUS='T'
		"); 
		if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
		$idt=mysqli_insert_id($link);
	}

	$zmiana=($typ=='PZ'?1:-1);
	mysqli_query($link,$q="
	update towary
	   set STAN=STAN+($zmiana)
	 where ID=$idt
	"); 
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

	return 1;
}

function Generuj($link,$dokument,$prog,$procent,$towar,$typ,$ido)
{
	$wynik=0;
	$netto=$dokument[24];
	if(	($netto<=$prog)
	  ||($typ=='WZ')
	  )
	{
		$dokument[24]=($typ=='WZ'?round($dokument[24]*$procent*0.01,2):$dokument[24]);
		$wynik+=dokGeneruj($link,$dokument,$prog,$procent,$towar,$typ,$ido);
	}
	else
	{
		$wartosc=round($netto/4,2);
		for($i=0;$i<4;++$i)
		{
			if($i==3)
			{
				$wartosc=$netto;
			}
			$netto-=$wartosc;
			$dokument[24]=$wartosc;
			$wynik+=dokGeneruj($link,$dokument,$prog,$procent,$towar,$typ,$ido);
		}
	}
	
	return $wynik;
}

$czas=date('Y-m-d H:i:s');

ini_set('max_execution_time', 600);
error_reporting(E_ERROR | E_PARSE);

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

$_POST['typZT']=str_replace(',',"','",$_POST['typZT']);
$_POST['typST']=str_replace(',',"','",$_POST['typST']);
$_POST['prog']=str_replace(',',".",$_POST['prog']);
$_POST['procent']=str_replace(',',".",$_POST['procent']);

if($_POST['zastapic'])
{
	mysqli_query($link,$q="
		update dokumentm
	 left join dokumenty
			on dokumenty.ID=dokumentm.ID_D
			set dokumentm.ID_D=-2
		 where dokumenty.GDZIE='bufor'
		   and dokumenty.TYP IN ('PZ','WZ')
	");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

	mysqli_query($link,$q="
		delete 
		  from dokumentm
		 where ID_D=-2
	");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

	mysqli_query($link,$q="
		delete 
		  from dokumenty
		 where dokumenty.GDZIE='bufor'
		   and dokumenty.TYP IN ('PZ','WZ')
	");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

	mysqli_query($link,$q="
		delete 
		  from towary
		 where INDEKS='czesci'
		   and STATUS='T'
	");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
}

$wynik=0;

$dokumenty=mysqli_query($link,$q="
	select *
	  from dokumenty
	 where GDZIE='bufor'
	   and dokumenty.TYP IN ('$_POST[typZT]')
	 order by DOPERACJI, ID
");
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

while($dokument=mysqli_fetch_row($dokumenty))
{
	$wynik+=Generuj($link,$dokument,$_POST['prog'],$_POST['procent'],$_POST['towar'],'PZ',$ido);
}
$dokumenty=mysqli_query($link,$q="
	select *
	  from dokumenty
	 where GDZIE='bufor'
	   and dokumenty.TYP IN ('$_POST[typST]')
	 order by DOPERACJI, ID
");
if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}

while($dokument=mysqli_fetch_row($dokumenty))
{
	$wynik+=Generuj($link,$dokument,$_POST['prog'],$_POST['procent'],$_POST['towar'],'WZ',$ido);
}

$title="Masowe generowanie dokumentów PZ i WZ: raport";
$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"..");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

echo "<table width='100%' height='100%'>";
echo "<tr>";
echo "<td width='33%'></td>";
echo "<td>";

echo "<h1>Raport masowego generowania dokumentów PZ i WZ:</h1>";
echo "<br>$wynik dokumentów wygenerowanych";
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