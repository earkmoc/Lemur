<?php

//die(print_r($_GET));

error_reporting(E_ERROR | E_PARSE | E_WARNING);//E_NOTICE | 

session_start();
$_SESSION['osoba_id']=($_SESSION['osoba_id']?$_SESSION['osoba_id']:0);

$sumyw=array();
$sumys=array();

?>

<html>
<head>
<meta http-equiv="Content-type" content="text/html; charset=iso-8859-2">
<meta http-equiv="Reply-to" content="AMoch@pro.onet.pl">
<meta name="Author" content="Arkadiusz Moch">
<title>
<?php
if ($_SESSION['osoba_upr']) {
	echo ': ';
	echo $_SESSION['osoba_upr'];
	$osoba_gr=$_SESSION['osoba_gr'];
	$osoba_pu=$_SESSION['osoba_pu'];
//echo ' (';
//echo $_SESSION['osoba_id'];
//echo ')';
}
?>
</title>

<!-- jQuery -->
<script type="text/javascript" src="<?php echo "http://{$_SERVER['HTTP_HOST']}/Lemur2/";?>js/jquery-1.10.2.min.js"></script>

<style type="text/css">
<!--

@media print  {.breakhere {page-break-before: always; margin: 0 0 0 0; font-size: 1px;}}	
@media print  {.bez {display: none;}}
@media screen {.bez {display: none;}}
.bialy {color: white; background-color: white; font-size: 1px;}
.nag {font: bold <?php echo (@$_POST['wielkosc']?$_POST['wielkosc']:'10');?>pt <?php echo (@$_POST['czcionka']?$_POST['czcionka']:'times');?>;}
.nor {font: normal <?php echo (@$_POST['wielkosc']?$_POST['wielkosc']:'10');?>pt <?php echo (@$_POST['czcionka']?$_POST['czcionka']:'times');?>;}
.zaz {font-size: 22pt; background-color: red;}

#f0 {POSITION: absolute; VISIBILITY: hidden; TOP:0px; LEFT: 0px; Z-INDEX:1;}
#f1 {POSITION: absolute; VISIBILITY: hidden; TOP:0px; LEFT: 10px; Z-INDEX:2;}
#glowka2 {POSITION: absolute; VISIBILITY: visible; TOP:10px; right: 10px; Z-INDEX:3;}
#glowka3 {POSITION: absolute; VISIBILITY: visible; TOP:80px; right: 10px; Z-INDEX:4;}

<?php														// jeśli to nie Raport, to ukryj mastera
if (!($_GET['wydruk']=='Raport')) {
	echo '#master {POSITION: absolute; VISIBILITY: hidden; TOP:10px; LEFT: 10px; Z-INDEX:5;}';
}
?>

-->
</style>

<script type="text/javascript" language="JavaScript">
<!--
var r, rr, rrr, c, cc, str, tnag, cnag, twie, cwie;

<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
$sqlaa=$baza;

if ($_GET['natab']) {								//druk z tabeli obcej (powyższej)
	$_POST['natab']=$_GET['natab'];
	$_POST['batab']=($_GET['batab']?$_GET['batab']:$_GET['natab']);
	//$_POST['batab']=$_GET['batab'];
	$_POST['sutabmid']='';
	$_POST['cpole']=2;
	$_POST['rrpole']=1;
	$_POST['rrrpole']=21;

	$z="Select ID from tabele where NAZWA='";
	$z.=$_POST['batab'];
	$z.="'";
	$w=mysqli_query($linkLemur,$z);
	$w=mysqli_fetch_row($w);
	$_POST['idtab']=$w[0];							//mamy ID obcej

	$z='Select ID_POZYCJI from tabeles where ID_OSOBY=';
	$z.=$_SESSION['osoba_id'];
	$z.=' and ID_TABELE=';
	$z.=$_POST['idtab'];

	$w=mysqli_query($link,$z);
	$w=mysqli_fetch_row($w);
	$_POST['ipole']=$w[0];							//mamy ostatnio użyty ID obcej

}

if ($_POST['idtab']) {
	$z='Select NAZWA from tabele where ID='.($_POST['idtab']); $w=mysqli_query($linkLemur,$z); $w=mysqli_fetch_row($w); $ntab_master=$w[0];
	if (substr($ntab_master,0,9)==='dokumenty') {$_SESSION['ntab_mast']=$ntab_master;};
	if (substr($ntab_master,0,10)==='dokumentFV') {$_SESSION['ntab_mast']=$ntab_master;};
}
if ($_GET['tabela']) {
	$ntab_master=$_GET['tabela'];
	if (substr($ntab_master,0,9)==='dokumenty') {$_SESSION['ntab_mast']=$ntab_master;};
	if (substr($ntab_master,0,10)==='dokumentFV') {$_SESSION['ntab_mast']=$ntab_master;};
	if ($ntab_master==='tab_master') {
		$_GET['tabela']=$_SESSION['ntab_mast'];
		$z="Select ID from tabele where NAZWA='".($_GET['tabela'])."'"; $w=mysqli_query($linkLemur, $z); $w=mysqli_fetch_row($w); $_POST['idtab']=$w[0];
	};
}
$ntab_master=$_SESSION['ntab_mast'];
if (!$ntab_master) {$ntab_master=' ';}

//echo "<!-- ".($_POST['idtab'])." $ntab_master  -->";

echo '$ntab_master="'.$ntab_master.'";';
echo "\n";

//require('Save_Tabela.php');

//********************************************************************
//zmienne PHP i Java Script sterujące dalszym zachowaniem
if ($_POST['sutab']) {                                         // tryb Master/Slave (SubTab=podtabela)
        if ($opole=="S") {                                                                // suwanie się po tej samej tabeli
                $tabela=$_POST['natab'];                        // tabela slave aktywna
                $tabelaa=$_POST['sutab'];                        // tabela master nieaktywna
                $tabelap=$_POST['sutabpol'];                // pole łącznik do tabeli slave
                $tabelai=$_POST['sutabmid'];                 // identyfikator pozycji w master
        }
        else {
                $tabela=$_POST['sutab'];                        // tabela slave aktywna
                $tabelaa=$_POST['natab'];                        // tabela master nieaktywna
                $tabelap=$_POST['sutabpol'];                // pole łącznik do tabeli slave
                $tabelai=$_POST['ipole'];                         // identyfikator pozycji w master
        }
} else {
	$tabela=$_GET['tabela'];
	if (!$tabela) {$tabela=$_POST['natab'];};
	if (!$tabela) {$tabela='tabele';};
}
if (!$tabela) {                // brak podanej tabeli
        $tabela='tabele'; // => ląduj w tabeli głównej
        $tabelaa="";                // tabela master nieaktywna
        $tabelap="";                // pole łącznik do tabeli slave
        $tabelai="";                 // identyfikator pozycji w master
};

//if (!$_SESSION['osoba_upr']) {$tabela='osoby';}; // niezalogowany ląduje w osoby

//********************************************************************
// może tryb Master/Slave jest określony w definicji tabeli ?

if ($opole!="S") {                                        // nie suwanie się
//$tabela może być liczbą ID tabeli lub nazwą tabeli
$z=ord(substr($tabela,0,1));
if (48<=$z && $z<=57) {
        $z="select * from tabele where ID='";
        $z.=$tabela;
        $z.="'";
}
else {
	if (count($w=explode(",",$tabela))>1) {	// jest przecinek
		$tabela=$w[0];
	}
        $z="select * from tabele where NAZWA='";                // WYKAZYSPE
        $z.=$tabela;
        $z.="'";
}
$w=mysqli_query($linkLemur, $z);
if ($w){
        $w=mysqli_fetch_array($w);
        $sql=StripSlashes($w['TABELA']);
        if (!$sql) { exit;}
        else {
                $w=explode("\n",$sql);
                $z=trim($w[0]);
                if (count($w=explode(",",$z))>1) {  // jest przecinek
                        $tabela=$w[0];              // tabela slave aktywna
                        $tabelaa=$w[1];             // tabela master nieaktywna
			if (substr($tabelaa,0,10)=='tab_master') {$tabelaa=$ntab_master;}
                        $tabelap=trim($w[2]);       // pole łącznik do tabeli slave
                        $tabelai='';                // ID pozycji w Master za chwilę ...
                  }
        }
}
}
// może tryb Master/Slave jest określony w definicji tabeli ?
//********************************************************************

echo '$tabela="'.$tabela.'";';
echo "\n";

$tnag='"#FFFFFF"';              //'"#FFCC33"';
echo '$tnag='.$tnag.';';
echo "\n";

$cnag='"#FFFFFF"';                                        //'"#FF6600"';
echo '$cnag='.$cnag.';';
echo "\n";

$twie='"#FFFFFF"';                                        //'"#FFFFCC"';
echo '$twie='.$twie.';';
echo "\n";

$cwie='"#FFFFFF"';                                        //'"#FFCC66"';
echo '$cwie='.$cwie.';';
echo "\n";

//zmienne Java Script
//********************************************************************

if ($tabelaa) {
//********************************************************************
// wariant z tabelą MASTER (nieaktywną)

$zprequery=0;
$prequery=array();
$tna=array();
$mca=$cca;
$ca=1;

$z=ord(substr($tabelaa,0,1));
if (48<=$z && $z<=57) {
        $z="select * from tabele where ID='";
        $z.=$tabelaa;
        $z.="'";
}
else {
        $z="select * from tabele where NAZWA='";
        $z.=$tabelaa;
        $z.="'";
}
$sqlaa.=$z;
$wa=mysqli_query($linkLemur, $z);
if ($wa){
        $wa=mysqli_fetch_array($wa);
        $sqlaa.=($idtaba=$wa['ID']);
        $tabelaa=StripSlashes($wa['NAZWA']);
        echo '$tabelaa="'.($wa['NAZWA']).'";';
        echo "\n";

        $tyta=StripSlashes($wa['OPIS']);
        $sqla=StripSlashes($wa['TABELA']);
        $funa=StripSlashes($wa['FUNKCJE']);
        if (!$sqla) { exit;}
        else {
                $mca=0;
                $wa=explode("\n",$sqla);
                $sqla='';

                if (count($bazaa=explode(",",$wa[0]))>1) {        // jest przecinek
	             if (count($bazaa=explode(",",$wa[0]))>3) {   // są nawet 3: abonenciG,grupy,[1].[2],abonenci
	                $bazaa=trim($bazaa[3]);
		     }
		     else {
                      $bazaa=$bazaa[0];
		     }
                }
                else {
                        $bazaa=trim($wa[0]);
                }
                $z='Select';
                $cca=Count($wa);
                for($i=1;$i<$cca;$i++) {
			               $wa[$i]=trim($wa[$i]);
                        if     (!$wa[$i]) {;}
                        elseif (substr($wa[$i],0,4)=='from')  {$z.=' '.$wa[$i];}
                        elseif (substr($wa[$i],0,9)=='left join') {$z.=' '.$wa[$i];}
                        elseif (substr($wa[$i],0,5)=='where') {$zwhere=' '.$wa[$i];}
                        elseif (substr($wa[$i],0,5)=='group') {$zgroup=' '.$wa[$i];}
                        elseif (substr($wa[$i],0,6)=='having') {$zhaving=' '.$wa[$i];}
                        elseif (substr($wa[$i],0,5)=='order') {$zorder=' '.$wa[$i];}
                        elseif (substr($wa[$i],0,8)=='prequery'){$prequery[$zprequery]=substr($wa[$i],9);$zprequery++;}
                        else {
                                if($i==1) {$z.=' ';} else {$z.=',';};
                                $la=explode("|",$wa[$i]);
                                if (!($bazaa=='Select')&&(count(explode(".",$la[0]))<2)&&(count(explode("(",$la[0]))<2)) {
                                        $z.=$bazaa;
                                        $z.=".";
                                }
                                $z.=$la[0];
                                if(!$la[1]) {$tna[$i-1]=trim($la[0]);} else {$tna[$i-1]=trim($la[1]);};
                                $szera[$mca]=$la[2];                //szerokość
                                if (substr($szera[$mca],0,1)=='+') {$ca=$mca+1;};
                                $styla[$mca]=$la[3];                //style="font-size: 70pt; color: red; font-weight: normal"
                                $styna[$mca]=$la[4];                //font-family: serif; font-size: 18pt; text-align: center
                                $mca++;
                        }
                }
                $cca=$mca;
        }
}
if (!$tabelai) {                                                        // nie ma ID pozycji w Master
        $za='Select ID, ID_POZYCJI from tabeles where ID_OSOBY=';
        $za.=$_SESSION['osoba_id'];
        $za.=' and ID_TABELE=';
        $za.=$idtaba;
		$sqlaa.=$za;
        $wa=mysqli_query($link, $za);
        $wa=mysqli_fetch_array($wa);
        $sqlaa.=", tabelai=".($tabelai=$wa['ID_POZYCJI']);                                          // ID pozycji w Master
}
if ($zgroup) {
        $z.=' '.$zgroup;                 // "group by" zamiast "where"
        if ($zhaving) {                // "having" za "group by"
                $z.="$zhaving";
                if (substr($tabelap,0,1)=='[') {        // odwołanie do pól mastera
                        $tr=explode('.',$tabelap);                // [1],[2]
                        for($i=0;$i<count($tr);$i++) {
                                $j=substr($tr[$i],1)*1;	//może mieć 2 cyfry i więcej
                                $z=str_replace($tr[$i],$tra[$j],$z);
                        }
                }
                else {$z.=" and $bazaa.ID=$tabelai";};
        }
        else {                                          // nie ma "having", więc ma być
                $z.=" having $bazaa.ID=$tabelai";
        }
}
else {
        if ($zwhere) {                                                                                // jest "where"
                if (substr($tabelap,0,1)=='[') {        // odwołanie do pól mastera
                	$z.=" where $bazaa.ID=$tabelai";	//master nie odwołuje się do mastera tylko polega na ID
                }
                else {$z.="$zwhere and $bazaa.ID=$tabelai";};
        }
        else {
                $z.=" where $bazaa.ID=$tabelai";                 // nie ma "where"
        }
}
if ($zorder) {$z.=' '.$zorder;}                                  // "order by" za "where"
$z.=' limit 1';
$z=str_replace('ID_master',$tabelai,$z);
$z=str_replace('osoba_id',$_SESSION['osoba_id'],$z);
$sqla=$z.';';
if (1==2&&$zprequery) {
	for($k=0;$k<count($prequery);$k++) {
		$prequery[$k]=str_replace('ID_master',$tabelai,$prequery[$k]);
		$prequery[$k]=str_replace('osoba_id',$_SESSION['osoba_id'],$prequery[$k]);
		$sql.='   '.$prequery[$k].';';
		if (substr($prequery[$k],0,1)=='?') {
			$prequery[$k]=substr($prequery[$k],1);
			$wa=mysqli_query($link, $prequery[$k]);
			$wa=mysqli_fetch_row($wa);
			$sql.='   '.$wa[0].';';
			if ($wa[0]) {$k=count($prequery);};	//finito prequerys
		}
		else {
			$wa=mysqli_query($link, $prequery[$k]);
		}
	}
}
$wa=mysqli_query($link, $z);
$na=mysqli_num_rows($wa);
$tra=mysqli_fetch_row($wa);
for($j=0;$j<Count($tra);$j++) {$tra[$j]=StripSlashes($tra[$j]);}

// wariant z tabelą MASTER (nieaktywną)
//********************************************************************
}

//********************************************************************
// tabela Slave (aktywna)

$zwhere="";                // zerowanie zmiennych, które za chwilę znów będą użyte
$zorder="";
$zgroup="";
$zhaving="";
$zunion=0;
$uniony=array();
$zprequery=0;
$prequery=array();
$pola=array();
$tn=array();
$sumy=array();
$sumyp=array();
$sumyok=false;
$grupi=0;	//indeks kolumny grupowanej
$grupw='';	//wartość z kolumny grupowanej
$grupt=array();	//tablica np. stawek VAT
$grupy=array();	//sumy poszczególnych stawek
$grupa=array();	//kwoty z danego wiersza
$grupyok=false;
$mc=$cc;
$sql='';

//$tabela może być liczbą ID tabeli lub nazwą tabeli
$z=ord(substr($tabela,0,1));
if (48<=$z && $z<=57) {
        $z="select * from tabele where ID='";
        $z.=$tabela;
        $z.="'";
}
else {
        $z="select * from tabele where NAZWA='";
        $z.=$tabela;
        $z.="'";
}
$w=mysqli_query($linkLemur, $z);
if (!$w) {
	echo "Nie wyszlo: $z\r";
	exit;}
else {
        $w=mysqli_fetch_array($w);
        $idtab=$w['ID'];
        echo '$idtab='.$idtab.';';
        echo "\n";

        $tabela=$w['NAZWA'];
        echo '$tabela="'.($w['NAZWA']).'";';
        echo "\n";

        $tyt=StripSlashes($w['OPIS']);
        $sql=StripSlashes($w['TABELA']);
        $fun=StripSlashes($w['FUNKCJE']);
//wydruk nie ma ogranicznika na ilość wierszy na stronie
        $rr=99999999;
//        $rr=$w['MAXROWS'];
//        if ($rr==0) {$rr=20;}
        $rrr=$rr;

        $z='Select NR_STR, NR_ROW, NR_COL, WARUNKI, SORTOWANIE from tabeles where ID_OSOBY=';
        $z.=$_SESSION['osoba_id'];
        $z.=' and ID_TABELE=';
        $z.=$idtab;
        $ww=mysqli_query($link, $z);
        if ($ww and mysqli_num_rows($ww)>0) {
			$ww=mysqli_fetch_array($ww);
			$warunek=StripSlashes($ww['WARUNKI']).($mandatory?($ww['WARUNKI']?" and ":'')."($mandatory)":'');
			$sortowanie=StripSlashes($ww['SORTOWANIE']);
			$r=$ww['NR_ROW'];
			$str=$ww['NR_STR'];
			$c=$ww['NR_COL'];
        };

        if (!$r) {$r=1;};

        $str=1;
        if (!$str) {$str=1;};
        if ($_POST['opole']=="S") {
                $str=$_POST['strpole'];
                if ($str>0) {$r=1;};        //jak dodaje strony, to najpierw staje na pierwszym wierszu
        }
        else {
                if ($tabelaa) {                // po wejściu do Slave w trybie Maste/Slave stoi na szczycie
//                        $r=1;
                        $str=1;
                }
        };
        if ($str<0) {$str=-$str; $r=$rr;};        //jak cofa strony, to najpierw staje na ostatnim wierszu
        echo '$str='.$str.';';
        echo "\n";

        if ($rr<$r) {$r=$rr;};

        echo '$r='.$r.';';
        echo "\n";

        echo '$rr='.$rr.';';
        echo "\n";

        echo '$rrr='.$rrr.';';
        echo "\n";

        $cc=11;

        if (!$c) {$c=2;};
        if (!$sql) { exit;}
        else {
                $mc=0;
                $w=explode("\n",$sql);
                $z='Select';

                if (count($baza=explode(",",$w[0]))>1) {        // jest przecinek
	             if (count($baza=explode(",",$w[0]))>3) {   // są nawet 3: abonenciG,grupy,[1].[2],abonenci
                        $baza=trim($baza[3]);
		     }
		     else {
                        $baza=$baza[0];
		     }
                }
                else {
                        $baza=trim($w[0]);
                }
                echo '$baza="'.$baza.'";';
                echo "\n";

                $cc=Count($w);
                for($i=1;$i<$cc;$i++) {
			               $w[$i]=trim($w[$i]);
                        if     (!$w[$i]) {;}
                        elseif (substr($w[$i],0,4)=='from')   {   $z.=' '.$w[$i];}
                        elseif (substr($w[$i],0,9)=='left join') {$z.=' '.$w[$i];}
                        elseif (substr($w[$i],0,5)=='where')  { $zwhere=' '.$w[$i];}
                        elseif (substr($w[$i],0,5)=='order')  { $zorder=' '.$w[$i];}
                        elseif (substr($w[$i],0,5)=='group')  { $zgroup=' '.$w[$i];}
                        elseif (substr($w[$i],0,5)=='union')  { $uniony[$zunion]=$w[$i];$zunion++;}
                        elseif (substr($w[$i],0,8)=='prequery'){$prequery[$zprequery]=substr($w[$i],9);$zprequery++;}
                        elseif (substr($w[$i],0,6)=='having') {$zhaving=' '.$w[$i];}
                        else {
                                if($i==1) {$z.=' ';} else {$z.=',';};
                                $l=explode("|",$w[$i]);
                                if (!($baza=='Select')&&(count(explode(".",$l[0]))<2)&&(count(explode("(",$l[0]))<2)) {
                                        $z.=$baza;
                                        $z.=".";
                                }
                                $z.=$l[0];
				$pola[$i-1]=$l[0];
                                if(!$l[1]) {
					$tn[$i-1]=trim($l[0]);
				}
				else {
					$tn[$i-1]=trim($l[1]);
					if (count(explode("[",$tn[$i-1]))>1) {	//są jakieś odwołania w nazwie kolumny
						$zz=explode('.',$tabelap);	//[1].[2]
						for($ii=0;$ii<count($zz);$ii++) {
							$jj=substr($zz[$ii],1)*1;
							$tn[$i-1]=str_replace($zz[$ii],$tra[$jj],$tn[$i-1]);
						}
					}
				}
                                $szer[$mc]=$l[2];                //szerokość
                                if (substr($szer[$mc],0,1)=='+') {$c=$mc+1;};
                                $sumy[$mc]='';
                                if (strpos($szer[$mc],'+')>0) {        //"+" z prawej
                                        $sumy[$mc]='0';
                                        $sumyok=true;
                                };
                                if (substr($szer[$mc],-1,1)=='*') {        //"*" z prawej
                                        $grupa[$mc]='0';
                                        $grupyok=true;
                                };
                                $styl[$mc]=$l[3];                //style="font-size: 70pt; color: red; font-weight: normal"
                                $styn[$mc]=$l[4];                //font-family: serif; font-size: 18pt; text-align: center
                                $mc++;
                        }
                }
                $cc=$mc;
//                $sql=$z.';';
        }
}

if ($tabelaa) {                                // tryb Master/Slave
        if ($zgroup) {
                $z.=' '.$zgroup;                 // "group by" zamiast "where"
                if ($zhaving) {                // "having" za "group by"
                        $z.="$zhaving";
                        if (substr($tabelap,0,1)=='[') {        // odwołanie do pól mastera
                                $tr=explode('.',$tabelap);                // [1],[2]
                                for($i=0;$i<count($tr);$i++) {
					$j=substr($tr[$i],1)*1;
					$z=str_replace($tr[$i],$tra[$j],$z);
                                }
                        }
                        else {$z.=" and ($baza.$tabelap=$tabelai)";};
                }
                else {                                          // nie ma "having", więc ma być
//                        $z.=" having $baza.$tabelap=$tabelai";
                }
			if ($warunek) {
				$warunek="($warunek)";
				if ($zhaving) {$z.=" and $warunek";} else {$z.=" having $warunek";}
			};
			if ($sortowanie) {
				$z.=" order by $sortowanie";
				$zorder='';
			};
        }
        else {
                if ($zwhere) {                        // jest "where", więc "and"
                        $z.="$zwhere";
						$sqla.=$tabelap;
                        if (substr($tabelap,0,1)=='[') {        // odwołanie do pól mastera
                                $tr=explode('.',$tabelap);                // [1],[2]
                                for($i=0;$i<count($tr);$i++) {
					$j=substr($tr[$i],1)*1;
					$z=str_replace($tr[$i],$tra[$j],$z);
                                }
                        }
                        else {$z.=" and ($baza.$tabelap=$tabelai)";};
			if ($warunek) {
				$warunek="($warunek)";
				$z.=" and $warunek";
			}
			if ($sortowanie) {
				$z.=" order by $sortowanie";
				$zorder='';
			};
                }
                else {                                          // nie ma "where", więc ma być
			if ($warunek) {
				$warunek="($warunek)";
				$z.=" where ($baza.$tabelap=$tabelai) and $warunek";
			}
			else {
                	        $z.=" where $baza.$tabelap=$tabelai";
			}
			if ($sortowanie) {
				$z.=" order by $sortowanie";
				$zorder='';
			};
                }
        }
}
else {                                                // tryb Slave
        if ($zgroup) {
                if ($zwhere) {$z.="$zwhere";}
                $z.=' '.$zgroup;                                                                          // "group by" zamiast "where"
                if ($zhaving) {                // "having" za "group by"
	                $z.="$zhaving";
                        if (substr($tabelap,0,1)=='[') {        // odwołanie do pól mastera
                            $tr=explode('.',$tabelap);                // [1].[2]
                            for($i=0;$i<count($tr);$i++) {
                               $j=substr($tr[$i],1)*1;
                               $z=str_replace($tr[$i],$tra[$j],$z);
                            }
                        }
                        elseif ($tabelap) {$z.=" and $baza.$tabelap=$tabelai";};
                }
                else {                                          // nie ma "having", więc ma być
//                        $z.=" ...having $baza.$tabelap=$tabelai";
                }
			if ($warunek) {
				$warunek="($warunek)";
				if ($zhaving) {$z.=" and $warunek";} else {$z.=" having $warunek";}
			};
			if ($sortowanie) {
				$z.=" order by $sortowanie";
				$zorder='';
			};
        }
        else {
                if ($_GET['szukane']) {
                   $zwhere=str_replace('[1]',$_GET['szukane'],$zwhere);
                }
                else {                                        // nic ne szukamy
                   if (count($w=explode("[1]",$zwhere))>1) {  // definicja SQL jest przeznaczona do szukania
                      $zwhere=''; // trzeba zrezygnować z ograniczeń
                      $zorder=''; // trzeba zrezygnować z uporządkowania "po nazwie" na rzecz "po ID", bo po "Dopisz" by się na nim nie ustawiał
                   }
                };
                $z.="$zwhere";                        // trzeba w końcu uwzględnić warunek "where"
					if ($warunek) {
						$warunek="($warunek)";
                if ($zwhere) {$z.=" and $warunek";} else {$z.=" where $warunek";}
					};
					if ($sortowanie) {
						$z.=" order by $sortowanie";
						$zorder='';
					};
        }
}
if ($zorder) {$z.=' '.$zorder;}                // "order by" za "where"
elseif (!$sortowanie) {$z.=" order by $baza.ID";}	// "order by" obowiązkowy gdy niesprecyzowany
if ($zunion) {
	$z='('.$z.')';
	for($i=0;$i<$zunion;$i++) {
		$z.=' '.$uniony[$i];
	}
}
if (substr($tabelap,0,1)=='[') {        // odwołanie do pól mastera
	$sql.="...$tabelap...";
	$tr=explode('.',$tabelap);                // [1].[2]
	for($i=0;$i<count($tr);$i++) {
		$j=substr($tr[$i],1)*1;				// 1 lub 2, a nawet 25 i większe
		$z=str_replace($tr[$i],$tra[$j],$z);
		if ($zprequery) {
			for($k=0;$k<count($prequery);$k++) {
				$prequery[$k]=str_replace($tr[$i],$tra[$j],$prequery[$k]);
			}
		}
	}
}
$z.=" limit ";                                                                // "limit" na końcu
$z.=sprintf("%d",($str-1)*$rr).",";
$z.=sprintf("%d",$rr);

$z=str_replace('$osoba_gr',$osoba_gr,$z);  // wrażliwość na grupę usera
$z=str_replace('$osoba_pu',$osoba_pu,$z);  // wrażliwość na punkt usera
$z=str_replace('osoba_id',$_SESSION['osoba_id'],$z);  // wrażliwość na ID usera

$sql=$z.';';
if ($zprequery) {
	for($k=0;$k<count($prequery);$k++) {
		$prequery[$k]=str_replace('ID_master',$tabelai,$prequery[$k]);
		$prequery[$k]=str_replace('osoba_id',$_SESSION['osoba_id'],$prequery[$k]);
		$sql.='   '.$prequery[$k].';';
		if (substr($prequery[$k],0,1)=='?') {
			$prequery[$k]=substr($prequery[$k],1);
			$w=mysqli_query($link, $prequery[$k]);
			$w=mysqli_fetch_row($w);
			$sql.='   '.$w[0].';';
			if ($w[0]) {$k=count($prequery);};	//finito prequerys
		}
		else {
			$w=mysqli_query($link, $prequery[$k]);
		}
	}
}
$w=mysqli_query($link, $z);
if ($w) {$n=mysqli_num_rows($w);} else {$n=0;};
if (!$n) {
	$r=1;
	echo '$r='.$r.';';
	echo "\n";
}
else {
	if ($n<$r) {
		$r=$n;
		echo '$r='.$r.';';
		echo "\n";
	}
}

// tabela Slave (aktywna)
//********************************************************************

if ($cc<$c) {$c=$cc;};
echo '$c='.$c.';';
echo "\n";

echo '$cc='.$cc.';';
echo "\n";

//********************************************************************
?>

function Odswiez($kierunek){};

$(document).keydown(function(e) {
   $key=e.keyCode;
   if ($key==27) {
		location.href='index.php';      
<?php
/*
        $ok=false;
        if ($fun) 
		{
			echo "location.href='index.php';";
		}
        else {
                $f=explode("\n",$fun);
                $cc=Count($f);
                for($i=0;$i<$cc;$i++) {
                        $l=explode("|",$f[$i]);
                        if ($l[0]=='Esc') {
                                echo $l[2].';';
                                $ok=true;
                        }
                }
        }
*/
?>
      return false;
   }
   if ($key==13) {
      $('#tak').click();
      return false;
   }
   return true;
});

function mysza($x,$y){}
function mysza2($x,$y){}
function tab_czysc(){}
function tab_kolor(){}
function PlikPHP($ko,$h,$pa,$f02){
	f0.phpini.value=$pa;
	f0.action=$ko;
	f0.odswiez.click();
}
function Adres($ko){
        f0.sutab.value="";                                        //czyść, bo to koniec chodzenia po subtabeli slave
if (isNaN($ko)) {                                                        // nazwa tabeli
        f0.natab.value=$ko;
        f0.action="Tabela.php";
        f0.odswiez.click();
}
else { // $ko=1 => numer kolumny zawierającej id tabeli
        f0.natab.value=f0.ipole.value;
        f0.action="Tabela.php";
        f0.odswiez.click();
}}
function Start(){
<?php
	//include($_GET['wydruk']."_p.html");
	require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/Raport_p.php");
?>
};
-->
</script>

</head>

<body bgcolor="#FFFFFF" onload="Start(); print();">

<?php
	//include($_GET['wydruk'].(($_SESSION['osoba_pu']==3)?'a':'')."_n.html");
	require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/Raport_n.php");
?>

<br style="font-size: 12pt">

<?php
echo '<form id="f0" hidden action="Tabela.php?tabela='.$tabela.'" method="post">';echo "\n";
//type="hidden"
?>
<input type="hidden" id="natab" name="natab" value=""/>
<input type="hidden" id="batab" name="batab" value=""/>
<?php
echo '<input id="sutab"    type="hidden" name="sutab"    value="'.$tabelaa.'"/>';echo "\n";
echo '<input id="sutabpol" type="hidden" name="sutabpol" value="'.$tabelap.'"/>';echo "\n";
echo '<input id="sutabmid" type="hidden" name="sutabmid" value="'.$tabelai.'"/>';echo "\n";
?>
<input type="hidden" id="idtab" name="idtab" value=""/>
<input type="hidden" id="ipole" name="ipole" value=""/>
<?php
//echo '<input id="fpole" value=""/>';
?>
<input type="hidden" id="opole" name="opole" value=""/>
<input type="hidden" id="strpole" name="strpole" value=""/>
<input type="hidden" id="rpole" name="rpole" value=""/>
<input type="hidden" id="cpole" name="cpole" value=""/>
<input type="hidden" id="rrpole" name="rrpole" value=""/>
<input type="hidden" id="rrrpole" name="rrrpole" value=""/>
<input type="hidden" id="phpini" name="phpini" value=""/>
<input type="hidden" id="zaznaczone" name="zaznaczone" value=""/>
<input type="hidden" id="offsetX" name="offsetX" value=""/>
<input type="hidden" id="offsetY" name="offsetY" value=""/>
<input type="submit" id="odswiez" value="Anuluj" style="visibility: hidden" onclick="target='_top'"/>
</form>

<form id="f1">
<?php
        if ($fun) {
                $f=explode("\n",$fun);
                $cc=Count($f);
                $ok_esc=false;
                for($i=0;$i<$cc;$i++) {
                        $l=explode("|",$f[$i]);
                        if ($l[0]=="Esc") {
                                $ok_esc=true;
                        }
                }
                if (!$ok_esc) {
                        echo '<input type="button" value="Esc=wyjście" onclick="window.close()"/>';echo "\n";
                }
        }
?>
</form>

<div id="master" hidden>

<?php

$mr=$n;
if ($n==0) {
        if ($r<2&&$str<2) {
                $n=1;
//                echo '<h1 align="center"><br><br><br>BRAK DANYCH<br><br><br></h1>';
        }
        else {
                echo '<h1 align="center"><br>TO JEST OSTATNIA POZYCJA</h1>';
        }
};

$startkol=1;
if ($_GET['wydruk']=='Raport') {
	//$startkol=0;
}

if ($tabelaa) { // tabela master nieaktywna
//        $startkol=2;
        echo '<table align="center" border="1" cellpadding="2" cellspacing="0" bordercolorlight="#C0C0C0" bordercolordark="#808080" title="'.$tyta.'"> '; echo "\n";
        echo '<caption align="left">'.$tyta;
        echo '</caption>';
        echo "\n";
        echo '<tr bordercolor="black">';
        echo "\n";
// wydruk ma nagłówki bez pierwszej kolumny (Nr 0) z ID tabeli
        for($j=1;$j<=$mca-1;$j++) {
                echo '<td ';
                echo 'align="center" CLASS="';
		if (($szera[$j]==='0')||($szera[$j]=='.')) {echo 'bez';} else {echo 'nag';}
		echo '" bgcolor='.$tnag.'>';
		echo StripSlashes($tna[$j]);
                echo '</td>';
                echo "\n";
        }
        echo '</tr>';
        for($i=0;$i<1;$i++){
//                $tra=mysqli_fetch_row($wa);
                echo "\n";
                echo '<tr height=1 bgcolor='.$twie.'>';
                echo "\n";
// wydruk ma nagłówki bez pierwszej kolumny (Nr 0) z ID tabeli
                for($j=1;$j<$mca;$j++){
// wydruk nie tnie treści kolumn tabeli  "nowrap "
                        echo '<td id="taba_'.$i.'_'.$j.'" width='.($szera[$j]*12);
                        echo ' align="center" CLASS="';
			if (($szera[$j]==='0')||($szera[$j]=='.')) {echo 'bez" ';} else {echo 'nor" ';}
			if (!$styla[$j]||$styla[$j]=="\r") {;} else {echo $styla[$j];};
                        echo ' >';
                        if (count($z=explode(":",$szera[$j]))>1) {                        //obrazek
                                if (!$z[0]) echo '<img src="'.$tra[$j].'" alt="" height='.$z[1].'>';
                                if (!$z[1]) echo '<img src="'.$tra[$j].'" alt="" width='.$z[0].' >';
                                if ($z[0]&&$z[1]) echo '<img src="'.$tra[$j].'" alt="" width='.$z[0].' height='.$z[1].'>';
                        }
                        else {                                                                                                                  //tekst

					    $buf=$szera[$j];
	                if (count($z=explode("@Z",$buf))>1) {		// bez zer
								$buf=str_replace('@Z','',$szera[$j]);
								if ($tra[$j]*1==0) {
									$buf='';
									$tra[$j]='';
								}
	                }
                   if (!$buf) {echo $tra[$j];}
                   elseif ($buf==='0') {echo $tra[$j];}
                   elseif ($buf=='.') {echo '.';}
                   elseif (substr($buf,0,1)=='%') {printf($buf,$tra[$j]);}
//                   elseif (strlen($tra[$j])>$buf) {echo substr($tra[$j],0,$buf).'...';}
//                   else {echo substr($tra[$j],0,$buf);};
                   else {echo $tra[$j];}
                        }
                        echo '</td>';
                        echo "\n";
                }
                echo '</tr>';
        }
	echo '</table>';
}
echo '</div>';
echo "\n";
if ($_GET['wydruk']=='Raport') {
	echo '<br style="font-size: 12pt">';
	echo "\n";
}

$strona=1;
$sumyj=0;	//na którym miejscu jest napis Suma:

$strona1=(@$_GET['strona1']?$_GET['strona1']:17);
$stronan=(@$_GET['stronan']?$_GET['stronan']:20);
$tyt=(@$_POST['tytul']?$_POST['tytul']:$tyt);
$borderNag=(@$_POST['borderNag']===null?1:($_POST['borderNag']?1:0));
$borderPol=(@$_POST['borderPol']===null?1:($_POST['borderPol']?1:0));
$lamanie=(@$_POST['lamanie']?$_POST['lamanie']:0);
$zawijanie=(@$_POST['zawijanie']===null?0:($_POST['zawijanie']?1:0));
$osobneStrony=(@$_POST['osobneStrony']===null?0:($_POST['osobneStrony']?1:0));
$tylkoSumy=(@$_POST['tylkoSumy']===null?0:($_POST['tylkoSumy']?1:0));

echo "\n".'<table cellspacing="0" cellpadding="0" rules="none" width="100%" bgcolor="#ffffff" border="0">'."\n";
echo '<tr>'."\n";
echo '	<td align="left"><font style="font-size:12pt">'.$tyt.'</font></td>'."\n";
echo '	<td align="right"><font style="font-size:12pt">Strona Nr '.$strona.'</font></td>'."\n";
echo '</tr>'."\n";
echo '</table>'."\n";

$naglowekTabeli="\n".'<table border="0" width="100%" align="left" id="tab" summary="'.$n.'"  cellpadding="2" cellspacing="0" bordercolorlight="#C0C0C0" bordercolordark="#808080" title="'.$tyt.'"> ';
echo $naglowekTabeli;

$naglowkiKolumn="\n";
if($osobneStrony)
{
	$strona1=1;
	$stronan=1;
	$naglowkiKolumn.= '<tr bordercolor="black">'."\n";
	$naglowkiKolumn.= '<td align="center" CLASS="nag" style="border: 2px solid black" width="50%" nowrap>Opis pola</td>'."\n";
	$naglowkiKolumn.= '<td align="center" CLASS="nag" style="border: 2px solid black">Wartość</td>'."\n";
	$naglowkiKolumn.= '</tr>'."\n";
}
else
{
	$naglowkiKolumn.= '<tr bordercolor="black">';
	if($tn[$startkol]!=='LP')
	{
		$naglowkiKolumn.= "\n";
		$naglowkiKolumn.= '<td align="center" CLASS="nag" style="border: '.$borderNag.'px solid black">LP</td>';	//LP
		$naglowkiKolumn.= "\n";
	}

	// wydruk ma nagłówki bez pierwszej kolumny (Nr 0) z ID tabeli
	for($j=$startkol;$j<=$mc-1;$j++) {
			if ($szer[$j]==='0')    {$naglowkiKolumn.= '<td id="tab_0'.($j+1).'" nowrap class="bez" ';}
			elseif ($szer[$j]=='.') {$naglowkiKolumn.= '<td id="tab_0'.($j+1).'" nowrap class="bez" ';}	//width=0 style="font-size:0"
			elseif(strpos('.'.$szer[$j],'@s')) {$naglowkiKolumn.= '<td id="tab_0'.($j+1).'" nowrap class="bez" ';}	//width=0 style="font-size:0"
			else {                   $naglowkiKolumn.= '<td id="tab_0'.($j+1).'" class="nag" ';}
			$naglowkiKolumn.= ' align="center" style="border: '.$borderNag.'px solid black" ';
	//        if (!$styn[$j]||$styn[$j]=="\r") {;} else {echo $styn[$j];};
			$naglowkiKolumn.= ' bgcolor='.$tnag.'>';
			$naglowkiKolumn.=($szer[$j]=='.'?'.':str_replace('-','-<br>',$tn[$j]));
			//$naglowkiKolumn.=($szer[$j]=='.'?'.':$tn[$j]);
			$naglowkiKolumn.= '</td>';
			$naglowkiKolumn.= "\n";
			if(in_array($j,explode(',',$lamanie)))
			{
				$naglowkiKolumn.= '</tr><tr><td></td>';
			}
	}
	$naglowkiKolumn.= '</tr>';
}

echo $naglowkiKolumn;

if (false&&($mr==0))
{                // brak specyfikacji
   $mr=1;
   for($i=0;$i<1;$i++)
   {
        $tr=mysqli_fetch_row($w);
        echo "\n";
        echo '<tr id="tab_'.($i+1).'" height=1 bgcolor='.$twie.'>';
        echo "\n";
		// wydruk ma nagłówki bez pierwszej kolumny (Nr 0) z ID tabeli
        for($j=$startkol;$j<$mc;$j++)
		{
			// wydruk nie tnie treści kolumn tabeli  "nowrap "
			if ($szer[$j]==='0')    {echo '<td id="tab_'.$i.'_'.$j.'" class="bez" ';}
			elseif ($szer[$j]=='.') {echo '<td id="tab_'.$i.'_'.$j.'" class="bez" ';}
			elseif(strpos('.'.$szer[$j],'@s')) {echo '<td id="tab_'.$i.'_'.$j.'" class="bez" ';}
			else {                   echo '<td id="tab_'.$i.'_'.$j.'" class="nor" width='.($szer[$j]*12);}
			echo ' nowrap align="center" ';
			if (!$styl[$j]||$styl[$j]=="\r") {;} else {echo $styl[$j];};
			echo ' >';
			echo '...';
			echo '</td>';
			echo "\n";
        }
        echo '</tr>';
   }
} 
else 
{
	for($i=0;$i<$mr;$i++)
	{
		$tr=mysqli_fetch_row($w);
		echo "\n";
		if (($strona>1&&(($i-$strona1)%$stronan==0))||($strona==1&&$i==$strona1)) 
		{
			if ($sumyok) 
			{                // wiersz sum
				if ($strona==1) {
					$sumys=$sumy;
				}
				if(!$tylkoSumy&&!$osobneStrony)
				{
					echo "\n";
					echo '<tr bgcolor='.$twie.'>';
					echo "\n";
					if($tn[$startkol]!=='LP')
					{
						echo "<td></td>";	//LP: wszystkie strony prócz ostatniej
						echo "\n";
					}
				}
				$znikniete=0;
				$sumyok=true;
				for($j=$startkol;$j<$mc;$j++)
				{

					if	( ($szer[$j]==='0')
						||($szer[$j]=='.')
						||(strpos('.'.$szer[$j],'@s'))
						)
					{
						$znikniete++;
					}

					//if ($sumyok&&((($strona==1)?$szer[$j+1]:$sumyj==$j||($sumy[$j+1]<>'')))) 
					if ($sumyok&&($sumyj==$j||($sumy[$j+1]<>''))) 
					{
						$sumys[$j]='Suma strony:';
						$sumyok=false;
						$sumyj=$j;
						$zniknieteDoSum=$znikniete;
						if ($strona==1) 
						{
							for($k=$j+1;$k<$mc;$k++)
							{
								if ($sumy[$k]) 
								{
									$sumyw[$k]=$sumy[$k]-$sumys[$k];
								}
							}
						} else 
						{
							for($k=$j+1;$k<$mc;$k++)
							{
								if ($sumy[$k]) 
								{
									$sumys[$k]=$sumy[$k]-$sumyw[$k];
								}
							}
						}
					}

					$szerx[$j]=str_replace('+','',$szer[$j]);
					$szerx[$j]=str_replace('@Z','',$szerx[$j]);
					if (substr($szerx[$j],0,1)=='%') {
						$szerx[$j]=substr($szerx[$j],2);
					}

					$buf=$sumys[$j];
					if ($sumy[$j] && $sumyj<>$j) {$buf=number_format($buf*1,2,'.',',');}

					if(!$tylkoSumy&&($sumyj>0)&&($j>=$sumyj)&&!$osobneStrony)
					{
						echo '<td nowrap ';

						if($j==$sumyj)
						{
							echo 'colspan="'.($j-($tn[$startkol]!=='LP'?0:0)-$zniknieteDoSum).'" ';
						}

						if ($szerx[$j]==='0')    {echo ' class="bez" ';}
						elseif ($szerx[$j]=='.') {echo ' class="bez" ';}
						elseif($szerx[$j]=='@s') {echo ' class="bez" ';}
						else {                   echo ' class="nor" ';}

						if($borderPol)
						{
							if ($sumyj!=$j) 
							{
								echo ' style="border-top: double black;';
								echo '        border-right: '.$borderPol.'px solid black;';
								echo '        border-left: '.$borderPol.'px solid black;';
								echo '        border-bottom: '.$borderPol.'px solid black;';
								echo '"';
							}
						}
						else
						{
							echo ' style="border-top: 1px solid black" width='.($szerx[$j]*12);
						}

						if ($sumyj==$j) {
							echo ' align="right" ';
						} 
						else 
						{
							echo ' align="right" ';
							if (!$styl[$j]||$styl[$j]=="\r") {;} else {echo $styl[$j];};
						}
						
						echo ' >';
						echo $buf;
						//if (!$szerx[$j]) {echo $buf;}
						//elseif (strlen($buf)>$szerx[$j]) {echo substr($buf,0,$szerx[$j]).'...';}
						//elseif (!$buf||$sumyj==$j) {echo substr($buf,0,1*$szerx[$j]);}
						//elseif ($sumyp[$j]>0 && $sumyp[$j]<>2) {printf("%.".($sumyp[$j])."f",$buf);}
						//else {echo $buf;}
						echo '</td>';
						echo "\n";
					}
//łamanie sumy pozycji
			if(in_array($j,explode(',',$lamanie)))
			{
				echo '</tr><tr><td></td>';
			}
				}

				$sumys[$sumyj]='';

				if(!$tylkoSumy&&!$osobneStrony)
				{
					echo '</tr>';
					echo "\n";

					echo '<tr bgcolor='.$twie.'>';
					echo "\n";

					if($tn[$startkol]!=='LP')
					{
						echo "<td></td>";	//LP: wszystkie strony prócz ostatniej
						echo "\n";
					}
				}

				$sumyok=true;
				for($j=$startkol;$j<$mc;$j++)
				{
					if ($sumyok&&($sumyj==$j||($sumy[$j+1]<>''))) 
					{
						$sumyw[$j]='Poprzednie strony:';
						$sumyok=false;
						$sumyj=$j;
					}

					$buf=$sumyw[$j];
					if ($sumy[$j] && $sumyj<>$j) {$buf=number_format($buf*1,2,'.',',');}

					if(!$tylkoSumy&&($sumyj>0)&&($j>=$sumyj)&&!$osobneStrony)
					{
						echo '<td nowrap ';

						if($j==$sumyj)
						{
							echo 'colspan="'.($j-($tn[$startkol]!=='LP'?0:0)-$zniknieteDoSum).'" ';
						}

						if($borderPol)
						{
							if ($sumyj!=$j) 
							{
								echo ' style="border: '.$borderPol.'px solid black;" ';
							}
						}

						$szerx[$j]=str_replace('+','',$szer[$j]);
						$szerx[$j]=str_replace('@Z','',$szerx[$j]);
						if (substr($szerx[$j],0,1)=='%') {$szerx[$j]=substr($szerx[$j],2);}

						if ($szerx[$j]==='0')    {echo ' class="bez" ';}
						elseif ($szerx[$j]=='.') {echo ' class="bez" ';}
						elseif($szerx[$j]=='@s') {echo ' class="bez" ';}
						else {                   echo ' class="nor" ';}
						echo ' width='.($szerx[$j]*12);
						if ($sumyj==$j) {
							echo ' align="right" ';
						} else 
						{
							echo ' align="right" ';
							if (!$styl[$j]||$styl[$j]=="\r") {;} else {echo $styl[$j];};
						}
						echo ' >';
						echo $buf;
						//if (!$szerx[$j]) {echo $buf;}
						//elseif (strlen($buf)>$szerx[$j]) {echo substr($buf,0,$szerx[$j]).'...';}
						//elseif (!$buf||$sumyj==$j) {echo substr($buf,0,1*$szerx[$j]);}
						//elseif ($sumyp[$j]>0 && $sumyp[$j]<>2) {printf("%.".($sumyp[$j])."f",$buf);}
						//else {echo $buf;}
						echo '</td>';
						echo "\n";
					}
					//łamanie końcowej sumy pozycji
					if(in_array($j,explode(',',$lamanie)))
					{
						echo '</tr><tr><td></td>';
					}
				}

				$sumyw[$sumyj]='';

				if(!$tylkoSumy&&!$osobneStrony)
				{
					echo '</tr>';
					echo '<tr bgcolor='.$twie.'>';
					echo "\n";

					if($tn[$startkol]!=='LP')
					{
						echo "<td></td>";	//LP: wszystkie strony prócz ostatniej
						echo "\n";
					}
				}

				$sumyok=true;
				for($j=$startkol;$j<$mc;$j++)
				{
					if ($sumyok&&($sumyj==$j||($sumy[$j+1]<>''))) {
						$sumy[$j]='Razem:';
						$sumyok=false;
						$sumyj=$j;
						$sumyw=$sumy;
					}

					$buf=$sumy[$j];

					if(!$tylkoSumy&&($sumyj>0)&&($j>=$sumyj)&&!$osobneStrony)
					{
						echo '<td nowrap ';

						if($j==$sumyj)
						{
							echo 'colspan="'.($j-($tn[$startkol]!=='LP'?0:0)-$zniknieteDoSum).'" ';
						}

						if($borderPol)
						{
							if ($sumyj!=$j) 
							{
								echo ' style="border: '.$borderPol.'px solid black;" ';
							}
						}

						$szerx[$j]=str_replace('+','',$szer[$j]);
						$szerx[$j]=str_replace('@Z','',$szerx[$j]);
						if (substr($szerx[$j],0,1)=='%') {$szerx[$j]=substr($szerx[$j],2);}

						if ($szerx[$j]==='0')    {echo ' class="bez" ';}
						elseif ($szerx[$j]=='.') {echo ' class="bez" ';}
						elseif($szerx[$j]=='@s') {echo ' class="bez" ';}
						else {                   echo ' class="nor" ';}
						echo ' width='.($szerx[$j]*12);
						if ($sumyj==$j) {
							echo ' align="right" ';
						} else {
							echo ' align="right" ';
							if (!$styl[$j]||$styl[$j]=="\r") {;} else {echo $styl[$j];};
						}
						echo ' >';
						if ($sumy[$j] && $sumyj<>$j) {$buf=number_format($buf*1,2,'.',',');}

						echo $buf;
						//if (!$szerx[$j]) {echo $buf;}
						//elseif (strlen($buf)>$szerx[$j]) {echo substr($buf,0,$szerx[$j]).'...';}
						//elseif (!$buf||$sumyj==$j) {echo substr($buf,0,1*$szerx[$j]);}
						//elseif ($sumyp[$j]>0 && $sumyp[$j]<>2) {printf("%.".($sumyp[$j])."f",$buf);}
						//else {echo $buf;}
						echo '</td>';
						echo "\n";
					}
					//łamanie końcowej sumy pozycji
					if(in_array($j,explode(',',$lamanie)))
					{
						echo '</tr><tr><td></td>';
					}
				}

				if(!$tylkoSumy&&!$osobneStrony)
				{
					echo '</tr>';
					$sumy[$sumyj]='';
				}
				
				$sumyok=true;
			}

			if(!$tylkoSumy)
			{
				if($osobneStrony)
				{
					echo "<tr><td height=1px colspan=$mc valign='top'>Strona Nr ".$strona++;	// style='border: 1px solid black'
					echo '</td></tr>'."\n";
					echo '</table>'."\n";
					echo '<hr><p class="breakhere"></p>';

					require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/Raport_n.php");
					echo '<table cellspacing="0" cellpadding="0" rules="none" width="100%" bgcolor="#ffffff" border="0">';
					echo '<tr>';
					echo '	<td align="left"><font style="font-size:12pt">'.$tyt.'</font></td>';
					echo '	<td align="right"><font style="font-size:12pt">Strona Nr '.$strona.'</font></td>';
					echo '</tr>';
					echo '</table>';
				}
				else
				{
					echo "<tr><td height=1px colspan=$mc valign='top'>Strona Nr ".$strona++;	// style='border: 1px solid black'
					echo '</td></tr>'."\n";
					echo '</table>'."\n";
					echo '<hr><p class="breakhere"></p>';
			//		include($_GET['wydruk'].(($_SESSION['osoba_pu']==3)?'a':'')."_ns.html");
					echo '<table cellspacing="0" cellpadding="0" rules="none" width="100%" bgcolor="#ffffff" border="0">';
					echo '<tr>';
					echo '	<td align="left"><font style="font-size:12pt">'.nl2br(@$_POST['naglowekN']?$_POST['naglowekN']:$baza).'</font></td>';
					echo '	<td align="right"><font style="font-size:12pt">Strona Nr '.$strona.'</font></td>';
					echo '</tr>';
					echo '</table>';
					//echo '</td></tr>'."\n";
				}
				echo $naglowekTabeli."\n";
				echo $naglowkiKolumn;
			}
		}
		if(!$tylkoSumy)
		{
			if(!$osobneStrony)
			{
				echo '<tr id="tab_'.($i+1).'" height=1 bgcolor='.$twie.'>';
				echo "\n";
				if($tn[$startkol]!=='LP')
				{
					echo '<td class="nor" align="right" style="border: '.$borderPol.'px solid black;">';
					echo '&nbsp;'.($i+1).'&nbsp;';
					echo '</td>';	//LP
					echo "\n";// wydruk ma nagłówki bez pierwszej kolumny (Nr 0) z ID tabeli
				}
			}
		}

		for($j=$startkol;$j<$mc;$j++)
		{
			if(!$tylkoSumy&&$osobneStrony)
			{
				echo "\n".'<tr bordercolor="black">'."\n";
				if ($szer[$j]==='0')    {echo '<td id="tab_0'.($j+1).'" nowrap class="bez" ';}
				elseif ($szer[$j]=='.') {echo '<td id="tab_0'.($j+1).'" nowrap class="bez" ';}	//width=0 style="font-size:0"
				elseif(strpos('.'.$szer[$j],'@s')) {echo '<td id="tab_0'.($j+1).'" nowrap class="bez" ';}	//width=0 style="font-size:0"
				else {                   echo '<td id="tab_0'.($j+1).'" class="nag" ';}
				echo ' nowrap align="right" style="border: '.$borderNag.'px solid black" ';
				echo ' bgcolor='.$tnag.'>';
				echo ($szer[$j]=='.'?'.':str_replace('-','',$tn[$j]));
				echo ': </td>';
				echo "\n";
			}
			
			if(!$tylkoSumy)
			{
				if ($szer[$j]==='0')    {echo '<td id="tab_'.$i.'_'.$j.'" class="bez" ';} //na ekranie nie ma, na wydruku nie ma, np. ID
				elseif ($szer[$j]=='.') {echo '<td id="tab_'.$i.'_'.$j.'" class="bez" ';} //na ekranie jest, a na wydruku nie ma
				elseif(strpos('.'.$szer[$j],'@s')) {echo '<td id="tab_'.$i.'_'.$j.'" class="bez" ';} //na ekranie jest, a na wydruku nie ma
				else {                   echo '<td id="tab_'.$i.'_'.$j.'" class="nor" width='.($szer[$j]*12);}
				echo ' ';
				if (!$styl[$j]||$styl[$j]=="\r") 
				{
					echo ' style="border: '.$borderPol.'px solid black;" ';
				} else {
					echo str_replace('style="','style="border: '.$borderPol.'px solid black; ',$styl[$j]);
				}
				if(!$zawijanie||$szer[$j]=='10')
				{
					echo ' nowrap';		//zawijanie dlugich wierszy
				}
				echo ' >';
				if (count($z=explode(":",$szer[$j]))>1) {                        //obrazek
						if (!$z[0]) echo '<img src="'.$tr[$j].'" alt="" height='.$z[1].'>';
						if (!$z[1]) echo '<img src="'.$tr[$j].'" alt="" width='.$z[0].' >';
						if ($z[0]&&$z[1]) echo '<img src="'.$tr[$j].'" alt="" width='.$z[0].' height='.$z[1].'>';
				} else 
				{                                                                                                                  //tekst
					// wydruk nie tnie treści kolumn tabeli  "nowrap "
					$buf=$szer[$j];
					if (count($z=explode("@Z",$buf))>1) 
					{		// bez zer
						$buf=str_replace('@Z','',$szer[$j]);
						$buf=str_replace('+','',$buf);
						if ($tr[$j]*1==0) {$tr[$j]='&nbsp;';}
					}
					if (!$tr[$j]) {$tr[$j]='&nbsp;';}
					if ($buf=='.') {echo '.';}
					elseif (substr($buf,0,1)=='%') {printf($buf,$tr[$j]);}
					else {echo StripSlashes($tr[$j]);};
				}
				echo '</td>';
				echo "\n";
			}
			if ($grupyok&&(!($grupa[$j]==null)||(!($sumy[$j]==null)))) 
			{	// wiersz sum grup
				if (($grupa[$j]==='0')&&$grupi==0) {$grupi=$j;}
				$grupa[$j]=str_replace(',','',$tr[$j]);		// 100.00 22% 22.00 122.00
				if ($grupi==$j) {$grupw=$grupa[$j];}
			}
			if (($sumyok)&&(!($sumy[$j]===''))) 
			{                // wiersz sum
//			echo "pr [j=$j tr[j]=$tr[$j] sumy[13]=$sumy[13] ][ sumy[14]=$sumy[14]<br>";
				 $sumy[$j]+=1*str_replace(',','',$tr[$j]);
//			echo "po [j=$j tr[j]=$tr[$j] sumy[13]=$sumy[13] ][ sumy[14]=$sumy[14]<br>";
				 $buf=explode('.',$tr[$j]);
				 $sumyp[$j]=Max(strlen($buf[1]),$sumyp[$j]);
			}
	//print_r($grupa);echo "$j $startkol<br>";
			if(!$tylkoSumy&&$osobneStrony)
			{
				echo '</tr>';
			}

//łamanie pozycji
			if(in_array($j,explode(',',$lamanie)))
			{
				echo '</tr><tr><td></td>';
			}

		}

		if(!$tylkoSumy&&!$osobneStrony)
		{
			echo '</tr>';
		}

		if ($grupyok) 
		{
			$k=0; while (($grupt[$k][0]<>$grupw)&&($k<count($grupt))) {$k++;}
			$grupt[$k][0]=$grupw;
	//print_r($grupt);echo " $grupw $k<br>";
			for ($j=$startkol;$j<$mc;$j++) 
			{
	//print_r($grupt);echo " $grupw $k $j<br>";
	//print_r($grupa[$j]);echo "<br>";
				if ($j==$grupi) {
					$grupt[$k][$j]=$grupa[$j];	// 22%
				} else {
					$grupt[$k][$j]+=str_replace(',','',$grupa[$j])*1;	//kwoty
				}
			}
	//print_r($grupt);echo " $k <br>";
		}
	}

	if ($sumyok) 
	{                // wiersz sum

		if(!$tylkoSumy&&$osobneStrony)
		{
			echo "<tr><td height=1px colspan=$mc valign='top'>Strona Nr ".$strona++;	// style='border: 1px solid black'
			echo '</td></tr>'."\n";
			echo '</table>'."\n";
			echo '<hr><p class="breakhere"></p>';

			require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/Raport_n.php");
			echo '<table cellspacing="0" cellpadding="0" rules="none" width="100%" bgcolor="#ffffff" border="0">';
			echo '<tr>';
			echo '	<td align="left"><font style="font-size:12pt">'.$tyt.'</font></td>';
			echo '	<td align="right"><font style="font-size:12pt">Strona Nr '.$strona.'</font></td>';
			echo '</tr>';
			echo '</table>';
			echo $naglowekTabeli."\n";
			echo $naglowkiKolumn;
		}

		if ($strona==1) {
			$sumys=$sumy;
		}
		if(!$osobneStrony)
		{
			echo "\n";
			echo '<tr bgcolor='.$twie.'>';
			echo "\n";
			if($tn[$startkol]!=='LP')
			{
				echo "<td></td>";	//LP: ostatnia strona
				echo "\n";
			}
		}
		$znikniete=0;
		$sumyok=true;
		for($j=$startkol;$j<$mc;$j++) 
		{
			if	( ($szer[$j]==='0')
				||($szer[$j]=='.')
				||(strpos('.'.$szer[$j],'@s'))
				)
			{
				$znikniete++;
			}

			if ($sumyok&&($sumyj==$j||($sumy[$j+1]<>''))) 
			{
				$sumys[$j]='Suma strony:';
				$sumyok=false;
				$sumyj=$j;
				$zniknieteDoSum=$znikniete;
				if ($strona==1) {
					for($k=$j+1;$k<$mc;$k++){
						if ($sumy[$k]) {
							$sumyw[$k]=$sumy[$k]-$sumys[$k];
						}
					}
				} else {
					for($k=$j+1;$k<$mc;$k++){
						if ($sumy[$k]) {
							$sumys[$k]=$sumy[$k]-$sumyw[$k];
						}
					}
				}
			}

			$buf=$sumys[$j];

			if(!$tylkoSumy)
			{
				$szerx[$j]=str_replace('+','',$szer[$j]);
				$szerx[$j]=str_replace('@Z','',$szerx[$j]);
				if (substr($szerx[$j],0,1)=='%') {$szerx[$j]=substr($szerx[$j],2);}
				if(!$tylkoSumy&&($sumyj>0)&&($j>=$sumyj)&&!$osobneStrony)
				{
					echo '<td nowrap ';
					if($j==$sumyj)
					{
						echo 'colspan="'.($j-($tn[$startkol]!=='LP'?0:0)-$zniknieteDoSum).'" ';
					}
					if ($szerx[$j]==='0')    {echo ' class="bez" ';}
					elseif ($szerx[$j]=='.') {echo ' class="bez" ';}
					elseif($szerx[$j]=='@s') {echo ' class="bez" ';}
					else {                   echo ' class="nor" ';}

					if($borderPol)
					{
						if ($sumyj!=$j) 
						{
							echo ' style="border-top: double black;';
							echo '        border-right: '.$borderPol.'px solid black;';
							echo '        border-left: '.$borderPol.'px solid black;';
							echo '        border-bottom: '.$borderPol.'px solid black;';
							echo '"';
						}
					}
					else
					{
						echo ' style="border-top: 1px solid black" width='.($szerx[$j]*12);
					}

					if ($sumyj==$j) {
						echo ' align="right" ';
					} else {
						echo ' align="right" ';
						if (!$styl[$j]||$styl[$j]=="\r") {;} else {echo $styl[$j];};
					}
					echo ' >';

					if ($sumy[$j] && $sumyj<>$j) {$buf=number_format($buf*1,2,'.',',');}

					echo $buf;
					//if (!$szerx[$j]) {echo $buf;}
					//elseif (strlen($buf)>$szerx[$j]) {echo substr($buf,0,$szerx[$j]).'...';}
					//elseif (!$buf||$sumyj==$j) {echo substr($buf,0,1*$szerx[$j]);}
					//elseif ($sumyp[$j]>0 && $sumyp[$j]<>2) {printf("%.".($sumyp[$j])."f",$buf);}
					//else {echo $buf;}
					echo '</td>';
					echo "\n";
				}
			}

//łamanie końcowej sumy pozycji
			if(in_array($j,explode(',',$lamanie)))
			{
				echo '</tr><tr><td></td>';
			}
		}

		$sumys[$sumyj]='';

		if(!$tylkoSumy&&!$osobneStrony)
		{
			echo '</tr>';
			echo "\n";

			echo '<tr bgcolor='.$twie.'>';
			echo "\n";
			if($tn[$startkol]!=='LP')
			{
				echo "<td></td>";	//LP
				echo "\n";
			}
		}

		$sumyok=true;
		for($j=$startkol;$j<$mc;$j++){
			if ($sumyok&&($sumyj==$j||($sumy[$j+1]<>''))) {
					$sumyw[$j]='Poprzednie strony:';
					$sumyok=false;
					$sumyj=$j;
			}

			$buf=$sumyw[$j];

			if(!$tylkoSumy&&!$osobneStrony)
			{
				$szerx[$j]=str_replace('+','',$szer[$j]);
				$szerx[$j]=str_replace('@Z','',$szerx[$j]);
				if (substr($szerx[$j],0,1)=='%') {$szerx[$j]=substr($szerx[$j],2);}
				if(!$tylkoSumy&&($sumyj>0)&&($j>=$sumyj))
				{
					echo '<td nowrap ';
					if($j==$sumyj)
					{
						echo 'colspan="'.($j-($tn[$startkol]!=='LP'?0:0)-$zniknieteDoSum).'" ';
					}
					if ($szerx[$j]==='0')    {echo ' class="bez" ';}
					elseif ($szerx[$j]=='.') {echo ' class="bez" ';}
					elseif($szerx[$j]=='@s') {echo ' class="bez" ';}
					else {                   echo ' class="nor" ';}

					if($borderPol)
					{
						if ($sumyj!=$j) 
						{
							echo ' style="border: '.$borderPol.'px solid black;" ';
						}
					}

					echo ' width='.($szerx[$j]*12);
					if ($sumyj==$j) {
						echo ' align="right" ';
					} else {
						echo ' align="right" ';
						if (!$styl[$j]||$styl[$j]=="\r") {;} else {echo $styl[$j];};
					}
					echo ' >';

					if ($sumy[$j] && $sumyj<>$j) {$buf=number_format($buf*1,2,'.',',');}

					echo $buf;
					//if (!$szerx[$j]) {echo $buf;}
					//elseif (strlen($buf)>$szerx[$j]) {echo substr($buf,0,$szerx[$j]).'...';}
					//elseif (!$buf||$sumyj==$j) {echo substr($buf,0,1*$szerx[$j]);}
					//elseif ($sumyp[$j]>0 && $sumyp[$j]<>2) {printf("%.".($sumyp[$j])."f",$buf);}
					//else {echo $buf;}

					echo '</td>';
					echo "\n";
				}
			}
			//łamanie końcowej sumy pozycji
			if(in_array($j,explode(',',$lamanie)))
			{
				echo '</tr><tr><td></td>';
			}
		}

		$liniaCala="";
		$linia="";
		$buf='';
		$bufLicznik=0;

		if(!$tylkoSumy&&!$osobneStrony)
		{
			echo '</tr>';
			$linia.='<tr bgcolor='.$twie.'>';
			$linia.="\n";
			if($tn[$startkol]!=='LP')
			{
				$linia.="<td></td>";	//LP
				$linia.="\n";
			}
		}
		
		$sumyw[$sumyj]='';
		$sumyok=true;
		for($j=$startkol;$j<$mc;$j++)
		{
			if ($sumyok&&($sumyj==$j||($sumy[$j+1]<>''))) {
				$sumy[$j]='Razem:';
				$sumyok=false;
				$sumyj=$j;
				$sumyw=$sumy;
			}
$wazne=false;
			if(($sumyj>0)&&($j>=$sumyj)&&$osobneStrony)
			{
				$tn[$sumyj]='';
				$linia.='<tr bordercolor="black">'."\n";
				if ($szer[$j]==='0')    {$linia.='<td id="tab_0'.($j+1).'" nowrap class="bez" ';}
				elseif ($szer[$j]=='.') {$linia.='<td id="tab_0'.($j+1).'" nowrap class="bez" ';}
				elseif(strpos('.'.$szer[$j],'@s')) {$linia.='<td id="tab_0'.($j+1).'" nowrap class="bez" ';}
				elseif(!strpos($szer[$j],'+')) {$linia.='<td id="tab_0'.($j+1).'" nowrap class="bialy" ';}
				else {                   $linia.='<td id="tab_0'.($j+1).'" class="nag" ';}
				$linia.=' nowrap align="right" style="border: '.$borderNag.'px solid black" ';
				$linia.=' bgcolor='.$tnag.'>';
				
				if	( $osobneStrony
					&&	( $tn[$j]=='Ogółem przychód'
						||$tn[$j]=='Składki pracownika razem'
						||substr($tn[$j],0,7)=='Należna'
						||$tn[$j]=='Do wypłaty'
						)
					)
				{
					$wazne=true;
				}
				$linia.=($szer[$j]=='.'?'.':str_replace('-','',$tn[$j]));
				$linia.=': ';
				
				if($wazne)
				{
					$linia.='<hr>';
				}
				$linia.='</td>';
				$linia.="\n";
			}

			$szerx[$j]=str_replace('+','',$szer[$j]);
			$szerx[$j]=str_replace('@Z','',$szerx[$j]);
			if (substr($szerx[$j],0,1)=='%') {$szerx[$j]=substr($szerx[$j],2);}

			if(($sumyj>0)&&($j>=$sumyj))
			{
				$linia.='<td nowrap ';

				if($j==$sumyj)
				{
					$linia.='colspan="'.($j-($tn[$startkol]!=='LP'?0:0)-$zniknieteDoSum).'" ';
				}
				if    ($szerx[$j]==='0') {$linia.=' class="bez" ';}
				elseif($szerx[$j]=='.')  {$linia.=' class="bez" ';}
				elseif($szerx[$j]=='@s') {$linia.=' class="bez" ';}
				elseif(!strpos($szer[$j],'+')&&($j>$sumyj)) {$linia.=' class="bialy" ';}
				else {                    $linia.=' class="nor" ';}

				if($borderPol)
				{
					if ($sumyj!=$j) 
					{
						$linia.=' style="border: '.$borderPol.'px solid black;" ';
					}
				}

				$linia.=' width='.($szerx[$j]*12);
				if ($sumyj==$j) {
					$linia.=' align="right" ';
				} else {
					$linia.=' align="right" ';
					if (!$styl[$j]||$styl[$j]=="\r") {;} else {$linia.=$styl[$j];};
				}
				$linia.=' >';
				
				$buf=$sumy[$j];
				if ($sumy[$j] && $sumyj<>$j) {$buf=number_format($buf*1,2,'.',',');}

				if($wazne)
				{
					//$linia.='<font style="font-size:20pt; font-weight:bold;">';
				}

				++$bufLicznik;
				$linia.='$buf'.$bufLicznik;

				if($wazne)
				{
					$linia.='<hr>';
				}
				//if (!$szerx[$j]) {$linia.=$buf;}
				//elseif (strlen($buf)>$szerx[$j]) {$linia.=substr($buf,0,$szerx[$j]).'...';}
				//elseif (!$buf||$sumyj==$j) {$linia.=substr($buf,0,1*$szerx[$j]);}
				//elseif ($sumyp[$j]>0 && $sumyp[$j]<>2) {$linia.=sprintf("%.".($sumyp[$j])."f",$buf);}
				//else {$linia.=$buf;}
				$linia.='</td>';
				$linia.="\n";
			}
			if(($sumyj>0)&&($j>=$sumyj)&&$osobneStrony)
			{
				$linia.='</tr>'."\n"."\n";
			}
			//łamanie końcowej sumy pozycji
			if(in_array($j,explode(',',$lamanie)))
			{
				$linia.='</tr><tr><td></td>';
			}
			
			echo str_replace('$buf'.$bufLicznik,$buf,$linia);
			$liniaCala.=$linia;
			$linia='';
			$buf='';
		}

		if(!$osobneStrony)
		{
			$liniaCala.='</tr>'."\n"."\n";
			echo '</tr>'."\n"."\n";
		}

		$sumy[$sumyj]='';
		$sumyok=true;
	}

	if($tabela=='zest2')	//analityka obr konta
	{
		$j=8;
		$liniaCala=str_replace('$buf1','Saldo:',$liniaCala);
		if($tr[$j]>=0)
		{
			$liniaCala=str_replace('$buf2',$tr[$j],$liniaCala);
			$liniaCala=str_replace('$buf3',0,$liniaCala);
		}
		else
		{
			$liniaCala=str_replace('$buf2',0,$liniaCala);
			$liniaCala=str_replace('$buf3',str_replace('-','',$tr[$j]),$liniaCala);
		}
		echo $liniaCala;
	}

	if (false&&$sumyok) 
	{                // wiersz sum
			echo "\n";
			echo '<tr bgcolor='.$twie.'>';
			echo "\n";
			echo "<td></td>";	//LP
			echo "\n";
			$sumyok=true;
			for($j=$startkol;$j<$mc;$j++){
					if ($sumyok&&!$sumy[$j+1]=='') {
							$sumy[$j]='Suma:';
							$sumyok=false;
					}
			$szerx[$j]=str_replace('+','',$szer[$j]);
			$szerx[$j]=str_replace('@Z','',$szerx[$j]);
					if (substr($szerx[$j],0,1)=='%') {$szerx[$j]=substr($szerx[$j],2);}
					echo '<td nowrap ';
					if ($szerx[$j]==='0')    {echo ' class="bez" ';}
					elseif ($szerx[$j]=='.') {echo ' class="bez" ';}
					elseif($szerx[$j]=='@s') {echo ' class="bez" ';}
					else {                    echo ' class="nor" ';}
					echo ' width='.($szerx[$j]*12);
					if (!$sumy[$j]==''&&!$sumyok) {
							echo ' style="border-top: double #000000" ';
					}
				 if ($sumy[$j]=='Suma:') {
				echo ' align="right" ';
				 } else {
				echo ' align="center" ';
						if (!$styl[$j]||$styl[$j]=="\r") {;} else {echo $styl[$j];};
				 }
					echo ' >';
			if ($sumy[$j] && $sumy[$j]<>'Suma:') {$sumy[$j]=number_format($sumy[$j]*1,2,'.',',');}
					if (!$szerx[$j]) {echo $sumy[$j];}
					elseif (strlen($sumy[$j])>$szerx[$j]) {echo substr($sumy[$j],0,$szerx[$j]).'...';}
					elseif (!$sumy[$j]||$sumy[$j]=='Suma:') {echo substr($sumy[$j],0,$szerx[$j]);}
					elseif ($sumyp[$j]>0 && $sumyp[$j]<>2) {printf("%.".($sumyp[$j])."f",$sumy[$j]);}
						 else {echo $sumy[$j];}
					echo '</td>';
					echo "\n";
			}
			echo '</tr>';
	}

	if ($grupyok) 
	{                // wiersz sum
		for($i=0;$i<count($grupt);$i++) 
		{
			echo "\n";
			echo '<tr bgcolor='.$twie.'>';
			echo "\n";
			echo "<td></td>";	//LP
			echo "\n";
			$sumyok=true;
			for($j=$startkol;$j<$mc;$j++) {
				$sumy[$j]=$grupt[$i][$j];
				if ($sumy[$j]=='0') {$sumy[$j]='';}
			}
			for($j=$startkol;$j<$mc;$j++) 
			{
				if ($sumyok&&!$sumy[$j+1]==''&&$i==0) {
					$sumy[$j]='W tym:';
					$sumyok=false;
				}
	//			$szer[$j]=str_replace('*','',$szer[$j]);
				$szerx[$j]=str_replace('+','',$szer[$j]);
				$szerx[$j]=str_replace('@Z','',$szerx[$j]);
				if (substr($szerx[$j],0,1)=='%') {$szerx[$j]=substr($szerx[$j],2);}
				echo '<td nowrap ';
				if ($szerx[$j]==='0')    {echo ' class="bez" ';}
				elseif ($szerx[$j]=='.') {echo ' class="bez" ';}
				elseif($szerx[$j]=='@s') {echo ' class="bez" ';}
				else {                   echo ' class="nor" ';}
				echo ' width='.($szerx[$j]*12);
				if (!$sumy[$j]==''&&$i==0) {
						echo ' style="border-top: double #000000" ';
				}
				if ($sumy[$j]=='W tym:') {
					echo ' align="right" ';
				} else {
					echo ' align="right" ';
					if (!$styl[$j]||$styl[$j]=="\r") {;} else {echo $styl[$j];};
				}
				echo ' >';
				if ($sumy[$j] && $sumy[$j]<>'W tym:' && $szerx[$j]<>'*') {$sumy[$j]=number_format($sumy[$j]*1,2,'.',',');}
				if (!$szerx[$j]) {echo $sumy[$j];}
				elseif ($szerx[$j]=='*') {echo $sumy[$j];}
				elseif (strlen($sumy[$j])>$szerx[$j]) {echo substr($sumy[$j],0,$szerx[$j]).'...';}
				elseif (!$sumy[$j]||$sumy[$j]=='W tym:') {echo substr($sumy[$j],0,$szerx[$j]);}
				elseif ($sumyp[$j]>0 && $sumyp[$j]<>2) {printf("%.".($sumyp[$j])."f",$sumy[$j]);}
				else {echo $sumy[$j];}
				echo '</td>';
				echo "\n";
			}
			echo '</tr>';
		}
	}
}

if($w) {mysqli_free_result($w);}
//mysqli_free_result($f);
//require('dbdisconnect.inc');

echo '<tr>';
//echo '<td colspan='.$mc.'>Strona Nr '.$strona++.'. Koniec wydruku. Data: '.(@$_POST['data']?$_POST['data']:date('Y.m.d')).', godzina: '.(@$_POST['czas']?$_POST['czas']:date('G.i.s'));//.'. Wykonał: ......................................';
echo '<td colspan='.($osobneStrony?2:$mc).'>Koniec wydruku.';

//$x=strtoupper(trim($_SESSION['osoba_upr']));
//$dane=explode(' ',$x);
//if (substr($dane[0],-1,1)=='A' || substr($dane[1],-1,1)=='A') {echo 'a';};
//echo ":&nbsp;".$_SESSION['osoba_upr'].'<hr>';

echo '</td>'."\n";
echo '</tr>'."\n";
echo '</table>'."\n";

//include($_GET['wydruk']."_s.html");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/Raport_s.php");
//echo "<hr>$sqlaa<hr>";
//echo "<hr>$sqla<hr>";
//echo "<hr>$sql<hr>";
//die(print_r($_GET));
?>

</body>
</html>
