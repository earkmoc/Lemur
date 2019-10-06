<?php

session_start();
//die(print_r($_GET));
$ido=$_SESSION['osoba_id'];
$osu=$_SESSION['osoba_upr'];
$punkt=$_SESSION['osoba_pu'];

$ntab_master=$_SESSION['ntab_mast'];

//include('skladuj_zmienne.php');
require('funkcje.php');
require('dbconnect.php');

@$opole=$_POST['opole'];
@$ipole=$_POST['ipole'];
@$batab=$_POST['batab'];

$batab='dokumenty';
$_GET['natab']=$batab;

@$zaznaczone=$_POST['zaznaczone'];
if ($ipole) {require('Save_Tabela.php');
} else {
	$opole="S";		// niech nie zapisuje stanu tabeli
	$ipole=$_GET['id'];
}
$fname="Wydruk.htm";
$file=fopen($fname,"w");
$zaznaczone=$ipole;

//***************************************************************************************

$q=array();
$qs=array();

$dataWersji='0000-00-00';
if ($batab=='dokumenty') {
   $z=("
       Select DDOKUMENTU
         from $batab
        where ID=$ipole
   ");
   $w=mysqli_query($link,$z);
   $r=mysqli_fetch_row($w);
   $dataWersji=$r[0];
}

$w=$_GET['wzor'];

$z=("
    Select TEKST, ID, SPACJE, WIERSZE 
      from wzoryumow 
     where NAZWA='$w' 
       and if('$dataWersji'='',1,DATA_OD<='$dataWersji')
  order by DATA_OD desc
     limit 1
");
$w=mysqli_query($linkLemur,$z);
if (!$w||(mysqli_num_rows($w)==0)) {
	$w=substr($_GET['wzor'],0,2);							//krótsza nazwa dokumentu
//	$z="Select TEKST, ID, SPACJE, WIERSZE from wzoryumow where NAZWA='$w'";
   $z=("
       Select TEKST, ID, SPACJE, WIERSZE 
         from wzoryumow 
        where NAZWA='$w' 
          and if('$dataWersji'='',1,DATA_OD<='$dataWersji')
     order by DATA_OD desc
        limit 1
   ");
	$w=mysqli_query($linkLemur,$z);
	if (!$w||(mysqli_num_rows($w)==0)) {
		$w='ST';							//awaryjna nazwa dokumentu
	//	$z="Select TEKST, ID, SPACJE, WIERSZE from wzoryumow where NAZWA='$w'";
	   $z=("
		   Select TEKST, ID, SPACJE, WIERSZE 
			 from wzoryumow 
			where NAZWA='$w' 
			  and if('$dataWersji'='',1,DATA_OD<='$dataWersji')
		 order by DATA_OD desc
			limit 1
	   ");
		$w=mysqli_query($linkLemur,$z);
	}
}

$w=mysqli_fetch_row($w);
$z=$w[1];
$spacje=$w[2];
$blokmax=$w[3];		//max ile pozycji na stronie
$w=StripSlashes($w[0]);	//tekst do zmiany (ten zapis musi byæ na koñcu)

fputs($file,'<html>'."\n");
fputs($file,'<head>'."\n");
if ($spacje=='N') {	//$_SESSION['osoba_os']=='XP'
fputs($file,'<meta http-equiv="Content-type" content="text/html; charset=iso-8859-2">'."\n");
fputs($file,'<meta http-equiv="Reply-to" content="AMoch@pro.onet.pl">'."\n");
fputs($file,'<meta name="Author" content="Arkadiusz Moch">'."\n");
}
fputs($file,'<title>Lemur'."\n");
if ($osu) {
	fputs($file,': ');
	fputs($file,$osu);
	fputs($file,' (Nr ');
	fputs($file,$ido);
	fputs($file,', punkt kasowy Nr ');
	fputs($file,$punkt);
	fputs($file,')');
}
fputs($file,'</title>'."\n");

fputs($file,'<script type="text/javascript" src="'."https://{$_SERVER['HTTP_HOST']}/Lemur2/".'js/jquery-1.10.2.min.js"></script>'."\n");

fputs($file,'<script type="text/javascript" language="JavaScript">'."\n");
fputs($file,'<!--'."\n");

fputs($file,'$(document).keydown(function(e) {'."\n");
fputs($file,'   $key=e.keyCode;'."\n");
fputs($file,'   if ($key==13||$key==27) {'."\n");
   	if (@$_GET['sio']=='tak') {
         fputs($file,'close();'."\n");
      } elseif ($_GET['natab']) {
         fputs($file,'location.href="..";');	//Tabela.php?tabela='.$_GET['natab'].'";'."\n"
      } else {
         fputs($file,'location.href="..";');	//Tabela.php?tabela='.$_POST['natab'].'";'."\n"
      }
fputs($file,'      return false;'."\n");
fputs($file,'   }'."\n");
fputs($file,'   return true;'."\n");
fputs($file,'});'."\n");

fputs($file,'-->'."\n");
fputs($file,'</script>'."\n");

fputs($file,'<STYLE TYPE="text/css">'."\n");
fputs($file,'     P.breakhere {page-break-before: always}'."\n");
fputs($file,'</STYLE>  '."\n");

fputs($file,'</head>'."\n");

fputs($file,'<body bgcolor="#FFFFFF" onload="');
//echo '<body bgcolor="#FFFFFF" onload="';
//if (($ido==4)||($ido==6)||($ido==7)) {	//Agata, Andrzej, Beata maja ig³ówki
if ($spacje=='N') {	//$_SESSION['osoba_os']=='XP'
	fputs($file,'window.print()');
//	echo 'window.print()';
} else {
	fputs($file,"document.execCommand('SaveAs','','C:\\\Wydruki\\\Wydruk.htm')");
//	echo "document.execCommand('SaveAs','','C:\\\Wydruki\\\Wydruk.htm')";
}
fputs($file,'">'."\n");
//echo '">';

fputs($file,'<table width="2100">'."\n");

$blokn='';		//nag³ówek
$bloks='';		//stopka
$blokstr=1;		//strona
$blokbreak=false;	//page break

$z="Select NAZWA, FORMAT, TEKST from wzoryumows where ID_WZORYUMOW=$z order by ID";
$wynik=mysqli_query($linkLemur,$z);
while ($wiersz=mysqli_fetch_array($wynik)) {
	$n=StripSlashes($wiersz['NAZWA']);
	$f=StripSlashes($wiersz['FORMAT']);
	$z=StripSlashes($wiersz['TEKST']);
	$z=str_replace('ID_master',$ipole,$z);
	$z=($z=='osoba_upr'?$z:str_replace('osoba_upr',$osu,$z));
	$z=str_replace('osoba_id',$ido,$z);
	$z=str_replace('osoba_pu',$punkt,$z);
	$z=str_replace('zaznaczone',@$_POST['zaznaczone'],$z);
	$naglow=($f=='n');
	$stopka=($f=='s');
	if ($f=='+'||$naglow||$stopka) {	//subtabela, np.: specyfikacja, nag³ówek, stopka
		$lps=0;				//l.p. w subtabeli
		$lps2=0;			//l.p. w subsubtabeli
		$bloklp=0;			//l.p. w ramach bloku
		if (trim($z)=='') {	//nie by³o ¿adnych zapytañ, wiêc jeden wiersz (pewnie nag³ówek lub stopka)
			$lpsmax=1;
		} else {
			require('WydrukWzorSeria.php');
			if (count($qs)>1) {	//wiêcej pól wyniku, to znaczy, ¿e s¹ tam pola dla specyfikacji w formacie [1], [2], itd.
				$lpsmax=-1;	//i nie wiadomo ile bêdzie wierszy
				$blok0=$qs[0];	//wartoœæ poprzedniego wiersza w ramach bloku
				$blok1=$qs[0];	//wartoœæ bie¿¹cego wiersza w ramach bloku
			} else {		//tylko jedno pole wyniku, to znaczy, ¿e 
				$lpsmax=$qs[0];	//wynik ostatniego zapytania to iloœæ wierszy do obróbki
			}
		}	//if (trim($z)!='')

		$fvs=$n;	//s³owo: FVspec

	   while ($lpsmax==-1 ? (1==1) : ($lps<$lpsmax)) {
		$zs="Select TEKST, ID from wzoryumow where NAZWA='$fvs'";	// tekst FVspec
		$ws=mysqli_query($linkLemur,$zs);
		$ws=mysqli_fetch_row($ws);
		$zs=$ws[1];			//ID definicji FVspec
		$ws=StripSlashes($ws[0]);	//linia z tekstami do zamiany

		if (count(explode('[lp]',$ws))>0) {	//jeœli '[lp]' jest ju¿ w tekœcie g³ównym specyfikacji
			$ws=str_replace('[lp]',$lps+1,$ws);
		}

		if ($lpsmax<0) {		//wiêcej pól wyniku, to znaczy, ¿e s¹ tam pola dla specyfikacji w formacie [1], [2], itd.
			for ($j=0;$j<count($qs);$j++) {		//korzysta z wyników zapytania g³ównego specyfikacji
				$ws=str_replace('['.$j.']',$qs[$j],$ws);
			}
			$blok1=$qs[0];
			if ($blok0!=$blok1&&!$blokbreak) {	//zmieni³ siê numer bloku i nie ³ama³ strony ledwo co
				$bloklp=0;			//liczymy od nowa
				$blokstr++;			//next strona dla nowego bloku
				$ws=str_replace('[str]',$blokstr-1,$bloks).'<P CLASS="breakhere">'.str_replace('[str]',$blokstr,$blokn).$ws;
			}
			$blok0=$qs[0];
			if (count(explode('[bloklp]',$ws))>0) {//jeœli '[bloklp]' jest ju¿ w tekœcie g³ównym specyfikacji
				$ws=str_replace('[bloklp]',$bloklp+1,$ws);
			}
		}

		$blokbreak=false;

		$zs="Select NAZWA, FORMAT, TEKST from wzoryumows where ID_WZORYUMOW=$zs";
		$wyniks=mysqli_query($linkLemur,$zs);			//definicje zamian
		while ($wierszs=mysqli_fetch_array($wyniks)) {	//lecimy po polach do zmiany
			$n=StripSlashes($wierszs['NAZWA']);
			$f=StripSlashes($wierszs['FORMAT']);
			$z=StripSlashes($wierszs['TEKST']);
			if ($f=='+') {		//subraport2
				require('WydrukWzorSeria.php');
				$fvs2=$n;	//s³owo: FakturaPS1Spec
				$lps2=0;
				$lps2max=$qs[0];//iloœæ wierszy do obróbki
				while ($lps2<$lps2max) {
					$zs="Select TEKST, ID from wzoryumow where NAZWA='$fvs2'";// tekst FakturaPS1Spec
					$ws2=mysqli_query($linkLemur,$zs); $ws2=mysqli_fetch_row($ws2);
					$zs=$ws2[1];			//ID definicji FVspec
					$ws2=StripSlashes($ws2[0]);	//linia z tekstami do zamiany
					$zs="Select NAZWA, FORMAT, TEKST from wzoryumows where ID_WZORYUMOW=$zs";
					$wyniks2=mysqli_query($linkLemur,$zs);			//definicje zamian
					while ($wierszs2=mysqli_fetch_array($wyniks2)) {	//lecimy po polach do zmiany
						$n=StripSlashes($wierszs2['NAZWA']);
						$f=StripSlashes($wierszs2['FORMAT']);
						$z=StripSlashes($wierszs2['TEKST']);
						$wr=$ws2; require('WydrukWzorSeria.php'); $ws2=$wr;
					}
					$ws=str_replace($fvs2,$ws2.(($spacje=='N')?'':'<br>').$fvs2,$ws);	//kontynuacja FakturaPS1Spec
					$lps2++;
				}
				$ws=str_replace($fvs2,'',$ws);		//koniec FVspec
			} else {
				$wr=$ws; require('WydrukWzorSeria.php'); $ws=$wr;
			}
		}

		$bloklp++;					// nastêpny wiersz
		$lps++;						// nastêpny wiersz

		if ($blokmax<>0 && $bloklp%$blokmax==0) {
			$blokstr++;
			$blokbreak=true;	//page break przy zmianie strony
		}

		if ($lpsmax<0) {		//wiêcej pól wyniku, to znaczy, ¿e s¹ tam pola dla specyfikacji w formacie [1], [2], itd.
			if ($qs=mysqli_fetch_row($qqs)) {
				if ($blokbreak) {
					$ws=$ws.str_replace('[str]',$blokstr-1,$bloks).'<P CLASS="breakhere">'.str_replace('[str]',$blokstr,$blokn);
				}
				if ($blokmax<>0) {	$w=str_replace($fvs,$ws.$fvs,$w);	//kontynuacja FVspec
				} else {		$w=str_replace($fvs,$ws.'<br>'.$fvs,$w);//kontynuacja FVspec
				}
//echo '<br>';
			} else {
				$ws=$ws.str_replace('[str]',$blokstr,$bloks);	//stopka z prawdziwym numerem ostatniej strony
				$w=str_replace($fvs,$ws,$w);		//koniec FVspec
				$lpsmax=-2;
			}
		} elseif ($lps<$lpsmax) {
			$w=str_replace($fvs,$ws.(($spacje=='N')?'':'<br>').$fvs,$w);	//kontynuacja FVspec
		} else {
			if (!$stopka) {					//jak nie stopka (ona ma numer 1)
				$w=str_replace($fvs,$ws.$fvs,$w);	//kontynuacja FVspec
			}
		}
	   }	//while ($lpsmax==-1 ? (1==1) : ($lps<$lpsmax))
	   $w=str_replace($fvs,'',$w);		//koniec FVspec
	   $w=str_replace('[str]',$blokstr,$w);	//numer strony na pierwszej stronie
	   if ($naglow) {$blokn=$ws;}		//mamy nag³ówek
	   if ($stopka) {$bloks=$ws;}		//mamy stopkê
	}	//if ($f=='+')
	else {
		$wr=$w;require('WydrukWzorSeria.php');$w=$wr;
	}
}

if ($spacje!='N') {$w=str_replace(' ','&nbsp;',$w);$w=nl2br($w);}

$w=str_replace('^','&nbsp;',$w);

fputs($file,'<font style="font-family: Courier">'."\n");
//     echo '<font style="font-family: Courier">';
fputs($file,$w."\n");
//echo      $w;
fputs($file,'</font>'."\n");
//     echo '</font>';

//require('dbdisconnect.inc');

fputs($file,'</table>'."\n");
fputs($file,'</body>'."\n");
fputs($file,'</html>'."\n");

fclose($file);

include($fname);

?>
