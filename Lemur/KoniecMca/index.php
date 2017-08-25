<?php

$wydruki=array();
$wydruki["rs"]="Rejestr sprzeda¿y VAT";
$wydruki["rzztmu"]="Rejestr zakupów VAT - zestawienie (towary, materia³y us³ugi)";
$wydruki["rzzwnt"]="Rejestr zakupów VAT - zestawienie (WNT)";
$wydruki["rzbio"]="Rejestr zbiorczy";
$wydruki["rzwnt"]="Rejestr zakupów WNT";
$wydruki["rswnt"]="Rejestr sprzeda¿y WNT";
$wydruki["lp"]="Lista p³ac";
$wydruki["wb"]="Wyci±gi bankowe";
$wydruki["ak"]="Analityka obrotów konta - raport kasowy";
$wydruki["nin"]="PK - Nale¿ny i naliczony podatek VAT";
$wydruki["zus"]="ZUS P DRA";
$wydruki["snuz"]="PK - Sk³adka na ubezpieczenie zdrowotne";
$wydruki["ww"]="PK - Wyp³ata wynagrodzenia";
$wydruki["dg"]="Dziennik g³ówny";
$wydruki["zs"]="Zestawienie syntetyczne";
$wydruki["bi"]="Bilans (Aktywa, Pasywa, Rachunek wyników) na ostatni dzieñ miesi±ca";
$wydruki["VUE"]="VAT-UE";
$wydruki["V-7"]="VAT-7";

if(count($_POST)>0)
{
	foreach($_POST as $key => $value)
	{
		echo "$wydruki[$key]<br>";
		switch($key)
		{
			case 'rs':
				break;
		}
	}
}
else
{
	$title="Zakoñczenie miesi±ca";
	$buttons=array();
	$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=wyj¶cie','akcja'=>"../Menu");
	$buttons[]=array('klawisz'=>'Enter','nazwa'=>'Enter=wykonaj Wydruki','akcja'=>".");
	$buttons[]=array('klawisz'=>'AltZ','nazwa'=>'Zaznacz wszystkie','js'=>"$('input').prop('checked', true)");
	$buttons[]=array('klawisz'=>'AltO','nazwa'=>'Odznacz wszystkie','js'=>"$('input').prop('checked', false)");

	require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");

	echo "<table width='100%' height='100%'>\n";
	echo "<tr>\n";
	echo "<td>\n";
?>
<div class="tab-content">
   <div class="tab-pane active in" id="home" style="margin: 20px 0px 20px 0px; padding: 0px;">
      <div class="container-fluid bs-docs-container">
		<div class="row">
			<div class="col-md-2 nag">
Okres sprawozdawczy:
			</div>
			<div class="col-md-2">
<input name='okres' value='2017-06' class='form-control' />
			</div>
		</div>
<?php
	echo '<h1>Wybierz wydruki, a potem u¿yj opcji "Enter=wykonaj Wydruki"</h1>'."\n";
	echo "<hr>\n";

	foreach($wydruki as $key => $value)
	{
		echo "<input checked type='checkbox' name='$key' /> $value<br>\n";
	}
?>
      </div>
   </div>
</div>
<?php
	echo "</td>\n";
	echo "</tr>\n";
	echo "</table>\n\n";

	require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");

	echo '<link href="index.css" rel="stylesheet">';
	echo '<script type="text/javascript" src="index.js"> </script>';

}