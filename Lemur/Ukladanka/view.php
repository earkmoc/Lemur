<?php
$site->addButton ( 'Q', 'Q=clear', '', '$("#tabela").load("refresh.php","akcja=clear")' );
$site->addButton ( 'Up', '', '', '$("#tabela").load("refresh.php","kierunek=up")' );
$site->addButton ( 'Down', '', '', '$("#tabela").load("refresh.php","kierunek=down")' );
$site->addButton ( 'Left', '', '', '$("#tabela").load("refresh.php","kierunek=left")' );
$site->addButton ( 'Right', '', '', '$("#tabela").load("refresh.php","kierunek=right")' );
$site->addButton ( '1', '', '', '$("#tabela").load("refresh.php","aktywacja=1")' );
$site->addButton ( '2', '', '', '$("#tabela").load("refresh.php","aktywacja=2")' );
$site->addButton ( '3', '', '', '$("#tabela").load("refresh.php","aktywacja=3")' );
$site->addButton ( '4', '', '', '$("#tabela").load("refresh.php","aktywacja=4")' );
$site->addButton ( '5', '', '', '$("#tabela").load("refresh.php","aktywacja=5")' );
$site->addButton ( '6', '', '', '$("#tabela").load("refresh.php","aktywacja=6")' );
$site->addButton ( '7', '', '', '$("#tabela").load("refresh.php","aktywacja=7")' );
$site->addButton ( '8', '', '', '$("#tabela").load("refresh.php","aktywacja=8")' );
$site->addButton ( '9', '', '', '$("#tabela").load("refresh.php","aktywacja=9")' );
$site->addButton ( '0', '', '', '$("#tabela").load("refresh.php","aktywacja=10")' );
$site->header ();
?>

<div class="container-fluid bs-docs-container">

<table>
<tr>
<td>
	<div id="tabela" class="panel panel-default" style="margin-left:40px; margin-top:5px; width:830px; height:665px">
<?php
	$_GET ['kierunek'] = 'tu';
	require ('refresh.php');
?>
	</div>
</div>

<td style="padding:0px">
<img src="prawo2.png" />
</td>

<td style="text-align:center">
Przeprowad¼ czerwony klocek do wyj¶cia.<br>
<img style="opacity:0.3" src="red.png" />
Wskazuj klocki myszk± i przesuwaj je klawiszami strza³ek
</td>

</td>
</tr>
</table>

<?php

$site->footer();