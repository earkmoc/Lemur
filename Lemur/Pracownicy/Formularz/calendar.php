<script type="text/javascript">

var aktywne='#FF6600';	//ceglaste

</script>

<?php

$id=trim($_GET['id']);
$idPracownika=trim($_GET['idPracownika']);
$data=trim($_GET['data']);

$id=(!$id?'Kalendarz':$id);
$data=(!$data?date('Y-m-d'):$data);

$baseYear=substr($data,0,4);
$baseMonth=1;
$baseDay=1;
$baseDate="$baseYear-$baseMonth-$baseDay";

//----------------------------------------------------------------------------------------------------------
//Dni tygodnia

$plDOW=array(
 'Nd'
,'Pn'
,'Wt'
,'Sr'
,'Cz'
,'Pt'
,'Sb'
);

$plSbNd=array(
 'Nd'
,''
,''
,''
,''
,''
,'Sb'
);

//miesi±ce
$plMOY=array(
 'Styczeñ'
,'Luty'
,'Marzec'
,'Kwiecieñ'
,'Maj'
,'Czerwiec'
,'Lipiec'
,'Sierpieñ'
,'Wrzesieñ'
,'Pa¼dziernik'
,'Listopad'
,'Grudzieñ'
);

$rzymskie=array("I","II","III","IV","V","VI","VII","VIII","IX","X","XI","XII");

$typy=array(
 "P"=>"praca"
,"D"=>"dy¿ur"
,"S"=>"podró¿ s³u¿bowa"
,"Uw"=>"urlop wypoczynkowy"
,"Um"=>"urlop macierzyñski"
,"Ub"=>"urlop bezp³atny"
,"W"=>"urlop wychowawczy"
,"Ch"=>"choroba"
,"Op"=>"opieka"
,"Np"=>"inne nieobecno¶ci p³atne"
,"N"=>"inne nieobecno¶ci niep³atne"
,"Nn"=>"nieobecno¶æ nieusprawiedliwiona"
);

$typyKolory=array(
 "P"=>"lightblue"
,"D"=>"yellow"
,"S"=>"yellow"
,"Uw"=>"lightgreen"
,"Um"=>"yellow"
,"Ub"=>"yellow"
,"W"=>"yellow"
,"Ch"=>"red"
,"Op"=>"yellow"
,"Np"=>"yellow"
,"N"=>"yellow"
,"Nn"=>"yellow"
);

$sumy=array(
 "O"=>"Ogó³em"
,"N¦"=>"Niedziele i ¦wiêta"
,"N"=>"Nocne"
,"GN"=>"Godziny Nadliczbowe"
,"DW"=>"w Dni Wolne"
);

//----------------------------------------------------------------------------------------------------------
//ewentualne utworzenie tabeli w bazie danych

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
   
$tabela=$widok='absencje';
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/tableFields.php");

//----------------------------------------------------------------------------------------------------------
//absencje

$w=mysqli_query($link, $q=("
	select DATA, KOD from absencje where ID_D=$idPracownika
"));
if (mysqli_error($link)) {
	die(mysqli_error($link).'<br>'.$q);
}

$absencje=array();
while($absencja=mysqli_fetch_array($w)) 
{
	$absencje[$absencja['DATA']]=$absencja['KOD'];
}

//----------------------------------------------------------------------------------------------------------
//daty bazowe do nawigacji kalendarza

$w=mysqli_query($link, $q=("
      Select date_Add('$baseDate',interval -1 month) as prevMonth
            ,date_Add('$baseDate',interval  1 month) as nextMonth
            ,date_Add('$baseDate',interval -1 year)  as prevYear
            ,date_Add('$baseDate',interval  1 year)  as nextYear
            ,date_Add('$baseDate',interval -7 day)   as prevWeek
            ,date_Add('$baseDate',interval  7 day)   as nextWeek
"));
if (mysqli_error($link)) {
	die(mysqli_error($link).'<br>'.$q);
}

$daty=mysqli_fetch_array($w);

//----------------------------------------------------------------------------------------------------------
//kalendarz

echo "<table class='table table-striped table-bordered table-hover table-condensed'>";
echo '<tr  style="vertical-align:center">';
echo '<th colspan="6" style="text-align:center">';

echo '<h4><b>Rok: </b>';

echo '<button type="button" class="btn btn-default btn-xs" aria-label="rok" title="rok poprzedni"';
echo " onclick=\"getCalendar('$id','$idPracownika','$daty[prevYear]')\">";
echo '<span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>';
echo '</button>';

echo ' <button type="button" class="btn btn-default" title="Wpisanie aktywnego kodu dla wszystkich dni roboczych w tym roku" onclick="ToggleYear(this)">';
echo '<font color="gray">'.(" $baseYear ").'</font>';
echo '</button> ';

echo '<button type="button" class="btn btn-default btn-xs" aria-label="rok" title="rok nastêpny"';
echo " onclick=\"getCalendar('$id','$idPracownika','$daty[nextYear]')\">";
echo '<span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>';
echo '</button>';

echo '</h4>';

echo '</th>';

echo '<th colspan="31" style="text-align:left">';
echo 'Kod godzin: ';
foreach($typy as $key => $value)
{
	echo "<span id='div{$key}' style='padding:5pt'>";
	echo "<button name='{$key}' type='button' onclick='AktywujKolor(this)' title='{$value}: aktywacja tego kodu'>{$key}</button>";
	echo "= <span id='{$key}'>0</span>";
	echo "</span> ";
}
echo "<br>Ilo¶æ godzin: <input name='godziny' value='8' size='1' /> na dzieñ";
echo '</th>';

echo '</tr>';

for($mc=0;$mc<=12;++$mc) 
{
	$mc=($mc<10?"0$mc":$mc);
	echo "<tr>";
	for($day=0;$day<=31;++$day) 
	{
		$day=($day<10?"0$day":$day);
		echo "<td kolor='' style='text-align:center; padding:2px;";
		switch (true)
		{
		case(	($mc==0) 
			&&	($day==0)
			):
			echo "'>";
//			echo "<b>m-c \ dzieñ</b>";
			break;
		case(	($mc==0)
			):
			echo " background:lightgray'>";
			echo "<b>$day</b>";
			break;
		case(	($day==0)
			):
			echo " background:lightgray'>";
			echo '<button type="button" class="form-control btn btn-default btn-xs" name="'.$mc.'" title="'.$plMOY[$mc-1].': wpisanie aktywnego kodu dla wszystkich dni roboczych w tym miesi±cu" onclick="ToggleMonth(this)">';
			echo '<font color="gray"><b>'.$rzymskie[$mc-1].'</b></font>';
			echo '</button>';
			break;
		default:
			echo "'>";
			$year=$baseYear;
			$maxDay=cal_days_in_month(CAL_GREGORIAN,$mc,$year);
			if ($day<=$maxDay) {
				$nrDOW=jddayofweek(cal_to_jd(CAL_GREGORIAN,$mc,$day,$year),0);  //Niedziela=0, Poniedzia³ek=1, ... 
				$weekend=(($nrDOW==0||$nrDOW==6)?1:0);
				$dt="$year-$mc-$day";
				$dow=$plDOW[$nrDOW];
				$dSb=$plSbNd[$nrDOW];

				$val=@$absencje[$dt];
				$val=($val?$val:$dSb);

				echo '<input type="text" class="form-control btn btn-default btn-xs" mc="'.$mc.'" weekend="'.$weekend.'" name="'.$dt.'" title="'."$dt (".($dow).')" onclick="ToggleDay(this)" value="'.$val.'" dow="'.$dSb.'" />';
			} 
			break;
		}
		echo "</td>";
	}
	
	foreach($sumy as $key => $value)
	{
		if($mc==0)
		{
			echo "<th style='text-align:center; background:lightgray'><b>$key</b></th>";
		}
		else
		{
			echo "<td style='text-align:center; padding:2px; background:lightgray'>";
			echo "<input type='text' class='form-control btn btn-default btn-xs' name='{$year}-{$mc}-{$key}' title='{$value}: {$plMOY[$mc-1]}' value='".@$absencje["{$year}-{$mc}-{$key}"]."'  style='text-align:center; padding:1px;'/></td>";
		}
	}

	echo "</tr>";
}
echo "</table>";
?>

<script type="text/javascript">

var aktywnyKolor='lightblue';
var aktywnaLitera='P';

function getCalendar($id,$idPracownika,$data) 
{
  var parametry=
     "id="       +$id
    +"&idPracownika=" +$idPracownika
    +"&data="    +$data
  ;
  $("#"+$id).load("calendar.php",parametry,function(){
  });
}

function ToggleDay($this) 
{
   ZaznaczAbsencje($("input[name="+$this.name+"]"));
   PoliczAbsencje();
}

function ToggleMonth($btn) 
{
   $("input[mc="+$btn.name+"]").each(function(){
      ZaznaczAbsencje($(this));
   });
   PoliczAbsencje();
}

function ToggleYear($btn) 
{
<?php
	for($mc=1;$mc<=12;++$mc) 
	{
		$mc=($mc<10?"0$mc":$mc);
		echo "$('input[mc=$mc]').each(function(){";
		echo "	ZaznaczAbsencje($(this));";
		echo "});";
   		echo "PoliczAbsencje();";
	}
?>
}

function ZaznaczAbsencje(el) 
{
   if(el.parent().attr("kolor")!=aktywnyKolor) {
	  var ok=true;
	  if(( (el.attr('value')=='Nd')
		 ||(el.attr('value')=='Sb')
		 )
//		&&(aktywnaLitera=='P')
		)
		{
			ok=false;
		}
	  if(ok)
	  {
		el.parent().css("background-color",aktywnyKolor);
		el.parent().attr("kolor",aktywnyKolor);
		el.attr('value',aktywnaLitera+$('input[name=godziny]').val());
	  }
   } else {
      el.parent().css("background-color","");
      el.parent().attr("kolor","");
      el.attr('value',el.attr('dow'));
   }
}

function PoliczAbsencje() 
{
	<?php
	foreach($typy as $key => $value)
	{
		echo "$('#{$key}').html($('input[value='+'$key'+$('input[name=godziny]').val()+']').length);\n";
	}
	?>
}

function AktywujKolor(el) 
{
	aktywnyKolor=$("button[name="+el.name+"]").css("background-color");
	aktywnaLitera=el.name;	//el.name.substring(0,1);
	<?php
	foreach($typy as $key => $value)
	{
		echo "$('button[name={$key}]').parent().css('background-color','');\n";
	}
	?>
	$("button[name="+el.name+"]").parent().css("background-color",aktywne);
}

$(document).ready(function() 
{
	$("input[weekend=1]").css("color","red");

	<?php
	foreach($typyKolory as $key => $value)
	{
		echo "$('input[value={$key}]').parent().css('background-color','{$value}').attr('kolor','{$value}');\n";
	}
	?>

	PoliczAbsencje();
	
	<?php
	foreach($typyKolory as $key => $value)
	{
		echo "$('button[name={$key}]').css('background-color','{$value}');\n";
	}
	?>

	$("button[name=P]").parent().css("background-color",aktywne);
});

</script>
