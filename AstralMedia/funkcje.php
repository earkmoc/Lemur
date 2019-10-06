<?php

//require_once("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/funkcje.php");

//***************************************************************************************
//Zwraca nazwy pól od podanego numeru pola (dla ID $nrPola=0)

function FieldsOd($link, $tabela, $nrPola)
{
	$wynik='';
	$w=mysqli_query($link, $q="
		show fields from $tabela
	");
	if (mysqli_error($link)) {die(mysqli_error($link).'<br>'.$q);}
	
	$i=0;
	while($r=mysqli_fetch_row($w))
	{
		$wynik.=(++$i>$nrPola?($wynik?', ':'').$r[0]:'');
	}

	return($wynik);
}

//***************************************************************************************

function Grosz($value,$round=2){
$value*=pow(10.0,$round);
$value=floor(floatval($value+0.51));
$value/=pow(10.0,$round);
return($value);
}

//***************************************************************************************

function Dekoduj($tab,$kod,$j,$n,$d,$s,$t,$ml,$md,$bl) {

if(strlen($kod)==0) {return '';}

$wynik='';
$kod.='   '.$kod;
$c1=intval(substr($kod,-3,1));
$c2=intval(substr($kod,-2,1));
$c3=intval(substr($kod,-1,1));

$wynik.=( $c1==0 ? '' : $s[$c1-1].' ' );  // setki

if($c2==0) {;}
elseif($c2==1) {$wynik.=($c3==0 ? $d[$c2-1] : $n[$c3-1] ).' ';} // nastki
else {$wynik.=$d[$c2-1].' ';                       // dzesi†tki
}

$wynik.=($c3==0||$c2==1 ? '' : $j[$c3-1].' ');  // jednožci

if($c1+$c2+$c3<>0) {       // dopisek o rz'dzie wielkožci
   $c3=sprintf("%1d",$c3);
   if(!$tab) {;}
   elseif(sprintf("%1d",$c2)=='1') {$wynik.=$tab[2].' ';}    		// nastki
   elseif($c3=='1') {$wynik.=($c1+$c2==0 ? $tab[0] : $tab[2] ).' ';}	//1 milion, 991 milionów
   elseif($c3=='2'||$c3=='3'||$c3=='4') {$wynik.=$tab[1].' ';}		//992, 993, 994 miliony
   else {$wynik.=$tab[2].' ';						//995... milionów
   }
}

return $wynik;

}

//***************************************************************************************

function Slownie($w,$znak,$czesc) {

$ww=$w;	//orygina³ do póŸniejszych porównañ

if ($czesc==1) {
   $liczba=trim(substr(sprintf("%' 19.3f",$w),0,15));
	$w=intval($w);
}
else {
	$w=$w-intval($w);
   return $liczba=substr(sprintf("%' 5.2f",$w),-2);
}

if (!$w||($w==0)) {
	$liczba='zero';
	if ($czesc==1) {
		if ($znak) {
		   if($ww<0)  {$liczba='minus '.$liczba;}
	   	else       {$liczba='plus ' .$liczba;}
		}
		elseif($ww<0) {$liczba='minus '.$liczba;}
	}
	return $liczba;
}

$j=array('jeden','dwa','trzy','cztery','piêæ','sze¶æ','siedem','osiem','dziewiêæ');
$n=array('jedena¶cie','dwana¶cie','trzyna¶cie','czterna¶cie','piêtna¶cie','szesna¶cie','siedemna¶cie','osiemna¶cie','dziewiêtna¶cie');
$d=array('dziesiêæ','dwadzie¶cia','trzydzie¶ci','czterdzie¶ci','piêædziesi±t','sze¶ædziesi±t','siedemdziesi±t','osiemdziesi±t','dziewiêædziesi±t');
$s=array('sto','dwie¶cie','trzysta','czterysta','piêæset','sze¶æset','siedemset','osiemset','dziewiêæset');

$t =array('tysi±c','tysi±ce','tysiêcy');
$ml=array('milion','miliony','milionów');
$md=array('miliard','miliardy','miliardów');
$bl=array('bilion','biliony','bilionów');

$rzedy=array($bl,$md,$ml,$t,NULL);
$trojki=array('','','','','');

$k=strlen($liczba)/3;              // ilož tr¢jek
$k=($k>intval($k) ? intval($k)+1 : intval($k));
$k=($k>count($trojki) ? count($trojki) : $k);      // max tr¢jek

for($i=0;$i<$k;$i++) {
    $trojki[count($trojki)-$i-1]=substr($liczba,-3);
    $liczba=substr($liczba,0,strlen($liczba)-3);
}

$liczba='';
for($i=0;$i<count($trojki);$i++) {
	$liczba.=Dekoduj($rzedy[$i],$trojki[$i],$j,$n,$d,$s,$t,$ml,$md,$bl);
}

if ($czesc==1) {
	if ($znak) {
	   if($w<0) {$liczba='minus '.$liczba;}
   	else     {$liczba='plus ' .$liczba;}
	}
	elseif($w<0) {$liczba='minus '.$liczba;}
}

return trim( $liczba );
}

//***************************************************************************************

function SlownieAng($w,$znak,$czesc) {

$ww=$w;	//orygina³ do póŸniejszych porównañ

if ($czesc==1) {
   $liczba=trim(substr(sprintf("%' 19.3f",$w),0,15));
	$w=intval($w);
}
else {
	$w=$w-intval($w);
   return $liczba=substr(sprintf("%' 5.2f",$w),-2);
}

if (!$w||($w==0)) {
	$liczba='zero';
	if ($czesc==1) {
		if ($znak) {
		   if($ww<0)  {$liczba='minus '.$liczba;}
	   	else       {$liczba='plus ' .$liczba;}
		}
		elseif($ww<0) {$liczba='minus '.$liczba;}
	}
	return $liczba;
}

$j=array('one','two','three','four','five','six','seven','eight','nine');
$n=array('eleven','twelve','thirteen','fourteen','fifteen','sixteen','seventeen','eighteen','nineteen');
$d=array('ten','twenty','thirty','fourty','fifty','sixty','seventy','eighty','ninety');
$s=array('one hundred','two hundred','three hundred','four hundred','five hundred','six hundred','seven hundred','eight hundred','nine hundred');

$t =array('thousand','thousand','thousand');
$ml=array('milion','miliony','milionów');
$md=array('miliard','miliardy','miliardów');
$bl=array('bilion','biliony','bilionów');

$rzedy=array($bl,$md,$ml,$t,NULL);
$trojki=array('','','','','');

$k=strlen($liczba)/3;              // ilož tr¢jek
$k=($k>intval($k) ? intval($k)+1 : intval($k));
$k=($k>count($trojki) ? count($trojki) : $k);      // max tr¢jek

for($i=0;$i<$k;$i++) {
    $trojki[count($trojki)-$i-1]=substr($liczba,-3);
    $liczba=substr($liczba,0,strlen($liczba)-3);
}

$liczba='';
for($i=0;$i<count($trojki);$i++) {
	$liczba.=Dekoduj($rzedy[$i],$trojki[$i],$j,$n,$d,$s,$t,$ml,$md,$bl);
}

if ($czesc==1) {
	if ($znak) {
	   if($w<0) {$liczba='minus '.$liczba;}
   	else     {$liczba='plus ' .$liczba;}
	}
	elseif($w<0) {$liczba='minus '.$liczba;}
}

return trim( $liczba );
}

//***************************************************************************************
?>