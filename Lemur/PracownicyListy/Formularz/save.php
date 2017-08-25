<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
$idd=$_SESSION["{$baza}ListyPlacID_D"];
if ($idd)
{
	$_POST['ID_D']=$idd;
}

$_POST['KTO']=$_SESSION['osoba_id'];
$_POST['CZAS']=date('Y-m-d H:i:s');

$kuzprzych=0;
$kwolna=0;
if(!$_POST['KUZPRZYCH']||!$_POST['KWOLNA'])
{
	//ODLICZANEKOSZTY|Odliczane koszty uzyskania przychodu|@Z|right|1|
	//ODLICZANAKWOP|Odliczana kwota wolna od podatku|@Z|right|1|
	$w=mysqli_query($link, $q="select ODLICZANEKOSZTY, ODLICZANAKWOP from pracownicy where ID='$_POST[ID_P]'"); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
	if($r=mysqli_fetch_row($w))
	{
		$kuzprzych=$r[0];
		$kwolna=$r[1];
	}
}

function PodatekDochodowy($x, $podstawy, $kwolna, $potracenia)
{
	$test=false;
	if($test)
	{
		echo "kwota			=$x<br>";
		echo "podstawy		=$podstawy<br>";
		echo "kwolna/mc		=$kwolna<br>";
		echo "potracenia	=$potracenia<br>";
	}
	
	//Rok 2016
	$prog1kwota=85528;
	$prog1proc=18;

	//próg 2 jest specjalnie ustawiony "w kosmos", żeby nikt go nie przekroczył, więc nikt nie wchodzi w 3 próg w 2016 r.
	$prog2kwota=74048000000;
	$prog2proc=32;
	$prog2rycz=14839.02;
	
	//próg 3 nieużywany w 2016
	$prog3proc=40;
	$prog3rycz=17611.68;
	
	switch (true)
	{
		case ($x+$podstawy)<=$prog1kwota:
			echo ($test?"prog 1: ($x+$podstawy)<=$prog1kwota: 	podatek=round($x*$prog1proc*0.01,2)-$kwolna<br>":'');
			$x=round($x*$prog1proc*0.01,2)-$kwolna; 
			break;
		case ($x+$podstawy)<=$prog2kwota:
			echo ($test?"prog 2: ($x+$podstawy)<=$prog2kwota: 	podatek=round($prog2rycz+($x+$podstawy-$prog1kwota)*$prog2proc*0.01,2)<br>":'');
			$x=round($prog2rycz+($x+$podstawy-$prog1kwota)*$prog2proc*0.01,2); 
			$x-=$potracenia;
			break;
		default:
			echo ($test?"prog 3: ($x+$podstawy)>$prog2kwota: 	podatek=round($prog3rycz+($x+$podstawy-$prog2kwota)*$prog3proc*0.01,2)<br>":'');
			$x=round($prog3rycz+($x+$podstawy-$prog2kwota)*$prog3proc*0.01,2); 
			echo ($test?"potracenia: $x-$potracenia<br>":'');
			$x-=$potracenia;
			break;
	}
	if($test) {echo "podatek= $x<br>";die;}
	return ($x<0?0:$x);
}

function SumaPoz($pole,$link,$idd)
{
	$dataListy=date('Y-m-d');
	if($idd)
	{
		$w=mysqli_query($link, $q="select DATA from listyplac where ID='$idd'"); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
		$dataListy=mysqli_fetch_row($w)[0];
	}
	
	$w=mysqli_query($link, $q="
		select sum($pole) 
		  from listyplacp
	 left join listyplac
			on listyplac.ID=listyplacp.ID_D
		 where listyplacp.ID_P=1*'$_POST[ID_P]'
		   and !isnull(listyplac.ID)
		   and listyplac.DATA<'$dataListy'
		   and year(listyplac.DATA)=year('$dataListy')
	"); if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
	return mysqli_fetch_row($w)[0];
}

$_POST['OGPRZYCHOD']=$_POST['P_PODST']+$_POST['DOD1']+$_POST['DOD2']+$_POST['DOD3']+$_POST['ZAS_CHOR'];
$_POST['PSUS']=$_POST['OGPRZYCHOD']-$_POST['ZAS_CHOR'];
$_POST['SUE']=round($_POST['PSUS']*9.76*0.01,2);
$_POST['SUR']=round($_POST['PSUS']*1.50*0.01,2);
$_POST['SUCH']=round($_POST['PSUS']*2.45*0.01,2);
$_POST['SRAZEM']=$_POST['SUE']+$_POST['SUR']+$_POST['SUCH'];

$_POST['KUZPRZYCH']=($_POST['KUZPRZYCH']?$_POST['KUZPRZYCH']:$kuzprzych);
$_POST['KWOLNA']=($_POST['KWOLNA']?$_POST['KWOLNA']:$kwolna);

$_POST['PSUZ']=$_POST['OGPRZYCHOD']-$_POST['SRAZEM'];

$_POST['PONAPODOCH']=round($_POST['PSUZ']-$_POST['KUZPRZYCH']+$_POST['ZASWYPLAC'],2);
$_POST['PONAPODOCH']=($_POST['PONAPODOCH']<0?0:$_POST['PONAPODOCH']);

$_POST['POZANAPODO']=round(PodatekDochodowy($_POST['PONAPODOCH'],SumaPoz('PONAPODOCH',$link,$idd),$_POST['KWOLNA'],SumaPoz('POZANAPODO',$link,$idd)),2);
$_POST['SUZNA']=($suzna=round($_POST['PSUZ']*9.00*0.01,2));
$_POST['SUZ']=(($suz=round($_POST['PSUZ']*7.75*0.01,2))<$_POST['POZANAPODO']?$suz:$_POST['POZANAPODO']);
$_POST['NAZANAPODO']=round($_POST['POZANAPODO']-$_POST['SUZ'],0);
$_POST['PORAZEM']=$_POST['POINNE']+$_POST['NAZANAPODO']+$_POST['SUZNA']+$_POST['SGRUBNAZY'];
$_POST['DOWY']=$_POST['OGPRZYCHOD']-$_POST['SRAZEM']+$_POST['ZARO']-$_POST['PORAZEM'];
$_POST['SUEP']=round($_POST['PSUS']*9.76*0.01,2);
$_POST['SURP']=round($_POST['PSUS']*6.50*0.01,2);
$_POST['SUCHP']=round($_POST['PSUS']*1.80*0.01,2);
$_POST['SRAZEMP']=$_POST['SUEP']+$_POST['SURP']+$_POST['SUCHP'];
$_POST['FPRACY']=round($_POST['PSUS']*2.45*0.01,2);
$_POST['FGSP']=round($_POST['PSUS']*0.10*0.01,2);

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveFormFields.php");
