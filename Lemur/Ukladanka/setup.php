<?php

require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/dbconnect.php");
require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/saveTablePosition.php");

require ('site.php');
$site = new Site("Uk³adanka");
$site->addButton('Esc', 'Esc=wyj¶cie', '../Menu', '');
