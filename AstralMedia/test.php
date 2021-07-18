<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-type" content="text/html; charset=iso-8859-2" />
<?php

require('funkcje_odsetki.php');
require('dbconnect.inc');

$kwota=$_POST['kwota'];
$termin=$_POST['termin'];
$na_dzien=$_POST['na_dzien'];

//echo '<title>Udało się</title>';
echo '<script type="text/javascript" language="JavaScript">';
echo '<!--';
echo 'function Start(){';
echo '	f0.ok.focus();';
echo '};';
echo '-->';
echo '</script>';
echo '</head>';

echo '<body bgcolor="#BFD2FF" onload="Start()">';
echo "<form id='f0' action='test.php' method='post'>";
echo 'Kwota: <input name="kwota" value="'.$kwota.'"/> ';
echo 'Termin: <input name="termin" value="'.$termin.'"/> ';
echo 'Na dzień: <input name="na_dzien" value="'.$na_dzien.'"/> ';
echo '<input id="ok" type="submit" value=" Oblicz odsetki "/>';
echo '<input id="sio" type="reset" value=" Powrót do menu głównego " onclick="location=\'index.php\'" />';
echo "</form>";

Odsetki($kwota, $termin, $na_dzien, true);

echo '</body></html>';
?>