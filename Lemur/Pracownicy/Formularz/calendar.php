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

$typy=array(
 "D"=>"dy¿ur"
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
 "D"=>"lightblue"
,"S"=>"lightblue"
,"Uw"=>"lightgreen"
,"Um"=>"lightblue"
,"Ub"=>"lightblue"
,"W"=>"lightblue"
,"Ch"=>"red"
,"Op"=>"lightblue"
,"Np"=>"lightblue"
,"N"=>"lightblue"
,"Nn"=>"lightblue"
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

echo '<h4>';

echo '<button type="button" class="btn btn-default btn-xs" aria-label="rok" title="rok wstecz"';
echo " onclick=\"getCalendar('$id','$idPracownika','$daty[prevYear]')\">";
echo '<span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>';
echo '</button>';

echo " $baseYear ";

echo '<button type="button" class="btn btn-default btn-xs" aria-label="rok" title="rok wprzód"';
echo " onclick=\"getCalendar('$id','$idPracownika','$daty[nextYear]')\">";
echo '<span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>';
echo '</button>';

echo '</h4>';

echo '</th>';

echo '<th colspan="26" style="text-align:center">';
foreach($typy as $key => $value)
{
	echo "<span id='div{$key}' style='padding:5pt'>";
	echo "<button name='{$key}' type='button' onclick='AktywujKolor(this)' title='{$value}'>{$key}</button>";
	echo "= <span id='{$key}'>0</span>";
	echo "</span> ";
}
echo '</th>';

echo '</tr>';

for($mc=0;$mc<=12;++$mc) 
{
	$mc=($mc<10?"0$mc":$mc);
	echo "<tr>";
	for($day=0;$day<=31;++$day) 
	{
		$day=($day<10?"0$day":$day);
		echo "<td kolor=''>";
		switch (true)
		{
		case(	($mc==0) 
			&&	($day==0)
			):
			break;
		case(	($mc==0)
			):
			echo $day;
			break;
		case(	($day==0)
			):
			echo '<button type="button" class="form-control btn btn-default" name="'.$mc.'" title="'.$plMOY[$mc-1].'" onclick="ToggleMonth(this)">';
			echo '<font color="gray">'.$plMOY[$mc-1].'</font>';
			echo '</button>';
			break;
		default:
			$year=$baseYear;
			$maxDay=cal_days_in_month(CAL_GREGORIAN,$mc,$year);
			if ($day<=$maxDay) {
				$nrDOW=jddayofweek(cal_to_jd(CAL_GREGORIAN,$mc,$day,$year),0);  //Niedziela=0, Poniedzia³ek=1, ... 
				$weekend=(($nrDOW==0||$nrDOW==6)?1:0);
				$dt="$year-$mc-$day";
				$dow=$plDOW[$nrDOW];

				$val=@$absencje[$dt];
				$val=($val?$val:$dow);

				echo '<input type="text" class="form-control btn btn-default btn-xs" mc="'.$mc.'" weekend="'.$weekend.'" name="'.$dt.'" title="'."$dt (".($dow).')" onclick="ToggleDay(this)" value="'.$val.'" dow="'.$dow.'" />';
			} 
			break;
		}
		echo "</td>";
	}
	echo "</tr>";
}
echo "</table>";
?>

<script type="text/javascript">

var aktywnyKolor='lightgreen';
var aktywnaLitera='Uw';

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
}

function ToggleMonth($btn) 
{
   $("input[mc="+$btn.name+"]").each(function(){
      ZaznaczAbsencje($(this));
   });
}

function ZaznaczAbsencje(el) 
{
   if(el.parent().attr("kolor")!=aktywnyKolor) {
      el.parent().css("background-color",aktywnyKolor);
      el.parent().attr("kolor",aktywnyKolor);
      el.attr('value',aktywnaLitera);
   } else {
      el.parent().css("background-color","");
      el.parent().attr("kolor","");
      el.attr('value',el.attr('dow'));
   }
   PoliczAbsencje();
}

function PoliczAbsencje() 
{
	<?php
	foreach($typy as $key => $value)
	{
		echo "$('#{$key}').html($('input[value={$key}]').length);\n";
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

	$("button[name=Uw]").parent().css("background-color",aktywne);
});

</script>
