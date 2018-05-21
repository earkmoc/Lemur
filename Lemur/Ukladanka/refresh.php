<?php
require ('ukladanka.php');
$ukladanka = new Ukladanka ();
switch (true) {
	case @$_GET['kierunek']:
	{
		$ukladanka->Move( $_GET ['kierunek'] );
		break;
	}
	case @$_GET['aktywacja']:
	{
		$ukladanka->Aktywuj( $_GET ['aktywacja'] );
		break;
	}
	case @$_GET['akcja']:
	{
		$ukladanka->Akcja( $_GET ['akcja'] );
		break;
	}
}
