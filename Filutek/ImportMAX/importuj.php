<?php

error_reporting(E_ERROR | E_PARSE | E_WARNING);//E_NOTICE | 

$dzis=date('Y-m-d');
$czas=date('Y-m-d H:i:s');

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");

//Mazovia  134 141 145 146 164 162 158 166 167 143 149 144 156 165 163 152 160 161
//ISO88592 177 230 234 179 241 243 182 188 191 161 198 202 163 209 211 166 172 175
$maz=array(134,141,145,146,164,162,158,166,167,161,143,149,144,163,156,165,152,160);
$iso=array(177,230,234,179,241,243,182,188,191,175,161,198,202,211,163,209,166,172);
//Array (  ± > æ > ê > ³ > ñ > ó > ¶ > ¼ > ¿ > ¯ > ¡ > Æ > Ê > Ó > £ > Ñ > ¦ > ¬ )

foreach($maz as $key => $value) {$maz[$key]=chr($value);}
foreach($iso as $key => $value) {$iso[$key]=chr($value);}

$file=$_POST['path'].'\\max.txt';
$max=file_get_contents($file);

$value='';
for($i=0;$i<strlen($max);++$i)
{
	$value.=chr(ord(substr($max,$i,1))-11);
}
$value=str_replace($maz,$iso,$value);
$value=str_replace("'","`",$value);

$_POST['path']=str_replace("\\","/",$_POST['path']);
//$_POST['path']=AddSlashes($_POST['path']);
$value=AddSlashes($value);

mysqli_query($link, "insert into klienci set CZAS=Now(), OPIS='$_POST[path]', UWAGI='$value'");

$title="Import pliku MAX: raport";
$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=powrót','akcja'=>"../Klienci");

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

echo "<table width='100%' height='100%'>";
echo "<tr>";
echo "<td width='33%'></td>";
echo "<td>";

echo "<h2>Raport importu pliku $file:</h2>";
echo "<hr>";
echo "<table>";
	echo '<tr>';
	echo '<td align="left"><h1>'.nl2br($value).'</h1></td>';
	echo '</tr>';
echo "<table>";

echo '<hr>';

echo $czas.' czas rozpoczêcia';
echo '<br>';
echo date('Y-m-d H:i:s').' czas zakoñczenia';

echo "</td>";
echo "<td width='33%'></td>";
echo "</tr></table>";

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");