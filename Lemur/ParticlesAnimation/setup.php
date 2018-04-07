<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

// ----------------------------------------------
// Parametry widoku

$title='Particles Animation';

//----------------------------------------------

$buttons=array();
$buttons[]=array('klawisz'=>'Esc','nazwa'=>'Esc=Anuluj','akcja'=>"../Menu");

//----------------------------------------------
